import 'package:blurry/core/services/binding.dart';
import 'package:blurry/presentation/view/unblur/view/plan_your_date_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import '../controller/unblur_controller.dart';

class UnblurDecisionScreen extends GetView<UnblurController> {

  const UnblurDecisionScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        centerTitle: false,

        title: Text(
          "What's Next",
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,

          ),
        ),

      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile image
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You have fully unblured each other!",style: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.textDisabled),),
                  ],
                ),
                16.height,
                Container(
                  height: 185,
                  width: 185,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppThemeNotifier.success2,
                      width: 4,
                    ),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: controller.profileImage.value, // <-- your network URL (String)
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.broken_image_outlined,
                          color: Colors.red,
                          size: 60,
                        ),
                      ),
                      fadeInDuration: const Duration(milliseconds: 400),
                      memCacheWidth: 512,   // optional: cache at higher res for crisp zoom
                      memCacheHeight: 512,
                    ),
                  ),
                ),
                // Container(
                //   height: 185,
                //   width: 185,
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     border: Border.all(
                //       color: AppThemeNotifier.success2,
                //       width: 4,
                //     ),
                //   ),
                //   child: ClipOval(
                //     child: Container(
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: AssetImage("assets/images/unblure_image.png"),
                //           fit: BoxFit.cover,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 24),
                // Profile info
                Text(
                  '${controller.profileName.value}, ${controller.profileAge.value}',
                  style: TextStyles.headlineLarge.copyWith(
                    color: AppThemeNotifier.textPrimary,
                    fontSize: 16

                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.profileLocation.value,
                  style: TextStyles.bodyMedium.copyWith(
                    fontSize: 13,
                    color: AppThemeNotifier.textDisabled,

                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: AppThemeNotifier.shadow,thickness: 1,
                    height: 1,
                ),
                const SizedBox(height: 30),
                // Action buttons
                gradientButton(onPressed: () async {
                await  Get.to(()=>PlanYourDateScreen(),binding: PlanYourDateBinding(targetUserId: controller.targetUserId.toString(),matchId: controller.matchId.toString()));
                Get.back();

                },
                buttonText: "Let’s go on a date"
                ),
                5.height,
                Text("Move this match forward",style: TextStyles.bodySmall.copyWith(fontSize: 11,color: Color(0xFF35A218)),),

                const SizedBox(height: 16),
                commonButton(onPressed: (){
                  Get.back();
                },
                    backgroundColor: AppThemeNotifier.textDisabled.withOpacity(0.3),
                    textColor: AppThemeNotifier.textPrimary,
                    buttonText: "Maybe next time",
                  type: ButtonType.outlined
                ),
                5.height,
                Text("Archives this match",style: TextStyles.bodySmall.copyWith(fontSize: 11,color: AppThemeNotifier.textDisabled.withOpacity(0.7)),),


                const SizedBox(height: 16),
                Obx(
                  ()=> commonButton(
                      isLoading: controller.stopChatLoad.value,
                      onPressed:controller.onStopConversation,
                      backgroundColor: AppThemeNotifier.primarySet2,
                      textColor: AppThemeNotifier.primarySet2,
                      buttonText: "Lets Stop here",
                      type: ButtonType.outlined
                  ),
                ),
                5.height,
                Text("Ends the conversation for both of you",style: TextStyles.bodySmall.copyWith(fontSize: 11,color: Color(0xFFE47E63)),),

              ],
            ),
          ),
        ),
      ),
    );
  }


}
