import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jinahfoods/app/modules/profile/widget/change_phone_number.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/loader.dart';
import '../../splash/controllers/splash_controller.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends StatefulWidget {
  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool validate = false;

  @override
  Widget build(BuildContext context) {
    SplashController splashController = Get.put(SplashController());
    ProfileController profileController = Get.find<ProfileController>();
    TextEditingController mobileEditingController =
        TextEditingController(text: profileController.mobileController.text);

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
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8.h),
                      child: Text(
                        'EDIT_PROFILE'.tr,
                        style: fontMedium,
                      ),
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
                            'FIRST_NAME'.tr,
                            style: fontProfileLite,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            controller: profileController.firstNameController,
                            validator: (value) => value!.isEmpty
                                ? 'PLEASE_TYPE_FIRST_NAME'.tr
                                : null,
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  width: 1.w,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  width: 1.w,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              fillColor: Colors.red,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide: BorderSide(
                                    color: AppColor.primaryColor, width: 1.w),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                                borderSide: BorderSide(
                                    width: 1.w, color: AppColor.dividerColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'LAST_NAME'.tr,
                            style: fontProfileLite,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            controller: profileController.lastNameController,
                            validator: (value) => value!.isEmpty
                                ? 'PLEASE_TYPE_LAST_NAME'.tr
                                : null,
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  width: 1.w,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  width: 1.w,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              fillColor: Colors.red,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide: BorderSide(
                                    color: AppColor.primaryColor, width: 1.w),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.r),
                                ),
                                borderSide: BorderSide(
                                    width: 1.w, color: AppColor.dividerColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Text(
                            'EMAIL'.tr,
                            style: fontProfileLite,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          TextFormField(
                            enabled: false,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            controller: profileController.emailController,
                            validator: (value) => value!.isEmpty
                                ? 'PLEASE_TYPE_EMAIL'.tr
                                : value.toString() == 'null'
                                    ? 'PLEASE_TYPE_EMAIL'.tr
                                    : null,
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  width: 1.w,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  width: 1.w,
                                  color: AppColor.primaryColor,
                                ),
                              ),
                              fillColor: Colors.red,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide: BorderSide(
                                    color: AppColor.primaryColor, width: 1.w),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.r)),
                                borderSide: BorderSide(
                                    width: 1.w, color: AppColor.dividerColor),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Get.width - 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    validateAndSave(context);
                                    (context as Element).markNeedsBuild();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColor.primaryColor,
                                    minimumSize: Size(156.w, 48.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.r),
                                    ),
                                  ),
                                  child: Text(
                                    "UPDATE_PROFILE".tr,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: fontMedium,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: Get.width - 50,
                                child: OutlinedButton(
                                  onPressed: () {
                                    Get.to(ChangePhoneNumberView());
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    minimumSize: Size(156.w, 48.h),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24.r),
                                      side: BorderSide(
                                        color: AppColor.primaryColor,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "CHANGE PHONE  NUMBER",
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: TextStyle(
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
          profileController.updateProfileLodear
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

  void validateAndSave(context) {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      Get.find<ProfileController>().updateUserProfile(context);
      validate = true;
    } else {
      validate = false;
    }
  }
}
