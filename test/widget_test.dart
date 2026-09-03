import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pincus_work/main.dart';

void main() {
  testWidgets('Pincus Work App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PincusWorkApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('material module can be opened', (WidgetTester tester) async {
    await tester.pumpWidget(const PincusWorkApp());

    await tester.tap(find.byIcon(Icons.construction_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Material & Geräte'), findsOneWidget);
    expect(find.text('Eintrag erfassen'), findsOneWidget);
  });

  testWidgets('material entry requires a positive quantity', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PincusWorkApp());
    await tester.tap(find.byIcon(Icons.construction_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Eintrag erfassen'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Speichern'));
    await tester.pump();

    expect(find.text('Material / Gerät erfassen'), findsOneWidget);
    expect(
      find.text('Bitte Bezeichnung und eine gültige Menge angeben.'),
      findsOneWidget,
    );
  });
}
