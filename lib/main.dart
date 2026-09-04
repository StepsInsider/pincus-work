import 'features/sites/widgets/site_selector_widget.dart';
import 'package:flutter/material.dart';

import 'features/materials/services/material_equipment_service.dart';
import 'features/materials/views/materials_view.dart';
import 'features/photos/photo_upload_dialog.dart';
import 'services/photo_documentation_service.dart';
import 'services/pdf_service.dart';

const _green = Color(0xFF23863A);
const _greenDark = Color(0xFF17672B);
const _greenLight = Color(0xFFEAF5EC);
const _surface = Color(0xFFF7F8F6);
const _border = Color(0xFFE2E7E2);

void main() => runApp(const PincusWorkApp());

class PincusWorkApp extends StatelessWidget {
  const PincusWorkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pincus Work',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _surface,
        colorScheme: ColorScheme.fromSeed(seedColor: _green),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _green, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        ),
      ),
      home: const AppShell(),
    );
  }
}

enum AppModule { dashboard, calendar, sites, materials, time, orders, employees, photos, settings }

class Site {
  Site({String? id, required this.name, required this.customer, required this.address, this.status = 'Aktiv'})
    : id = id ?? name;
  final String id;
  String name;
  String customer;
  String address;
  String status;
}

class TimeEntry {
  TimeEntry({
    required this.employee,
    required this.site,
    required this.date,
    required this.start,
    required this.end,
    required this.breakMinutes,
    required this.task,
  });
  String employee;
  String site;
  String date;
  String start;
  String end;
  String breakMinutes;
  String task;
}

class OrderItem {
  OrderItem({required this.number, required this.title, required this.customer, required this.status});
  String number;
  String title;
  String customer;
  String status;
}

class Employee {
  Employee({required this.name, required this.role, required this.phone});
  String name;
  String role;
  String phone;
}

class PhotoItem {
  PhotoItem({required this.site, required this.description});
  String site;
  String description;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppModule _module = AppModule.dashboard;
  final _materialService = MaterialEquipmentService();
  final _photoService = PhotoDocumentationService();

  final sites = <Site>[
    Site(name: 'Baumfällung Musterstraße', customer: 'Max Mustermann', address: 'Musterstraße 12, Kamen'),
    Site(name: 'Gartenpflege Lindenweg', customer: 'Müller Immobilien', address: 'Lindenweg 8, Unna'),
  ];
  final timeEntries = <TimeEntry>[];
  final orders = <OrderItem>[
    OrderItem(number: 'AU-2026-001', title: 'Baumkontrolle und Pflege', customer: 'Max Mustermann', status: 'Offen'),
    OrderItem(number: 'AU-2026-002', title: 'Heckenschnitt', customer: 'Müller Immobilien', status: 'In Arbeit'),
  ];
  final employees = <Employee>[
    Employee(name: 'René Pincus', role: 'Geschäftsführung', phone: '0170 0000000'),
    Employee(name: 'Mitarbeiter 1', role: 'Fachkraft', phone: '0171 0000000'),
  ];
  final photos = <PhotoItem>[];

