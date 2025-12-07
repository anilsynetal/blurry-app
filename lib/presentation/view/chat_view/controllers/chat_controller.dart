// controllers/chat_controller.dart
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:blurry/core/utils/string.dart';
import 'package:blurry/data/repository/api_repository.dart';
import 'package:blurry/presentation/view/chat_view/models/chat_block_response_model.dart';
import 'package:blurry/presentation/view/chat_view/models/report_reason.dart';
import 'package:blurry/presentation/widgets/getx_message_toast.dart';
import 'package:blurry/presentation/widgets/showErrorDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'package:uuid/uuid.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/services/chat_sqlite_service.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../core/utils/export.dart';
import '../../../bottom_bar/bottom_bar.dart';
import '../../../widgets/confirmation_dialog.dart';
import '../../../widgets/credit_widget.dart';
import '../../../widgets/time_config.dart';
import '../../unblur/model/unblur_access_status.dart';
import '../../unblur/view/unblur_confirmation_screen.dart';
import '../../your_match/controller/your_match_controller.dart';
import '../../your_match/model/my_matches_list_model.dart' show MatchUser;
import '../models/chat_message_model.dart';

enum RecordingState { idle, recording, locked, canceled, sent }

class ChatController extends GetxController with GetTickerProviderStateMixin {
  final ScoreSocketController socketService;
  final ApiRepository repository;
  final MatchUser userDetails;
  final String matchId;
  final String chatIdPass;
  ChatController({
    required this.socketService,
    required this.repository,
    required this.userDetails,
    required this.matchId,
    required this.chatIdPass,
  });

  final messages = <ChatMessage>[].obs;
  final isLoading = true.obs;
  final currentUser = Rxn<MatchUser>();
  final senderUser = MatchUser(
    id: GetStorage().read(userDataKey)["_id"],
    name: GetStorage().read(userNameKey),
  );
  final messageText = ''.obs;
  final isSending = false.obs;
  final isTyping = false.obs;
  final otherUserTyping = false.obs;
  final blurAfter = GetStorage().read(blurPercentageAfterKey).toString();

  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Pagination
  int page = 1;
  final int limit = 10;
  final hasMore = true.obs;
  final isLoadMoreRunning = false.obs;

  // Database service
  // final DatabaseService _databaseService = DatabaseService();

  /* --------------------------------------------------------------------- */
  /* -------------------------- VOICE PART ------------------------------ */
  /* --------------------------------------------------------------------- */
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final recordingState = RecordingState.idle.obs;
  final recordingDuration = Duration.zero.obs;
  final dragOffset = Offset.zero.obs;
  final recordingPath = Rxn<String>();

  late AnimationController micScaleController;
  late AnimationController lockSlideController;
  late AnimationController cancelTextController;

  late Animation<double> micScaleAnimation;
  late Animation<Offset> lockSlideAnimation;
  late Animation<Offset> cancelTextAnimation;

  Timer? _recordingTimer;
  Timer? _typingTimer;

