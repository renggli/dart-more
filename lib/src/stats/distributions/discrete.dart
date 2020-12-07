import '../../../feature.dart';
import '../distribution.dart';

abstract class DiscreteDistribution extends Distribution<int> {
  const DiscreteDistribution();

  @override
  int get min => minSafeInteger;

  @override
  int get max => maxSafeInteger;

  @override
  double cdf(int k) {
    if (k < min) {
      return 0.0;
    } else if (k <= max) {
      var sum = 0.0;
      for (var i = min; i <= k && i <= max; i++) {
        sum += pdf(i);
      }
      return sum;
    } else {
      return 1.0;
    }
  }
}
