/// Public API package `core`.
///
/// Semua widget/service/model yang dipakai lebih dari satu modul `feature_*`
/// diekspor dari sini. Jangan import file di dalam `src/` secara langsung
/// dari package lain.
library core;

export 'src/widgets/big_round_button.dart';
export 'src/services/audio_service.dart';
export 'src/models/game_result.dart';
