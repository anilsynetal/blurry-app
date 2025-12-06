import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/typography.dart';
import 'controller/privacy_policy_controller.dart';


class PrivacyPolicyScreen extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyScreen({super.key});

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
          "Privacy Policy",
          style: TextStyles.headlineMedium.copyWith(
            color: AppThemeNotifier.textPrimary,
          ),
        ),

      ),

      body:
      Obx(
        ()=> controller.isLoad.value ?
            Center(
              child: CircularProgressIndicator(),
            )
            :
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Html(
                data: controller.content.value,
                style: {
                  "body": Style(
                    color: Colors.black, // set default text color

                  ),
                  "h1": Style(
                    color: Colors.black, // set default text color
                  ),
                  "p": Style(
                    color: Colors.black, // set default text color
                  ),

                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
