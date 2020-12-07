import 'package:more/stats.dart';
import 'package:test/test.dart';

void main() {
  group('iterable', () {
    const epsilon = 1.0e-6;
    test('sum', () {
      expect([3, 2.25, 4.5, -0.5, 1.0].sum(), closeTo(10.25, epsilon));
    });
    test('sum (int)', () {
      expect([-1, 2, 3, 5, 7].sum(), 16);
    });
    test('average', () {
      expect(<num>[].average(), isNaN);
      expect([1, 2, 3, 4, 4].average(), closeTo(2.8, epsilon));
    });
    test('arithmeticMean', () {
      expect(<num>[].arithmeticMean(), isNaN);
      expect([1, 2, 3, 4, 4].arithmeticMean(), closeTo(2.8, epsilon));
    });
    test('geometricMean', () {
      expect(<num>[].geometricMean(), isNaN);
      expect([54, 24, 36].geometricMean(), closeTo(36.0, epsilon));
    });
    test('harmonicMean', () {
      expect(<num>[].harmonicMean(), isNaN);
      expect([1, -1].harmonicMean(), isNaN);
      expect([2.5, 3, 10].harmonicMean(), closeTo(3.6, epsilon));
    });
    test('variance', () {
      expect(<num>[].variance(), isNaN);
      expect([2.75].variance(), isNaN);
      expect([2.75, 1.75].variance(), closeTo(0.5, epsilon));
      expect([2.75, 1.75, 1.25, 0.25, 0.5, 1.25, 3.5].variance(),
          closeTo(1.372023809523809, epsilon));
    });
    test('populationVariance', () {
      expect(<num>[].populationVariance(), isNaN);
      expect([0.0].populationVariance(), closeTo(0.0, epsilon));
      expect(
          [0.0, 0.25, 0.25, 1.25, 1.5, 1.75, 2.75, 3.25].populationVariance(),
          closeTo(1.25, epsilon));
    });
    test('standardDeviation', () {
      expect(<num>[].standardDeviation(), isNaN);
      expect([1.5].standardDeviation(), isNaN);
      expect(
          [1.5, 2.5].standardDeviation(), closeTo(0.707106781186547, epsilon));
      expect([1.5, 2.5, 2.5, 2.75, 3.25, 4.75].standardDeviation(),
          closeTo(1.081087415521982, epsilon));
    });
    test('populationStandardDeviation', () {
      expect(<num>[].populationStandardDeviation(), isNaN);
      expect([1.5].populationStandardDeviation(), closeTo(0.0, epsilon));
      expect([1.5, 2.5, 2.5, 2.75, 3.25, 4.75].populationStandardDeviation(),
          closeTo(0.98689327352725, epsilon));
    });
  });
}
