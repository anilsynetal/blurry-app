
import 'package:blurry/core/services/binding.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/view/auth/login_screen.dart';
import 'package:blurry/presentation/view/profile/controller/change_password_screen.dart';
import 'package:blurry/presentation/view/profile/privacy_policy.dart';
import 'package:blurry/presentation/view/profile/term_condition.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/string.dart';
import '../../widgets/credit_widget.dart';
import '../../widgets/message_dialog.dart';
import '../auth/get_started_first.dart';
import 'controller/profile_controller.dart';
import 'edit_profile/edit_profile_screen.dart';
import 'help_support_bottom_sheet.dart';
import 'notification/notification_screen.dart';


class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppThemeNotifier.surface,
        elevation: 0,
        centerTitle: true,


        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Profile & Settings',
                  style: TextStyles.headlineMedium.copyWith(
                    color: AppThemeNotifier.textPrimary,
                  ),
                ),
                CreditBoxWidget(),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             Container(
               padding: EdgeInsets.all(14),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 border: Border.all(color: AppThemeNotifier.border,width: 1)
               ),
               child: Column(
                 children: [

                   Row(
                     children: [
                      Stack(
                        children: [
                          ClipOval(
                            child: Obx(
                              ()=> Container(
                                margin: EdgeInsets.all(5),
                                height: 45,
                                width: 45,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppThemeNotifier.primarySet1.withOpacity(0.5),
                                    width: 1,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: "${controller.imageUrl.value}",
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
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                              bottom: 10,
                              right: 2,
                              child: Container(
                                height: 13,
                                width: 13,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppThemeNotifier.onPrimary,width: 2),
                                  shape: BoxShape.circle,
                                  color: AppThemeNotifier.success2
                                ),
                              ))
                        ],
                      ),
                       5.width,
                       SizedBox(
                         width: Get.width*0.55,
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.start,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Text("${GetStorage().read(userNameKey)??""}",style: TextStyles.headlineMedium.copyWith(
                               color: AppThemeNotifier.textSecondary,
                             ) ,),
                             1.height,
                             Text("${GetStorage().read(emailKey)??""}",style: TextStyles.bodyMedium.copyWith(
                               color: AppThemeNotifier.textDisabled.withOpacity(0.8),
                               overflow: TextOverflow.ellipsis
                             ) ,)
                           ],
                         ),
                       ),
                       Spacer(),
                       InkWell(
                         onTap: (){
                           Get.to(()=>EditProfileScreen(),binding: EditProfileBinding());
                         },
                         child: CircleAvatar(
                           radius: 18,
                           backgroundColor:Color(0xFFF0F0F0),
                           child: Center(child: Image.asset("assets/icons/edit.png",height: 22,)),
                         ),
                       )
                     ],
                   ),
                   12.height,
                   Image.asset("assets/icons/divider_line.png",height: 1.5,),
                   12.height,
                   Obx(
                     ()=> Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         Flexible(child: Text("${controller.bioHome.value}",style: TextStyles.titleMedium.copyWith(fontSize: 15,color: AppThemeNotifier.textDisabled),)),
                       ],
                     ),
                   )
                 ],
               ),
             ),
              10.height,
              Obx(
                ()=> GestureDetector(
                  onTap: (){

                  },
                  child: Stack(
                    children: [
                      controller.isLoadMyPlan.value
                          ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 90, // Approximate height of a plan card
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      )
                          : (controller.selectedPlan.value.id == "" ||
                          controller.selectedPlan.value.id == null)
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Text(
                                "No Active Plan Yet 💡",
                                style: TextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                          :
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                               Color(0xFFD66649),
                                AppThemeNotifier.onPrimary
                              ]
                            )
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Row: Plan Name + Badge/Price
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                 "${controller.selectedPlan.value.name}",
                                  style: TextStyles.headlineMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color:  AppThemeNotifier.onPrimary,
                                    fontSize: 18,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,

                                    children: [

                                      Text(
                                  controller.selectedPlan.value.price.toString() == "0"?"FREE": "${ controller.selectedPlan.value.currency.toString()} ${ controller.selectedPlan.value.price.toString()}",
                                        style: TextStyles.headlineMedium.copyWith(
                                            color: AppThemeNotifier.onPrimary,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700
                                        ),
                                      ),
                                      Text(
                                          controller.selectedPlan.value.billingCycle == "" ||  controller.selectedPlan.value.billingCycle == null ?"":  "/${ controller.selectedPlan.value.billingCycle.toString().toLowerCase() == "monthly"?"M": controller.selectedPlan.value.billingCycle.toString().toLowerCase() == "yearly"?"Y": controller.selectedPlan.value.billingCycle.toString()}",
                                        style: TextStyles.headlineMedium.copyWith(
                                          color:Color(0xFFE0E0E0),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Credits Row


                            // Features Row
                            Row(
                              children: [

                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/selected_done.png",height: 16,color: AppThemeNotifier.textPrimary),
                                    SizedBox(width: 3),
                                    Text(
                                      "Up to ${controller.selectedPlan.value.matchesLimit} Matches!",
                                      style: TextStyles.bodySmall.copyWith(
                                        color: AppThemeNotifier.textPrimary,
                                        fontSize: 12,
                                      ),

                                    ),
                                  ],
                                ),
                                8.width,
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/icons/selected_done.png",height: 16,color: AppThemeNotifier.textPrimary,),
                                    SizedBox(width: 3),
                                    Text(
                                      "${controller.selectedPlan.value.loungeSwitches.toString().capitalizeFirst} lounge switches",
                                      style: TextStyles.bodySmall.copyWith(
                                        color: AppThemeNotifier.textPrimary,
                                        fontSize: 12,
                                      ),

                                    ),
                                  ],
                                ),
                              ]
                            ),
                            4.height

                            // Checkmark for selected plan

                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ),
              12.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text("Settings",style: TextStyles.titleMedium.copyWith(
                  color: AppThemeNotifier.textPrimary,
                ),),
              ),
              10.height,
              _buildCardDesign(
                title: "Notification",
                imagePath: "assets/icons/notification_ic.png",
                subTitle: "Message, group & call tones",
                onTap: (){
                  Get.to(()=>NotificationScreen(),binding: NotificationBinding());
                }
              ),
              8.height,

              GetStorage().read(userDataKey)["signupProvider"].toString() == "google" ||  GetStorage().read(userDataKey)["signupProvider"].toString() == "apple"?
                  SizedBox():
              _buildCardDesign(
                  title: "Password",
                  imagePath: "assets/icons/privacy.png",
                  subTitle: "Change passwords",
                  onTap: (){
                    Get.to(()=>ChangePasswordScreen(),binding: ChangePasswordBinding());
                  }
              ),
              8.height,
              _buildCardDesign(
                  title: "Account",
                  imagePath: "assets/icons/setting.png",
                  subTitle: "Privacy, security, change email or number",
                  onTap: (){
                    Get.to(()=>EditProfileScreen(),binding: EditProfileBinding());
                  }
              ),
              8.height,
              _buildCardDesign(
                  title: "Help & Support",
                  imagePath: "assets/icons/help_support.png",
                  subTitle: "Help centre, contact us",
                  onTap: (){
                    HelpSupportBottomSheet.show(context);
                  }
              ),
              8.height,
              _buildCardDesign(
                  title: "Terms of Service",
                  imagePath: "assets/icons/t_c.png",
                  subTitle: "",
                  onTap: (){
                    Get.to(()=>TermAndConditionScreen(),binding: TermConditionBinding());
                  }
              ),
              8.height,
              _buildCardDesign(
                  title: "Privacy Policy",
                  imagePath: "assets/icons/privacy_policy.png",
                  subTitle: "",
                  onTap: (){
                    Get.to(()=>PrivacyPolicyScreen(),binding: PrivacyPolicyBinding());
                  }
              ),
              8.height,
              _buildCardDesign(
                  title: "Delete Account",
                  imagePath: "assets/icons/deleteaccount.png",
                  subTitle: "Permanently delete your account",
                  onTap: (){
                     showDialog(
                      context: context,
                      builder: (context) => _buildDeleteAccountDialog(context),
                    );
                  }
              ),
              8.height,
              _buildCardDesign(
                  title: "Logout",
                  imagePath: "assets/icons/logout.png",
                  subTitle: "",
                  onTap: (){
                    showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Obx(
                          ()=> CupertinoMessageCustomDialog(
                            topImage: Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Image.asset("assets/icons/logout_new.png",height: 50,),
                            ),
                            heading: 'Logout',
                            title: 'Are you sure do you want to logout ?',
                            leftButtonText: 'No',
                            onLeftButtonTap: () {
                              Navigator.pop(context);

                            },
                            rightButtonText: controller.isLogoutLoad.value ?"Loading..": 'Yes',
                            onRightButtonTap: () {
                              controller.logout();
                            },

                          ),
                        );
                      },
                    );
                  }
              )

            ],
          ),
        ),
      ),
    );
  }


  _buildCardDesign(
  {required String imagePath,required String title, required String subTitle, required Callback onTap}
      ){
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppThemeNotifier.border,width: 1),
          borderRadius: BorderRadius.circular(50)
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFF0F0F0),
              child: Center(
                child: Image.asset(imagePath,height:title == "Logout"?16: 23,color: AppThemeNotifier.textPrimary,),
                
              ),
            ),
            8.width,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: TextStyles.titleMedium.copyWith(color: AppThemeNotifier.textPrimary,fontSize: 15),),

                subTitle == ""?SizedBox():  Text(subTitle,style: TextStyles.labelSmall.copyWith(color: AppThemeNotifier.textDisabled.withOpacity(0.6)),),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded,color: AppThemeNotifier.textSecondary,size: 16,)
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountDialog(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Delete Account",
              style: TextStyles.headlineMedium.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            20.height,
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFFF5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.red, size: 24),
                      8.width,
                      Text(
                        "Warning",
                        style: TextStyles.titleMedium.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  8.height,
                  _buildBulletPoint("Permanent removal from all Lounges"),
                  4.height,
                  _buildBulletPoint("Deletion of all chat history"),
                  4.height,
                  _buildBulletPoint("Loss of profile & unblurred image access"),
                ],
              ),
            ),
            24.height,
            Obx(() => controller.isLoadingDelete.value
                ? CircularProgressIndicator(color: Colors.red)
                : SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD32F2F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        controller.deleteAccount();
                      },
                      child: Text(
                        "Delete My Account",
                        style: TextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )),
            16.height,
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Text(
                "Cancel and return",
                style: TextStyles.bodyMedium.copyWith(
                  color: AppThemeNotifier.clickableText,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6.0),
          child: CircleAvatar(radius: 2, backgroundColor: Colors.black),
        ),
        8.width,
        Expanded(
          child: Text(
            text,
            style: TextStyles.bodyMedium.copyWith(color: Colors.black87),
          ),
        ),
      ],
    );
  }
}




