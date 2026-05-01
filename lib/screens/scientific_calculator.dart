import 'package:fluent_ui/fluent_ui.dart';

class ScientificCalculator extends StatefulWidget {
  final void Function(String)? onResult;

  const ScientificCalculator({super.key, this.onResult});

  @override
  State<ScientificCalculator> createState() => _ScientificCalculatorState();
}

class _ScientificCalculatorState extends State<ScientificCalculator> {
  List<String> history = [];
  String expression = '';
  String result = '0';

  final List<String> buttons = [
    '2nd', 'π', 'e', 'C', '⌫',
    'x²', '1/x', '|x|', 'exp', 'mod',
    '√x', '(', ')', 'n!', '÷',
    'xʸ', '7', '8', '9', '×',
    '10ˣ', '4', '5', '6', '−',
    'log', '1', '2', '3', '+',
    'ln', '±', '0', '.', '='
  ];

  void onButtonPressed(String btnText) {}

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        int cols = 5;
        double spacing = 8;

        return Column(
          children: [
            // Display
            Flexible(
              flex: 2,
              fit: FlexFit.loose,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: const Color(0xFF2D2D2D),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      expression,
                      style: TextStyle(
                        color: theme.inactiveColor,
                        fontSize: 28,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            const Divider(style: DividerThemeData(thickness: 1)),

            // Buttons
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    mainAxisSpacing: spacing,
                    crossAxisSpacing: spacing,
                    childAspectRatio: 1,
                  ),
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    final btnText = buttons[index];
                    final isOperator = [
                      '÷', '×', '−', '+', '=', 'C', '⌫'
                    ].contains(btnText);

                    Color bgColor = isOperator
                        ? const Color(0xFF0067C0)
                        : const Color(0xFF2E2E2E);
                    if (btnText == 'C' || btnText == '⌫') {
                      bgColor = const Color(0xFF3C3C3C);
                    }

                    return HoverButton(
                      onPressed: () => onButtonPressed(btnText),
                      cursor: SystemMouseCursors.click,
                      builder: (context, states) {
                        final pressed = states.isPressing;
                        final hovered = states.isHovering;
                        final color = pressed
                            ? bgColor.withOpacity(0.7)
                            : hovered
                                ? bgColor.withOpacity(0.85)
                                : bgColor;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            btnText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
