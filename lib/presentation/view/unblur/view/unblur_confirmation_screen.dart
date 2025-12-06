import 'dart:ui' as ui;
import 'package:blurry/presentation/view/chat_view/controllers/chat_controller.dart';
import 'package:blurry/presentation/view/unblur/view/unblur_decision_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import '../../../../core/utils/string.dart';
import '../../../widgets/credit_widget.dart';
import '../controller/unblur_controller.dart';

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
class UnblurConfirmationScreen extends GetView<UnblurController> {
  const UnblurConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController chatController = Get.find<ChatController>();
    final blur = GetStorage().read(blurPercentageKey).toString();
    final blurAfter = GetStorage().read(blurPercentageAfterKey).toString();
    final progressValue = (double.tryParse(blur) ?? 0) / 100;
    final progressAfterValue = 1.0-(double.tryParse(blurAfter) ?? 0) / 100 ;

    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,


      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppThemeNotifier.surface,
        elevation: 0,

        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Center(child: Image.asset(back_ic,height: 24,)),
            )
        ),

        title: Text(
          'Confirm Unblur?',
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,

          ),
        ),
        actions: [
          CreditBoxWidget(),
          16.width
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlurredImageCard(
                        title: 'Current Blur',
                        blurSigma: 10.0,
                        percentage: '${blur}%',
                        imagePath: controller.profileImage.value,
                      ),
                      30.width,
                      BlurredImageCard(
                        title: 'After Unblur',
                        blurSigma: 5.0,
                        percentage: '${blurAfter}%',
                        imagePath: controller.profileImage.value,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: Get.width,
                  padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      gradient:
                      LinearGradient(
                          begin: Alignment.topCenter,
                          end:  Alignment.bottomCenter,
                          colors: [
                            AppThemeNotifier.primarySet1,
                            AppThemeNotifier.primarySet2,
                            AppThemeNotifier.primarySet3,
                          ]),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: Text(
                    'This action costs 1 Credit per person.',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppThemeNotifier.primarySet2,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: commonButton(
                        type: ButtonType.outlined,
                        backgroundColor: AppThemeNotifier.border,
                        textColor: AppThemeNotifier.textPrimary,
                        height: 50,
                        buttonText: 'Cancel',
                        onPressed: () => Get.back(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(
                        ()=> gradientButton(
                          isLoading: chatController.isLoadUnBlur.value,
                          textColor: AppThemeNotifier.onPrimary,
                          height: 50,
                          buttonText: 'Confirm Unblur',
                          onPressed: () async {

                            showCupertinoDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (BuildContext context) {
                                return CupertinoAlertDialog(
                                  title: Column(
                                    children: [

                                        Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                        "Unblur Confirmed"    ,
                                          style:  TextStyles.headlineMedium.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: CupertinoColors.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      BlurredImageCard(
                                        title: 'Current Blur',
                                        blurSigma: 10.0,
                                        percentage: '${blurAfter}%',
                                        isDialog: true,
                                        imagePath: controller.profileImage.value,
                                      ),

                                           Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                         "The mist lifts a little… keep talking to see each other more clearly.",
                                          style:  TextStyles.bodySmall.copyWith(
                                            color: AppThemeNotifier.textSecondary,
                                            fontSize: 14
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5.0),
                                        child: Text(
                                          "A little investment from both sides — 1 credit each, and the photo’s now clearer!",
                                          style:  TextStyles.bodySmall.copyWith(
                                              color: AppThemeNotifier.textDisabled,
                                              fontSize: 12
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    CupertinoDialogAction(
                                      onPressed: ()async{
                                        Get.back();
                                      },
                                      child: Text(
                                        "Cancel",
                                        style: TextStyles.titleMedium.copyWith(
                                          color: Color(0xFF2194FF),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                      CupertinoDialogAction(
                                        onPressed: ()async{
                                          Get.back();
                                          chatController.confirmUnblur(context);


                                        },
                                        child: Text(
                                          "Continue",
                                          style: TextStyles.titleMedium.copyWith(
                                            color: Color(0xFF2194FF),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),


                                  ],
                                );
                              },
                            );


                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}



class BlurredImageCard extends StatelessWidget {
  final String title;
  final double blurSigma;
  final String percentage;
  final String imagePath;
  final Color gradientStartColor;
  final Color gradientEndColor;
  bool ?isDialog;

   BlurredImageCard({
    Key? key,
    required this.title,
    required this.blurSigma,
    required this.percentage,
    required this.imagePath,
    this.isDialog,
    this.gradientStartColor = const Color(0xFF1a1a1a),
    this.gradientEndColor = const Color(0xFF00FF00),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double percentageValue = double.tryParse(percentage.replaceAll('%', '')) ?? 0;
    percentageValue = percentageValue / 100;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // <CHANGE> Custom painted gradient border with percentage fill
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppThemeNotifier.shadow,
                    offset: Offset(0, 0),
                    blurRadius: 15,
                    blurStyle: BlurStyle.inner
                  )
                ],
                shape: BoxShape.circle,
                border: Border.all(color: AppThemeNotifier.border,width: 0.7)
              ),
              child: CustomPaint(

                size: isDialog??false?Size(90, 90): Size(120, 120),

                painter: GradientBorderPainter(

                  fillPercentage: percentageValue,
                  gradientStartColor: isDialog ?? false?AppThemeNotifier.primarySet2:gradientStartColor,
                  gradientEndColor: isDialog ?? false?Color(0xFFE47E63):gradientEndColor,
                  borderWidth: 12,

                ),
              ),
            ),
            // <CHANGE> Blurred image in the center
            Container(
              height: isDialog == true ? 80 : 110,
              width: isDialog == true ? 80 : 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppThemeNotifier.background,
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: blurSigma,
                    sigmaY: blurSigma,
                    tileMode: TileMode.mirror,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imagePath, // <-- your network URL string
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                    // This is important: CachedNetworkImage must be wrapped in a widget with size
                    // ClipOval + Container above already constrains it, so we're good

                    fadeInDuration: const Duration(milliseconds: 300),
                  ),
                ),
              ),
            ),
            // Container(
            //   height: isDialog??false?80: 110,
            //   width:isDialog??false?80: 110,
            //   decoration: BoxDecoration(
            //     shape: BoxShape.circle,
            //     border: Border.all(
            //       color: AppThemeNotifier.background,
            //       width: 1,
            //     ),
            //   ),
            //   child: ClipOval(
            //     child: ImageFiltered(
            //       imageFilter: ui.ImageFilter.blur(
            //         sigmaX: blurSigma,
            //         sigmaY: blurSigma,
            //         tileMode: TileMode.mirror,
            //       ),
            //       child: Container(
            //         decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage(imagePath),
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // <CHANGE> Percentage indicator at top
            // Positioned(
            //   top: 0,
            //   right: 0,
            //   child: Container(
            //     width: 50,
            //     height: 50,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Colors.white,
            //       border: Border.all(
            //         color: const Color(0xFF1a1a1a),
            //         width: 3,
            //       ),
            //     ),
            //     child: Center(
            //       child: Text(
            //         percentage,
            //         style: const TextStyle(
            //           fontSize: 12,
            //           fontWeight: FontWeight.bold,
            //           color: Color(0xFF1a1a1a),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
        isDialog??false?SizedBox(height: 12,): const SizedBox(height: 20),
        Text(
          isDialog??false?"$percentage" :"$title : $percentage",
          style:  TextStyles.bodyMedium.copyWith(

            color: AppThemeNotifier.textTertiary,
          ),
        ),
      ],
    );
  }
}

// <CHANGE> Custom painter for gradient border with fill animation
class GradientBorderPainter extends CustomPainter {
  final double fillPercentage;
  final Color gradientStartColor;
  final Color gradientEndColor;
  final double borderWidth;

  GradientBorderPainter({
    required this.fillPercentage,
    required this.gradientStartColor,
    required this.gradientEndColor,
    required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw gradient border with fill
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Create gradient shader
    final gradient = SweepGradient(
      colors: [gradientStartColor, gradientEndColor, gradientStartColor],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(
      Rect.fromCircle(center: center, radius: radius),
    );

    paint.shader = gradient;

    // Draw the arc based on fill percentage
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -90 * (3.14159 / 180), // Start from top
      360 * fillPercentage * (3.14159 / 180), // Draw arc based on percentage
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(GradientBorderPainter oldDelegate) {
    return oldDelegate.fillPercentage != fillPercentage;
  }
}
