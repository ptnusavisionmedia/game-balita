import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';

/// Overlay perayaan di akhir sesi mini-game: confetti + jumlah bintang.
///
/// Dipakai sama oleh semua `feature_*` supaya "rasa menang"-nya konsisten.
/// Confetti-nya pakai package `confetti` (particle system teruji), bukan
/// animasi partikel buatan sendiri.
class StarRewardOverlay extends StatefulWidget {
  const StarRewardOverlay({
    super.key,
    required this.starsEarned,
    this.maxStars = 3,
    this.onContinue,
  });

  final int starsEarned;
  final int maxStars;
  final VoidCallback? onContinue;

  @override
  State<StarRewardOverlay> createState() => _StarRewardOverlayState();
}

class _StarRewardOverlayState extends State<StarRewardOverlay> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    if (widget.starsEarned > 0) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(color: Colors.black.withValues(alpha: 0.4)),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              AppColors.sunshine,
              AppColors.sky,
              AppColors.leaf,
              AppColors.gold,
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.all(32),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(widget.maxStars, (i) {
                    final filled = i < widget.starsEarned;
                    return Icon(
                      filled ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.gold,
                      size: 56,
                    ).animate(delay: (120 * i).ms).scale(
                          begin: const Offset(0, 0),
                          end: const Offset(1, 1),
                          curve: Curves.elasticOut,
                          duration: 500.ms,
                        );
                  }),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: widget.onContinue,
                  child: const Text('Lanjut'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
