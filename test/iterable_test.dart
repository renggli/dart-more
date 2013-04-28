// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library iterable_test;

import 'package:unittest/unittest.dart';
import 'package:more/iterable.dart';

void main() {
  group('iterable', () {
    test('fib', () {
      expect(fib(0, 1).take(8), [0, 1, 1, 2, 3, 5, 8, 13]);
      expect(fib(1, 1).take(8), [1, 1, 2, 3, 5, 8, 13, 21]);
      expect(fib(1, 0).take(8), [1, 0, 1, 1, 2, 3, 5, 8]);
    });
  });

}