  void _addSite(Site site) => setState(() => sites.insert(0, site));
  void _addTime(TimeEntry entry) => setState(() => timeEntries.insert(0, entry));
  void _addOrder(OrderItem item) => setState(() => orders.insert(0, item));
  void _addEmployee(Employee employee) => setState(() => employees.insert(0, employee));
  void _addPhoto(PhotoItem photo) => setState(() => photos.insert(0, photo));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 760;
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const _TopBar(),
                Expanded(
                  child: Row(
                    children: [
                      if (!mobile) _Sidebar(module: _module, onSelect: (m) => setState(() => _module = m)),
                      Expanded(
                        child: _Content(
                          module: _module,
                          sites: sites,
                          materialService: _materialService,
                          photoService: _photoService,
                          onMaterialsChanged: () => setState(() {}),
                          timeEntries: timeEntries,
                          orders: orders,
                          employees: employees,
                          photos: photos,
                          onSelect: (m) => setState(() => _module = m),
                          onAddSite: _addSite,
                          onAddTime: _addTime,
                          onAddOrder: _addOrder,
                          onAddEmployee: _addEmployee,
                          onAddPhoto: _addPhoto,
                        ),
                      ),
                    ],
                  ),
                ),
                if (mobile) _MobileNav(module: _module, onSelect: (m) => setState(() => _module = m)),
                const _FooterBar(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      color: _greenDark,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.park, color: _greenDark, size: 23),
          ),
          const SizedBox(width: 10),
          const Text(
            'PINCUS WORK',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.1),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.white),
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: _greenDark, size: 18),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.module, required this.onSelect});
  final AppModule module;
  final ValueChanged<AppModule> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: _border)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _navIcon(Icons.dashboard_outlined, AppModule.dashboard, module, onSelect, 'Start'),
          _navIcon(Icons.calendar_month_outlined, AppModule.calendar, module, onSelect, 'Jahreskalender'),
          _navIcon(Icons.location_on_outlined, AppModule.sites, module, onSelect, 'Baustellen'),
          _navIcon(Icons.construction_outlined, AppModule.materials, module, onSelect, 'Material & Geräte'),
          _navIcon(Icons.schedule_outlined, AppModule.time, module, onSelect, 'Zeit'),
          _navIcon(Icons.assignment_outlined, AppModule.orders, module, onSelect, 'Aufträge'),
          _navIcon(Icons.groups_outlined, AppModule.employees, module, onSelect, 'Mitarbeiter'),
          _navIcon(Icons.photo_camera_outlined, AppModule.photos, module, onSelect, 'Fotos'),
          const Spacer(),
          _navIcon(Icons.settings_outlined, AppModule.settings, module, onSelect, 'Einstellungen'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

Widget _navIcon(IconData icon, AppModule item, AppModule current, ValueChanged<AppModule> onSelect, String label) {
  final active = item == current;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Tooltip(
      message: label,
      child: InkWell(
        onTap: () => onSelect(item),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 54,
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: active ? _greenLight : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 23, color: active ? _greenDark : Colors.black54),
        ),
      ),
    ),
  );
}

class _MobileNav extends StatelessWidget {
  const _MobileNav({required this.module, required this.onSelect});
  final AppModule module;
  final ValueChanged<AppModule> onSelect;

  @override
  Widget build(BuildContext context) {
    const items = [
      AppModule.dashboard,
      AppModule.calendar,
      AppModule.sites,
      AppModule.materials,
      AppModule.time,
      AppModule.orders,
      AppModule.employees,
    ];
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items.map((item) {
          final icon = switch (item) {
            AppModule.dashboard => Icons.dashboard_outlined,
            AppModule.calendar => Icons.calendar_month_outlined,
            AppModule.sites => Icons.location_on_outlined,
            AppModule.materials => Icons.construction_outlined,
            AppModule.time => Icons.schedule_outlined,
            AppModule.orders => Icons.assignment_outlined,
            _ => Icons.groups_outlined,
          };
          return IconButton(
            onPressed: () => onSelect(item),
            icon: Icon(icon, color: item == module ? _green : Colors.black54),
          );
        }).toList(),
      ),
    );
  }
}

class _FooterBar extends StatelessWidget {
  const _FooterBar();

  @override
  Widget build(BuildContext context) => Container(
    height: 30,
    color: _greenDark,
    alignment: Alignment.center,
    child: const Icon(Icons.park, color: Colors.white, size: 17),
  );
}

