import 'package:audioplayers/audioplayers.dart';

/// Wrapper tipis di atas `audioplayers` supaya semua mini-game memutar efek
/// suara/VO dengan cara yang sama (volume, caching asset, dsb).
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  final AudioPlayer _player = AudioPlayer();

  Future<void> playAsset(String assetPath) async {
    await _player.play(AssetSource(assetPath));
  }

  Future<void> dispose() => _player.dispose();
}
