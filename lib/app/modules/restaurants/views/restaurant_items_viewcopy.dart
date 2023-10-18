// ignore_for_file: must_be_immutable, sort_child_properties_last, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/bottom_cart_widget.dart';
import '../../../../widget/item_card_grid.dart';
import '../../../../widget/item_card_list.dart';
import '../../../../widget/no_items_available.dart';
import '../../home/widget/home_vew_shimmer.dart';
import '../../search/views/search_view.dart';
import '../controllers/restaurant_controller.dart';
import '../widget/restaurant_item_vew_shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class RestaurantItemView extends StatefulWidget {
  bool? fromRestaurantList;
  int? restaurantId;

  RestaurantItemView({
    Key? key,
    this.fromRestaurantList,
    this.restaurantId,
  }) : super(key: key);

  @override
  State<RestaurantItemView> createState() => _RestaurantItemViewState();
}

class _RestaurantItemViewState extends State<RestaurantItemView> {
  final box = GetStorage();
  int? value;
  bool? isSelected;
  RestaurantController restaurantController = Get.put(RestaurantController());

  @override
  void initState() {
    Get.put(RestaurantController());
    if (box.read('viewValue') == null) {
      box.write('viewValue', 0);
    }
    if (restaurantController.restaurantDataList.isNotEmpty) {
      restaurantController.getRestaurantItemDataList(
          restaurantController.restaurantDataList[widget.restaurantId!].id!);
      restaurantController.fromRestaurantList = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(
      builder: (restaurantController) => Scaffold(
        backgroundColor: Colors.white,
        appBar: widget.fromRestaurantList!
            ? AppBar(
                leadingWidth: 150.w,

                leading: Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        Images.back,
                        height: 25.h,
                        width: 25.w,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Image.asset(
                      Images.logo,
                      width: 85.w,
                      // height: 16.h,
                    ),
                  ],
                ),
                // title: Image.asset(
                //   Images.logo,
                //   width: 85.w,
                //   height: 16.h,
                // ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, right: 16),
                    child: SizedBox(
                      height: 25.h,
                      width: 25.w,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => const SearchView());
                        },
                        child: SvgPicture.asset(
                          Images.iconSearch,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],

                elevation: 0,
                backgroundColor: Colors.white,
              )
            : AppBar(
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
                    padding: const EdgeInsets.only(top: 8, right: 16),
                    child: SizedBox(
                      height: 25.h,
                      width: 25.w,
                      child: InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          Get.to(() => const SearchView());
                        },
                        child: SvgPicture.asset(
                          Images.iconSearch,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
                centerTitle: false,
                elevation: 0,
                backgroundColor: Colors.white,
              ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  restaurantController.restaurantDataList.isNotEmpty
                      ? menuSection(widget.fromRestaurantList!, widget.restaurantId!)
                      : menuSectionShimmer(),
                  restaurantController.restaurantDataList.isNotEmpty
                      ? menuVegNonVegSection(
                          context, box, widget.fromRestaurantList!, widget.restaurantId!)
                      : Column(
                          children: [menuItemSectionGridShimmer()],
                        )
                ],
              ),
            ),
            widget.fromRestaurantList! ? const BottomCartWidget() : const SizedBox()
          ],
        ),
      ),
    );
  }
}

