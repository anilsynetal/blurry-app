
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/view/plan/view/referrel_card.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/plan_price_controller.dart';
import '../model/plan_model.dart';

class PricingScreen extends GetView<PricingController> {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    // Add listener for "load more"
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 50 &&
          !controller.isLoadingMore.value &&
          controller.currentPage.value < controller.totalPages.value) {
        controller.fetchPlans(loadMore: true);
      }
    });
    return Scaffold(
      backgroundColor: AppThemeNotifier.surface,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppThemeNotifier.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Get Started with a Plan',
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,

          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Credits let you unblur photos and discover amazing people. Choose what works best for you!',
                textAlign: TextAlign.center,
                style: TextStyles.bodySmall.copyWith(
                  fontSize: 12,
                  color: AppThemeNotifier.textSecondary,

                ),
              ),
            ),
            Expanded(
              child: Obx(
                ()=> SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Header Description

                      const SizedBox(height: 12),

                      // Pricing Plans
                      controller.isLoading.value
                          ? buildShimmerLoading():
                       controller.plans.isEmpty
                         ? Padding(
                           padding: const EdgeInsets.only(top: 50),
                           child: Center(
                             child: Text(
                               "No Plans Available",
                               style: TextStyles.bodyMedium.copyWith(
                                 color: AppThemeNotifier.textPrimary,
                               ),
                             ),
                           ),
                         )
                         : Column(
                             children: [
                           ...List.generate(controller.plans.length, (index) {
                             return Padding(
                               padding: const EdgeInsets.only(bottom: 12),
                               child: Obx(()=> buildPlanCard(controller.plans[index],index,() { controller.selectPlan(controller.plans[index].id.toString());},controller.selectedPlan.value == controller.plans[index].id)),
                             );
                           },)
                         ],
                       ),



                      // Continue Button
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Obx(
                          ()=> gradientButton(
                            height: 48,
                            isLoading: controller.isLoadingPayment.value,
                            buttonText: 'Continue',
                            onPressed: (){
                              controller.continueToPlan();
                            },
                          ),
                        ),
                      ),
                      10.height,
                      // Referral Section
                      ReferralCardWidget(onTap: () { /* ... */ }),
                      30.height
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




}

Widget buildPlanCard(PricingPlan plan,int index,Callback onTap,bool isSelected  ) {
  return Obx(() {


    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Stack(
        children: [

          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(image: AssetImage("assets/images/price_card_bg_decorate.png")),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isSelected?[
                    AppThemeNotifier.primarySet1,
                    AppThemeNotifier.primarySet2,
                    AppThemeNotifier.primarySet3,
                  ]:[
                    AppThemeNotifier.surfaceContainer,
                    AppThemeNotifier.surfaceContainer,
                    AppThemeNotifier.surfaceContainer,
                  ],
                )


            ),
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row: Plan Name + Badge/Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plan.name.toString(),
                      style: TextStyles.headlineMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isSelected
                            ? AppThemeNotifier.onPrimary
                            : Color(0xFF111B2C),
                        fontSize: 17,
                      ),
                    ),
                    if (plan.badge != null)
                      Container(
                        width: 85,
                        height: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isSelected
                              ? AppThemeNotifier.onPrimary
                              : null,
                          gradient: isSelected?null: LinearGradient(colors:
                          index % 2 == 0 ?
                          [
                            AppThemeNotifier.primarySet3,
                            Color(0xFF8B6498)

                          ]
                              :
                          [
                            AppThemeNotifier.primarySet1,
                            AppThemeNotifier.primarySet3,

                          ]),
                          border: GradientBoxBorder(
                            gradient:
                            LinearGradient(
                                begin: Alignment.topCenter,
                                end:  Alignment.bottomCenter,
                                colors: [Color(0x4D3C3C3C),
                                  isSelected?AppThemeNotifier.onPrimary:Colors.transparent
                                ]),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            plan.badge!,
                            style: TextStyles.labelSmall.copyWith(
                              color: isSelected
                                  ? AppThemeNotifier.textTertiary
                                  : AppThemeNotifier.onPrimary,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 7),

                // Credits Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: isSelected
                              ? null
                              : Color(0xFFE0E0E0),
                          gradient: isSelected?
                          LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF11B2C38).withOpacity(0.6),
                                Color(0xFF11B2C38).withOpacity(0.5),
                                Color(0xFF11B2C38).withOpacity(0.4),
                                Color(0xFF11B2C38).withOpacity(0.3),

                              ]):null
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset("assets/icons/diamond_shine.png",height: 18,color: isSelected ? AppThemeNotifier.onPrimary : AppThemeNotifier.textDisabled,),

                          const SizedBox(width: 4),
                          Text(
                            "${plan.credits.toString()} Credits",
                            style: TextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppThemeNotifier.onPrimary
                                  : AppThemeNotifier.textDisabled,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    isSelected?    Image.asset("assets/icons/selected_done2.png",height: 30,):SizedBox(),
                    // plan.badge.toString().toLowerCase() == "free"?SizedBox():
                    plan.price.toString() == "0"?SizedBox():   Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                           "${plan.currency.toString()} ${plan.price.toString()}",
                            style: TextStyles.headlineMedium.copyWith(
                                color:isSelected?AppThemeNotifier.onPrimary: AppThemeNotifier.textTertiary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700
                            ),
                          ),
                          Text(
                            plan.billingCycle == "" ||  plan.billingCycle == null ?"":    "/${plan.billingCycle.toString().toLowerCase() == "monthly"?"M":plan.billingCycle.toString().toLowerCase() == "yearly"?"Y":plan.billingCycle.toString()}",
                            style: TextStyles.headlineMedium.copyWith(
                              color:isSelected?AppThemeNotifier.onPrimary: AppThemeNotifier.textDisabled,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Features Row
                Row(
                  children:
                  // List.generate(plan.features.length, (index) {
                  List.generate(2, (index) {
                    return
                      Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Row(
                        children: [
                          Image.asset(
                            isSelected?
                            "assets/icons/selected_done.png":
                            "assets/icons/unselected_done.png",height: 14,),
                          SizedBox(width: 5),
                          Text(
                            index == 0 ?"Up to ${plan.matchesLimit} Matches!":"${plan.loungeSwitches.toString().capitalizeFirst} lounge switches",
                            style: TextStyles.bodySmall.copyWith(
                              color: isSelected
                                  ? AppThemeNotifier.onPrimary
                                  : AppThemeNotifier.textPrimary,
                              fontSize: 11,
                            ),

                          ),
                        ],
                      ),
                    );
                  },),
                ),
                4.height

                // Checkmark for selected plan

              ],
            ),
          ),

        ],
      ),
    );
  });
}
Widget _buildReferralCard() {
  return InkWell(
    onTap: (){

    },
    child: Container(
      height: 100,
      width: Get.width,
      decoration: BoxDecoration(

        image: const DecorationImage(
          image: AssetImage('assets/images/price_banner.png'),
          fit: BoxFit.contain,

        ),
      ),

    ),
  );
}
Widget buildShimmerLoading() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ...List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 120, // Approximate height of a plan card
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        );
      }),

    ],
  );
}