import 'dart:ui' as ui;
import 'package:blurry/presentation/view/home/response/respond_privately_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:shimmer/shimmer.dart';

import '../../../core/services/binding.dart';

import '../../../core/utils/string.dart';
import '../../widgets/confirmation_dialog.dart';

import '../../widgets/progress_bar.dart';
import '../../widgets/time_config.dart';
import '../chat_view/views/chat_screen.dart';

import '../plan/view/plan_price_screen.dart';
import 'controller/your_match_controller.dart';


class YourMatchScreen extends StatelessWidget {

  const YourMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blur = GetStorage().read(blurPercentageKey).toString();
    final blurAfter = GetStorage().read(blurPercentageAfterKey).toString();
    final progressValue = (double.tryParse(blur) ?? 0) / 100;
    final progressAfterValue = 1.0-(double.tryParse(blurAfter) ?? 0) / 100 ;

    return GetBuilder<YourMatchController>(
      init: YourMatchController(repository: Get.find(),socketService: Get.find()),
      builder: (YourMatchController controller) {
        return Scaffold(
          backgroundColor: AppThemeNotifier.surface,
          appBar: _buildAppBar(controller),
          body: SafeArea(
            child: Obx(
                  ()=> RefreshIndicator(
                onRefresh: ()async{
                  controller.getMyMatchesListApi(isRefresh: true);
                },
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [

                      _buildPlanSection(controller),
                      const SizedBox(height: 10),
                      Divider(height: 1,thickness: 1,color: AppThemeNotifier.border,),
                      const SizedBox(height: 10),

                      if(controller.isLoading.value )...[
                        ...List.generate(3, (index) {
                          return  Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 3),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: 140, // Approximate height of a plan card
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                          );
                        },),
                      ]
                      else if (controller.matchesList.isEmpty)
                        Center(
                          child: Padding(
                            padding:  EdgeInsets.only(top: Get.height*0.14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset("assets/json/empty_heart.json",height: 100),
                                Text(
                                  "No matches yet 🫶",
                                  style: TextStyles.bodyMedium.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Start swiping and find your perfect match! ",
                                  style: TextStyles.bodyMedium.copyWith(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )

                      else
                        ...List.generate(controller.matchesList.length, (index) {
                          var matchData = controller.matchesList[index];
                          String status = matchData.status??"";
                          String timeAgoString = timeAgo(matchData.createdAt??DateTime.now());
                          return Stack(
                            children: [
                              InkWell(
                                onTap:(){
                                  if( status.toString() != AccessRequestStatus.pending.value){
                                    controller.matchesList[index].unreadMessageCount = 0;
                                    Get.to(()=>ChatScreen(),binding: ChatBinding(chatIdPass: matchData.chatId??"",matchId :matchData.matchId.toString(), userDetails: matchData.user!))!.then((value) {
                                      controller.matchesList[index].unreadMessageCount = 0;
                                      controller.matchesList.refresh();
                                      print(" matchData.unreadMessageCount ${  controller.matchesList[index].unreadMessageCount}");
                                    },);

                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 5),
                                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                                  decoration: BoxDecoration(
                                      border: Border.all(color:   status.toString() == AccessRequestStatus.pending.value? Colors.transparent:AppThemeNotifier.border,width: 1),
                                      color:
                                      status.toString() == AccessRequestStatus.pending.value?
                                      Color(0x21E47E63):AppThemeNotifier.background,
                                      borderRadius: BorderRadius.circular(16)
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(2),
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: AppThemeNotifier.primarySet1.withOpacity(0.5),
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipOval(
                                              child: ImageFiltered(
                                                imageFilter: ui.ImageFilter.blur(
                                                  sigmaX: matchData.unblurRequest?.status.toString() == "approved" ? 0 : 3,
                                                  sigmaY: matchData.unblurRequest?.status.toString() == "approved" ? 0 : 3,
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: "$imageBaseUrl${matchData.user?.avatar}",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Shimmer.fromColors(
                                                    baseColor: Colors.grey[300]!,
                                                    highlightColor: Colors.grey[100]!,
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    decoration: const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: AssetImage("assets/images/Profile_picture.png"),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // ClipOval(
                                          //   child: Container(
                                          //     margin: EdgeInsets.all(2),
                                          //     height: 50,
                                          //     width: 50,
                                          //     decoration: BoxDecoration(
                                          //       shape: BoxShape.circle,
                                          //       border: Border.all(
                                          //         color: AppThemeNotifier.primarySet1.withOpacity(0.5),
                                          //         width: 1,
                                          //       ),
                                          //     ),
                                          //     child: CachedNetworkImage(
                                          //       imageUrl: "${imageBaseUrl}${matchData.user!.avatar.toString()}",
                                          //       fit: BoxFit.cover,
                                          //       imageBuilder: (context, imageProvider) => Container(
                                          //         decoration: BoxDecoration(
                                          //           shape: BoxShape.circle,
                                          //           image: DecorationImage(
                                          //             image: imageProvider,
                                          //             fit: BoxFit.cover,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       placeholder: (context, url) => Shimmer.fromColors(
                                          //         baseColor: Colors.grey[300]!,
                                          //         highlightColor: Colors.grey[100]!,
                                          //         child: Container(
                                          //           decoration: BoxDecoration(
                                          //             shape: BoxShape.circle,
                                          //             color: Colors.grey[300],
                                          //           ),
                                          //         ),
                                          //       ),
                                          //       errorWidget: (context, url, error) => Container(
                                          //         decoration: BoxDecoration(
                                          //           shape: BoxShape.circle,
                                          //           image: DecorationImage(
                                          //             image: AssetImage("assets/images/Profile_picture.png"),
                                          //             fit: BoxFit.cover,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),

                                          12.width,
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${matchData.user?.name??""}",
                                                style: TextStyles.bodyMedium.copyWith(
                                                  fontSize: 15,
                                                  color: AppThemeNotifier.textSecondary,

                                                ),
                                              ),
                                              3.height,
                                              status.toString() == AccessRequestStatus.pending.value?
                                              Row(
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30),
                                                      color:AppThemeNotifier.background,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Image.asset("assets/icons/uil_18-plus.png",height: 16,),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          "${matchData.user?.age??""}",
                                                          style: TextStyles.labelMedium.copyWith(
                                                            color: AppThemeNotifier.textPrimary,
                                                            fontSize: 11,

                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  8.width,
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(30),
                                                      color:AppThemeNotifier.background,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Image.asset("assets/icons/distance.png",height: 16,),
                                                        const SizedBox(width: 4),
                                                        Text(
                                                          "${matchData.user?.city??""}",
                                                          style: TextStyles.labelMedium.copyWith(
                                                            color: AppThemeNotifier.textPrimary,
                                                            fontSize: 11,

                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ):
                                              matchData.message == null ?2.height:      Row(
                                                children: [
                                                  SizedBox(
                                                    width: Get.width*0.6,
                                                    child:

                                                    Text("${matchData.message}",style: TextStyles.bodySmall.copyWith(
                                                      color: AppThemeNotifier.textDisabled,fontSize: 14,
                                                    ),maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              status.toString() == AccessRequestStatus.pending.value?SizedBox():
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2.0),
                                                child: Text("${timeAgoString}",style: TextStyles.labelSmall.copyWith(color: AppThemeNotifier.textDisabled),),
                                              )

                                            ],),
                                        ],
                                      ),

                                      status.toString() == AccessRequestStatus.pending.value?
                                      matchData.message == null ?SizedBox(height: 12,):    Padding(
                                        padding: const EdgeInsets.only(top: 4.0,bottom: 8),
                                        child: Text(
                                          "${matchData.message ??""}",
                                          maxLines: 2,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyles.bodyMedium.copyWith(
                                            color: AppThemeNotifier.textSecondary,
                                            height: 1.4,

                                          ),
                                        ),
                                      ):SizedBox(),

                                      ( matchData.requester?.id.toString() == GetStorage().read(userDataKey)["_id"].toString() &&   status.toString() == AccessRequestStatus.pending.value)?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          gradientButton(
                                              width: Get.width*0.5,
                                              isLoading: controller.isLoadingUpdate.value && controller.loadingIndex.value == index && controller.loadType.value ==AccessRequestStatus.approved.value,
                                              textStyle: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.onPrimary ,fontSize: 13),
                                              height: 30,
                                              buttonText: "Requested", onPressed: (){

                                            // showCupertinoDialog(
                                            //   context: context,
                                            //   builder: (BuildContext context) {
                                            //     return CupertinoCustomDialog(
                                            //       heading: '⏳ Match Expiring Soon',
                                            //       title: 'Your chat with Alex is fading... ⏳\n24 hours left before it disappears.',
                                            //       subtitle: 'Send a quick message to keep it alive 💬✨',
                                            //       leftButtonText: 'Let It Expire',
                                            //       rightButtonText: 'Send Message',
                                            //       onLeftButtonTap: () {
                                            //         Navigator.pop(context);
                                            //
                                            //       },
                                            //       onRightButtonTap: () {
                                            //         Navigator.pop(context);
                                            //
                                            //       },
                                            //     );
                                            //   },
                                            // );


                                          }),
                                        ],
                                      )
                                          :
                                      status.toString() == AccessRequestStatus.pending.value?   Obx(
                                            ()=> Row(
                                          children: [
                                            Flexible(
                                              child: commonButton(
                                                  type: ButtonType.outlined,
                                                  backgroundColor: AppThemeNotifier.textDisabled.withOpacity(0.3),
                                                  // textColor: AppThemeNotifier.textSecondary,
                                                  textStyle: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.textSecondary ,fontSize: 13),
                                                  height: 30,
                                                  isLoading: controller.isLoadingUpdate.value && controller.loadingIndex.value == index && controller.loadType.value ==AccessRequestStatus.denied.value,
                                                  buttonText: "Ignore", onPressed: (){

                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return CupertinoCustomDialog(
                                                      heading: 'Ignore Match Request',
                                                      title: 'Are You Sure?',
                                                      subtitle: '🚫 You won’t be able to chat with this person if you ignore the request.',
                                                      leftButtonText: 'Cancel',
                                                      rightButtonText: 'Ignore Request',
                                                      onLeftButtonTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      onRightButtonTap: () {
                                                        controller.respondToMatch(matchData.matchId.toString(),AccessRequestStatus.denied.value,index);
                                                        Navigator.pop(context);
                                                      },
                                                    );

                                                  },
                                                );
                                              }),
                                            ),
                                            10.width,
                                            Flexible(
                                              child: gradientButton(
                                                  isLoading: controller.isLoadingUpdate.value && controller.loadingIndex.value == index && controller.loadType.value ==AccessRequestStatus.approved.value,
                                                  textStyle: TextStyles.labelMedium.copyWith(color: AppThemeNotifier.onPrimary ,fontSize: 13),
                                                  height: 30,
                                                  buttonText: "Accept", onPressed: (){

                                                showCupertinoDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return CupertinoCustomDialog(
                                                      heading: 'Accept Match Request',
                                                      title: 'Ready to Connect?',
                                                      subtitle: '💬✨ Accept this match request and start chatting!',
                                                      leftButtonText: 'Cancel',
                                                      rightButtonText: 'Accept Request',
                                                      onLeftButtonTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      onRightButtonTap: () {
                                                        controller.respondToMatch(matchData.matchId.toString(),AccessRequestStatus.approved.value,index);
                                                        Navigator.pop(context);
                                                      },
                                                    );

                                                  },
                                                );
                                                // showCupertinoDialog(
                                                //   context: context,
                                                //   builder: (BuildContext context) {
                                                //     return CupertinoCustomDialog(
                                                //       heading: '⏳ Match Expiring Soon',
                                                //       title: 'Your chat with Alex is fading... ⏳\n24 hours left before it disappears.',
                                                //       subtitle: 'Send a quick message to keep it alive 💬✨',
                                                //       leftButtonText: 'Let It Expire',
                                                //       rightButtonText: 'Send Message',
                                                //       onLeftButtonTap: () {
                                                //         Navigator.pop(context);
                                                //
                                                //       },
                                                //       onRightButtonTap: () {
                                                //         Navigator.pop(context);
                                                //
                                                //       },
                                                //     );
                                                //   },
                                                // );


                                              }),
                                            ),

                                          ],
                                        ),
                                      ):   Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: CustomProgressBar(
                                              progress:
                                              matchData.unblurRequest?.status.toString() == "approved"?
                                                  1.0
                                                  :
                                              progressValue, // 0.4
                                              label:
                                              matchData.unblurRequest?.status.toString() == "approved"?
                                                  '100% Unblurred'
                                                  :
                                                  '${(progressValue * 100).toStringAsFixed(0)}% Unblurred',
                                              height: 20,
                                            )


                                      ),
                                      3.height
                                    ],
                                  ),
                                ),
                              ),
                              status.toString() == AccessRequestStatus.pending.value?
                              Obx(
                                    ()=> Positioned(
                                    top:10,right:24,
                                    child: Text("${timeAgoString}",style: TextStyles.labelSmall.copyWith(color: AppThemeNotifier.textDisabled),)),
                              )
                                  :
                              Obx(
                          ()=> Positioned(
                                    top:12,right:24,
                                    child:

                                    controller.matchesList[index].unreadMessageCount == null ||   controller.matchesList[index].unreadMessageCount == 0?SizedBox():gradientButton(
                                        height: 22,width:22,
                                        onPressed: (){},
                                        buttonText: "${controller.matchesList[index].unreadMessageCount}",
                                        child: Text("${controller.matchesList[index].unreadMessageCount}",style: TextStyles.labelSmall.copyWith(color: AppThemeNotifier.onPrimary,fontSize: 10),
                                        )
                                    )),
                              )
                            ],
                          );
                        },),

                      // _buildProfileCardsList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }

  PreferredSizeWidget _buildAppBar(YourMatchController controller) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppThemeNotifier.surface,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Obx(() {
            return Text(
              "Your Matches",
              style: TextStyles.headlineMedium.copyWith(
                color: AppThemeNotifier.textPrimary,

              ),
            );
          }),

         Spacer(),
          Image.asset("assets/images/heart_lock.png",height: 16,),

          Obx(()=> Text("${controller.matchesList.where((e) => e.status.toString().toLowerCase() == AccessRequestStatus.approved.value.toString().toLowerCase()).toList().length}/${controller.matchesList.length} matches used",style: TextStyles.bodySmall.copyWith(color: AppThemeNotifier.textDisabled),))
        ],
      ),
    );
  }


  Widget _buildPlanSection(YourMatchController controller) {
    return Obx(
      ()=> Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child:
        controller.isLoadMyPlan.value
            ? Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 120, // Approximate height of a plan card
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        )
            : (controller.selectedPlan.value.id == "" ||
            controller.selectedPlan.value.id == null)
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "No Active Plan Yet 💡",
                  style: TextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ),

            ],
          ),
        )
            : buildPlanCard(
          controller.selectedPlan.value,
          0,
              () {},
          true,
        )
      ),
    );
  }



}

String timeAgo(DateTime apiDate) {


  // apiDate must be treated as UTC
 final now  = TimeZoneHelper.nowNetherlands();


  final Duration diff = now.difference(apiDate);

  if (diff.inSeconds < 60) {
    return 'just now';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays}d ago';
  } else {
    return DateFormat('dd MMM yyyy').format(apiDate);
  }
}


