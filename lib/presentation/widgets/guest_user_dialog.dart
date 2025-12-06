
import 'package:get_storage/get_storage.dart';

import '../../core/services/binding.dart';
import '../../core/utils/export.dart';
import '../view/auth/get_started_first.dart';
import '../view/auth/login_screen.dart';
import 'common_button.dart';

void guestUserDialog(String title) {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppThemeNotifier.border, width: 1),
          color: AppThemeNotifier.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,  // <-- Important fix
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 16),
            Text(
              'Welcome Guest! 👋',
              style: TextStyles.headlineMedium.copyWith(
                color: AppThemeNotifier.textPrimary,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Login or sign up to unlock your $title',
              style: TextStyles.bodyMedium.copyWith(
                color: AppThemeNotifier.textDisabled.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
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
    ),
    barrierDismissible: true, // optional
  );
}
