import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Screen utama mini-game suara hewan.
class HewanGameScreen extends StatelessWidget {
  const HewanGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BigRoundButton(
          onTap: () {},
          child: const Text('suara hewan'),
        ),
      ),
    );
  }
}
