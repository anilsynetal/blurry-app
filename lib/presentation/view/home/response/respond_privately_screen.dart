import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';

import '../../../../core/utils/string.dart';
import '../home_controller.dart';
import '../model/lounges_response_model.dart';
import 'respond_privately_controller.dart';

class RespondPrivatelyScreen extends GetView<RespondPrivatelyController> {

   RespondPrivatelyScreen({super.key});

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
          'Respond Privately',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRespondingToSection(),
              const SizedBox(height: 5),
              _buildPunchlineCard(),
              const SizedBox(height: 10),
              _buildResponseInputSection(),

            ],
          ),
        ),
      ),
      bottomNavigationBar:   Padding(
        padding: const EdgeInsets.only(bottom: 50.0,left: 20,right: 20),
        child: _buildActionButtons(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {

    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppThemeNotifier.surface,
      elevation: 0,
      leading: GestureDetector(
        onTap: controller.goBack,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: AppThemeNotifier.textPrimary,
              size: 24,
            ),
          ),
        ),
      ),
      title: Text(
        'Respond Privately',
        style: TextStyles.headlineMedium.copyWith(
          color: AppThemeNotifier.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRespondingToSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'You\'re responding to this punchline:',
          textAlign: TextAlign.start,

          style: TextStyles.bodySmall.copyWith(
            fontSize: 12,
            color: AppThemeNotifier.textSecondary,

          ),
        ),
      ],
    );
  }

  Widget _buildPunchlineCard() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              SizedBox(
                height:142,

                width: Get.width,
                child: ImageFiltered(

                  imageFilter: ui.ImageFilter.blur(
                    sigmaX: 14.0,
                    sigmaY: 14.0,
                    tileMode: TileMode.mirror,
                  ),
                  child:CachedNetworkImage(
                    imageUrl: "${imageBaseUrl}${controller.profile.user!.avatar.toString()}",
                    fit: BoxFit.fill,
                    placeholder:(context, url) {
                      return Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/list_card_bg.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } ,
                    errorWidget: (context, url, error) => Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/list_card_bg.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 142,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Container(
                height: 142,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // User name and age
                      Row(
                        children: [
                          Text(
                            '${controller.profile.user!.name}',
                            style: TextStyles.titleMedium.copyWith(
                              color: AppThemeNotifier.onPrimary,

                            ),
                          ),
                          8.width,
                          Image.asset("assets/icons/verify.png",height: 16,)
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Punchline
                      Text(
                        controller.profile.vibeDescription.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.bodySmall.copyWith(
                          color: AppThemeNotifier.onPrimary,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Location and age info
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color:AppThemeNotifier.background,
                            ),
                            child: Row(
                              children: [
                                Image.asset("assets/icons/uil_18-plus.png",height: 16,),
                                const SizedBox(width: 4),
                                Text(
                                "${  controller.profile.user?.age??""}",
                                  style: TextStyles.labelMedium.copyWith(
                                    color: AppThemeNotifier.textPrimary,
                                    fontSize: 11,

                                  ),
                                ),
                              ],
                            ),
                          ),
                          8.width,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color:AppThemeNotifier.background,
                            ),
                            child: Row(
                              children: [
                                Image.asset("assets/icons/distance.png",height: 16,),
                                const SizedBox(width: 4),
                                Text(
                                  "${  controller.profile.user?.cityName??""}",
                                  style: TextStyles.labelMedium.copyWith(
                                    color: AppThemeNotifier.textPrimary,
                                    fontSize: 11,

                                  ),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildResponseInputSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppThemeNotifier.border,
                    width: 0.8,
                  ),
                ),
                child: TextField(
                  onChanged: controller.updateResponse,
                  maxLines: 5,
                  maxLength: controller.maxCharacters,
                  decoration: InputDecoration(
                    hintText: 'Send your spark!...',
                    hintStyle: TextStyles.bodySmall.copyWith(
                      color: AppThemeNotifier.textDisabled,
                      fontSize: 12,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    counterText: '',
                  ),
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppThemeNotifier.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 16,
                child: Text(
                  '${controller.characterCount.value}/${controller.maxCharacters}',
                  style: TextStyles.labelSmall.copyWith(
                    color: AppThemeNotifier.textDisabled,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildActionButtons(context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppThemeNotifier.border,
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: controller.goBack,
              borderRadius: BorderRadius.circular(35),
              child: Center(
                child: Text(
                  'Cancel',
                  style: TextStyles.titleMedium.copyWith(
                    color: AppThemeNotifier.textTertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(
            ()=> gradientButton(
              isLoading: controller.isLoading.value,
              height: 48,
              buttonText: 'Send Response',
              onPressed: (){
                controller.sendResponse(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
