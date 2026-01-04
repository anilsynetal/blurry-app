import 'dart:io';

import 'package:blurry/core/services/binding.dart';
import 'package:blurry/presentation/view/auth/sign_up_steps/signup_steps_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/utils/string.dart';
import '../../../../data/repository/api_repository.dart';
import '../../../widgets/getx_message_toast.dart';
import '../otp_verify_screen.dart';

class SignupController extends GetxController {


  final ApiRepository authRepository;

  SignupController({required this.authRepository});

   Rx<TextEditingController> fullNameController = TextEditingController().obs;
   Rx<TextEditingController> emailController = TextEditingController().obs;
   Rx<TextEditingController> passwordController = TextEditingController().obs;
   Rx<TextEditingController> refCodeController = TextEditingController().obs;

  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }


  @override
  Future<void> onInit() async {
    // TODO: implement onInit

    fetchDeviceFCMToken();
    super.onInit();
  }
  RxString deviceToken = "device123".obs;


  Future<void> fetchDeviceFCMToken() async {
    try {
      // Request notification permissions on iOS
      NotificationSettings settings =  await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Fetch FCM token
        String? fcmToken =  await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          deviceToken.value = fcmToken;

        } else {
          if (kDebugMode) {
            debugPrint("⚠️ Failed to get FCM token");
          }
        }

        // Fetch APNs token for iOS if FCM token is available
        if (Platform.isIOS && fcmToken != null) {
          String? apnsToken = await  FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null && kDebugMode) {
            debugPrint("📱 APNs Token: $apnsToken");
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint("⚠️ User declined or has not accepted permission: ${settings.authorizationStatus}");
        }

      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("❌ Error fetching FCM token: $e");
      }
    }
  }

  Future<void> signUp() async {
    if(fullNameController.value.text.isEmpty){
      showWarningMessage("Please enter your full name");
      return ;
    }
    if(emailController.value.text.isEmpty){
      showWarningMessage("Please enter valid email address");
      return ;
    }
    if(passwordController.value.text.isEmpty){
      showWarningMessage("Please enter your password");
      return ;
    }
    isLoading.value = true;
    try{
      await  authRepository.register(emailController.value.text, passwordController.value.text,"${deviceToken.value}",fullNameController.value.text,inviteCode: refCodeController.value.text).then((value) {
        if(value.status == "success"){

          Get.to(OTPVerificationScreen(),binding: OTPBinding(email: emailController.value.text));
        }else{
          showErrorMessage(value.message??"Login Failed");
        }
      },).onError((error, stackTrace) {
        isLoading.value = false;
      },);
    }finally{
      isLoading.value = false;
    }



  }
}
