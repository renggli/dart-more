library more.iterable.math;

import 'package:more/src/iterable/fold.dart';

/// Returns an iterable over the fibonacci sequence starting with [f0] and
/// [f1]. The default sequence is indefinitely long and by default starts
/// with 0, 1, 1, 2, 3, 5, 8, 13, ...
Iterable<int> fibonacci([int f0 = 0, int f1 = 1]) =>
    fold([f0, f1], (args) => args[0] + args[1]);

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
