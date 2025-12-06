import 'package:blurry/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/typography.dart';

class CustomRadioTile extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const CustomRadioTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // final borderColor = selected ? const Color(0xFFB73B3A) : const Color(0xFFE0E0E0);
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding:  EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppThemeNotifier.border, width:  1),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyles.titleSmall.copyWith(color: AppThemeNotifier.textDisabled,fontSize: 15)
              ),
            ),
            selected?Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppThemeNotifier.primary,width: 2.2)
              ),
              child: Container(
                height: 13,
                width: 13,
                decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppThemeNotifier.primarySet1,
                      AppThemeNotifier.primarySet2,
                      AppThemeNotifier.primarySet3,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),),
            ):Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                   ),
              child: Container(
                height: 18,
                width: 18,
                decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                 color: Colors.transparent
                ),),
            )
            // _GradientRadio(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _GradientRadio extends StatelessWidget {
  final bool selected;
  const _GradientRadio({required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 22,
      decoration:  BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppThemeNotifier.primarySet1,
            AppThemeNotifier.primarySet2,
            AppThemeNotifier.primarySet3,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF3E6E6), width: 1),
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: selected ? 8 : 0,
              width: selected ? 8 : 0,
              decoration: const BoxDecoration(
                color: Color(0xFFB73B3A),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
