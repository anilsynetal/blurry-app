import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  // Font family using Google Fonts
  static final TextStyle Function(TextStyle? textStyle) fontFamily = (TextStyle? textStyle) {
    return GoogleFonts.schibstedGrotesk(
      textStyle: textStyle,
      fontSize: textStyle?.fontSize,
      fontWeight: textStyle?.fontWeight,
      color: textStyle?.color,
    );
  };

  static final TextStyle Function(TextStyle? textStyle) fontInterFamily = (TextStyle? textStyle) {
    return GoogleFonts.inter(
      textStyle: textStyle,
      fontSize: textStyle?.fontSize,
      fontWeight: textStyle?.fontWeight,
      color: textStyle?.color,
    );
  };
  static final TextStyle interTextStyle = fontInterFamily(TextStyle(

  ));

  // Headline styles
  static final TextStyle headlineLarge = fontFamily(TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700, // Bold
  ));

  static final TextStyle headlineMedium = fontFamily(TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
  ));

  static final TextStyle headlineSmall = fontFamily(TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular
  ));

  // Title styles
  static final TextStyle titleLarge = fontFamily(TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700, // Bold
  ));

  static final TextStyle titleMedium = fontFamily(TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500, // Medium
  ));

  static final TextStyle titleSmall = fontFamily(TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
  ));

  // Body styles
  static final TextStyle bodyLarge = fontFamily(TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700, // Bold
  ));

  static final TextStyle bodyMedium = fontFamily(TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
  ));

  static final TextStyle bodySmall = fontFamily(TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
  ));

  // Label styles
  static final TextStyle labelLarge = fontFamily(TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700, // Bold
  ));

  static final TextStyle labelMedium = fontFamily(TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
  ));

  static final TextStyle labelSmall = fontFamily(TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
  ));
}