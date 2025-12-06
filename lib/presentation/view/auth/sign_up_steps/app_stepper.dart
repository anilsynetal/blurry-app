import 'package:blurry/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AppStepper extends StatelessWidget {
  final int total;
  final int current; // 0-based
  const AppStepper({super.key, required this.total, required this.current});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: List.generate(total, (i) {
            final active = i <= current;
            return Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 9,

                    margin: EdgeInsets.only(
                      top: 12,
                      bottom: 12,
                      left: i == 0 ? 0 : 5,
                      right: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: active ? null : Color(0xFFE8E8E8),
                      gradient: active
                          ?  LinearGradient(
                              colors: [
                                AppThemeNotifier.primarySet1,
                                AppThemeNotifier.primarySet2,
                                AppThemeNotifier.primarySet3,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : null,
                    ),
                  ),
                  current == i?   Positioned(
                    right:0,
                    top: 0,
                    bottom: 0,
                    child: Center(child: Image.asset("assets/icons/current_step_ic.png",height: 24,)),
                  ):SizedBox()
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
