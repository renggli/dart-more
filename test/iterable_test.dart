// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library iterable_test;

import 'package:unittest/unittest.dart';
import 'package:more/iterable.dart';

void main() {
  group('iterable', () {
    test('empty', () {
      expect(range(0, 0), []);
      expect(range(1, 1), []);
      expect(range(2, 2, step: 1), []);
      expect(range(3, 3, step: -1), []);
    });
    test('one', () {
      expect(range(0, 1), [0]);
      expect(range(1, 0), [1]);
      expect(range(2, 3, step: 1), [2]);
      expect(range(3, 2, step: -1), [3]);
    });
  });

}

