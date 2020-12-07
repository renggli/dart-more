import 'dart:math';

import 'package:meta/meta.dart';

@immutable
abstract class Distribution<T extends num> {
  const Distribution();

  /// Returns the lower bound of the distribution.
  T get min;

  /// Returns the upper bound of the distribution.
  T get max;

  /// Returns the expected value of mean value for the calling instance.
  double get mean;

  /// Returns the expected value of variance for the calling instance.
  double get variance;

  /// Returns value of probability density function at [x].
  num pdf(T x);

  /// Returns value of cumulative density function at [x].
  num cdf(T x);

  /// Returns a random value within the distribution.
  T random({Random? random});
}
