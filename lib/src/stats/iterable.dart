import 'dart:math';

extension IterableNumExtension on Iterable<num> {
  /// Returns the sum of this [Iterable].
  ///
  /// Example: `[-1, 2.5].sum()` returns `1.5`.
  ///
  double sum() {
    var sum = 0.0;
    for (final value in this) {
      sum += value;
    }
    return sum;
  }

  /// Returns the average of this [Iterable], see [arithmeticMean] for details.
  double average() => arithmeticMean();

  /// Returns the arithmetic mean (or average) of this [Iterable], or
  /// [double.nan] if the iterable is empty.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Arithmetic_mean.`
  ///
  /// Example: `[5, 2].arithmeticMean()` returns `3.5`.
  ///`
  double arithmeticMean() {
    var count = 0, sum = 0.0;
    for (final value in this) {
      count++;
      sum += value;
    }
    return count == 0 ? double.nan : sum / count;
  }

  /// Returns the geometric mean of this [Iterable], or [double.nan] if the
  /// iterable is empty.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Geometric_mean.
  ///
  /// Example: `[2, 8].geometricMean()` returns `4.0`.
  ///
  double geometricMean() {
    var count = 0, sum = 0.0;
    for (final value in this) {
      count++;
      sum += log(value);
    }
    return count == 0 ? double.nan : exp(sum / count);
  }

  /// Returns the harmonic mean of this [Iterable], or [double.nan] if the
  /// sum of the iterable is 0.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Harmonic_mean.average
  ///
  /// Example: `[2, 3].harmonicMean()` returns `2.4`.
  ///
  double harmonicMean() {
    var count = 0, sum = 0.0;
    for (final value in this) {
      count++;
      sum += 1 / value;
    }
    return sum == 0.0 ? double.nan : count / sum;
  }

  /// Returns the variance of this [Iterable], or [double.nan] if the iterable
  /// contains less than 2 numbers.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Variance.
  ///
  /// Example: `[2, 5].variance()` returns `4.5`.
  ///
  double variance() {
    var count = 0, mean = 0.0, m2 = 0.0;
    for (final value in this) {
      count++;
      final delta = value - mean;
      mean += delta / count;
      final delta2 = value - mean;
      m2 += delta * delta2;
    }
    return count < 2 ? double.nan : m2 / (count - 1);
  }

  /// Returns the population variance of this [Iterable], or [double.nan] if the
  /// iterable is empty.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Variance.
  ///
  /// Example: `[2, 5].populationVariance()` returns `2.25`.
  ///
  double populationVariance() {
    var count = 0, mean = 0.0, m2 = 0.0;
    for (final value in this) {
      count++;
      final delta = value - mean;
      mean += delta / count;
      final delta2 = value - mean;
      m2 += delta * delta2;
    }
    return count == 0 ? double.nan : m2 / count;
  }

  /// Returns the square root of the variance of this [Iterable], or
  /// [double.nan] if the iterable contains less than 2 numbers.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Standard_deviation.
  ///
  /// Example: `[2, 5].standardDeviation()` returns `2.1213...`.
  ///
  double standardDeviation() => sqrt(variance());

  /// Returns the square root of the population variance of this [Iterable], or
  /// [double.nan] if the iterable is empty.
  ///
  /// For details, see https://en.wikipedia.org/wiki/Standard_deviation.
  ///
  /// Example: `[2, 5].populationStandardDeviation()` returns `1.5`.
  ///
  double populationStandardDeviation() => sqrt(populationVariance());
}

extension IterableIntExtension on Iterable<int> {
  /// Returns the sum of this [Iterable].
  int sum() {
    var sum = 0;
    for (final value in this) {
      sum += value;
    }
    return sum;
  }
}
