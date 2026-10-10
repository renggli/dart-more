import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('operators', () {
    const empty = <int>[];
    const reverse = reverseComparable<num>;

    group('min', () {
      test('empty', () {
        check(() => empty.min()).throws<StateError>();
        check(empty.min(orElse: () => -1)).equals(-1);
      });
      test('comparable', () {
        check([1, 2, 3].min()).equals(1);
        check([3, 2, 1].min()).equals(1);
      });
      test('custom comparator', () {
        check([1, 2, 3].min(comparator: reverse)).equals(3);
        check([3, 2, 1].min(comparator: reverse)).equals(3);
      });
    });

    group('max', () {
      test('empty', () {
        check(() => empty.max()).throws<StateError>();
        check(empty.max(orElse: () => -1)).equals(-1);
      });
      test('comparable', () {
        check([1, 2, 3].max()).equals(3);
        check([3, 2, 1].max()).equals(3);
      });
      test('custom comparator', () {
        check([1, 2, 3].max(comparator: reverse)).equals(1);
        check([3, 2, 1].max(comparator: reverse)).equals(1);
      });
    });

    group('min/max', () {
      const sentinel = (min: -1, max: -1);
      test('empty', () {
        check(() => empty.minMax()).throws<StateError>();
        check(empty.minMax(orElse: () => sentinel)).equals(sentinel);
      });
      test('comparable', () {
        check([1, 2, 3].minMax()).equals((min: 1, max: 3));
        check([3, 2, 1].minMax()).equals((min: 1, max: 3));
      });
      test('custom comparator', () {
        check([1, 2, 3].minMax(comparator: reverse)).equals((min: 3, max: 1));
        check([3, 2, 1].minMax(comparator: reverse)).equals((min: 3, max: 1));
      });
    });

    group('smallest', () {
      test('empty', () {
        check(empty.smallest(0)).isEmpty();
        check(empty.smallest(1)).isEmpty();
        check(empty.smallest(2)).isEmpty();
        check(empty.smallest(3)).isEmpty();
        check(empty.smallest(4)).isEmpty();
      });
      test('comparable', () {
        check([3, 1, 2].smallest(0)).isEmpty();
        check([3, 1, 2].smallest(1)).deepEquals([1]);
        check([3, 1, 2].smallest(2)).deepEquals([1, 2]);
        check([3, 1, 2].smallest(3)).deepEquals([1, 2, 3]);
        check([3, 1, 2].smallest(4)).deepEquals([1, 2, 3]);
      });
      test('custom comparator', () {
        check([3, 1, 2].smallest(0, comparator: reverse)).isEmpty();
        check([3, 1, 2].smallest(1, comparator: reverse)).deepEquals([3]);
        check([3, 1, 2].smallest(2, comparator: reverse)).deepEquals([3, 2]);
        check([3, 1, 2].smallest(3, comparator: reverse)).deepEquals([3, 2, 1]);
        check([3, 1, 2].smallest(4, comparator: reverse)).deepEquals([3, 2, 1]);
      });
    });

    group('largest', () {
      test('empty', () {
        check(empty.largest(0)).isEmpty();
        check(empty.largest(1)).isEmpty();
        check(empty.largest(2)).isEmpty();
        check(empty.largest(3)).isEmpty();
        check(empty.largest(4)).isEmpty();
      });
      test('comparable', () {
        check([3, 1, 2].largest(0)).isEmpty();
        check([3, 1, 2].largest(1)).deepEquals([3]);
        check([3, 1, 2].largest(2)).deepEquals([3, 2]);
        check([3, 1, 2].largest(3)).deepEquals([3, 2, 1]);
        check([3, 1, 2].largest(4)).deepEquals([3, 2, 1]);
      });
      test('custom comparator', () {
        check([3, 1, 2].largest(0, comparator: reverse)).isEmpty();
        check([3, 1, 2].largest(1, comparator: reverse)).deepEquals([1]);
        check([3, 1, 2].largest(2, comparator: reverse)).deepEquals([1, 2]);
        check([3, 1, 2].largest(3, comparator: reverse)).deepEquals([1, 2, 3]);
        check([3, 1, 2].largest(4, comparator: reverse)).deepEquals([1, 2, 3]);
      });
    });
  });
}
