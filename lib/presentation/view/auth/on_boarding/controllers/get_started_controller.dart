import 'dart:ui';

import 'package:get/get.dart';
import '../models/onboarding_page.dart';

class GetStartedOnBoardController extends GetxController {
  final _currentPage = 0.obs;

  int get currentPage => _currentPage.value;

  int get totalPages => OnboardingContent.pages.length;

  bool get isLast => _currentPage.value == totalPages - 1;

  void setCurrentPage(int page) {
    _currentPage.value = page;
  }

  void next(VoidCallback onFinished) {
    if (_currentPage.value < totalPages - 1) {
      _currentPage.value++;
    } else {
      onFinished();
    }
  }
}
