// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../util/constant.dart';

class BranchCaution extends StatefulWidget {
  String? branchName;
  String? branchCaution;
  BranchCaution({super.key, this.branchName, this.branchCaution});

  @override
  State<BranchCaution> createState() => _BranchCautionState();
}

class _BranchCautionState extends State<BranchCaution> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.gray.withOpacity(0.5),
            offset: const Offset(
              0.0,
              6.0,
            ),
            blurRadius: 30.r,
            spreadRadius: 10.r,
          ),
          //BoxShadow
          //BoxShadow
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.branchName!,
                    style: TextStyle(
                      fontFamily: 'Rubik',
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: SvgPicture.asset(
                      Images.IconClose,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Flexible(
              child: Text(
                widget.branchCaution!,
                maxLines: 12,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
