// get_started_screen.dart
import 'dart:ui' as ui;
import 'package:blurry/core/services/binding.dart';
import 'package:blurry/presentation/view/auth/signup_screen.dart';
import 'package:blurry/presentation/view/profile/privacy_policy.dart';
import 'package:blurry/presentation/view/profile/term_condition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Your project's exports (includes commonButton, AppThemeNotifier, TextStyles, etc.)
import '../../widgets/common_button.dart';
import '/core/utils/export.dart';
import 'controller/get_started_controller.dart';
import 'login_screen.dart';

class GetStartedScreenFirst extends GetView<GetStartedController> {
  const GetStartedScreenFirst({super.key});

  // Gradient colors from the spec:

  // You can tweak the overlay strength if needed
  static const double _overlayOpacity = 0.65;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeNotifier.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(toolbarHeight: 0,backgroundColor: Colors.transparent,),
      body: Obx(
        ()=> Stack(
          fit: StackFit.expand,
          children: [
            // 1) Base background image (sharp at top)
            Image.asset(
              'assets/images/get_start_bg2.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),

            // 2) Progressive blur layer: a strongly blurred image,
            // revealed from bottom to top using an alpha gradient mask.
            ShaderMask(
              blendMode: BlendMode.dstIn,
              shaderCallback: (Rect r) {
                return  LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // At the top: fully transparent mask => no blurred image visible
                   AppThemeNotifier.primarySet1.withOpacity(0.4),
                   AppThemeNotifier.primarySet2.withOpacity(0.4),
                   AppThemeNotifier.primarySet3.withOpacity(0.5),

                  ],
                  stops: [0.0, 0.5, 1.0],
                ).createShader(r);
              },
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Image.asset(
                  'assets/images/get_start_bg2.png',
                  fit: BoxFit.cover,
                  // alignment: Alignment.center,
                ),
              ),
            ),

            // 3) Warm gradient color overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppThemeNotifier.primarySet1.withOpacity(_overlayOpacity),
                    AppThemeNotifier.primarySet2.withOpacity(_overlayOpacity),
                    AppThemeNotifier.primarySet3.withOpacity(_overlayOpacity),
                  ],
                ),
              ),
            ),

            // 4) Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    // Circular gradient "logo" badge
                    Image.asset(app_logo,height: 120,),
                    const Spacer(),

                    // Headline
                    Text(
                      'Find a Soul, not a face.',
                      textAlign: TextAlign.center,
                      style: TextStyles.headlineLarge.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color:AppThemeNotifier.onPrimary,
                        height: 1.2,

                      ),
                    ),
                    const SizedBox(height: 12),

                    Text(
                      'Because real connections go beyond appearances.',
                      style: TextStyles.interTextStyle.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppThemeNotifier.onPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    // Buttons using your common button component
                    commonButton(
                      buttonText: 'Log In',
                      onPressed: () {
                        Get.to(()=>LoginScreen(),binding: LoginBinding());
                        // TODO: handle login
                      },
                      backgroundColor: AppThemeNotifier.background,
                      textColor: AppThemeNotifier.textPrimary,
                      borderRadius: 50,
                      elevation: 0,
                      height: 48,
                    ),
                    const SizedBox(height: 24),
                    commonButton(
                      buttonText: 'Create Your Account',
                      onPressed: () {
                        Get.to(() => const SignupScreen(),binding: SignUpBinding());
                        // TODO: handle sign up
                      },
                      backgroundColor: AppThemeNotifier.background,
                      textColor: AppThemeNotifier.textPrimary,
                      borderRadius: 50,
                      elevation: 0,
                      height: 48,
                    ),

                    const SizedBox(height: 18),

                    // Browse as Guest (using text-style button)
                    commonButton(
                      buttonText: 'Browse As Guest',
                      onPressed: () {
                        controller.guest();

                        // TODO: handle guest browsing
                      },
                      type: ButtonType.text,
                      textColor: AppThemeNotifier.onPrimary,
                      textStyle: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.onPrimary),
                      icon:  Icon(
                        CupertinoIcons.arrow_right,
                        size: 16,
                        color: AppThemeNotifier.onPrimary,
                      ),
                      height: 44,
                    ),

                    const SizedBox(height: 20),

                    // Terms / Privacy
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            Get.to(()=>TermAndConditionScreen(),binding: TermConditionBinding());
                          },
                          child: Text(
                            'Terms of Service & ',
                            textAlign: TextAlign.center,
                            style:TextStyles.labelMedium.copyWith(color: AppThemeNotifier.onPrimary),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Get.to(()=>PrivacyPolicyScreen(),binding: PrivacyPolicyBinding());
                          },
                          child: Text(
                            'Privacy Policy',
                            textAlign: TextAlign.center,
                            style:TextStyles.labelMedium.copyWith(color: AppThemeNotifier.onPrimary),
                          ),
                        ),

                      ],
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            controller.isLoading.value?
            Container(
              height: Get.height,
              width: Get.width,
              color: Colors.black12,
              child: Center(
                child: CircularProgressIndicator(

                ),
              ),
            ):SizedBox()
          ],
        ),
      ),
    );
  }
}