import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('unique', () {
    test('identity', () {
      check([1].unique()).deepEquals([1]);
      check([1, 2].unique()).deepEquals([1, 2]);
      check([1, 2, 3].unique()).deepEquals([1, 2, 3]);
    });
    test('duplicates', () {
      check([1, 1].unique()).deepEquals([1]);
      check([1, 2, 2, 1].unique()).deepEquals([1, 2]);
      check([1, 2, 3, 3, 2, 1].unique()).deepEquals([1, 2, 3]);
    });
    test('repeated', () {
      final uniques = [1, 2, 2, 3, 3, 3].unique();
      check(uniques).deepEquals([1, 2, 3]);
      check(uniques).deepEquals([1, 2, 3]);
    });
    test('factory', () {
      final uniques = [
        1,
        2,
        2,
        3,
        3,
        3,
      ].unique(factory: StorageStrategy.positiveInteger().createSet);
      check(uniques).deepEquals([1, 2, 3]);
      check(uniques).deepEquals([1, 2, 3]);
    });
    test('equals and hashCode', () {
      final a = const Point(1, 2), b = const Point(1, 1) + const Point(0, 1);
      final uniques = [
        a,
        b,
        a,
      ].unique(equals: identical, hashCode: identityHashCode);
      check(uniques).deepEquals([a, b]);
      check(uniques).deepEquals([a, b]);
    });
  });
}
