
import 'package:blurry/core/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';

import '../../core/theme/typography.dart';

class CupertinoCustomDialog extends StatelessWidget {
  final String ?heading;
  final String ?title;
  final String? subtitle;
  final String? subtitle2;
  final String leftButtonText;
  final String rightButtonText;
  final VoidCallback onLeftButtonTap;
  final VoidCallback onRightButtonTap;

  const CupertinoCustomDialog({
    Key? key,
     this.heading,
     this.title,
     this.subtitle,
     this.subtitle2,
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
          heading == null ?SizedBox():     Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
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
            padding: const EdgeInsets.only(bottom: 5.0),
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
      content:
      subtitle == null ?SizedBox():
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Text(
              subtitle.toString(),
              style:  TextStyles.labelMedium.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Color(0xFF898989)
              ),
              textAlign: TextAlign.center,
            ),
          ),
         subtitle2== null?SizedBox(): Container(
           margin: EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),

                gradient:
                LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF11B2C38),
                      Color(0xFF11B2C38).withOpacity(0.8),
                      Color(0xFF11B2C38).withOpacity(0.6),
                      Color(0xFF11B2C38).withOpacity(0.5),
                      Color(0xFF11B2C38).withOpacity(0.4),
                      Color(0xFF11B2C38).withOpacity(0.3),

                    ])
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Text(
                  "$subtitle2",
                  style: TextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color:AppThemeNotifier.onPrimary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      actions: [
        CupertinoDialogAction(
          onPressed: onLeftButtonTap,
          child: Text(
            leftButtonText,
            style:  TextStyles.titleMedium.copyWith(
              color: Color(0xFF2194FF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        CupertinoDialogAction(
          onPressed: onRightButtonTap,
          child: Text(
            rightButtonText,
            style:  TextStyles.titleMedium.copyWith(
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