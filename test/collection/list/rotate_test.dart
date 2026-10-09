import 'dart:collection';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('rotate', () {
    group('list', () {
      test('size = 0', () {
        check(<int>[]..rotate(-1)).isEmpty();
        check(<int>[]..rotate(0)).isEmpty();
        check(<int>[]..rotate(1)).isEmpty();
      });
      group('size = 1', () {
        test('offset = 0', () {
          check([0]..rotate(0)).deepEquals([0]);
        });
        test('offset = ±1', () {
          check([0]..rotate(-1)).deepEquals([0]);
          check([0]..rotate(1)).deepEquals([0]);
        });
      });
      group('size = 2', () {
        test('offset = 0', () {
          check([0, 1]..rotate(0)).deepEquals([0, 1]);
        });
        test('offset = ±1', () {
          check([0, 1]..rotate(-1)).deepEquals([1, 0]);
          check([0, 1]..rotate(1)).deepEquals([1, 0]);
        });
        test('offset = ±2', () {
          check([0, 1]..rotate(-2)).deepEquals([0, 1]);
          check([0, 1]..rotate(2)).deepEquals([0, 1]);
        });
      });
      group('size = 3', () {
        test('offset = 0', () {
          check([0, 1, 2]..rotate(0)).deepEquals([0, 1, 2]);
        });
        test('offset = ±1', () {
          check([0, 1, 2]..rotate(-1)).deepEquals([1, 2, 0]);
          check([0, 1, 2]..rotate(1)).deepEquals([2, 0, 1]);
        });
        test('offset = ±2', () {
          check([0, 1, 2]..rotate(-2)).deepEquals([2, 0, 1]);
          check([0, 1, 2]..rotate(2)).deepEquals([1, 2, 0]);
        });
        test('offset = ±3', () {
          check([0, 1, 2]..rotate(-3)).deepEquals([0, 1, 2]);
          check([0, 1, 2]..rotate(3)).deepEquals([0, 1, 2]);
        });
      });
      group('size = 4', () {
        test('offset = 0', () {
          check([0, 1, 2, 3]..rotate(0)).deepEquals([0, 1, 2, 3]);
        });
        test('offset = ±1', () {
          check([0, 1, 2, 3]..rotate(-1)).deepEquals([1, 2, 3, 0]);
          check([0, 1, 2, 3]..rotate(1)).deepEquals([3, 0, 1, 2]);
        });
        test('offset = ±2', () {
          check([0, 1, 2, 3]..rotate(-2)).deepEquals([2, 3, 0, 1]);
          check([0, 1, 2, 3]..rotate(2)).deepEquals([2, 3, 0, 1]);
        });
        test('offset = ±3', () {
          check([0, 1, 2, 3]..rotate(-3)).deepEquals([3, 0, 1, 2]);
          check([0, 1, 2, 3]..rotate(3)).deepEquals([1, 2, 3, 0]);
        });
        test('offset = ±4', () {
          check([0, 1, 2, 3]..rotate(-4)).deepEquals([0, 1, 2, 3]);
          check([0, 1, 2, 3]..rotate(4)).deepEquals([0, 1, 2, 3]);
        });
      });
    });
    group('queue', () {
      test('size = 0', () {
        check(Queue.of([])..rotate(-1)).isEmpty();
        check(Queue.of([])..rotate(0)).isEmpty();
        check(Queue.of([])..rotate(1)).isEmpty();
      });
      group('size = 1', () {
        test('offset = 0', () {
          check(Queue.of([0])..rotate(0)).deepEquals([0]);
        });
        test('offset = ±1', () {
          check(Queue.of([0])..rotate(-1)).deepEquals([0]);
          check(Queue.of([0])..rotate(1)).deepEquals([0]);
        });
      });
      group('size = 2', () {
        test('offset = 0', () {
          check(Queue.of([0, 1])..rotate(0)).deepEquals([0, 1]);
        });
        test('offset = ±1', () {
          check(Queue.of([0, 1])..rotate(-1)).deepEquals([1, 0]);
          check(Queue.of([0, 1])..rotate(1)).deepEquals([1, 0]);
        });
        test('offset = ±2', () {
          check(Queue.of([0, 1])..rotate(-2)).deepEquals([0, 1]);
          check(Queue.of([0, 1])..rotate(2)).deepEquals([0, 1]);
        });
      });
      group('size = 3', () {
        test('offset = 0', () {
          check(Queue.of([0, 1, 2])..rotate(0)).deepEquals([0, 1, 2]);
        });
        test('offset = ±1', () {
          check(Queue.of([0, 1, 2])..rotate(-1)).deepEquals([1, 2, 0]);
          check(Queue.of([0, 1, 2])..rotate(1)).deepEquals([2, 0, 1]);
        });
        test('offset = ±2', () {
          check(Queue.of([0, 1, 2])..rotate(-2)).deepEquals([2, 0, 1]);
          check(Queue.of([0, 1, 2])..rotate(2)).deepEquals([1, 2, 0]);
        });
        test('offset = ±3', () {
          check(Queue.of([0, 1, 2])..rotate(-3)).deepEquals([0, 1, 2]);
          check(Queue.of([0, 1, 2])..rotate(3)).deepEquals([0, 1, 2]);
        });
      });
      group('size = 4', () {
        test('offset = 0', () {
          check(Queue.of([0, 1, 2, 3])..rotate(0)).deepEquals([0, 1, 2, 3]);
        });
        test('offset = ±1', () {
          check(Queue.of([0, 1, 2, 3])..rotate(-1)).deepEquals([1, 2, 3, 0]);
          check(Queue.of([0, 1, 2, 3])..rotate(1)).deepEquals([3, 0, 1, 2]);
        });
        test('offset = ±2', () {
          check(Queue.of([0, 1, 2, 3])..rotate(-2)).deepEquals([2, 3, 0, 1]);
          check(Queue.of([0, 1, 2, 3])..rotate(2)).deepEquals([2, 3, 0, 1]);
        });
        test('offset = ±3', () {
          check(Queue.of([0, 1, 2, 3])..rotate(-3)).deepEquals([3, 0, 1, 2]);
          check(Queue.of([0, 1, 2, 3])..rotate(3)).deepEquals([1, 2, 3, 0]);
        });
        test('offset = ±4', () {
          check(Queue.of([0, 1, 2, 3])..rotate(-4)).deepEquals([0, 1, 2, 3]);
          check(Queue.of([0, 1, 2, 3])..rotate(4)).deepEquals([0, 1, 2, 3]);
        });
      });
    });
  });
}
