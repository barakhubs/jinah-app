// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'package:get/get.dart';
import '../../../../util/api-list.dart';
import '../../../data/api/server.dart';
import '../../../data/model/response/restaurant_with_items_modal.dart';
import '../../../data/model/response/branch_model.dart';
import '../../../data/model/response/item_model.dart';
import '../../../data/repository/category_repo.dart';
import '../../../data/repository/restaurant_repo.dart';
import '../../../data/repository/item_repo.dart';

class RestaurantController extends GetxController {
  List<BranchData> restaurantDataList = <BranchData>[];
  List<ItemData> restaurantItemsDataList = <ItemData>[];
  List<ItemData> categoryItemVgDataList = <ItemData>[];

  int currentIndex = 0;
  int selectedCategoryIndex = 0;
  int vegNonVegActive = 0;
  int vegNonVegActiveList = 0;
  bool fromRestaurantList = true;
  String? selectedBranch;
  bool restaurantLoader = false;
  bool itemLoader = false;
  bool restaurantItemLoader = false;
  bool isRestaurantItemEmpty = false;

  static Server server = Server();
  static RestaurantItemModel restaurantItemModel = RestaurantItemModel();
  static BranchModel branchModel = BranchModel();
  @override
  void onInit() {
    getRestaurantList();
    super.onInit();
  }

  void setCategoryIndex(int index) {
    selectedCategoryIndex = index;
    update();
  }

  getRestaurantList() async {
    restaurantLoader = true;
    restaurantDataList.clear();
    update();
    var restaurantData = await RestaurantRepo.getRestaurants();
    if (restaurantData != null) {
      restaurantDataList = restaurantData.data ?? [];
      restaurantLoader = false;
      update();
    } else {
      restaurantLoader = false;
      update();
    }
  }

  // getRestaurantName(id) async {
  //   restaurantLoader = true;
  //   restaurantDataList.clear();
  //   String url = 'https://admin.jinahonestop.com/api/frontend/item-restaurant';

  //   await server.getRequestWithoutToken(endPoint: url + id.toString()).then((response) {
  //     if (response != null && response.statusCode == 200) {
  //       final jsonResponse = json.decode(response.body);
  //       branchModel = BranchModel.fromJson(jsonResponse);
  //       restaurantDataList = branchModel.data!;

  //       restaurantLoader = false;
  //       update();

  //       return restaurantDataList;
  //     } else {
  //       restaurantLoader = false;
  //       update();
  //     }
  //   });
  // }

  getItemDataList() async {
    itemLoader = true;
    update();
    var itemData = await ItemRepo.getItem();
    restaurantItemsDataList = <ItemData>[];
    if (itemData != null) {
      restaurantItemsDataList = itemData.data!;
      itemLoader = false;
      update();
    } else {
      update();
    }
  }

  // getRestaurantItemDataList(int id) async {
  //   restaurantItemLoader = true;
  //   restaurantItemsDataList.clear();
  //   print('from controller ---->' + id.toString());
  //   String url =
  //       'https://admin.jinahonestop.com/api/frontend/item-restaurant/show/';

  //   await server
  //       .getRequestWithoutToken(endPoint: url + id.toString())
  //       .then((response) {
  //     if (response != null && response.statusCode == 200) {
  //       restaurantItemLoader = false;

  //       final jsonResponse = json.decode(response.body);
  //       restaurantItemModel = RestaurantItemModel.fromJson(jsonResponse);
  //       restaurantItemsDataList = restaurantItemModel.data!.items!;
  //       // Check if items list is empty
  //       if (restaurantItemsDataList.isEmpty) {
  //         isRestaurantItemEmpty = true;
  //       } else {
  //         isRestaurantItemEmpty = false;
  //       }
  //       update();

  //       return restaurantItemsDataList;
  //     } else {
  //       restaurantItemLoader = false;
  //       isRestaurantItemEmpty = true;
  //       update();
  //     }
  //   });
  // }

  getRestaurantItemDataList(int id) async {
  restaurantItemLoader = true;
  restaurantItemsDataList.clear();
  print('from controller ---->' + id.toString());
  String url =
      'https://admin.jinahonestop.com/api/frontend/item-restaurant/show/';

  await server
      .getRequestWithoutToken(endPoint: url + id.toString())
      .then((response) {
    if (response != null && response.statusCode == 200) {
      restaurantItemLoader = false;

      final jsonResponse = json.decode(response.body);
      restaurantItemModel = RestaurantItemModel.fromJson(jsonResponse);
      restaurantItemsDataList = restaurantItemModel.data!.items!;
      print('restaurantItemsDataList: $restaurantItemsDataList'); // Add this line to check the value of the restaurantItemsDataList variable
      // Check if items list is empty
      if (restaurantItemsDataList.isEmpty) {
        isRestaurantItemEmpty = true;
      } else {
        isRestaurantItemEmpty = false;
      }
      update();

      return restaurantItemsDataList;
    } else {
      restaurantItemLoader = false;
      isRestaurantItemEmpty = true;
      update();
    }
  });
}
}
