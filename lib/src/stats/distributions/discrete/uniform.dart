import 'dart:math';

import '../../../../hash.dart';
import '../continuous/uniform.dart';
import '../discrete.dart';

/// A discrete uniform distribution between [min] and [max], for details see
/// https://en.wikipedia.org/wiki/Discrete_uniform_distribution.
class UniformDiscreteDistribution extends DiscreteDistribution {
  const UniformDiscreteDistribution(this.min, this.max);

  @override
  final int min;

  @override
  final int max;

  // Returns the number of elements in this distribution.
  int get length => max - min + 1;

  @override
  double pdf(int x) => min <= x && x <= max ? 1.0 / length : 0.0;

  @override
  double cdf(int x) => x <= min
      ? 0.0
      : x <= max
          ? (x - min) / length
          : 1.0;

  @override
  double get mean => 0.5 * (min + max);

  @override
  double get variance => (length * length - 1) / 12;

  @override
  int random({Random? random}) =>
      min + (length * _uniform.random(random: random)).floor();

  @override
  bool operator ==(Object other) =>
      other is UniformDiscreteDistribution &&
      min == other.min &&
      max == other.max;

  @override
  int get hashCode => hash2(min, max);

  @override
  String toString() => 'UniformDiscreteDistribution[$min..$max]';
}

const _uniform = UniformDistribution(0, 1);
