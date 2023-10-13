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
import '../../../../widget/no_items_available.dart';

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
      print('from view ' + restaurantController.restaurantDataList[widget.restaurantId!].id!.toString());
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
                            ? menuVegNonVegSection(context, box,
                                widget.fromRestaurantList!, widget.restaurantId!)
                            : Column(
                                children: [menuItemSectionGridShimmer()],
                              )
                      ],
                    ),
                  ),
                  widget.fromRestaurantList!
                      ? const BottomCartWidget()
                      : const SizedBox()
                ],
              ),
      ),
    );
  }
}

Widget menuVegNonVegSection(
    context, box, bool fromRestaurantList, int restaurantId) {
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
                  SizedBox(
                    height: 34.h,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              restaurantController
                                  .restaurantDataList[restaurantId].name!,
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
  return GetBuilder<RestaurantController>(
    builder: (restaurantController) =>
        !restaurantController.restaurantItemLoader
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    StaggeredGridView.countBuilder(
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      itemCount:
                          restaurantController.restaurantItemsDataList.length,
                      crossAxisCount: 2,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) =>
                          const StaggeredTile.fit(1),
                      itemBuilder: (BuildContext context, int index) {
                        return itemCardGrid(
                            restaurantController.restaurantItemsDataList,
                            index,
                            context);
                      },
                    ),
                    SizedBox(
                      height: 40.h,
                    )
                  ],
                ),
              )
            : menuItemSectionGridShimmer(),
  );
}
