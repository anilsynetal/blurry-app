
// controllers/invite_controller.dart
import 'package:get/get.dart';

import '../../../../data/repository/api_repository.dart';
import '../model/invite_plan_details_model.dart';


class InviteController extends GetxController {
  final ApiRepository apiRepository = Get.find();

  Rx<InviteData?> inviteData = Rx<InviteData?>(null);
  Rx<bool> isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInviteDetails();
  }

  Future<void> fetchInviteDetails() async {
    try {
      isLoading.value = true;
      final response = await apiRepository.getInviteCardDetails();
      if (response.data != null) {
        inviteData.value = response.data;
      }
    } catch (e) {
      print("Error fetching invite details: $e");
    } finally {
      isLoading.value = false;
    }
  }
}