import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/utils/string.dart';
import '../../widgets/box_decoration.dart';
import '../../widgets/what_longes.dart';
import 'lounge_controller.dart';
import 'lounge_model.dart';
import 'model/lounge_list_response_model.dart';


class LoungeSelectionScreen extends GetView<LoungeController> {
  const LoungeSelectionScreen({super.key});

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
        leading: GestureDetector(
            onTap: (){
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Center(child: Image.asset(back_ic,height: 24,)),
            )
        ),

        title: Column(
          children: [
            Text(
              'Find Your Vibe',
              style: TextStyles.headlineLarge.copyWith(
                  color: AppThemeNotifier.textTertiary,
                  fontSize: 19,
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    'Hop into a lounge that matches your mood. You can switch again in 24 hours.',
                    textAlign: TextAlign.center,

                    style: TextStyles.bodySmall.copyWith(
                      fontSize: 12,
                      color: AppThemeNotifier.textSecondary,

                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      showLoungeInfoDialog(context);
                    },
                    child: Text(
                      "What's a Lounge?",
                      style: TextStyles.bodySmall.copyWith(
                        fontSize: 12,
                        color: Color(0xFF5686FF),
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF5686FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                child: Obx(
                  ()=> Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      controller.isLoading.value?
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.9,
                    ),
                    itemCount:4,
                    itemBuilder: (context, index) {
                      return _buildLoungeCardShimmer();
                    },
                  )
                          :
                      // Grid of lounge cards (2 columns)
                      controller.lounges.isEmpty
                        ? Padding(
                          padding: const EdgeInsets.only(top: 100,bottom: 100),
                          child: Text(
                            "No Lounges Found",
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppThemeNotifier.textPrimary,
                            ),
                          ),
                        )
                        : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: controller.lounges.length,
                        itemBuilder: (context, index) {
                          return _buildLoungeCard(controller.lounges[index]);
                        },
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: gradientButton(
                          height: 48,
                          buttonText: 'Continue',
                          onPressed:(){
                            controller.continueWithLounge(context);
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildCountdownCard(),



                  // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                      //   decoration: gradientDarkBox(),
                      //   child: Center(child: Text("🕒 Time left in your current lounge: 13h 45m",style: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.onPrimary),)),
                      // ),

                      // _buildCountdownCard(),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLoungeCard(LoungesData lounge) {
    return Obx(() {
      final isSelected = controller.selectedLounge.value.id.toString() == lounge.id.toString();

      return GestureDetector(
        onTap: () => controller.selectLounge(lounge),
        child: Container(
          decoration: BoxDecoration(
            border: isSelected
                ? GradientBoxBorder(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppThemeNotifier.primarySet1,
                  AppThemeNotifier.primarySet2,
                  AppThemeNotifier.primarySet3,
                ],
              ),
              width: 1.2,
            )
                : null,
            borderRadius: BorderRadius.circular(22),
          ),
          padding: EdgeInsets.all(3),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Stack(
              children: [
                /// ⭐ Blurred Background Image
                ImageFiltered(
                  imageFilter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: CachedNetworkImage(
                    imageUrl: lounge.bannerImage == "" || lounge.bannerImage == "null"
                        ? ""
                        : imageBaseUrl + lounge.bannerImage.toString(),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (_, __) => shimmerBox(height: 180),
                    errorWidget: (_, __, ___) => Container(
                      child: Image.asset("assets/images/image_bg.jpg",fit: BoxFit.cover,)
                    ),
                  ),
                ),

                /// ⭐ Foreground Content
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// ⭐ Circular Avatar Image
                      SizedBox(
                        width: 55,
                        height: 55,
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: imageBaseUrl + lounge.image.toString(),
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                shimmerBox(height: 55, width: 55, radius: 55),
                            errorWidget: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                CupertinoIcons.person_alt_circle_fill,
                                color: Colors.grey,
                                size: 55,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Column(
                        children: [
                          const SizedBox(height: 3),
                          Text(
                            lounge.name.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyles.headlineMedium.copyWith(
                              color: AppThemeNotifier.onPrimary,
                              fontSize: 16,
                              height: 1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              lounge.description.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyles.labelMedium.copyWith(
                                color: AppThemeNotifier.onPrimary,
                                height: 1.3,
                                fontSize: 9,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 5),

                      /// ⭐ Tags
                      Wrap(
                        spacing: 8,
                        alignment: WrapAlignment.center,
                        children: lounge.tags!.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppThemeNotifier.background,
                            ),
                            child: Text(
                              tag,
                              style: TextStyles.labelSmall.copyWith(
                                color: AppThemeNotifier.textPrimary,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
  // Widget _buildLoungeCard(LoungesData lounge) {
  //   return Obx(() {
  //     final isSelected = controller.selectedLounge.value.id.toString() == lounge.id.toString();
  //
  //     return GestureDetector(
  //       onTap: () => controller.selectLounge(lounge),
  //       child:  Container(
  //         decoration: BoxDecoration(
  //           border: isSelected? GradientBoxBorder(
  //             gradient:
  //             LinearGradient(
  //                 begin: Alignment.topCenter,
  //                 end:  Alignment.bottomCenter,
  //                 colors: [
  //                   AppThemeNotifier.primarySet1,
  //                   AppThemeNotifier.primarySet2,
  //                   AppThemeNotifier.primarySet3,
  //                 ]),
  //             width: 1.2,
  //           ):null,
  //           borderRadius: BorderRadius.circular(22),
  //         ),
  //         padding: EdgeInsets.all(3),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(22),
  //           child: Stack(
  //             children: [
  //               // <CHANGE> Blurred background image only
  //               ImageFiltered(
  //                 imageFilter: ui.ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0,tileMode: TileMode.mirror),
  //                 child:
  //                 Container(
  //                   decoration: BoxDecoration(
  //                     image: DecorationImage(
  //                       image:
  //                       lounge.bannerImage == "" || lounge.bannerImage.toString() == "null"?
  //                           AssetImage("assets/images/lounge_background_1.png")
  //                           :
  //                       NetworkImage(imageBaseUrl+lounge.bannerImage.toString(),
  //                       ),
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //               // <CHANGE> Sharp content on top
  //               Container(
  //                 padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: [
  //                     Container(
  //                       width: 55,
  //                       height: 55,
  //
  //                       child: ClipOval(
  //                         child: Image.network(
  //                           imageBaseUrl+lounge.image.toString(),
  //                           fit: BoxFit.cover,
  //                         ),
  //                       ),
  //                     ),
  //                     Column(
  //                       children: [
  //                         3.height,
  //                         Text(
  //                           lounge.name.toString(),
  //                           textAlign: TextAlign.center,
  //                           style: TextStyles.headlineMedium.copyWith(
  //                             color: AppThemeNotifier.onPrimary,
  //                             fontSize: 16,
  //                             height: 1,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 6),
  //                         Padding(
  //                           padding: const EdgeInsets.symmetric(horizontal: 5.0),
  //                           child: Text(
  //                             lounge.description.toString(),
  //                             textAlign: TextAlign.center,
  //                             style: TextStyles.labelMedium.copyWith(
  //                               color: AppThemeNotifier.onPrimary,
  //                               height: 1.3,
  //                               fontSize: 9,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     5.height,
  //                     Wrap(
  //                       spacing: 8,
  //                       alignment: WrapAlignment.center,
  //                       children: lounge.tags!.map((tag) {
  //                         return Container(
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: 8,
  //                             vertical: 4,
  //                           ),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(20),
  //                             color: AppThemeNotifier.background,
  //                           ),
  //                           child: Text(
  //                             tag,
  //                             style: TextStyles.labelSmall.copyWith(
  //                               color: AppThemeNotifier.textPrimary,
  //                               fontSize: 9,
  //                               fontWeight: FontWeight.w600,
  //                             ),
  //                           ),
  //                         );
  //                       }).toList(),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   });
  // }

  Widget _buildCountdownCard() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
            decoration: gradientDarkBox(),
            child: Center(child: Text( '⏳Next switch in ${controller.formattedCountdown}',style: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.onPrimary),)),
          ),
        ],
      );
    });
  }


  Widget _buildLoungeCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,

      child: Container(
        margin: EdgeInsets.all(2),

        height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
  Widget shimmerBox({double height = 100, double width = double.infinity, double radius = 0}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

}
