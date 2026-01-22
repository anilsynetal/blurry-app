

import 'package:blurry/core/services/socket_service.dart';
import 'package:blurry/presentation/view/profile/controller/privacy_policy_controller.dart';
import 'package:blurry/presentation/view/profile/controller/term_and_condition_controller.dart';
import 'package:get/get.dart';
import '../../data/api/api_client.dart';
import '../../data/repository/api_repository.dart';
import '../../presentation/view/auth/controller/get_started_controller.dart';
import '../../presentation/view/auth/controller/login_controller.dart';
import '../../presentation/view/auth/controller/otp_controller.dart';
import '../../presentation/view/auth/controller/signup_controller.dart';
import '../../presentation/view/auth/forgot_password/forgot_password_controller.dart';
import '../../presentation/view/auth/sign_up_steps/signup_controller.dart';
import '../../presentation/view/chat_view/controllers/chat_controller.dart';
import '../../presentation/view/home/model/lounges_response_model.dart';
import '../../presentation/view/home/response/respond_privately_controller.dart';
import '../../presentation/view/lounge/lounge_controller.dart';
import '../../presentation/view/lounge/model/lounge_list_response_model.dart';
import '../../presentation/view/lounge/vibe_controller.dart';
import '../../presentation/view/plan/controller/invite_controller.dart';
import '../../presentation/view/plan/controller/plan_price_controller.dart';
import '../../presentation/view/plan/model/plan_model.dart';
import '../../presentation/view/profile/controller/change_password_controller.dart';
import '../../presentation/view/profile/edit_profile/edit_profile_controller.dart';
import '../../presentation/view/profile/notification/notification_controller.dart';
import '../../presentation/view/unblur/controller/plan_your_date_controller.dart';
import '../../presentation/view/unblur/controller/unblur_controller.dart';
import '../../presentation/view/your_match/model/my_matches_list_model.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    // Get.put(DioClient(), permanent: true);
    // Get.put(AuthRepository(), permanent: true);
    // Get.lazyPut(() => AuthController(loginRepository: Get.find()));
  }
}

class OTPBinding extends Bindings {
  final String email;

  OTPBinding({required this.email});

  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<OTPController>(() => OTPController(authRepository:Get.find(),emailAddress: email ));
  }
}
class GetStartedBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<GetStartedController>(() => GetStartedController(apiRepository:Get.find() ));
  }
}


class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<LoginController>(() => LoginController(authRepository:Get.find() ));
  }
}


class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<SignupController>(() => SignupController(authRepository: Get.find()));
  }
}


class SignUpStepsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<SignUpStepsController>(() => SignUpStepsController(authRepository: Get.find()));
  }
}
class PricingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<InviteController>(() => InviteController());
    Get.lazyPut<PricingController>(() => PricingController(repository: Get.find()));
  }
}

class LoungeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<LoungeController>(() => LoungeController(repository: Get.find()));
  }
}


class VibeBinding extends Bindings {
  final LoungesData selectedLounges;
  final String exitingDescription;


  VibeBinding({required this.selectedLounges,required this.exitingDescription});
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<VibeController>(() => VibeController(exitingDescription: exitingDescription,repository: Get.find(),selectedLounges :selectedLounges));
  }
}

class RespondPrivatelyBinding extends Bindings {
  final MemberData profile;
  RespondPrivatelyBinding({required this.profile});
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<RespondPrivatelyController>(
          () => RespondPrivatelyController(repository:  Get.find(),profile: profile),
    );
  }
}

class ChatBinding extends Bindings {
  final MatchUser userDetails;
  final String matchId;
  final String chatIdPass;

  ChatBinding({required this.userDetails,required this.matchId,required this.chatIdPass});

  @override
  void dependencies() {
    Get.lazyPut(() => ScoreSocketController());
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<ChatController>(() => ChatController(chatIdPass:chatIdPass,socketService: Get.find(),repository: Get.find(),userDetails: userDetails,matchId:matchId));
  }
}

class UnblurBinding extends Bindings {
  final String targetUserId;
  final String matchId;
  final MatchUser targetUserDetails;


  UnblurBinding({required this.targetUserId, required this.matchId,required this.targetUserDetails});
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<UnblurController>(() => UnblurController(targetUserDetails: targetUserDetails,socketService: Get.find(),matchId: matchId,targetUserId: targetUserId,repository: Get.find()));
  }
}


class PlanYourDateBinding extends Bindings {
  final String matchId;
  final String targetUserId;

  PlanYourDateBinding({required this.matchId, required this.targetUserId});
  @override
  void dependencies() {
    Get.lazyPut<PlanYourDateController>(() => PlanYourDateController(matchId: matchId,targetUserId: targetUserId));
  }
}



class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationController>(
          () => NotificationController(),
    );
  }
}

class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<EditProfileController>(
          () => EditProfileController(
            apiRepository: Get.find()
          ),
    );
  }
}

class PrivacyPolicyBinding extends Bindings {

  PrivacyPolicyBinding();

  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController(authRepository:Get.find() ));
  }
}
class TermConditionBinding extends Bindings {


  TermConditionBinding();

  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<TermAndConditionController>(() => TermAndConditionController(authRepository:Get.find()));
  }
}


class ChangePasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<ChangePasswordController>(
          () => ChangePasswordController(
        apiRepository: Get.find<ApiRepository>(),
      ),
    );
  }
}

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioClient(), permanent: true);
    Get.put(ApiRepository(), permanent: true);
    Get.lazyPut<ForgotPasswordController>(
          () => ForgotPasswordController(
        apiRepository: Get.find<ApiRepository>(),
      ),
    );
  }
}