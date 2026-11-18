/// Hasil satu sesi mini-game, dipakai `app` untuk menyimpan progres anak.
class GameResult {
  const GameResult({
    required this.gameId,
    required this.completedAt,
    this.starsEarned = 0,
  });

  final String gameId;
  final DateTime completedAt;
  final int starsEarned;
}
