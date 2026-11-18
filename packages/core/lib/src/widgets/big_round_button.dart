import 'package:flutter/material.dart';

/// Tombol bulat besar dengan minimal hit-area 64dp, dipakai di semua mini-game
/// supaya konsisten dan mudah ditekan oleh anak 1-5 tahun.
class BigRoundButton extends StatelessWidget {
  const BigRoundButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size = 88,
    this.color = Colors.orange,
  });

  final VoidCallback onTap;
  final Widget child;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: child),
        ),
      ),
    );
  }
}
