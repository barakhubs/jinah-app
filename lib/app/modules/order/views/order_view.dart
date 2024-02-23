// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jinahfoods/app/modules/auth/views/login_view.dart';
import 'package:jinahfoods/app/modules/cart/controllers/cart_controller.dart';
import 'package:jinahfoods/app/modules/dashboard/views/dashboard_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../controllers/order_controller.dart';

import 'package:get_storage/get_storage.dart';

class OrderView extends StatefulWidget {
  const OrderView({super.key});

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  @override
  void initState() {
    Get.put(OrderController());
    Get.find<OrderController>().getMyOrderList();
    
    super.initState();
  }

  final box = GetStorage();

  bool? isLogedIn;

  @override
Widget build(BuildContext context) {
  return GetBuilder<OrderController>(
    builder: (orderController) => Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'My Orders',
              style: fontBoldWithColorBlack,
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
          ),
          body: RefreshIndicator(
            color: AppColor.primaryColor,
            onRefresh: () async {
              orderController.getMyOrderList();
            },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: box.read('isLogedIn') == true
                    ? [
                        SizedBox(
                          height: 20.h,
                        ),
                        orderController.loader
                            ? activeOrderSectionShimmer()
                            : activeOrderSection(),
                        SizedBox(
                          height: 24.h,
                        ),
                        orderController.loader
                            ? previousOrdersShimmer()
                            : previousOrders(),
                      ]
                    : [notLogged()],
              ),
            ),
          ),
        ),
        orderController.orderDetailsLoader
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
            : const SizedBox.shrink(),
      ],
    ),
  );
}


}

Widget notLogged() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        child: Column(children: [
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            width: 100.w,
            height: 100.h,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Image.asset(
                Images.profile,
                width: 100.w,
                height: 100.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            'Login to see your orders',
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 14.sp,
              color: AppColor.fontColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => LoginView());

                    // (context as Element).markNeedsBuild();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: Size(320.w, 52.h),
                    backgroundColor: AppColor.loginButtonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                  child: Text("LOGIN".tr, style: fontMedium),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
        ]),
      ),
    ],
  );
}

Widget activeOrderSection() {
  return GetBuilder<OrderController>(
    builder: (orderController) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 18.w, right: 18.w),
          child: Text(
            'ACTIVE_ORDERS'.tr,
            style: fontMedium,
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: orderController.ordersData.length,
            itemBuilder: (BuildContext context, index) {
              return orderController.ordersData[index].status == 1 ||
                      orderController.ordersData[index].status == 4 ||
                      orderController.ordersData[index].status == 7 ||
                      orderController.ordersData[index].status == 10
                  ? Padding(
                      padding:
                          EdgeInsets.only(left: 8.w, right: 8.w, bottom: 10.w),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () async {
                                orderController.getOrderDetails(
                                    orderController.ordersData[index].id!);
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.only(top: 5.h, bottom: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                    border: Border.all(color: AppColor.itembg)),
                                child: Padding(
                                  padding: EdgeInsets.all(4.r),
                                  child: Row(children: [
                                    SvgPicture.asset(
                                      Images.active_order,
                                      width: 32.w,
                                      height: 32.h,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      width: 270.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 6.h, bottom: 6.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "ORDER_ID".tr,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily: "Rubik",
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                Text(
                                                  orderController
                                                      .ordersData[index]
                                                      .orderSerialNo
                                                      .toString(),
                                                  style: fontRegularBold,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const Spacer(),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    1)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.pending,
                                                      AppColor.pendingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    4)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.preparing,
                                                      AppColor.preparingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    7)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.preparing,
                                                      AppColor.preparingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    10)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.preparing,
                                                      AppColor.preparingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    13)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.preparing,
                                                      AppColor.preparingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    14)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.canceled,
                                                      AppColor.error),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    19)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.canceled,
                                                      AppColor.error),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    22)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.canceled,
                                                      AppColor.error),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            orderController
                                                .ordersData[index].orderDatetime
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: "Rubik",
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          orderController.ordersData[index]
                                                      .orderType ==
                                                  5
                                              ? Text(
                                                  "DELIVERY".tr,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColor
                                                          .activeTxtColor),
                                                )
                                              : Text(
                                                  "TAKEAWAY".tr,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey),
                                                ),
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "TOTAL".tr,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Rubik",
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                orderController
                                                    .ordersData[index]
                                                    .totalCurrencyPrice
                                                    .toString(),
                                                style: fontMediumPro,
                                              ),
                                              const Spacer(),
                                              Text(
                                                "SEE_ORDER_STATUS".tr,
                                                style: fontRegularBoldwithColor,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              SvgPicture.asset(
                                                Images.right_arrow,
                                                width: 10.w,
                                                height: 10.h,
                                                fit: BoxFit.cover,
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ),
                          ]),
                    )
                  : const SizedBox.shrink();
            }),
      ],
    ),
  );
}

