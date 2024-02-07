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

Widget horizontalScrollCard(branch) {
  return Container(
    height: 200.h, // Change this value based on your design
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: branch.length,
      itemBuilder: (BuildContext context, int index) => _buildBranchCard(branch, index, context),
    ),
  );
}

Widget _buildBranchCard(branch, index, context) {
  return InkWell(
    onTap: () {
      Get.to(() => RestaurantItemView(
            fromRestaurantList: true,
            restaurantId: branch[index].id!, 
            restaurantName: branch[index].name!, 
          ));
      // print('branch ' + branch[index].id.toString());
      print('id from click ----->' + branch[index].id!.toString());
    },
    child: Container(
      width: MediaQuery.of(context).size.width - 70.w, // Width of the card
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        border: Border.all(color: AppColor.itembg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 160.h,
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
                        crossAxisAlignment: CrossAxisAlignment.center,
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
