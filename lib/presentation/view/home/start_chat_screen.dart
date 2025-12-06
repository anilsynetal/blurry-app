


import 'dart:ui' as ui;

import 'package:blurry/presentation/view/your_match/model/my_matches_list_model.dart';

import '../../../core/services/binding.dart';
import '../../widgets/common_button.dart';
import '../chat_view/views/chat_screen.dart';
import '/core/utils/export.dart';


class StartChatScreen extends StatefulWidget {
  const StartChatScreen({super.key});

  @override
  State<StartChatScreen> createState() => _StartChatScreenState();
}

class _StartChatScreenState extends State<StartChatScreen> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              AppThemeNotifier.primarySet1,
              AppThemeNotifier.primarySet2,
              AppThemeNotifier.primarySet3,
            ],
            begin: Alignment.topCenter,
              end :Alignment.bottomCenter
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/new_match.png",height: 90,),

              Stack(
                children: [
                  Image.asset("assets/images/heart_background.png",fit: BoxFit.cover),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(width: 180,height: 120,),
                              Positioned(
                                left: 0,
                                  top: 0,
                                  bottom: 0,
                                  child:  Container(

                                height: 95,
                                width: 95,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppThemeNotifier.onPrimary,width: 1),
                                    image: DecorationImage(image: AssetImage("assets/images/Profile_picture.png"))
                                ),
                              ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child:  Container(

                                  height: 95,
                                  width: 95,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: AppThemeNotifier.onPrimary,width: 1),
                                      image: DecorationImage(image: AssetImage("assets/images/Profile_picture.png"))
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 0,
                                right: 0,

                                bottom: 20,
                                child:  Center(
                                  child:Image.asset("assets/images/rectangle.png",height: 30,)
                                ),
                              )
                            ],
                          ),
                          10.height,
                          Text("❤️Boom! You and Alex are \nnow matched 💫",style: TextStyles.bodySmall.copyWith(color: AppThemeNotifier.onPrimary),textAlign: TextAlign.center,)
                        ],
                      ))
                ],
              ),
              10.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: gradientButton(
                  height: 48,
                  buttonText: 'Start a Chat!',
                  onPressed: (){
                    Get.to(()=>ChatScreen(),binding: ChatBinding(
                      chatIdPass: "",
                      matchId: "1",
                        userDetails: MatchUser(id: "1",age: 28,
                        bio: "Hi Im dnfgdf vrgdv ",
                        name: "Alex Vollox",
                        lastActive: DateTime.now(),
                        avatar: "https://images.unsplash.com/photo-1609132718484-cc90df3417f8?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1287")
                    ));
                  },
                ),
              ),
              10.height,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: (){
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: AppThemeNotifier.onPrimary,width: 0.4)
                      ),
                      child: Center(
                        child: Text("Cancel",style: TextStyles.bodyMedium.copyWith(color: AppThemeNotifier.onPrimary),),
                      ),

                  ),
                ),
              )
            ],
          ),
      
        ),
      ),
    );
  }
}

