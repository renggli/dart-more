// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:more/collection.dart';
import 'package:test/test.dart';

import 'utils/collection.dart';

void main() {
  group('constructor', () {
    test('empty', () {
      final set = Multiset<String>();
      expect(set, isEmpty);
      expect(set, hasLength(0));
      expect(set, unorderedEquals([]));
      expect(set.entrySet, unorderedEquals([]));
      expect(set.elementSet, unorderedEquals([]));
      expect(set.elementCounts, unorderedEquals([]));
      expect(set.distinct, unorderedEquals([]));
      expect(set.counts, unorderedEquals([]));
    });
    test('empty identity', () {
      final set = Multiset<String>.identity();
      expect(set, isEmpty);
      expect(set, hasLength(0));
      expect(set, unorderedEquals([]));
      expect(set.entrySet, unorderedEquals([]));
      expect(set.elementSet, unorderedEquals([]));
      expect(set.elementCounts, unorderedEquals([]));
      expect(set.distinct, unorderedEquals([]));
      expect(set.counts, unorderedEquals([]));
    });
    test('of one unique', () {
      final set = Multiset.of(['a']);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(1));
      expect(set, unorderedEquals(['a']));
      expect(set.entrySet, unorderedEquals([isMapEntry('a', 1)]));
      expect(set.elementSet, unorderedEquals(['a']));
      expect(set.elementCounts, unorderedEquals([1]));
      expect(set.distinct, unorderedEquals(['a']));
      expect(set.counts, unorderedEquals([1]));
    });
    test('of many unique', () {
      final set = Multiset.of(['a', 'b', 'c']);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(3));
      expect(set, unorderedEquals(['a', 'b', 'c']));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry('a', 1),
          isMapEntry('b', 1),
          isMapEntry('c', 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
      expect(set.elementCounts, unorderedEquals([1, 1, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      expect(set.counts, unorderedEquals([1, 1, 1]));
    });
    test('of one repeated', () {
      final set = Multiset.of(['a', 'a', 'a']);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(3));
      expect(set, unorderedEquals(['a', 'a', 'a']));
      expect(set.entrySet, unorderedEquals([isMapEntry('a', 3)]));
      expect(set.elementSet, unorderedEquals(['a']));
      expect(set.elementCounts, unorderedEquals([3]));
      expect(set.distinct, unorderedEquals(['a']));
      expect(set.counts, unorderedEquals([3]));
    });
    test('of many repeated', () {
      final set = Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(6));
      expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry('a', 3),
          isMapEntry('b', 2),
          isMapEntry('c', 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
      expect(set.elementCounts, unorderedEquals([3, 2, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      expect(set.counts, unorderedEquals([3, 2, 1]));
    });
    test('of set', () {
      final set = Multiset.of({'a', 'b', 'c'});
      expect(set, isNot(isEmpty));
      expect(set, hasLength(3));
      expect(set, unorderedEquals(['a', 'b', 'c']));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry('a', 1),
          isMapEntry('b', 1),
          isMapEntry('c', 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
      expect(set.elementCounts, unorderedEquals([1, 1, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      expect(set.counts, unorderedEquals([1, 1, 1]));
    });
    test('from many repeated', () {
      final set = Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(6));
      expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry('a', 3),
          isMapEntry('b', 2),
          isMapEntry('c', 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
      expect(set.elementCounts, unorderedEquals([3, 2, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      expect(set.counts, unorderedEquals([3, 2, 1]));
    });
    test('copy', () {
      final set = Multiset.of(Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']));
      expect(set, isNot(isEmpty));
      expect(set, hasLength(6));
      expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry('a', 3),
          isMapEntry('b', 2),
          isMapEntry('c', 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
      expect(set.elementCounts, unorderedEquals([3, 2, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      expect(set.counts, unorderedEquals([3, 2, 1]));
    });
    test('generate', () {
      final set = Multiset<String>.fromIterable(['a', 'a', 'a', 'b', 'b', 'c']);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(6));
      expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry('a', 3),
          isMapEntry('b', 2),
          isMapEntry('c', 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
      expect(set.elementCounts, unorderedEquals([3, 2, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      expect(set.counts, unorderedEquals([3, 2, 1]));
    });
    test('generate with key', () {
      final set = Multiset<int>.fromIterable([
        'a',
        'a',
        'a',
        'b',
        'b',
        'c',
      ], key: (e) => (e as String).codeUnitAt(0));
      expect(set, isNot(isEmpty));
      expect(set, hasLength(6));
      expect(set, unorderedEquals([97, 97, 97, 98, 98, 99]));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry(97, 3),
          isMapEntry(98, 2),
          isMapEntry(99, 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals([97, 98, 99]));
      expect(set.elementCounts, unorderedEquals([3, 2, 1]));
      expect(set.distinct, unorderedEquals([97, 98, 99]));
      expect(set.counts, unorderedEquals([3, 2, 1]));
    });
    test('generate with count', () {
      final set = Multiset.fromIterable(
        ['aaa', 'bb', 'c'],
        key: (e) => (e as String).substring(0, 1),
        count: (e) => (e as String).length,
      );
      expect(set, isNot(isEmpty));
      expect(set, hasLength(6));
      expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry('a', 3),
          isMapEntry('b', 2),
          isMapEntry('c', 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
      expect(set.elementCounts, unorderedEquals([3, 2, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      expect(set.counts, unorderedEquals([3, 2, 1]));
    });
    test('convert', () {
      final set = ['a', 'a', 'a', 'b', 'b', 'c'].toMultiset();
      expect(set, isNot(isEmpty));
      expect(set, hasLength(6));
      expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
      expect(
        set.entrySet,
        unorderedEquals([
          isMapEntry('a', 3),
          isMapEntry('b', 2),
          isMapEntry('c', 1),
        ]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
      expect(set.elementCounts, unorderedEquals([3, 2, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      expect(set.counts, unorderedEquals([3, 2, 1]));
    });
  });
  group('adding', () {
    test('zero', () {
      final set = Multiset<String>()
        ..add('a', 0)
        ..add('b', 0);
      expect(set, isEmpty);
      expect(set, hasLength(0));
      expect(set, unorderedEquals([]));
      expect(set.entrySet, unorderedEquals([]));
      expect(set.elementSet, unorderedEquals([]));
      expect(set.elementCounts, unorderedEquals([]));
      expect(set.distinct, unorderedEquals([]));
      expect(set.counts, unorderedEquals([]));
    });
    test('single', () {
      final set = Multiset<String>()
        ..add('a')
        ..add('b')
        ..add('b');
      expect(set, isNot(isEmpty));
      expect(set, hasLength(3));
      expect(set, unorderedEquals(['a', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 1), isMapEntry('b', 2)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([1, 2]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([1, 2]));
    });
    test('multiple', () {
      final set = Multiset<String>()
        ..add('a', 2)
        ..add('b', 3);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(5));
      expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([2, 3]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([2, 3]));
    });
    test('all', () {
      final set = Multiset<String>()..addAll(['a', 'a', 'b', 'b', 'b']);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(5));
      expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([3, 2]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([3, 2]));
    });
    test('error', () {
      final set = Multiset<String>();
      expect(() => set.add('a', -1), throwsArgumentError);
      expect(set, isEmpty);
      expect(set, hasLength(0));
      expect(set, unorderedEquals([]));
      expect(set.entrySet, unorderedEquals([]));
      expect(set.elementSet, unorderedEquals([]));
      expect(set.elementCounts, unorderedEquals([]));
      expect(set.distinct, unorderedEquals([]));
      expect(set.counts, unorderedEquals([]));
    });
  });
  group('removing', () {
    test('zero', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set
        ..remove('a', 0)
        ..remove('b', 0);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(5));
      expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([2, 3]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([2, 3]));
    });
    test('single', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set
        ..remove('a')
        ..remove('b');
      expect(set, isNot(isEmpty));
      expect(set, hasLength(3));
      expect(set, unorderedEquals(['a', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 1), isMapEntry('b', 2)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([1, 2]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([1, 2]));
    });
    test('multiple', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set
        ..remove('a', 3)
        ..remove('b', 2);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(1));
      expect(set, unorderedEquals(['b']));
      expect(set.entrySet, unorderedEquals([isMapEntry('b', 1)]));
      expect(set.elementSet, unorderedEquals(['b']));
      expect(set.elementCounts, unorderedEquals([1]));
      expect(set.distinct, unorderedEquals(['b']));
      expect(set.counts, unorderedEquals([1]));
    });
    test('all', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set.removeAll(['a', 'b', 'b', 123, null]);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(2));
      expect(set, unorderedEquals(['a', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 1), isMapEntry('b', 1)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([1, 1]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([1, 1]));
    });
    test('clear', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set.clear();
      expect(set, isEmpty);
      expect(set, hasLength(0));
      expect(set, unorderedEquals([]));
      expect(set.entrySet, unorderedEquals([]));
      expect(set.elementSet, unorderedEquals([]));
      expect(set.elementCounts, unorderedEquals([]));
      expect(set.distinct, unorderedEquals([]));
      expect(set.counts, unorderedEquals([]));
    });
    test('invalid', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      expect(() => set.remove('c'), returnsNormally);
      expect(() => set.remove('z'), returnsNormally);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(5));
      expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([2, 3]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([2, 3]));
    });
    test('error', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      expect(() => set.remove('a', -1), throwsArgumentError);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(5));
      expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([2, 3]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([2, 3]));
    });
  });
  group('access', () {
    test('single', () {
      final set = Multiset<String>();
      set['a'] = 2;
      expect(set['a'], 2);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(2));
      expect(set, unorderedEquals(['a', 'a']));
      expect(set.entrySet, unorderedEquals([isMapEntry('a', 2)]));
      expect(set.elementSet, unorderedEquals(['a']));
      expect(set.elementCounts, unorderedEquals([2]));
      expect(set.distinct, unorderedEquals(['a']));
      expect(set.counts, unorderedEquals([2]));
    });
    test('multiple', () {
      final set = Multiset<String>();
      set['a'] = 2;
      set['b'] = 3;
      expect(set['a'], 2);
      expect(set['b'], 3);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(5));
      expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([3, 2]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([3, 2]));
    });
    test('remove', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set['b'] = 0;
      expect(set, isNot(isEmpty));
      expect(set, hasLength(2));
      expect(set, unorderedEquals(['a', 'a']));
      expect(set.entrySet, unorderedEquals([isMapEntry('a', 2)]));
      expect(set.elementSet, unorderedEquals(['a']));
      expect(set.elementCounts, unorderedEquals([2]));
      expect(set.distinct, unorderedEquals(['a']));
      expect(set.counts, unorderedEquals([2]));
    });
    test('error', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      expect(() => set['a'] = -1, throwsArgumentError);
      expect(set, isNot(isEmpty));
      expect(set, hasLength(5));
      expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
      expect(
        set.entrySet,
        unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
      );
      expect(set.elementSet, unorderedEquals(['a', 'b']));
      expect(set.elementCounts, unorderedEquals([2, 3]));
      expect(set.distinct, unorderedEquals(['a', 'b']));
      expect(set.counts, unorderedEquals([2, 3]));
    });
  });
  group('operator', () {
    final firstList = ['a', 'b', 'c', 'c'];
    final firstSet = Multiset.of(firstList);
    final secondList = ['a', 'c', 'd', 'd'];
    final secondSet = Multiset.of(secondList);
    test('contains', () {
      expect(firstSet.contains('a'), isTrue);
      expect(firstSet.contains('b'), isTrue);
      expect(firstSet.contains('c'), isTrue);
      expect(firstSet.contains('d'), isFalse);
    });
    test('containsAll', () {
      expect(firstSet.containsAll(firstSet), isTrue);
      expect(firstSet.containsAll(secondSet), isFalse);
      expect(firstSet.containsAll(Multiset()), isTrue);
      expect(firstSet.containsAll(Multiset.of(['a', 'b', 'b'])), isFalse);
      expect(firstSet.containsAll(Multiset.of(['a', 'b', 'd'])), isFalse);
    });
    test('containsAll (iterable)', () {
      expect(firstSet.containsAll(firstList), isTrue);
      expect(firstSet.containsAll(secondList), isFalse);
      expect(firstSet.containsAll([]), isTrue);
      expect(firstSet.containsAll(['a']), isTrue);
      expect(firstSet.containsAll(['x']), isFalse);
      expect(firstSet.containsAll(['a', 'b', 'b']), isFalse);
      expect(firstSet.containsAll(['a', 'b', 'd']), isFalse);
      expect(firstSet.containsAll([1, 2]), isFalse);
      expect(firstSet.containsAll(['a', null]), isFalse);
    });
    test('combine', () {
      expect(
        firstSet.combine(secondSet, (_, a, b) => a + b),
        unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
      );
      expect(
        firstSet.combine(secondSet, (_, a, b) => min(a, b)),
        unorderedEquals(['a', 'c']),
      );
      expect(
        firstSet.combine(secondSet, (_, a, b) => max(0, a - b)),
        unorderedEquals(['b', 'c']),
      );
      expect(
        firstSet.combine(secondSet, (_, a, b) => max(a - b, b - a)),
        unorderedEquals(['b', 'c', 'd', 'd']),
      );
    });
    test('combine (iterable)', () {
      expect(
        firstSet.combine(secondList, (_, a, b) => a + b),
        unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
      );
      expect(
        firstSet.combine(secondList, (_, a, b) => min(a, b)),
        unorderedEquals(['a', 'c']),
      );
      expect(
        firstSet.combine(secondList, (_, a, b) => max(0, a - b)),
        unorderedEquals(['b', 'c']),
      );
      expect(
        firstSet.combine(secondList, (_, a, b) => max(a - b, b - a)),
        unorderedEquals(['b', 'c', 'd', 'd']),
      );
    });
    test('intersection', () {
      expect(firstSet.intersection(secondSet), unorderedEquals(['a', 'c']));
      expect(
        firstSet.intersection(secondSet).distinct,
        unorderedEquals(['a', 'c']),
      );
      expect(secondSet.intersection(firstSet), unorderedEquals(['a', 'c']));
      expect(
        secondSet.intersection(firstSet).distinct,
        unorderedEquals(['a', 'c']),
      );
    });
    test('intersection (iterable)', () {
      expect(firstSet.intersection(secondList), unorderedEquals(['a', 'c']));
      expect(secondSet.intersection(firstList), unorderedEquals(['a', 'c']));
      expect(firstSet.intersection(['a', 1, null]), unorderedEquals(['a']));
    });
    test('union', () {
      expect(
        firstSet.union(secondSet),
        unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
      );
      expect(
        firstSet.union(secondSet).distinct,
        unorderedEquals(['a', 'b', 'c', 'd']),
      );
      expect(
        secondSet.union(firstSet),
        unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
      );
      expect(
        secondSet.union(firstSet).distinct,
        unorderedEquals(['a', 'b', 'c', 'd']),
      );
    });
    test('union (iterable)', () {
      expect(
        firstSet.union(secondList),
        unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
      );
      expect(
        secondSet.union(firstList),
        unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
      );
    });
    test('difference', () {
      expect(firstSet.difference(secondSet), unorderedEquals(['b', 'c']));
      expect(
        firstSet.difference(secondSet).distinct,
        unorderedEquals(['b', 'c']),
      );
      expect(secondSet.difference(firstSet), unorderedEquals(['d', 'd']));
      expect(secondSet.difference(firstSet).distinct, unorderedEquals(['d']));
    });
    test('difference (iterable)', () {
      expect(firstSet.difference(secondList), unorderedEquals(['b', 'c']));
      expect(secondSet.difference(firstList), unorderedEquals(['d', 'd']));
      expect(
        firstSet.difference(['a', 1, null]),
        unorderedEquals(['b', 'c', 'c']),
      );
    });
    test('asMap', () {
      expect(firstSet.asMap(), {'a': 1, 'b': 1, 'c': 2});
      expect(secondSet.asMap(), {'a': 1, 'c': 1, 'd': 2});
    });
    test('asMap (unmodifiable)', () {
      final map = firstSet.asMap();
      expect(() => map['a'] = 2, throwsUnsupportedError);
      expect(() => map.remove('a'), throwsUnsupportedError);
      expect(() => map.clear(), throwsUnsupportedError);
    });
  });
}
