

// import '';

import 'package:blurry/core/utils/export.dart';

import '../../../../data/repository/api_repository.dart';

class TermAndConditionController extends GetxController{
  final ApiRepository authRepository;

  TermAndConditionController({required this.authRepository});

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
    authRepository.getTermAndCondition().then((value) {
      content.value = value["data"]["content"];
      isLoad.value = false;
    },);
  }
}