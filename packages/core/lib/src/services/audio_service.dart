import 'package:audioplayers/audioplayers.dart';

/// Wrapper tipis di atas `audioplayers`, khusus **musik/VO panjang**
/// (instruksi suara, background music). Untuk efek suara pendek yang sering
/// dipicu (tap/benar/salah), pakai [SfxService], bukan ini — latensinya
/// lebih rendah untuk kasus itu.
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playAsset(String assetPath) async {
    await _player.play(AssetSource(assetPath));
  }

  Future<void> dispose() => _player.dispose();
}
