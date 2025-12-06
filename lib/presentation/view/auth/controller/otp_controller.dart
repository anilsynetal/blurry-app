import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/services/binding.dart';
import '../../../../core/utils/string.dart';
import '../../../../data/repository/api_repository.dart';
import '../../../widgets/getx_message_toast.dart';
import '../sign_up_steps/signup_steps_screen.dart';


class OTPController extends GetxController {

  final ApiRepository authRepository;
  final String emailAddress;
  OTPController({required this.authRepository,required this.emailAddress});

  final RxString code = ''.obs;
  final int otpLength = 6;

  final RxInt secondsRemaining = 60.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    secondsRemaining.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining.value <= 0) {
        t.cancel();
      } else {
        secondsRemaining.value--;
      }
    });
  }

  void onCompleted(String value) {
    code.value = value;
  }

  void onChanged(String value) {
    code.value = value;
  }

  Rx<bool> isLoadResent = false.obs;
  Future<void> resendCode() async {

    if (secondsRemaining.value == 0) {
      try {
        isLoadResent.value = true;
     await   authRepository.resentOtpRegister(emailAddress).then((value) {
          showSuccessMessage(value["message"]);
          _startTimer();
        },);
        // TODO: trigger resend API

      }finally{
        isLoadResent.value = false;
      }
    }
  }
  final RxBool isLoading = false.obs;
  Future<void> verify() async {
    isLoading.value = true;
    try{
      await  authRepository.registerOtpVerify(emailAddress,code.value).then((value) {
        if(value.status == "success"){
          GetStorage().write(tokenKey, value.data?.token??"");
          GetStorage().write(isLoginKey, true);
          GetStorage().write(isRunningSignUp, true);
          GetStorage().write(signUpStage, "1");
          GetStorage().write(userNameKey, value.data!.user!.name??"");
          GetStorage().write(emailKey, value.data!.user!.email??"");
          GetStorage().write(userDataKey, value.data!.user!.toJson()??"");
          Get.offAll(()=>SignUpStepsScreen(),binding: SignUpStepsBinding());

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

  // Future<void> resend() async {
  //   isLoading.value = true;
  //   try{
  //     await  authRepository.registerOtpVerify(emailAddress,code.value).then((value) {
  //       if(value.status == "success"){
  //         GetStorage().write(tokenKey, value.data?.token??"");
  //         GetStorage().write(isLoginKey, true);
  //         GetStorage().write(isRunningSignUp, true);
  //         GetStorage().write(signUpStage, "1");
  //         GetStorage().write(userNameKey, value.data!.user!.name??"");
  //         GetStorage().write(emailKey, value.data!.user!.email??"");
  //         GetStorage().write(userDataKey, value.data!.user!.toJson()??"");
  //         Get.offAll(()=>SignUpStepsScreen(),binding: SignUpStepsBinding());
  //
  //       }else{
  //         showErrorMessage(value.message??"Login Failed");
  //       }
  //     },).onError((error, stackTrace) {
  //       isLoading.value = false;
  //     },);
  //   }finally{
  //     isLoading.value = false;
  //   }
  //
  //
  //
  //
  //
  // }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
