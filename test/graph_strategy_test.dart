import 'dart:math';

import 'package:more/graph.dart';
import 'package:test/test.dart';

void main() {
  group('object', () {
    final strategy = StorageStrategy<String>.object();
    test('set', () {
      final set = strategy.createSet();
      set.addAll(['foo', 'bar', 'foo']);
      expect(set, hasLength(2));
      expect(set, unorderedEquals(['foo', 'bar']));
    });
    test('map', () {
      final map = strategy.createMap<int>();
      map['foo'] = 42;
      map['bar'] = 43;
      expect(map, hasLength(2));
      expect(map, {'foo': 42, 'bar': 43});
    });
  });
  group('identity', () {
    final strategy = StorageStrategy<Point<int>>.identity();
    final first = const Point(1, 2),
        second = const Point(2, 3) - const Point(1, 1);
    test('set', () {
      final set = strategy.createSet();
      set.addAll([first, second]);
      expect(set, unorderedEquals([first, second]));
    });
    test('map', () {
      final map = strategy.createMap<int>();
      map[first] = 42;
      map[second] = 43;
      expect(map.keys, unorderedEquals([first, second]));
      expect(map.values, unorderedEquals([42, 43]));
    });
  });
  group('integer', () {
    final strategy = StorageStrategy.integer();
    test('set', () {
      final set = strategy.createSet();
      expect(set.add(42), isTrue);
      expect(set.add(-43), isTrue);
      expect(set.add(42), isFalse);
      expect(set.contains(42), isTrue);
      expect(set.contains(41), isFalse);
      expect(set.contains('foo' as dynamic), isFalse);
      expect(set, unorderedEquals([42, -43]));
      expect(set.length, 2);
      expect(() => set.lookup(42), throwsUnimplementedError);
      expect(set.remove(42), isTrue);
      expect(set.remove(42), isFalse);
      expect(set.remove('foo' as dynamic), isFalse);
      expect(set.toSet(), {-43});
      set.clear();
      expect(set, isEmpty);
    });
    test('map', () {
      final map = strategy.createMap<String>();
      map[-42] = 'foo';
      map[43] = 'bar';
      map[43] = 'baz';
      expect(map[-42], 'foo');
      expect(map[43], 'baz');
      expect(map[44], isNull);
      expect(map['foo' as dynamic], isNull);
      expect(map.containsKey(-42), isTrue);
      expect(map.containsKey(43), isTrue);
      expect(map.containsKey(44), isFalse);
      expect(map.keys, unorderedEquals([-42, 43]));
      expect(map.values, unorderedEquals(['foo', 'baz']));
      expect(map.remove(-42), 'foo');
      expect(map.remove(-42), isNull);
      expect(map.remove('foo' as dynamic), isNull);
      map.clear();
      expect(map, isEmpty);
    });
    test('map (nullable)', () {
      final map = strategy.createMap<String?>();
      map[-3] = 'foo';
      map[2] = 'bar';
      map[2] = null;
      expect(map[-3], 'foo');
      expect(map[2], isNull);
      expect(map[3], isNull);
      expect(map['foo' as dynamic], isNull);
      expect(map.containsKey(-3), isTrue);
      expect(map.containsKey(2), isTrue);
      expect(map.containsKey(3), isFalse);
      expect(map.keys, unorderedEquals([2, -3]));
      expect(map.values, unorderedEquals([null, 'foo']));
      expect(map.remove(2), isNull);
      expect(map.remove('foo' as dynamic), isNull);
      map.clear();
      expect(map, isEmpty);
    });
  });
  group('positive integer', () {
    final strategy = StorageStrategy.positiveInteger();
    test('set', () {
      final set = strategy.createSet();
      expect(set.add(42), isTrue);
      expect(set.add(43), isTrue);
      expect(set.add(42), isFalse);
      expect(set.contains(42), isTrue);
      expect(set.contains(41), isFalse);
      expect(set.contains('foo' as dynamic), isFalse);
      expect(set, unorderedEquals([42, 43]));
      expect(set.length, 2);
      expect(() => set.lookup(42), throwsUnimplementedError);
      expect(set.remove(42), isTrue);
      expect(set.remove(42), isFalse);
      expect(set.remove('foo' as dynamic), isFalse);
      expect(set.toSet(), {43});
      set.clear();
      expect(set, isEmpty);
    });
    test('map', () {
      final map = strategy.createMap<String>();
      map[42] = 'foo';
      map[43] = 'bar';
      map[43] = 'baz';
      expect(map[42], 'foo');
      expect(map[43], 'baz');
      expect(map[44], isNull);
      expect(map['foo' as dynamic], isNull);
      expect(map.containsKey(42), isTrue);
      expect(map.containsKey(43), isTrue);
      expect(map.containsKey(44), isFalse);
      expect(map.keys, unorderedEquals([42, 43]));
      expect(map.values, unorderedEquals(['foo', 'baz']));
      expect(map.remove(42), 'foo');
      expect(map.remove(42), isNull);
      expect(map.remove('foo' as dynamic), isNull);
      map.clear();
      expect(map, isEmpty);
    });
    test('map (nullable)', () {
      final map = strategy.createMap<String?>();
      map[3] = 'foo';
      map[2] = 'bar';
      map[2] = null;
      expect(map[3], 'foo');
      expect(map[2], isNull);
      expect(map[1], isNull);
      expect(map['foo' as dynamic], isNull);
      expect(map.containsKey(3), isTrue);
      expect(map.containsKey(2), isTrue);
      expect(map.containsKey(1), isFalse);
      expect(map.keys, unorderedEquals([2, 3]));
      expect(map.values, unorderedEquals([null, 'foo']));
      expect(map.remove(2), isNull);
      expect(map.remove('foo' as dynamic), isNull);
      map.clear();
      expect(map, isEmpty);
    });
  });
}
