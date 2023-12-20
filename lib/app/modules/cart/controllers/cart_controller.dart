// ignore_for_file: avoid_function_literals_in_foreach_calls, unnecessary_overrides

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:jinahfoods/util/constant.dart';
import '../../../../util/api-list.dart';
import '../../../../widget/custom_snackbar.dart';
import '../../../data/api/server.dart';
import '../../../data/model/body/place_order_body.dart';
import '../../../data/model/response/add_cart_model.dart';
import '../../../data/model/response/coupon_check_model.dart';
import '../../../data/model/response/item_model.dart';
import '../../../data/repository/coupon_repo.dart';
import '../../address/controllers/address_controller.dart';
import '../../home/controllers/home_controller.dart';

class CartController extends GetxController {
  // CouponController couponController = Get.put(CouponController());

  bool itemLoader = true;
  List<dynamic> selectedAddOns = [];
  List<int> selectedAddOnsIndex = [];
  List<int> selectedExtraIndex = [];
  List<int> selectedVariationIndex = [];
  List<dynamic> selectedItem = [];
  int selectedSingleVariationIndex = 0;
  List<dynamic>? selectedDish = [];

  int itemQuantity = 1;
  int addOnsQuantity = 1;
  double totalCartValue = 0;
  double deliveryCharge = 0.0;
  double total = 0;
  int orderTypeIndex = 0;

  double totalQunty = 0;
  double kilometer = 0;
  double roundedKilometer = 0.0;

  List<MainItem> cartItemList = [];
  List<AddonsItem> addonList = [];
  List<Cart> cart = [];

  //coupon code
  bool couponAplied = false;
  double couponDiscount = 0.0;
  String couponCode = '';
  int? couponId = 0;
  bool couponLoading = false;
  CouponRepo couponRepo = CouponRepo();
  static Server server = Server();
  CouponCheckModel couponCheckModel = CouponCheckModel();
  CouponCheckData couponCheckData = CouponCheckData();
  final TextEditingController couponTextController = TextEditingController();
  HomeController homeController = Get.put(HomeController());

  @override
  void onInit() {
    super.onInit();
  }

