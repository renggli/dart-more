import 'package:meta/meta.dart';

import '../../printer.dart';

/// Lower-case digits and letters by increasing value.
const String lowerCaseDigits = '0123456789abcdefghijklmnopqrstuvwxyz';

/// Upper-case digits and letters by increasing value.
const String upperCaseDigits = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

/// Default string for number delimiters.
const String delimiterString = '.';

/// Default string for infinite values.
const String infinityString = 'Infinity';

/// Default string for NaN values.
const String nanString = 'NaN';

/// Default string for exponent notation.
const String notationString = 'e';

abstract class NumberPrinter extends Printer {
  const NumberPrinter();

  /// Calls the right callback based on the type of number.
  @protected
  T checkNumericType<T>(dynamic object, T Function(num value) nativeCallback,
      T Function(BigInt value) bigIntCallback) {
    if (object is num) {
      return nativeCallback(object);
    } else if (object is BigInt) {
      return bigIntCallback(object);
    } else {
      throw ArgumentError.value(
          object, 'value', 'is not a known numeric type.');
    }
  }

  /// Extracts digits of a positive `int` [value] in the provided [base].
  @protected
  Iterable<int> intDigits(int value, int base) {
    if (value == 0) {
      return <int>[0];
    }
    final digits = <int>[];
    while (value > 0) {
      final next = value ~/ base;
      final index = value - next * base;
      digits.add(index);
      value = next;
    }
    return digits.reversed;
  }

  /// Extracts digits of a positive `BigInt` [value] in the provided [base].
  @protected
  Iterable<int> bigIntDigits(BigInt value, int base) {
    if (value == BigInt.zero) {
      return <int>[0];
    }
    final digits = <int>[];
    final bigBase = BigInt.from(base);
    while (value > BigInt.zero) {
      final next = value ~/ bigBase;
      final index = value - next * bigBase;
      digits.add(index.toInt());
      value = next;
    }
    return digits.reversed;
  }

  /// Converts an iterable of [digits] to a string using [characters] mapping.
  @protected
  String formatDigits(Iterable<int> digits, String characters) =>
      digits.map((digit) => characters[digit]).join();
}
