
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:blurry/presentation/widgets/custom_text_field.dart';
import 'package:blurry/presentation/widgets/credit_widget.dart';

import 'change_password_controller.dart';

class ChangePasswordScreen extends GetView<ChangePasswordController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppThemeNotifier.surface,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Center(child: Image.asset(back_ic, height: 24)),
          ),
        ),
        centerTitle: false,
        title: Text(
          "Change Password",
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,
          ),
        ),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Description
              Text(
                'Update Your Password',
                style: TextStyles.headlineMedium.copyWith(
                  color: AppThemeNotifier.textSecondary,
                  fontSize: 16,
                ),
              ),
              8.height,
              Text(
                'Please enter your current password and choose a new password.',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppThemeNotifier.textDisabled,
                ),
              ),
              24.height,

              // Old Password Field
              Text(
                'Current Password',
                style: TextStyles.titleMedium.copyWith(
                  color: AppThemeNotifier.textPrimary,
                  fontSize: 14,
                ),
              ),
              8.height,
              Obx(
                    () => commonTextField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 6),
                    child: Image.asset(
                      password_ic,
                      height: 19,
                      width: 19,
                      color: AppThemeNotifier.primary,
                    ),
                  ),
                  hintText: "Current Password",
                  fillColor: AppThemeNotifier.surface,
                  controller: controller.oldPasswordController.value,
                  isPassword: !controller.isOldPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isOldPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppThemeNotifier.textDisabled,
                      size: 18,
                    ),
                    onPressed: controller.toggleOldPasswordVisibility,
                  ),
                  borderRadius: 12,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
              16.height,

              // New Password Field
              Text(
                'New Password',
                style: TextStyles.titleMedium.copyWith(
                  color: AppThemeNotifier.textPrimary,
                  fontSize: 14,
                ),
              ),
              8.height,
              Obx(
                    () => commonTextField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 6),
                    child: Image.asset(
                      password_ic,
                      height: 19,
                      width: 19,
                      color: AppThemeNotifier.primary,
                    ),
                  ),
                  hintText: "New Password",
                  fillColor: AppThemeNotifier.surface,
                  controller: controller.newPasswordController.value,
                  isPassword: !controller.isNewPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isNewPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppThemeNotifier.textDisabled,
                      size: 18,
                    ),
                    onPressed: controller.toggleNewPasswordVisibility,
                  ),
                  borderRadius: 12,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
              8.height,
              Text(
                'Password must be at least 8 characters',
                style: TextStyles.labelSmall.copyWith(
                  color: AppThemeNotifier.textSecondaryAlpha,
                  fontSize: 10,
                ),
              ),
              16.height,

              // Confirm Password Field
              Text(
                'Confirm Password',
                style: TextStyles.titleMedium.copyWith(
                  color: AppThemeNotifier.textPrimary,
                  fontSize: 14,
                ),
              ),
              8.height,
              Obx(
                    () => commonTextField(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 6),
                    child: Image.asset(
                      password_ic,
                      height: 19,
                      width: 19,
                      color: AppThemeNotifier.primary,
                    ),
                  ),
                  hintText: "Confirm Password",
                  fillColor: AppThemeNotifier.surface,
                  controller: controller.confirmPasswordController.value,
                  isPassword: !controller.isConfirmPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppThemeNotifier.textDisabled,
                      size: 18,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                  borderRadius: 12,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 16,
                  ),
                ),
              ),
              32.height,
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: gradientButton(
            height: 48,
            isLoading:  controller.isLoading.value ,
            buttonText: controller.isLoading.value ? 'Changing...' : 'Change Password',
            onPressed: controller.isLoading.value
                ? () {}
                : () {
              controller.changePassword(context);
            },
          ),
        ),
      ),
    );
  }
}