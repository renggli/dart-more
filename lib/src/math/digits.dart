extension DigitsIntegerExtension on int {
  /// Returns an iterable over the digits of this [int] in the given [base].
  ///
  /// The digits are produced from least significant to most significant.
  /// For example, `123.digits()` yields `3`, then `2`, then `1`.
  ///
  /// For negative numbers, the digits of the absolute value are returned.
  /// For example, `-123.digits()` also yields `3`, then `2`, then `1`.
  ///
  /// The [base] must be greater than or equal to 2.
  Iterable<int> digits([int base = 10]) sync* {
    assert(base >= 2, 'base must be greater than or equal to 2');
    if (this == 0) {
      yield 0;
    } else {
      var number = abs();
      while (number > 0) {
        yield number % base;
        number ~/= base;
      }
    }
  }
}

extension DigitsBigIntExtension on BigInt {
  /// Returns an iterable over the digits of this [BigInt] in the given [base].
  ///
  /// The digits are produced from least significant to most significant.
  /// For example, `BigInt.from(123).digits()` yields `3`, then `2`, then `1`.
  ///
  /// For negative numbers, the digits of the absolute value are returned.
  /// For example, `BigInt.from(-123).digits()` also yields `3`, then `2`,
  /// then `1`.
  ///
  /// The [base] must be greater than or equal to 2.
  Iterable<int> digits([int base = 10]) sync* {
    assert(base >= 2, 'base must be greater than or equal to 2');
    if (this == BigInt.zero) {
      yield 0;
    } else {
      var number = abs();
      final bigBase = BigInt.from(base);
      while (number > BigInt.zero) {
        yield (number % bigBase).toInt();
        number ~/= bigBase;
      }
    }
  }
}
