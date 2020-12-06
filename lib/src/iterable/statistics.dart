import 'dart:math';

extension NumStatisticExtension on Iterable<num> {
  /// Returns the sum of this [Iterable].
  double sum() => fold(0, (a, b) => a + b);

  /// Returns the average of this [Iterable], see the [arithmeticMean].
  ///
  /// For details, see https://en.wikipedia.org/wiki/Arithmetic_mean.
  double average() => arithmeticMean();

  /// Returns the arithmetic mean (or average) of this [Iterable].
  ///
  /// For details, see https://en.wikipedia.org/wiki/Arithmetic_mean.
  double arithmeticMean() {
    var count = 0, sum = 0.0;
    for (final value in this) {
      count++;
      sum += value;
    }
    return sum / count;
  }

  /// Returns the geometric mean of this [Iterable].
  ///
  /// For details, see https://en.wikipedia.org/wiki/Geometric_mean.
  double geometricMean() {
    var count = 0, sum = 0.0;
    for (final value in this) {
      count++;
      sum += log(value);
    }
    return exp(sum / count);
  }

  /// Returns the harmonic mean of this [Iterable].
  ///
  /// For details, see https://en.wikipedia.org/wiki/Harmonic_mean.
  double harmonicMean() {
    var count = 0, sum = 0.0;
    for (final value in this) {
      count++;
      sum += 1 / value;
    }
    return count / sum;
  }

  /// Returns the variance of this [Iterable].
  ///
  /// For details, see https://en.wikipedia.org/wiki/Variance.
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

  /// Returns the population variance of this [Iterable].
  ///
  /// For details, see https://en.wikipedia.org/wiki/Variance.
  double populationVariance() {
    var count = 0, mean = 0.0, m2 = 0.0;
    for (final value in this) {
      count++;
      final delta = value - mean;
      mean += delta / count;
      final delta2 = value - mean;
      m2 += delta * delta2;
    }
    return count < 1 ? double.nan : m2 / count;
  }

  /// Returns the square root of the variance of this [Iterable].
  ///
  /// For details, see https://en.wikipedia.org/wiki/Standard_deviation.
  double standardDeviation() => sqrt(variance());

  /// Returns the square root of the population variance of this [Iterable].
  ///
  /// For details, see https://en.wikipedia.org/wiki/Standard_deviation.
  double populationStandardDeviation() => sqrt(populationVariance());
}

extension IntStatisticExtension on Iterable<int> {
  /// Returns the sum of this [Iterable].
  int sum() => fold(0, (a, b) => a + b);
}
