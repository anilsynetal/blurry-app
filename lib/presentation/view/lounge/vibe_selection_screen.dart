import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import 'vibe_controller.dart';

class VibeSelectionScreen extends GetView<VibeController> {
  const VibeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppThemeNotifier.surface,
        elevation: 0,

        leading: GestureDetector(
          onTap: controller.goBack,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Center(child: Image.asset(back_ic,height: 24,)),
          )
        ),

        title: Text(
          'What\'s Your Vibe?',
          style: TextStyles.headlineLarge.copyWith(
              color: AppThemeNotifier.textTertiary,
              fontSize: 19,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // <CHANGE> Description text
              Text(
                'Others will see this on your lounge card before the photo reveals more.',
                textAlign: TextAlign.start,

                style: TextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppThemeNotifier.textSecondary,

                ),
              ),
              const SizedBox(height: 24),

              // <CHANGE> Text input field for vibe description
              Obx(() {
                return Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppThemeNotifier.border,
                          width: 1,
                        ),
                      ),
                      child: TextField(
                        controller: controller.vibeDescription.value,
                        maxLines: 6,
                        maxLength: 100,

                        decoration: InputDecoration(
                          hintText: 'Describe yourself in one sentence...',
                          hintStyle: TextStyles.bodySmall.copyWith(
                            color: AppThemeNotifier.textSecondary,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                          counterText: '',
                        ),
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppThemeNotifier.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,right: 10,
                      child:
                Obx(
                  ()=> Text(
                  '${controller.charLength.value}/100',
                  style: TextStyles.labelSmall.copyWith(
                  color: AppThemeNotifier.textDisabled,
                  fontSize: 12,
                  ),
                  ),
                ),)
                  ],
                );
              }),

              // <CHANGE> Character counter
              // Obx(() {
              //   return Align(
              //     alignment: Alignment.bottomRight,
              //     child: Padding(
              //       padding: const EdgeInsets.only(top: 8, right: 16),
              //       child: Text(
              //         '${controller.characterCount.value}/${controller.maxCharacters}',
              //         style: TextStyles.labelSmall.copyWith(
              //           color: AppThemeNotifier.textSecondary,
              //           fontSize: 12,
              //         ),
              //       ),
              //     ),
              //   );
              // }),

              const SizedBox(height: 50),

              // <CHANGE> Inspiration section title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Need Inspiration For Your Punchline',
                    textAlign: TextAlign.center,
                    style: TextStyles.titleMedium.copyWith(
                      color: AppThemeNotifier.textPrimary,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      decorationColor: AppThemeNotifier.textPrimary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // <CHANGE> Suggested punchlines grid
              Obx(() {
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: controller.suggestedPunchlines.map((punchline) {


                    return GestureDetector(
                      onTap: (){
                        if ((controller.vibeDescription.value.text + punchline.toString()).length <= 100) {
                          controller.vibeDescription.value.text += punchline.toString();
                        } else {
                          showWarningMessage("Maximum 100 characters are allowed");
                        }



                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                            gradient:
                            LinearGradient(
                                begin: Alignment.topCenter,
                                end:  Alignment.bottomCenter,
                                colors: [
                                  AppThemeNotifier.primarySet2,
                                  AppThemeNotifier.primarySet2.withOpacity(0.9),
                                  AppThemeNotifier.primarySet3,
                                ]),
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(24),


                        ),
                        child: Text(
                          punchline,
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppThemeNotifier.textPrimary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),

              const SizedBox(height: 80),

              // <CHANGE> Post button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  ()=> gradientButton(
                    height: 50,
                    isLoading: controller.isLoad.value,
                    buttonText: 'Post To ${controller.selectedLounges.name.toString()}',
                    onPressed: controller.joinVibe,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}