class _Content extends StatelessWidget {
  const _Content({
    required this.module,
    required this.sites,
    required this.materialService,
    required this.photoService,
    required this.onMaterialsChanged,
    required this.timeEntries,
    required this.orders,
    required this.employees,
    required this.photos,
    required this.onSelect,
    required this.onAddSite,
    required this.onAddTime,
    required this.onAddOrder,
    required this.onAddEmployee,
    required this.onAddPhoto,
  });
  final AppModule module;
  final List<Site> sites;
  final MaterialEquipmentService materialService;
  final PhotoDocumentationService photoService;
  final VoidCallback onMaterialsChanged;
  final List<TimeEntry> timeEntries;
  final List<OrderItem> orders;
  final List<Employee> employees;
  final List<PhotoItem> photos;
  final ValueChanged<AppModule> onSelect;
  final ValueChanged<Site> onAddSite;
  final ValueChanged<TimeEntry> onAddTime;
  final ValueChanged<OrderItem> onAddOrder;
  final ValueChanged<Employee> onAddEmployee;
  final ValueChanged<PhotoItem> onAddPhoto;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: switch (module) {
            AppModule.dashboard => _Dashboard(
              sites: sites,
              timeEntries: timeEntries,
              orders: orders,
              employees: employees,
              onSelect: onSelect,
            ),
            AppModule.calendar => _YearCalendarView(entries: timeEntries, sites: sites),
            AppModule.sites => _Sites(sites: sites, onAdd: onAddSite),
            AppModule.materials => MaterialsView(sites: sites, service: materialService, onChanged: onMaterialsChanged),
            AppModule.time => _TimeTracking(entries: timeEntries, sites: sites, employees: employees, onAdd: onAddTime),
            AppModule.orders => _Orders(orders: orders, onAdd: onAddOrder),
            AppModule.employees => _Employees(employees: employees, onAdd: onAddEmployee),
            AppModule.photos => _Photos(photos: photos, sites: sites, onAdd: onAddPhoto, service: photoService),
            AppModule.settings => const _Settings(),
          },
        ),
      ),
    );
  }
}

class _YearCalendarView extends StatelessWidget {
  const _YearCalendarView({required this.entries, required this.sites});

  final List<TimeEntry> entries;
  final List<Site> sites;

  @override
  Widget build(BuildContext context) {
    final currentYear = DateTime.now().year;
    final groupedEntries = <String, List<TimeEntry>>{};
    for (final entry in entries) {
      final date = _parseCalendarDate(entry.date);
      if (date != null && date.year == currentYear) {
        final dateKey = _calendarDateKey(date);
        groupedEntries.putIfAbsent(dateKey, () => []).add(entry);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PageHeader(
          title: 'Jahreskalender $currentYear',
          subtitle: 'Einsätze, Mitarbeiter, Baustellen und Stunden nach Tagen.',
        ),
        const SizedBox(height: 18),
        if (groupedEntries.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 14),
            child: Text('Noch keine Zeiteinträge für dieses Jahr.', style: TextStyle(color: Colors.black54)),
          ),
        for (var month = 1; month <= 12; month++) ...[
          _MonthSection(year: currentYear, month: month, groupedEntries: groupedEntries, sites: sites),
          const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _MonthSection extends StatelessWidget {
  const _MonthSection({required this.year, required this.month, required this.groupedEntries, required this.sites});

  final int year;
  final int month;
  final Map<String, List<TimeEntry>> groupedEntries;
  final List<Site> sites;

  static const _monthNames = [
    'Januar',
    'Februar',
    'März',
    'April',
    'Mai',
    'Juni',
    'Juli',
    'August',
    'September',
    'Oktober',
    'November',
    'Dezember',
  ];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final leadingDays = firstDay.weekday - 1;

    return _ModuleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_monthNames[month - 1], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _WeekdayLabel('Mo'),
              _WeekdayLabel('Di'),
              _WeekdayLabel('Mi'),
              _WeekdayLabel('Do'),
              _WeekdayLabel('Fr'),
              _WeekdayLabel('Sa'),
              _WeekdayLabel('So'),
            ],
          ),
          const SizedBox(height: 6),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingDays + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 86,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < leadingDays) return const SizedBox.shrink();
              final day = index - leadingDays + 1;
              final dateKey = _calendarDateKey(DateTime(year, month, day));
              final dayEntries = groupedEntries[dateKey] ?? const <TimeEntry>[];
              return _CalendarDay(day: day, entries: dayEntries, sites: sites, dateStr: dateKey);
            },
          ),
        ],
      ),
    );
  }
}

