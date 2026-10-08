import 'dart:math';

import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('construction', () {
    test('default', () {
      final list = OrderedList<int>();
      expect(list, isEmpty);
      expect(list.length, 0);
      expect(list.isGrowable, isTrue);
    });
    test('of', () {
      final list = OrderedList<int>.of([1, 2, 3]);
      expect(list, [1, 2, 3]);
      expect(list.length, 3);
    });
    test('filled', () {
      final list = OrderedList<int>.filled(5, 42);
      expect(list, [42, 42, 42, 42, 42]);
      expect(list.length, 5);
      expect(list.isGrowable, isFalse);
    });
    test('converter', () {
      final list = [1, 2, 3].toOrderedList();
      expect(list, [1, 2, 3]);
    });
  });
  group('accessors', () {
    test('reading and writing', () {
      final list = OrderedList<int>.of([10, 20, 30]);
      expect(list[0], 10);
      expect(list[1], 20);
      expect(list[2], 30);
      list[1] = 99;
      expect(list[1], 99);
      expect(list, [10, 99, 30]);
    });
    test('out of bounds', () {
      final list = OrderedList<int>.of([1, 2]);
      expect(() => list[-1], throwsRangeError);
      expect(() => list[2], throwsRangeError);
      expect(() => list[-1] = 0, throwsRangeError);
      expect(() => list[2] = 0, throwsRangeError);
    });
    test('first and last', () {
      final list = OrderedList<int>();
      expect(() => list.first, throwsStateError);
      expect(() => list.last, throwsStateError);
      list.add(1);
      expect(list.first, 1);
      expect(list.last, 1);
      list.add(2);
      expect(list.first, 1);
      expect(list.last, 2);
    });
  });
  group('double-ended operations', () {
    test('addFirst and removeFirst', () {
      final list = OrderedList<int>();
      list.addFirst(1);
      list.addFirst(2);
      list.addFirst(3);
      expect(list, [3, 2, 1]);
      expect(list.removeFirst(), 3);
      expect(list.removeFirst(), 2);
      expect(list.removeFirst(), 1);
      expect(list, isEmpty);
      expect(list.removeFirst, throwsStateError);
    });
    test('addLast and removeLast', () {
      final list = OrderedList<int>();
      list.addLast(1);
      list.addLast(2);
      list.addLast(3);
      expect(list, [1, 2, 3]);
      expect(list.removeLast(), 3);
      expect(list.removeLast(), 2);
      expect(list.removeLast(), 1);
      expect(list, isEmpty);
      expect(list.removeLast, throwsStateError);
    });
    test('interleaved operations wrapping around buffer', () {
      final list = OrderedList<int>();
      for (var i = 0; i < 50; i++) {
        list.addLast(i);
        list.addFirst(-i);
      }
      expect(list.length, 100);
      for (var i = 49; i >= 0; i--) {
        expect(list.removeFirst(), -i);
      }
      for (var i = 0; i < 50; i++) {
        expect(list.removeFirst(), i);
      }
      expect(list, isEmpty);
    });
  });
  group('insert and removeAt', () {
    test('insert at head, tail, and middle', () {
      final list = OrderedList<int>.of([2, 4]);
      list.insert(0, 1);
      list.insert(2, 3);
      list.insert(4, 5);
      expect(list, [1, 2, 3, 4, 5]);
    });
    test('removeAt head, tail, and middle', () {
      final list = OrderedList<int>.of([1, 2, 3, 4, 5]);
      expect(list.removeAt(0), 1);
      expect(list.removeAt(3), 5);
      expect(list.removeAt(1), 3);
      expect(list, [2, 4]);
    });
  });
  group('collection operations', () {
    test('contains and remove', () {
      final list = OrderedList<int>.of([10, 20, 30]);
      expect(list.contains(20), isTrue);
      expect(list.contains(40), isFalse);
      expect(list.remove(20), isTrue);
      expect(list, [10, 30]);
      expect(list.remove(20), isFalse);
    });
    test('clear and removeAll', () {
      final list = OrderedList<int>.of([1, 2, 3]);
      expect(list.removeAll(), [1, 2, 3]);
      expect(list, isEmpty);
      list.addAll([4, 5]);
      expect(list, [4, 5]);
      list.clear();
      expect(list, isEmpty);
    });
    test('unorderedElements and toUnorderedList', () {
      final list = OrderedList<int>.of([3, 1, 2]);
      expect(list.unorderedElements, [3, 1, 2]);
      expect(list.toUnorderedList(), [3, 1, 2]);
    });
  });
  group('fixed length', () {
    test('unsupported modifications', () {
      final list = OrderedList<int>.of([1, 2], growable: false);
      expect(() => list.add(3), throwsUnsupportedError);
      expect(() => list.addFirst(0), throwsUnsupportedError);
      expect(() => list.addLast(3), throwsUnsupportedError);
      expect(() => list.insert(1, 99), throwsUnsupportedError);
      expect(() => list.remove(1), throwsUnsupportedError);
      expect(() => list.removeAt(0), throwsUnsupportedError);
      expect(list.removeFirst, throwsUnsupportedError);
      expect(list.removeLast, throwsUnsupportedError);
      expect(list.clear, throwsUnsupportedError);
    });
  });
  group('stress', () {
    test('random operations compared against Dart List', () {
      final random = Random(42);
      final model = <int>[];
      final actual = OrderedList<int>();
      for (var step = 0; step < 1000; step++) {
        final op = random.nextInt(6);
        final value = random.nextInt(100);
        switch (op) {
          case 0: // addFirst
            model.insert(0, value);
            actual.addFirst(value);
          case 1: // addLast
            model.add(value);
            actual.addLast(value);
          case 2: // removeFirst
            if (model.isNotEmpty) {
              expect(actual.removeFirst(), model.removeAt(0));
            }
          case 3: // removeLast
            if (model.isNotEmpty) {
              expect(actual.removeLast(), model.removeLast());
            }
          case 4: // insert
            final index = model.isEmpty ? 0 : random.nextInt(model.length + 1);
            model.insert(index, value);
            actual.insert(index, value);
          case 5: // removeAt
            if (model.isNotEmpty) {
              final index = random.nextInt(model.length);
              expect(actual.removeAt(index), model.removeAt(index));
            }
        }
        expect(actual.length, model.length);
        if (model.isNotEmpty) {
          final probe = random.nextInt(model.length);
          expect(actual[probe], model[probe]);
        }
      }
      expect(actual, model);
    });
  });
}
