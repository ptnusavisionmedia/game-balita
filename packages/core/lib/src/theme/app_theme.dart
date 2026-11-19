import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Token tipografi & ukuran, satu tempat supaya 6 mini-game terasa 1 produk.
///
/// Font pakai `google_fonts` (Baloo 2 — rounded, ramah anak), bukan file
/// font manual yang perlu diurus embedding per platform.
abstract class AppTheme {
  /// Hit-area minimum untuk elemen interaktif (lihat docs/UI_UX_DESIGN.md).
  static const double minTouchTarget = 64;

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.sunshine,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.cream,
    );

    final textTheme = GoogleFonts.baloo2TextTheme(base.textTheme).apply(
      bodyColor: AppColors.ink,
      displayColor: AppColors.ink,
    );

    return base.copyWith(
      textTheme: textTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          shape: const StadiumBorder(),
          textStyle: textTheme.titleLarge,
        ),
      ),
    );
  }
}
