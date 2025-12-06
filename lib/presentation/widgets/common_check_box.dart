

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/images.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double size;
  final Color? fillColor ;
  CustomCheckbox({
    Key? key,
    required this.value,
    this.onChanged,
    this.size = 24.0,
    this.fillColor ,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox>
    with SingleTickerProviderStateMixin {


  final double borderWidth = 0.8;
  final Duration animationDuration = Duration(milliseconds: 200);
  final Curve animationCurve = Curves.easeInOut;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: animationCurve,
    ));

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 1.0, curve: animationCurve),
    ));

    if (widget.value) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onChanged != null
          ? () => widget.onChanged!(!widget.value)
          : null,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: widget.value
                    ? widget.fillColor ?? AppThemeNotifier.primary
                    : AppThemeNotifier.textDisabled,
                width: borderWidth,
              ),
              color: widget.value
                  ? Color.lerp(
                Colors.transparent,
                widget.fillColor?? AppThemeNotifier.primary,
                _scaleAnimation.value,
              )
                  : Colors.transparent,
            ),
            child: widget.value
                ? Transform.scale(
              scale: _checkAnimation.value,
              child: Center(child: Image.asset(ic_check,color: AppThemeNotifier.onPrimary,height: widget.size * 0.5,)),
              // child: Icon(
              //   Icons.check, // You can replace this with your custom ic_check
              //   size: widget.size * 0.7,
              //   color: AppThemeNotifier.onPrimary,
              // ),
            )
                : null,
          );
        },
      ),
    );
  }
}