import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../core/utils/export.dart'; // Adjust import as per your project
import '../../core/utils/string.dart';
import '../../data/repository/api_repository.dart';

class CreditBoxWidget extends StatelessWidget {
  const CreditBoxWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final WalletController controller = Get.put(WalletController());

    bool isPlanDisabled = Platform.isIOS && GetStorage().read(isPlanEnable) == false;
    return    isPlanDisabled?SizedBox(): Obx(
          () =>

              Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF11B2C38),
              const Color(0xFF11B2C38).withOpacity(0.8),
              const Color(0xFF11B2C38).withOpacity(0.6),
              const Color(0xFF11B2C38).withOpacity(0.5),
              const Color(0xFF11B2C38).withOpacity(0.4),
              const Color(0xFF11B2C38).withOpacity(0.3),
            ],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/icons/diamond_shine.png",
              height: 18,
              color: AppThemeNotifier.onPrimary,
            ),
            const SizedBox(width: 4),
            controller.isLoading.value
                ?  SizedBox(
              height: 12,
              width: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppThemeNotifier.onPrimary,
                ),
              ),
            )
                : Text(
              "${controller.walletCredit.value} Credit",
              style: TextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppThemeNotifier.onPrimary,
                fontSize: 12,
              ),
            ),

          ],
        ),
      ),
    );
  }
}



class WalletController extends GetxController {
  final ApiRepository apiRepository = Get.find<ApiRepository>();
  var walletCredit = 0.obs; // Observable to hold wallet credit
  var isLoading = false.obs; // Observable to track loading state
  var errorMessage = ''.obs; // Observable to track error messages

  @override
  void onInit() {
    super.onInit();
    fetchWalletCredit(); // Fetch wallet credit when controller is initialized
  }

  Future<void> fetchWalletCredit() async {
    try {
      isLoading.value = true;
      final response = await apiRepository.getMyWalletCredit();
      if (response['message'] == 'Wallet balance retrieved successfully') {
        walletCredit.value = response['data']['walletCredit'] ?? 0;
        errorMessage.value = '';
      } else {
        errorMessage.value = response['message'] ?? 'Failed to fetch wallet credit';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching wallet credit: $e';
    } finally {
      isLoading.value = false;
    }
  }
}