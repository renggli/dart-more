// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library iterable_test;

import 'package:unittest/unittest.dart';
import 'package:more/iterable.dart';

void main() {
  group('iterable', () {
    test('fibonacci', () {
      expect(fibonacci(0, 1).take(8), [0, 1, 1, 2, 3, 5, 8, 13]);
      expect(fibonacci(1, 1).take(8), [1, 1, 2, 3, 5, 8, 13, 21]);
      expect(fibonacci(1, 0).take(8), [1, 0, 1, 1, 2, 3, 5, 8]);
    });
    test('permutations', () {
      expect(permutations([0, 1, 2]),
          [[0, 1, 2], [0, 2, 1], [1, 0, 2],
           [1, 2, 0], [2, 0, 1], [2, 1, 0]]);
    });
    test('permutations (reverse)', () {
      expect(permutations([2, 1, 0], (a, b) => b - a),
          [[2, 1, 0], [2, 0, 1], [1, 2, 0],
           [1, 0, 2], [0, 2, 1], [0, 1, 2]]);
    });
    test('string', () {
      expect(string('').toList(), []);
      expect(string('a').toList(), ['a']);
      expect(string('ab').toList(), ['a', 'b']);
      expect(string('aA1! ').toList(), ['a', 'A', '1', '!', ' ']);
    });
    test('string (mutable)', () {
      List<String> mutable = mutableString('abc');
      expect(mutable.length, 3);
      expect(mutable.toString(), 'abc');
      expect(mutable[1], 'b');
      mutable[1] = 'd';
      expect(mutable[1], 'd');
      expect(mutable.toString(), 'adc');
      mutable.add('e');
      expect(mutable.toString(), 'adce');
      mutable.remove('a');
      expect(mutable.toString(), 'dce');
      expect(mutable.toList(), ['d', 'c', 'e']);
    });
    test('digits', () {
      expect(digits(0).toList(), [0]);
      expect(digits(1).toList(), [1]);
      expect(digits(12).toList(), [2, 1]);
      expect(digits(123).toList(), [3, 2, 1]);
      expect(digits(1001).toList(), [1, 0, 0, 1]);
      expect(digits(10001).toList(), [1, 0, 0, 0, 1]);
      expect(digits(1000).toList(), [0, 0, 0, 1]);
      expect(digits(10000).toList(), [0, 0, 0, 0, 1]);
    });
    test('digits (base 2)', () {
      expect(digits(0, 2).toList(), [0]);
      expect(digits(1, 2).toList(), [1]);
      expect(digits(12, 2).toList(), [0, 0, 1, 1]);
      expect(digits(123, 2).toList(), [1, 1, 0, 1, 1, 1, 1]);
      expect(digits(1001, 2).toList(), [1, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10001, 2).toList(), [1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
      expect(digits(1000, 2).toList(), [0, 0, 0, 1, 0, 1, 1, 1, 1, 1]);
      expect(digits(10000, 2).toList(), [0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 1]);
    });
    test('digits (base 16)', () {
      expect(digits(0, 16).toList(), [0]);
      expect(digits(1, 16).toList(), [1]);
      expect(digits(12, 16).toList(), [12]);
      expect(digits(123, 16).toList(), [11, 7]);
      expect(digits(1001, 16).toList(), [9, 14, 3]);
      expect(digits(10001, 16).toList(), [1, 1, 7, 2]);
      expect(digits(1000, 16).toList(), [8, 14, 3]);
      expect(digits(10000, 16).toList(), [0, 1, 7, 2]);
    });
  });
}