class _WeekdayLabel extends StatelessWidget {
  const _WeekdayLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Text(
      label,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black54),
    ),
  );
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({required this.day, required this.entries, required this.sites, required this.dateStr});

  final int day;
  final List<TimeEntry> entries;
  final List<Site> sites;
  final String dateStr;

  @override
  Widget build(BuildContext context) {
    final totalHours = entries.fold<double>(0, (total, entry) => total + _entryHours(entry));
    final summaries = <String, double>{};
    for (final entry in entries) {
      final site = sites.where((s) => s.name == entry.site).firstOrNull;
      final customer = site?.customer;
      final label = customer == null || customer.isEmpty ? entry.site : '${entry.site} · $customer';
      summaries[label] = (summaries[label] ?? 0) + _entryHours(entry);
    }

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Tagesdetails für den $dateStr'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gesamte Stunden: ${totalHours.toStringAsFixed(1)} Std.', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (entries.isEmpty)
                      const Text('Keine Zeiteinträge an diesem Tag.')
                    else
                      ...entries.map((e) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Mitarbeiter: ${e.employee}', style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('Baustelle/Kunde: ${e.site}'),
                              Text('Zeitraum: ${e.start} - ${e.end} (${_entryHours(e).toStringAsFixed(1)} Std.)'),
                              if (e.task.isNotEmpty) Text('Notiz: ${e.task}', style: const TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                      )),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Schließen')),
            ],
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: entries.isEmpty ? Colors.white : _greenLight,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: entries.isEmpty ? _border : _green),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$day', style: const TextStyle(fontWeight: FontWeight.w800)),
            if (entries.isNotEmpty) ...[
              const Spacer(),
              Text(
                '${totalHours.toStringAsFixed(1)} Std. · ${entries.length}Eins.',
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
              ),
              ...summaries.entries
                  .take(2)
                  .map(
                    (summary) => Text(
                      '${summary.key}: ${summary.value.toStringAsFixed(1)}Std.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 9, color: Colors.black54),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}

DateTime? _parseCalendarDate(String value) {
  final trimmed = value.trim();
  final parsed = DateTime.tryParse(trimmed);
  if (parsed != null) return parsed;
  final parts = trimmed.split('.');
  if (parts.length != 3) return null;
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return null;
  return DateTime.tryParse('$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}');
}

String _calendarDateKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

double _entryHours(TimeEntry entry) {
  final start = _parseClock(entry.start);
  final end = _parseClock(entry.end);
  final breakMinutes = double.tryParse(entry.breakMinutes.replaceAll(',', '.')) ?? 0;
  if (start == null || end == null) return 0;
  final duration = end - start - breakMinutes;
  return duration > 0 ? duration / 60 : 0;
}

int? _parseClock(String value) {
  final parts = value.trim().split(':');
  if (parts.length != 2) return null;
  final hours = int.tryParse(parts[0]);
  final minutes = int.tryParse(parts[1]);
  if (hours == null || minutes == null || hours < 0 || minutes < 0 || minutes > 59) {
    return null;
  }
  return hours * 60 + minutes;
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.title, required this.subtitle, this.action});
  final String title;
  final String subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
      ?action,
    ],
  );
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({
    required this.sites,
    required this.timeEntries,
    required this.orders,
    required this.employees,
    required this.onSelect,
  });
  final List<Site> sites;
  final List<TimeEntry> timeEntries;
  final List<OrderItem> orders;
  final List<Employee> employees;
  final ValueChanged<AppModule> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _PageHeader(title: 'PINCUS WORK', subtitle: 'Baum- & Landschaftspflege · Übersicht'),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, c) {
            final columns = c.maxWidth > 850
                ? 4
                : c.maxWidth > 560
                ? 2
                : 1;
            return GridView.count(
              crossAxisCount: columns,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.4,
              children: [
                _StatCard(
                  icon: Icons.location_on_outlined,
                  title: 'Baustellen',
                  value: '${sites.length}',
                  onTap: () => onSelect(AppModule.sites),
                ),
                _StatCard(
                  icon: Icons.schedule_outlined,
                  title: 'Zeiteinträge',
                  value: '${timeEntries.length}',
                  onTap: () => onSelect(AppModule.time),
                ),
                _StatCard(
                  icon: Icons.assignment_outlined,
                  title: 'Aufträge',
                  value: '${orders.length}',
                  onTap: () => onSelect(AppModule.orders),
                ),
                _StatCard(
                  icon: Icons.groups_outlined,
                  title: 'Mitarbeiter',
                  value: '${employees.length}',
                  onTap: () => onSelect(AppModule.employees),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Container(
          height: 210,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: CustomPaint(painter: _TreePainter())),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Arbeitsübersicht', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                    const SizedBox(height: 8),
                    const Text('Alle wichtigen Bereiche auf einen Blick.', style: TextStyle(color: Colors.black54)),
                    const Spacer(),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _QuickAction(
                          icon: Icons.add_location_alt_outlined,
                          label: 'Baustelle anlegen',
                          onTap: () => onSelect(AppModule.sites),
                        ),
                        _QuickAction(
                          icon: Icons.timer_outlined,
                          label: 'Zeit erfassen',
                          onTap: () => onSelect(AppModule.time),
                        ),
                        _QuickAction(
                          icon: Icons.add_task,
                          label: 'Auftrag anlegen',
                          onTap: () => onSelect(AppModule.orders),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, c) {
            if (c.maxWidth < 700) {
              return Column(
                children: [
                  _RecentCard(
                    title: 'Aktuelle Baustellen',
                    empty: sites.isEmpty,
                    children: sites.take(4).map(_siteTile).toList(),
                  ),
                  const SizedBox(height: 12),
                  _RecentCard(
                    title: 'Aufträge',
                    empty: orders.isEmpty,
                    children: orders.take(4).map(_orderTile).toList(),
                  ),
                ],
              );
            }
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _RecentCard(
                    title: 'Aktuelle Baustellen',
                    empty: sites.isEmpty,
                    children: sites.take(4).map(_siteTile).toList(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RecentCard(
                    title: 'Aufträge',
                    empty: orders.isEmpty,
                    children: orders.take(4).map(_orderTile).toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _siteTile(Site s) => ListTile(
    dense: true,
    leading: const Icon(Icons.park_outlined, color: _green),
    title: Text(s.name),
    subtitle: Text('${s.customer} · ${s.address}'),
    trailing: Text(
      s.status,
      style: const TextStyle(color: _green, fontWeight: FontWeight.w700),
    ),
  );
  Widget _orderTile(OrderItem o) => ListTile(
    dense: true,
    leading: const Icon(Icons.assignment_outlined, color: _green),
    title: Text(o.title),
    subtitle: Text('${o.number} · ${o.customer}'),
    trailing: Text(o.status, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
  );
}

class _TreePainter extends CustomPainter {
  const _TreePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = _green.withValues(alpha: .08);
    final tree = Path()
      ..moveTo(size.width * .58, size.height)
      ..quadraticBezierTo(size.width * .55, size.height * .65, size.width * .58, size.height * .38)
      ..quadraticBezierTo(size.width * .48, size.height * .30, size.width * .40, size.height * .20)
      ..quadraticBezierTo(size.width * .54, size.height * .24, size.width * .62, size.height * .34)
      ..quadraticBezierTo(size.width * .72, size.height * .16, size.width * .88, size.height * .19)
      ..quadraticBezierTo(size.width * .76, size.height * .28, size.width * .70, size.height * .43)
      ..quadraticBezierTo(size.width * .84, size.height * .31, size.width * .97, size.height * .38)
      ..quadraticBezierTo(size.width * .80, size.height * .48, size.width * .68, size.height * .55)
      ..quadraticBezierTo(size.width * .73, size.height * .75, size.width * .70, size.height)
      ..close();
    canvas.drawPath(tree, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.title, required this.value, required this.onTap});
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: _greenLight, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: _greenDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) =>
      OutlinedButton.icon(onPressed: onTap, icon: Icon(icon, size: 18), label: Text(label));
}

class _RecentCard extends StatelessWidget {
  const _RecentCard({required this.title, required this.children, required this.empty});
  final String title;
  final List<Widget> children;
  final bool empty;
  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        ),
        if (empty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Noch keine Einträge.', style: TextStyle(color: Colors.black54)),
          ),
        ...children,
      ],
    ),
  );
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 18),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _border),
    ),
    child: child,
  );
}

