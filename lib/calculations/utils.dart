String formatNumber(double value) {
  if (value % 1 == 0) {
    return value.toInt().toString();
  }
  return value.toStringAsPrecision(12).replaceFirst(RegExp(r'\.?0+$'), '');
}
