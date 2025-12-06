

import 'package:blurry/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

import '../../core/theme/typography.dart';

class CupertinoMessageCustomDialog extends StatelessWidget {
  final String ?heading;
  final String ?title;
  final Widget? topImage;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onLeftButtonTap;
  final VoidCallback onRightButtonTap;

  const CupertinoMessageCustomDialog({
    Key? key,
    this.heading,
    this.title,
    this.topImage,
    required this.leftButtonText,
    required this.rightButtonText,
    required this.onLeftButtonTap,
    required this.onRightButtonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(


      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: topImage??SizedBox(),
          ),

          heading == null ?SizedBox():     Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              heading.toString(),
              style:  TextStyles.headlineMedium.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),


          title == null ?SizedBox():       Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Text(
              title.toString(),
              style:  TextStyles.bodyMedium.copyWith(
                fontSize: 12,

                color: AppThemeNotifier.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      actions: [
        if (leftButtonText.isNotEmpty)
          CupertinoDialogAction(
            onPressed: onLeftButtonTap,
            child: Text(
              leftButtonText,
              style: TextStyles.titleMedium.copyWith(
                color: Color(0xFF2194FF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        if (rightButtonText.isNotEmpty)
          CupertinoDialogAction(
            onPressed: onRightButtonTap,
            child: Text(
              rightButtonText,
              style: TextStyles.titleMedium.copyWith(
                color: Color(0xFF2194FF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}