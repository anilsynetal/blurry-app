import 'dart:io';

import 'package:blurry/core/services/binding.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/view/auth/sign_up_steps/signup_controller.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/typography.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/common_check_box.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';
import '../../plan/view/plan_price_screen.dart';
import '../../profile/privacy_policy.dart';
import '../../profile/term_condition.dart';
import 'app_stepper.dart';
import 'custom_radio_tile.dart';

class SignUpStepsScreen extends GetView<SignUpStepsController> {
  const SignUpStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle device back button
        if (controller.currentStep.value > 0) {
          controller.back(); // Go to previous step
          return false; // Prevent popping the screen
        }
        return true; // Allow popping the screen when on step 0
      },
      child: Scaffold(
        backgroundColor: AppThemeNotifier.surface,
        appBar: AppBar(
          shadowColor: Colors.transparent,
          scrolledUnderElevation: 0,
          surfaceTintColor: AppThemeNotifier.surface,
          backgroundColor: AppThemeNotifier.surface,
          elevation: 0,
          title: Obx(
                () => Text(
              controller.currentStep.value == 3 ? "Verify Your Identity" : 'Create Your Account',
              style: TextStyles.headlineMedium.copyWith(
                color: AppThemeNotifier.textPrimary,
                fontSize: 20,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Obx(() {
            return Column(
              children: [
                controller.currentStep.value == 3
                    ? SizedBox()
                    : Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: AppStepper(
                    total: 3,
                    current: controller.currentStep.value,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: _buildStep(controller.currentStep.value, context),
                  ),
                ),
                _buildBottomBar(context),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Obx(() {
      final isFirst = controller.currentStep.value == 0;
      final isLast = controller.currentStep.value == 2;
      return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 40),
        child: controller.currentStep.value == 3
            ? Obx(
              ()=> gradientButton(
                        height: 48,
                        isLoading: controller.   isLoading.value,
                        buttonText: 'Continue',
                        onPressed: () {
              if(controller.verificationSelfie.value == null){
                showWarningMessage("Please select your profile picture.");
              }else {
                if (controller.termsAccepted.value) {
                  controller.updateProfileImage(controller.verificationSelfie.value!.path.toString(),context);
                } else {
                  showWarningMessage(
                      "Please check Terms of service & privacy policy.");
                }
              }
                        },
                      ),
            )
            : Row(
          children: [
            gradientButton(
              height: 50,
              width: 65,
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppThemeNotifier.onPrimary,
                size: 20,
              ),
              onPressed: isFirst ? () {} : controller.back,
            ),
            Spacer(),
            gradientButton(
              bgColor: isLast ? AppThemeNotifier.shadow : null,
              height: 50,
              width: 65,
              child: Icon(
                Icons.arrow_forward_ios_sharp,
                color: AppThemeNotifier.onPrimary,
                size: 20,
              ),
              onPressed: () {
                if (isLast) {
                  // Handle last step if needed
                } else {
                  controller.next();
                }
              },
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStep(int step, BuildContext context) {
    switch (step) {
      case 0:
        return _identifyAs();
      case 1:
        return _basicInformation(context);
      case 2:
        return _addYourPhoto();
      default:
        return _verifyYourIdentity(context);
    }
  }

  // Step 1: Identify as (custom radio)
  Widget _identifyAs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "“Tired of endless swiping? We slow things down so you can meet the person behind the pixels.”",
          style: TextStyles.bodySmall.copyWith(
            fontSize: 13,
            color: AppThemeNotifier.textDisabled,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          'I identify as.',
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textSecondary,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 30),
        ...controller.genders.map(
              (g) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Obx(
                  () => CustomRadioTile(
                title: g,
                selected: controller.gender.value == g,
                onTap: () => controller.gender.value = g,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Step 2: Basic Information
  Widget _basicInformation(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Basic Information',
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textSecondary,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 30),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: commonTextField(
                      controller: controller.dobCtrl,
                      hintText: 'DD/MM/YYYY',
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      borderRadius: 12,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 12.0, right: 8),
                        child: Image.asset(
                          "assets/icons/calender_ic.png",
                          height: 22,
                        ),
                      ),
                      onTap: () => controller.pickDOB(context),
                      isReadOnly: true,
                      fillColor: Colors.transparent,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 25,
                            child: VerticalDivider(
                              color: AppThemeNotifier.textSecondary.withOpacity(0.7),
                              width: 1,
                              thickness: 1,
                            ),
                          ),
                          12.width,
                          Text(
                            'Age ${controller.age}',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppThemeNotifier.textDisabled,
                            ),
                          ),
                          12.width,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -3,
              left: 0,
              child: Text(
                "*",
                style: TextStyles.headlineMedium.copyWith(
                  color: Colors.red,
                  height: 0,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Obx(
              () => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: CommonDropDown<String>(
                  title: "",
                  borderRadius: 12,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 8),
                    child: Image.asset(
                      "assets/icons/location_ic.png",
                      height: 22,
                    ),
                  ),
                  hintText: 'Cities/Provinces',
                  value: controller.locationCtrl.value == "" ? null : controller.locationCtrl.value,
                  items: controller.cityList,
                  onChanged: (value) {
                    controller.locationCtrl.value = value!;
                  },
                  itemLabelBuilder: (item) => item ?? "",
                  fillColor: Colors.transparent,
                ),
              ),

            ],
          ),
        ),  const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "(Optional)",
              style: TextStyles.labelSmall.copyWith(
                color: AppThemeNotifier.textDisabled.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(
              () => CommonDropDown<String>(
            borderRadius: 12,
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 8),
              child: Image.asset(
                "assets/icons/time_ic.png",
                height: 22,
              ),
            ),
            fillColor: Colors.transparent,
            title: "",
            hintText: 'Ethnicity',
            value: controller.ethnicityCtrl.value == "" ? null : controller.ethnicityCtrl.value,
            items: controller.ethnicityList,
            onChanged: (value) {
              controller.ethnicityCtrl.value = value!;
            },
            itemLabelBuilder: (item) => item ?? "",
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "(Optional)",
              style: TextStyles.labelSmall.copyWith(
                color: AppThemeNotifier.textDisabled.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Obx(() {
                return commonTextField(
                  controller: controller.heightCtrl,
                  fillColor: Colors.transparent,
                  hintText: controller.useMetric.value ? 'Height in cm' : "Height in Ft/In",
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                  borderRadius: 12,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 8),
                    child: Image.asset(
                      "assets/icons/height_ic.png",
                      height: 22,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => controller.heightCm.value = double.tryParse(v) ?? 0,
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(
                            () => _unitSwitch(
                          useMetric: controller.useMetric.value,
                          onToggle: () => controller.useMetric.value = !controller.useMetric.value,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "(Optional)",
              style: TextStyles.labelSmall.copyWith(
                color: AppThemeNotifier.textDisabled.withOpacity(0.7),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _unitSwitch({required bool useMetric, required VoidCallback onToggle}) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: AppThemeNotifier.textDisabled.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _chip(text: 'Cm', active: useMetric),
            _chip(text: 'Ft/In', active: !useMetric),
          ],
        ),
      ),
    );
  }

  Widget _chip({required String text, required bool active}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: active ? AppThemeNotifier.primarySet1 : AppThemeNotifier.shadow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyles.labelSmall.copyWith(
          color: active ? AppThemeNotifier.onPrimary : AppThemeNotifier.textDisabled,
        ),
      ),
    );
  }

  // Step 3: Add Your Photo
  Widget _addYourPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Add Your Photo',
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textSecondary,
            fontSize: 20,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            "This helps others get to know you. Your photo will remain blurred at first.",
            style: TextStyles.bodySmall.copyWith(
              fontSize: 13,
              color: AppThemeNotifier.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Obx(() {
          final XFile? img = controller.verificationSelfie.value;
          return Column(
            children: [
              InkWell(
                onTap: controller.takeProfilePhoto,
                child: Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppThemeNotifier.textDisabled,
                      width: 1,
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: img == null
                      ? Center(
                    child: Image.asset(
                      "assets/icons/camera_ic.png",
                      height: 24,
                      width: 24,
                      fit: BoxFit.contain,
                    ),
                  )
                      : Image.file(
                    File(img.path),
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Image.asset(
                          "assets/icons/camera_ic.png",
                          height: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 5),
              InkWell(
                onTap: controller.takeProfilePhoto,
                child: Text(
                  'Take a Photo',
                  style: TextStyles.labelSmall.copyWith(
                    color: AppThemeNotifier.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: controller.takeProfilePhoto,
                child: Text(
                  'Or',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppThemeNotifier.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              commonButton(
                onPressed: controller.pickProfileFromGallery,
                buttonText: 'Upload from Gallery',
                type: ButtonType.outlined,
                backgroundColor: AppThemeNotifier.border,
                textColor: AppThemeNotifier.textPrimary,
              ),
              const SizedBox(height: 40),
              gradientButton(
                height: 48,
                buttonText: 'Take Verification Selfie',
                onPressed: controller.takeVerificationSelfie,
              ),
              10.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Take a live selfie to complete photo verification. This will never be shown to others.",
                  style: TextStyles.labelSmall.copyWith(
                    fontSize: 11,
                    color: AppThemeNotifier.textDisabled,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _verifyYourIdentity(context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "To keep the community safe and real, we need to verify your identity. This only takes a minute!",
            textAlign: TextAlign.center,
            style: TextStyles.labelSmall.copyWith(
              color: AppThemeNotifier.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Selfie",
            textAlign: TextAlign.center,
            style: TextStyles.bodySmall.copyWith(
              color: AppThemeNotifier.textPrimary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            width: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipOval(
                  child: SizedBox(
                    height: 260,
                    width: 220,
                    child: controller.isCameraInitialized.value
                        ? CameraPreview(controller.cameraController!)
                        : Container(
                      color: Colors.grey[300],
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
                if (controller.verificationSelfie.value != null)
                  ClipOval(
                    child: SizedBox(
                      height: 260,
                      width: 220,
                      child: Image.file(
                        File(controller.verificationSelfie.value!.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 260,
                  width: 220,
                  child: CircularProgressIndicator(
                    value: controller.scanProgress.value == 0 ? null : controller.scanProgress.value,
                    strokeWidth: 2,
                    backgroundColor: const Color(0xFFEDEDED),
                    valueColor: const AlwaysStoppedAnimation(Colors.green),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Position your face in the oval",
            textAlign: TextAlign.center,
            style: TextStyles.bodySmall.copyWith(
              color: AppThemeNotifier.textPrimary,
              fontSize: 13,
            ),
          ),
          10.height,
          GestureDetector(
            onTap: controller.verificationSelfie.value == null
                ? () {
              controller.captureSelfie(context);
            }
                : null,
            child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppThemeNotifier.border,
                  width: 1,
                ),
                color: Colors.transparent,
              ),
            ),
          ),
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomCheckbox(
                size: 18,
                value: controller.termsAccepted.value,
                onChanged: (v) => controller.termsAccepted.value = v ?? false,
              ),
              10.width,
              InkWell(
                onTap: (){
                  Get.to(()=>TermAndConditionScreen(),binding: TermConditionBinding());
                },
                child: Text(
                  'Terms of Service',
                  style: TextStyles.labelMedium.copyWith(
                    color: AppThemeNotifier.clickableText,
                  ),
                ),
              ),
              Text(
                ' &',
                style: TextStyles.labelMedium.copyWith(
                  color: AppThemeNotifier.textPrimary,
                ),
                
              ),
              InkWell(
                onTap: (){
                  Get.to(()=>PrivacyPolicyScreen(),binding: PrivacyPolicyBinding());
                },
                child: Text(
                  ' Privacy Policy',
                  style: TextStyles.labelMedium.copyWith(
                    color: AppThemeNotifier.clickableText,
                  ),
                ),
              ),

            ],
          ),
        ],
      );
    });
  }
}