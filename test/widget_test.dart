import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pincus_work/main.dart';
import 'package:pincus_work/features/sites/models/site_model.dart';
import 'package:pincus_work/features/sites/screens/baustellen_detail_screen.dart';

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

  testWidgets('customer details can be edited from a site', (WidgetTester tester) async {
    SiteModel? updatedSite;
    final site = SiteModel(
      id: 'site-42',
      name: 'Testbaustelle',
      customer: 'Alter Kunde',
      address: 'Alte Adresse',
      status: 'Geplant',
      contactPerson: 'Alte Kontaktperson',
      phone: '0123 456789',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BaustellenDetailScreen(
          site: site,
          onSiteUpdated: (value) => updatedSite = value,
        ),
      ),
    );

    expect(find.text('Alter Kunde'), findsOneWidget);
    await tester.tap(find.byTooltip('Kundendaten bearbeiten'));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Alter Kunde'), findsOneWidget);
    await tester.enterText(find.widgetWithText(TextField, 'Alter Kunde'), 'Neuer Kunde');
    await tester.enterText(find.widgetWithText(TextField, 'Alte Adresse'), 'Neue Adresse');
    await tester.tap(find.text('Speichern'));
    await tester.pumpAndSettle();

    expect(updatedSite?.id, 'site-42');
    expect(updatedSite?.customer, 'Neuer Kunde');
    expect(updatedSite?.address, 'Neue Adresse');
    expect(find.text('Neuer Kunde'), findsOneWidget);
    expect(find.text('Neue Adresse'), findsOneWidget);
  });
}
