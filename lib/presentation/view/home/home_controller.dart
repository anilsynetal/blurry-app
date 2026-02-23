import 'dart:developer';

import 'package:blurry/data/repository/api_repository.dart';
import 'package:blurry/presentation/view/home/model/lounges_response_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/utils/string.dart';

class ProfileCard {
  final String id;
  final String name;
  final int age;
  final String location;
  final String profileImage;
  final String punchline;
  final bool isVerified;

  ProfileCard({
    required this.id,
    required this.name,
    required this.age,
    required this.location,
    required this.profileImage,
    required this.punchline,
    this.isVerified = false,
  });
}

class HomeController extends GetxController {

  final ApiRepository repository ;

  // Observable state
  final RxList<MemberData> memberData = <MemberData>[].obs;
  // final RxInt currentIndex = 0.obs;
  final RxString currentLounge = ''.obs;
  final RxString currentLoungeId = ''.obs;
   RxString bannerImageLounge = ''.obs;
  RxBool isLoadingBanner = true.obs;
  final RxBool isOnline = true.obs;
  final RxString userPunchline = ''.obs;
  final Rx<bool> selectedLoungesNull = false.obs;

  HomeController({required this.repository});

  @override
  Future<void> onInit() async {
    super.onInit();
    getSettingDetails();
    getUnreadCount();
    _fetchProfileDetails();
    await getMyLounges();

  }

  getSettingDetails(){
    repository.getSetting("app_config").then((value) {

       String blurPer = "${value["data"]["unblurPercentage"]}";
       String afterUnblurPercentage = "${value["data"]["afterUnblurPercentage"]}";

       String email = "${value["data"]["email"]}";
       String timezone = "${value["data"]["timezone"]}";
       GetStorage().write(blurPercentageKey,blurPer);
       GetStorage().write(blurPercentageAfterKey,afterUnblurPercentage);
       GetStorage().write(supportMailKey,email);
       GetStorage().write(timezoneKey,timezone);
    },);
  }

  Rx<String> unreadCountNotification = "".obs;
  Rx<bool>isLoadNotificationCount = false.obs;

  getUnreadCount() async{
    isLoadNotificationCount.value = true;
    await repository.getUnreadNotificationCount().then((value) {
      unreadCountNotification.value = "${value["data"]["unreadCount"]??"0"}";
    },).onError((error, stackTrace) {
      isLoadNotificationCount.value = false;
    },);
    isLoadNotificationCount.value = false;
  }



  RxBool isLoading = true.obs; // For initial loading
  RxBool isLoadingMore = false.obs; // For load more
  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;
  Future<void> loadProfiles({bool loadMore = false}) async {
    if (loadMore && currentPage.value >= totalPages.value) return; // No more pages to load

    if (!loadMore) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final response = await repository.getLoungesMemberList(
        page: loadMore ? currentPage.value + 1 : 1,
        limit: 10,
        lId: currentLoungeId.toString()
      );

      if (response.data != null) {
        if (!loadMore) {
          memberData.clear(); // Clear existing plans for fresh load
        }
        memberData.addAll(response.data!);
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



  getMyLounges() async{
    try{
      isLoadingBanner.value = true;
      await repository.getMyLounges().then((value) async {
        if(value["data"] != null){

          // userPunchline.value = '“${value["data"]["lounge"]["description"]}”';
          currentLoungeId.value = '${value["data"]["lounge"]["_id"]}';
          currentLounge.value = '${value["data"]["lounge"]["name"]}';
          bannerImageLounge.value = '${imageBaseUrl}${value["data"]["lounge"]["bannerImage"]}';
          isLoadingBanner.value = false;
          selectedLoungesNull.value = false;
          await loadProfiles();
        }else{
          selectedLoungesNull.value = true;
          isLoadingBanner.value = false;
        }
      },);
    }finally{

    }
  }

  Future<void> _fetchProfileDetails() async {
    try {
      isLoading.value = true;
      final response = await repository.getProfileDetails();

      if (response != null ) {
        final user = response!.data!.user!;


        userPunchline.value ='“${user.punchLine ?? ''}”';;

      } else {

      }
    } catch (e) {

    } finally {
      isLoading.value = false;
    }
  }

}
