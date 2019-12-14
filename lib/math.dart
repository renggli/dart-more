/// A collection of common mathematical functions.
library more.math;

export 'src/math/binomial.dart'
    show BinomialIntegerExtension, BinomialBigIntExtension;
export 'src/math/digits.dart'
    show DigitsIntegerExtension, DigitsBigIntExtension;
export 'src/math/factorial.dart'
    show FactorialIntegerExtension, FactorialBigIntExtension;
export 'src/math/hyperbolic.dart' show HyperbolicNumExtension;
export 'src/math/is_probably_prime.dart'
    show ProbablyPrimeIntegerExtension, ProbablyPrimeBigIntExtension;
export 'src/math/lcm.dart' show LcmIntegerExtension, LcmBigIntExtension;
export 'src/math/math.dart' show MathNumExtension;
export 'src/math/primes.dart' show PrimesIntExtension;
