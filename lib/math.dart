/// A collection of common mathematical functions.
library math;

export 'src/math/binomial.dart'
    show BinomialBigIntExtension, BinomialIntegerExtension;
export 'src/math/bit.dart' show BitUint32Extension;
export 'src/math/digits.dart'
    show DigitsBigIntExtension, DigitsIntegerExtension;
export 'src/math/double.dart' show DoubleExtension;
export 'src/math/factorial.dart'
    show FactorialBigIntExtension, FactorialIntegerExtension;
export 'src/math/hyperbolic.dart' show HyperbolicNumberExtension;
export 'src/math/is_probably_prime.dart'
    show
        ProbablyPrimeBigIntExtension,
        ProbablyPrimeComplexExtension,
        ProbablyPrimeIntegerExtension;
export 'src/math/lcm.dart' show LcmBigIntExtension, LcmIntegerExtension;
export 'src/math/math.dart' show MathNumberExtension;
export 'src/math/polynomial.dart' show PolynomialIterableExtension;
export 'src/math/primes/atkin.dart' show AtkinPrimeSieve;
export 'src/math/primes/eratosthenes.dart' show EratosthenesPrimeSieve;
export 'src/math/primes/euler.dart' show EulerPrimeSieve;
export 'src/math/primes/sieve.dart' show PrimeSieve;
