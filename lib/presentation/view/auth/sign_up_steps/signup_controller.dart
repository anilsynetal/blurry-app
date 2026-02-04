import 'dart:async';
import 'dart:io';

import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:blurry/presentation/widgets/message_dialog.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/services/binding.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/string.dart';
import '../../../../data/repository/api_repository.dart';
import '../../../../main.dart';
import '../../../bottom_bar/bottom_bar.dart';
import '../../lounge/lounge_selection_screen.dart';
import '../../plan/view/plan_price_screen.dart';

class SignUpStepsController extends GetxController {

  final ApiRepository authRepository;

  SignUpStepsController({required this.authRepository});

  // Steps: 0-identify, 1-basic info, 2-photo, 3-verify
  final RxInt currentStep = 0.obs;

  // Step 1 - identity
  final RxString gender = 'Men'.obs;
  final List<String> genders = const ['Men', 'Women', 'Prefer Not To Say', 'Other'];

  // Step 2 - basic info
  final Rx<DateTime?> dob = Rx<DateTime?>(null);
  final RxString location = ''.obs;
  final RxString ethnicity = ''.obs;

  // Height handling



  // Text controllers (reuse your commonTextField)
  final TextEditingController dobCtrl = TextEditingController();

  Rx<String> locationCtrl = "".obs;
  RxList<String> cityList = [
    // Major Cities
    'Amsterdam',
    'Rotterdam',
    'The Hague (Den Haag)',
    'Utrecht',
    'Eindhoven',
    'Tilburg',
    'Groningen',
    'Almere',
    'Breda',
    'Nijmegen',
    'Enschede',
    'Apeldoorn',
    'Haarlem',
    'Arnhem',
    'Amersfoort',
    'Zaanstad',
    'Hertogenbosch (Den Bosch)',
    'Zwolle',
    'Leiden',
    'Maastricht',
    'Dordrecht',
    'Leeuwarden',
    'Ede',
    'Emmen',
    'Venlo',
    'Delft',
    'Helmond',
    'Deventer',
    'Alkmaar',
    'Sittard-Geleen',
    'Roosendaal',
    'Hoofddorp',
    'Vlaardingen',
    'Heerlen',
    'Hilversum',
    'Assen',
    'Middelburg',
    'Lelystad',
    'Hengelo',
    'Oss',
    'Gouda',
    'Rijswijk',
    'Zeist',
    'Capelle aan den IJssel',
    'Katwijk',
    'Tiel',
    'Woerden',
    'Other / Outside Netherlands',
  ].obs;

  Rx<String> ethnicityCtrl = "".obs;
  RxList<String> ethnicityList = [
    'White / Caucasian',
    'South Asian (Indian Subcontinent)',
    'Black / African',
    'Arab / Middle Eastern / North African',
    'East Asian',
    'Southeast Asian',
    'Mixed / Multiracial',
    'Other',
    'Prefer not to answer',
  ].obs;

  final TextEditingController heightCtrl = TextEditingController();

  // Step 3/4 - photos
  final ImagePicker _picker = ImagePicker();
  // final Rx<XFile?> profilePhoto = Rx<XFile?>(null);
  final Rx<XFile?> verificationSelfie = Rx<XFile?>(null);

  // Step 4 - verification
  final RxBool termsAccepted = false.obs;
  final RxDouble scanProgress = 0.0.obs;
  Timer? _scanTimer;

  int get age {
    final d = dob.value;
    if (d == null) return 0;
    final now = DateTime.now();
    int years = now.year - d.year;
    if (now.month < d.month || (now.month == d.month && now.day < d.day)) {
      years--;
    }
    return years;
  }

  bool get canContinue {
    switch (currentStep.value) {
      case 0:
        return gender.value.isNotEmpty;
      case 1:
        final validHeight = useMetric.value
            ? heightCm.value > 0
            : (heightFt.value > 0 );
        return dob.value != null &&
            location.value.isNotEmpty &&
            ethnicity.value.isNotEmpty &&
            validHeight;
      case 2:
        return verificationSelfie.value != null;
      case 3:
        return verificationSelfie.value != null && termsAccepted.value;
      default:
        return false;
    }
  }
  final RxBool useMetric = true.obs; // true = cm, false = ft/in
  final RxDouble heightCm = 0.0.obs;
  final RxInt heightFt = 0.obs;

