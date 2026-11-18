import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Screen utama mini-game mewarnai.
class MewarnaiGameScreen extends StatelessWidget {
  const MewarnaiGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BigRoundButton(
          onTap: () {},
          child: const Text('mewarnai'),
        ),
      ),
    );
  }
}