class _Sites extends StatelessWidget {
  const _Sites({required this.sites, required this.onAdd});
  final List<Site> sites;
  final ValueChanged<Site> onAdd;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _PageHeader(
        title: 'Baustellen',
        subtitle: 'Baustellen, Kunden und Einsatzorte verwalten.',
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => PdfService.printSitesReport(
                title: 'Baustellenübersicht Pincus Work',
                items: sites.map((s) => {
                  'name': s.name,
                  'customer': s.customer,
                  'address': s.address,
                  'status': s.status,
                }).toList(),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('PDF Export'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _showSiteForm(context, onAdd),
              icon: const Icon(Icons.add),
              label: const Text('Baustelle anlegen'),
            ),
          ],
        ),
      ),
      _ModuleCard(
        child: sites.isEmpty
            ? const Text('Noch keine Baustellen angelegt.')
            : Column(
                children: sites
                    .map(
                      (s) => _DataTile(
                        icon: Icons.park_outlined,
                        title: s.name,
                        subtitle: '${s.customer} · ${s.address}',
                        status: s.status,
                      ),
                    )
                    .toList(),
              ),
      ),
    ],
  );
}

class _TimeTracking extends StatelessWidget {
  const _TimeTracking({required this.entries, required this.sites, required this.employees, required this.onAdd});
  final List<TimeEntry> entries;
  final List<Site> sites;
  final List<Employee> employees;
  final ValueChanged<TimeEntry> onAdd;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _PageHeader(
        title: 'Zeiterfassung',
        subtitle: 'Arbeitszeiten direkt im Einsatz erfassen.',
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => PdfService.printTimeReport(
                title: 'Stundennachweis Pincus Work',
                items: entries.map((e) => {
                  'date': e.date,
                  'employee': e.employee,
                  'site': e.site,
                  'hours': '${e.start} - ${e.end} (${e.breakMinutes} Min.)',
                }).toList(),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('PDF Export'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _showTimeForm(context, sites, employees, onAdd),
              icon: const Icon(Icons.add),
              label: const Text('Zeit erfassen'),
            ),
          ],
        ),
      ),
      _ModuleCard(
        child: entries.isEmpty
            ? const _EmptyState(
                icon: Icons.schedule_outlined,
                text: 'Noch keine Zeiteinträge. Erstelle den ersten Eintrag.',
              )
            : Column(
                children: entries
                    .map(
                      (e) => _DataTile(
                        icon: Icons.schedule,
                        title: '${e.employee} · ${e.site}',
                        subtitle: '${e.date} · ${e.start}–${e.end} · Pause ${e.breakMinutes} Min. · ${e.task}',
                      ),
                    )
                    .toList(),
              ),
      ),
    ],
  );
}

