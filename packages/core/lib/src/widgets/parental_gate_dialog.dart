import 'package:flutter/material.dart';

/// Gate sederhana sebelum masuk Settings atau aksi lain yang bukan untuk
/// anak — anak kecil biasanya tidak sabar menahan tombol 3 detik penuh,
/// orang tua bisa.
///
/// Pakai lewat [ParentalGateDialog.show], bukan `showDialog` manual.
class ParentalGateDialog extends StatefulWidget {
  const ParentalGateDialog({super.key});

  static const holdDuration = Duration(seconds: 3);

  /// Menampilkan gate, return `true` kalau berhasil ditahan penuh.
  static Future<bool> show(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const ParentalGateDialog(),
    );
    return result ?? false;
  }

  @override
  State<ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<ParentalGateDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: ParentalGateDialog.holdDuration,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pop(true);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mode Orang Tua'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Tahan tombol di bawah selama 3 detik untuk lanjut.'),
          const SizedBox(height: 24),
          GestureDetector(
            onTapDown: (_) => _controller.forward(),
            onTapUp: (_) => _controller.reverse(),
            onTapCancel: () => _controller.reverse(),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) => SizedBox(
                width: 72,
                height: 72,
                child: CircularProgressIndicator(
                  value: _controller.value,
                  strokeWidth: 6,
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
      ],
    );
  }
}
