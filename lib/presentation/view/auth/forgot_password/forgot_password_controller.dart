import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/data/repository/api_repository.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart';

import '../../../../core/services/binding.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../auth/get_started_first.dart';

class ForgotPasswordController extends GetxController {
  final ApiRepository apiRepository;
  ForgotPasswordController({required this.apiRepository});

  final currentStep = 1.obs; // Step 1: Email, Step 2: OTP + Password

  // Controllers
  final emailController = TextEditingController().obs;
  final otpController = TextEditingController().obs;
  final newPasswordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;

  // Password visibility
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // OTP timer
   RxInt secondsRemaining = 60.obs;
  Timer? _timer;

  // Loading states
  final isLoading = false.obs;
  final isSendingOTP = false.obs;

  // Email for OTP verification
  final verificationEmail = ''.obs;

  final int otpLength = 6;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> sendOTP() async {
    if (!_validateEmail()) return;

    isSendingOTP.value = true;
    try {
      final response = await apiRepository.forgotPassword(
        email: emailController.value.text.trim(),
      );

      if (response["status"].toString() == "success") {
        verificationEmail.value = emailController.value.text.trim();
        showSuccessMessage(
          response["message"] ?? 'OTP sent successfully',
        );
        currentStep.value = 2; // Move to step 2
        _startTimer();
      } else {
        showErrorMessageDialog(
          response["message"] ?? 'Failed to send OTP',
        );
      }
    } catch (e) {
      showErrorMessageDialog('An unexpected error occurred.');
    } finally {
      isSendingOTP.value = false;
    }
  }

  Future<void> resetPassword() async {
    if (!_validateResetForm()) return;

    isLoading.value = true;
    try {
      final response = await apiRepository.resetPassword(
        email: verificationEmail.value,
        otp: otpController.value.text.trim(),
        password: newPasswordController.value.text,
      );

      if (response["status"].toString() == "success") {
        showSuccessMessage(
          response["message"] ?? 'Password reset successfully',
        );


        // Reset all fields
        _resetForm();

        // Navigate to login
        Get.offAll(() => GetStartedScreenFirst(), binding: GetStartedBinding());
      } else {
        showErrorMessageDialog(
          response["message"] ?? 'Failed to reset password',
        );
      }
    } catch (e) {
      showErrorMessageDialog('An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
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

  void resendCode() {
    if (secondsRemaining.value == 0) {
      sendOTP();
    }
  }

  // Go back to step 1
  void goBackToEmailStep() {
    currentStep.value = 1;
    otpController.value.clear();
    newPasswordController.value.clear();
    confirmPasswordController.value.clear();
  }

  bool _validateEmail() {
    final email = emailController.value.text.trim();
    if (email.isEmpty) {
      showMessageDialog('Email is required', "Warning ⚠️");

      return false;
    }
    if (!GetUtils.isEmail(email)) {
      showMessageDialog('Please enter a valid email', "Warning ⚠️");


      return false;
    }
    return true;
  }

  bool _validateResetForm() {
    if (otpController.value.text.isEmpty) {
      showMessageDialog('OTP is required', "Warning ⚠️");


      return false;
    }

    if (otpController.value.text.length != otpLength) {
      showMessageDialog('Please enter a valid 6-digit OTP', "Warning ⚠️");


      return false;
    }

    if (newPasswordController.value.text.isEmpty) {
      showMessageDialog('New password is required', "Warning ⚠️");

      return false;
    }

    if (confirmPasswordController.value.text.isEmpty) {
      showMessageDialog('Confirm password is required', "Warning ⚠️");

      return false;
    }

    if (newPasswordController.value.text.length < 8) {
      showMessageDialog('Password must be at least 8 characters', "Warning ⚠️");

      return false;
    }

    if (newPasswordController.value.text != confirmPasswordController.value.text) {
      showMessageDialog('Passwords do not match', "Warning ⚠️");


      return false;
    }

    return true;
  }

  void _resetForm() {
    emailController.value.clear();
    otpController.value.clear();
    newPasswordController.value.clear();
    confirmPasswordController.value.clear();
    currentStep.value = 1;
  }

  @override
  void onClose() {
    emailController.value.dispose();
    otpController.value.dispose();
    newPasswordController.value.dispose();
    confirmPasswordController.value.dispose();
    _timer?.cancel();
    super.onClose();
  }
}