class _Orders extends StatelessWidget {
  const _Orders({required this.orders, required this.onAdd});
  final List<OrderItem> orders;
  final ValueChanged<OrderItem> onAdd;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _PageHeader(
        title: 'Aufträge',
        subtitle: 'Aufträge, Leistungen und Material verwalten.',
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => PdfService.printOrdersReport(
                title: 'Auftragsübersicht Pincus Work',
                items: orders.map((o) => {
                  'number': o.number,
                  'title': o.title,
                  'customer': o.customer,
                  'status': o.status,
                }).toList(),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('PDF Export'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _showOrderForm(context, onAdd),
              icon: const Icon(Icons.add),
              label: const Text('Auftrag anlegen'),
            ),
          ],
        ),
      ),
      _ModuleCard(
        child: Column(
          children: orders
              .map(
                (o) => _DataTile(
                  icon: Icons.assignment_outlined,
                  title: o.title,
                  subtitle: '${o.number} · ${o.customer}',
                  status: o.status,
                ),
              )
              .toList(),
        ),
      ),
    ],
  );
}

class _Employees extends StatelessWidget {
  const _Employees({required this.employees, required this.onAdd});
  final List<Employee> employees;
  final ValueChanged<Employee> onAdd;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      _PageHeader(
        title: 'Mitarbeiter',
        subtitle: 'Stammdaten und Kontaktdaten verwalten.',
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => PdfService.printEmployeesReport(
                title: 'Mitarbeiterübersicht Pincus Work',
                items: employees.map((e) => {
                  'name': e.name,
                  'role': e.role,
                  'phone': e.phone,
                }).toList(),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('PDF Export'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _showEmployeeForm(context, onAdd),
              icon: const Icon(Icons.add),
              label: const Text('Mitarbeiter anlegen'),
            ),
          ],
        ),
      ),
      _ModuleCard(
        child: Column(
          children: employees
              .map((e) => _DataTile(icon: Icons.person_outline, title: e.name, subtitle: '${e.role} · ${e.phone}'))
              .toList(),
        ),
      ),
    ],
  );
}

