

import 'dart:convert';
import 'dart:io';

import 'package:blurry/core/utils/string.dart';
import 'package:blurry/presentation/view/chat_view/models/chat_block_response_model.dart';
import 'package:blurry/presentation/view/plan/model/plan_model.dart';

import 'package:dio/dio.dart' as getFrom;
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../../presentation/view/chat_view/models/chat_message_model.dart';
import '../../presentation/view/chat_view/models/report_reason.dart';
import '../../presentation/view/home/model/lounges_response_model.dart';
import '../../presentation/view/lounge/model/lounge_list_response_model.dart';
import '../../presentation/view/plan/model/invite_plan_details_model.dart';
import '../../presentation/view/profile/notification/notification_list_model.dart';
import '../../presentation/view/unblur/model/date_plan_model.dart';
import '../../presentation/view/unblur/model/unblur_access_status.dart';
import '../../presentation/view/your_match/model/my_matches_list_model.dart';
import '../api/api_client.dart';
import '../models/login_response_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

class ApiRepository {
  final DioClient dioClient = Get.find<DioClient>(); // Access the DioClient dependency



  Future<LoginResponseModel> getProfileDetails() async {
    final response = await dioClient.dio.post(
      'app/v1/user/get-user-details',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

      return LoginResponseModel.fromJson(response.data);

  }

  Future<LoginResponseModel> logIn(String email, String password,String device_token) async {
    final response = await dioClient.dio.post(
      'app/v1/auth/user/login',
      data: {
        'email': email,
        'password': password,
        "deviceToken": device_token,
        "platform":Platform.isAndroid ?"android":"ios"
      },
    );
    if(response.data["status"].toString() == "error" ){
      return LoginResponseModel(message: response.data["message"].toString());

    }else{
      return LoginResponseModel.fromJson(response.data);

    }
  }


  Future<LoginResponseModel> guestRegister(String device_token) async {
    final response = await dioClient.dio.post(
      'app/v1/auth/guest/register',
      data: {
        // 'email': email,
        // 'password': password,
        "deviceToken": device_token,
        "platform":Platform.isAndroid ?"android":"ios"
      },
    );
    if(response.data["status"].toString() == "error" ){
      return LoginResponseModel(message: response.data["message"].toString());

    }else{
      return LoginResponseModel.fromJson(response.data);

    }
  }

  Future<LoginResponseModel> googleLogin(var data) async {
    final response = await dioClient.dio.post(
      'app/v1/auth/google-login',
      data: data
    );
    if(response.data["status"].toString() == "error" ){
      return LoginResponseModel(message: response.data["message"].toString());

    }else{
      return LoginResponseModel.fromJson(response.data);

    }
  }

  Future<LoginResponseModel> appleLogin(var data) async {
    final response = await dioClient.dio.post(
        'app/v1/auth/apple-login',
        data: data
    );
    if(response.data["status"].toString() == "error" ){
      return LoginResponseModel(message: response.data["message"].toString());

    }else{
      return LoginResponseModel.fromJson(response.data);

    }
  }

  Future<LoginResponseModel> register(String email, String password,String device_token,String name, {String? inviteCode}) async {
    final response = await dioClient.dio.post(
      'app/v1/auth/register',
      data: {
        "name":name,
        'email': email,
        'password': password,
        "deviceToken": device_token,
        "platform":Platform.isAndroid ?"android":"ios",
        if(inviteCode != null && inviteCode.isNotEmpty) "inviteCode": inviteCode,
      },
    );
    if(response.data["status"].toString() == "error" ){
      return LoginResponseModel(message: response.data["message"].toString());

    }else{
      return LoginResponseModel.fromJson(response.data);

    }
  }

  Future<dynamic> resentOtpRegister(String email,) async {
    final response = await dioClient.dio.post(
      'app/v1/auth/resend-registration-otp',
      data: {

        'email': email,

      },
    );
    return response.data;
  }


  Future<LoginResponseModel> registerOtpVerify(String email, String otp) async {
    final response = await dioClient.dio.post(
      'app/v1/auth/verify-registration-otp',
      data: {
        'email': email,
         'otp':otp
      },
    );
    print("response.data ======> ${response.data["status"].toString() }");
    if(response.data["status"].toString() == "error" ){
      return LoginResponseModel(message: response.data["message"].toString());

    }else{
      return LoginResponseModel.fromJson(response.data);

    }
  }

  Future<LoginResponseModel> deleteAccount() async {
    final response = await dioClient.dio.delete(
      'app/v1/user/delete-account',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    if (response.data["status"].toString() == "error") {
      return LoginResponseModel(message: response.data["message"].toString());
    } else {
      return LoginResponseModel.fromJson(response.data);
    }
  }

  Future<UserData> updateProfile(var body) async {
    final response = await dioClient.dio.put(
      'app/v1/user/update-user',
      data: body,
      options: Options(
        headers: {'Authorization': 'Bearer ${GetStorage().read(tokenKey)}'},
      ),
    );
    return UserData.fromJson(response.data["data"]);
  }

  Future<LoginResponseModel> updateProfilePicture(String imagePath) async {
    try {
      final token = GetStorage().read(tokenKey);


      final formData = getFrom.FormData();


      // Add profile image
      if (imagePath != "" && imagePath.isNotEmpty) {
        String? mimeType = mime(imagePath);
        final mimeSplit = mimeType?.split('/') ?? ['image', 'jpeg'];
        formData.files.add(
          MapEntry(
            'profilePicture',
            await getFrom.MultipartFile.fromFile(
              imagePath,
              contentType: MediaType(mimeSplit[0], mimeSplit[1]),
              filename: imagePath.split("/").last,
            ),
          ),
        );
      }


      final response = await dioClient.dio.put(
        'app/v1/user/update-profile-picture',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.data["status"].toString() == "error") {
        return LoginResponseModel(message: response.data["message"].toString(),status: "error");
      } else {
        return LoginResponseModel.fromJson(response.data);
      }
    } catch (e) {
      print("Error updating profile picture: $e");
      return LoginResponseModel(message: "Something went wrong");
    }
  }


  Future<dynamic> getAppPrivacyPolicy() async {
    final response = await dioClient.dio.get(
      'admin/v1/settings/privacy-policy',

    );
     return response.data;
  }

  Future<dynamic> getTermAndCondition() async {
    final response = await dioClient.dio.get(
      'admin/v1/settings/terms-and-conditions',

    );
    return response.data;
  }


  Future<dynamic> getSetting(String type) async {
    final response = await dioClient.dio.get(
      'app/v1/settings/$type',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );
    return response.data;
  }

  Future<dynamic> getFaqsList() async {
    final response = await dioClient.dio.get(
      'app/v1/faqs/list',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );
    return response.data;
  }

  Future<dynamic> getStripSetting() async {
    final response = await dioClient.dio.get(
      'app/v1/settings/stripe',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );
    return response.data;
  }


  Future<GetPlanListResponseModel> getPlanList({int page = 1, int limit = 10}) async {
    final response = await dioClient.dio.get(
      'app/v1/plan-list',
      queryParameters: {
        'page': page,
        'limit': limit,
        "sortOrder":"asc",
         "sortBy":"sortOrder"
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    if (response.data["status"].toString() == "error") {
      return GetPlanListResponseModel(message: response.data["message"].toString());
    } else {
      return GetPlanListResponseModel.fromJson(response.data);
    }
  }


  Future<GetLoungesListResponseModel> getLoungesList({int page = 1, int limit = 10}) async {
    final response = await dioClient.dio.get(
      'app/v1/lounges/list',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    if (response.data["status"].toString() == "error") {
      return GetLoungesListResponseModel(message: response.data["message"].toString());
    } else {
      return GetLoungesListResponseModel.fromJson(response.data);
    }
  }

  Future<dynamic> joinLounges(String loungesId, String videDescription) async {
    final response = await dioClient.dio.post(
      'app/v1/lounges/join',
      data:{
        "loungeId": loungesId,
        "vibeDescription": videDescription
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

   return response.data;
  }


  Future<dynamic> getMyLounges() async {
    final response = await dioClient.dio.get(
      'app/v1/lounges/my-lounge',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }


  Future<MemberListApiResponseModel> getLoungesMemberList({int page = 1, int limit = 10,required String lId}) async {
    final response = await dioClient.dio.get(
      'app/v1/lounges/${lId}/members',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    if (response.data["status"].toString() == "error") {
      return MemberListApiResponseModel(message: response.data["message"].toString());
    } else {
      return MemberListApiResponseModel.fromJson(response.data);
    }
  }

  Future<dynamic> getMyWalletCredit() async {
    final response = await dioClient.dio.get(
      'app/v1/payments/wallet',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }


  Future<dynamic> createPaymentIntent(String planId,String activePayment) async {
    final response = await dioClient.dio.post(
      'app/v1/payments/create-payment-intent',
      data:{
          "planId": planId ,
          "paymentGateway":activePayment
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future<dynamic> getMyActivePlan() async {
    final response = await dioClient.dio.get(
      'app/v1/payments/active-subscription',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  // Future<dynamic> getPaymentPlanStatus() async {
  //   final response = await dioClient.dio.get(
  //     'app/v1/settings/purchase-plan-status',
  //     options: Options(
  //       headers: {
  //         'accept': 'application/json',
  //       },
  //     ),
  //   );
  //   if(response.data["status"] == "success"){
  //     GetStorage().write("$isPlanEnable", bool.tryParse(response.data["data"]["isEnabled"].toString())??true);
  //   }
  //
  //   return response.data;
  // }

  Future<dynamic> sendResponse( String targetUserId,String message) async {
    final response = await dioClient.dio.post(
      'app/v1/matches/action',
      data: {
          "targetUserId": targetUserId,
          "message":message
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }


  Future<MyMatchesListResponseModel> getMyMatchesList({int page = 1, int limit = 20,required String lId}) async {
    final response = await dioClient.dio.get(
      "app/v1/matches/list",
      queryParameters: {
        'page': page,
        'limit': limit,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    if (response.data["status"].toString() == "error") {
      return MyMatchesListResponseModel(message: response.data["message"].toString());
    } else {
      return MyMatchesListResponseModel.fromJson(response.data);
    }
  }


  Future<MatchData> getMatchDetails( String matchId) async {
    final response = await dioClient.dio.get(
      'app/v1/matches/$matchId',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );
    return MatchData.fromJson(response.data);
  }


  Future<dynamic> updateMatchRequest( String matchId,String status) async {
    final response = await dioClient.dio.patch(
      'app/v1/matches/status/$matchId',
      data: {
        "status": status
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }


 /// Chat PLAN

  Future<dynamic> getAvailableGateway() async {
    final response = await dioClient.dio.get(
      'app/v1/payments/available-gateways',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future<dynamic> getOrderStatus(String orderID) async {
    final response = await dioClient.dio.get(
      'app/v1/payments/payment-status/$orderID',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future<dynamic> confirmPayment( String paymentIntentId) async {
    final response = await dioClient.dio.post(
      'app/v1/payments/confirm-payment',
      data: {
        "paymentIntentId": paymentIntentId
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

/// Chat API

  Future<dynamic> blockUser( bool isBlock,String matchId) async {
    final response = await dioClient.dio.post(
      'app/v1/matches/block/$matchId',
      data: {
          "isBlocked": isBlock,
          "blockReason": "Inappropriate behavior"
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );
    Map<String, dynamic> responseMap = {};
    if (response.data is Map<String, dynamic>) {
      responseMap = response.data;
    } else {
      responseMap = jsonDecode(response.data);
    }
    return responseMap;
  }
  Future<ReportReasonListModel> getReportReason() async {
    final response = await dioClient.dio.get(
      'app/v1/matches/report-reasons',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return ReportReasonListModel.fromJson(response.data);
  }

  Future<dynamic> reportUser( String reason,String description,String reportedUserId) async {
    final response = await dioClient.dio.post(
      'app/v1/matches/report',
      data: {
            "reportedUserId": reportedUserId,
            "reason": reason,
            "description": description
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }


  Future<dynamic> getChatId( String matchId) async {
    final response = await dioClient.dio.get(
      'app/v1/chats/match/$matchId',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );
    Map<String, dynamic> responseMap = {};
    if (response.data is Map<String, dynamic>) {
      responseMap = response.data;
    } else {
      responseMap = jsonDecode(response.data);
    }
    return responseMap;
  }


  Future<ChatDetailsResponseModel> getChatMessage({int page = 1, int limit = 50,required String chatId}) async {
    final response = await dioClient.dio.get(
      "app/v1/chats/$chatId/messages?page=$page&limit=$limit&markAsRead=true",
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    if (response.data["status"].toString() == "error") {
      return ChatDetailsResponseModel(message: response.data["message"].toString());
    } else {
      return ChatDetailsResponseModel.fromJson(response.data);
    }
  }

  Future<dynamic> sendMessage({required String messageType,required String content,required String chatId}) async {
    final response = await dioClient.dio.post(
      "app/v1/chats/$chatId/messages",
      data:
        {
          "content":content,
          "type": messageType
        }
      ,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

   return response.data;
  }


  Future<dynamic> sendVoiceMessage(File audioFile, String chatId,int durationSec) async {
    try {
      // 1. Token
      final token = GetStorage().read(tokenKey);


      // 2. Build FormData (dio package)
      final formData = getFrom.FormData.fromMap({"duration":durationSec});

      // 3. Attach voice file

        final mimeType =  'audio/mpeg';
        final mimeSplit = mimeType.split('/');
        final multipartFile = await getFrom.MultipartFile.fromFile(
          audioFile.path,
          filename: audioFile.path.split(Platform.pathSeparator).last,
          contentType: MediaType(mimeSplit[0], mimeSplit[1]),
        );

        formData.files.add(MapEntry('voiceFile', multipartFile));
      // } else {
      //   return LoginResponseModel(message: "Audio file not found");
      // }

      // 4. Send request
      final response = await dioClient.dio.post(
        'app/v1/chats/$chatId/voice',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            // Dio automatically sets the correct multipart boundary when you pass FormData
          },
        ),
      );

      // 5. Parse response
      final data = response.data as Map<String, dynamic>;

      return data;

      return LoginResponseModel.fromJson(data);
    } on DioException catch (dioError) {

    } catch (e, s) {
    }
  }
// app/v1/chats/69077bbd0d7f131eafdb9038/messages?page=1&limit=50&markAsRead=true



// ──────────────────────────────────────────────────────────────
//  Add this method inside ApiRepository (anywhere after the other methods)
// ──────────────────────────────────────────────────────────────
  Future<NotificationListModel> getNotifications({
    int page = 1,
    int limit = 20,
    bool unreadOnly = false,
  }) async
  {
    try {
      final response = await dioClient.dio.get(
        'app/v1/notifications/list',
        queryParameters: {
          'page': page,
          'limit': limit,
          'unreadOnly': unreadOnly,
          // "types":"unreadOnly"
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
            'accept': 'application/json',
          },
        ),
      );

      // The API always returns {status, message, data}
      if (response.data["status"]?.toString().toLowerCase() == "error") {
        return NotificationListModel(
          status: "error",
          message: response.data["message"]?.toString(),
        );
      }

      return NotificationListModel.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['message']?.toString() ??
          e.message ??
          "Network error";
      return NotificationListModel(status: "error", message: msg);
    } catch (e) {
      return NotificationListModel(
          status: "error", message: "Something went wrong");
    }
  }

  Future<dynamic> markAsRead() async {
    final response = await dioClient.dio.patch(
      'app/v1/notifications/mark-all-read',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }


  Future<dynamic> unBlurRequest( String targetUserId,String matchId) async {
    final response = await dioClient.dio.post(
      'app/v1/unblur/request',
      data: {
        "targetUserId": targetUserId,
        "matchId": matchId
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }


  Future<ChatBlockStatusResponseModel> getBlockChatStatus(String chatId) async {
    final response = await dioClient.dio.get(
      'app/v1/chats/$chatId/block/status',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return ChatBlockStatusResponseModel.fromJson( response.data);
  }

  Future<dynamic> getUnblurPendingRequest(String targetUserId) async {
    final response = await dioClient.dio.get(
      'app/v1/unblur/unblur-request',
      queryParameters: {
        'targetUserId': targetUserId,
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future<UnblurAccessCheckModel> getUnBlurProfileAccessCheck(String targetUserId) async {
    final response = await dioClient.dio.get(
      'app/v1/unblur/access/$targetUserId',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return UnblurAccessCheckModel.fromJson(response.data);
  }

  Future<DatePlanListResponseModel> getDatePlanTemplates({int page = 1, int limit = 20}) async {
    try {
      final response = await dioClient.dio.get(
        'app/v1/date-plans/templates',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
            'accept': 'application/json',
          },
        ),
      );

      if (response.data["status"].toString() == "error") {
        return DatePlanListResponseModel(
          message: response.data["message"].toString(),
        );
      } else {
        return DatePlanListResponseModel.fromJson(response.data);
      }
    } catch (e,s) {
      print("errror is $e");
      print("errror is $s");
      return DatePlanListResponseModel(
        message: "Failed to fetch date plans: ${e.toString()}",
      );
    }
  }


  Future<dynamic> sendDateProposal( var data) async {
    final response = await dioClient.dio.post(
      'app/v1/date-plans',
      data:data,
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }


  Future<dynamic> getUnreadNotificationCount() async {
    final response = await dioClient.dio.get(
      'app/v1/notifications/unread-count',

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }



  Future<InviteDetailsResponse> getInviteCardDetails() async {
    final response = await dioClient.dio.get(
      'app/v1/referrals/invite-info',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return InviteDetailsResponse.fromJson(response.data);
  }


  Future<dynamic> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final response = await dioClient.dio.post(
      'app/v1/user/change-password',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
      data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword,
      },

    );
    return response.data;
  }

  Future<dynamic> forgotPassword({
    required String email,

  }) async {
    final response = await dioClient.dio.post(
      'app/v1/auth/user/forgot-password',
      data: {
        "email": email
      },

    );
    return response.data;
  }

  Future<dynamic> resetPassword({
    required String email,
    required String otp,
    required String password,

  }) async {
    final response = await dioClient.dio.post(
      'app/v1/auth/user/reset-password',
      data: {

          "email": email,
          "otp": otp,
          "newPassword": password

      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );
    return response.data;
  }


  Future<dynamic> stopChat( String matchId) async {
    final response = await dioClient.dio.patch(
      "app/v1/matches/active/$matchId",
      data: {
        "isActive": false
      },
      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

  Future<dynamic> logout() async {
    final response = await dioClient.dio.post(
      "app/v1/auth/user/logout",

      options: Options(
        headers: {
          'Authorization': 'Bearer ${GetStorage().read(tokenKey)}',
          'accept': 'application/json',
        },
      ),
    );

    return response.data;
  }

}