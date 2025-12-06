import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'colors.dart';

class AppThemeNotifier extends GetxController {
  static final Rx<ThemeMode> currentTheme = ThemeMode.light.obs;

  // Switch between light and dark themes
  void switchTheme() {
    currentTheme.value =
    currentTheme.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }

  // Check if dark mode is active
  static bool isDarkMode() => currentTheme.value == ThemeMode.dark;

  // Theme-based color getters

  static Color get primarySet1 => isDarkMode() ? DarkThemeColors.primarySet1 : LightThemeColors.primarySet1;
  static Color get primarySet2 => isDarkMode() ? DarkThemeColors.primarySet2 : LightThemeColors.primarySet2;
  static Color get primarySet3 => isDarkMode() ? DarkThemeColors.primarySet3 : LightThemeColors.primarySet3;

  static Color get primary => isDarkMode() ? DarkThemeColors.primary : LightThemeColors.primary;
  static Color get secondary => isDarkMode() ? DarkThemeColors.secondary : LightThemeColors.secondary;
  static Color get buttonColor => isDarkMode() ? DarkThemeColors.buttonColor : LightThemeColors.buttonColor;
  static Color get background => isDarkMode() ? DarkThemeColors.background : LightThemeColors.background;
  static Color get surface => isDarkMode() ? DarkThemeColors.surface : LightThemeColors.surface;
  static Color get surfaceContainer => isDarkMode() ? DarkThemeColors.surfaceContainer : LightThemeColors.surfaceContainer;
  static Color get onSurface => isDarkMode() ? DarkThemeColors.onSurface : LightThemeColors.onSurface;
  static Color get onPrimary => isDarkMode() ? DarkThemeColors.onPrimary : LightThemeColors.onPrimary;
  static Color get onSurfaceVariant => isDarkMode() ? DarkThemeColors.onSurfaceVariant : LightThemeColors.onSurfaceVariant;
  static Color get onSurfaceSecondary => isDarkMode() ? DarkThemeColors.onSurfaceSecondary : LightThemeColors.onSurfaceSecondary;
  static Color get border => isDarkMode() ? DarkThemeColors.outline : LightThemeColors.outline;
  static Color get shadow => isDarkMode() ? DarkThemeColors.shadow : LightThemeColors.shadow;
  static Color get error => isDarkMode() ? DarkThemeColors.error : LightThemeColors.error;
  static Color get success => isDarkMode() ? DarkThemeColors.success : LightThemeColors.success;
  static Color get success2 => isDarkMode() ? Color(0xFF43A336) :Color(0xFF43A336);
  static Color get warning => isDarkMode() ? DarkThemeColors.warning : LightThemeColors.warning;
  static Color get primaryContainer => isDarkMode() ? DarkThemeColors.primaryContainer : LightThemeColors.primaryContainer;
  static Color get secondaryContainer => isDarkMode() ? DarkThemeColors.secondaryContainer : LightThemeColors.secondaryContainer;
  static Color get shimmerBase => isDarkMode() ? DarkThemeColors.shimmerBase : LightThemeColors.shimmerBase;
  static Color get shimmerHighlight => isDarkMode() ? DarkThemeColors.shimmerHighlight : LightThemeColors.shimmerHighlight;

