import '../distribution.dart';

abstract class ContinuousDistribution extends Distribution<double> {
  const ContinuousDistribution();

  @override
  double get min => double.negativeInfinity;

  @override
  double get max => double.infinity;
}
