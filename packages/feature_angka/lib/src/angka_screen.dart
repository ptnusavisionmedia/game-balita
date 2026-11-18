import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Screen utama mini-game berhitung.
class AngkaGameScreen extends StatelessWidget {
  const AngkaGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BigRoundButton(
          onTap: () {},
          child: const Text('berhitung'),
        ),
      ),
    );
  }
}
