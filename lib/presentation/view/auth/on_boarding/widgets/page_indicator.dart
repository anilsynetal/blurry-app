import 'package:blurry/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int current;
  final int count;

  const PageIndicator({
    Key? key,
    required this.current,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final bool isSelected = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          width: isSelected ? 28.0 : 8.0,
          height: 8.0,
          margin: EdgeInsets.only(right: index != count - 1 ? 8.0 : 0.0),
          decoration: BoxDecoration(
            gradient: isSelected?LinearGradient(colors:

            [
              AppThemeNotifier.primarySet1,
              AppThemeNotifier.primarySet2,
              AppThemeNotifier.primarySet3,

            ],begin: Alignment.topCenter,
                end:  Alignment.bottomCenter
            ):
            LinearGradient(colors:

            [
              AppThemeNotifier.onPrimary,
              AppThemeNotifier.onPrimary,
              AppThemeNotifier.onPrimary,
            ]),
            borderRadius: BorderRadius.circular(5.0),
          ),
        );
      }),
    );
  }
}