class _Photos extends StatelessWidget {
  const _Photos({required this.photos, required this.sites, required this.onAdd, required this.service});
  final List<PhotoItem> photos;
  final List<Site> sites;
  final ValueChanged<PhotoItem> onAdd;
  final PhotoDocumentationService service;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _PageHeader(
        title: 'Fotos',
        subtitle: 'Baustellenfotos mit Beschreibung dokumentieren.',
        action: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => PdfService.printPhotosReport(
                title: 'Fotodokumentation Pincus Work',
                items: photos.map((p) => {
                  'siteName': p.site,
                  'description': p.description,
                  'date': '-',
                }).toList(),
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text('PDF Export'),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: sites.isEmpty
                  ? null
                  : () => showDialog<void>(
                      context: context,
                      builder: (context) => PhotoUploadDialog(
                        sites: sites.map((s) => SiteSelectorItem(id: s.name, name: s.name, status: 'aktiv')).toList(),
                        service: service,
                        onSaved: (photoDoc) {
                          onAdd(PhotoItem(site: photoDoc.projectId, description: photoDoc.note));
                        },
                      ),
                    ),
              icon: const Icon(Icons.add),
              label: const Text('Foto hochladen'),
            ),
          ],
        ),
      ),
      _ModuleCard(
        child: Column(
          children: photos.isEmpty
              ? [const Padding(padding: EdgeInsets.all(16), child: Text('Keine Fotos vorhanden'))]
              : photos.map((p) => _DataTile(
                  icon: Icons.photo_outlined,
                  title: p.site,
                  subtitle: p.description,
                )).toList(),
        ),
      ),
    ],
  );
}

class _Settings extends StatelessWidget {
  const _Settings();
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const _PageHeader(title: 'Einstellungen', subtitle: 'Grundlegende Einstellungen für Pincus Work.'),
      const _ModuleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unternehmen', style: TextStyle(fontWeight: FontWeight.w800)),
            SizedBox(height: 10),
            Text('René Pincus Baum- & Landschaftspflege'),
            SizedBox(height: 6),
            Text(
              'Datenanbindung, Authentifizierung und Backend werden in einem separaten Schritt ergänzt.',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    ],
  );
}

class _DataTile extends StatelessWidget {
  const _DataTile({required this.icon, required this.title, required this.subtitle, this.status});
  final IconData icon;
  final String title;
  final String subtitle;
  final String? status;
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 4),
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: _greenLight, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: _greenDark),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text(subtitle),
    trailing: status == null
        ? null
        : Text(
            status!,
            style: const TextStyle(color: _green, fontWeight: FontWeight.w700),
          ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Icon(icon, size: 42, color: _green),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
        ],
      ),
    ),
  );
}

Future<void> _showSiteForm(BuildContext context, ValueChanged<Site> onSave) async {
  final name = TextEditingController();
  final customer = TextEditingController();
  final address = TextEditingController();
  await _showForm(
    context,
    title: 'Baustelle anlegen',
    fields: [
      TextField(
        controller: name,
        decoration: const InputDecoration(labelText: 'Baustellenname *'),
      ),
      TextField(
        controller: customer,
        decoration: const InputDecoration(labelText: 'Kunde *'),
      ),
      TextField(
        controller: address,
        decoration: const InputDecoration(labelText: 'Adresse *'),
      ),
    ],
    onSave: () {
      if (name.text.trim().isEmpty || customer.text.trim().isEmpty || address.text.trim().isEmpty) {
        return false;
      }
      onSave(Site(name: name.text.trim(), customer: customer.text.trim(), address: address.text.trim()));
      return true;
    },
  );
}

