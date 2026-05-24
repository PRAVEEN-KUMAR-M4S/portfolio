import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display font = Nanum Pen Script (handwritten)
  static TextStyle display(double size, {Color color = AppColors.primary}) =>
      TextStyle(
        fontFamily: 'Nanum Pen Script',
        fontSize: size,
        color: color,
        fontWeight: FontWeight.w400,
      );

  // Body font = DM Sans
  static TextStyle body(double size,
          {FontWeight weight = FontWeight.w300,
          Color color = AppColors.textColor}) =>
      TextStyle(
        fontFamily: 'DM Sans',
        fontSize: size,
        fontWeight: weight,
        color: color,
      );

  static final textTheme = TextTheme(
    displayLarge: const TextStyle(fontFamily: 'Nanum Pen Script', fontSize: 96, color: AppColors.primary),
    headlineLarge: const TextStyle(fontFamily: 'Nanum Pen Script', fontSize: 64, color: AppColors.primary),
    headlineMedium: const TextStyle(fontFamily: 'Nanum Pen Script', fontSize: 48, color: AppColors.primary),
    titleLarge: const TextStyle(fontFamily: 'DM Sans', fontSize: 20, fontWeight: FontWeight.w500),
    bodyLarge: const TextStyle(fontFamily: 'DM Sans', fontSize: 16, height: 1.5, color: AppColors.textColor),
    bodyMedium: const TextStyle(fontFamily: 'DM Sans', fontSize: 14, color: AppColors.textColor),
    labelLarge: const TextStyle(fontFamily: 'DM Sans', fontSize: 13, fontWeight: FontWeight.w500),
  );
}
