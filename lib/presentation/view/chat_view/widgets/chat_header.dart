import 'dart:ui' as ui;

import 'package:blurry/core/services/binding.dart';
import 'package:blurry/core/utils/export.dart';
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/presentation/view/chat_view/widgets/report_dialog.dart';
import 'package:blurry/presentation/view/your_match/model/my_matches_list_model.dart';
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import 'package:get_storage/get_storage.dart';
import '../../../widgets/message_dialog.dart';
import '../../../widgets/progress_bar.dart';
import '../../unblur/view/unblur_confirmation_screen.dart';
import '../../unblur/view/unblur_decision_screen.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_message_model.dart';

class ChatHeader extends StatelessWidget {
  final MatchUser user;


  const ChatHeader({
    super.key,
    required this.user,
  });
  void _showReportDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) => ReportUserDialog(
        userName: user.name.toString(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final blur = GetStorage().read(blurPercentageKey).toString();
    final progressValue = (double.tryParse(blur) ?? 0) / 100;
    return Column(
      children: [
        InkWell(
          onTap: (){
            if(controller. unBlurProfileAccess.value.hasAccess??false){
              Get.to(() => const UnblurDecisionScreen(), transition: Transition.fadeIn,binding: UnblurBinding(targetUserDetails: controller.userDetails,targetUserId: controller.userDetails.id.toString(),matchId: controller.matchId.toString()));
            }else{

            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppThemeNotifier.background.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 14,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // User info row
                Row(
                  children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: AppThemeNotifier.textDisabled,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 4),
                    // Avatar
                    InkWell(
                      onTap: (){

                      },
                      child: Obx(
                        ()=> Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppThemeNotifier.primarySet2,
                              width: 0.7,
                            ),
                          ),
                          child: ClipOval(
                            child: ImageFiltered(
                              imageFilter: ui.ImageFilter.blur(
                                sigmaX:controller. unBlurProfileAccess.value .hasAccess ??false?0: 3.0,
                                sigmaY:controller. unBlurProfileAccess.value .hasAccess ??false?0: 3.0,
                                tileMode: TileMode.mirror,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: imageBaseUrl + user.avatar.toString(),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.person, color: Colors.grey),
                                ),
                                fadeInDuration: const Duration(milliseconds: 300),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // User details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                user.name.toString(),
                                style: TextStyles.titleMedium.copyWith(
                                  color: AppThemeNotifier.textTertiary,
                                ),
                              ),
                              Spacer(),
                              PopupMenuButton<String>(
                                child: Icon(
                                  Icons.more_vert,
                                  color: AppThemeNotifier.textSecondary,
                                  size: 22,
                                ),
                                onSelected: (value) {
                                  if (value == 'Report') {
                                    _showReportDialog(context);
                                  } else if (value == 'Block') {
                                    showCupertinoDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Obx(
                                          ()=> CupertinoMessageCustomDialog(
                                            topImage: Padding(
                                              padding: const EdgeInsets.only(bottom: 10.0),
                                              child: Image.asset("assets/icons/block.png",height: 22,),
                                            ),
                                            heading:
                                            (   controller. blockStatusData.value.isBlocked??false) && (controller. blockStatusData.value.blockedBy.toString() == controller.senderUser.id.toString())?
                                            'UnBlock ${user.name}?'
                                                :
                                            'Block ${ user.name} ?',
                                            title:
                                            (   controller. blockStatusData.value.isBlocked??false) && (controller. blockStatusData.value.blockedBy.toString() == controller.senderUser.id.toString())?
                                            'Messages from this person will reach you.'
                                             :
                                            'Messages from this person will no longer reach you.',
                                            leftButtonText: 'Cancel',
                                            onLeftButtonTap: () {
                                              Navigator.pop(context);
          
                                            },
                                            rightButtonText:
                                            controller.isLoadBlock.value?
                                                "Loading..."
                                                :
                                            (   controller. blockStatusData.value.isBlocked??false) && (controller. blockStatusData.value.blockedBy.toString() == controller.senderUser.id.toString())  ?"Yes Un Block":  'Yes Block',
                                            onRightButtonTap: () async {
                                              (   controller. blockStatusData.value.isBlocked??false) && (controller. blockStatusData.value.blockedBy.toString() == controller.senderUser.id.toString())?
                                              await controller.unBlockChat()
                                                  :
                                              await controller.blockUser();
                                             Navigator.pop(context);
                                            },
          
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                                color: AppThemeNotifier.background,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                offset: Offset(-15, 15),elevation: 8,
                                enabled: true,
          
                                shadowColor: AppThemeNotifier.border,
          
                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
          
                                    value: 'Report',
                                    child: Row(
                                      children: [
                                        Text('Report' ,
                                          style: TextStyles.titleMedium.copyWith(
                                            color: AppThemeNotifier.textPrimary,
          
                                          ),),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Block',
                                    child: Row(
                                      children: [
                                        Obx(
                                          ()=> Text(
                                            (   controller. blockStatusData.value.isBlocked??false) && (controller. blockStatusData.value.blockedBy.toString() == controller.senderUser.id.toString())     ?"UnBlock":
                                            'Block', style: TextStyles.titleMedium.copyWith(
                                            color: AppThemeNotifier.textPrimary,
          
                                          ),),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
          
                            ],
                          ),
          2.height,
                          Row(
                            children: [
                              Obx(() =>
                              controller.otherUserTyping.value
                                  ?  Text(
                                'typing...',
                                style: TextStyles.labelSmall.copyWith(
                                  color: AppThemeNotifier.textDisabled,
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                                  :
                              Text(
                                'Age: ${user.age} years',
                                style: TextStyles.labelSmall.copyWith(
                                  color: AppThemeNotifier.textDisabled,
                                ),
                              ),
                              ),
          
                              Spacer(),
                             Obx(()=>controller. unBlurProfileAccess.value .hasAccess ??false ?SizedBox():      InkWell(
                               onTap: (){
                                 Get.to(()=>UnblurConfirmationScreen(),binding: UnblurBinding(targetUserDetails: controller.userDetails,targetUserId: controller.userDetails.id.toString(),matchId: controller.matchId.toString()));
          
          
                               },
                               child: Container(
                                   padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                   decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(30),
                                       gradient: LinearGradient(colors:
                                       [
                                         AppThemeNotifier.primarySet1,
                                         AppThemeNotifier.primarySet2,
                                         AppThemeNotifier.primarySet3,
          
                                       ],begin: Alignment.topCenter,
                                           end:  Alignment.bottomCenter
                                       )
                                   ),
                                   child: Center(child: Text("Unblur 🔓 (1 Credit)",style: TextStyles.labelSmall.copyWith(color: AppThemeNotifier.onPrimary,fontSize: 10),))
                               ),
                             ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Menu button
          
                  ],
                ),
          
              ],
            ),
          ),
        ),

        // Unblur progress bar
        Obx(
          ()=> Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: CustomProgressBar(
              progress:
              controller. unBlurProfileAccess.value.hasAccess??false?1.0:
              progressValue, // 0.4
              label:

              controller. unBlurProfileAccess.value.hasAccess??false?
              '100% Unblurred'
          :
              '${(progressValue * 100).toStringAsFixed(0)}% Unblurred',
              height: 18,
            )
            ,
          ),
        ),
        20.height,
        // Row(
        //   children: [
        //     Expanded(
        //       child: ClipRRect(
        //         borderRadius: BorderRadius.circular(12),
        //         child: LinearProgressIndicator(
        //           value: user.unblurPercentage / 100,
        //           minHeight: 12,
        //           backgroundColor: Colors.grey[300],
        //           valueColor: AlwaysStoppedAnimation<Color>(
        //             Color(0xFF22C55E),
        //           ),
        //         ),
        //       ),
        //     ),
        //     SizedBox(width: 12),
        //     Container(
        //       padding: EdgeInsets.symmetric(
        //         horizontal: 12,
        //         vertical: 6,
        //       ),
        //       decoration: BoxDecoration(
        //         color: Color(0xFFE85D75),
        //         borderRadius: BorderRadius.circular(20),
        //       ),
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           Icon(
        //             Icons.lock,
        //             color: Colors.white,
        //             size: 14,
        //           ),
        //           SizedBox(width: 4),
        //           Text(
        //             'Unblur',
        //             style: TextStyles.labelSmall.copyWith(
        //               color: Colors.white,
        //               fontWeight: FontWeight.w600,
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ],
        // ),

      ],
    );
  }
}
