import 'dart:developer';

import 'package:blurry/core/utils/export.dart';
import 'package:blurry/data/repository/api_repository.dart';
import 'package:blurry/presentation/view/lounge/model/lounge_list_response_model.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/utils/string.dart';
import '../../bottom_bar/bottom_bar.dart';

class VibeController extends GetxController {
  final LoungesData selectedLounges;

  final ApiRepository repository;
  final String exitingDescription;
  VibeController({required this.selectedLounges,required this.repository,required this.exitingDescription});

  // Observable variables
  Rx<TextEditingController> vibeDescription = TextEditingController().obs;
  final RxInt charLength = 0.obs;
   get carLength {
     return vibeDescription.value.text.length;
   }

  // List of suggested punchlines
  final List<String> suggestedPunchlines = [
    '📚 \'Lost in Murakami novels\'',
    '🌿 \'Hikes > Netflix\'',
    '🌿 \'Hikes > Netflix\'',
    '📚 \'Lost in Murakami novels\'',
  ];

  @override
  void onInit() {
    super.onInit();
    vibeDescription.value.text = exitingDescription.toString();
    // Listen to TextEditingController changes and update charLength
    vibeDescription.value.addListener(() {
      final textLength = vibeDescription.value.text.length;
      charLength.value = textLength > 100 ? 100 : textLength;
    });

  }
  // Post to Urban Souls


  // Navigate back
  void goBack() {
    Get.back();
  }

  Rx<bool> isLoad = false.obs;
 void joinVibe() async{
    isLoad.value =true;
   try{
    await repository.joinLounges(selectedLounges.id.toString(), vibeDescription.value.text).then((value) async {

      if(value["status"].toString() == "success"){
        GetStorage().write(isLoginKey, true);
        Get.offAll(()=>BottomNavBar());
      }
     },
    );
   }finally{
     isLoad.value =false;
   }

  }


}