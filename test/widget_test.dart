import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pincus_work/main.dart';

void main() {
  testWidgets('Pincus Work App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PincusWorkApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('year calendar can be opened', (WidgetTester tester) async {
    await tester.pumpWidget(const PincusWorkApp());

    await tester.tap(find.byIcon(Icons.calendar_month_outlined));
    await tester.pumpAndSettle();

    expect(find.textContaining('Jahreskalender'), findsOneWidget);
    expect(find.text('Januar'), findsOneWidget);
    expect(find.text('Dezember'), findsOneWidget);
  });
}
