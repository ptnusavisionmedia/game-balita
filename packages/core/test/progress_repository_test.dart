import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('soundEnabled default true, dan tersimpan setelah diubah', () async {
    final repo = ProgressRepository.instance;
    await repo.init();
    expect(repo.soundEnabled, true);

    await repo.setSoundEnabled(false);
    expect(repo.soundEnabled, false);

    // Simulasikan app ditutup-buka lagi: instance baru, baca ulang dari prefs.
    final reopened = ProgressRepository.instance;
    await reopened.init();
    expect(reopened.soundEnabled, false);
  });

  test('recordResult tersimpan dan terbaca lagi via latestResultFor', () async {
    final repo = ProgressRepository.instance;
    await repo.init();

    expect(repo.latestResultFor('feature_angka'), isNull);

    final result = GameResult(
      gameId: 'feature_angka',
      completedAt: DateTime(2026, 11, 19),
      starsEarned: 3,
    );
    await repo.recordResult(result);

    expect(repo.latestResultFor('feature_angka')?.starsEarned, 3);

    final reopened = ProgressRepository.instance;
    await reopened.init();
    expect(reopened.latestResultFor('feature_angka')?.starsEarned, 3);
  });
}