  void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: AppColor.error,
        textColor: Colors.white,
        timeInSecForIosWeb: 1,
        fontSize: 16.0);
  }

  //for main item
  addQuantity() {
    itemQuantity++;
    update();
  }

  removeQuantity() {
    if (itemQuantity > 0) {
      itemQuantity--;
    }
    update();
  }

  //new code
  addItem(
    ItemData mainItem,
    extra,
    variationList,
    totalPrice,
    variationSum,
    extraSum,
    instruction,
  ) {
    // Check if the product already exists in the cart
    final existingItemIndex = cart.indexWhere(
      (item) => item.itemId == mainItem.id,
    );

    if (existingItemIndex != -1) {
      // If the product already exists, increase the quantity and update the total price
      cart[existingItemIndex].quantity =
          cart[existingItemIndex].quantity! + itemQuantity;

      return true;
    } else {
      // If the product does not exist, add a new item to the cart
      if (cart.isEmpty || mainItem.branch_id == cart[0].branchId) {
        cart.add(
          Cart(
            itemId: mainItem.id,
            itemName: mainItem.name,
            itemPrice: mainItem.offer!.isEmpty
                ? mainItem.convertPrice
                : mainItem.offer![0].convertPrice,
            branchId: mainItem.branch_id,
            itemImage: mainItem.cover,
            quantity: itemQuantity,
            discount: couponDiscount,
            instruction: instruction,
            totalPrice: totalPrice,
            itemVariationTotal: variationSum,
            itemExtraTotal: extraSum,
            itemExtras: extra,
            itemVariations: variationList,
          ),
        );
        String branchDeliveryCharge = mainItem.delivery_charge!;
        deliveryCharge = double.parse(branchDeliveryCharge);

        return true;
      } else {
        // Display toast message if the branch is different
        showToast("Items with different branches are not allowed in the cart");
        return false; // Exit the method if different branch is detected
      }
    }

    // selectedExtraIndex.clear();
    // selectedAddOnsIndex.clear();
    // itemQuantity = 1;
    // update();
    // calculateTotal();
    // update();
  }

  //old code
  // addItem(ItemData mainItem, extra, variationList, totalPrice, variationSum,
  //     extraSum, instruction) {
  //   cart.add(Cart(
  //       itemId: mainItem.id,
  //       itemName: mainItem.name,
  //       itemPrice: mainItem.offer!.isEmpty
  //           ? mainItem.convertPrice
  //           : mainItem.offer![0].convertPrice,
  //       branchId: homeController.selectedbranchId,
  //       itemImage: mainItem.cover,
  //       quantity: itemQuantity,
  //       discount: couponDiscount,
  //       instruction: instruction,
  //       totalPrice: mainItem.offer!.isEmpty
  //           ? mainItem.convertPrice! + variationSum + extraSum
  //           : mainItem.offer![0].convertPrice! + variationSum + extraSum,
  //       itemVariationTotal: variationSum,
  //       itemExtraTotal: extraSum,
  //       itemExtras: extra,
  //       itemVariations: variationList));

  //   selectedExtraIndex.clear();
  //   selectedAddOnsIndex.clear();
  //   itemQuantity = 1;
  //   update();
  //   calculateTotal();
  //   update();
  // }

  //new code
  addItemAddons(addonItem) {
    addonItem.forEach((a) {
      final existingItemIndex = cart.indexWhere(
        (item) => item.itemId == a.id,
      );

      if (existingItemIndex != -1) {
        // If the product already exists, increase the quantity and update the total price
        cart[existingItemIndex].quantity =
            cart[existingItemIndex].quantity! + itemQuantity;
      } else {
        cart.add(Cart(
          itemId: a.id,
          itemName: a.name,
          itemPrice: a.price,
          branchId: homeController.selectedbranchId,
          itemImage: a.image,
          quantity: a.quantity,
          discount: couponDiscount,
          totalPrice: a.price + a.itemVariationTotal,
          itemVariationTotal: a.itemVariationTotal,
          itemExtraTotal: a.itemExtraTotal,
          itemExtras: null,
          itemVariations: null,
        ));
      }
    });

    calculateTotal();
    update();
  }

  //old code
  // addItemAddons(addonItem) {
  //   addonItem.forEach((a) {
  //     cart.add(Cart(
  //       itemId: a.id,
  //       itemName: a.name,
  //       itemPrice: a.price,
  //       branchId: homeController.selectedbranchId,
  //       itemImage: a.image,
  //       quantity: a.quantity,
  //       discount: couponDiscount,
  //       totalPrice: a.price + a.itemVariationTotal,
  //       itemVariationTotal: a.itemVariationTotal,
  //       itemExtraTotal: a.itemExtraTotal,
  //       itemExtras: null,
  //       itemVariations: null,
  //     ));
  //   });

  //   calculateTotal();
  //   update();
  // }

  removeItemFromCart(index) {
    cart.removeAt(index);
    update();
  }

  updateQuantityRemove(qty, id, name, price, image, index, extras,
      variationList, itemVariationTotal, itemExtraTotal) {
    if (qty > 0) {
      qty--;
    }
    cart[index] = (Cart(
        itemId: id,
        itemName: name,
        itemPrice: price,
        branchId: homeController.selectedbranchId,
        itemImage: image,
        quantity: qty,
        discount: couponDiscount,
        totalPrice: price + itemVariationTotal + itemExtraTotal,
        itemVariationTotal: itemVariationTotal,
        itemExtraTotal: itemExtraTotal,
        itemExtras: extras,
        itemVariations: variationList));

    calculateTotal();
    update();
  }

  updateQuantityAdd(qty, id, name, price, image, index, extras, variationList,
      itemVariationTotal, itemExtraTotal) {
    qty++;

    cart[index] = (Cart(
        itemId: id,
        itemName: name,
        itemPrice: price,
        branchId: homeController.selectedbranchId,
        itemImage: image,
        quantity: qty,
        discount: couponDiscount,
        totalPrice: price + itemVariationTotal + itemExtraTotal,
        itemVariationTotal: itemVariationTotal,
        itemExtraTotal: itemExtraTotal,
        itemExtras: extras,
        itemVariations: variationList));
    calculateTotal();
    update();
  }

  removeItem(id) {
    cartItemList.removeWhere((item) => item.id == id);
    update();
  }

  // total calculation
  void calculateTotal() {
    totalCartValue = 0.0;
    totalQunty = 0;
    cart.forEach((f) {
      totalCartValue +=
          (f.itemPrice! + f.itemExtraTotal! + f.itemVariationTotal!) *
              f.quantity!;
      totalQunty += f.quantity!;
    });
    if (Get.find<AddressController>().addressDataList.isNotEmpty) {
      total = deliveryCharge + totalCartValue - couponDiscount;
    } else {
      total = totalCartValue - couponDiscount;
    }
  }

  calculateDistance(lat1, lon1, lat2, lon2) {
    deliveryCharge = 0.0;
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    kilometer = 12742 * asin(sqrt(a));
    distanceWiseDeliveryCharge();
    // return kilometer.toStringAsFixed(0);

    // Round off to the nearest tenth
    roundedKilometer = (kilometer * 1).round() / 1;

    // Call the distanceWiseDeliveryCharge function using the rounded value
    distanceWiseDeliveryCharge();
    return roundedKilometer.toString();
  }

  distanceWiseDeliveryCharge() {
    print(roundedKilometer);
    if (roundedKilometer <= 1) {
      deliveryCharge = 1000 + deliveryCharge;
    } else if (roundedKilometer <= 2) {
      deliveryCharge = 2000 +deliveryCharge;
    } else if (roundedKilometer <= 3) {
      deliveryCharge = 3500 + deliveryCharge;
    } else {
      deliveryCharge = (3500 + ((roundedKilometer - 3) * 1000)) + deliveryCharge;
    }

    if (orderTypeIndex == 0) {
      total = deliveryCharge + totalCartValue;
    } else if (orderTypeIndex == 1) {
      total = totalCartValue;
      deliveryCharge = 0.0;
    } else if (orderTypeIndex == 10) {
      total = totalCartValue;
      deliveryCharge = 0.0;
    }
  }

  // calculateDistance(double customerLat, double customerLon) {
  //   double fixedLat = 3.020505748699635;
  //   double fixedLon = 30.91136695179617;

  //   var p = 0.017453292519943295;
  //   var a = 0.5 -
  //       cos((customerLat - fixedLat) * p) / 2 +
  //       cos(fixedLat * p) *
  //           cos(customerLat * p) *
  //           (1 - cos((customerLon - fixedLon) * p)) /
  //           2;

  //   kilometer = 12742 * asin(sqrt(a));
  //   distanceWiseDeliveryCharge();
  //   return kilometer.toStringAsFixed(0);
  // }

  // distanceWiseDeliveryCharge() {
  //   if (kilometer >= 1 && kilometer < 2) {
  //     deliveryCharge = 1000;
  //   } else if (kilometer >= 2 && kilometer < 3) {
  //     deliveryCharge = 2000;
  //   } else if (kilometer >= 3) {
  //     deliveryCharge = 3500;
  //   }

  //   if (orderTypeIndex == 0) {
  //     total = deliveryCharge + totalCartValue;
  //   } else if (orderTypeIndex == 1) {
  //     total = totalCartValue;
  //     deliveryCharge = 0.0;
  //   } else if (orderTypeIndex == 10) {
  //     total = totalCartValue;
  //     deliveryCharge = 0.0;
  //   }
  //   update();
  // }

  Future<CouponCheckModel?> checkCoupon() async {
    couponLoading = true;
    update();
    Map body = {'total': totalCartValue, 'code': couponTextController.text};
    String jsonBody = json.encode(body);
    try {
      server
          .postRequestWithToken(endPoint: APIList.checkCoupon, body: jsonBody)
          .then((response) {
        if (response != null && response.statusCode == 200) {
          couponLoading = false;
          update();
          final jsonResponse = json.decode(response.body);
          couponCheckModel = CouponCheckModel.fromJson(jsonResponse);
          couponCode = couponCheckModel.data!.code!;
          couponId = couponCheckModel.data!.id!;
          couponDiscount = couponCheckModel.data!.convertDiscount!;
          couponAplied = true;
          couponLoading = false;
          calculateTotal();
          update();
          Get.back();
          return couponCheckModel;
        } else {
          couponLoading = false;
          update();
          final jsonResponse = json.decode(response.body);
          String errorMessage = jsonResponse['message'].toString();
          customSnackbar("ERROR".tr, errorMessage, Colors.red);
          return null;
        }
      });
      return couponCheckModel;
    } catch (e) {
      couponLoading = false;
      return customSnackbar("ERROR".tr, "SOMETHING_WRONG".tr, Colors.red);
    }
  }

  removeCoupon() {
    couponTextController.clear();
    couponAplied = false;
    couponDiscount = 0.0;
    couponCode = '';
    couponId = 0;
    update();
    calculateTotal();
    update();
  }
}
