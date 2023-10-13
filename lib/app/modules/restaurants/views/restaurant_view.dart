// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foodking/app/modules/search/views/search_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/constant.dart';
import '../controllers/restaurant_controller.dart';
import '../widget/restaurant_vew_shimmer.dart';
import '../widget/branches_section.dart';

class RestaurantView extends StatefulWidget {
  const RestaurantView({super.key});

  @override
  State<RestaurantView> createState() => _RestaurantViewState();
}

class _RestaurantViewState extends State<RestaurantView> {
  @override
  void initState() {
    Get.put(RestaurantController());
    super.initState();
  }

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<RestaurantController>(
        builder: (restaurantController) => Stack(
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
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 16.h),
                      child: Row(
                        children: [],
                      ),
                    )
                  ],
                  centerTitle: false,
                  elevation: 0,
                  backgroundColor: Colors.white,
                ),
                body: GetBuilder<RestaurantController>(
                  builder: (restaurantController) => Stack(
                    children: [
                      Padding(
                        padding: restaurantController.restaurantDataList.isEmpty ||
                                box.read('isLogedIn') == false
                            ? EdgeInsets.only(left: 16.h, right: 16.h)
                            : EdgeInsets.only(
                                left: 16.h, right: 16.h, bottom: 100.h),
                        child: Column(
                          children: [
                            SizedBox(
                              child: restaurantController.restaurantLoader
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
                                  restaurantController.getRestaurantList();
                                },
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  child: Stack(
                                    children: [ 
                                      Column(
                                        children: [
                                          restaurantController
                                                      .restaurantLoader ||
                                                  restaurantController
                                                      .restaurantDataList.isEmpty
                                              ? restaurantShimmer()
                                              : BranchesSection(),
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
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
