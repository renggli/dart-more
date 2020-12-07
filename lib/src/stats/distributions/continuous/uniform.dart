import 'dart:math';

import '../../../../hash.dart';
import '../continuous.dart';

/// A uniform distribution between [min] and [max], for details see
/// https://en.wikipedia.org/wiki/Continuous_uniform_distribution.
class UniformDistribution extends ContinuousDistribution {
  const UniformDistribution(this.min, this.max);

  @override
  final double min;

  @override
  final double max;

  @override
  double pdf(num x) => min <= x && x <= max ? 1.0 : 0.0;

  @override
  double cdf(num x) => x <= min
      ? 0.0
      : x <= max
          ? (x - min) / (max - min)
          : 1.0;

  @override
  double get mean => (min + max) / 2.0;

  @override
  double get variance => pow(max - min, 2) / 12.0;

  @override
  double random({Random? random}) =>
      min + (max - min) * ((random ?? _random).nextDouble());

  @override
  bool operator ==(Object other) =>
      other is UniformDistribution && min == other.min && max == other.max;

  @override
  int get hashCode => hash2(min, max);

  @override
  String toString() => 'UniformDistribution[$min..$max]';
}

final _random = Random();
