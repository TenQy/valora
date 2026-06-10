import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: AppFonts.body,
    scaffoldBackgroundColor: AppColors.bgPage,
    canvasColor: AppColors.bgPage,
    dividerColor: AppColors.borderSubtle,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.silver,
      onPrimary: AppColors.bgBase,
      secondary: AppColors.green,
      onSecondary: AppColors.bgBase,
      error: AppColors.colorError,
      surface: AppColors.bgSurface,
      onSurface: AppColors.textPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.salary,
      displayMedium: AppTextStyles.h1,
      displaySmall: AppTextStyles.score,
      titleLarge: AppTextStyles.title,
      titleMedium: AppTextStyles.userName,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.subtitle,
      bodySmall: AppTextStyles.compactBody,
      labelLarge: AppTextStyles.button,
      labelSmall: AppTextStyles.sectionLabel,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bgBase,
      surfaceTintColor: AppColors.transparent,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.silverMuted),
      titleTextStyle: TextStyle(
        fontFamily: AppFonts.display,
        fontSize: 18,
        height: 1.2,
        fontWeight: FontWeight.w300,
        color: AppColors.textPrimary,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.bgBase,
      selectedItemColor: AppColors.silverMuted,
      unselectedItemColor: AppColors.bottomNavUnselected,
      selectedLabelStyle: TextStyle(
        fontFamily: AppFonts.body,
        fontSize: 10,
        letterSpacing: 0.6,
      ),
      unselectedLabelStyle: TextStyle(fontFamily: AppFonts.body, fontSize: 10),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.bgInput,
      hintStyle: AppTextStyles.subtitle.copyWith(
        color: AppColors.textPlaceholder,
      ),
      labelStyle: AppTextStyles.compactBody.copyWith(
        color: AppColors.textMuted,
      ),
      errorStyle: AppTextStyles.compactBody.copyWith(
        color: AppColors.colorError,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space16,
        vertical: AppSpacing.space16,
      ),
      border: _inputBorder(AppColors.borderDefault),
      enabledBorder: _inputBorder(AppColors.borderDefault),
      focusedBorder: _inputBorder(AppColors.borderStrong),
      errorBorder: _inputBorder(AppColors.colorError),
      focusedErrorBorder: _inputBorder(AppColors.colorError),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered)) {
            return AppColors.silverHover;
          }
          return AppColors.silver;
        }),
        foregroundColor: const WidgetStatePropertyAll(AppColors.bgBase),
        overlayColor: const WidgetStatePropertyAll(AppColors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        textStyle: const WidgetStatePropertyAll(AppTextStyles.button),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.space24,
            vertical: AppSpacing.space16,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: const WidgetStatePropertyAll(AppColors.silverMuted),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.borderDefault),
        ),
        textStyle: const WidgetStatePropertyAll(AppTextStyles.button),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(
            horizontal: AppSpacing.space24,
            vertical: AppSpacing.space16,
          ),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.xs),
          ),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textMuted,
        textStyle: AppTextStyles.button,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.silverMuted,
      circularTrackColor: AppColors.borderSubtle,
      linearTrackColor: AppColors.borderSubtle,
    ),
  );

  static ThemeData get light {
    return dark.copyWith(brightness: Brightness.light);
  }

  static OutlineInputBorder _inputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: color),
    );
  }
}
