

import 'package:get_storage/get_storage.dart';

import '../../../core/services/binding.dart';
import '../../../core/utils/string.dart';
import '../../bottom_bar/bottom_bar.dart';
import '/core/utils/export.dart';
import 'get_started_first.dart';
import 'on_boarding/screens/get_started_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 2),() {
      if( GetStorage().read(isLoginKey)??false){
        Get.offAll(()=>BottomNavBar());
      }else{
        Get.offAll(()=>GetStartedScreenFirst(),binding: GetStartedBinding());
      }


    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(splash_screen),fit: BoxFit.fill)
        ),

      ),
    );
  }
}
