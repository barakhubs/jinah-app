// ignore_for_file: sort_child_properties_last, deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jinahfoods/app/modules/order/controllers/order_controller.dart';
import 'package:jinahfoods/app/modules/payment/views/payment_view.dart';
import 'package:jinahfoods/util/api-list.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../../offer/controllers/offer_controller.dart';
import '../../search/views/search_view.dart';
import '../controllers/home_controller.dart';
import '../widget/active_order_status.dart';
import '../widget/featured_item_section.dart';
import '../widget/home_menu_section.dart';
import '../widget/home_offer_section.dart';
import '../widget/home_vew_shimmer.dart';
import '../widget/popular_item_section.dart';
import '../widget/popular_branch_section.dart';
import '../widget/latest_branch_section.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform; // Import dart:io

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final box = GetStorage();
  List<String> imgList = [];
  bool isLoggedIn = false;

  @override
  void initState() {
    Get.find<HomeController>().getBranchList();
    Get.find<HomeController>().getCategoryList();
    Get.find<HomeController>().getPopularItemDataList();
    Get.find<HomeController>().getFeaturedItemDataList();
    Get.find<HomeController>().getPopularBranchDataList();
    Get.find<HomeController>().getLatestBranchDataList();
    Get.find<OfferController>().getOfferList();
    isLoggedIn = box.read('isLogedIn') ??
        false; // Correctly update isLoggedIn based on stored value
    fetchBannerData();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForAcceptedOrdersAndPromptPayment();
    });

  }

  void checkForAcceptedOrdersAndPromptPayment() {
    final orderController = Get.find<OrderController>();
    final acceptedOrderIndex = orderController.ordersData
        .indexWhere((order) => order.status == 4 && order.paymentStatus == 10);

    if (acceptedOrderIndex != -1) {
      // Assuming your order objects have an orderId field
      final int? orderId = orderController.ordersData[acceptedOrderIndex].id;
      showOrderAcceptedAndPromptPaymentDialog(context, orderId);
    }
  }

  void showOrderAcceptedAndPromptPaymentDialog(
      BuildContext context, int? orderId) {
    // Check if we should show the dialog
    var lastShown = box.read('lastDialogShownTime');
    var currentTime = DateTime.now();

    if (lastShown != null) {
      var lastShownTime = DateTime.parse(lastShown);
      var difference = currentTime.difference(lastShownTime);

      // If less than 10 minutes have passed, do not show the dialog
      if (difference.inMinutes < 5) {
        return;
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order Accepted"),
          content: Text(
              "Your order has been accepted. Tap on 'Pay Now' to pay before your order is prepared",style: TextStyle(
                fontSize: 16, 
              ),),
          actions: <Widget>[
            TextButton(
              child: Text("Later", style: TextStyle(
                fontSize: 16, 
              ),),
              onPressed: () {
                Navigator.of(context).pop();
                // Store the current timestamp when clicking "Later"
                box.write('lastDialogShownTime', currentTime.toIso8601String());
              },
            ),
            TextButton(
              child: Text("Pay Now", style: TextStyle(
                fontSize: 16, // Increase font size for the 'Pay Now' button
                color: Colors.orange, // Text color
              ),),
              onPressed: () {
                Get.to(() => PaymentView(orderId: orderId));
              },
            ),
          ],
        );
      },
    );
  }

  void delayDialog(BuildContext context, int? orderId) {
    Future.delayed(Duration(minutes: 10), () {
      // Check if it's appropriate to show the dialog again
      // For example, check if the user is still in the relevant screen or if the order status has changed
      // This is a placeholder for whatever condition makes sense in your app
      if (shouldShowDialogAgain()) {
        // Show the dialog again if the condition is met
        showOrderAcceptedAndPromptPaymentDialog(context, orderId);
      }
    });
  }

  bool shouldShowDialogAgain() {
    // Implement your logic here to determine if the dialog should be shown again
    // For example, check if the user has not yet proceeded with payment or if they are in a specific part of the app
    return true; // Placeholder return value
  }

