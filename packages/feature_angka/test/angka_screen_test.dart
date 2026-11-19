import 'package:core/core.dart';
import 'package:feature_angka/feature_angka.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AngkaGameScreen menampilkan judul dan 3 pilihan angka', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: AngkaGameScreen()),
    );

    expect(find.text('Berhitung'), findsOneWidget);
    expect(find.byType(BigRoundButton), findsNWidgets(3));
    expect(find.byIcon(Icons.favorite), findsWidgets);
  });
}
