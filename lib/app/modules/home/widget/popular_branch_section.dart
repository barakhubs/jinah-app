import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:jinahfoods/widget/horizontal_scroll_branch_card.dart';
import 'package:get/get.dart';

import '../../../../util/style.dart';
import '../../../../widget/branch_card_grid.dart';
import '../controllers/home_controller.dart';

Widget popularBranchSection() {
  return GetBuilder<HomeController>(
    builder: (homeController) => Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 24.h, bottom: 13.h),
          child: Row(
            children: [
              SizedBox(
                height: 24.h, 
                child: Text(
                  "Most Popular Restaurants",
                  style: fontBold,
                ),
              ),
            ],
          ), 
        ),
        horizontalScrollCard(homeController.popularBranchDataList)
      ],
    ),
  );
}
