import 'package:fluent_ui/fluent_ui.dart';
import '../screens/history_screen.dart';
import '../screens/basic_calculator.dart';
import '../screens/scientific_calculator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  int _selected = 0;
  final PaneDisplayMode _displayMode = PaneDisplayMode.compact;
   final List<String> history = [];

  void addToHistory(String entry) {
    setState(() {
      history.add(entry);
    });
  }

  void clearHistory() {
    setState(() {
      history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      // NavigationView handles the app side bar menu using panes
      pane: NavigationPane(
        displayMode: _displayMode,
        selected: _selected,
        onChanged: (i) => setState(() => _selected = i),
        items: [
          PaneItem(
            icon: const Icon(FluentIcons.history),
            title: const Text('History'),
            body: HistoryScreen(history: history, clearHistory: () => setState(() => history.clear())),
          ),
          PaneItemSeparator(),
          PaneItemHeader(header: Text('Calculator')),
          PaneItem(
            icon: const Icon(FluentIcons.calculator),
            title: const Text('Basic'),
            body: BasicCalculator(
              onResult: addToHistory,
            ),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.test_beaker_solid),
            title: const Text('Scientific'),
            body: ScientificCalculator(),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.bar_chart4),
            title: const Text('Graphing'),
            body: const Center(child: Text('Graphing calculator')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.code),
            title: const Text('Programmer'),
            body: const Center(child: Text('Programmer calculator')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.calendar),
            title: const Text('Date'),
            body: const Center(child: Text('Date calculator')),
          ),
          PaneItemSeparator(),
          PaneItemHeader(header: Text('Converter')),
          PaneItem(
            icon: const Icon(FluentIcons.currency),
            title: const Text('Currency'),
            body: const Center(child: Text('Currency converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.cube_shape),
            title: const Text('Volume'),
            body: const Center(child: Text('Volume converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.design),
            title: const Text('Length'),
            body: const Center(child: Text('Length converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.product_variant),
            title: const Text('Weight and mass'),
            body: const Center(child: Text('Weight and mass converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.frigid),
            title: const Text('Temperature'),
            body: const Center(child: Text('Temperature converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.flame_solid),
            title: const Text('Energy'),
            body: const Center(child: Text('Energy converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.unite_shape),
            title: const Text('Area'),
            body: const Center(child: Text('Area converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.running),
            title: const Text('Speed'),
            body: const Center(child: Text('Speed converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.clock),
            title: const Text('Time'),
            body: const Center(child: Text('Time converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.lightning_bolt),
            title: const Text('Power'),
            body: const Center(child: Text('Power converter')),
          ),
          PaneItem(
            icon: const Icon(FluentIcons.s_d_card),
            title: const Text('Data'),
            body: const Center(child: Text('Data converter')),
          ),
        ],
        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Setttings'),
            body: const Center(child: Text('Settings screen')),
          ),
        ],
      ),
    );
  }
}
