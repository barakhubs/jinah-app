// ignore_for_file: sort_child_properties_last, deprecated_member_use
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final box = GetStorage();

  // final List<String> imgList = [
  //   'https://admin.jinahonestop.com/storage/27/conversions/slider_three-cover-cover.png',
  //   'https://admin.jinahonestop.com/storage/26/conversions/slider_two-cover-cover.png',
  //   // Add more URLs or paths to local images
  // ];

  List<String> imgList = [];

  @override
  void initState() {
    Get.find<HomeController>().getBranchList();
    Get.find<HomeController>().getCategoryList();
    Get.find<HomeController>().getPopularItemDataList();
    Get.find<HomeController>().getFeaturedItemDataList();
    Get.find<HomeController>().getPopularBranchDataList();
    Get.find<HomeController>().getLatestBranchDataList();
    Get.find<OfferController>().getOfferList();
    fetchBannerData(); // Fetching banner data

    // if (box.read('isLogedIn') == true) {
    //   Get.find<HomeController>().getActiveOrderList();
    // }
    super.initState();
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
            fetchedData
                .map((item) => 'https://admin.jinahonestop.com' + item['image'])
                .toList()
                .cast<String>(),
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
      child: GetBuilder<HomeController>(
        builder: (homeController) => Stack(
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
                        padding: EdgeInsets.only(
                            left: 16.h, right: 16.h, bottom: 5.h),
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
                                          borderRadius:
                                              BorderRadius.circular(16.r),
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
                                          hintStyle: const TextStyle(
                                              color: AppColor.gray),
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
                                                color: AppColor.itembg,
                                                width: 1.w),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.r)),
                                            borderSide: BorderSide(
                                                width: 0.w,
                                                color: AppColor.itembg),
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
                                                scrollDirection:
                                                    Axis.horizontal,
                                                autoPlay: true,
                                                viewportFraction:
                                                    1, // Adjust to your needs, this adds spacing between the carousel items
                                                enlargeStrategy:
                                                    CenterPageEnlargeStrategy
                                                        .scale,
                                                onPageChanged: (index, reason) {
                                                  // Handle page change if needed
                                                },
                                              ),
                                              items: imgList
                                                  .map(
                                                    (item) => Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                              item),
                                                          fit: BoxFit.cover,
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
                                                      .popularItemDataList
                                                      .isEmpty
                                              ? popularItemSectionShimmer()
                                              : popularItemSection(),

                                          homeController.latestBranchLoader ||
                                                  homeController
                                                      .latestBranchDataList
                                                      .isEmpty
                                              ? latestBranchSectionShimmer()
                                              : latestBranchSection(),

                                          Get.find<OfferController>()
                                                      .offerDataList
                                                      .isEmpty ||
                                                  Get.find<OfferController>()
                                                      .lodear
                                              ? const SizedBox.shrink()
                                              : homeOfferSection(),

                                          homeController.popularBranchLoader ||
                                                  homeController
                                                      .popularBranchDataList
                                                      .isEmpty
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
                )),
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
      ),
    );
  }
}
