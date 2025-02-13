/// Precomputed list of factorials.
const List<int> factorials = [
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
  121645100408832000,
  2432902008176640000,
];

extension FactorialIntegerExtension on int {
  /// Returns the factorial of this [int].
  ///
  /// This is the number of ways to arrange `n` distinct objects into a
  /// sequence.
  int factorial() {
    if (this < 0) {
      throw ArgumentError('$this.factorial() is undefined.');
    }
    if (this < factorials.length) {
      return factorials[this];
    }
    var r = factorials.last;
    for (var i = factorials.length; i <= this; i++) {
      r *= i;
    }
    return r;
  }
}

extension FactorialBigIntExtension on BigInt {
  /// Returns the factorial of this [BigInt].
  ///
  /// This is the number of ways to arrange `n` distinct objects into a
  /// sequence.
  BigInt factorial() {
    final n = toInt();
    if (n < 0) {
      throw ArgumentError('$this.factorial() is undefined.');
    }
    if (n < factorials.length) {
      return BigInt.from(factorials[n]);
    }
    var r = BigInt.from(factorials.last);
    for (var i = factorials.length; i <= n; i++) {
      r *= BigInt.from(i);
    }
    return r;
  }
}
