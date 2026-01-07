
import 'dart:io';

import 'package:blurry/core/utils/string.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


import '../../../../core/services/binding.dart';
import '../../../../data/repository/api_repository.dart';
import '../../../bottom_bar/bottom_bar.dart';
import '../../../widgets/getx_message_toast.dart';
import '../otp_verify_screen.dart';
import '../sign_up_steps/signup_steps_screen.dart';

class LoginController extends GetxController {

  final ApiRepository authRepository;

  LoginController({required this.authRepository});

  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }


  final TextEditingController phoneController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool termsAccepted = false.obs;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    await _requestNotificationPermission();
    fetchDeviceFCMToken();
    super.onInit();
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;
    print("status $status");
    if (status.isDenied || status.isPermanentlyDenied) {
      // Show permission dialog
      await Permission.notification.request();
    }
  }

  RxString deviceToken = "device123".obs;


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

  Future<void> login() async {

    if(emailController.value.text.isEmpty){
      showWarningMessage("Please enter valid email address");
      return ;
    }
    if(passwordController.value.text.isEmpty){
      showWarningMessage("Please enter your password");
      return ;
    }

    if (!termsAccepted.value) {
      showWarningMessage("Please accept Terms of Service & Privacy Policy");
      return;
    }

    isLoading.value = true;
    try{
      await  authRepository.logIn(emailController.value.text, passwordController.value.text,  deviceToken.value).then((value) async {
        if(value.status == "success"){
          GetStorage().write(isGuest, false);
          GetStorage().write(tokenKey, value.data?.token??"");
          GetStorage().write(userNameKey, value.data!.user!.name??"");
          GetStorage().write(emailKey, value.data!.user!.email??"");
          GetStorage().write(userDataKey, value.data!.user!.toJson()??"");
          if(value.data?.user?.gender == null ||value.data?.user?.dob == null || value.data?.user?.avatar == null  ){
            GetStorage().write(isLoginKey, false);
            GetStorage().write(isRunningSignUp, true);
            Get.to(()=>SignUpStepsScreen(),binding: SignUpStepsBinding());
          }else{
            // await getMyLounges();
            GetStorage().write(isLoginKey, true);
            GetStorage().write(isRunningSignUp, false);
            Get.offAll(()=>BottomNavBar());
          }

        }else{
          showErrorMessage(value.message??"Login Failed");
        }
      },).onError((error, stackTrace) {
        isLoading.value = false;
      },);
    }finally{
      isLoading.value = false;
    }
  }


  // getMyLounges() async{
  //   try{
  //     await authRepository.getMyLounges().then((value) {
  //       GetStorage().write(yourSaveLoungeKey,value["data"]);
  //     },);
  //   }finally{
  //   }
  // }

  final _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  AuthService() {
    _initializeGoogleSignIn();
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  /// Always check Google sign in initialization before use
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    await _ensureGoogleSignInInitialized();

    try {
      // authenticate() throws exceptions instead of returning null
      final GoogleSignInAccount account = await _googleSignIn.authenticate(
        scopeHint: ['email','profile'],  // Specify required scopes
      );
      return account;
    } on GoogleSignInException catch (e) {

      } catch (error) {
        print('Unexpected Google Sign-In error: $error');
        rethrow;
      }
    }


  Future<String?> getAccessTokenForScopes(List<String> scopes) async {
    await _ensureGoogleSignInInitialized();

    try {
      final authClient = _googleSignIn.authorizationClient;

      // Try to get existing authorization
      var authorization = await authClient.authorizationForScopes(scopes);

      if (authorization == null) {
        // Request new authorization from user
        authorization = await authClient.authorizeScopes(scopes);
      }

      return authorization?.accessToken;
    } catch (error) {
      print('Failed to get access token for scopes: $error');
      return null;
    }
  }
  // Manage user state manually
  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;

  bool get isSignedIn => _currentUser != null;


  RxBool isLoadGoogleLogin = false.obs;
  Future<void> signIn() async {


    isLoadGoogleLogin.value = true;

    try{
      _currentUser = await signInWithGoogle();

      var data = {
        "idToken": "${_currentUser?.id}",
        "name": "${_currentUser!.displayName}",
        "email": "${_currentUser!.email}",
        // "avatar": "${_currentUser!.photoUrl}",
        "deviceToken": "${deviceToken.value}",
        "platform":Platform.isAndroid ?"android":"ios"
      };
      await  authRepository.googleLogin(data).then((value) async {
        GetStorage().write(isGuest, false);
        if(value.status == "success"){
          GetStorage().write(tokenKey, value.data?.token??"");
          GetStorage().write(userNameKey, value.data!.user!.name??"");
          GetStorage().write(emailKey, value.data!.user!.email??"");
          GetStorage().write(userDataKey, value.data!.user!.toJson()??"");
          if(value.data?.user?.gender == null ||value.data?.user?.dob == null || value.data?.user?.avatar == null  ){
            GetStorage().write(isLoginKey, false);
            GetStorage().write(isRunningSignUp, true);
            Get.to(()=>SignUpStepsScreen(),binding: SignUpStepsBinding());
          }else{
            // await getMyLounges();
            GetStorage().write(isLoginKey, true);
            GetStorage().write(isRunningSignUp, false);
            Get.offAll(()=>BottomNavBar());
          }

        }else{
          showErrorMessage(value.message??"Login Failed");
        }
      },).onError((error, stackTrace) {
        isLoadGoogleLogin.value = false;
      },);
    }finally{
      isLoadGoogleLogin.value = false;
    }
  }

  Future<void> appleSignIn() async {
    isLoadGoogleLogin.value = true;

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final fullName = [
        credential.givenName,
        credential.familyName,
      ].where((e) => e != null && e.isNotEmpty).join(' ');

      final data = {
        "identityToken": credential.identityToken, // ✅ CORRECT
        "name": fullName.isNotEmpty ? fullName : null,
        "email": credential.email, // may be null after first login
        "deviceToken": deviceToken.value,
        "platform": "ios",


        //       "identityToken": "${credential.userIdentifier}",
        //       "name": "${fullName}",
        //       "email": "${credential?.email}",
        //       // "avatar": "",
        //       "deviceToken": "${deviceToken.value}",
        //       "platform":"ios"
      };

      final value = await authRepository.appleLogin(data);

      GetStorage().write(isGuest, false);

      if (value.status == "success") {
        GetStorage().write(tokenKey, value.data?.token ?? "");
        GetStorage().write(userNameKey, value.data?.user?.name ?? "");
        GetStorage().write(emailKey, value.data?.user?.email ?? "");
        GetStorage().write(userDataKey, value.data?.user?.toJson());

        if (value.data?.user?.gender == null ||
            value.data?.user?.dob == null ||
            value.data?.user?.avatar == null) {
          GetStorage().write(isLoginKey, false);
          GetStorage().write(isRunningSignUp, true);
          Get.to(() => SignUpStepsScreen(),
              binding: SignUpStepsBinding());
        } else {
          GetStorage().write(isLoginKey, true);
          GetStorage().write(isRunningSignUp, false);
          Get.offAll(() => BottomNavBar());
        }
      } else {
        showErrorMessage(value.message ?? "Login Failed");
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint("Apple auth error: ${e.message}");
    } catch (e) {
      debugPrint("Unexpected Apple error: $e");
    } finally {
      isLoadGoogleLogin.value = false;
    }
  }



  // Future<void> appleSignIn() async {
  //   // Show the same loader that Google uses
  //   isLoadGoogleLogin.value = true;
  //   try {
  //     // 1. Trigger Apple native UI
  //     final credential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );
  //     // 2. Build the payload exactly like Google
  //     final String? fullName = credential.givenName != null
  //         ? '${credential.givenName} ${credential.familyName ?? ''}'.trim()
  //         : null;
  //
  //     var data = {
  //       "identityToken": "${credential.userIdentifier}",
  //       "name": "${fullName}",
  //       "email": "${credential?.email}",
  //       // "avatar": "",
  //       "deviceToken": "${deviceToken.value}",
  //       "platform":"ios"
  //     };
  //     await  authRepository.appleLogin(data).then((value) async {
  //       GetStorage().write(isGuest, false);
  //       if(value.status == "success"){
  //         GetStorage().write(tokenKey, value.data?.token??"");
  //         GetStorage().write(userNameKey, value.data!.user!.name??"");
  //         GetStorage().write(emailKey, value.data!.user!.email??"");
  //         GetStorage().write(userDataKey, value.data!.user!.toJson()??"");
  //         if(value.data?.user?.gender == null ||value.data?.user?.dob == null ||value.data?.user?.avatar == null  ){
  //           GetStorage().write(isLoginKey, false);
  //           GetStorage().write(isRunningSignUp, true);
  //           Get.to(()=>SignUpStepsScreen(),binding: SignUpStepsBinding());
  //         }else{
  //           // await getMyLounges();
  //           GetStorage().write(isLoginKey, true);
  //           GetStorage().write(isRunningSignUp, false);
  //           Get.offAll(()=>BottomNavBar());
  //         }
  //
  //       }else{
  //         showErrorMessage(value.message??"Login Failed");
  //       }
  //     },).onError((error, stackTrace) {
  //       isLoadGoogleLogin.value = false;
  //     },);
  //
  //
  //   } on SignInWithAppleAuthorizationException catch (e) {
  //     // User cancelled or Apple not available
  //     // showErrorMessage(e.message);
  //   } catch (e) {
  //     debugPrint("Unexpected Apple error: $e");
  //     // showErrorMessage("Unexpected error");
  //   } finally {
  //     isLoadGoogleLogin.value = false;
  //   }
  // }
}