import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart' show group, test;

void main() {
  group('construction', () {
    test('default', () {
      final list = OrderedList<int>();
      check(list).isEmpty();
      check(list.length).equals(0);
      check(list.isGrowable).isTrue();
    });
    test('of', () {
      final list = OrderedList<int>.of([1, 2, 3]);
      check(list).deepEquals([1, 2, 3]);
      check(list.length).equals(3);
    });
    test('filled', () {
      final list = OrderedList<int>.filled(5, 42);
      check(list).deepEquals([42, 42, 42, 42, 42]);
      check(list.length).equals(5);
      check(list.isGrowable).isFalse();
    });
    test('converter', () {
      final list = [1, 2, 3].toOrderedList();
      check(list).deepEquals([1, 2, 3]);
    });
  });
  group('accessors', () {
    test('reading and writing', () {
      final list = OrderedList<int>.of([10, 20, 30]);
      check(list[0]).equals(10);
      check(list[1]).equals(20);
      check(list[2]).equals(30);
      list[1] = 99;
      check(list[1]).equals(99);
      check(list).deepEquals([10, 99, 30]);
    });
    test('out of bounds', () {
      final list = OrderedList<int>.of([1, 2]);
      check(() => list[-1]).throws<RangeError>();
      check(() => list[2]).throws<RangeError>();
      check(() => list[-1] = 0).throws<RangeError>();
      check(() => list[2] = 0).throws<RangeError>();
    });
    test('first and last', () {
      final list = OrderedList<int>();
      check(() => list.first).throws<StateError>();
      check(() => list.last).throws<StateError>();
      list.add(1);
      check(list.first).equals(1);
      check(list.last).equals(1);
      list.add(2);
      check(list.first).equals(1);
      check(list.last).equals(2);
    });
  });
  group('double-ended operations', () {
    test('addFirst and removeFirst', () {
      final list = OrderedList<int>();
      list.addFirst(1);
      list.addFirst(2);
      list.addFirst(3);
      check(list).deepEquals([3, 2, 1]);
      check(list.removeFirst()).equals(3);
      check(list.removeFirst()).equals(2);
      check(list.removeFirst()).equals(1);
      check(list).isEmpty();
      check(list.removeFirst).throws<StateError>();
    });
    test('addLast and removeLast', () {
      final list = OrderedList<int>();
      list.addLast(1);
      list.addLast(2);
      list.addLast(3);
      check(list).deepEquals([1, 2, 3]);
      check(list.removeLast()).equals(3);
      check(list.removeLast()).equals(2);
      check(list.removeLast()).equals(1);
      check(list).isEmpty();
      check(list.removeLast).throws<StateError>();
    });
    test('interleaved operations wrapping around buffer', () {
      final list = OrderedList<int>();
      for (var i = 0; i < 50; i++) {
        list.addLast(i);
        list.addFirst(-i);
      }
      check(list.length).equals(100);
      for (var i = 49; i >= 0; i--) {
        check(list.removeFirst()).equals(-i);
      }
      for (var i = 0; i < 50; i++) {
        check(list.removeFirst()).equals(i);
      }
      check(list).isEmpty();
    });
  });
  group('insert and removeAt', () {
    test('insert at head, tail, and middle', () {
      final list = OrderedList<int>.of([2, 4]);
      list.insert(0, 1);
      list.insert(2, 3);
      list.insert(4, 5);
      check(list).deepEquals([1, 2, 3, 4, 5]);
    });
    test('insertAll', () {
      final list = OrderedList<int>.of([1, 4]);
      list.insertAll(1, [2, 3]);
      check(list).deepEquals([1, 2, 3, 4]);
      list.insertAll(0, [0]);
      check(list).deepEquals([0, 1, 2, 3, 4]);
      list.insertAll(5, [5]);
      check(list).deepEquals([0, 1, 2, 3, 4, 5]);
    });
    test('removeAt head, tail, and middle', () {
      final list = OrderedList<int>.of([1, 2, 3, 4, 5]);
      check(list.removeAt(0)).equals(1);
      check(list.removeAt(3)).equals(5);
      check(list.removeAt(1)).equals(3);
      check(list).deepEquals([2, 4]);
    });
    test('removeRange', () {
      final list = OrderedList<int>.of([1, 2, 3, 4, 5]);
      list.removeRange(0, 2);
      check(list).deepEquals([3, 4, 5]);
      list.removeRange(2, 3);
      check(list).deepEquals([3, 4]);
      list.addAll([5, 6]);
      list.removeRange(1, 3);
      check(list).deepEquals([3, 6]);
    });
  });
  group('circular buffer properties', () {
    test('startIndex and endIndex tracking', () {
      final list = OrderedList<int>();
      check(list.startIndex).equals(0);
      check(list.endIndex).equals(0);
      list.addLast(1);
      check(list.startIndex).equals(0);
      check(list.endIndex).equals(1);
      list.addFirst(0);
      check(list.startIndex).equals(7);
      check(list.endIndex).equals(1);
      check(list.length).equals(2);
    });
    test('of from single-pass generator', () {
      Iterable<int> generator() sync* {
        yield 10;
        yield 20;
        yield 30;
      }

      final list = OrderedList<int>.of(generator());
      check(list).deepEquals([10, 20, 30]);
    });
    test('enlarge non-nullable list throws', () {
      final list = OrderedList<int>();
      check(() => list.length = 5).throws<UnsupportedError>();
    });
  });
  group('collection operations', () {
    test('contains and remove', () {
      final list = OrderedList<int>.of([10, 20, 30]);
      check(list.contains(20)).isTrue();
      check(list.contains(40)).isFalse();
      check(list.remove(20)).isTrue();
      check(list).deepEquals([10, 30]);
      check(list.remove(20)).isFalse();
    });
    test('clear and removeAll', () {
      final list = OrderedList<int>.of([1, 2, 3]);
      check(list.removeAll()).deepEquals([1, 2, 3]);
      check(list).isEmpty();
      list.addAll([4, 5]);
      check(list).deepEquals([4, 5]);
      list.clear();
      check(list).isEmpty();
    });
    test('unorderedElements and toUnorderedList', () {
      final list = OrderedList<int>.of([3, 1, 2]);
      check(list.unorderedElements).deepEquals([3, 1, 2]);
      check(list.toUnorderedList()).deepEquals([3, 1, 2]);
    });
  });
  group('fixed length', () {
    test('unsupported modifications', () {
      final list = OrderedList<int>.of([1, 2], growable: false);
      check(() => list.add(3)).throws<UnsupportedError>();
      check(() => list.addFirst(0)).throws<UnsupportedError>();
      check(() => list.addLast(3)).throws<UnsupportedError>();
      check(() => list.insert(1, 99)).throws<UnsupportedError>();
      check(() => list.remove(1)).throws<UnsupportedError>();
      check(() => list.removeAt(0)).throws<UnsupportedError>();
      check(list.removeFirst).throws<UnsupportedError>();
      check(list.removeLast).throws<UnsupportedError>();
      check(list.clear).throws<UnsupportedError>();
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
              check(actual.removeFirst()).equals(model.removeAt(0));
            }
          case 3: // removeLast
            if (model.isNotEmpty) {
              check(actual.removeLast()).equals(model.removeLast());
            }
          case 4: // insert
            final index = model.isEmpty ? 0 : random.nextInt(model.length + 1);
            model.insert(index, value);
            actual.insert(index, value);
          case 5: // removeAt
            if (model.isNotEmpty) {
              final index = random.nextInt(model.length);
              check(actual.removeAt(index)).equals(model.removeAt(index));
            }
        }
        check(actual.length).equals(model.length);
        if (model.isNotEmpty) {
          final probe = random.nextInt(model.length);
          check(actual[probe]).equals(model[probe]);
        }
      }
      check(actual).deepEquals(model);
    });
  });
}
