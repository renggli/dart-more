import '../../feature.dart';

const List<int> _factorialsJs = [
  1,
  1,
  2,
  6,
  24,
  120,
  720,
  5040,
  40320,
  362880,
  3628800,
  39916800,
  479001600,
  6227020800,
  87178291200,
  1307674368000,
  20922789888000,
  355687428096000,
  6402373705728000,
];

const List<int> _factorialsVm = [
  ..._factorialsJs,
  121645100408832000,
  2432902008176640000,
];

/// Precomputed list of factorials.
///
/// On the 64-bit Dart VM this contains factorials up to `20!`, while on
/// JavaScript it contains factorials up to `18!` (the maximum safe integer).
const List<int> factorials = isJavaScript ? _factorialsJs : _factorialsVm;

/// Extension on [int] providing [factorial].
extension FactorialIntegerExtension on int {
  /// Returns the factorial of this [int].
  ///
  /// This is the number of ways to arrange `n` distinct objects into a
  /// sequence.
  ///
  /// Throws an [ArgumentError] if `this < 0` or if the result exceeds the
  /// integer range (`n > 20` on the 64-bit Dart VM, `n > 18` on JavaScript).
  /// For arbitrarily large factorials, use [FactorialBigIntExtension.factorial]
  /// instead.
  int factorial() {
    if (0 <= this && this < factorials.length) {
      return factorials[this];
    }
    throw ArgumentError.value(this, 'n', '$this.factorial() is out of range.');
  }
}

/// Extension on [BigInt] providing [factorial].
extension FactorialBigIntExtension on BigInt {
  /// Returns the factorial of this [BigInt].
  ///
  /// This is the number of ways to arrange `n` distinct objects into a
  /// sequence.
  BigInt factorial() {
    if (this < BigInt.zero) {
      throw ArgumentError('$this.factorial() is undefined.');
    }
    if (this < BigInt.from(factorials.length)) {
      return BigInt.from(factorials[toInt()]);
    }
    final n = toInt();
    var r = BigInt.from(factorials.last);
    for (var i = factorials.length; i <= n; i++) {
      r *= BigInt.from(i);
    }
    return r;
  }
}
