import 'package:fluent_ui/fluent_ui.dart';
import '../calculations/basic.dart';
import '../calculations/utils.dart';

class BasicCalculator extends StatefulWidget {
  final void Function(String)? onResult;

  const BasicCalculator({super.key, this.onResult});

  @override
  State<BasicCalculator> createState() => _BasicCalculatorState();
}

class _BasicCalculatorState extends State<BasicCalculator> {
  List<String> history = [];
  double firstOperand = 0;
  String operator = '';
  bool awaitingNextOperand = false;

  String expression = '';
  String result = '0';

  final List<String> buttons = [
    '%', 'CE', 'C', '⌫',
    '1/x', 'x²', '√x', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '−',
    '1', '2', '3', '+',
    '±', '0', '.', '='
  ];

  bool get isError => result == 'Error';

  void onButtonPressed(String value) {
    setState(() {
      if (isError) {
        if (value == 'C') {
          expression = '';
          result = '0';
          firstOperand = 0;
          operator = '';
          awaitingNextOperand = false;
        } else if (value == 'CE' || value == '⌫') {
          result = '0';
        } else if (RegExp(r'^[0-9.]$').hasMatch(value)) {
          result = value;
        } else {
          return;
        }
        return;
      }

      if (value == 'C') {
        expression = '';
        result = '0';
        firstOperand = 0;
        operator = '';
        awaitingNextOperand = false;
        return;
      }

      if (value == 'CE') {
        result = '0';
        return;
      }

      if (value == '⌫') {
        if (result.isNotEmpty && result != '0') {
          result = result.substring(0, result.length - 1);
          if (result.isEmpty) result = '0';
        }
        return;
      }

      if (RegExp(r'^[0-9.]$').hasMatch(value)) {
        if (awaitingNextOperand) {
          result = value == '.' ? '0.' : value;
          awaitingNextOperand = false;
        } else {
          result = (result == '0' && value != '.') ? value : result + value;
        }
        return;
      }

      try {
        double current = double.parse(result);

        switch (value) {
          case '±':
            result = formatNumber(negate(current));
            return;
          case '1/x':
            if (current == 0) {
              result = 'Error';
              return;
            }
            expression = '1/${formatNumber(current)} =';
            result =  formatNumber(reciprocal(current));
            history.insert(0, '$expression $result');
            if (widget.onResult != null) {
              widget.onResult!('$expression $result');
            }
            return;
          case 'x²':
            expression = '${formatNumber(current)}² =';
            result = formatNumber(square(current));
            history.insert(0, '$expression $result');
            if (widget.onResult != null) {
              widget.onResult!('$expression $result');
            }
            return;
          case '√x':
            if (current < 0) {
              result = 'Error';
              return;
            }
            expression = '√${formatNumber(current)} =';
            result = formatNumber(sqrtValue(current));
            if (widget.onResult != null) {
              widget.onResult!('$expression $result');
            }
            return;
          case '%':
            // A single number as a percentage
            if (operator.isEmpty) {
              expression = '${formatNumber(current)}% =';
              result = formatNumber(current / 100);
            } else {
              // A number operated on by a percentage of that number
              double percentValue = firstOperand * (current / 100);
              expression = '${formatNumber(firstOperand)} $operator ${formatNumber(percentValue)} =';
              switch (operator) {
                case '+':
                  result = formatNumber(add(firstOperand, percentValue));
                  break;
                case '−':
                  result = formatNumber(subtract(firstOperand, percentValue));
                  break;
                case '×':
                  result = formatNumber(multiply(firstOperand, percentValue));
                  break;
                case '÷':
                  result = formatNumber(divide(firstOperand, percentValue));
                  break;
              }
              operator = '';
            }
            if (widget.onResult != null) {
              widget.onResult!('$expression $result');
            }
            return;
        }
      } catch (_) {
        result = 'Error';
        return;
      }

      if (['+', '−', '×', '÷'].contains(value)) {
        try {
          double current = double.parse(result);
          if (operator.isNotEmpty && !awaitingNextOperand) {
            switch (operator) {
              case '+':
                result = formatNumber(add(firstOperand, current));
                break;
              case '−':
                result = formatNumber(subtract(firstOperand, current));
                break;
              case '×':
                result = formatNumber(multiply(firstOperand, current));
                break;
              case '÷':
                result = formatNumber(divide(firstOperand, current));
                break;
            }
          }
          firstOperand = double.parse(result);
          operator = value;
          awaitingNextOperand = true;
          expression = '${formatNumber(firstOperand)} $operator';
        } catch (_) {
          result = 'Error';
        }
        return;
      }

      if (value == '=') {
        try {
          double current = double.parse(result);
          double eval = firstOperand;
          switch (operator) {
            case '+':
              eval = add(firstOperand, current);
              break;
            case '−':
              eval = subtract(firstOperand, current);
              break;
            case '×':
              eval = multiply(firstOperand, current);
              break;
            case '÷':
              eval = divide(firstOperand, current);
              break;
          }
          expression =
              '${formatNumber(firstOperand)} $operator ${formatNumber(current)} =';
          result = formatNumber(eval);
          history.insert(0, '$expression $result');
          if (widget.onResult != null) {
            widget.onResult!('$expression $result');
          }
          operator = '';
        } catch (_) {
          result = 'Error';
        }
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        int rows = 5;
        int cols = 4;
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
                        fontSize: 32,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),

            const Divider(style: DividerThemeData(thickness: 1)),

            // Buttons grid
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
                    final isOperator = ['÷', '×', '−', '+', '='].contains(btnText);

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
                              fontSize: 22,
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