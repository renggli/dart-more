// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart' show group, test;

import 'test_utils.dart';

void main() {
  group('constructor', () {
    test('empty', () {
      final set = Multiset<String>();
      check(set).isEmpty();
      check(set.isEmpty).isTrue();
      check(set.isNotEmpty).isFalse();
      check(set).length.equals(0);
      check(set).unorderedEquals([]);
      check(set.entrySet).unorderedEquals([]);
      check(set.elementSet).unorderedEquals([]);
      check(set.elementCounts).unorderedEquals([]);
      check(set.distinct).unorderedEquals([]);
      check(set.counts).unorderedEquals([]);
    });
    test('empty identity', () {
      final set = Multiset<String>.identity();
      check(set).isEmpty();
      check(set).length.equals(0);
      check(set).unorderedEquals([]);
      check(set.entrySet).unorderedEquals([]);
      check(set.elementSet).unorderedEquals([]);
      check(set.elementCounts).unorderedEquals([]);
      check(set.distinct).unorderedEquals([]);
      check(set.counts).unorderedEquals([]);
    });
    test('of one unique', () {
      final set = Multiset.of(['a']);
      check(set).isNotEmpty();
      check(set.isEmpty).isFalse();
      check(set.isNotEmpty).isTrue();
      check(set).length.equals(1);
      check(set).unorderedEquals(['a']);
      check(set.entrySet).unorderedMatches([isMapEntry('a', 1)]);
      check(set.elementSet).unorderedEquals(['a']);
      check(set.elementCounts).unorderedEquals([1]);
      check(set.distinct).unorderedEquals(['a']);
      check(set.counts).unorderedEquals([1]);
    });
    test('of many unique', () {
      final set = Multiset.of(['a', 'b', 'c']);
      check(set).isNotEmpty();
      check(set).length.equals(3);
      check(set).unorderedEquals(['a', 'b', 'c']);
      check(set.entrySet).unorderedMatches([
        isMapEntry('a', 1),
        isMapEntry('b', 1),
        isMapEntry('c', 1),
      ]);
      check(set.elementSet).unorderedEquals(['a', 'b', 'c']);
      check(set.elementCounts).unorderedEquals([1, 1, 1]);
      check(set.distinct).unorderedEquals(['a', 'b', 'c']);
      check(set.counts).unorderedEquals([1, 1, 1]);
    });
    test('of one repeated', () {
      final set = Multiset.of(['a', 'a', 'a']);
      check(set).isNotEmpty();
      check(set).length.equals(3);
      check(set).unorderedEquals(['a', 'a', 'a']);
      check(set.entrySet).unorderedMatches([isMapEntry('a', 3)]);
      check(set.elementSet).unorderedEquals(['a']);
      check(set.elementCounts).unorderedEquals([3]);
      check(set.distinct).unorderedEquals(['a']);
      check(set.counts).unorderedEquals([3]);
    });
    test('of many repeated', () {
      final set = Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set).isNotEmpty();
      check(set).length.equals(6);
      check(set).unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set.entrySet).unorderedMatches([
        isMapEntry('a', 3),
        isMapEntry('b', 2),
        isMapEntry('c', 1),
      ]);
      check(set.elementSet).unorderedEquals(['a', 'b', 'c']);
      check(set.elementCounts).unorderedEquals([3, 2, 1]);
      check(set.distinct).unorderedEquals(['a', 'b', 'c']);
      check(set.counts).unorderedEquals([3, 2, 1]);
    });
    test('of set', () {
      final set = Multiset.of({'a', 'b', 'c'});
      check(set).isNotEmpty();
      check(set).length.equals(3);
      check(set).unorderedEquals(['a', 'b', 'c']);
      check(set.entrySet).unorderedMatches([
        isMapEntry('a', 1),
        isMapEntry('b', 1),
        isMapEntry('c', 1),
      ]);
      check(set.elementSet).unorderedEquals(['a', 'b', 'c']);
      check(set.elementCounts).unorderedEquals([1, 1, 1]);
      check(set.distinct).unorderedEquals(['a', 'b', 'c']);
      check(set.counts).unorderedEquals([1, 1, 1]);
    });
    test('from many repeated', () {
      final set = Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set).isNotEmpty();
      check(set).length.equals(6);
      check(set).unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set.entrySet).unorderedMatches([
        isMapEntry('a', 3),
        isMapEntry('b', 2),
        isMapEntry('c', 1),
      ]);
      check(set.elementSet).unorderedEquals(['a', 'b', 'c']);
      check(set.elementCounts).unorderedEquals([3, 2, 1]);
      check(set.distinct).unorderedEquals(['a', 'b', 'c']);
      check(set.counts).unorderedEquals([3, 2, 1]);
    });
    test('copy', () {
      final set = Multiset.of(Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']));
      check(set).isNotEmpty();
      check(set).length.equals(6);
      check(set).unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set.entrySet).unorderedMatches([
        isMapEntry('a', 3),
        isMapEntry('b', 2),
        isMapEntry('c', 1),
      ]);
      check(set.elementSet).unorderedEquals(['a', 'b', 'c']);
      check(set.elementCounts).unorderedEquals([3, 2, 1]);
      check(set.distinct).unorderedEquals(['a', 'b', 'c']);
      check(set.counts).unorderedEquals([3, 2, 1]);
    });
    test('generate', () {
      final set = Multiset<String>.fromIterable(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set).isNotEmpty();
      check(set).length.equals(6);
      check(set).unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set.entrySet).unorderedMatches([
        isMapEntry('a', 3),
        isMapEntry('b', 2),
        isMapEntry('c', 1),
      ]);
      check(set.elementSet).unorderedEquals(['a', 'b', 'c']);
      check(set.elementCounts).unorderedEquals([3, 2, 1]);
      check(set.distinct).unorderedEquals(['a', 'b', 'c']);
      check(set.counts).unorderedEquals([3, 2, 1]);
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
      check(set).isNotEmpty();
      check(set).length.equals(6);
      check(set).unorderedEquals([97, 97, 97, 98, 98, 99]);
      check(set.entrySet).unorderedMatches([
        isMapEntry(97, 3),
        isMapEntry(98, 2),
        isMapEntry(99, 1),
      ]);
      check(set.elementSet).unorderedEquals([97, 98, 99]);
      check(set.elementCounts).unorderedEquals([3, 2, 1]);
      check(set.distinct).unorderedEquals([97, 98, 99]);
      check(set.counts).unorderedEquals([3, 2, 1]);
    });
    test('generate with count', () {
      final set = Multiset.fromIterable(
        ['aaa', 'bb', 'c'],
        key: (e) => (e as String).substring(0, 1),
        count: (e) => (e as String).length,
      );
      check(set).isNotEmpty();
      check(set).length.equals(6);
      check(set).unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set.entrySet).unorderedMatches([
        isMapEntry('a', 3),
        isMapEntry('b', 2),
        isMapEntry('c', 1),
      ]);
      check(set.elementSet).unorderedEquals(['a', 'b', 'c']);
      check(set.elementCounts).unorderedEquals([3, 2, 1]);
      check(set.distinct).unorderedEquals(['a', 'b', 'c']);
      check(set.counts).unorderedEquals([3, 2, 1]);
    });
    test('convert', () {
      final set = ['a', 'a', 'a', 'b', 'b', 'c'].toMultiset();
      check(set).isNotEmpty();
      check(set).length.equals(6);
      check(set).unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']);
      check(set.entrySet).unorderedMatches([
        isMapEntry('a', 3),
        isMapEntry('b', 2),
        isMapEntry('c', 1),
      ]);
      check(set.elementSet).unorderedEquals(['a', 'b', 'c']);
      check(set.elementCounts).unorderedEquals([3, 2, 1]);
      check(set.distinct).unorderedEquals(['a', 'b', 'c']);
      check(set.counts).unorderedEquals([3, 2, 1]);
    });
  });
  group('adding', () {
    test('zero', () {
      final set = Multiset<String>()
        ..add('a', 0)
        ..add('b', 0);
      check(set).isEmpty();
      check(set).length.equals(0);
      check(set).unorderedEquals([]);
      check(set.entrySet).unorderedEquals([]);
      check(set.elementSet).unorderedEquals([]);
      check(set.elementCounts).unorderedEquals([]);
      check(set.distinct).unorderedEquals([]);
      check(set.counts).unorderedEquals([]);
    });
    test('single', () {
      final set = Multiset<String>()
        ..add('a')
        ..add('b')
        ..add('b');
      check(set).isNotEmpty();
      check(set).length.equals(3);
      check(set).unorderedEquals(['a', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 1), isMapEntry('b', 2)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([1, 2]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([1, 2]);
    });
    test('multiple', () {
      final set = Multiset<String>()
        ..add('a', 2)
        ..add('b', 3);
      check(set).isNotEmpty();
      check(set).length.equals(5);
      check(set).unorderedEquals(['a', 'a', 'b', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 2), isMapEntry('b', 3)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([2, 3]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([2, 3]);
    });
    test('all', () {
      final set = Multiset<String>()..addAll(['a', 'a', 'b', 'b', 'b']);
      check(set).isNotEmpty();
      check(set).length.equals(5);
      check(set).unorderedEquals(['a', 'a', 'b', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 2), isMapEntry('b', 3)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([3, 2]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([3, 2]);
    });
    test('error', () {
      final set = Multiset<String>();
      check(() => set.add('a', -1)).throws<ArgumentError>();
      check(set).isEmpty();
      check(set).length.equals(0);
      check(set).unorderedEquals([]);
      check(set.entrySet).unorderedEquals([]);
      check(set.elementSet).unorderedEquals([]);
      check(set.elementCounts).unorderedEquals([]);
      check(set.distinct).unorderedEquals([]);
      check(set.counts).unorderedEquals([]);
    });
  });
  group('removing', () {
    test('zero', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set
        ..remove('a', 0)
        ..remove('b', 0);
      check(set).isNotEmpty();
      check(set).length.equals(5);
      check(set).unorderedEquals(['a', 'a', 'b', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 2), isMapEntry('b', 3)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([2, 3]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([2, 3]);
    });
    test('single', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set
        ..remove('a')
        ..remove('b');
      check(set).isNotEmpty();
      check(set).length.equals(3);
      check(set).unorderedEquals(['a', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 1), isMapEntry('b', 2)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([1, 2]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([1, 2]);
    });
    test('multiple', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set
        ..remove('a', 3)
        ..remove('b', 2);
      check(set).isNotEmpty();
      check(set).length.equals(1);
      check(set).unorderedEquals(['b']);
      check(set.entrySet).unorderedMatches([isMapEntry('b', 1)]);
      check(set.elementSet).unorderedEquals(['b']);
      check(set.elementCounts).unorderedEquals([1]);
      check(set.distinct).unorderedEquals(['b']);
      check(set.counts).unorderedEquals([1]);
    });
    test('all', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set.removeAll(['a', 'b', 'b', 123, null]);
      check(set).isNotEmpty();
      check(set).length.equals(2);
      check(set).unorderedEquals(['a', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 1), isMapEntry('b', 1)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([1, 1]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([1, 1]);
    });
    test('clear', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set.clear();
      check(set).isEmpty();
      check(set).length.equals(0);
      check(set).unorderedEquals([]);
      check(set.entrySet).unorderedEquals([]);
      check(set.elementSet).unorderedEquals([]);
      check(set.elementCounts).unorderedEquals([]);
      check(set.distinct).unorderedEquals([]);
      check(set.counts).unorderedEquals([]);
    });
    test('invalid', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      check(() => set.remove('c')).returnsNormally();
      check(() => set.remove('z')).returnsNormally();
      check(set).isNotEmpty();
      check(set).length.equals(5);
      check(set).unorderedEquals(['a', 'a', 'b', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 2), isMapEntry('b', 3)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([2, 3]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([2, 3]);
    });
    test('error', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      check(() => set.remove('a', -1)).throws<ArgumentError>();
      check(set).isNotEmpty();
      check(set).length.equals(5);
      check(set).unorderedEquals(['a', 'a', 'b', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 2), isMapEntry('b', 3)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([2, 3]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([2, 3]);
    });
  });
  group('access', () {
    test('single', () {
      final set = Multiset<String>();
      set['a'] = 2;
      check(set['a']).equals(2);
      check(set).isNotEmpty();
      check(set).length.equals(2);
      check(set).unorderedEquals(['a', 'a']);
      check(set.entrySet).unorderedMatches([isMapEntry('a', 2)]);
      check(set.elementSet).unorderedEquals(['a']);
      check(set.elementCounts).unorderedEquals([2]);
      check(set.distinct).unorderedEquals(['a']);
      check(set.counts).unorderedEquals([2]);
    });
    test('multiple', () {
      final set = Multiset<String>();
      set['a'] = 2;
      set['b'] = 3;
      check(set['a']).equals(2);
      check(set['b']).equals(3);
      check(set).isNotEmpty();
      check(set).length.equals(5);
      check(set).unorderedEquals(['a', 'a', 'b', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 2), isMapEntry('b', 3)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([3, 2]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([3, 2]);
    });
    test('remove', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      set['b'] = 0;
      check(set).isNotEmpty();
      check(set).length.equals(2);
      check(set).unorderedEquals(['a', 'a']);
      check(set.entrySet).unorderedMatches([isMapEntry('a', 2)]);
      check(set.elementSet).unorderedEquals(['a']);
      check(set.elementCounts).unorderedEquals([2]);
      check(set.distinct).unorderedEquals(['a']);
      check(set.counts).unorderedEquals([2]);
    });
    test('error', () {
      final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
      check(() => set['a'] = -1).throws<ArgumentError>();
      check(set).isNotEmpty();
      check(set).length.equals(5);
      check(set).unorderedEquals(['a', 'a', 'b', 'b', 'b']);
      check(set.entrySet)
          .unorderedMatches([isMapEntry('a', 2), isMapEntry('b', 3)]);
      check(set.elementSet).unorderedEquals(['a', 'b']);
      check(set.elementCounts).unorderedEquals([2, 3]);
      check(set.distinct).unorderedEquals(['a', 'b']);
      check(set.counts).unorderedEquals([2, 3]);
    });
  });
  group('operator', () {
    final firstList = ['a', 'b', 'c', 'c'];
    final firstSet = Multiset.of(firstList);
    final secondList = ['a', 'c', 'd', 'd'];
    final secondSet = Multiset.of(secondList);
    test('contains', () {
      check(firstSet.contains('a')).isTrue();
      check(firstSet.contains('b')).isTrue();
      check(firstSet.contains('c')).isTrue();
      check(firstSet.contains('d')).isFalse();
    });
    test('containsAll', () {
      check(firstSet.containsAll(firstSet)).isTrue();
      check(firstSet.containsAll(secondSet)).isFalse();
      check(firstSet.containsAll(Multiset())).isTrue();
      check(firstSet.containsAll(Multiset.of(['a', 'b', 'b']))).isFalse();
      check(firstSet.containsAll(Multiset.of(['a', 'b', 'd']))).isFalse();
    });
    test('containsAll (iterable)', () {
      check(firstSet.containsAll(firstList)).isTrue();
      check(firstSet.containsAll(secondList)).isFalse();
      check(firstSet.containsAll([])).isTrue();
      check(firstSet.containsAll(['a'])).isTrue();
      check(firstSet.containsAll(['x'])).isFalse();
      check(firstSet.containsAll(['a', 'b', 'b'])).isFalse();
      check(firstSet.containsAll(['a', 'b', 'd'])).isFalse();
      check(firstSet.containsAll([1, 2])).isFalse();
      check(firstSet.containsAll(['a', null])).isFalse();
    });
    test('combine', () {
      check(firstSet.combine(secondSet, (_, a, b) => a + b))
          .unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']);
      check(firstSet.combine(secondSet, (_, a, b) => min(a, b)))
          .unorderedEquals(['a', 'c']);
      check(firstSet.combine(secondSet, (_, a, b) => max(0, a - b)))
          .unorderedEquals(['b', 'c']);
      check(firstSet.combine(secondSet, (_, a, b) => max(a - b, b - a)))
          .unorderedEquals(['b', 'c', 'd', 'd']);
    });
    test('combine (iterable)', () {
      check(firstSet.combine(secondList, (_, a, b) => a + b))
          .unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']);
      check(firstSet.combine(secondList, (_, a, b) => min(a, b)))
          .unorderedEquals(['a', 'c']);
      check(firstSet.combine(secondList, (_, a, b) => max(0, a - b)))
          .unorderedEquals(['b', 'c']);
      check(firstSet.combine(secondList, (_, a, b) => max(a - b, b - a)))
          .unorderedEquals(['b', 'c', 'd', 'd']);
    });
    test('intersection', () {
      check(firstSet.intersection(secondSet)).unorderedEquals(['a', 'c']);
      check(firstSet.intersection(secondSet).distinct)
          .unorderedEquals(['a', 'c']);
      check(secondSet.intersection(firstSet)).unorderedEquals(['a', 'c']);
      check(secondSet.intersection(firstSet).distinct)
          .unorderedEquals(['a', 'c']);
    });
    test('intersection (iterable)', () {
      check(firstSet.intersection(secondList)).unorderedEquals(['a', 'c']);
      check(secondSet.intersection(firstList)).unorderedEquals(['a', 'c']);
      check(firstSet.intersection(['a', 1, null])).unorderedEquals(['a']);
    });
    test('union', () {
      check(firstSet.union(secondSet))
          .unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']);
      check(firstSet.union(secondSet).distinct)
          .unorderedEquals(['a', 'b', 'c', 'd']);
      check(secondSet.union(firstSet))
          .unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']);
      check(secondSet.union(firstSet).distinct)
          .unorderedEquals(['a', 'b', 'c', 'd']);
    });
    test('union (iterable)', () {
      check(firstSet.union(secondList))
          .unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']);
      check(secondSet.union(firstList))
          .unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']);
    });
    test('difference', () {
      check(firstSet.difference(secondSet)).unorderedEquals(['b', 'c']);
      check(firstSet.difference(secondSet).distinct)
          .unorderedEquals(['b', 'c']);
      check(secondSet.difference(firstSet)).unorderedEquals(['d', 'd']);
      check(secondSet.difference(firstSet).distinct).unorderedEquals(['d']);
    });
    test('difference (iterable)', () {
      check(firstSet.difference(secondList)).unorderedEquals(['b', 'c']);
      check(secondSet.difference(firstList)).unorderedEquals(['d', 'd']);
      check(firstSet.difference(['a', 1, null]))
          .unorderedEquals(['b', 'c', 'c']);
    });
    test('asMap', () {
      check(firstSet.asMap()).deepEquals({'a': 1, 'b': 1, 'c': 2});
      check(secondSet.asMap()).deepEquals({'a': 1, 'c': 1, 'd': 2});
    });
    test('asMap (unmodifiable)', () {
      final map = firstSet.asMap();
      check(() => map['a'] = 2).throws<UnsupportedError>();
      check(() => map.remove('a')).throws<UnsupportedError>();
      check(() => map.clear()).throws<UnsupportedError>();
    });
  });
}
