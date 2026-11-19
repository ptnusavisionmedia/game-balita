import 'dart:math';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Mini-game berhitung: tampilkan N objek (1-5), anak pilih angka yang
/// sesuai. Modul ini jadi contoh pola untuk 5 modul `feature_*` lain —
/// lihat `obsidian-vault/Specs/feature_angka.md`.
class AngkaGameScreen extends StatefulWidget {
  const AngkaGameScreen({super.key});

  @override
  State<AngkaGameScreen> createState() => _AngkaGameScreenState();
}

class _AngkaGameScreenState extends State<AngkaGameScreen> {
  static const _questionsPerSession = 4;

  final _random = Random();
  late final List<int> _targets;
  int _questionIndex = 0;
  int _correctCount = 0;
  bool _sessionDone = false;

  @override
  void initState() {
    super.initState();
    _targets = List.generate(_questionsPerSession, (_) => _random.nextInt(5) + 1);
  }

  int get _currentTarget => _targets[_questionIndex];

  int get _starsEarned =>
      (_correctCount * 3 / _questionsPerSession).round().clamp(0, 3);

  List<int> _choicesFor(int target) {
    final choices = <int>{target};
    while (choices.length < 3) {
      final candidate = (target + _random.nextInt(5) - 2).clamp(1, 5);
      choices.add(candidate);
    }
    return choices.toList()..shuffle(_random);
  }

  void _onChoiceTap(int choice) {
    final sfx = SfxService.instance;
    if (choice == _currentTarget) {
      sfx.play('assets/audio/sfx_correct.mp3');
      setState(() {
        _correctCount++;
        if (_questionIndex + 1 >= _targets.length) {
          _sessionDone = true;
        } else {
          _questionIndex++;
        }
      });
    } else {
      sfx.play('assets/audio/sfx_try_again.mp3');
    }
  }

  Future<void> _finishSession() async {
    await ProgressRepository.instance.recordResult(
      GameResult(
        gameId: 'feature_angka',
        completedAt: DateTime.now(),
        starsEarned: _starsEarned,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final choices = _choicesFor(_currentTarget);

    return Scaffold(
      appBar: AppBar(title: const Text('Berhitung')),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    _currentTarget,
                    (_) => const Icon(
                      Icons.favorite,
                      color: AppColors.coral,
                      size: 48,
                    ),
                  ),
                ),
                const SizedBox(height: 48),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: choices
                      .map(
                        (choice) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: BigRoundButton(
                            onTap: () => _onChoiceTap(choice),
                            color: AppColors.accentAngka,
                            child: Text(
                              '$choice',
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          if (_sessionDone)
            StarRewardOverlay(
              starsEarned: _starsEarned,
              onContinue: _finishSession,
            ),
        ],
      ),
    );
  }
}
