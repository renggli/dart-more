library multiset_test;

import 'package:unittest/unittest.dart';
import 'package:more/multiset.dart';

void main() {
  group('multiset', () {
    group('construct', () {
      test('empty', () {
        var set = new Multiset();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
      });
      test('one unique', () {
        var set = new Multiset.from(['a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['a']));
        expect(set.distinct, unorderedEquals(['a']));
      });
      test('many unique', () {
        var set = new Multiset.from(['a', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      });
      test('one repeated', () {
        var set = new Multiset.from(['a', 'a', 'a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
      });
      test('many repeated', () {
        var set = new Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      });
      test('copy', () {
        var set = new Multiset.from(new Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      });
      test('generate', () {
        var set = new Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      });
      test('generate with key', () {
        var set = new Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c'],
            key: (String e) => e.codeUnitAt(0));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals([97, 97, 97, 98, 98, 99]));
        expect(set.distinct, unorderedEquals([97, 98, 99]));
      });
      test('generate with count', () {
        var set = new Multiset.fromIterable(['aaa', 'bb', 'c'],
            key: (String e) => e.substring(0, 1),
            count: (String e) => e.length);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
      });
    });
    group('adding', () {
      test('zero', () {
        var set = new Multiset();
        set..add('a', 0)..add('b', 0);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
      });
      test('single', () {
        var set = new Multiset();
        set..add('a')..add('b')..add('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
      test('multiple', () {
        var set = new Multiset();
        set..add('a', 2)..add('b', 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
      test('all', () {
        var set = new Multiset();
        set.addAll(['a', 'a', 'b', 'b', 'b']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
      test('error', () {
        var set = new Multiset();
        expect(() => set.add('a', -1), throwsArgumentError);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
      });
    });
    group('remvoing', () {
      test('zero', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set..remove('a', 0)..remove('b', 0);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
      test('single', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set..remove('a')..remove('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
      test('multiple', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set..remove('a', 3)..remove('b', 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['b']));
        expect(set.distinct, unorderedEquals(['b']));
      });
      test('all', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set.removeAll(['a', 'b', 'b']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
      test('clear', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set.clear();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
      });
      test('invalid', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('c'), returnsNormally);
        expect(() => set.remove(false), returnsNormally);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
      test('error', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('a', -1), throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
    });
    group('access', () {
      test('single', () {
        var set = new Multiset();
        set['a'] = 2;
        expect(set['a'], 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
      });
      test('multiple', () {
        var set = new Multiset();
        set['a'] = 2;
        set['b'] = 3;
        expect(set['a'], 2);
        expect(set['b'], 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
      test('remove', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        set['b'] = 0;
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
      });
      test('error', () {
        var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
        expect(() => set['a'] = -1, throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
      });
    });
    group('operator', () {
      var first_list = ['a', 'b', 'c', 'c'];
      var first_set = new Multiset.from(first_list);
      var second_list = ['a', 'c', 'd', 'd'];
      var second_set = new Multiset.from(second_list);
      test('contains', () {
        expect(first_set.contains('a'), isTrue);
        expect(first_set.contains('b'), isTrue);
        expect(first_set.contains('c'), isTrue);
        expect(first_set.contains('d'), isFalse);
      });
      test('containsAll', () {
        expect(first_set.containsAll(first_set), isTrue);
        expect(first_set.containsAll(second_set), isFalse);
        expect(first_set.containsAll(new Multiset()), isTrue);
        expect(first_set.containsAll(new Multiset.from(['a', 'b', 'b'])), isFalse);
        expect(first_set.containsAll(new Multiset.from(['a', 'b', 'd'])), isFalse);
      });
      test('containsAll (iterable)', () {
        expect(first_set.containsAll(first_list), isTrue);
        expect(first_set.containsAll(second_list), isFalse);
        expect(first_set.containsAll([]), isTrue);
        expect(first_set.containsAll(['a', 'b', 'b']), isFalse);
        expect(first_set.containsAll(['a', 'b', 'd']), isFalse);
      });
      test('intersection', () {
        expect(first_set.intersection(second_set), unorderedEquals(['a', 'c']));
        expect(first_set.intersection(second_set).distinct, unorderedEquals(['a', 'c']));
        expect(second_set.intersection(first_set), unorderedEquals(['a', 'c']));
        expect(second_set.intersection(first_set).distinct, unorderedEquals(['a', 'c']));
      });
      test('intersection (iterable)', () {
        expect(first_set.intersection(second_list), unorderedEquals(['a', 'c']));
        expect(second_set.intersection(first_list), unorderedEquals(['a', 'c']));
      });
      test('union', () {
        expect(first_set.union(second_set), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(first_set.union(second_set).distinct, unorderedEquals(['a', 'b', 'c', 'd']));
        expect(second_set.union(first_set), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(second_set.union(first_set).distinct, unorderedEquals(['a', 'b', 'c', 'd']));
      });
      test('union (iterable)', () {
        expect(first_set.union(second_list), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(second_set.union(first_list), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
      });
      test('difference', () {
        expect(first_set.difference(second_set), unorderedEquals(['b', 'c']));
        expect(first_set.difference(second_set).distinct, unorderedEquals(['b', 'c']));
        expect(second_set.difference(first_set), unorderedEquals(['d', 'd']));
        expect(second_set.difference(first_set).distinct, unorderedEquals(['d']));
      });
      test('difference (iterable)', () {
        expect(first_set.difference(second_list), unorderedEquals(['b', 'c']));
        expect(second_set.difference(first_list), unorderedEquals(['d', 'd']));
      });
    });
  });
}
