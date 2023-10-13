import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../../util/style.dart';
import '../../../../widget/item_card_grid.dart';
import '../controllers/restaurant_controller.dart';

Widget restaurantItemSection() {
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
                  "All Restaurants",
                  style: fontBold,
                ),
              ),
            ],
          ),
        ),
        // ListView.builder(
        //     primary: false,
        //     shrinkWrap: true,
        //     itemCount: restaurantController.popularItemDataList.length > 4
        //         ? 4
        //         : restaurantController.popularItemDataList.length,
        //     itemBuilder: (BuildContext context, index) {
        //       return itemCardGrid(
        //           restaurantController.popularItemDataList, index, context);
        //     }),
        StaggeredGridView.countBuilder(
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          itemCount: restaurantController.restaurantDataList.length > 4
              ? 4
              : restaurantController.restaurantDataList.length,
          crossAxisCount: 2,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          staggeredTileBuilder: (int index) => const StaggeredTile.fit(1),
          itemBuilder: (BuildContext context, int index) {
            return itemCardGrid(
                restaurantController.restaurantDataList, index, context);
          },
        )
      ],
    ),
  );
}
