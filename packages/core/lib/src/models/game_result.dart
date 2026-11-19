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

  Map<String, dynamic> toJson() => {
        'gameId': gameId,
        'completedAt': completedAt.toIso8601String(),
        'starsEarned': starsEarned,
      };

  factory GameResult.fromJson(Map<String, dynamic> json) => GameResult(
        gameId: json['gameId'] as String,
        completedAt: DateTime.parse(json['completedAt'] as String),
        starsEarned: json['starsEarned'] as int,
      );
}