class GuestProfileScreen extends StatelessWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppThemeNotifier.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile & Settings',
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppThemeNotifier.border, width: 1),
                  color: AppThemeNotifier.surface,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppThemeNotifier.primarySet1.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 48,
                        color: AppThemeNotifier.primarySet1,
                      ),
                    ),
                    16.height,
                    Text(
                      'Welcome Guest! 👋',
                      style: TextStyles.headlineMedium.copyWith(
                        color: AppThemeNotifier.textPrimary,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    8.height,
                    Text(
                      'Login or sign up to unlock your full profile',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppThemeNotifier.textDisabled.withOpacity(0.7),
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    20.height,
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: gradientButton(
                        onPressed: () {
                          GetStorage().erase();
                          Get.off(()=>LoginScreen(),binding: LoginBinding());

                        },
                        buttonText: 'Login / Sign Up',
                      ),
                    ),
                  ],
                ),
              ),
              24.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Info & Support',
                  style: TextStyles.titleMedium.copyWith(
                    color: AppThemeNotifier.textPrimary,
                  ),
                ),
              ),
              10.height,
              _buildCardDesign(
                title: 'Terms of Service',
                imagePath: 'assets/icons/t_c.png',
                subTitle: '',
                onTap: () {
                  Get.to(() => TermAndConditionScreen(),
                      binding: TermConditionBinding());
                },
              ),
              8.height,
              _buildCardDesign(
                title: 'Privacy Policy',
                imagePath: 'assets/icons/privacy_policy.png',
                subTitle: '',
                onTap: () {
                  Get.to(() => PrivacyPolicyScreen(),
                      binding: PrivacyPolicyBinding());
                },
              ),
              8.height,
              _buildCardDesign(
                title: 'Help & Support',
                imagePath: 'assets/icons/help_support.png',
                subTitle: 'Contact us, FAQ',
                onTap: () {
                  HelpSupportBottomSheet.show(context);
                  // Navigate to help screen
                },
              ),
              20.height,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardDesign({
    required String imagePath,
    required String title,
    required String subTitle,
    required Callback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppThemeNotifier.border, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFF0F0F0),
              child: Center(
                child: Image.asset(
                  imagePath,
                  height: 23,
                  color: AppThemeNotifier.textPrimary,
                ),
              ),
            ),
            8.width,
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.titleMedium.copyWith(
                    color: AppThemeNotifier.textPrimary,
                    fontSize: 15,
                  ),
                ),
                subTitle == ''
                    ? SizedBox()
                    : Text(
                  subTitle,
                  style: TextStyles.labelSmall.copyWith(
                    color: AppThemeNotifier.textDisabled.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppThemeNotifier.textSecondary,
              size: 16,
            )
          ],
        ),
      ),
    );
  }
}
