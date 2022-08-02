/// Default string for number delimiters.
const String delimiterString = '.';

/// Default string for infinite values.
const String infinityString = 'Infinity';

/// Default string for NaN values.
const String nanString = 'NaN';

/// Default string for exponent notation.
const String notationString = 'e';

/// Extracts digits of a positive `int` [value] in the provided [base].
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

/// Converts an iterable of [digits] to a string using [characters] mapping.
String formatDigits(Iterable<int> digits, List<String> characters) =>
    digits.map((digit) => characters[digit]).join();
