// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_set_test;

import 'dart:math';
import 'package:unittest/unittest.dart';
import 'package:more/bit_set.dart';

List<bool> randomList(int seed, int length) {
  var list = new List();
  var generator = new Random(seed);
  for (var i = 0; i < length; i++) {
    list.add(generator.nextBool());
  }
  return list;
}

void main() {
  group('bit list', () {
    test('empty list', () {
      var list = new BitSet(0);
      expect(list, isEmpty);
      expect(list, []);
    });
    test('tiny list', () {
      var list = new BitSet(1);
      expect(list, isNot(isEmpty));
      expect(list, [false]);
      list[0] = true;
      expect(list, [true]);
      list[0] = false;
      expect(list, [false]);
    });
    test('long list', () {
      var target = new BitSet(100);
      for (var i = 0; i < 100; i++) {
        var source = randomList(i, target.length);
        for (var j = 0; j < source.length; j++) {
          target[j] = source[j];
        }
        for (var j = 0; j < source.length; j++) {
          expect(source[j], target[j]);
        }
      }
    });
    test('list conversion', () {
      for (var len = 0; len < 100; len++) {
        var source = randomList(len, len);
        var target = new BitSet.fromList(source);
        expect(source, target);
        expect(source, target.toList());
        expect(source, new BitSet.fromList(target));
      }
    });
    test('reading bounds', () {
      for (var i = 0; i <= 24; i++) {
        var list = new BitSet(i);
        expect(() => list[-1], throwsRangeError);
        for (var j = 0; j < i; j++) {
          expect(() => list[j], returnsNormally);
        }
        expect(() => list[i], throwsRangeError);
      }
    });
    test('writing bounds', () {
      for (var i = 0; i <= 24; i++) {
        var list = new BitSet(i);
        expect(() => list[-1] = true, throwsRangeError);
        for (var j = 0; j < i; j++) {
          expect(() => list[j] = true, returnsNormally);
        }
        expect(() => list[i] = true, throwsRangeError);
      }
    });
    test('logical negation', () {
      var source = new BitSet.fromList(randomList(702, 100));
      var target = ~source;
      for (var i = 0; i < target.length; i++) {
        expect(target[i], !source[i]);
      }
    });
    test('logical and', () {
      var source1 = new BitSet.fromList(randomList(439, 100));
      var source2 = new BitSet.fromList(randomList(902, 100));
      var target = source1 & source2;
      for (var i = 0; i < target.length; i++) {
        expect(target[i], source1[i] && source2[i]);
      }
      expect(target, source2 & source1);
    });
    test('logical or', () {
      var source1 = new BitSet.fromList(randomList(817, 100));
      var source2 = new BitSet.fromList(randomList(858, 100));
      var target = source1 | source2;
      for (var i = 0; i < target.length; i++) {
        expect(target[i], source1[i] || source2[i]);
      }
      expect(target, source2 | source1);
    });
  });
}

