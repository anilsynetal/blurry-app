import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/export.dart';
import '../../widgets/common_button.dart';
import '../../widgets/custom_text_field.dart';
import 'controller/signup_controller.dart';
import 'on_boarding/screens/get_started_screen.dart';

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reuse the existing hero/header just like login
            GetStartedScreen(message: "Create Account",),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: Column(
                children: [
                  12.height,
                  // Full Name
                  commonTextField(
                    prefixIcon: Padding(
                      padding:
                      const EdgeInsets.only(left: 12.0, right: 6),
                      child: Image.asset(
                        "assets/icons/person.png",
                        height: 19,
                        width: 19,
                      ),
                    ),
                    hintText: "Full Name",
                    fillColor: AppThemeNotifier.surface,
                    controller: controller.fullNameController.value,
                      keyboardType: TextInputType.text
                  ),
                  10.height,
                  // Email
                  commonTextField(
                    prefixIcon: Padding(
                      padding:
                          const EdgeInsets.only(left: 12.0, right: 6),
                      child: Image.asset(
                        mail_ic,
                        height: 19,
                        width: 19,
                      ),
                    ),
                    hintText: "Email",
                    fillColor: AppThemeNotifier.surface,
                    controller: controller.emailController.value,
                    keyboardType: TextInputType.emailAddress
                  ),
                  10.height,
                  // Password with visibility toggle
                  Obx(
                    () => commonTextField(
                      prefixIcon: Padding(
                        padding:
                            const EdgeInsets.only(left: 12.0, right: 6),
                        child: Image.asset(
                          password_ic,
                          height: 19,
                          width: 19,
                        ),
                      ),
                      hintText: "Password",
                      fillColor: AppThemeNotifier.surface,
                      controller: controller.passwordController.value,
                      isPassword: !controller.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: AppThemeNotifier.textDisabled,
                          size: 18,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  10.height,
                  // Referral Code
                   commonTextField(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 7),
                      child: Image.asset("assets/icons/gift.png",height: 20,color: Color(0xFFA0A0A0),)
                    ),
                    hintText: "Referral Code (Optional)",
                    fillColor: AppThemeNotifier.surface,
                    controller: controller.refCodeController.value,
                  ),
                  20.height,
                  // Sign up CTA
                  Obx(
                    () => gradientButton(
                      isLoading: controller.isLoading.value,
                      onPressed:
                          controller.isLoading.value ? (){} : controller.signUp,
                      buttonText: controller.isLoading.value
                          ? "Please wait..."
                          : "Sign up",
                    ),
                  ),
                  20.height,
                  // Divider "or"
                  Row(
                    children: [
                      const Flexible(
                          child: Divider(
                        height: 1,
                      )),
                      5.width,
                      Text(
                        "or",
                        style: TextStyles.labelMedium
                            .copyWith(color: AppThemeNotifier.textDisabled),
                      ),
                      5.width,
                      const Flexible(
                          child: Divider(
                        height: 1,
                      )),
                    ],
                  ),
                  20.height,
                  // Footer link to Login
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyles.bodySmall.copyWith(
                        color: AppThemeNotifier.textPrimary,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: 'Log in',
                          style: TextStyles.bodySmall.copyWith(
                            color: AppThemeNotifier.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.back();
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
