import 'package:audioplayers/audioplayers.dart';

/// Wrapper tipis di atas `audioplayers`, khusus **musik/VO panjang**
/// (instruksi suara, background music). Untuk efek suara pendek yang sering
/// dipicu (tap/benar/salah), pakai [SfxService], bukan ini — latensinya
/// lebih rendah untuk kasus itu.
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();
  bool muted = false;

  Future<void> playAsset(String assetPath) async {
    if (muted) return;
    try {
      await _player.play(AssetSource(assetPath));
    } catch (_) {
      // Asset belum ada (belum diproduksi Asset creator) — jangan crash,
      // base model harus tetap bisa ditest tanpa audio final.
    }
  }

  Future<void> dispose() => _player.dispose();
}
