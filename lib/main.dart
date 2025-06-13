import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  int _selectedIndex = 0;
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      _HomePage(),
      _CounterPage(
        counter: _counter,
        onIncrement: () => setState(() => _counter++),
      ),
      const _WeatherPage(),
    ];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Portfolio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF041b6e)),
        useMaterial3: true,
        fontFamily: 'Helvetica Neue',
      ),
      home: Scaffold(
        drawer: _Sidebar(
          selectedIndex: _selectedIndex,
          onNav: (i) => setState(() {
            _selectedIndex = i;
            Navigator.of(context).pop(); // close drawer
          }),
        ),
        appBar: AppBar(
          title: Text(_pageTitle(_selectedIndex)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const _AboutPage()),
              ),
              child: const Text('About'),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: pages[_selectedIndex],
        ),
      ),
    );
  }

  String _pageTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Counter';
      case 2:
        return 'Weather';
      default:
        return '';
    }
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.selectedIndex, required this.onNav});

  final int selectedIndex;
  final ValueChanged<int> onNav;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.home, 'Home'),
      (Icons.add_box_outlined, 'Counter'),
      (Icons.list_alt, 'Weather'),
    ];

    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF041b6e), Color(0xFF2d006d), Color(0xFF5b0060)],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Portfolio',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
              ...List.generate(items.length, (i) {
                final (icon, label) = items[i];
                return ListTile(
                  leading: Icon(icon, color: Colors.white),
                  title: Text(label, style: const TextStyle(color: Colors.white)),
                  tileColor: selectedIndex == i
                      ? Colors.white.withOpacity(0.25)
                      : Colors.transparent,
                  onTap: () => onNav(i),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/* ------------------------ Pages -------------------------------------- */

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isMobile = defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text(
          'You are browsing from a ${isMobile ? 'mobile' : 'desktop'} device.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 24),
        const Text('This is the Flutter port of the original MAUI Blazor app.'),
      ],
    );
  }
}

class _CounterPage extends StatelessWidget {
  const _CounterPage({required this.counter, required this.onIncrement});

  final int counter;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Counter', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onIncrement,
          child: const Text('Click me'),
        ),
        const SizedBox(width: 8),
        Text('$counter', style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

class _WeatherPage extends StatelessWidget {
  const _WeatherPage();

  @override
  Widget build(BuildContext context) {
    final summaries = [
      'Freezing','Bracing','Chilly','Cool','Mild',
      'Warm','Balmy','Hot','Sweltering','Scorching'
    ];
    final today = DateTime.now();
    final rows = List.generate(5, (i) {
      final date = today.add(Duration(days: i + 1));
      final c = Random().nextInt(75) - 20;
      final f = (c * 9 / 5 + 32).round();
      final summary = summaries[Random().nextInt(summaries.length)];
      return _WeatherRow(date: date, c: c, f: f, summary: summary);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Weather', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DataTable(
          columns: const [
            DataColumn(label: Text('Date')),
            DataColumn(label: Text('Temp. (C)')),
            DataColumn(label: Text('Temp. (F)')),
            DataColumn(label: Text('Summary')),
          ],
          rows: rows,
        ),
      ],
    );
  }
}

class _WeatherRow extends DataRow {
  _WeatherRow({
    required DateTime date,
    required int c,
    required int f,
    required String summary,
  }) : super(cells: [
          DataCell(Text('${date.month}/${date.day}/${date.year}')),
          DataCell(Text('$c')),
          DataCell(Text('$f')),
          DataCell(Text(summary)),
        ]);
}

class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('About')),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('A stub About page — fill with your own content.'),
          ),
        ),
      );
}
