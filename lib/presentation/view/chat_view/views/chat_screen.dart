// view/chat_screen.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import '../controllers/chat_controller.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_message_bubble.dart';
import '../widgets/chat_input_field.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppThemeNotifier.primarySet1.withOpacity(0.1),
              AppThemeNotifier.primarySet2.withOpacity(0.5),
              AppThemeNotifier.primarySet3.withOpacity(0.9),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: 22.0,
                  sigmaY: 22.0,
                  tileMode: TileMode.mirror,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/chat_bg.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  // Header with user info
                  Obx(() {
                    if (controller.currentUser.value == null) {
                      return SizedBox(height: 80);
                    }
                    return ChatHeader(user: controller.currentUser.value!);
                  }),
                  // Messages list
                  Expanded(
                    child: Obx(() {
                      if (controller.isLoading.value && controller.messages.isEmpty) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      }

                      if (controller.messages.isEmpty) {
                        return Center(
                          child: Text(
                            'No messages yet. Start the conversation!',
                            style: TextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        );
                      }
                      return ListView.builder(
                        reverse: true,
                        controller: controller.scrollController,
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        itemCount: controller.messages.length + (controller.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == controller.messages.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            );
                          }

                          // Since we're using reverse: true, we need to get the message from the end of the list
                          final message = controller.messages[controller.messages.length - 1 - index];
                          return ChatMessageBubble(
                            message: message,
                            isLast: index == 0,
                            formatTime: controller.formatTime,
                          );
                        },
                      );
                      // return ListView.builder(
                      //   reverse: true,
                      //   controller: controller.scrollController,
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 12,
                      //     vertical: 0,
                      //   ),
                      //   itemCount: controller.messages.length + (controller.hasMore.value ? 1 : 0),
                      //   itemBuilder: (context, index) {
                      //     if (index == controller.messages.length) {
                      //        return Center(
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: CircularProgressIndicator(color: Colors.white),
                      //         ),
                      //       );
                      //     }
                      //     // Reverse index mapping: Last element in list is index 0 in UI
                      //     final msgIndex = controller.messages.length - 1 - index;
                      //     final message = controller.messages[msgIndex];
                      //     return ChatMessageBubble(
                      //       message: message,
                      //        isLast : index == 0,
                      //       formatTime: controller.formatTime,
                      //     );
                      //   },
                      // );
                    }),
                  ),
                  // Message input field
               Obx(() =>  controller. blockStatusData.value.isBlocked??false?
                   Container(
                     margin: EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                     height: 45,
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(50),
                       color: Colors.white30,
                     ),
                     child: Center(
                       child: Text(
                         (controller. blockStatusData.value.blockedBy.toString() == controller.senderUser.id.toString())
                             ? "You’ve blocked ${controller.userDetails.name}"
                             : "${controller.userDetails.name} has blocked you",style: TextStyles.titleMedium.copyWith(color: AppThemeNotifier.textPrimary),),
                     ),
                   )
                   :    ChatInputField(),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}