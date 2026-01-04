
import 'dart:io';

import 'package:blurry/presentation/widgets/time_config.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'core/services/binding.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/export.dart';
import 'core/utils/string.dart';
import 'firebase_options.dart';
import 'presentation/view/auth/splash_screen.dart';

late List<CameraDescription> cameras;

Future<void> setupCameras() async {
  cameras = await availableCameras();
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TimeZoneHelper.initialize();
  try {
    await setupCameras();
  } catch (e) {
    debugPrint("Camera initialization failed: $e");
    cameras = [];
  }
  // await ScreenUtil.ensureScreenSize();

 // if(Platform.isAndroid){
   try {
     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
     FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
     FirebaseMessaging.onMessage.listen(showFlutterNotification );
     await setupFlutterNotifications();
   } catch (e,s) {
     debugPrint(s.toString());
     debugPrint(e.toString());
   }
 // }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();
  Get.put(AppThemeNotifier(), permanent: true);
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: Get.find<AppThemeNotifier>().getLightTheme(),
      darkTheme: Get.find<AppThemeNotifier>().getDarkTheme(),
      title: "$appName",
      initialBinding:AuthBinding(),
      defaultTransition: Transition.fadeIn, // 👈 Default transition
      transitionDuration: const Duration(milliseconds: 200), // 👈 Speed
      home: SplashScreen(),
      builder: (context, child) {
        return SafeArea(
          top: false, // Set to true if you want to avoid notch overlap too
          bottom: true, // Avoids overlap with navigation bar
          child: child!,
        );
      },
    );

  }
}

