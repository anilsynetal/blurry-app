import 'package:blurry/core/utils/string.dart';
import 'package:blurry/data/repository/api_repository.dart';
import 'package:blurry/presentation/bottom_bar/bottom_bar.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../core/services/socket_service.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/credit_widget.dart';
import '../../your_match/model/my_matches_list_model.dart';


class UnblurController extends GetxController {
  final String targetUserId;
  final String matchId;
  final ApiRepository repository;
  final ScoreSocketController socketService;
  final MatchUser targetUserDetails;

  UnblurController({required this.targetUserDetails,required this.matchId,required this.targetUserId,required this.repository,required this.socketService});
  // Observable variables
  final currentBlurSigma = 14.0.obs;
  final targetBlurSigma = 0.0.obs;
  final blurPercentage = 80.0.obs;
  final creditsRequired = 12.obs;
  final isUnblurring = false.obs;

  // Profile data
  final profileName = ''.obs;
  final profileAge = "".obs;
  final profileLocation = ''.obs;
  final profileImage = "".obs;

  @override
  void onInit() {
    profileImage.value = "${imageBaseUrl}${targetUserDetails!.avatar.toString()}";
    profileName.value = "${targetUserDetails.name.toString()}";
    profileAge.value = "${targetUserDetails.age.toString()}";
    profileLocation.value = "";
    _setupSocketListeners();
    _calculateBlurPercentage();
    super.onInit();
  }

  /// Calculate blur percentage based on current sigma
  void _calculateBlurPercentage() {
    final maxSigma = 14.0;
    final percentage = ((maxSigma - currentBlurSigma.value) / maxSigma) * 100;
    blurPercentage.value = percentage.clamp(0, 100);
  }

  /// Update blur sigma dynamically
  void updateBlurSigma(double newSigma) {
    currentBlurSigma.value = newSigma.clamp(0, 14.0);
    _calculateBlurPercentage();
  }

  /// Confirm unblur action

  RxBool isLoadUnBlur = false.obs;

   confirmUnblur(context) async {
     if(Get.find<WalletController>().walletCredit.value >1){
       isLoadUnBlur.value = true;
       try {
         final data = {
           "targetUserId": targetUserId,
           "matchId": matchId,
           "requestType": 'profile'};
         socketService.socket?.emitWithAck('request_unblur', data, ack: (response) {
         });
       }finally{
       }
     }else{
       showCupertinoDialog(
         context: context,
         builder: (BuildContext context) {
           return CupertinoCustomDialog(
             heading: 'Not Enough Credits',
             title: 'Oops!🫠 You need more credits to see this photo clearly.',
             subtitle: 'Each unblur step costs 1 credit per user.',

             leftButtonText: 'Cancel',
             rightButtonText: 'Buy Credits',
             onLeftButtonTap: () {
               Navigator.pop(context);

             },
             onRightButtonTap: () {
               Get.offAll(()=>BottomNavBar(initialIndex: 2,));

             },
           );
         },
       );
     }

    // isUnblurring.value = true;
    // // Animate blur to 0
    //
    //   currentBlurSigma.value = 0.0;
    //   targetBlurSigma.value = 0.0;
    //   _calculateBlurPercentage();
    //   isUnblurring.value = false;

  }

  /// Reset blur to initial state
  void resetBlur() {
    currentBlurSigma.value = 14.0;
    targetBlurSigma.value = 14.0;
    _calculateBlurPercentage();
  }



  /// Handle maybe next time


  /// Handle stop conversation
  Rx<bool> stopChatLoad = false.obs;
  void onStopConversation() {
    stopChatLoad.value = true;
    repository.stopChat(matchId).then((value) {
      stopChatLoad.value = false;

      Get.off(BottomNavBar(initialIndex: 1,));
    },).onError((error, stackTrace) {
      stopChatLoad.value = false;
    },);
  }

  void _setupSocketListeners() {

    socketService.socket?.on('unblur_request_sent', (data)  {
      isLoadUnBlur.value = false;
      Get.back();
      showMessageDialog(data["message"],"Success");
    });

  }




}