  /* --------------------------------------------------------------------- */
  /* --------------------------- LIFECYCLE ------------------------------- */
  /* --------------------------------------------------------------------- */
  @override
  Future<void> onInit() async {
    super.onInit();

    currentUser.value = userDetails;
    getReportReasonList();
    // Animation controllers need a TickerProvider → use GetX's built-in one
    micScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    lockSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    cancelTextController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _setupAnimations();

    // Initialize socket (safe to call now)
    socketService.initializeSocket();

    // Handle socket connection changes
    ever(socketService.isConnected, (connected) {
      if (connected) {
        _refreshSocketListeners();
      }
    });

    // Initial setup if already connected
    if (socketService.isConnected.value) {
      _refreshSocketListeners();
    }

    if (chatIdPass.toString() == "") {
      await getChatId();
    } else {
      print("chatIdPass is $chatIdPass");
      chatId.value = chatIdPass.toString();
      getBlckStatus();
      getUnblurRequest();
      getUnBlurProfile();
    }

    loadMessages();

    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.hasClients && scrollController.position.pixels >= scrollController.position.maxScrollExtent - 100) {
      loadMoreMessages();
    }
  }

  void _refreshSocketListeners() {
    _removeSocketListeners();
    _setupSocketListeners();
    joinChat();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();

    micScaleController.dispose();
    lockSlideController.dispose();
    cancelTextController.dispose();

    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _recordingTimer?.cancel();
    _typingTimer?.cancel();

    _removeSocketListeners();

    super.onClose();
  }

  void _setupAnimations() {
    micScaleAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: micScaleController, curve: Curves.easeInOut),
    );

    lockSlideAnimation =
        Tween<Offset>(
          begin: const Offset(0, 1.0), // start below mic
          end: const Offset(0, -1.0), // move above mic
        ).animate(
          CurvedAnimation(parent: lockSlideController, curve: Curves.easeInOut),
        );

    cancelTextAnimation =
        Tween<Offset>(
          begin: const Offset(-0.2, 0),
          end: const Offset(0.2, 0),
        ).animate(
          CurvedAnimation(
            parent: cancelTextController,
            curve: Curves.easeInOut,
          ),
        );
  }

  void _setupSocketListeners() {
    if (socketService.socket == null) return;
    print("new_message listner on");
    socketService.socket?.on('new_message', _onNewMessage);
    socketService.socket?.on('typing', _onTyping);
    socketService.socket?.on('stop_typing', _onStopTyping);
    socketService.socket?.on('chat_block_success', _onChatBlockSuccess);
    socketService.socket?.on('chat_unblock_success', _onChatUnblockSuccess);
    socketService.socket?.on('unblur_approval_sent', _onUnblurApprovalSent);
    socketService.socket?.on('unblur_denial_sent', _onUnblurDenialSent);
    socketService.socket?.on('unblur_request_denied', _onUnblurRequestDenied);

    print("✅ Adding listener for unblur_request_approved");
    socketService.socket?.on('unblur_request_approved', (data) {
      print(
        "🔥 INLINE LISTENER: unblur_request_approved triggered with: $data",
      );
      debugPrint(
        "🔥 INLINE LISTENER: unblur_request_approved triggered with: $data",
      );
      _onUnblurRequestApproved(data);
    });

    socketService.socket?.on('chat_blocked', _onChatBlocked);
    socketService.socket?.on('chat_unblocked', _onChatUnblocked);
    socketService.socket?.on('unblur_request_received',
      _onUnblurRequestReceived,
    );
    socketService.socket?.on('unblur_request_sent', _onUnblurRequestSent);
  }

  void _removeSocketListeners() {
    if (socketService.socket == null) return;

    socketService.socket?.off('new_message', _onNewMessage);

    socketService.socket?.off('typing', _onTyping);
    socketService.socket?.off('stop_typing', _onStopTyping);
    socketService.socket?.off('chat_block_success', _onChatBlockSuccess);
    socketService.socket?.off('chat_unblock_success', _onChatUnblockSuccess);
    socketService.socket?.off('unblur_approval_sent', _onUnblurApprovalSent);
    socketService.socket?.off('unblur_denial_sent', _onUnblurDenialSent);
    socketService.socket?.off('unblur_request_denied', _onUnblurRequestDenied);
    socketService.socket?.off(
      'unblur_request_approved',
    ); // Remove all listeners for this event

    socketService.socket?.off('chat_blocked', _onChatBlocked);
    socketService.socket?.off('chat_unblocked', _onChatUnblocked);
    socketService.socket?.off('unblur_request_received');
    socketService.socket?.off('unblur_request_sent', _onUnblurRequestSent);
  }

  // Socket Event Handlers
  void _onNewMessage(data) {
    debugPrint("New Message receive data is $data");
    log("New Message receive data is $data");
    print("New Message receive data is $data");
    if (data['chatId'] == chatId.value) {
      final message = ChatMessage.fromJson(data['message']);
      if (message.sender != senderUser.id) {
        messages.add(message);
        // _databaseService.saveMessage(message, chatId.value);
        _scrollToBottom();
      }
      // Mark as read if it's not from current user
      if (message.sender != senderUser.id) {
        markMessagesAsRead();
      }
    }
  }

  void _onTyping(data) {
    if (data['userId'] != senderUser.id) {
      otherUserTyping.value = true;
    }
  }

  void _onStopTyping(data) {
    print("is Typing is ");
    debugPrint("is Typing is ");
    if (data['userId'] != senderUser.id) {
      otherUserTyping.value = false;
    }
  }

  void _onChatBlockSuccess(data) {
    log('Chat blocked: $data');
    showSuccessMessage(data["message"]);
    isLoadBlock.value = false;
  }

  void _onChatUnblockSuccess(data) {
    log('Chat Un blocked: $data');
    showSuccessMessage(data["message"]);
    isLoadBlock.value = false;
  }

  void _onUnblurApprovalSent(data) {
    showSuccessMessage(data["message"]);
  }

  void _onUnblurDenialSent(data) {
    showSuccessMessage(data["message"]);
  }

  void _onUnblurRequestDenied(data) {
    print("unblur_request_denied ${data}");
    if (data["approvedBy"].toString() != senderUser.id.toString()) {
      getUnBlurProfile();
      showMessageDialog("Your unblur request was denied", "Request declined");
    }
  }

  void _onUnblurRequestApproved(data) {
    debugPrint("_onUnblurRequestApproved called with data: $data");
    print("_onUnblurRequestApproved called with data: $data");
    if (data["approvedBy"].toString() != senderUser.id.toString()) {
      getUnBlurProfile();
      showMessageDialog("Your unblur request was approved", "Request approved");
      repository.getMatchDetails(matchId).then((value) {
        final controller = Get.find<YourMatchController>();
        int index = controller.matchesList.indexWhere(
          (element) => element.matchId.toString() == matchId.toString(),
        );
        if (index != -1) {
          controller.matchesList[index] = value;
          controller.matchesList.refresh(); // notify GetX listeners
        }
      });
    }
  }

  void _onChatBlocked(data) {
    log('Chat blocked: $data');
    blockStatusData.value = ChatBlockedResponseData(
      isBlocked: true,
      chatId: data["chatId"],
      blockedAt: data["blockedAt"],
      blockedBy: data["blockedBy"].toString(),
    );
  }

  void _onChatUnblocked(data) {
    log('Chat blocked: $data');
    blockStatusData.value = ChatBlockedResponseData(
      isBlocked: false,
      chatId: data["chatId"],
      blockedAt: data["blockedAt"].toString(),
      blockedBy: data["blockedBy"],
    );
  }

  bool isUnblurRequestDialogOpen = false;

  void _onUnblurRequestReceived(data) {
    print("unblur_request_received request received success $data");

    if (isUnblurRequestDialogOpen) return;

    isUnblurRequestDialogOpen = true;

    showCupertinoDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Unblur Request Received",
                  style: TextStyles.headlineMedium.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: CupertinoColors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              BlurredImageCard(
                title: 'Current Blur',
                blurSigma: 10.0,
                percentage: '$blurAfter%',
                isDialog: true,
                imagePath: "assets/images/Profile_picture.png",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: Text(
                  "Your Partner has requested to see your photo more clearly.",
                  style: TextStyles.bodySmall.copyWith(
                    color: AppThemeNotifier.textSecondary,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () {
                declineUnBlurRequest(data["requestId"]);
                Get.back();
                isUnblurRequestDialogOpen = false;
              },
              child: Text(
                "Decline",
                style: TextStyles.titleMedium.copyWith(
                  color: Color(0xFF2194FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),



            CupertinoDialogAction(
              onPressed: () {
                approveUnBlurRequest(data["requestId"]);
                Get.back();
                isUnblurRequestDialogOpen = false;
              },
              child: Text(
                "Accept Request",
                style: TextStyles.titleMedium.copyWith(
                  color: Color(0xFF2194FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      isUnblurRequestDialogOpen = false;
    });
  }

  void _onUnblurRequestSent(data) async {
    isLoadUnBlur.value = false;
    showMessageDialog(data["message"], "Success");
    Get.back();
  }

  /* --------------------------------------------------------------------- */
  /* --------------------------- TEXT LOGIC ------------------------------ */
  /* --------------------------------------------------------------------- */

  Future<void> loadMessages({bool loadMore = false}) async {
    try {
      if (loadMore) {

        isLoadMoreRunning(true);
      } else {
        isLoading(true);
        page = 1;
        hasMore.value = true;
        messages.clear();
      }

      // Then fetch from server
      if (chatId.value != "") {
        await repository.getChatMessage(chatId: chatId.toString(), page: page,).then((value) {
          var fetchedMessages = value.data?.chat?.messages?.reversed ?? [];
          hasMore.value = value.data?.pagination?.hasMore ?? false;

          print("hasMore.value value ${hasMore.value}");

          if (loadMore) {
            // Prepend older messages at the beginning
            messages.insertAll(0, fetchedMessages);
          } else {
            // For initial load, set all messages
            messages.value = fetchedMessages.toList();
            _scrollToBottom();
          }
          // Increment page for next load
          page++;
        });
      }
    } catch (e) {
      print("Catch error is $e");
    } finally {
      isLoading(false);
      isLoadMoreRunning(false);
    }
  }

  Future<void> loadMoreMessages() async {
    if(hasMore.value && !isLoadMoreRunning.value ){
      await loadMessages(loadMore: true);
    }

  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;
    print("Send Message 1");
    try {
      isSending(true);
      print("Send Message 2");
      final content = messageController.text.trim();

      // Create temporary message
      final tempId = const Uuid().v4();
      final tempMsg = ChatMessage(
        id: tempId,
        sender: senderUser.id,
        content: content,
        timestamp: TimeZoneHelper.nowNetherlands(),
        messageType: "text",
        isRead: false,
      );
      print("Send Message 3");
      // Add to UI immediately
      messages.add(tempMsg);
      // _databaseService.saveMessage(tempMsg, chatId.value);
      _scrollToBottom();
      print("Send Message 4");
      // Send via socket
      if (socketService.isConnected.value) {
        print("Send Message 5 ${content} ${chatId}");
        socketService.socket?.emit('send_message', {
          'chatId': chatId.value,
          'content': content,
          'messageType': 'text',
        });
      } else {
        print("Send Message 6");
        // Fallback to API if socket is not connected
        final response = await repository.sendMessage(
          chatId: chatId.toString(),
          content: content,
          messageType: "text",
        );

        // Update with server response
        final serverMsg = ChatMessage(
          id: response["data"]["message"]["_id"],
          sender: response["data"]["message"]["sender"]["id"],
          content: response["data"]["message"]["content"],
          timestamp: DateTime.parse(
            response["data"]["message"]["timestamp"].toString(),
          ),
          messageType: response["data"]["message"]["messageType"],
          isRead: response["data"]["message"]["isRead"],
          readAt: response["data"]["message"]["readAt"],
        );

        // Replace temp message with server message
        final index = messages.indexWhere((msg) => msg.id == tempId);
        if (index != -1) {
          messages[index] = serverMsg;
          // _databaseService.saveMessage(serverMsg, chatId.value);
        }
      }
      print("Send Message 7");
      messageController.clear();
      messageText('');
    } catch (e, s) {
      print("error is $e");
      print("error is $s");
      messageController.text = messageText.value;
    } finally {
      isSending(false);
    }
  }

  void updateMessageText(String text) {
    messageText(text);

    // Send typing indicator
    if (text.isNotEmpty && !isTyping.value) {
      isTyping.value = true;
      socketService.socket?.emit('typing', {'chatId': chatId.value});

      // Reset typing timer
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 1), () {
        isTyping.value = false;
        socketService.socket?.emit('stop_typing', {'chatId': chatId.value});
      });
    } else if (text.isEmpty && isTyping.value) {
      isTyping.value = false;
      socketService.socket?.emit('stop_typing', {'chatId': chatId.value});
    } else if (text.isNotEmpty && isTyping.value) {
      // Reset timer if user continues typing
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 1), () {
        isTyping.value = false;
        socketService.socket?.emit('stop_typing', {'chatId': chatId.value});
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          0.0, // 0.0 is the bottom in a reversed ListView
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String formatTime(DateTime dateTime) {
    final now = TimeZoneHelper.nowNetherlands();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } else {
      final int hour = dateTime.hour > 12
          ? dateTime.hour - 12
          : (dateTime.hour == 0 ? 12 : dateTime.hour);
      final String period = dateTime.hour >= 12 ? 'PM' : 'AM';
      return '$hour:${dateTime.minute.toString().padLeft(2, '0')} $period';
    }
  }

  Future<void> markMessagesAsRead() async {
    try {
      // await _databaseService.markMessagesAsRead(chatId.value);
      // Also notify server if needed
      if (socketService.isConnected.value) {
        socketService.socket?.emit('mark_as_read', {'chatId': chatId.value});
      }
    } catch (e) {
      print("Error marking messages as read: $e");
    }
  }

  /* --------------------------------------------------------------------- */
  /* -------------------------- VOICE LOGIC ------------------------------ */
  /* --------------------------------------------------------------------- */
  void _startRecordingTimer() {
    recordingDuration(Duration.zero);
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      recordingDuration.value += const Duration(milliseconds: 100);
    });
  }

  Future<void> startRecording() async {
    try {
      final allowed = await checkAndRequestPermission();

      if (!allowed) {
        // ❌ Do NOT enter locked/recording here
        // ❌ User must LONG PRESS AGAIN to start recording
        recordingState(RecordingState.idle);
        return;
      } else {
        // Permission was granted → Now start recording UI
        recordingState(RecordingState.recording);
        micScaleController.forward();
        lockSlideController.forward();

        final dir = await getTemporaryDirectory();
        final path = '${dir.path}/${const Uuid().v4()}.wav';

        await _audioRecorder.start(
          const RecordConfig(encoder: AudioEncoder.wav),
          path: path,
        );

        recordingPath(path);
        _startRecordingTimer();
      }
    } catch (e) {
      recordingState(RecordingState.idle);
    }
  }

  Future<bool> checkAndRequestPermission() async {
    // Check current state
    // final alreadyGranted = await _audioRecorder.hasPermission();
    final alreadyGranted = await Permission.microphone.isGranted;

    if (alreadyGranted) {
      // User had permission before this cycle
      return true;
    } else {
      await Permission.microphone.request();
      return false;
    }
  }

  // Future<void> startRecording() async {
  //   try {
  //
  //     if (!await _audioRecorder.hasPermission()) return;
  //
  //     // OR alternatively:
  //     final dir = await getTemporaryDirectory();
  //     final path = '${dir.path}/${const Uuid().v4()}.wav';
  //     await _audioRecorder.start(
  //       const RecordConfig(encoder: AudioEncoder.wav),
  //       path: path,
  //     );
  //
  //     recordingPath(path);
  //     recordingState(RecordingState.recording);
  //     micScaleController.forward();
  //     lockSlideController.forward();
  //     _startRecordingTimer();
  //   } catch (e) {
  //     recordingState(RecordingState.idle);
  //   }
  // }
  Future<void> stopRecording({bool send = false}) async {
    await _audioRecorder.stop();
    _recordingTimer?.cancel();
    micScaleController.reverse();
    lockSlideController.reverse();

    recordingState(RecordingState.idle);
    int secDuration = recordingDuration.value.inSeconds;
    recordingDuration(Duration.zero);
    dragOffset(Offset.zero);

    if (send && recordingPath.value != null && secDuration != 0) {
      await Future.delayed(const Duration(milliseconds: 100));
      await sendVoiceMessage(File(recordingPath.value!), secDuration);
    }

    recordingPath(null);
  }

  Future<void> sendVoiceMessage(File audioFile, int durationSec) async {
    try {
      isSending(true);

      // Create temporary message
      final tempId = const Uuid().v4();
      final tempMsg = ChatMessage(
        id: tempId,
        sender: senderUser.id,
        content: 'Voice message',
        timestamp: TimeZoneHelper.nowNetherlands(),
        messageType: "voice",
        isRead: false,
        voiceDuration: durationSec,
        localPath: audioFile.path,
      );

      // Add to UI immediately
      messages.add(tempMsg);
      // _databaseService.saveMessage(tempMsg, chatId.value);
      _scrollToBottom();

      // Send via API

      final response = await repository.sendVoiceMessage(
        audioFile,
        chatId.value,
        durationSec,
      );

      if (response['status'] == 'success') {
        // Update with server response
        final serverMsg = ChatMessage(
          id: response["data"]["message"]["_id"],
          sender: response["data"]["message"]["sender"]["_id"],
          content: response["data"]["message"]["content"],
          voiceUrl: response["data"]["message"]["voiceUrl"],
          voiceDuration: response["data"]["message"]["voiceDuration"],
          timestamp: DateTime.parse(
            response["data"]["message"]["timestamp"].toString(),
          ),
          messageType: response["data"]["message"]["messageType"],
          isRead: response["data"]["message"]["isRead"],
          readAt: response["data"]["message"]["readAt"],
        );
        print("senderUser.id is  ${senderUser.id}");
        print("sendVoiceMessage ${response}");

        socketService.socket?.emit('send_message', {
          'chatId': chatId.value,
          'content': serverMsg.content,
          'voiceDuration': serverMsg.voiceDuration,
          'voiceUrl': serverMsg.voiceUrl,
          'messageType': "voice",
        });
        print("send_message woring ${response}");
        // Replace temp message with server message
        final index = messages.indexWhere((msg) => msg.id == tempId);
        if (index != -1) {
          messages[index] = serverMsg;
          // _databaseService.saveMessage(serverMsg, chatId.value);
        }
      } else {
        // Show error and remove temp message
        showErrorMessage(response['message'] ?? 'Failed to send voice message');
        messages.removeWhere((msg) => msg.id == tempId);
      }
    } catch (e) {
      showErrorMessage('Failed to send voice message: $e');
    } finally {
      isSending(false);
    }
  }

  Future<void> cancelRecording() async {
    await _audioRecorder.cancel();
    _recordingTimer?.cancel();
    micScaleController.reverse();
    lockSlideController.reverse();

    recordingState(RecordingState.canceled);
    recordingDuration(Duration.zero);
    dragOffset(Offset.zero);

    Future.delayed(const Duration(milliseconds: 300), () {
      recordingState(RecordingState.idle);
    });
  }

  void lockRecording() {
    recordingState(RecordingState.locked);
    dragOffset(Offset.zero);
  }

  void handleDragUpdate(LongPressMoveUpdateDetails details) {
    dragOffset(details.localOffsetFromOrigin);

    if (dragOffset.value.dy < -50) {
      lockRecording();
    } else if (dragOffset.value.dx < -100) {
      cancelRecording();
    }
  }

  String formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatDurationApi(Duration d) =>
      d.toString().split('.').first.padLeft(8, '0');

  /* --------------------------------------------------------------------- */
  /* --------------------------- UI HELPERS ------------------------------ */
  /* --------------------------------------------------------------------- */
  void resetUI() {
    recordingState(RecordingState.idle);
    micScaleController.reset();
    lockSlideController.reset();
    cancelTextController.reset();
  }

  Rx<bool> isLoadBlock = false.obs;

  Future<void> blockUser() async {
    try {
      isLoadBlock.value = true;
      final data = {"chatId": chatId.value, "reason": 'Inappropriate behavior'};
      socketService.socket?.emitWithAck('block_chat', data, ack: (response) {});
    } catch (e) {
      print("Error blocking user: $e");
    } finally {}
  }

  RxBool isLoadUnBlur = false.obs;

  confirmUnblur(context) async {
    if (Get.find<WalletController>().walletCredit.value > 1) {
      isLoadUnBlur.value = true;
      try {
        final data = {
          "targetUserId": userDetails.id,
          "matchId": matchId,
          "requestType": 'profile',
        };
        print("request_unblur request send success $data");
        socketService.socket?.emitWithAck(
          'request_unblur',
          data,
          ack: (response) {},
        );
      } catch (e, s) {
      } finally {}
    } else {
      showCupertinoDialog(
        context: context,

        builder: (BuildContext context) {
          return CupertinoCustomDialog(
            heading: 'Not Enough Credits',
            title: 'Oops!🫠 You need more credits to see this photo clearly.',
            subtitle: 'Each unblur step costs 1 credit per user.',

            leftButtonText: 'Cancel',
            rightButtonText: 'Buy Credits',
            onLeftButtonTap: () {
              Navigator.pop(context);
            },
            onRightButtonTap: () {
              Get.offAll(() => BottomNavBar(initialIndex: 2));
            },
          );
        },
      );
    }

    // isUnblurring.value = true;
    // // Animate blur to 0
    //
    //   currentBlurSigma.value = 0.0;
    //   targetBlurSigma.value = 0.0;
    //   _calculateBlurPercentage();
    //   isUnblurring.value = false;
  }

  Future<void> unBlockChat() async {
    try {
      isLoadBlock.value = true;
      final data = {"chatId": chatId.value, "reason": 'Inappropriate behavior'};
      socketService.socket?.emitWithAck(
        'unblock_chat',
        data,
        ack: (response) {},
      );
    } catch (e) {
      print("Error blocking user: $e");
    } finally {}
  }

  Rx<bool> isLoadReport = false.obs;

  Future<void> reportUser(String reason, String description) async {
    try {
      isLoadReport.value = true;
      final response = await repository.reportUser(
        reason,
        description,
        userDetails.id.toString(),
      );
      if (response['status'] == 'success') {
        showSuccessMessage(response["message"]);
      } else {
        showErrorMessageDialog(response["message"]);
      }
    } catch (e) {
      print("Error reporting user: $e");
    } finally {
      isLoadReport.value = false;
    }
  }

  Rx<bool> isLoadReportReason = false.obs;
  RxList<ReportReason> reportReasonList = <ReportReason>[].obs;
  Rx<ReportReason> selectedReason = ReportReason(label: "", value: "").obs;

  Future<void> getReportReasonList() async {
    try {
      isLoadReportReason.value = true;
      final response = await repository.getReportReason();
      if (response.status == 'success') {
        reportReasonList.value = response.data?.reasons ?? [];
      } else {}
    } catch (e) {
      print("Error reporting user: $e");
    } finally {
      isLoadReportReason.value = false;
    }
  }

  RxString chatId = "".obs;

  getChatId() async {
    await repository.getChatId(matchId).then((value) {
      chatId.value = value["data"]["chat"]["chatId"];
      // joinChat();
      print("chatId.value is ${chatId.value}");
    });
  }

  void joinChat() {
    if (socketService.isConnected.value) {
      final data = {"matchId": matchId};
      print("Call JoinChat");
      socketService.socket?.emitWithAck(
        'join_chat',
        data,
        ack: (response) {
          debugPrint("join_chat response: from emit $response");
        },
      );
    } else {
      debugPrint("Cannot emit join_chat: Socket not connected");
    }
  }

  Rx<ChatBlockedResponseData> blockStatusData = ChatBlockedResponseData(
    isBlocked: false,
  ).obs;

  /// Block Sockets
  void getBlckStatus() {
    try {
      repository.getBlockChatStatus(chatId.value.toString()).then((value) {
        blockStatusData.value = value.data!;
      });
    } catch (e, s) {}
  }

  /// UnBlur
  Future<void> approveUnBlurRequest(String requestId) async {
    try {
      print("approve_unblur emit");
      final data = {"requestId": requestId};
      socketService.socket?.emitWithAck(
        'approve_unblur',
        data,
        ack: (response) {},
      );
    } catch (e, s) {
      print("error is $e");
      print("error is $s");
    } finally {}
  }

  Future<void> declineUnBlurRequest(String requestId) async {
    try {
      final data = {"requestId": requestId, "reason": 'Not interested'};
      socketService.socket?.emitWithAck(
        'deny_unblur',
        data,
        ack: (response) {},
      );
    } catch (e) {
    } finally {}
  }

  // app/v1/unblur/unblur-request?targetUserId=60d0fe4f5311236168a109ca
  void getUnblurRequest() {
    try {
      repository.getUnblurPendingRequest(userDetails.id.toString()).then((
        value,
      ) {
        if (value["data"]["hasPendingRequest"].toString() == "true") {
          showCupertinoDialog(
            context: Get.overlayContext!,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Unblur Request Received",
                        style: TextStyles.headlineMedium.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    BlurredImageCard(
                      title: 'Current Blur',
                      blurSigma: 10.0,
                      percentage: '$blurAfter%',
                      isDialog: true,
                      imagePath: "assets/images/Profile_picture.png",
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        "Your Partner has requested to see your photo more clearly.",
                        style: TextStyles.bodySmall.copyWith(
                          color: AppThemeNotifier.textSecondary,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    onPressed: () {
                      declineUnBlurRequest(value["data"]["requestId"]);
                      Get.back();
                    },
                    child: Text(
                      "Decline",
                      style: TextStyles.titleMedium.copyWith(
                        color: Color(0xFF2194FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  CupertinoDialogAction(
                    onPressed: () {
                      approveUnBlurRequest(value["data"]["requestId"]);
                      Get.back();
                    },
                    child: Text(
                      "Accept Request",
                      style: TextStyles.titleMedium.copyWith(
                        color: Color(0xFF2194FF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e, s) {}
  }
  // app/v1/unblur/unblur-request?targetUserId=60d0fe4f5311236168a109ca

  Rx<UnblurAccessCheckData> unBlurProfileAccess = UnblurAccessCheckData(hasAccess: false,).obs;
  void getUnBlurProfile() {
    try {
      repository.getUnBlurProfileAccessCheck(userDetails.id.toString()).then((value) {
        unBlurProfileAccess.value = value.data!;
        print("Unblur request Data $value");
      });
    } catch (e, s) {
      print("error is $e");
      print("error is $s");
    }
  }
}
