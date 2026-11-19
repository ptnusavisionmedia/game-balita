import 'package:flutter/material.dart';

/// Palet warna Bayi GuguGaga.
///
/// Rasional lengkap (kontras, kenapa bukan merah untuk "salah", dsb) ada di
/// `docs/UI_UX_DESIGN.md`. File ini cuma definisi, jangan taruh warna hex
/// baru langsung di widget — tambah di sini dulu.
abstract class AppColors {
  // Brand & background
  static const sunshine = Color(0xFFFFC93C); // primary brand
  static const cream = Color(0xFFFFFDF5); // background utama
  static const ink = Color(0xFF2B2D42); // teks, bukan hitam pekat

  // Feedback (sengaja bukan merah/hijau murni — lebih ramah low-vision/buta warna)
  static const leaf = Color(0xFF6FCF97); // benar
  static const coral = Color(0xFFFF8A65); // coba lagi (bukan "salah" yang menghukum)
  static const gold = Color(0xFFFFD166); // bintang reward

  // Aksen per mini-game (dipakai di tile menu Home & tema screen masing-masing)
  static const accentAngka = Color(0xFF4FC3F7); // sky
  static const accentWarna = Color(0xFFFF8A65); // coral
  static const accentHewan = Color(0xFF6FCF97); // leaf
  static const accentMusik = Color(0xFFB39DDB); // lavender
  static const accentMewarnai = Color(0xFFF48FB1); // pink
  static const accentPuzzle = Color(0xFF4DB6AC); // teal
}
