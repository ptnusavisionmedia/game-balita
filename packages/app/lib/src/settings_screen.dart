import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Satu-satunya layar untuk orang tua: toggle suara.
/// Diakses lewat [ParentalGateDialog] dulu — lihat `HomeMenu`.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: AnimatedBuilder(
        animation: ProgressRepository.instance,
        builder: (context, _) {
          final repo = ProgressRepository.instance;
          return SwitchListTile(
            title: const Text('Suara'),
            value: repo.soundEnabled,
            onChanged: (value) async {
              await repo.setSoundEnabled(value);
              SfxService.instance.muted = !value;
              AudioService.instance.muted = !value;
            },
          );
        },
      ),
    );
  }
}