// Method to fetch banner data
  Future<void> fetchBannerData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://admin.jinahonestop.com/api/frontend/slider?paginate=0&order_column=id&order_type=desc&status=5'),
        headers: {
          'X-Api-Key': '00TdJKnn5Ck8kWHNd/BuZkVvZD8JPsNSSeMVdSveZ+0=',
          // Add any other headers here
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> fetchedData = jsonDecode(response.body)['data'];
        setState(() {
          imgList.clear();
          imgList.addAll(
            fetchedData.map((item) => item['image']).toList().cast<String>(),
          );
        });
      } else {
        print('Failed to load banners, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leadingWidth: 100.w,
              leading: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: Image.asset(
                  Images.logo,
                  width: 85.w,
                ),
              ),
              centerTitle: false,
              elevation: 0,
              backgroundColor: Colors.white,
            ),
            body: GetBuilder<HomeController>(
              builder: (homeController) => Stack(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 16.h, right: 16.h, bottom: 5.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          child: homeController.loader
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[200]!,
                                  highlightColor: Colors.grey[300]!,
                                  child: Container(
                                    height: 52.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.r),
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  child: TextField(
                                    showCursor: true,
                                    readOnly: true,
                                    onTap: () {
                                      Get.to(() => const SearchView());
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 0.w, vertical: 0.h),
                                      hintText: "SEARCH".tr,
                                      hintStyle:
                                          const TextStyle(color: AppColor.gray),
                                      prefixIcon: SizedBox(
                                        child: Padding(
                                          padding: EdgeInsets.all(12.r),
                                          child: SvgPicture.asset(
                                            Images.iconSearch,
                                            fit: BoxFit.cover,
                                            color: AppColor.gray,
                                            height: 16.h,
                                            width: 16.w,
                                          ),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: AppColor.itembg,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.r)),
                                        borderSide: BorderSide(
                                            color: AppColor.itembg, width: 1.w),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12.r)),
                                        borderSide: BorderSide(
                                            width: 0.w, color: AppColor.itembg),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(
                          height: 14.h,
                        ),
                        Expanded(
                          child: RefreshIndicator(
                            color: AppColor.primaryColor,
                            onRefresh: () async {
                              homeController.getCategoryList();
                              homeController.getFeaturedItemDataList();
                              homeController.getPopularItemDataList();
                              homeController.getLatestBranchDataList();
                              homeController.getPopularBranchDataList();
                              // if (box.read('isLogedIn') == true) {
                              //   homeController.getActiveOrderList();
                              // }
                            },
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              primary: false,
                              scrollDirection: Axis.vertical,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom:
                                                36.0), // This will add the margin around the CarouselSlider
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            aspectRatio: 2.0,
                                            enlargeCenterPage: true,
                                            scrollDirection: Axis.horizontal,
                                            autoPlay: true,
                                            viewportFraction:
                                                1, // Adjust to your needs, this adds spacing between the carousel items
                                            enlargeStrategy:
                                                CenterPageEnlargeStrategy.scale,
                                            onPageChanged: (index, reason) {
                                              // Handle page change if needed
                                            },
                                          ),
                                          items: imgList
                                              .map(
                                                (item) => Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    image: DecorationImage(
                                                      image: NetworkImage(item),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                        ),
                                      ),

                                      //Menu Section
                                      homeController.menuLoader ||
                                              homeController
                                                  .categoryDataList.isEmpty
                                          ? menuSectionShimmer()
                                          : homeMenuSection(),

                                      homeController.popularLoader ||
                                              homeController
                                                  .popularItemDataList.isEmpty
                                          ? popularItemSectionShimmer()
                                          : popularItemSection(),

                                      homeController.latestBranchLoader ||
                                              homeController
                                                  .latestBranchDataList.isEmpty
                                          ? latestBranchSectionShimmer()
                                          : latestBranchSection(),

                                      Get.find<OfferController>()
                                                  .offerDataList
                                                  .isEmpty ||
                                              Get.find<OfferController>().lodear
                                          ? const SizedBox.shrink()
                                          : homeOfferSection(),

                                      homeController.popularBranchLoader ||
                                              homeController
                                                  .popularBranchDataList.isEmpty
                                          ? popularBranchSectionShimmer()
                                          : popularBranchSection()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // if (homeController.activeOrderData.isNotEmpty &&
                  //     box.read('isLogedIn') == true)
                  //   const ActiveOrderStatus()
                ],
              ),
            ),
            // Omit the FloatingActionButton from here
          ),
          Positioned(
            right: 20, // Adjust the positioning as needed
            bottom: 20, // Adjust the positioning as needed
            child: isLoggedIn
                ? FloatingActionButton.extended(
                    onPressed: () async {
                      const whatsappNumber =
                          "256776116630"; // Exclude the '+' from the country code
                      // const message =
                      //     "Hello, I'd like to chat on WhatsApp!"; // URL encode this if necessary

                      // Corrected Platform-specific URL construction
                      final url = Uri.parse("https://wa.me/$whatsappNumber");

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Could not launch WhatsApp. Please try again later.'),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    },

                    icon: Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 25,
                    ),
                    label: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.0), // Adds more space around the text
                      child: Text(
                        "Chat",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    backgroundColor: Color(0xFF04B000), // WhatsApp Green Color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  )
                : SizedBox(),
          ),
          Get.find<OfferController>().offerItemlodear
              ? Positioned(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white60,
                    child: const Center(
                      child: LoaderCircle(),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
