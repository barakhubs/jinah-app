// ignore_for_file: must_be_immutable, unused_field

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jinahfoods/app/modules/auth/controllers/auth_controller.dart';
import 'package:jinahfoods/app/modules/dashboard/views/dashboard_view.dart';
import 'package:jinahfoods/app/modules/profile/controllers/profile_controller.dart';
import 'package:pinput/pinput.dart';

import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';

class VerifyChangePhoneNumberOtpView extends StatefulWidget {
  String? phoneNumber;
  bool? isGuest;
  bool? forgetPassword;
  VerifyChangePhoneNumberOtpView(
      {Key? key, this.phoneNumber, this.isGuest, this.forgetPassword})
      : super(key: key);
  @override
  State<VerifyChangePhoneNumberOtpView> createState() =>
      _VerifyChangePhoneNumberOtpViewState();
}

class _VerifyChangePhoneNumberOtpViewState
    extends State<VerifyChangePhoneNumberOtpView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final box = GetStorage();
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: fontMedium,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.gray),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColor.primaryColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
          // color: AppColor.primaryColor,
          ),
    );
    return GetBuilder<ProfileController>(
      builder: (profileController) => Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: SvgPicture.asset(Images.back),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 48.h,
                      ),
                      Image.asset(
                        Images.logo,
                        height: 60.h,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(
                        height: 32.h,
                      ),
                      Text(
                        'Verify New Number',
                        style: TextStyle(
                            fontSize: 26.sp,
                            fontFamily: "Rubik",
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 41.h,
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'ENTER_THE_CODE_SENT_TO'.tr,
                                    style: fontRegular,
                                  ),
                                  Text(
                                    widget.phoneNumber.toString(),
                                    style: fontMediumPro,
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Center(
                                child: Pinput(
                                  length: int.parse(box.read("otpLength")),
                                  defaultPinTheme: defaultPinTheme,
                                  focusedPinTheme: focusedPinTheme,
                                  submittedPinTheme: submittedPinTheme,
                                  pinputAutovalidateMode:
                                      PinputAutovalidateMode.onSubmit,
                                  showCursor: true,
                                  onCompleted: (pin) async {
                                      bool isVerified = await profileController.otpVerify(pin);
                                      if (isVerified) {
                                        // OTP verification successful, navigate to another screen
                                        Get.to(DashboardView());
                                      } else {
                                        // OTP verification failed, display an error message
                                        // You may choose to display an error message to the user here
                                      }
                                    }
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          profileController.loader
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
