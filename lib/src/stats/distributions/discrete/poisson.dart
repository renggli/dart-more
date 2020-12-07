import 'dart:math';

import '../../../math/factorial.dart';
import '../../iterable.dart';
import '../continuous/uniform.dart';
import '../discrete.dart';

/// The Poisson distribution is a discrete probability distribution that
/// expresses the probability of a given number of events occurring in a fixed
/// interval of time or space if these events occur with a known constant mean
/// rate and independently of the time since the last event.
///
/// For details see https://en.wikipedia.org/wiki/Poisson_distribution.
class PoissonDistribution extends DiscreteDistribution {
  factory PoissonDistribution.fromSamples(Iterable<num> values) =>
      PoissonDistribution(values.arithmeticMean());

  const PoissonDistribution(this.pois);

  /// Arithmetic mean of a poisson distribution.
  final double pois;

  @override
  int get min => 0;

  @override
  double get mean => pois;

  @override
  double get variance => pois;

  @override
  double pdf(int k) => k < 0
      ? 0.0
      : k == 0
          ? exp(-pois)
          : pow(pois, k) * exp(-pois) / k.factorial();

  @override
  int random({Random? random}) {
    const uniform = UniformDistribution(0, 1);
    var i = 0, b = 1.0;
    while (b >= exp(-pois)) {
      b *= uniform.random(random: random);
      i++;
    }
    return i - 1;
  }

  @override
  bool operator ==(Object other) =>
      other is PoissonDistribution && pois == other.pois;

  @override
  int get hashCode => pois.hashCode;

  @override
  String toString() => 'PoissonDistribution{lambda: $pois}';
}