Widget previousOrders() {
  return GetBuilder<OrderController>(
    builder: (orderController) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 18.w, right: 18.w),
          child: Text(
            'PREVIOUS_ORDERS'.tr,
            style: TextStyle(
                fontSize: 18.sp,
                color: AppColor.activeTxtColor,
                fontWeight: FontWeight.w600),
          ),
        ),
        SizedBox(
          height: 14.h,
        ),
        ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: orderController.ordersData.length,
            itemBuilder: (BuildContext context, index) {
              return orderController.ordersData[index].status == 13 ||
                      orderController.ordersData[index].status == 16 ||
                      orderController.ordersData[index].status == 19 ||
                      orderController.ordersData[index].status == 22
                  ? InkWell(
                      onTap: () async {
                        orderController.getOrderDetails(
                            orderController.ordersData[index].id!);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 8.w, right: 8.w, bottom: 10.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding:
                                    EdgeInsets.only(top: 5.h, bottom: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white,
                                    border: Border.all(color: AppColor.itembg)),
                                child: Padding(
                                  padding: EdgeInsets.all(4.r),
                                  child: Row(children: [
                                    SvgPicture.asset(
                                      Images.active_order,
                                      width: 32.w,
                                      height: 32.h,
                                      fit: BoxFit.cover,
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    SizedBox(
                                      width: 270.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 6.h, bottom: 6.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "ORDER_ID".tr,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontFamily: "Rubik",
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                Text(
                                                  orderController
                                                      .ordersData[index]
                                                      .orderSerialNo
                                                      .toString(),
                                                  style: fontRegularBold,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const Spacer(),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    1)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.pending,
                                                      AppColor.pendingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    4)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.preparing,
                                                      AppColor.preparingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    7)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.preparing,
                                                      AppColor.preparingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    10)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.preparing,
                                                      AppColor.preparingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    13)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.preparing,
                                                      AppColor.preparingText),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    16)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.canceled,
                                                      AppColor.error),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    19)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.canceled,
                                                      AppColor.error),
                                                if (orderController
                                                        .ordersData[index]
                                                        .status ==
                                                    22)
                                                  orderStatus(
                                                      orderController
                                                          .ordersData[index]
                                                          .statusName,
                                                      AppColor.canceled,
                                                      AppColor.error),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            orderController
                                                .ordersData[index].orderDatetime
                                                .toString(),
                                            style: TextStyle(
                                                fontFamily: "Rubik",
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          ),
                                          SizedBox(
                                            height: 4.h,
                                          ),
                                          orderController.ordersData[index]
                                                      .orderType ==
                                                  5
                                              ? Text(
                                                  "Delivery".tr,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AppColor
                                                          .activeTxtColor),
                                                )
                                              : Text(
                                                  "Takeaway".tr,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontFamily: "Rubik",
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.grey),
                                                ),
                                          SizedBox(
                                            height: 6.h,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "TOTAL".tr,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: "Rubik",
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Text(
                                                orderController
                                                    .ordersData[index]
                                                    .totalCurrencyPrice
                                                    .toString(),
                                                style: fontMediumPro,
                                              ),
                                              const Spacer(),
                                              Text(
                                                "SEE_ORDER_STATUS".tr,
                                                style: fontRegularBoldwithColor,
                                              ),
                                              SizedBox(
                                                width: 8.w,
                                              ),
                                              SvgPicture.asset(
                                                Images.right_arrow,
                                                width: 10.w,
                                                height: 10.h,
                                                fit: BoxFit.cover,
                                              ),
                                              SizedBox(
                                                width: 6.w,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ]),
                      ),
                    )
                  : const SizedBox.shrink();
            }),
      ],
    ),
  );
}

Container orderStatus(status, bgColor, textColor) {
  return Container(
    padding: EdgeInsets.all(4.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(10.r)),
      color: bgColor,
    ),
    alignment: Alignment.center,
    child: Text(
      status.toString(),
      style: TextStyle(fontFamily: "Rubik", fontSize: 8.sp, color: textColor),
    ),
  );
}

//shimmer section
Widget activeOrderSectionShimmer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[300]!,
          child: Container(
            height: 30.h,
            width: 150.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r), color: Colors.white),
          ),
        ),
      ),
      SizedBox(
        height: 14.h,
      ),
      Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[300]!,
        child: Padding(
          padding: EdgeInsets.only(left: 8.w, right: 8.w),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              height: 96.h,
              width: 328.w,
              padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Colors.white,
                  border: Border.all(color: AppColor.itembg)),
            ),
          ]),
        ),
      ),
    ],
  );
}

Widget previousOrdersShimmer() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[300]!,
          child: Container(
            height: 30.h,
            width: 150.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r), color: Colors.white),
          ),
        ),
      ),
      SizedBox(
        height: 12.h,
      ),
      ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (BuildContext context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[300]!,
              child: Padding(
                padding: EdgeInsets.only(left: 8.w, right: 8.w, bottom: 12.h),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: 96.h,
                    width: 328.w,
                    padding: EdgeInsets.only(top: 5.h, bottom: 10.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        color: Colors.white,
                        border: Border.all(color: AppColor.itembg)),
                  ),
                ]),
              ),
            );
          }),
    ],
  );
}
