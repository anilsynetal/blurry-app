import 'dart:ui' as ui;

import 'package:blurry/core/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import '../../../../core/services/binding.dart';
import '../../chat_view/views/chat_screen.dart';
import '../controller/plan_your_date_controller.dart';
import '../model/date_plan_model.dart';

class PlanYourDateScreen extends GetView<PlanYourDateController> {
  const PlanYourDateScreen({super.key});

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
          "Plan Your Date",
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(
              () {
            if (controller.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppThemeNotifier.primary,
                ),
              );
            }

            // if (controller.errorMessage.isNotEmpty) {
            //   return Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text(
            //           'Failed to load date plans',
            //           style: TextStyles.titleMedium.copyWith(
            //             color: AppThemeNotifier.textPrimary,
            //           ),
            //         ),
            //         12.height,
            //         Text(
            //           controller.errorMessage.value,
            //           style: TextStyles.bodyMedium.copyWith(
            //             color: AppThemeNotifier.textSecondary,
            //           ),
            //           textAlign: TextAlign.center,
            //         ),
            //         20.height,
            //         commonButton(
            //           buttonText: 'Retry',
            //           onPressed: () {
            //             controller.fetchDatePlans();
            //           },
            //         ),
            //       ],
            //     ),
            //   );
            // }

            if (controller.datePlans.isEmpty) {
              return Center(
                child: Text(
                  'No date plans available',
                  style: TextStyles.titleMedium.copyWith(
                    color: AppThemeNotifier.textPrimary,
                  ),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...List.generate(
                      controller.datePlans.length,
                          (index) {
                        final datePlan = controller.datePlans[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index < controller.datePlans.length - 1 ? 10 : 0,
                          ),
                          child: _buildDateCard(
                            datePlan: datePlan,
                            isSelected: controller.selectedOption.value == datePlan.id,
                          ),
                        );
                      },
                    ),
                    16.height,
                    Row(
                      children: [
                        Flexible(
                          child: Divider(
                            color: AppThemeNotifier.border,
                            height: 1,
                            thickness: 1,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppThemeNotifier.textDisabled.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Or',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppThemeNotifier.textSecondary,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Divider(
                            color: AppThemeNotifier.border,
                            height: 1,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Propose your own idea',
                          style: TextStyles.titleMedium.copyWith(
                            color: AppThemeNotifier.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    12.height,
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppThemeNotifier.border,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        color: AppThemeNotifier.background,
                      ),
                      child: TextField(
                        controller: controller.ideaController.value,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText:
                          'Dinner at Olive Bistro? Or let\'s try something wild...',
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: AppThemeNotifier.textDisabled,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppThemeNotifier.textPrimary,
                        ),
                      ),
                    ),
                    32.height,
                    Row(
                      children: [
                        Flexible(
                          child: commonButton(
                            type: ButtonType.outlined,
                            backgroundColor:
                            AppThemeNotifier.textDisabled.withOpacity(0.3),
                            textColor: AppThemeNotifier.textPrimary,
                            height: 50,
                            buttonText: 'Back to chat',
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                        30.width,
                        Flexible(
                          child: Obx(
                            ()=> gradientButton(
                              isLoading: controller.isLoadSendToMatch.value,
                              textColor: AppThemeNotifier.onPrimary,
                              height: 50,
                              buttonText: 'Send to match',
                              onPressed: () {
                                controller.sendDateProposal(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.height,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDateCard({
    required DatePlanData datePlan,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        print( "${imageBaseUrl}${datePlan.templateImage}");
        controller.selectDateOption(datePlan);
      },
      child: Container(
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: GradientBoxBorder(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isSelected
                  ? [
                AppThemeNotifier.primarySet1,
                AppThemeNotifier.primarySet2,
                AppThemeNotifier.primarySet3,
              ]
                  : [
                Colors.transparent,
                Colors.transparent,
                Colors.transparent,
              ],
            ),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              // Blurred background image
              Positioned.fill(
                child: ImageFiltered(
                  enabled: true,
                  imageFilter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                  child: Image.network(
                    "${imageBaseUrl}${datePlan.templateImage}",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/plan_date_bg.png',
                        fit: BoxFit.cover,
                        colorBlendMode: BlendMode.colorBurn,
                      );
                    },
                    colorBlendMode: BlendMode.colorBurn,
                  ),
                ),
              ),

              // 🔥 Add semi-transparent black overlay here
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.19), // Black overlay with 12% opacity
                ),
              ),

              // Foreground content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      datePlan.title ?? 'Date Plan',
                      style: TextStyles.titleLarge.copyWith(
                        color: AppThemeNotifier.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    8.height,
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        datePlan.description ?? 'Discover something amazing',
                        style: TextStyles.labelMedium.copyWith(
                          color: AppThemeNotifier.onPrimary.withOpacity(0.9),
                          height: 1.3,
                        ),
                      ),
                    ),
                    8.height,
                    Row(
                      children: [
                        // Cost badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppThemeNotifier.onPrimary,
                          ),
                          child: Text(
                            '€ ${datePlan.costType ?? 'Medium'}',
                            style: TextStyles.labelMedium.copyWith(
                              color: AppThemeNotifier.textPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        8.width,
                        // Type badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppThemeNotifier.onPrimary,
                          ),
                          child: Text(
                            '${datePlan.type ?? 'Standard'}',
                            style: TextStyles.labelMedium.copyWith(
                              color: AppThemeNotifier.textPrimary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Choose This button
                        gradientButton(
                          width: 90,
                          height: 32,
                          buttonText: 'Choose This',
                          textStyle: TextStyles.labelMedium.copyWith(
                            color: AppThemeNotifier.onPrimary,
                          ),
                          onPressed: () {
                            controller.selectDateOption(datePlan);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )

    );
  }
}
