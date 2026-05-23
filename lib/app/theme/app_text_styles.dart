import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display font = Nanum Pen Script (handwritten)
  static TextStyle display(double size, {Color color = AppColors.primary}) =>
      GoogleFonts.nanumPenScript(
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w400,
      );

  // Body font = DM Sans
  static TextStyle body(double size,
          {FontWeight weight = FontWeight.w300,
          Color color = AppColors.textColor}) =>
      GoogleFonts.dmSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  static final textTheme = TextTheme(
    displayLarge: GoogleFonts.nanumPenScript(fontSize: 96, color: AppColors.primary),
    headlineLarge: GoogleFonts.nanumPenScript(fontSize: 64, color: AppColors.primary),
    headlineMedium: GoogleFonts.nanumPenScript(fontSize: 48, color: AppColors.primary),
    titleLarge: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w500),
    bodyLarge: GoogleFonts.dmSans(fontSize: 16, height: 1.5, color: AppColors.textColor),
    bodyMedium: GoogleFonts.dmSans(fontSize: 14, color: AppColors.textColor),
    labelLarge: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500),
  );
}
