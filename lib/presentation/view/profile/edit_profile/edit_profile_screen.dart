import 'dart:io';

import 'package:blurry/core/utils/export.dart';
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/presentation/widgets/credit_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/typography.dart';
import '../../../widgets/common_button.dart';
import '../../../widgets/custom_dropdown.dart';
import '../../../widgets/custom_text_field.dart';

import 'edit_profile_controller.dart';

class EditProfileScreen extends GetView<EditProfileController> {
  const EditProfileScreen({super.key});

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
            )),
        centerTitle: false,
        title: Text(
          "Edit Profile",
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Photo Section
              _buildProfilePhotoSection(),

              18.height,
              // Your Information Section
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Your Information',
                  style: TextStyles.headlineMedium.copyWith(
                    color: AppThemeNotifier.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
              15.height,
              // Name Field
              _buildFormField(
                label: 'Your Name',
                maxLength: 30,
                keyboardType: TextInputType.name,
                controller: controller.nameController.value,
                icon: "assets/bottom_tab/user_prefix.png",
                helperText: 'This will be shown on your profile.',
              ),
              16.height,
              // City Field
              Obx(
                ()=> CommonDropDown<String>(
                  title: "",
                  borderRadius: 12,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 8),
                    child: Image.asset(
                      "assets/bottom_tab/location_prefix.png",
                      height: 22,
                    ),
                  ),
                  hintText: 'Cities/Provinces',
                  value: controller.locationCtrl.value == "" ? null : controller.locationCtrl.value,
                  items: controller.cityList,
                  onChanged: (value) {
                    controller.locationCtrl.value = value!;
                  },
                  itemLabelBuilder: (item) => item ?? "",
                  fillColor: Colors.transparent,
                ),
              ),
              5.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'This will be shown on your profile.',
                    style: TextStyles.labelSmall.copyWith(
                      color: AppThemeNotifier.textSecondaryAlpha,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              // _buildFormField(
              //   label: 'Your City',
              //   controller: controller.cityController.value,
              //   icon: "assets/bottom_tab/location_prefix.png",
              //   helperText: 'This will be shown on your profile.',
              // ),
              16.height,
              // Age Field
              _buildFormField(
                label: 'Your Age',
                maxLength: 2,
                controller: controller.ageController.value,
                icon: "assets/bottom_tab/age_prefix.png",
                keyboardType: TextInputType.number,
                helperText: 'This will be shown on your profile.',
              ),
              16.height,
              // Punchline Field
              _buildFormField(
                label: 'Punchline',
                maxLength: 30,
                controller: controller.punchlineController.value,
                icon: "assets/bottom_tab/age_prefix.png",
                maxLines: 1,
                helperText: 'This will be shown on your profile.',
              ),
              16.height,
              // Punchline Field
              _buildFormField(
                label: 'Bio',
                maxLength: 30,
                controller: controller.bio.value,
                icon: "assets/bottom_tab/age_prefix.png",
                maxLines: 1,
                helperText: 'This will be shown on your profile.',
              ),
              16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Gender",style: TextStyles.titleMedium.copyWith(color: AppThemeNotifier.textPrimary),),
                ],
              ),
              4.height,
              GenderSelectionHorizontal(
                genders: controller.genders,
                selectedGender: controller.gender,
              ),
              22.height,
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16),
        child: Stack(
          children: [
            gradientButton(
              height: 48,
              buttonText: controller.isLoading.value
                  ? 'Saving...'
                  : 'Save Changes',
              onPressed: controller.isLoading.value
                  ? () {}
                  :(){
                controller.saveChanges(context);
              },
            ),
            if (controller.isImageUploading.value)
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppThemeNotifier.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      )),
    );
  }

  Widget _buildProfilePhotoSection() {
    return Column(
      children: [
        Obx(() {
          final image = controller.profileImage.value;
          return Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppThemeNotifier.primarySet1,
                          AppThemeNotifier.primarySet2,
                          AppThemeNotifier.primarySet3,
                        ]),
                    width: 2,
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: 
                
                image == null
                    ? ClipOval(
                    child: 
                    controller. profileImageUrl.value != ""?
                    CachedNetworkImage(
                      imageUrl: "${imageBaseUrl}${controller.profileImageUrl.value}",
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage("assets/icons/placeholder_user.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                        :
                    Image.asset(
                      "assets/icons/placeholder_user.png",
                      fit: BoxFit.cover,
                    ))
                    : ClipOval(
                  child: Image.file(
                    File(image.path),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Obx(() => GestureDetector(
                onTap: controller.isImageUploading.value
                    ? null
                    : controller.takeProfilePhoto,
                child: controller.isImageUploading.value
                    ? Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppThemeNotifier.surface,
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppThemeNotifier.textPrimary,
                        ),
                      ),
                    ),
                  ),
                )
                    : Image.asset(
                  "assets/images/camera_ic.png",
                  height: 42,
                ),
              )),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String icon,
    String? helperText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int ?maxLength ,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonTextField(
          controller: controller,
          hintText: label,
          keyboardType: keyboardType,
          maxLines: maxLines,
          borderRadius: 12,
          maxLength: maxLength??30,
          hintStyle: TextStyles.labelSmall.copyWith(
              color: AppThemeNotifier.textDisabled),
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8),
            child: Image.asset(
              icon,
              height: 20,
            ),
          ),
          fillColor: Colors.transparent,
        ),
        if (helperText != null) ...[
          5.height,
          Text(
            helperText,
            style: TextStyles.labelSmall.copyWith(
              color: AppThemeNotifier.textSecondaryAlpha,
              fontSize: 10,
            ),
          ),
        ],
      ],
    );
  }
}




class GenderSelectionHorizontal extends StatelessWidget {
  final List<String> genders;
  final RxString selectedGender;

  const GenderSelectionHorizontal({
    super.key,
    required this.genders,
    required this.selectedGender,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0.0),
        child: Row(
          children: List.generate(
            genders.length,
                (index) {
              final gender = genders[index];
              final isSelected = selectedGender.value == gender;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: AnimatedGenderCard(
                  gender: gender,
                  isSelected: isSelected,
                  onTap: () => selectedGender.value = gender,
                ),
              );
            },
          ),
        ),
      ),
    ));
  }
}

class AnimatedGenderCard extends StatelessWidget {
  final String gender;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimatedGenderCard({
    super.key,
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        splashColor: AppThemeNotifier.primarySet1.withOpacity(0.2),
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: isSelected
                ? LinearGradient(
              colors: [
                AppThemeNotifier.primarySet1,
                AppThemeNotifier.primarySet2,
                AppThemeNotifier.primarySet3,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: isSelected ? null : Colors.transparent,
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : AppThemeNotifier.border,
              width: 1
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Radio indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : AppThemeNotifier.primarySet2,
                    width: 1,
                  ),
                  color: isSelected ? null : Colors.transparent,
                  gradient: isSelected
                      ? LinearGradient(
                    colors: [
                      AppThemeNotifier.primarySet1.withOpacity(0.3),
                      AppThemeNotifier.primarySet3.withOpacity(0.3),
                    ],
                  )
                      : null,
                ),
                child: isSelected
                    ? Center(
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                )
                    : null,
              ),
              8.width,
              // Gender text
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyles.titleSmall.copyWith(
                  color: isSelected
                      ? Colors.white
                      : AppThemeNotifier.textSecondary,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
                child: Text(gender),
              ),
            ],
          ),
        ),
      ),
    );
  }
}