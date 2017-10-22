library more.iterable.math;

import 'dart:collection' show IterableBase;

import 'package:more/src/iterable/fold.dart';

/// Returns an iterable over the fibonacci sequence starting with [f0] and
/// [f1]. The default sequence is indefinitely long and by default starts
/// with 0, 1, 1, 2, 3, 5, 8, 13, ...
Iterable<int> fibonacci([int f0 = 0, int f1 = 1]) {
  return fold([f0, f1], (e) => e[0] + e[1]);
}

/// Returns an iterable over the digits of the [number], in the optionally
/// given [base].
Iterable<int> digits(int number, [int base = 10]) {
  return new DigitIterable(number.abs(), base);
}

class DigitIterable extends IterableBase<int> {
  final int number;
  final int base;

  DigitIterable(this.number, this.base);

  @override
  Iterator<int> get iterator => new DigitIterator(number, base);
}

class DigitIterator extends Iterator<int> {
  int number;
  final int base;

  DigitIterator(this.number, this.base);

  @override
  int current;

  @override
  bool moveNext() {
    if (number == null) {
      current = null;
      return false;
    } else {
      current = number % base;
      number = number ~/ base;
      if (number == 0) {
        number = null;
      }
      return true;
    }
  }
}
