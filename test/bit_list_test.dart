// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_list_test;

import 'package:unittest/unittest.dart';
import 'package:more/bit_list.dart';

void main() {
  group('bit set', () {
    test('basic properties of empty set', () {
      var set = new BitList(0);
      expect(set.isEmpty, isTrue);
      expect(set.length, 0);
    });
    test('basic properties of one element set', () {
      var set = new BitList(1);
      expect(set.isEmpty, isFalse);
      expect(set.length, 1);
      expect(set[0], isFalse);
      set[0] = true;
      expect(set[0], isTrue);
    });
    for (var step = 1; step <= 24; step++) {
      test('setting ${step}th element works', () {
        var set = new BitList(100);
        for (var i = 0; i < set.length; i += step) {
          set[i] = true;
        }
        for (var i = 0; i < set.length; i++) {
          expect(set[i], i % step == 0);
        }
      });
    }
    test('out of bounds reading throws exception', () {
      var set = new BitList(10);
      expect(() => set[-1], throwsRangeError);
      expect(() => set[10], throwsRangeError);
    });
    test('out of bounds writing throws exception', () {
      var set = new BitList(10);
      expect(() => set[-1] = true, throwsRangeError);
      expect(() => set[10] = true, throwsRangeError);
    });
  });
}

