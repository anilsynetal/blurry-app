import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:blurry/presentation/widgets/custom_text_field.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';

import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends GetView<ForgotPasswordController> {
  const ForgotPasswordScreen({super.key});

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
            if (controller.currentStep.value == 2) {
              controller.goBackToEmailStep();
            } else {
              Get.back();
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Center(child: Image.asset(back_ic, height: 24)),
          ),
        ),
        centerTitle: false,
        title: Obx(
          () => Text(
            controller.currentStep.value == 1
                ? "Forgot Password"
                : "Reset Password",
            style: TextStyles.headlineMedium.copyWith(
              color: AppThemeNotifier.textPrimary,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.currentStep.value == 1) ...[
                  Text(
                    'Enter Your Email',
                    style: TextStyles.headlineMedium.copyWith(
                      color: AppThemeNotifier.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  8.height,
                  Text(
                    'We\'ll send you a verification code to reset your password.',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppThemeNotifier.textDisabled,
                    ),
                  ),
                  24.height,
                  Text(
                    'Email Address',
                    style: TextStyles.titleMedium.copyWith(
                      color: AppThemeNotifier.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  8.height,
                  commonTextField(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 6),
                      child: Image.asset(
                        mail_ic,
                        height: 19,
                        width: 19,
                        color: AppThemeNotifier.primary,
                      ),
                    ),
                    hintText: "Enter your email",
                    fillColor: AppThemeNotifier.surface,
                    controller: controller.emailController.value,
                    borderRadius: 12,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                  ),
                  32.height,
                ] else ...[
                  Text(
                    'Verify & Reset Password',
                    style: TextStyles.headlineMedium.copyWith(
                      color: AppThemeNotifier.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                  8.height,
                  Text(
                    'Enter the verification code sent to ${controller.verificationEmail.value}',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppThemeNotifier.textDisabled,
                    ),
                  ),
                  24.height,

                  // OTP Input
                  Text(
                    'Verification Code',
                    style: TextStyles.titleMedium.copyWith(
                      color: AppThemeNotifier.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  12.height,
                  Center(
                    child: Pinput(
                      length: controller.otpLength,
                      controller: controller.otpController.value,
                      defaultPinTheme: PinTheme(
                        height: 55,
                        width: 55,
                        textStyle: TextStyles.titleLarge.copyWith(
                          color: AppThemeNotifier.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          color: AppThemeNotifier.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppThemeNotifier.border,
                            width: 0.8,
                          ),
                        ),
                      ),
                      focusedPinTheme: PinTheme(
                        height: 55,
                        width: 55,
                        textStyle: TextStyles.titleLarge.copyWith(
                          color: AppThemeNotifier.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppThemeNotifier.primary,
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      submittedPinTheme: PinTheme(
                        height: 55,
                        width: 55,
                        textStyle: TextStyles.titleLarge.copyWith(
                          color: AppThemeNotifier.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          color: AppThemeNotifier.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppThemeNotifier.border,
                            width: 0.8,
                          ),
                        ),
                      ),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        controller.otpController.value.text = value;
                      },
                    ),
                  ),
                  20.height,

                  // Resend Countdown
                  Center(
                    child: Obx(() {

                      final baseStyle = TextStyles.labelMedium.copyWith(
                        color: AppThemeNotifier.textSecondaryAlpha,
                      );
                      final linkStyle = TextStyles.labelMedium.copyWith(
                        color: AppThemeNotifier.clickableText,
                        fontWeight: FontWeight.w600,
                      );
                      return RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: 'Resend code in ', style: baseStyle),
                            TextSpan(
                              text: controller.secondsRemaining.value == 0 ? 'Resend now' : '${controller.secondsRemaining.value} Seconds',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = controller.secondsRemaining.value == 0 ? controller.resendCode : null,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  24.height,

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
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
          child: controller.currentStep.value == 1
              ? gradientButton(
                  height: 48,
                  isLoading: controller.isSendingOTP.value,
                  buttonText: controller.isSendingOTP.value
                      ? 'Sending...'
                      : 'Send Verification Code',
                  onPressed: controller.isSendingOTP.value
                      ? () {}
                      : controller.sendOTP,
                )
              : gradientButton(
                  height: 48,
                  isLoading: controller.isLoading.value,
                  buttonText: controller.isLoading.value
                      ? 'Resetting...'
                      : 'Reset Password',
                  onPressed: controller.isLoading.value
                      ? () {}
                      : controller.resetPassword,
                ),
        ),
      ),
    );
  }
}