Future<void> _showTimeForm(
  BuildContext context,
  List<Site> sites,
  List<Employee> employees,
  ValueChanged<TimeEntry> onSave,
) async {
  final date = TextEditingController(text: _dateNow());
  final start = TextEditingController(text: '07:00');
  final end = TextEditingController(text: '16:00');
  final pause = TextEditingController(text: '30');
  final task = TextEditingController();
  String? employee = employees.isNotEmpty ? employees.first.name : null;
  String? site = sites.isNotEmpty ? sites.first.name : null;
  await _showForm(
    context,
    title: 'Zeit erfassen',
    fields: [
      DropdownButtonFormField<String>(
        initialValue: employee,
        decoration: const InputDecoration(labelText: 'Mitarbeiter'),
        items: employees.map((e) => DropdownMenuItem(value: e.name, child: Text(e.name))).toList(),
        onChanged: (v) => employee = v,
      ),
      DropdownButtonFormField<String>(
        initialValue: site,
        decoration: const InputDecoration(labelText: 'Baustelle'),
        items: sites.map((s) => DropdownMenuItem(value: s.name, child: Text(s.name))).toList(),
        onChanged: (v) => site = v,
      ),
      TextField(
        controller: date,
        decoration: const InputDecoration(labelText: 'Datum'),
      ),
      TextField(
        controller: start,
        decoration: const InputDecoration(labelText: 'Beginn'),
      ),
      TextField(
        controller: end,
        decoration: const InputDecoration(labelText: 'Ende'),
      ),
      TextField(
        controller: pause,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Pause (Minuten)'),
      ),
      TextField(
        controller: task,
        decoration: const InputDecoration(labelText: 'Tätigkeit'),
      ),
    ],
    onSave: () {
      if (employee == null || site == null || task.text.trim().isEmpty) {
        return false;
      }
      onSave(
        TimeEntry(
          employee: employee!,
          site: site!,
          date: date.text.trim(),
          start: start.text.trim(),
          end: end.text.trim(),
          breakMinutes: pause.text.trim(),
          task: task.text.trim(),
        ),
      );
      return true;
    },
  );
}

Future<void> _showOrderForm(BuildContext context, ValueChanged<OrderItem> onSave) async {
  final number = TextEditingController(text: 'AU-${DateTime.now().year}-');
  final title = TextEditingController();
  final customer = TextEditingController();
  await _showForm(
    context,
    title: 'Auftrag anlegen',
    fields: [
      TextField(
        controller: number,
        decoration: const InputDecoration(labelText: 'Auftragsnummer'),
      ),
      TextField(
        controller: title,
        decoration: const InputDecoration(labelText: 'Bezeichnung *'),
      ),
      TextField(
        controller: customer,
        decoration: const InputDecoration(labelText: 'Kunde *'),
      ),
    ],
    onSave: () {
      if (title.text.trim().isEmpty || customer.text.trim().isEmpty) {
        return false;
      }
      onSave(
        OrderItem(
          number: number.text.trim(),
          title: title.text.trim(),
          customer: customer.text.trim(),
          status: 'Offen',
        ),
      );
      return true;
    },
  );
}

Future<void> _showEmployeeForm(BuildContext context, ValueChanged<Employee> onSave) async {
  final name = TextEditingController();
  final role = TextEditingController();
  final phone = TextEditingController();
  await _showForm(
    context,
    title: 'Mitarbeiter anlegen',
    fields: [
      TextField(
        controller: name,
        decoration: const InputDecoration(labelText: 'Name *'),
      ),
      TextField(
        controller: role,
        decoration: const InputDecoration(labelText: 'Rolle / Tätigkeit'),
      ),
      TextField(
        controller: phone,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(labelText: 'Telefon'),
      ),
    ],
    onSave: () {
      if (name.text.trim().isEmpty) return false;
      onSave(Employee(name: name.text.trim(), role: role.text.trim(), phone: phone.text.trim()));
      return true;
    },
  );
}

Future<void> _showForm(
  BuildContext context, {
  required String title,
  required List<Widget> fields,
  required bool Function() onSave,
}) async {
  await showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: fields.map((f) => Padding(padding: const EdgeInsets.only(bottom: 12), child: f)).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Abbrechen')),
        FilledButton(
          onPressed: () {
            if (onSave()) Navigator.pop(context);
          },
          child: const Text('Speichern'),
        ),
      ],
    ),
  );
}

String _dateNow() {
  final d = DateTime.now();
  return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}