  /// Text colors
  static Color get textTertiary => isDarkMode() ? DarkThemeColors.textTertiary : LightThemeColors.textTertiary;
  static Color get clickableText => isDarkMode() ? DarkThemeColors.clickableText : LightThemeColors.clickableText;
  static Color get textDisabled => isDarkMode() ? DarkThemeColors.textDisabled : LightThemeColors.textDisabled;
  static Color get textPrimary => isDarkMode() ? DarkThemeColors.textPrimary : LightThemeColors.textPrimary;
  static Color get textSecondary => isDarkMode() ? DarkThemeColors.textSecondary : LightThemeColors.textSecondary;
  static Color get textSecondaryAlpha => isDarkMode() ? DarkThemeColors.textSecondaryAlpha : LightThemeColors.textSecondaryAlpha;

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,

      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: LightThemeColors.primary,
        onPrimary: LightThemeColors.onSurface,
        primaryContainer: LightThemeColors.primaryContainer,
        secondary: LightThemeColors.secondary,
        onSecondary: LightThemeColors.onSurface,
        secondaryContainer: LightThemeColors.secondaryContainer,
        error: LightThemeColors.error,
        onError: LightThemeColors.onSurface,
        surface: LightThemeColors.surface,
        onSurface: LightThemeColors.onSurface,
        surfaceContainer: LightThemeColors.surfaceContainer,
        shadow: LightThemeColors.shadow,
      ),

      scaffoldBackgroundColor: LightThemeColors.background,

      datePickerTheme: DatePickerThemeData(
        // Overall background of the date picker dialog
        backgroundColor: AppThemeNotifier.background,

        // Header styles (month/year header)
        headerHelpStyle: TextStyle(color: textPrimary),
        headerHeadlineStyle: TextStyle(color: textPrimary),

        headerForegroundColor: textPrimary,  // Adds foreground for header icons/buttons if needed
        headerBackgroundColor: AppThemeNotifier.background,  // Match to bg for consistency

        // Weekday labels (Mon, Tue, etc.)
        weekdayStyle: TextStyle(color: primary),


        // Toggle buttons (e.g., calendar/year switch)
        toggleButtonTextStyle: TextStyle(color: primary, fontWeight: FontWeight.w500),



        // Day cell text colors (foreground) - use MaterialState for state-based styling
        // Normal days: Use a color that contrasts with background (e.g., textPrimary if it works, else adjust)
        dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return onPrimary;  // High-contrast text for selected date (on primary bg)
          }

          return textPrimary;  // Default for unselected days
        }),

        // Day cell backgrounds - ensure selected uses a visible fill
        dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;  // Selected bg - use your primary color for fill
          }

          return Colors.transparent;  // Default
        }),


        // Overlay for pressed/ hovered days
        dayOverlayColor: MaterialStateProperty.all(primary.withOpacity(0.1)),

        // Today-specific text style override if needed
        todayForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return onPrimary;
          }
          return primary;
        }),
        todayBackgroundColor: MaterialStateProperty.all(primary.withOpacity(0.2)),

        // Year selector styles (if using year picker mode)
        yearStyle: TextStyle(color: textPrimary),
        yearForegroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return onPrimary;
          }
          return textPrimary;
        }),
        yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primary;
          }
          return Colors.transparent;
        }),

        // Range picker specifics (if using SFDateRangePicker or similar - adjust if not)
        // rangePickerHeaderStyle: ...
        // Add more as needed for elevation, shape, etc.
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 8,
      ),
      // datePickerTheme: DatePickerThemeData(
      //   dayStyle: TextStyle(color: textPrimary),
      //   toggleButtonTextStyle: TextStyle(color: primary,fontWeight: FontWeight.w500),
      //   headerHelpStyle: TextStyle(color: textPrimary),
      //   headerHeadlineStyle: TextStyle(color: textPrimary),
      //   weekdayStyle:  TextStyle(color: primary),
      //
      //
      //   backgroundColor: AppThemeNotifier.primarySet1,
      //
      // ),

      appBarTheme: AppBarTheme(
        backgroundColor: LightThemeColors.surface,
        foregroundColor: LightThemeColors.onSurface,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: LightThemeColors.surface,
        selectedItemColor: LightThemeColors.primary,
        unselectedItemColor: LightThemeColors.onSurfaceSecondary,
      ),
      dividerTheme: DividerThemeData(color: LightThemeColors.outline),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: DarkThemeColors.primary,
        onPrimary: DarkThemeColors.onSurface,
        primaryContainer: DarkThemeColors.primaryContainer,
        secondary: DarkThemeColors.secondary,
        onSecondary: DarkThemeColors.onSurface,
        secondaryContainer: DarkThemeColors.secondaryContainer,
        error: DarkThemeColors.error,
        onError: DarkThemeColors.onSurface,
        surface: DarkThemeColors.surface,
        onSurface: DarkThemeColors.onSurface,
        surfaceContainer: DarkThemeColors.surfaceContainer,
        shadow: DarkThemeColors.shadow,
      ),
      scaffoldBackgroundColor: DarkThemeColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: DarkThemeColors.surface,
        foregroundColor: DarkThemeColors.onSurface,
        elevation: 0,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: DarkThemeColors.surface,
        selectedItemColor: DarkThemeColors.primary,
        unselectedItemColor: DarkThemeColors.onSurfaceSecondary,
      ),
      dividerTheme: DividerThemeData(color: DarkThemeColors.outline),
    );
  }
}