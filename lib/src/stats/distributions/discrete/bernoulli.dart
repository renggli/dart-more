import 'dart:math';

import '../continuous/uniform.dart';
import '../discrete.dart';

/// The Bernoulli distribution is a discrete probability distribution which
/// takes the value 1 with a probability [p] and 0 otherwise.
///
/// For details see https://en.wikipedia.org/wiki/Bernoulli_distribution.
class BernoulliDistribution extends DiscreteDistribution {
  const BernoulliDistribution(this.p);

  /// Success probability for each trial (0..1).
  final double p;

  /// Failure probability for each trial (0..1).
  double get q => 1.0 - p;

  @override
  int get min => 0;

  @override
  int get max => 1;

  @override
  double get mean => p;

  @override
  double get variance => p * q;

  @override
  double pdf(int k) => k < 0
      ? 0.0
      : k == 0
          ? p
          : k == 1
              ? q
              : 1.0;

  @override
  double cdf(int k) => k < 0
      ? 0.0
      : k < 1
          ? q
          : 1.0;

  @override
  int random({Random? random}) {
    const uniform = UniformDistribution(0, 1);
    return uniform.random(random: random) < p ? 1 : 0;
  }

  @override
  bool operator ==(Object other) =>
      other is BernoulliDistribution && p == other.p;

  @override
  int get hashCode => p.hashCode;

  @override
  String toString() => 'BernoulliDistribution{p: $p, q: $q}';
}
