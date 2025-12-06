import 'package:blurry/presentation/widgets/showErrorDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/repository/api_repository.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/message_dialog.dart';
import '../model/date_plan_model.dart';

class PlanYourDateController extends GetxController {
  final String matchId;
  final String targetUserId;
  PlanYourDateController({required this.matchId, required this.targetUserId});

  final ApiRepository apiRepository = Get.find<ApiRepository>();

  Rx<String> selectedOption = "".obs;
  RxList<DatePlanData> datePlans = <DatePlanData>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;
  Rx<TextEditingController> ideaController = TextEditingController().obs;

  @override
  void onInit() {
    super.onInit();
    fetchDatePlans();
  }

  @override
  void onClose() {

    super.onClose();
  }

  Future<void> fetchDatePlans() async {
    try {
      isLoading.value = true;
      errorMessage.value = "";

      final response = await apiRepository.getDatePlanTemplates(page: 1, limit: 20);

      if (response.status == "error" || response.data == null) {
        errorMessage.value = response.message ?? "Failed to load date plans";
        datePlans.clear();
      } else {
        datePlans.assignAll(response.data ?? []);

      }
    } catch (e) {
      errorMessage.value = "Error fetching date plans: ${e.toString()}";
      datePlans.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void selectDateOption(DatePlanData datePlan) async {
    // If user has typed their own idea, confirm before switching to a template
    if (ideaController.value.text.isNotEmpty) {
      showCupertinoDialog(
        context: Get.overlayContext!,
        builder: (BuildContext context) {
          return CupertinoCustomDialog(
            heading: 'Alert ⚠️',
            title:   "You’ve already written your own idea. Continue to select a date plan instead?",

            leftButtonText: 'Cancel',
            rightButtonText: 'Yes Update',
            onLeftButtonTap: () {
              Navigator.pop(context);

            },
            onRightButtonTap: () {
              ideaController.value.clear();
              Navigator.pop(context);

            },
          );
        },
      );

    }

    selectedOption.value = datePlan.id ?? "";
  }

  Rx<bool> isLoadSendToMatch = false.obs;


  sendToMatch(context) async {


    isLoadSendToMatch.value = true;
    var data = {};
    final now = DateTime.now().add(Duration(days: 1)).toUtc();
    final formattedDate = now.toIso8601String().split('.').first + 'Z';

    if (ideaController.value.text.isNotEmpty) {
      data = {
        "proposedTo": targetUserId.toString(),
        "matchId": matchId,
        "description": ideaController.value.text,
        "proposedDate": formattedDate,
        "templateUsed": null,
        "isFromTemplate": false
      };
    } else {
      data = {
        "proposedTo": targetUserId,
        "matchId": matchId,
        "proposedDate": formattedDate,
        "templateUsed": selectedOption.value.toString(),
        "isFromTemplate": true
      };
    }

    apiRepository.sendDateProposal(data).then((value) async {
      isLoadSendToMatch.value = false;
      ideaController.value.clear();
       await showMessageDialog(value["message"], "Success");
       Get.back();
    }).onError((error, stackTrace) {
      isLoadSendToMatch.value = false;
      print(error);
      print(stackTrace);
    });
  }




  Future<void> sendDateProposal(context) async {
    if (ideaController.value.text.isEmpty && selectedOption.value == "") {
      showMessageDialog("Please select a plan or write your own idea.", "Alert");


    }else{
      await showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoMessageCustomDialog(
            topImage: Image.asset("assets/icons/safe.png", height: 80),
            heading: 'Stay safe!',
            title: 'Meet in public, tell a friend, trust your intuition.',
            leftButtonText: 'Continue',
            onLeftButtonTap: () {
              sendToMatch(context);
              Navigator.pop(context);
              // TODO: Add API call to send proposal with selectedOption.value
            },
            rightButtonText: '',
            onRightButtonTap: () {
              Get.back();
            },
          );
        },
      );
    }

  }
}
