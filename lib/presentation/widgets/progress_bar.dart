
import 'package:blurry/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../core/theme/typography.dart';

class CustomProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String label;
  final Color filledColor;
  final Color backgroundColor;
  final double height;
  final TextStyle? textStyle;

  const CustomProgressBar({
    Key? key,
    required this.progress,
    required this.label,
    this.filledColor = const Color(0xFF58CC02),
    this.backgroundColor = const Color(0xFFF0F0F0),
    this.height = 60.0,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Stack(
        children: [
          // Filled portion
          Container(
            width: MediaQuery.of(context).size.width * progress,
            height: height,
            decoration: BoxDecoration(
              color: filledColor,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
          // Text overlay
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    textAlign: TextAlign.start,
                    label,
                    style: textStyle ??
                        TextStyles.labelMedium.copyWith(
                          fontSize: 11,
                        color: AppThemeNotifier.onPrimary.withOpacity(0.9)
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}