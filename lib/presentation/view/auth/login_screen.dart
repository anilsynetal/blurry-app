import 'dart:io';

import 'package:blurry/presentation/view/auth/signup_screen.dart';
import 'package:blurry/presentation/widgets/box_decoration.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/services/binding.dart';
import '../../../core/utils/export.dart';
import '../../bottom_bar/bottom_bar.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_check_box.dart';
import '../../widgets/custom_text_field.dart';
import 'controller/login_controller.dart';
import 'forgot_password/forgot_password_screen.dart';
import 'on_boarding/screens/get_started_screen.dart';
import '../profile/privacy_policy.dart';
import '../profile/term_condition.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> Stack(
        children: [
          Scaffold(
            backgroundColor: AppThemeNotifier.surface,
            extendBodyBehindAppBar: true,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                GetStartedScreen(),
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 20),
                     child: SingleChildScrollView(
                       child: Column(
                         children: [
                           12.height,
                           commonTextField(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 12.0,right: 6),
                              child: Image.asset(mail_ic,height: 19,width: 19,),
                            ),
                             hintText: "Email",
                             fillColor: AppThemeNotifier.surface,
                             controller: controller.emailController.value
                           ),
                           10.height,
                           Obx(
                             ()=> commonTextField(
                                 prefixIcon: Padding(
                                   padding: const EdgeInsets.only(left: 12.0,right: 6),
                                   child: Image.asset(password_ic,height: 19,width: 19,),
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
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               InkWell(
                                   onTap: (){
                                     Get.to(()=>ForgotPasswordScreen(),binding: ForgotPasswordBinding());
                                   },
                                   child: Text("Forgot Password ?",style: TextStyles.labelSmall.copyWith(color: AppThemeNotifier.clickableText),))
                             ],
                           ),
                           12.height,
                           Row(
                             mainAxisAlignment: MainAxisAlignment.start,
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
                           12.height,
                           Obx(
                             ()=> gradientButton(
                              isLoading: controller.isLoading.value,
                               onPressed: () {
                               controller.login();
                               },
                               buttonText: "Log in",
                             ),
                           ),
                           20.height,
                           Row(
                             children: [
                               Flexible(child:Divider(color: AppThemeNotifier.border,height: 1,) ),
                               5.width,
                               Text("or",style: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.textDisabled),),
                               5.width,
                               Flexible(child:Divider(color: AppThemeNotifier.border,height: 1,) ),
                             ],
                           ),
                           20.height,
                          InkWell(
                             focusColor: Colors.transparent,
                               highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                               hoverColor: Colors.transparent,
                             onTap: (){
                               controller.signIn();
                             },
                             child: Container(
                               height: 50,
                               width: Get.width,
                               decoration: boxDecorationContainer(borderRadius: 40),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 children: [
                                   Image.asset(google_ic,height: 24,),
                                   10.width,
                                   Text("Sign In with Google",style:TextStyles.titleMedium.copyWith(color: AppThemeNotifier.textPrimary),)
                                 ],
                               ),
                             ),
                           ),

                          Platform.isIOS? InkWell(
                            onTap: (){
                              controller.appleSignIn();
                            },
                            focusColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            child: Container(
                               height: 50,
                               width: Get.width,
                               margin: EdgeInsets.only(top: 12),
                               decoration: boxDecorationContainer(bgColor: Color(0xFF1A1A1A),borderRadius: 40),
                               child: Row(
                                 crossAxisAlignment: CrossAxisAlignment.center,
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   Image.asset(apple_ic,height: 24,),
                                   10.width,
                                   Text("Sign In with Apple",style:TextStyles.titleMedium.copyWith(color: AppThemeNotifier.onPrimary),)
                                 ],
                               ),
                             ),
                          ):SizedBox(),
                           12.height,
                           RichText(
                             text: TextSpan(
                               text: "Don't have an account? ",
                               style: TextStyles.bodySmall.copyWith(
                                 color: AppThemeNotifier.textPrimary,
                                 fontSize: 13
                               ),
                               children: [
                                 TextSpan(

                                   text: ' Sign up',
                                   style: TextStyles.bodySmall.copyWith(
                                     color: AppThemeNotifier.primary,
                                       fontSize: 13

                                   ),
                               recognizer: TapGestureRecognizer()
                                 ..onTap = () {
                                   // 👉 Navigate to your Sign Up screen here
                                   Get.to(() => const SignupScreen(),binding: SignUpBinding());
                                   // or Navigator.push(context, MaterialPageRoute(builder: (_) => SignUpScreen()));
                                 },

                                 ),

                               ],
                             ),
                           ),

                         ],
                       ),
                     ),
                   ),
                 )

                // // Login Title
                // Center(
                //   child: Text(
                //     'Login',
                //     style: TextStyles.headlineMedium.copyWith(
                //       color: AppThemeNotifier.textPrimary,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                //
                // SizedBox(height: 8),
                //
                // // Subtitle
                // Center(
                //   child: Text(
                //     'Fill your information below or register\nwith your social account.',
                //     style: TextStyles.bodyMedium.copyWith(
                //       color: AppThemeNotifier.textSecondaryAlpha,
                //       fontSize: 13
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                //
                // SizedBox(height: 40),
                //
                // // Mobile Number Label
                // Text(
                //   'Mobile Number',
                //   style: TextStyles.titleSmall.copyWith(
                //     color: AppThemeNotifier.textSecondaryAlpha,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                //
                // SizedBox(height: 8),
                //
                // // Phone Input Field
                // TextField(
                //   controller: controller.phoneController,
                //   keyboardType: TextInputType.phone,
                //   inputFormatters: [
                //     FilteringTextInputFormatter.digitsOnly,
                //     LengthLimitingTextInputFormatter(10),
                //   ],
                //
                //   onChanged: controller.onPhoneChanged,
                //   style: TextStyles.titleMedium.copyWith(
                //     color: AppThemeNotifier.textPrimary,
                //   ),
                //   decoration: InputDecoration(
                //    isDense: true,
                //
                //     filled: true,
                //     fillColor: Color(0xFFF2F2F2),
                //
                //     hintText: 'Enter your 10 digit mobile number',
                //     hintStyle: TextStyles.bodySmall.copyWith(
                //       color: AppThemeNotifier.textTertiary,
                //     ),
                //     border: OutlineInputBorder(
                //       borderSide: BorderSide.none,
                //       borderRadius: BorderRadius.circular(12)
                //     ),
                //     enabled: true,
                //     enabledBorder: OutlineInputBorder(
                //         borderSide: BorderSide.none,
                //         borderRadius: BorderRadius.circular(12)
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(color: AppThemeNotifier.primary,width: 1),
                //         borderRadius: BorderRadius.circular(12)
                //     ),
                //     // focusedBorder:,
                //     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                //   ),
                // ),
                //
                // SizedBox(height: 24),





                // Send OTP Button

              ],
            ),

          ), controller.isLoadGoogleLogin.value? Container(
            color: Colors.black12,
            height: Get.height,
            width: Get.width,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ):SizedBox()
        ],
      ),
    );
  }
}