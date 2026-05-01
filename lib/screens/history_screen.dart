import 'package:fluent_ui/fluent_ui.dart';

class HistoryScreen extends StatefulWidget {
  final List<String> history;
  final VoidCallback clearHistory;

  const HistoryScreen({
    super.key,
    required this.history,
    required this.clearHistory,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final history = widget.history;

    return ScaffoldPage(
      header: PageHeader(
        title: const Text(
          'History',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        commandBar: IconButton(
          icon: const Icon(FluentIcons.delete),
          onPressed: () {
            setState(() => history.clear());
            widget.clearHistory();
          },
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: history.isEmpty
            ? const Center(
                child: Text(
                  'No history yet',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      history[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
