import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jinahfoods/app/modules/splash/controllers/splash_controller.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../controllers/profile_controller.dart';

class ChangePhoneNumberView extends GetView<ProfileController> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool validate = false;

  ChangePhoneNumberView({super.key});
  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());
    ProfileController profileController = Get.find<ProfileController>();
    TextEditingController mobileEditingController =
        TextEditingController(text: profileController.mobileController.text);
    return Stack(
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
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Phone Number',
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MOBILE_NUMBER'.tr,
                          style: fontProfileLite,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        SizedBox(
                          height: 56.h,
                          child: Row(
                            children: [
                              Container(
                                width: 100.w,
                                height: 56.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  border:
                                      Border.all(color: AppColor.dividerColor),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(splashController
                                        .countryInfoData.flagEmoji!),
                                    SizedBox(width: 6.w),
                                    Text(splashController
                                        .countryInfoData.callingCode!),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextFormField(
                                  controller:
                                      profileController.mobileController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                          width: 1.w,
                                          color: AppColor.primaryColor),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                          width: 1.w,
                                          color: AppColor.primaryColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.r)),
                                      borderSide: BorderSide(
                                          color: AppColor.primaryColor,
                                          width: 1.w),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide(
                                          width: 1.w,
                                          color: AppColor.dividerColor),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            'You will receive a code via SMS to verify your new number',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                validateAndSave(context);
                                (context as Element).markNeedsBuild();
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(328.w, 52.h),
                                backgroundColor: AppColor.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.r)),
                              ),
                              child: Text("Get Code", style: fontMedium),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        controller.updateProfileLodear
            ? Positioned(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white60,
                  child: const Center(child: LoaderCircle()),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }

  void validateAndSave(context) {
    final FormState? form = _formKey.currentState;
    final String? phoneNumber = controller.mobileController.text;

    // Perform validation only if the phone number has exactly 9 digits
    if (phoneNumber != null && phoneNumber.length == 9) {
      FocusManager.instance.primaryFocus?.unfocus();
      controller.phoneNumberChange(phoneNumber);
      validate = true;
    } else {
      validate = false;
      Get.snackbar(
      'Invalid Phone Number', // Title
      'Phone number must have exactly 9 digits', // Message
      backgroundColor: AppColor.primaryColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
    }
  }
}
