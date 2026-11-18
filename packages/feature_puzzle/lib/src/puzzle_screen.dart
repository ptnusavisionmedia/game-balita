import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Screen utama mini-game puzzle.
class PuzzleGameScreen extends StatelessWidget {
  const PuzzleGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BigRoundButton(
          onTap: () {},
          child: const Text('puzzle'),
        ),
      ),
    );
  }
}
