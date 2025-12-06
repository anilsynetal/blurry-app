import 'package:flutter/cupertino.dart';
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

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController().obs;
  final newPasswordController = TextEditingController().obs;
  final confirmPasswordController = TextEditingController().obs;

  final isOldPasswordVisible = false.obs;
  final isNewPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  final isLoading = false.obs;

  final ApiRepository apiRepository;
  ChangePasswordController({required this.apiRepository});

  void toggleOldPasswordVisibility() {
    isOldPasswordVisible.value = !isOldPasswordVisible.value;
  }

  void toggleNewPasswordVisibility() {
    isNewPasswordVisible.value = !isNewPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  bool _validateForm() {
    if (oldPasswordController.value.text.isEmpty) {
      showMessageDialog('Old password is required', "Warning ⚠️");

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

    if (newPasswordController.value.text.length < 6) {
      showMessageDialog('Password must be at least 6 characters', "Warning ⚠️");

      return false;
    }

    if (newPasswordController.value.text != confirmPasswordController.value.text) {

      showMessageDialog('Passwords do not match', "Warning ⚠️");

      return false;
    }

    if (oldPasswordController.value.text == newPasswordController.value.text) {
      showMessageDialog('New password cannot be same as old password', "Warning ⚠️");

      return false;
    }

    return true;
  }
  Future<void> changePassword(BuildContext context) async {
    // 👇 Add this to remove focus from text fields
    FocusScope.of(context).unfocus();
    if (!_validateForm()) return;

    // -----------------------------------------------------------------
    // 1. Show confirmation dialog
    // -----------------------------------------------------------------
    final bool? confirmed = await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return CupertinoCustomDialog(
            heading: 'Change Password?',
            title: 'Warning',
            subtitle:
            'Changing your password will log you out of the app. '
                'You will need to log in again with the new password.',
            leftButtonText: 'Cancel',
            rightButtonText: 'Confirm',
            onLeftButtonTap:  () => Navigator.pop(ctx, false),
        onRightButtonTap: () => Navigator.pop(ctx, true),
        );
      },
    );

    // If user cancelled → stop here
    if (confirmed != true) return;

    // -----------------------------------------------------------------
    // 2. Proceed with API call
    // -----------------------------------------------------------------
    isLoading.value = true;
    try {
      final response = await apiRepository.changePassword(
        oldPassword: oldPasswordController.value.text,
        newPassword: newPasswordController.value.text,
      );

      if (response["status"].toString() == "success") {
        showSuccessMessage(
          response["message"] ?? 'Password changed successfully',
        );


        // Pop the change-password screen
        if (context.mounted) Navigator.pop(context);

        GetStorage().erase();
        Get.offAll(()=>GetStartedScreenFirst(),binding: GetStartedBinding());

      } else {
        showErrorMessageDialog(
          response["message"] ?? 'Failed to change password',
        );
      }
    } catch (e) {
      // You can log the error or show a generic message

    } finally {
      isLoading.value = false;
    }
  }


  @override
  void onClose() {
    oldPasswordController.value.dispose();
    newPasswordController.value.dispose();
    confirmPasswordController.value.dispose();
    super.onClose();
  }
}