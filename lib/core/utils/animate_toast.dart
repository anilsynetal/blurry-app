

import 'package:flutter/cupertino.dart';
import '/core/utils/export.dart';

enum MessageType { success, error, warning }

Map<MessageType, Color> messageColors = {
  MessageType.success: AppThemeNotifier.success,
  MessageType.error: AppThemeNotifier.error,
  MessageType.warning:  AppThemeNotifier.warning
};

Map<MessageType, Widget> messageIcon = {
  MessageType.success: Image.asset(ic_success, color: AppThemeNotifier.success,height: 24,),
  MessageType.error: Image.asset(ic_error, color: AppThemeNotifier.error,height: 24),
  MessageType.warning: Image.asset(ic_warning, color:  AppThemeNotifier.warning,height: 24),
};


showMessage(
    BuildContext context,
    String msg,
    MessageType type,
    ) async
{
  FocusScope.of(context).unfocus(); // Unfocused any focused text field
  // SystemChannels.textInput.invokeMethod('TextInput.hide'); // Close the keyboard

  OverlayState? overlayState = Overlay.of(context);
  OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        left: 15,
        right: 15,
        bottom: 15,
        child: MessageContainer(
          context: context,
          message: msg,
          type: type,
        ),
      );
    },
  );
  overlayState.insert(overlayEntry);
  await Future.delayed(
    Duration(
      milliseconds: Constant.messageDisplayDuration,
    ),
  );

  overlayEntry.remove();
}

class ToastAnimation extends StatefulWidget {
  final Widget child;
  final int delay;

  const ToastAnimation({super.key, required this.child, required this.delay});

  @override
  State<ToastAnimation> createState() => _ToastAnimationState();
}

class _ToastAnimationState extends State<ToastAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500))
      ..forward();
    final curve =
    CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.00, 0.35), end: Offset.zero)
            .animate(curve);

    Future.delayed(Duration(milliseconds: widget.delay - 500), () {
      _animController.reverse();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animController,
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
    );
  }
}


Widget MessageContainer({
  required BuildContext context,
  required String message,
  required MessageType type,
}) {
  return Material(
    color: Theme.of(context).scaffoldBackgroundColor,
    child: ToastAnimation(
      delay: Constant.messageDisplayDuration,
      child: Container(

          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            // using gradient to apply one side dark color in container
            gradient: LinearGradient(
              stops: const [0.02, 0.02],
              colors: [
                messageColors[type]!,
                messageColors[type]!.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: messageColors[type]!.withOpacity(0.5),
            ),
          ),
          width: context.width,
          constraints: BoxConstraints(minHeight: 50),
          child: Row(
            children: [
              15.width,
              messageIcon[type]!,
              SizedBox(
                width: context.width - 90,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    message,
                    softWrap: true,
                    style: TextStyle(
                      color: messageColors[type],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              10.width,
            ],
          )),
    ),
  );
}
