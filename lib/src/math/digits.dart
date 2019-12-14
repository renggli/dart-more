library more.math.digits;

extension DigitsIntegerExtension on int {
  /// Returns an iterable over the digits of this [int], in the optionally
  /// given [base].
  Iterable<int> digits([int base = 10]) sync* {
    if (this == 0) {
      yield 0;
    } else {
      var number = abs();
      while (number != 0) {
        final next = number ~/ base;
        yield number - next * base;
        number = next;
      }
    }
  }
}

extension DigitsBigIntExtension on BigInt {
  /// Returns an iterable over the digits of this [BigInt], in the optionally
  /// given [base].
  Iterable<int> digits([int base = 10]) sync* {
    if (this == BigInt.zero) {
      yield 0;
    } else {
      var number = abs();
      final bigBase = BigInt.from(base);
      while (number != BigInt.zero) {
        final next = number ~/ bigBase;
        yield (number - next * bigBase).toInt();
        number = next;
      }
    }
  }
}
