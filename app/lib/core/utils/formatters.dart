class Formatters {
  static String formatThousands(int value) {
    final digits = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final remaining = digits.length - i;
      buffer.write(digits[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }

  static String formatCompact(int val) {
    if (val >= 1000) {
      final k = (val / 1000).toStringAsFixed(1).replaceAll('.0', '');
      return '${k}k';
    }
    return val.toString();
  }
}
