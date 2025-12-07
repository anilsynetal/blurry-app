
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/view/plan/view/plan_price_screen.dart';
import 'package:blurry/presentation/view/plan/view/referrel_card.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

import '../../../../core/utils/string.dart';
import '../../../widgets/credit_widget.dart';
import '../../../widgets/guest_user_dialog.dart';
import '../controller/plan_price_controller.dart';
import '../controller/switch_plan_bottom_bar_controller.dart';
import '../model/plan_model.dart';

class PlanSwitchScreen extends StatelessWidget {
  const PlanSwitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanSwitchScreenController>(
      init: PlanSwitchScreenController(repository: Get.find(), ),
      builder: (controller) {

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
                    'Get More Credits',
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
        body: Stack(
          children: [
            Obx(
              ()=> SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: Text(
                          'Upgrade—because you’re here to find a soul, not a face.',
                          textAlign: TextAlign.start,
                          style: TextStyles.bodySmall.copyWith(
                            fontSize: 12,
                            color: AppThemeNotifier.textSecondary,

                          ),
                        ),
                      ),
                      Expanded(
                        child: Obx(
                              ()=> RefreshIndicator(
                            onRefresh: ()async{
                              controller.fetchPlans(loadMore: false);
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Header Description
                                  const SizedBox(height: 12),
                                  // Pricing Plans
                                  controller.isLoading.value
                                      ? buildShimmerLoading():
                                  Column(
                                    children: [
                                      if (controller.plans.isEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 50,bottom: 50),
                                          child: Center(
                                            child: Text(
                                              "No Plans Available",
                                              style: TextStyles.bodyMedium.copyWith(
                                                color: AppThemeNotifier.textPrimary,
                                              ),
                                            ),
                                          ),
                                        )
                                      else
                                      ...List.generate(controller.plans.length, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Obx(()=> buildPlanCard(controller.plans[index],index,() { controller.selectPlan(controller.plans[index].name.toString());},controller.selectedPlan.value.toString() == controller.plans[index].name.toString())),
                                        );
                                      },),
                                      // Continue Button
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5),
                                        child: Obx(() => gradientButton(
                                          height: 48,
                                          buttonText: controller.isLoadingPayment.value ? 'Processing...' : 'Purchase',
                                          onPressed: controller.isLoadingPayment.value ? (){} :() async{
                                            if(GetStorage().read(isGuest)??false ){
                                              guestUserDialog("purchase plan");
                                            }else {
                                              // await Stripe.instance.presentPaymentSheet();
                                              controller.continueToPlan();
                                            }
                                          },
                                        )),
                                      ),
                                      5.height,
                                      ReferralCardWidget(onTap: () { /* ... */ }),
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.end,
                                      //   children: [
                                      //     Text("Restore Purchase",style: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.clickableText)
                                      //       ,textAlign: TextAlign.end,),
                                      //   ],
                                      // ),
                                      // 5.height,

                                    ],
                                  ),



                                ],
                              ),
                            ),
                          ),
                        ),
                      ),




                    ],
                  ),
                ),
              ),
            ),
            Obx(
                  ()=> Positioned(
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child:
                  controller.   securePaymentLoading.value?
                  Container(
                    height: Get.height,
                    width: Get.width,
                    color: Colors.black12,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ):SizedBox()),
            )
          ],
        ),
      );
    },);



  }




}