  void next() {
    if(currentStep.value == 0 ){
      String genderValue;

      switch (gender.value) {
        case 'Men':
          genderValue = 'male';
          break;
        case 'Women':
          genderValue = 'female';
          break;
        case 'Prefer Not To Say':
          genderValue = 'prefer not to say';
          break;
        case 'Other':
          genderValue = 'other';
          break;
        default:
          genderValue = 'prefer not to say';
      }

      var data = {
        "gender": genderValue,
      };
      updateProfile(data);
    }
    else if(currentStep.value == 1){
      if(dob.value == null){
        showWarningMessage("Please select your date of birth");
        return;
      }
     // else if( locationCtrl.value == ""){
     //    showWarningMessage("Please select your cities/Provinces");
     //    return;
     //  }
     else{
        submitProfileStep2();
      }

    }
    if (currentStep.value < 3) {
      currentStep.value += 1;
    }

  }

  void submitProfileStep2() {
    // Convert height properly based on unit
    double finalHeight;
    String heightUnit;

    if (useMetric.value) {
      finalHeight = heightCm.value;
      heightUnit = "cm";
    } else {
      // convert ft + in → cm (1 ft = 30.48 cm, 1 in = 2.54 cm)
      finalHeight = (heightFt.value * 30.48) ;
      heightUnit = "ft/in";
    }

    // Parse DOB correctly (MM → months, not mm)
    final parsedDob = DateFormat("yyyy-MM-dd").parse(dob.value.toString());

    // Prepare final data
    var data = {
      "dob": DateFormat("yyyy-MM-dd").format(parsedDob),
      "age": age,
      "height": finalHeight,
      "heightUnit": heightUnit,
      "ethnicity": ethnicityCtrl.value,
      "city": locationCtrl.value,
    };
    updateProfile(data);
  }

  Rx<bool> isLoading = false.obs;
  Future<void> updateProfile(var data) async {


    isLoading.value = true;
    try{
      await  authRepository.updateProfile(data).then((value) {

        GetStorage().write(userDataKey, value.toJson()??"");
      },).onError((error, stackTrace) {
        isLoading.value = false;
      },);
    }finally{
      isLoading.value = false;
    }

  }

