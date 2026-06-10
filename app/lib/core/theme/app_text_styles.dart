import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppFonts {
  const AppFonts._();

  static const String display = 'Cormorant Garamond';
  static const String body = 'Inter';
  static const String mono = 'JetBrains Mono';
}

class AppTextStyles {
  const AppTextStyles._();

  static const TextStyle salary = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 52,
    height: 1.1,
    fontWeight: FontWeight.w300,
    color: AppColors.green,
  );

  static const TextStyle currencySymbol = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w300,
    color: AppColors.greenMuted,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );

  static const TextStyle score = TextStyle(
    fontFamily: AppFonts.display,
    fontSize: 28,
    height: 1.2,
    fontWeight: FontWeight.w300,
    color: AppColors.textPrimary,
  );

  static const TextStyle title = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 18,
    height: 1.35,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static const TextStyle userName = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 16,
    height: 1.4,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    height: 1.6,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    height: 1.6,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  static const TextStyle compactBody = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 12,
    height: 1.5,
    fontWeight: FontWeight.w300,
    color: AppColors.textSecondary,
  );

  static const TextStyle sectionLabel = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11,
    height: 1.3,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 2.2,
  );

  static const TextStyle hint = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 11,
    height: 1.4,
    fontWeight: FontWeight.w300,
    color: AppColors.textMuted,
  );

  static const TextStyle button = TextStyle(
    fontFamily: AppFonts.body,
    fontSize: 14,
    height: 1.2,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.84,
  );

  static const TextStyle skill = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w400,
    color: AppColors.silverMuted,
  );

  static const TextStyle match = TextStyle(
    fontFamily: AppFonts.mono,
    fontSize: 12,
    height: 1.3,
    fontWeight: FontWeight.w500,
    color: AppColors.green,
  );
}
