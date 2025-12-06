

// import '';

import 'package:blurry/core/utils/export.dart';

import '../../../../data/repository/api_repository.dart';

class PrivacyPolicyController extends GetxController{
  final ApiRepository authRepository;

  PrivacyPolicyController({required this.authRepository});

  Rx<String> content = "".obs;
  Rx<bool> isLoad = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    getPrivacyPolicy();
    super.onInit();
  }

  getPrivacyPolicy() async{
    isLoad.value = true;
    authRepository.getAppPrivacyPolicy().then((value) {
      content.value = value["data"]["content"];
      isLoad.value = false;
    },);
  }
}