import 'package:flutter/material.dart';
import 'package:core/core.dart';
import 'package:feature_angka/feature_angka.dart';
import 'package:feature_warna/feature_warna.dart';
import 'package:feature_hewan/feature_hewan.dart';
import 'package:feature_musik/feature_musik.dart';
import 'package:feature_mewarnai/feature_mewarnai.dart';
import 'package:feature_puzzle/feature_puzzle.dart';

import 'src/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressRepository.instance.init();
  final muted = !ProgressRepository.instance.soundEnabled;
  SfxService.instance.muted = muted;
  AudioService.instance.muted = muted;
  runApp(const BayiGuguGagaApp());
}

class BayiGuguGagaApp extends StatelessWidget {
  const BayiGuguGagaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bayi GuguGaga',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const HomeMenu(),
    );
  }
}

/// Menu utama: 1 tombol besar per mini-game.
/// Tambah mini-game baru = tambah 1 baris di list ini, tidak lebih.
class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final games = <String, Widget>{
      'Angka': const AngkaGameScreen(),
      'Warna': const WarnaGameScreen(),
      'Hewan': const HewanGameScreen(),
      'Musik': const MusikGameScreen(),
      'Mewarnai': const MewarnaiGameScreen(),
      'Puzzle': const PuzzleGameScreen(),
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bayi GuguGaga'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan (orang tua)',
            onPressed: () => _openSettings(context),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: games.entries.map((entry) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => entry.value),
            ),
            child: Center(child: Text(entry.key)),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _openSettings(BuildContext context) async {
    final allowed = await ParentalGateDialog.show(context);
    if (allowed && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
    }
  }
}
