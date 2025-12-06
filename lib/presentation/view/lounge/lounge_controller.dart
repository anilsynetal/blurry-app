import 'package:blurry/core/services/binding.dart';
import 'package:blurry/presentation/view/lounge/vibe_selection_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../data/repository/api_repository.dart';
import '../../widgets/confirmation_dialog.dart';
import 'lounge_model.dart';
import 'model/lounge_list_response_model.dart';

class LoungeController extends GetxController {

  final ApiRepository repository;

  LoungeController({required this.repository});

  Rx<LoungesData> selectedLounge = LoungesData(id: "").obs;


  final List<LoungesData> lounges = [];


  @override
  Future<void> onInit() async {

    super.onInit();
   await fetchLounges();
     getMyLounges();

    _startCountdown();

  }

  void selectLounge(LoungesData loungeId) {
    selectedLounge.value = loungeId;
  }

  void continueWithLounge(context) {
    if (selectedLounge.value != null) {

      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoCustomDialog(
            heading: 'Switch Lounge?',
            subtitle2: isMyLoungesNull.value == false ? "🕒 Time left in your current lounge: ${formattedCountdown}":null,
            subtitle: 'One vibe at a time. You can hop lounges again in 24 hours.',

            leftButtonText: 'Stay',
            rightButtonText: 'Switch',
            onLeftButtonTap: () {
              Navigator.pop(context);

            },
            onRightButtonTap: () {
              Navigator.pop(context);

              Get.to(()=>VibeSelectionScreen(),binding:VibeBinding(selectedLounges: selectedLounge.value,exitingDescription:myVibeDescription.value.toString() ) );


            },
          );
        },
      );


      // Navigate to next screen
    }
  }

  RxBool isLoading = true.obs; // For initial loading
  RxBool isLoadingMore = false.obs; // For load more
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  Future<void> fetchLounges({bool loadMore = false}) async {
    if (loadMore && currentPage.value >= totalPages.value) return; // No more pages to load

    if (!loadMore) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await repository.getLoungesList(
        page: loadMore ? currentPage.value + 1 : 1,
        limit: 10,
      );

      if (response.data != null) {
        if (!loadMore) {
          lounges.clear(); // Clear existing plans for fresh load
        }
        lounges.addAll(response.data!);
        currentPage.value = response.pagination!.currentPage ?? 1;
        totalPages.value = response.pagination!.totalPages ?? 1;

      } else {

      }
    } catch (e) {

    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  RxInt switchCountdownSeconds = 86400.obs; // 24 hours in seconds
  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (switchCountdownSeconds.value > 0) {
        switchCountdownSeconds.value--;
        _startCountdown();
      }
    });
  }

  String get formattedCountdown {
    final hours = switchCountdownSeconds.value ~/ 3600;
    final minutes = (switchCountdownSeconds.value % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }

 Rx<bool> isMyLoungesNull = true.obs;
 Rx<String> myVibeDescription = "".obs;
 // Rx<LoungesData> mySavedLounges = LoungesData().obs;
  getMyLounges() async{
    try{
      await repository.getMyLounges().then((value) {
        if(value["data"] != null){
          if(value["data"] != null){
            selectedLounge.value = LoungesData.fromJson(value["data"]["lounge"]);
            myVibeDescription.value = value["data"]["vibeDescription"]??"";
            isMyLoungesNull.value = false;
          }else{
            selectedLounge.value = lounges[0];
          }
          setCountdownFromJoinedAt(value["data"]["joinedAt"]);

        }else{
          selectedLounge.value = lounges[0];
        }

      },);
    }finally{

    }

  }

  void setCountdownFromJoinedAt(String joinedAtString) {
    try {
      // Step 1: Parse the joinedAt string
      final DateTime joinedAt = DateTime.parse(
        joinedAtString.replaceAll(' ', 'T'), // Convert "2025-10-26 10:56:15" → "2025-10-26T10:56:15"
      );

      // Step 2: Add 24 hours to get expiry time
      final DateTime expiryTime = joinedAt.add(const Duration(hours: 24));

      // Step 3: Get current time
      final DateTime now = DateTime.now();

      // Step 4: Calculate remaining seconds (if still within 24h)
      int remainingSeconds = expiryTime.difference(now).inSeconds;

      // Ensure it doesn't go negative
      if (remainingSeconds < 0) {
        remainingSeconds = 0;
      }

      // Step 5: Assign to RxInt
      switchCountdownSeconds.value = remainingSeconds;
    } catch (e) {
      print("Error parsing joinedAt: $e");
      switchCountdownSeconds.value = 0;
    }
  }
}
