import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'item_caution.dart';
import '../app/modules/item/views/item_view.dart';
import '../util/constant.dart';
import '../util/style.dart';

Widget itemCardGrid(item, index, context) {
  return InkWell(
    onTap: () {
      showBottomSheet(
        context: context,
        builder: (context) => SingleChildScrollView(
          child: ItemView(
            itemDetails: item[index],
            indexNumber: index,
          ),
        ),
      );
    },
    child: Container(
      height: 195.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.white,
        border: Border.all(color: AppColor.itembg),
      ),
      child: Column(
        children: [
          _buildImage(item, index),
          Expanded(child: _buildItemDetails(item, index, context)),
        ],
      ),
    ),
  );
}

Widget _buildImage(item, index) {
  return SizedBox(
    height: 90.h,
    child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: CachedNetworkImage(
        imageUrl: item[index].cover!,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          child: Container(height: 86.h, width: 154.w, color: Colors.grey),
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[400]!,
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    ),
  );
}

Widget _buildItemDetails(item, index, context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    item[index].name!,
                    style: fontRegularBold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {
                    showBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SingleChildScrollView(
                        child: ItemCaution(
                          itemName: item[index].name,
                          itemCaution: item[index].caution,
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 16.w,
                    height: 16.h,
                    child: SvgPicture.asset(
                      Images.iconDetails,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              item[index].description!,
              style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp,
                  height: 1.4.h,
                  color: AppColor.gray),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
      _buildPriceSection(item, index),
    ],
  );
}

Widget _buildPriceSection(item, index) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.w).copyWith(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        item[index].offer.isNotEmpty
            ? Row(
                children: [
                  (item[index].price != null &&
                          double.parse(item[index].price!) != 0.0)
                      ? Text(
                          item[index].currencyPrice!,
                          style: TextStyle(
                              fontFamily: 'Rubik',
                              fontWeight: FontWeight.w500,
                              fontSize: 10.sp,
                              decoration: TextDecoration.lineThrough,
                              color: AppColor.gray),
                        )
                      : SizedBox(
                          width: 4.w,
                        ),
                  Text(
                    item[index].offer[0].currencyPrice!,
                    style: fontMediumPro,
                  ),
                ],
              )
            : (item[index].price != null &&
                    double.parse(item[index].price!) != 0.0)
                ? Text(
                    item[index].currencyPrice!,
                    style: fontMediumPro,
                  )
                : SizedBox.shrink(),
        _buildAddToCartButton(),
      ],
    ),
  );
}

Widget _buildAddToCartButton() {
  return Container(
    padding: EdgeInsets.all(4.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16.r),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: AppColor.itembg,
          offset: const Offset(0.0, 4.0),
          blurRadius: 5.r,
          spreadRadius: 1.r,
        ),
        BoxShadow(
          color: AppColor.itembg,
          offset: const Offset(1.0, 0.0),
          blurRadius: 1.r,
          spreadRadius: 0.r,
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 12.w,
          height: 12.h,
          child: SvgPicture.asset(
            Images.iconCart,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 2.w),
        Text("ADD".tr, style: fontRegularBoldwithColor)
      ],
    ),
  );
}
