library range_test;

import 'package:unittest/unittest.dart';
import 'package:more/range.dart';

void main() {
  group('range', () {
    test('no argument constructor', () {
      expect(range(), []);
    });
    test('1 argument constructor', () {
      expect(range(0), []);
      expect(range(1), [0]);
      expect(range(2), [0, 1]);
      expect(range(3), [0, 1, 2]);
    });
    test('2 argument constructor', () {
      expect(range(0, 4), [0, 1, 2, 3]);
      expect(range(5, 9), [5, 6, 7, 8]);
    });
    test('3 argument constructor', () {
      expect(range(2, 8, 2), [2, 4, 6]);
      expect(range(3, 8, 2), [3, 5, 7]);
      expect(range(4, 8, 2), [4, 6]);
      expect(range(2, 7, 2), [2, 4, 6]);
      expect(range(2, 6, 2), [2, 4]);
    });
    test('3 argument constructor (negative step)', () {
      expect(range(8, 2, -2), [8, 6, 4]);
      expect(range(8, 3, -2), [8, 6, 4]);
      expect(range(8, 4, -2), [8, 6]);
      expect(range(7, 2, -2), [7, 5, 3]);
      expect(range(6, 2, -2), [6, 4]);
    });
    test('printing', () {
      expect(range().toString(), 'range()');
      expect(range(1).toString(), 'range(1)');
      expect(range(1, 2).toString(), 'range(1, 2)');
      expect(range(1, 5, 2).toString(), 'range(1, 5, 2)');
    });
    test('double range', () {
      expect(range(1.5, 4.0), [1.5, 2.5, 3.5]);
      expect(range(1.5, 1.8, 0.1), [1.5, 1.6, 1.7]);
      expect(range(1.5, 1.8, 0.2), [1.5, 1.7]);
    });
    test('unmodifiable', () {
      var list = range(1, 5);
      expect(() => list[0] = 5, throwsUnsupportedError);
      expect(() => list.add(5), throwsUnsupportedError);
      expect(() => list.addAll([5, 6]), throwsUnsupportedError);
      expect(() => list.clear(), throwsUnsupportedError);
      expect(() => list.fillRange(2, 4, 5), throwsUnsupportedError);
      expect(() => list.insert(2, 5), throwsUnsupportedError);
      expect(() => list.insertAll(2, [5, 6]), throwsUnsupportedError);
      expect(() => list.length = 10, throwsUnsupportedError);
      expect(() => list.remove(5), throwsUnsupportedError);
      expect(() => list.removeAt(2), throwsUnsupportedError);
      expect(() => list.removeLast(), throwsUnsupportedError);
      expect(() => list.removeRange(2, 4), throwsUnsupportedError);
      expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
      expect(() => list.replaceRange(2, 4, [5, 6]), throwsUnsupportedError);
      expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
      expect(() => list.setAll(2, [5, 6]), throwsUnsupportedError);
      expect(() => list.setRange(2, 4, [5, 6]), throwsUnsupportedError);
      expect(() => list.sort(), throwsUnsupportedError);
    });
  });
}
