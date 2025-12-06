
import 'package:flutter/material.dart';

extension SizeBoxExtension on num {
  /// Adds a SizedBox with a specified height.
  SizedBox get height => SizedBox(height: toDouble());

  /// Adds a SizedBox with a specified width.
  SizedBox get width => SizedBox(width: toDouble());
}
