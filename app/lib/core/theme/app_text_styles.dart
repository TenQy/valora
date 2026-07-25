import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppFonts {
  const AppFonts._();

  static const String body = 'Inter';
  static const String display = 'Outfit';
  static const String mono = 'JetBrains Mono';
}

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get salary => GoogleFonts.outfit(
        fontSize: 34,
        height: 1.1,
        fontWeight: FontWeight.w600,
        color: AppColors.green,
      );

  static TextStyle get currencySymbol => GoogleFonts.outfit(
        fontSize: 24,
        height: 1.15,
        fontWeight: FontWeight.w500,
        color: AppColors.greenMuted,
      );

  static TextStyle get h1 => GoogleFonts.outfit(
        fontSize: 28,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get score => GoogleFonts.outfit(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get title => GoogleFonts.inter(
        fontSize: 18,
        height: 1.35,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get userName => GoogleFonts.inter(
        fontSize: 16,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get subtitle => GoogleFonts.inter(
        fontSize: 14,
        height: 1.6,
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14,
        height: 1.6,
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
      );

  static TextStyle get compactBody => GoogleFonts.inter(
        fontSize: 12,
        height: 1.5,
        fontWeight: FontWeight.w300,
        color: AppColors.textSecondary,
      );

  static TextStyle get sectionLabel => GoogleFonts.inter(
        fontSize: 11,
        height: 1.3,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        letterSpacing: 2.2,
      );

  static TextStyle get hint => GoogleFonts.inter(
        fontSize: 11,
        height: 1.4,
        fontWeight: FontWeight.w300,
        color: AppColors.textMuted,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 14,
        height: 1.2,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.84,
      );

  static TextStyle get skill => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        height: 1.3,
        fontWeight: FontWeight.w400,
        color: AppColors.silverMuted,
      );

  static TextStyle get match => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        height: 1.3,
        fontWeight: FontWeight.w500,
        color: AppColors.green,
      );
}