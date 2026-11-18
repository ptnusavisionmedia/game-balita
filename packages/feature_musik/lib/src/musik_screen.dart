import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Screen utama mini-game musik.
class MusikGameScreen extends StatelessWidget {
  const MusikGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BigRoundButton(
          onTap: () {},
          child: const Text('musik'),
        ),
      ),
    );
  }
}
