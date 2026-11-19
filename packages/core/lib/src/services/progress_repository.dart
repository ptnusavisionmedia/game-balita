import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/game_result.dart';

/// Satu-satunya tempat baca/simpan progres anak (hasil tiap mini-game) dan
/// setting suara, dipakai semua modul `feature_*` + `app` lewat `core`.
///
/// Pakai `ChangeNotifier` bawaan Flutter, bukan Riverpod/Bloc — lihat
/// `docs/LIBRARIES.md` untuk alasannya.
///
/// **Wajib** panggil `ProgressRepository.instance.init()` sekali di
/// `main()` sebelum `runApp(...)`, supaya data lama sudah termuat saat UI
/// pertama kali dibangun.
class ProgressRepository extends ChangeNotifier {
  ProgressRepository._();
  static final ProgressRepository instance = ProgressRepository._();

  static const _soundEnabledKey = 'sound_enabled';
  static const _resultsKey = 'game_results';

  late SharedPreferences _prefs;
  bool _soundEnabled = true;
  final List<GameResult> _results = [];

  bool get soundEnabled => _soundEnabled;

  /// Semua hasil game yang pernah tersimpan, urut dari yang paling lama.
  List<GameResult> get results => List.unmodifiable(_results);

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _soundEnabled = _prefs.getBool(_soundEnabledKey) ?? true;

    final raw = _prefs.getStringList(_resultsKey) ?? const <String>[];
    _results
      ..clear()
      ..addAll(
        raw.map(
          (entry) => GameResult.fromJson(
            jsonDecode(entry) as Map<String, dynamic>,
          ),
        ),
      );
  }

  Future<void> setSoundEnabled(bool value) async {
    _soundEnabled = value;
    await _prefs.setBool(_soundEnabledKey, value);
    notifyListeners();
  }

  /// Hasil terakhir untuk 1 modul (misal `feature_angka`), `null` kalau
  /// modul itu belum pernah dimainkan.
  GameResult? latestResultFor(String gameId) {
    for (var i = _results.length - 1; i >= 0; i--) {
      if (_results[i].gameId == gameId) return _results[i];
    }
    return null;
  }

  Future<void> recordResult(GameResult result) async {
    _results.add(result);
    await _prefs.setStringList(
      _resultsKey,
      _results.map((r) => jsonEncode(r.toJson())).toList(),
    );
    notifyListeners();
  }
}
