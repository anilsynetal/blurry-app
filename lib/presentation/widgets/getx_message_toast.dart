// toast_service.dart  (or your file name)
import 'package:flutter/material.dart';
import '../../main.dart';
import '/core/utils/export.dart';

enum MessageTypeGetx { success, error, warning }

final Map<MessageTypeGetx, Color> messageColors = {
  MessageTypeGetx.success: AppThemeNotifier.success,
  MessageTypeGetx.error: AppThemeNotifier.error,
  MessageTypeGetx.warning: AppThemeNotifier.warning,
};

final Map<MessageTypeGetx, Widget> messageIcon = {
  MessageTypeGetx.success: Image.asset(ic_success, color: AppThemeNotifier.success, height: 24),
  MessageTypeGetx.error: Image.asset(ic_error, color: AppThemeNotifier.error, height: 24),
  MessageTypeGetx.warning: Image.asset(ic_warning, color: AppThemeNotifier.warning, height: 24),
};

// MAGIC: This works 100% without Get.context or overlayContext
BuildContext get _context => navigatorKey.currentContext!;

void showMessageGetx(
    String msg,
    MessageTypeGetx type, {
      Duration? duration,
    }) {
  if (_context.mounted == false) return;

  ScaffoldMessenger.of(_context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: _buildMessageContent(msg, type),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        duration: duration ?? Duration(milliseconds: Constant.messageDisplayDuration),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
}

Widget _buildMessageContent(String message, MessageTypeGetx type) {
  final color = messageColors[type]!;

  return Container(
    constraints: const BoxConstraints(minHeight: 50),
    decoration: BoxDecoration(
      color: AppThemeNotifier.background,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color.withOpacity(0.7), width: 1),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.15),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        // LEFT BOLD COLOR STRIP (this is what you missed!)
        Container(
          width: 5,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Icon
        messageIcon[type]!,

        const SizedBox(width: 10),

        // Message Text
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              height: 1.4,
            ),
          ),
        ),

        const SizedBox(width: 16),
      ],
    ),
  );
}

// Your old functions — keep using them exactly as before!
void showSuccessMessage(String msg, {Duration? duration}) =>
    showMessageGetx(msg, MessageTypeGetx.success, duration: duration);

void showErrorMessage(String msg, {Duration? duration}) =>
    showMessageGetx(msg, MessageTypeGetx.error, duration: duration);

void showWarningMessage(String msg, {Duration? duration}) =>
    showMessageGetx(msg, MessageTypeGetx.warning, duration: duration);

// Extension still works perfectly
extension MessageExtension on GetInterface {
  void showSuccessToast(String msg, {Duration? duration}) => showSuccessMessage(msg, duration: duration);
  void showErrorToast(String msg, {Duration? duration}) => showErrorMessage(msg, duration: duration);
  void showWarningToast(String msg, {Duration? duration}) => showWarningMessage(msg, duration: duration);
}