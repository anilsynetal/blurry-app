import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';
import '/core/utils/export.dart';

enum ButtonType {
  elevated,
  outlined,
  text,
  icon,
}

Widget commonButton({
  required String buttonText,
  required VoidCallback onPressed,
  Color? backgroundColor,
  Color? textColor,
  double? height,
  double? width,
  double borderRadius = 30.0,
  double elevation = 0.0, // Default elevation set to 0
  TextStyle? textStyle,
  bool isLoading = false,
  ButtonType type = ButtonType.elevated,
  Widget? icon, // Optional icon widget
})
{
  final btnHeight = height ?? 48.0; // Reduced default height for smaller footprint
  final btnWidth = width ?? (type == ButtonType.icon ? 48.0 : double.infinity);

  final buttonChild = isLoading
      ? CupertinoActivityIndicator(color: textColor ?? AppThemeNotifier.onPrimary)
      : Row(
    mainAxisSize: MainAxisSize.min, // Minimize Row size
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      if (buttonText.isNotEmpty && type != ButtonType.icon)
        Text(
          buttonText,
          style: textStyle ??
              TextStyles.bodyMedium.copyWith(
                color: textColor ??
                    (type == ButtonType.outlined || type == ButtonType.icon
                        ? AppThemeNotifier.primary
                        : AppThemeNotifier.onPrimary),
              ),
        ),
      if (icon != null) ...[
        if (buttonText.isNotEmpty && type != ButtonType.icon) const SizedBox(width: 8.0),
        icon,
      // Space only if text exists
      ],
    ],
  );

  final shape = RoundedRectangleBorder(

    borderRadius: BorderRadius.circular(borderRadius),
  );

  switch (type) {
    case ButtonType.elevated:
      return SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: ElevatedButton(
          onPressed: isLoading ? () {} : onPressed,
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            backgroundColor: backgroundColor ?? AppThemeNotifier.buttonColor,
            shape: shape,
            padding: EdgeInsets.zero, // Remove unnecessary padding
          ),
          child: buttonChild,
        ),
      );

    case ButtonType.outlined:
      return SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: OutlinedButton(
          onPressed: isLoading ? () {} : onPressed,
          style: OutlinedButton.styleFrom(
            shape: shape,
            side: BorderSide(color: backgroundColor ?? AppThemeNotifier.primary,width: 1),
            padding: EdgeInsets.zero, // Remove unnecessary padding
          ),
          child: buttonChild,
        ),
      );

    case ButtonType.text:
      return SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: TextButton(
          onPressed: isLoading ? () {} : onPressed,
          style: TextButton.styleFrom(
            shape: shape,
            foregroundColor: backgroundColor ?? AppThemeNotifier.primary,
            padding: EdgeInsets.zero, // Remove unnecessary padding
          ),
          child: buttonChild,
        ),
      );

    case ButtonType.icon:
      return SizedBox(
        width: btnWidth,
        height: btnHeight,
        child: IconButton(
          onPressed: isLoading ? () {} : onPressed,
          style: IconButton.styleFrom(
            backgroundColor: backgroundColor ?? AppThemeNotifier.buttonColor,
            shape: shape,
            padding: EdgeInsets.zero, // Remove unnecessary padding
          ),
          icon: buttonChild,
        ),
      );
  }
}


Widget gradientButton({
  Color?bgColor,
  bool isLoading = false,
  required Callback onPressed,  Widget ?child,double?height,double?width , String ?buttonText,TextStyle?textStyle,Color?textColor} ){
  return InkWell(
    focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    onTap: onPressed,
    child: Container(
      height: height??48,
      width: width??Get.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: bgColor == null ?LinearGradient(colors:
        [
          AppThemeNotifier.primarySet1,
          AppThemeNotifier.primarySet2,
          AppThemeNotifier.primarySet3,

        ],begin: Alignment.topCenter,
            end:  Alignment.bottomCenter
        ):LinearGradient(colors:
        [
          bgColor,
          bgColor,
        ],begin: Alignment.topCenter,
            end:  Alignment.bottomCenter
        )
      ),
      child: buttonText != null ?Center(child:
      isLoading
          ? CupertinoActivityIndicator(color: textColor ?? AppThemeNotifier.onPrimary):
      Text(buttonText,style:textStyle?? TextStyles.bodyMedium.copyWith(color: textColor??AppThemeNotifier.onPrimary),)) : child,
    ),
  );
}