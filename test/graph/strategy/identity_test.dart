import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('identity', () {
    final strategy = StorageStrategy<Point<int>>.identity();
    final first = const Point(1, 2),
        second = const Point(2, 3) - const Point(1, 1);
    test('set', () {
      final set = strategy.createSet();
      set.addAll([first, second]);
      check(set).unorderedEquals([first, second]);
    });
    test('map', () {
      final map = strategy.createMap<int>();
      map[first] = 42;
      map[second] = 43;
      check(map.keys).unorderedEquals([first, second]);
      check(map.values).unorderedEquals([42, 43]);
    });
  });
}
