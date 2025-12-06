// widgets/chat_input_field.dart
import 'package:blurry/presentation/widgets/common_button.dart';
import 'package:flutter/material.dart';
import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/typography.dart';
import '../../../../core/utils/export.dart';
import '../controllers/chat_controller.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ChatController>();

    return Obx(
          () => Column(
        children: [
          // Typing indicator

          Row(
            children: [
              const SizedBox(width: 5),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppThemeNotifier.background,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ctrl.recordingState.value == RecordingState.idle
                      ? TextField(
                    controller: ctrl.messageController,
                    onChanged: ctrl.updateMessageText,
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyles.bodySmall.copyWith(
                        color: AppThemeNotifier.textDisabled,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: TextStyles.bodySmall.copyWith(
                      color: AppThemeNotifier.textPrimary,
                    ),
                    maxLines: null,
                  )
                      : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        const SizedBox(width: 5),
                        Icon(Icons.mic,
                            color: AppThemeNotifier.primary, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          ctrl.formatDuration(ctrl.recordingDuration.value),
                          style: TextStyle(
                            color: AppThemeNotifier.textPrimary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        if (ctrl.recordingState.value ==
                            RecordingState.recording)
                          SlideTransition(
                            position: ctrl.cancelTextAnimation,
                            child: Text(
                              'Slide to cancel',
                              style: TextStyles.bodyMedium
                                  .copyWith(color: Colors.grey),
                            ),
                          )
                        else if (ctrl.recordingState.value ==
                            RecordingState.locked)
                          InkWell(
                            onTap: ctrl.cancelRecording,
                            child: Text(
                              'Cancel',
                              style: TextStyles.bodyMedium
                                  .copyWith(color: Colors.grey),
                            ),
                          ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),

              // ------------------- SEND / MIC BUTTON -------------------
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Obx(() {
                  final hasText = ctrl.messageText.value.isNotEmpty;

                  // SEND TEXT
                  if (hasText) {
                    return GestureDetector(
                      onTap: ctrl.isSending.value ? null : ctrl.sendMessage,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppThemeNotifier.background,
                          ),
                          child: Image.asset("assets/icons/send.png",
                              color: AppThemeNotifier.textPrimary)
                              .paddingAll(12),
                        ),
                      ),
                    );
                  }

                  // VOICE RECORDER
                  return GestureDetector(
                    onLongPressStart: (_) => ctrl.startRecording(),
                    onLongPressEnd: (_) {
                      if (ctrl.recordingState.value == RecordingState.recording) {
                        ctrl.stopRecording(send: true);
                      }
                    },
                    onTap: () {
                      if (ctrl.recordingState.value == RecordingState.locked) {
                        ctrl.stopRecording(send: true);
                      }
                    },
                    onLongPressMoveUpdate: ctrl.handleDragUpdate,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedBuilder(
                          animation: ctrl.micScaleAnimation,
                          builder: (context, _) {
                            final scale = ctrl.recordingState.value ==
                                RecordingState.locked
                                ? 1.0
                                : ctrl.micScaleAnimation.value;
                            return Transform.scale(
                              scale: scale,
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppThemeNotifier.background,
                                  ),
                                  child: ctrl.recordingState.value ==
                                      RecordingState.locked
                                      ? Image.asset("assets/icons/send.png",
                                      color: AppThemeNotifier.textPrimary)
                                      .paddingAll(12)
                                      : Image.asset("assets/icons/mic.png",
                                      color: AppThemeNotifier.textPrimary)
                                      .paddingAll(12),
                                ),
                              ),
                            );
                          },
                        ),
                        if (ctrl.recordingState.value == RecordingState.recording)
                          Positioned(
                            top: -40,
                            child: SlideTransition(
                              position: ctrl.lockSlideAnimation,
                              child: gradientButton(
                                height: 36,
                                width: 36,
                                child: Icon(Icons.lock,
                                    color: AppThemeNotifier.onPrimary, size: 20),
                                onPressed: () {},
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}