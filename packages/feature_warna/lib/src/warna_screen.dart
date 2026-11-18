import 'package:flutter/material.dart';
import 'package:core/core.dart';

/// Screen utama mini-game warna & bentuk.
class WarnaGameScreen extends StatelessWidget {
  const WarnaGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BigRoundButton(
          onTap: () {},
          child: const Text('warna & bentuk'),
        ),
      ),
    );
  }
}
