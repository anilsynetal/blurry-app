// widgets/chat_message_bubble.dart
import 'package:blurry/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:blurry/core/theme/typography.dart';
import '../../../../core/utils/export.dart';
import '../controllers/chat_controller.dart';
import '../models/chat_message_model.dart';
import 'audio_player.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String Function(DateTime) formatTime;
  final bool isLast;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.formatTime,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final isCurrentUser =
        message.sender.toString() == controller.senderUser.id.toString();

    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: isCurrentUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          // Message bubble or audio player
          message.messageType.toString() == "voice"
              ? AudioPlayerWidget(
                  audioPath: message.localPath,
                  audioUrl: message.voiceUrl,
                  isCurrentUser: isCurrentUser,
                  duration: Duration(seconds: message.voiceDuration ?? 0),
                )
              : Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isCurrentUser
                        ? AppThemeNotifier.background
                        : Color(0xFFFFE7E0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      bottomLeft: Radius.circular(isCurrentUser ? 18 : 4),
                      bottomRight: Radius.circular(isCurrentUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        message.content.toString(),
                        style: TextStyles.bodySmall.copyWith(
                          color: isCurrentUser
                              ? Color(0xFF1F2937)
                              : Color(0xFF6B1F17),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 4),
          // Timestamp
          Text(
            formatTime(message.timestamp ?? DateTime.now()),
            style: TextStyles.labelSmall.copyWith(
              color: AppThemeNotifier.onPrimary,
              fontSize: 11,
            ),
          ),
          // isCurrentUser ?SizedBox(): isLast? Obx(()=> controller.otherUserTyping.value? Text(
          //     'typing...',
          //     style: TextStyles.labelSmall.copyWith(
          //       color: AppThemeNotifier.onPrimary,
          //       fontStyle: FontStyle.italic,
          //     ),
          //   )
          //   :SizedBox(),):SizedBox()
        ],
      ),
    );
  }
}
