import 'package:bayi_gugugaga_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home menu menampilkan judul app dan mini-game pertama', (tester) async {
    await tester.pumpWidget(const BayiGuguGagaApp());

    expect(find.text('Bayi GuguGaga'), findsOneWidget);
    // GridView lazy-render: hanya tile yang ada di viewport yang ter-build,
    // jadi cuma cek tile pertama ('Angka') yang pasti kelihatan tanpa scroll.
    expect(find.text('Angka'), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
