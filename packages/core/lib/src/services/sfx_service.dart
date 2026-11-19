import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Efek suara pendek yang dipicu sering (tap, benar, salah).
///
/// Pakai `soundpool`, bukan `audioplayers`, karena latensinya jauh lebih
/// rendah untuk suara pendek yang diputar berulang kali tiap detik.
/// Untuk musik/VO panjang, pakai [AudioService], bukan ini.
class SfxService {
  SfxService._();
  static final SfxService instance = SfxService._();

  final Soundpool _pool = Soundpool.fromOptions(
    options: const SoundpoolOptions(streamType: StreamType.notification),
  );
  final Map<String, int> _loaded = {};
  bool _muted = false;

  set muted(bool value) => _muted = value;

  Future<void> preload(String assetPath) async {
    if (_loaded.containsKey(assetPath)) return;
    try {
      final bytes = await rootBundle.load(assetPath);
      final soundId = await _pool.load(bytes);
      _loaded[assetPath] = soundId;
    } catch (_) {
      // Asset belum ada (belum diproduksi Asset creator) — jangan crash,
      // base model harus tetap bisa ditest tanpa audio final. play()
      // otomatis no-op selama assetPath ini belum ke-load.
    }
  }

  Future<void> play(String assetPath) async {
    if (_muted) return;
    final soundId = _loaded[assetPath];
    if (soundId == null) return;
    await _pool.play(soundId);
  }

  void dispose() => _pool.release();
}
