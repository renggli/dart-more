// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

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
      test('intersection', () {
        var first = new Multiset.from(['a', 'b', 'c', 'c']);
        var second = new Multiset.from(['a', 'c', 'd', 'd']);
        expect(first.intersection(second), unorderedEquals(['a', 'c']));
        expect(first.intersection(second).distinct, unorderedEquals(['a', 'c']));
        expect(second.intersection(first), unorderedEquals(['a', 'c']));
        expect(second.intersection(first).distinct, unorderedEquals(['a', 'c']));
      });
      test('union', () {
        var first = new Multiset.from(['a', 'b', 'c', 'c']);
        var second = new Multiset.from(['a', 'c', 'd', 'd']);
        expect(first.union(second), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(first.union(second).distinct, unorderedEquals(['a', 'b', 'c', 'd']));
        expect(second.union(first), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(second.union(first).distinct, unorderedEquals(['a', 'b', 'c', 'd']));
      });
      test('difference', () {
        var first = new Multiset.from(['a', 'b', 'c', 'c']);
        var second = new Multiset.from(['a', 'c', 'd', 'd']);
        expect(first.difference(second), unorderedEquals(['b', 'c']));
        expect(first.difference(second).distinct, unorderedEquals(['b', 'c']));
        expect(second.difference(first), unorderedEquals(['d', 'd']));
        expect(second.difference(first).distinct, unorderedEquals(['d']));
      });
    });
  });
}