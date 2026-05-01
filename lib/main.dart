import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:desktop_window/desktop_window.dart';
import 'screens/calculator_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await DesktopWindow.setWindowSize(const Size(400, 800));
  }

  runApp(const WindowsCalculatorApp());
}

class WindowsCalculatorApp extends StatelessWidget {
  const WindowsCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Windows 11 Calculator Project',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF202020),
      ),
      home: const CalculatorScreen(),
    );
  }
}