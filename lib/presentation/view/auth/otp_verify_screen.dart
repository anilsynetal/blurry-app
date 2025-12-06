import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:pinput/pinput.dart';

import '../../../core/utils/export.dart';
import '../../widgets/common_button.dart';
import 'controller/otp_controller.dart';

class OTPVerificationScreen extends GetView<OTPController> {
  OTPVerificationScreen({super.key});

  final _pinTheme = PinTheme(
    height: 55,
    width: 55,
    textStyle: TextStyles.titleLarge.copyWith(
      color: AppThemeNotifier.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(

      color: AppThemeNotifier.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppThemeNotifier.border, width: 0.8),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final String? sentTo = Get.arguments is String ? Get.arguments as String : null;

    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              40.height,
              Text(
                "Enter verification code",
                style: TextStyles.headlineMedium.copyWith(
                  color: AppThemeNotifier.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              10.height,
              Text(
                sentTo != null
                    ? "We have sent a code to $sentTo"
                    : "We have sent an email to your email account with a verification code!",
                style: TextStyles.bodyMedium.copyWith(
                  color: AppThemeNotifier.textDisabled,
                  height: 1.5,
                  fontSize: 13
                ),
                textAlign: TextAlign.center,
              ),
              28.height,

              // Pinput using shared colors
              Center(
                child: Obx(
                      () => Pinput(

                    length: controller.otpLength,
                    defaultPinTheme: _pinTheme,

                    focusedPinTheme: _pinTheme.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppThemeNotifier.primary,width: 1.3),
                        // border: GradientBoxBorder(
                        //   gradient:
                        //   LinearGradient(
                        //       begin: Alignment.topCenter,
                        //       end:  Alignment.bottomCenter,
                        //       colors: [AppThemeNotifier.primarySet1,AppThemeNotifier.primarySet2,AppThemeNotifier.primarySet3]),
                        //   width: 1.2,
                        // ),
                        borderRadius: BorderRadius.circular(12)
                      )
                      // decoration: _pinTheme.decoration!.copyWith(
                      //   color: AppThemeNotifier.surface,
                      //
                      //   borderRadius: BorderRadius.circular(12),
                      //   border: Border.all(color: AppThemeNotifier.border, width: 0.8),
                      // ),
                    ),
                    submittedPinTheme: _pinTheme.copyWith(
                      decoration: _pinTheme.decoration!.copyWith(
                        color: AppThemeNotifier.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppThemeNotifier.border, width: 0.8),
                      ),
                    ),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    onCompleted: controller.onCompleted,
                    onChanged: controller.onChanged,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),

              28.height,

              // Resend countdown
              Center(
                child: Obx(() {
                  final secs = controller.secondsRemaining.value;
                  final canResend = secs == 0;
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
                          text: canResend ? controller.isLoadResent.value ?"Loading...":'Resend now' : '$secs Seconds',
                          style: linkStyle,
                          recognizer: TapGestureRecognizer()
                            ..onTap = canResend ? controller.resendCode : null,
                        ),
                      ],
                    ),
                  );
                }),
              ),

              50.height,

              // Verify button reusing gradientButton
              Obx(
                    () => gradientButton(
                      isLoading: controller. isLoading.value,
                  onPressed: controller.code.value.length == controller.otpLength
                      ? controller.verify
                      : (){
                    showWarningMessage("Please Enter OTP");
                  },
                  buttonText: "Verify",
                ),
              ),
              24.height,
            ],
          ),
        ),
      ),
    );
  }
}