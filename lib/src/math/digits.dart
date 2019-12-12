library more.math.digits;

/// Returns an iterable over the digits of the [value], in the optionally
/// given [base].
Iterable<int> digits(int value, [int base = 10]) sync* {
  if (value == 0) {
    yield 0;
  } else {
    var number = value.abs();
    while (number != 0) {
      final next = number ~/ base;
      yield number - next * base;
      number = next;
    }
  }
}
