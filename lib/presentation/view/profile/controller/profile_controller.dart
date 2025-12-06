

import 'package:blurry/core/utils/export.dart';
import 'package:blurry/data/repository/api_repository.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/services/binding.dart';
import '../../../../core/utils/string.dart';
import '../../auth/get_started_first.dart';
import '../../plan/model/plan_model.dart';

class ProfileController extends GetxController{

  final ApiRepository repository;
  ProfileController({required this.repository});

  Rx<PricingPlan> selectedPlan = PricingPlan(id: "").obs;
  RxBool isLoadMyPlan = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getMyActivePlanApi();
    super.onInit();
  }

  Rx<String> imageUrl = GetStorage().read(userDataKey) == null ? "".obs: "${imageBaseUrl}${GetStorage().read(userDataKey)['avatar']}".obs;
  Rx<String> bioHome =GetStorage().read(userDataKey) == null ? "".obs: "${GetStorage().read(userDataKey)['bio']??""}".obs;
  Future<void> getMyActivePlanApi() async {
    isLoadMyPlan.value = true;
    try {
      final value = await repository.getMyActivePlan();
      if (value["data"] != null) {
        selectedPlan.value = PricingPlan.fromJson(value["data"]["plan"]);
      } else {
        selectedPlan.value = PricingPlan(id: "");
      }
    } catch (e, s) {
      print("[v0] Error fetching plan: $e");
      print("[v0] Stack: $s");
    } finally {
      isLoadMyPlan.value = false;
    }
  }

  Rx<bool> isLogoutLoad = false.obs;
  logout() async {
    isLogoutLoad.value =true;
    try {
      await repository.logout().then((value) {
        if (value["status"].toString() == "success") {
          GetStorage().erase();
          Get.offAll(() => GetStartedScreenFirst(),
              binding: GetStartedBinding());
        }
      },
      );
    }finally{
      isLogoutLoad.value =false;
    }

  }
  
}