Widget menuSection(bool fromRestaurantList, int restaurantId) {
  return GetBuilder<RestaurantController>(
    builder: (restaurantController) => Column(
      children: [
        SizedBox(
          height: 12.h,
        ),
        SizedBox(
          width: double.infinity,
          height: 80.h,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: restaurantController.restaurantDataList.length,
              itemBuilder: (BuildContext context, index) {
                return InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    restaurantController.getRestaurantItemDataList(
                        restaurantController.restaurantDataList[index].id!);
                    restaurantController.setCategoryIndex(index);
                    restaurantController.fromRestaurantList = false;
                    restaurantController.currentIndex = index;
                    (context as Element).markNeedsBuild();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 12.w),
                    child: SizedBox(
                      width: 90.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //here
                          SizedBox(
                            height: 30.h, 
                            width: 40.w,
                            child: CachedNetworkImage(
                              imageUrl: 'https://admin.jinahonestop.com' + restaurantController
                                  .restaurantDataList[index].cover!
                                  .toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Shimmer.fromColors(
                                child: Container(
                                    height: 60.h,
                                    width: 60.w,
                                    color: Colors.grey),
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[400]!,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  restaurantController.fromRestaurantList
                                      ? Text(
                                          restaurantController
                                              .restaurantDataList[index].name
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                            color: restaurantId == index
                                                ? AppColor.primaryColor
                                                : Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        )
                                      : Text(
                                          restaurantController
                                              .restaurantDataList[index].name
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Rubik',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 11,
                                            color:
                                                restaurantController.currentIndex ==
                                                        index
                                                    ? AppColor.primaryColor
                                                    : Colors.black,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                  restaurantController.fromRestaurantList
                                      ? Container(
                                          height: 4.h,
                                          width: 80.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32.r),
                                            color: restaurantId == index
                                                ? AppColor.primaryColor
                                                : Colors.white,
                                          ),
                                        )
                                      : Container(
                                          height: 4.h,
                                          width: 90.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(32.r),
                                            color: restaurantController
                                                        .selectedCategoryIndex ==
                                                    index
                                                ? AppColor.primaryColor
                                                : Colors.white,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 10.h,
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        Container(
          height: 2,
          color: AppColor.bgColor,
        )
      ],
    ),
  );
}

Widget menuVegNonVegSection(context, box, bool fromRestaurantList, int restaurantId) {
  return GetBuilder<RestaurantController>(
    builder: (restaurantController) => Expanded(
      child: RefreshIndicator(
        color: AppColor.primaryColor,
        onRefresh: () async {
          restaurantController.getRestaurantItemDataList(restaurantController
              .restaurantDataList[restaurantController.currentIndex].id!);
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 24.h, bottom: 24.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            restaurantController.getRestaurantItemDataList(
                                restaurantController
                                    .restaurantDataList[
                                        restaurantController.currentIndex]
                                    .id!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.r),
                              color: restaurantController.vegNonVegActiveList == 10
                                  ? Colors.white
                                  : AppColor.itembg,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.itembg,
                                  offset: const Offset(
                                    0.0,
                                    0.0,
                                  ),
                                  blurRadius: 10.r,
                                  spreadRadius: 2.r,
                                ), //BoxShadow
                                //BoxShadow
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      Images.nonVeg,
                                      height: 20.h,
                                      width: 30.w,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      "NON_VEG".tr,
                                      style: fontRegularBold,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    restaurantController.vegNonVegActiveList == 10
                                        ? SvgPicture.asset(
                                            Images.IconClose,
                                            width: 20.w,
                                            height: 20.h,
                                            fit: BoxFit.contain,
                                          )
                                        : const SizedBox(),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 24.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            restaurantController.getRestaurantItemDataList(
                                restaurantController
                                    .restaurantDataList[
                                        restaurantController.currentIndex]
                                    .id!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.r),
                              color: restaurantController.vegNonVegActiveList == 5
                                  ? Colors.white
                                  : AppColor.itembg,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.itembg,
                                  offset: const Offset(
                                    0.0,
                                    0.0,
                                  ),
                                  blurRadius: 10.r,
                                  spreadRadius: 2.r,
                                ), //BoxShadow
                                //BoxShadow
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Images.veg,
                                      height: 20.h,
                                      width: 30.w,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      "VEG".tr,
                                      style: fontRegularBold,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    restaurantController.vegNonVegActiveList == 5
                                        ? SvgPicture.asset(
                                            Images.IconClose,
                                            width: 20.w,
                                            height: 20.h,
                                            fit: BoxFit.contain,
                                          )
                                        : const SizedBox(),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 34.h,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              restaurantController.fromRestaurantList
                                  ? restaurantController
                                      .restaurantDataList[restaurantId].name!
                                  : restaurantController
                                      .restaurantDataList[
                                          restaurantController.selectedCategoryIndex]
                                      .name!,
                              style: fontBoldWithColor,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
  
                        ]),
                  ),
                  !restaurantController.isRestaurantItemEmpty
                      ? Column(
                          children: [
                            // if (box.read('viewValue') == 1)
                              menuItemSectionGrid(),
                          ],
                        )
                      : const NoItemsAvailable()
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget menuItemSectionGrid() {
  // return GetBuilder<RestaurantController>(
  //   builder: (restaurantController) => !restaurantController.restaurantItemLoader
  //       ? Padding(
  //           padding: const EdgeInsets.symmetric(vertical: 16),
  //           child: Column(
  //             children: [
                // StaggeredGridView.countBuilder(
                //       crossAxisSpacing: 10.0,
                //       mainAxisSpacing: 10.0,
                //       itemCount: restaurantController.restaurantItemsDataList.length > 4
                //           ? 4
                //           : restaurantController.restaurantItemsDataList.length,
                //       crossAxisCount: 2,
                //       physics: const NeverScrollableScrollPhysics(),
                //       shrinkWrap: true,
                //       staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                //       itemBuilder: (BuildContext context, int index) {
                //   return itemCardGrid(
                //       restaurantController.restaurantItemsDataList, index, context);
                // },
  //               ),
  //               SizedBox(
  //                 height: 40.h,
  //               )
  //             ],
  //           ),
  //         )
  //       : menuItemSectionGridShimmer(),
  // );

  return GetBuilder<RestaurantController>(
    builder: (restaurantController) => Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 13.h),
          child: Row(
            children: [
              SizedBox(
                height: 24.h,
                child: Text(
                  "Recommended Dishes",
                  style: fontBold,
                ),
              ),
            ],
          ),
        ),
        // ListView.builder(
        //     primary: false,
        //     shrinkWrap: true,
        //     itemCount: homeController.popularItemDataList.length > 4
        //         ? 4
        //         : homeController.popularItemDataList.length,
        //     itemBuilder: (BuildContext context, index) {
        //       return itemCardGrid(
        //           homeController.popularItemDataList, index, context);
        //     }),
            StaggeredGridView.countBuilder(
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      itemCount: restaurantController.restaurantItemsDataList.length > 4
                          ? 4
                          : restaurantController.restaurantItemsDataList.length,
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
                      itemBuilder: (BuildContext context, int index) {
                  return itemCardGrid(
                      restaurantController.restaurantItemsDataList, index, context);
                },
        )
      ],
    ),
  );
}
