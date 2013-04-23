// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_set_test;

import 'package:unittest/unittest.dart';
import 'package:more/bit_set.dart';

void main() {
  group('bit set', () {
    test('basic properties of empty set', () {
      var set = new BitSet(0);
      expect(set.isEmpty, isTrue);
      expect(set.length, 0);
    });
    test('basic properties of one element set', () {
      var set = new BitSet(1);
      expect(set.isEmpty, isFalse);
      expect(set.length, 1);
      expect(set[0], isFalse);
    });
    for (var step = 1; step <= 20; step++) {
      test('setting ${step}th element works', () {
        var set = new BitSet(100);
        for (var i = 0; i < set.length; i += step) {
          set[i] = true;
        }
        for (var i = 0; i < set.length; i++) {
          expect(set[i], i % step == 0);
        }
      });
    }
    test('out of bounds reading throws exception', () {
      var set = new BitSet(10);
      expect(() => set[-1], throwsRangeError);
      expect(() => set[10], throwsRangeError);
    });
    test('out of bounds writing throws exception', () {
      var set = new BitSet(10);
      expect(() => set[-1] = true, throwsRangeError);
      expect(() => set[10] = true, throwsRangeError);
    });
  });
}

