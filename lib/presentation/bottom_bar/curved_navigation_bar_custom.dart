import 'dart:math';

import 'package:blurry/core/theme/app_theme.dart';
import 'package:blurry/core/theme/colors.dart';
import 'package:flutter/material.dart';

import '../../core/theme/typography.dart';
import 'nav_button_custom.dart';
import 'nav_button_custom_common.dart';
import 'nav_custom_clipper_custom.dart';

typedef _LetIndexPage = bool Function(int value);

class CurvedNavigationBarCustom extends StatefulWidget {
  final List<Widget> items;
  final List<Widget> itemsSelected;
  final List<String> labels;
  final int index;
  final Color color;
  final Color? buttonBackgroundColor;
  final Color backgroundColor;
  final ValueChanged<int>? onTap;
  final _LetIndexPage letIndexChange;
  final Curve animationCurve;
  final Duration animationDuration;
  final double height;
  final double? maxWidth;

  CurvedNavigationBarCustom({
    Key? key,
    required this.items,
    required this.itemsSelected,
    required this.labels,
    this.index = 0,
    this.color = Colors.white,
    this.buttonBackgroundColor,
    this.backgroundColor = Colors.blueAccent,
    this.onTap,
    _LetIndexPage? letIndexChange,
    this.animationCurve = Curves.easeOut,
    this.animationDuration = const Duration(milliseconds: 600),
    this.height = 75.0,
    this.maxWidth,
  })  : letIndexChange = letIndexChange ?? ((_) => true),
        assert(items.isNotEmpty),
        assert(labels.length == items.length),
        assert(0 <= index && index < items.length),
        assert(0 <= height && height <= 75.0),
        assert(maxWidth == null || 0 <= maxWidth),
        super(key: key);

  @override
  CurvedNavigationBarCustomState createState() => CurvedNavigationBarCustomState();
}

class CurvedNavigationBarCustomState extends State<CurvedNavigationBarCustom>
    with SingleTickerProviderStateMixin {
  late double _startingPos;
  late int _endingIndex;
  late double _pos;
  double _buttonHide = 0;
  late Widget _icon;
  late Widget _selectedIcon;
  late AnimationController _animationController;
  late int _length;

  @override
  void initState() {
    super.initState();
    _icon = widget.items[widget.index];
    _selectedIcon = widget.itemsSelected[widget.index];
    _length = widget.items.length;
    _pos = widget.index / _length;
    _startingPos = widget.index / _length;
    _endingIndex = widget.index;
    _animationController = AnimationController(vsync: this, value: _pos);
    _animationController.addListener(() {
      setState(() {
        _pos = _animationController.value;
        final endingPos = _endingIndex / widget.items.length;
        final middle = (endingPos + _startingPos) / 2;
        if ((endingPos - _pos).abs() < (_startingPos - _pos).abs()) {
          _icon = widget.items[_endingIndex];
        }
        _buttonHide =
            (1 - ((middle - _pos) / (_startingPos - middle)).abs()).abs();
      });
    });
  }

  @override
  void didUpdateWidget(CurvedNavigationBarCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) {
      final newPosition = widget.index / _length;
      _startingPos = _pos;
      _endingIndex = widget.index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    }
    if (!_animationController.isAnimating) {
      _icon = widget.items[_endingIndex];
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return SizedBox(
      height: 100,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = min(
              constraints.maxWidth, widget.maxWidth ?? constraints.maxWidth);
          return Align(
            alignment: textDirection == TextDirection.ltr
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Container(
                color:AppThemeNotifier.background,
                width: maxWidth,
                child: ClipRect(
                  clipper: NavCustomClipper(

                    deviceHeight: MediaQuery.sizeOf(context).height,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      Positioned(
                        bottom: -25 - (76.0 - widget.height),
                        left: textDirection == TextDirection.rtl
                            ? null
                            : _pos * maxWidth,
                        right: textDirection == TextDirection.rtl
                            ? _pos * maxWidth
                            : null,
                        width: maxWidth / _length,
                        child: Center(
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              -(1 - _buttonHide) * 75,
                            ),
                            child: widget.itemsSelected[_endingIndex],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0 ,
                        child: CustomPaint(
                          painter: NavCustomPainter(
                              _pos, _length, widget.color, textDirection),
                          child: Container(
                            decoration: BoxDecoration(

                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))

                            ),
                            height: 75.0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0 - (80.0 - widget.height),
                        child: SizedBox(
                            height: 100.0,
                            child: Row(
                                children: widget.items.map((item) {
                                  final int idx = widget.items.indexOf(item);
                                  return NavButton(
                                    onTap: _buttonTap,
                                    position: _pos,
                                    length: _length,
                                    index: idx,
                                    child: item,
                                    label: widget.labels[idx],
                                  );
                                }).toList())),
                      ),
                      Positioned(
                        left: textDirection == TextDirection.ltr
                            ? _pos * maxWidth
                            : null,
                        right: textDirection == TextDirection.rtl
                            ? _pos * maxWidth
                            : null,
                        bottom: 0 - (70.0 - widget.height),
                        width: maxWidth / _length,
                        child: const Center(
                          child: Text(
                            '', // Placeholder; actual text set via NavButton for unselected, this for selected but wait no, this is for selected

                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // Selected label positioned at bottom
                      Positioned(
                        left: textDirection == TextDirection.ltr
                            ? _pos * maxWidth
                            : null,
                        right: textDirection == TextDirection.rtl
                            ? _pos * maxWidth
                            : null,
                        bottom: 0 - (58.0 - widget.height),
                        width: maxWidth / _length,
                        child: Center(
                          child: Text(
                            widget.labels[_endingIndex],
                            style:  TextStyles.labelMedium.copyWith(
                              color: AppThemeNotifier.textPrimary,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void setPage(int index) {
    _buttonTap(index);
  }

  void _buttonTap(int index) {
    if (!widget.letIndexChange(index) || _animationController.isAnimating) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(index);
    }
    final newPosition = index / _length;
    setState(() {
      _startingPos = _pos;
      _endingIndex = index;
      _animationController.animateTo(newPosition,
          duration: widget.animationDuration, curve: widget.animationCurve);
    });
  }
}