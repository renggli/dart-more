// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:collection';

import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('rotate', () {
    group('list', () {
      test('size = 0', () {
        expect(<int>[]..rotate(-1), isEmpty);
        expect(<int>[]..rotate(0), isEmpty);
        expect(<int>[]..rotate(1), isEmpty);
      });
      group('size = 1', () {
        test('offset = 0', () {
          expect([0]..rotate(0), [0]);
        });
        test('offset = ±1', () {
          expect([0]..rotate(-1), [0]);
          expect([0]..rotate(1), [0]);
        });
      });
      group('size = 2', () {
        test('offset = 0', () {
          expect([0, 1]..rotate(0), [0, 1]);
        });
        test('offset = ±1', () {
          expect([0, 1]..rotate(-1), [1, 0]);
          expect([0, 1]..rotate(1), [1, 0]);
        });
        test('offset = ±2', () {
          expect([0, 1]..rotate(-2), [0, 1]);
          expect([0, 1]..rotate(2), [0, 1]);
        });
      });
      group('size = 3', () {
        test('offset = 0', () {
          expect([0, 1, 2]..rotate(0), [0, 1, 2]);
        });
        test('offset = ±1', () {
          expect([0, 1, 2]..rotate(-1), [1, 2, 0]);
          expect([0, 1, 2]..rotate(1), [2, 0, 1]);
        });
        test('offset = ±2', () {
          expect([0, 1, 2]..rotate(-2), [2, 0, 1]);
          expect([0, 1, 2]..rotate(2), [1, 2, 0]);
        });
        test('offset = ±3', () {
          expect([0, 1, 2]..rotate(-3), [0, 1, 2]);
          expect([0, 1, 2]..rotate(3), [0, 1, 2]);
        });
      });
      group('size = 4', () {
        test('offset = 0', () {
          expect([0, 1, 2, 3]..rotate(0), [0, 1, 2, 3]);
        });
        test('offset = ±1', () {
          expect([0, 1, 2, 3]..rotate(-1), [1, 2, 3, 0]);
          expect([0, 1, 2, 3]..rotate(1), [3, 0, 1, 2]);
        });
        test('offset = ±2', () {
          expect([0, 1, 2, 3]..rotate(-2), [2, 3, 0, 1]);
          expect([0, 1, 2, 3]..rotate(2), [2, 3, 0, 1]);
        });
        test('offset = ±3', () {
          expect([0, 1, 2, 3]..rotate(-3), [3, 0, 1, 2]);
          expect([0, 1, 2, 3]..rotate(3), [1, 2, 3, 0]);
        });
        test('offset = ±4', () {
          expect([0, 1, 2, 3]..rotate(-4), [0, 1, 2, 3]);
          expect([0, 1, 2, 3]..rotate(4), [0, 1, 2, 3]);
        });
      });
    });
    group('queue', () {
      test('size = 0', () {
        expect(Queue.of([])..rotate(-1), isEmpty);
        expect(Queue.of([])..rotate(0), isEmpty);
        expect(Queue.of([])..rotate(1), isEmpty);
      });
      group('size = 1', () {
        test('offset = 0', () {
          expect(Queue.of([0])..rotate(0), [0]);
        });
        test('offset = ±1', () {
          expect(Queue.of([0])..rotate(-1), [0]);
          expect(Queue.of([0])..rotate(1), [0]);
        });
      });
      group('size = 2', () {
        test('offset = 0', () {
          expect(Queue.of([0, 1])..rotate(0), [0, 1]);
        });
        test('offset = ±1', () {
          expect(Queue.of([0, 1])..rotate(-1), [1, 0]);
          expect(Queue.of([0, 1])..rotate(1), [1, 0]);
        });
        test('offset = ±2', () {
          expect(Queue.of([0, 1])..rotate(-2), [0, 1]);
          expect(Queue.of([0, 1])..rotate(2), [0, 1]);
        });
      });
      group('size = 3', () {
        test('offset = 0', () {
          expect(Queue.of([0, 1, 2])..rotate(0), [0, 1, 2]);
        });
        test('offset = ±1', () {
          expect(Queue.of([0, 1, 2])..rotate(-1), [1, 2, 0]);
          expect(Queue.of([0, 1, 2])..rotate(1), [2, 0, 1]);
        });
        test('offset = ±2', () {
          expect(Queue.of([0, 1, 2])..rotate(-2), [2, 0, 1]);
          expect(Queue.of([0, 1, 2])..rotate(2), [1, 2, 0]);
        });
        test('offset = ±3', () {
          expect(Queue.of([0, 1, 2])..rotate(-3), [0, 1, 2]);
          expect(Queue.of([0, 1, 2])..rotate(3), [0, 1, 2]);
        });
      });
      group('size = 4', () {
        test('offset = 0', () {
          expect(Queue.of([0, 1, 2, 3])..rotate(0), [0, 1, 2, 3]);
        });
        test('offset = ±1', () {
          expect(Queue.of([0, 1, 2, 3])..rotate(-1), [1, 2, 3, 0]);
          expect(Queue.of([0, 1, 2, 3])..rotate(1), [3, 0, 1, 2]);
        });
        test('offset = ±2', () {
          expect(Queue.of([0, 1, 2, 3])..rotate(-2), [2, 3, 0, 1]);
          expect(Queue.of([0, 1, 2, 3])..rotate(2), [2, 3, 0, 1]);
        });
        test('offset = ±3', () {
          expect(Queue.of([0, 1, 2, 3])..rotate(-3), [3, 0, 1, 2]);
          expect(Queue.of([0, 1, 2, 3])..rotate(3), [1, 2, 3, 0]);
        });
        test('offset = ±4', () {
          expect(Queue.of([0, 1, 2, 3])..rotate(-4), [0, 1, 2, 3]);
          expect(Queue.of([0, 1, 2, 3])..rotate(4), [0, 1, 2, 3]);
        });
      });
    });
  });
  group('take/skip', () {
    const list = ['a', 'b', 'c'];
    test('take', () {
      expect(list.take(0), isEmpty);
      expect(list.take(1), ['a']);
      expect(list.take(2), ['a', 'b']);
      expect(list.take(3), ['a', 'b', 'c']);
      expect(list.take(4), ['a', 'b', 'c']);
    });
    test('takeTo', () {
      expect(list.takeTo('a'), isEmpty);
      expect(list.takeTo('b'), ['a']);
      expect(list.takeTo('c'), ['a', 'b']);
      expect(list.takeTo('d'), ['a', 'b', 'c']);
    });
    test('takeLast', () {
      expect(list.takeLast(0), isEmpty);
      expect(list.takeLast(1), ['c']);
      expect(list.takeLast(2), ['b', 'c']);
      expect(list.takeLast(3), ['a', 'b', 'c']);
      expect(list.takeLast(4), ['a', 'b', 'c']);
    });
    test('takeLastTo', () {
      expect(list.takeLastTo('a'), ['b', 'c']);
      expect(list.takeLastTo('b'), ['c']);
      expect(list.takeLastTo('c'), isEmpty);
      expect(list.takeLastTo('d'), ['a', 'b', 'c']);
    });
    test('skip', () {
      expect(list.skip(0), ['a', 'b', 'c']);
      expect(list.skip(1), ['b', 'c']);
      expect(list.skip(2), ['c']);
      expect(list.skip(3), isEmpty);
      expect(list.skip(4), isEmpty);
    });
    test('skipTo', () {
      expect(list.skipTo('a'), ['b', 'c']);
      expect(list.skipTo('b'), ['c']);
      expect(list.skipTo('c'), isEmpty);
      expect(list.skipTo('d'), isEmpty);
    });
    test('skipLast', () {
      expect(list.skipLast(0), ['a', 'b', 'c']);
      expect(list.skipLast(1), ['a', 'b']);
      expect(list.skipLast(2), ['a']);
      expect(list.skipLast(3), isEmpty);
      expect(list.skipLast(4), isEmpty);
    });
    test('skipLastTo', () {
      expect(list.skipLastTo('a'), isEmpty);
      expect(list.skipLastTo('b'), ['a']);
      expect(list.skipLastTo('c'), ['a', 'b']);
      expect(list.skipLastTo('d'), isEmpty);
    });
  });
}
