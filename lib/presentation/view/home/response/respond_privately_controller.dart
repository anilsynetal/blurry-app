import 'package:blurry/core/utils/export.dart';
import 'package:blurry/data/repository/api_repository.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart';
import 'package:get/get.dart';

import '../model/lounges_response_model.dart' show MemberData;
import '../start_chat_screen.dart';

class RespondPrivatelyController extends GetxController {
  final ApiRepository repository;
  final MemberData profile;
  RespondPrivatelyController({required this.repository,required this.profile, });

  final RxString response = ''.obs;
  final RxInt characterCount = 0.obs;
  final int maxCharacters = 100;



  void updateResponse(String value) {
    response.value = value;
    characterCount.value = value.length;
  }

  RxBool isLoading = false.obs;
  void sendResponse(context) async{
    isLoading.value = true;
    if(response.value.isEmpty){
      showWarningMessage("Please enter your message");
      return;
    }
    try {
      await repository.sendResponse(profile.user!.id.toString(),  response.value).then((value) async {
       await showMessageDialog(value["message"], "Success");
       Navigator.pop(context,true);

      },);
    }finally{
      isLoading.value = false;
    }


   // Get.to(()=>StartChatScreen());
  }

  void goBack() {
    Get.back();
  }

  @override
  void onClose() {
    response.close();
    characterCount.close();
    super.onClose();
  }
}
