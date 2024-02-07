// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jinahfoods/app/modules/restaurants/views/restaurant_items_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'branch_caution.dart';
import '../util/constant.dart';
import '../util/style.dart';

Widget branchCardGrid(branch, index, context) {
  return InkWell(
    onTap: () {
      
      print('index from click ' + index.toString());

      Get.to(() => RestaurantItemView(
            fromRestaurantList: true,
            restaurantId: branch[index].id!, 
            restaurantName: branch[index].name!,
          ));
      print('branch ---->' + branch[index].id!.toString());
      print('index ----->' + index.toString());
    },
    child: Container(
      height: 150.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          border: Border.all(color: AppColor.itembg)),
      child: Column(
        children: [
          SizedBox(
            height: 110.h,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r)),
              child: CachedNetworkImage(
                imageUrl:
                    branch[index].cover!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      // colorFilter: ColorFilter.mode(
                      //     Colors.red, BlendMode.colorBurn),
                    ),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  // ignore: sort_child_properties_last
                  child:
                      Container(height: 86.h, width: 154.w, color: Colors.grey),
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[400]!,
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: 8.w, right: 8.w, top: 6.h, bottom: 3.h),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Text(
                              branch[index].name!,
                              style: fontRegularBold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   height: 8.h,
                      // ),
                      // Text(
                      //   "Delivers in 30 minutes",
                      //   style: TextStyle(
                      //       fontFamily: 'Rubik',
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 10.sp,
                      //       height: 1.4.h,
                      //       color: AppColor.gray),
                      //   maxLines: 2,
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.itembg,
                              offset: const Offset(
                                0.0,
                                4.0,
                              ),
                              blurRadius: 5.r,
                              spreadRadius: 1.r,
                            ),
                            BoxShadow(
                              color: AppColor.itembg,
                              offset: const Offset(
                                1.0,
                                0.0,
                              ),
                              blurRadius: 1.r,
                              spreadRadius: 0.r,
                            ), //BoxShadow
                            //BoxShadow
                          ],
                        ),
                        // child: Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     SizedBox(
                        //       width: 12.w,
                        //       height: 12.h,
                        //       child: SvgPicture.asset(
                        //         Images.iconCart,
                        //         fit: BoxFit.cover,
                        //       ),
                        //     ),
                        //     SizedBox(
                        //       width: 2.w,
                        //     ),
                        //     Text(
                        //       "ADD".tr,
                        //       style: fontRegularBoldwithColor,
                        //     )
                        //   ],
                        // ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
