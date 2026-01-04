
import 'dart:io';

import 'package:blurry/data/repository/api_repository.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/services/binding.dart';
import '../../../../core/utils/export.dart';
import '../../../../core/utils/string.dart';
import '../../../widgets/getx_message_toast.dart';
import '../../lounge/lounge_selection_screen.dart';
import '../../plan/view/plan_price_screen.dart' show PricingScreen;

class GetStartedController extends GetxController{
  final ApiRepository apiRepository;

  GetStartedController({required this.apiRepository});

  Rx<bool>isLoading =false.obs;
  RxString deviceToken = "deviceToken".obs;


 @override
  void onInit() {
   fetchDeviceFCMToken();
    // TODO: implement onInit
    super.onInit();
  }
  Future<void> fetchDeviceFCMToken() async {
    try {
      // Request notification permissions on iOS
      NotificationSettings settings =  await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Fetch FCM token
        String? fcmToken =  await FirebaseMessaging.instance.getToken();
        if (fcmToken != null) {
          deviceToken.value = fcmToken;

        } else {
          if (kDebugMode) {
            debugPrint("⚠️ Failed to get FCM token");
          }
        }

        // Fetch APNs token for iOS if FCM token is available
        if (Platform.isIOS && fcmToken != null) {
          String? apnsToken = await  FirebaseMessaging.instance.getAPNSToken();
          if (apnsToken != null && kDebugMode) {
            debugPrint("📱 APNs Token: $apnsToken");
          }
        }
      } else {
        if (kDebugMode) {
          debugPrint("⚠️ User declined or has not accepted permission: ${settings.authorizationStatus}");
        }

      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("❌ Error fetching FCM token: $e");
      }
    }
  }
  Future<void> guest() async {


    isLoading.value = true;
    try{
      await  apiRepository.guestRegister(  deviceToken.value).then((value) async {
        if(value.status == "success"){
          GetStorage().write(tokenKey, value.data?.token??"");
          GetStorage().write(isGuest, true);
          final response = await apiRepository.getPlanList(
            page: 1,
            limit: 100,
          );
          if (response.data != null) {
            String PlanID = response.data!.firstWhere((element) => element.price.toString() == "0",).id.toString();
            if(PlanID != "null"){
              final dio = Dio();

              try {
                // STATIC API CALL → 200 or 400 both allowed
                final res = await dio.post(
                  '${baseUrl}app/v1/payments/create-payment-intent',
                  data: {"planId": PlanID},
                  options: Options(
                    headers: {
                      'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
                      'Accept': 'application/json',
                    },
                  ),
                );

                print("API Response → ${res.data}");
              } catch (err) {
                // If API returns 400, Dio throws error — but YOU STILL WANT TO CONTINUE
                print("API Error but allowed → $err");
              }

              // ALWAYS navigate after 200 or 400
              Get.to(() => LoungeSelectionScreen(), binding: LoungeBinding());
            }

          } else {
          }
        }else{
          showErrorMessage(value.message??"Login Failed");
        }
      },).onError((error, stackTrace) {
        print("error is $error");
        isLoading.value = false;
      },);
    }finally{
      isLoading.value = false;
    }
  }

  Future<void> fetchPlans() async {



    try {

    } catch (e) {

    } finally {
      isLoading.value = false;

    }
  }

}