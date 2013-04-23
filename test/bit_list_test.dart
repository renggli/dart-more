// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_list_test;

import 'package:unittest/unittest.dart';
import 'package:more/bit_list.dart';

void main() {
  group('bit list', () {
    test('empty list', () {
      var list = new BitList(0);
      expect(list, isEmpty);
    });
    test('basic list', () {
      var list = new BitList(1);
      expect(list, isNot(isEmpty));
      expect(list[0], isFalse);
      list[0] = true;
      expect(list[0], isTrue);
      list[0] = false;
      expect(list[0], isFalse);
    });
    test('long list', () {
      for (var step = 1; step < 25; step++) {
        var list = new BitList(100);
        for (var i = 0; i < list.length; i += step) {
          list[i] = true;
        }
        for (var i = 0; i < list.length; i++) {
          expect(list[i], i % step == 0);
        }
      }
    });
    test('list conversion', () {
      var source = [false, true, false, true, false, true, false, true, true];
      var target = new BitList.fromList(source);
      expect(source, target);
      expect(source, target.toList());
    });
    test('bounds reading', () {
      for (var i = 0; i <= 24; i++) {
        var list = new BitList(i);
        expect(() => list[-1], throwsRangeError);
        for (var j = 0; j < i; j++) {
          expect(() => list[j], returnsNormally);
        }
        expect(() => list[i], throwsRangeError);
      }
    });
    test('bounds writing', () {
      for (var i = 0; i <= 24; i++) {
        var list = new BitList(i);
        expect(() => list[-1] = true, throwsRangeError);
        for (var j = 0; j < i; j++) {
          expect(() => list[j] = true, returnsNormally);
        }
        expect(() => list[i] = true, throwsRangeError);
      }
    });
  });
}