  activeFreePlan() async {
    if(Platform.isIOS && GetStorage().read(isPlanEnable) == false){
      final response = await authRepository.getPlanList(
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
        }
      } else {
      }
    }
  }

  Future<void> updateProfileImage(String imgPath,context) async {

    // Check file size 5MB
    File imageFile = File(imgPath);
    int sizeInBytes = imageFile.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 5) {
      showMessageDialog("Image size must be less than 5 MB", "Warning");
      return;
    }


    isLoading.value = true;
    try{
      await  authRepository.updateProfilePicture(imgPath).then((value) {
        print("value is here ");
        if(value.status.toString() == "error" ){
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoMessageCustomDialog(
                topImage: Image.asset("assets/icons/close_ic.png",height: 80,),
                heading: 'Photo Verification Failed',
                title: '${value.message}',
                leftButtonText: 'Try Again Later',
                onLeftButtonTap: () {
                  Navigator.pop(context);

                },
                rightButtonText: '',
                onRightButtonTap: () {  },

              );
            },
          );
        }else{
          showCupertinoDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CupertinoMessageCustomDialog(
                topImage: Image.asset("assets/icons/check_success.png",height: 80,),
                heading: 'Photo Verification Successful!',
                title: 'Looking good! Your photo is verified — you’re ready to make some real connections. 🌟',
                leftButtonText: 'Continue',
                onLeftButtonTap: () async {
                  GetStorage().write(userDataKey, value.data!.user?.toJson()??"");
                  GetStorage().write(isLoginKey, true);
                  GetStorage().write(isRunningSignUp, false);
                  if(Platform.isIOS && GetStorage().read(isPlanEnable) == false){
                    await Get.to(() => LoungeSelectionScreen(), binding: LoungeBinding());
                    Get.offAll(()=>BottomNavBar());
                  }else{
                    Get.to(() => PricingScreen(), binding: PricingBinding());
                  }

                },
                rightButtonText: '',
                onRightButtonTap: () {

                },

              );
            },
          );
        }


      },).onError((error, stackTrace) {
        isLoading.value = false;
        verificationSelfie.value = null;
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoMessageCustomDialog(
              topImage: Image.asset("assets/icons/close_ic.png",height: 80,),
              heading: 'Photo Verification Failed',
              title: 'We can’t quite see you yet 😊 — snap a brighter, straight-on photo and try again.',
              leftButtonText: 'Try Again Later',
              onLeftButtonTap: () {
                Navigator.pop(context);

              },
              rightButtonText: '',
              onRightButtonTap: () {  },

            );
          },
        );
      },);
    }finally{
      isLoading.value = false;
    }








  }



  void back() {
    if (currentStep.value > 0) {
      currentStep.value -= 1;
    }
  }
  Future<void> pickDOB(BuildContext context) async {
    final now = DateTime.now();
    final themeData = Theme.of(context);

    // Calculate the date 18 years ago
    DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    // Handle leap year edge case: if Feb 29 was 18 years ago, but not a leap year now
    if (eighteenYearsAgo.month == 2 && eighteenYearsAgo.day == 29) {
      eighteenYearsAgo = DateTime(now.year - 18, 3, 1); // Move to March 1
    }

    // Ensure initialDate is not after 'now'
    final initialDate = eighteenYearsAgo.isAfter(now) ? now : eighteenYearsAgo;

    final iconColor = AppThemeNotifier.textPrimary;
    final headerBg = AppThemeNotifier.background;

    final customColorScheme = themeData.colorScheme.copyWith(
      onSurface: iconColor,
      onPrimary: iconColor,
      surface: headerBg,
      background: headerBg,
    );

    final customDatePickerTheme = themeData.datePickerTheme.copyWith(
      headerForegroundColor: iconColor,
      headerBackgroundColor: headerBg,
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.selected) ? Colors.white : iconColor;
      }),
      yearForegroundColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.selected) ? Colors.white : iconColor;
      }),
      weekdayStyle: TextStyle(color: AppThemeNotifier.primary),
    );

    final modifiedTheme = themeData.copyWith(
      datePickerTheme: customDatePickerTheme,
      colorScheme: customColorScheme,
      iconTheme: IconThemeData(color: iconColor, opacity: 1.0),
      primaryIconTheme: IconThemeData(color: iconColor),
      textTheme: themeData.textTheme.apply(bodyColor: iconColor, displayColor: iconColor),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: iconColor),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: iconColor),
      ),
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 100), // Allow older users (optional)
      lastDate: eighteenYearsAgo,         // CRITICAL: Cannot pick after this → must be 18+
      builder: (context, child) {
        return Theme(data: modifiedTheme, child: child!);
      },
    );

    if (picked != null && picked.isBefore(eighteenYearsAgo) || picked!.isAtSameMomentAs(eighteenYearsAgo)) {
      dob.value = picked;
      dobCtrl.text = "${picked!.day.toString().padLeft(2, '0')}/"
          "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    } else if (picked != null) {
      // Optional: Show error if somehow invalid (shouldn't happen)
     showWarningMessage("You must be at least 18 years old.");
    }
  }

  // Future<void> pickDOB(BuildContext context) async {
  //   final now = DateTime.now();
  //   final picked = await showDatePicker(
  //     context: context,
  //     firstDate: DateTime(now.year - 100, 1, 1),
  //     lastDate: now,
  //     initialDate: DateTime(now.year - 21, now.month, now.day),
  //
  //   );
  //   if (picked != null) {
  //     dob.value = picked;
  //     dobCtrl.text = "${picked.day.toString().padLeft(2, '0')}/"
  //         "${picked.month.toString().padLeft(2, '0')}/${picked.year}";
  //   }
  // }

  // Photo selection
  Future<void> takeProfilePhoto() async {
    final x = await _picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    if (x != null) verificationSelfie.value = x;
    currentStep.value = 3;
  }

  Future<void> pickProfileFromGallery() async {
    final x = await _picker.pickImage(source: ImageSource.gallery);
    if (x != null) verificationSelfie.value = x;
    currentStep.value = 3;
  }

  Future<void> takeVerificationSelfie() async {
    currentStep.value = 3;
  }

  void _startScan() {
    _scanTimer?.cancel();
    scanProgress.value = 0.0;
    _scanTimer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      scanProgress.value += 0.02;
      if (scanProgress.value >= 1.0) {
        scanProgress.value = 1.0;
        t.cancel();
      }
    });
  }

  @override
  void onClose() {
    _scanTimer?.cancel();

    super.onClose();
  }


  // Camera related
  CameraController? cameraController;
  final RxBool isCameraInitialized = false.obs;
  final RxBool isCapturing = false.obs;

  @override
  void onInit() {
    super.onInit();
    activeFreePlan();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await setupCameras();
      final frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
      );

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
      _startScan(); // Start animated progress
    } catch (e) {
      print("Camera init error: $e");
    }
  }

  Future<void> captureSelfie(context) async {
    if (cameraController == null || isCapturing.value) return;

    try {
      isCapturing.value = true;
      final xFile = await cameraController!.takePicture();
      verificationSelfie.value = XFile(xFile.path);
      scanProgress.value = 1.0; // Complete progress
      _scanTimer?.cancel();

    } catch (e) {

      print("Capture error: $e");
    } finally {
      isCapturing.value = false;
    }
  }
}
