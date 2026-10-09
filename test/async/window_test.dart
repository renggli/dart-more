import 'dart:async';

import 'package:checks/checks.dart';
import 'package:more/async.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('window stream', () {
    test('error', () async {
      await check(Stream.fromIterable([1, 2, 3]).window(0).toList())
          .throws<RangeError>();
      await check(Stream.fromIterable([1, 2, 3]).window(1, step: 0).toList())
          .throws<RangeError>();
    });
    test('size = 1', () async {
      check(await const Stream<int>.empty().window(1).toList()).isEmpty();
      check(await Stream.fromIterable([1]).window(1).toList()).deepEquals([
        [1],
      ]);
      check(await Stream.fromIterable([1, 2]).window(1).toList()).deepEquals([
        [1],
        [2],
      ]);
      check(await Stream.fromIterable([1, 2, 3]).window(1).toList())
          .deepEquals([
            [1],
            [2],
            [3],
          ]);
      check(await Stream.fromIterable([1, 2, 3, 4]).window(1).toList())
          .deepEquals([
            [1],
            [2],
            [3],
            [4],
          ]);
    });
    test('size = 2', () async {
      check(await Stream.fromIterable([]).window(2).toList()).isEmpty();
      check(await Stream.fromIterable([1]).window(2).toList()).isEmpty();
      check(await Stream.fromIterable([1, 2]).window(2).toList()).deepEquals([
        [1, 2],
      ]);
      check(await Stream.fromIterable([1, 2, 3]).window(2).toList())
          .deepEquals([
            [1, 2],
            [2, 3],
          ]);
      check(await Stream.fromIterable([1, 2, 3, 4]).window(2).toList())
          .deepEquals([
            [1, 2],
            [2, 3],
            [3, 4],
          ]);
    });
    test('size = 2, step = 2', () async {
      check(await Stream.fromIterable([]).window(2, step: 2).toList())
          .isEmpty();
      check(await Stream.fromIterable([1]).window(2, step: 2).toList())
          .isEmpty();
      check(await Stream.fromIterable([1, 2]).window(2, step: 2).toList())
          .deepEquals([
            [1, 2],
          ]);
      check(await Stream.fromIterable([1, 2, 3]).window(2, step: 2).toList())
          .deepEquals([
            [1, 2],
          ]);
      check(await Stream.fromIterable([1, 2, 3, 4]).window(2, step: 2).toList())
          .deepEquals([
            [1, 2],
            [3, 4],
          ]);
    });
    test('size = 2, step = 3', () async {
      check(await Stream.fromIterable([]).window(2, step: 3).toList())
          .isEmpty();
      check(await Stream.fromIterable([1]).window(2, step: 3).toList())
          .isEmpty();
      check(await Stream.fromIterable([1, 2]).window(2, step: 3).toList())
          .deepEquals([
            [1, 2],
          ]);
      check(await Stream.fromIterable([1, 2, 3]).window(2, step: 3).toList())
          .deepEquals([
            [1, 2],
          ]);
      check(await Stream.fromIterable([1, 2, 3, 4]).window(2, step: 3).toList())
          .deepEquals([
            [1, 2],
          ]);
    });
    test('size = 2, includePartial', () async {
      check(
        await Stream.fromIterable([]).window(2, includePartial: true).toList(),
      ).isEmpty();
      check(
        await Stream.fromIterable([1]).window(2, includePartial: true).toList(),
      ).deepEquals([
        [1],
      ]);
      check(
        await Stream.fromIterable([1, 2])
            .window(2, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
        [2],
      ]);
      check(
        await Stream.fromIterable([1, 2, 3])
            .window(2, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
        [2, 3],
        [3],
      ]);
      check(
        await Stream.fromIterable([1, 2, 3, 4])
            .window(2, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
        [2, 3],
        [3, 4],
        [4],
      ]);
    });
    test('size = 2, step = 2, includePartial', () async {
      check(
        await Stream.fromIterable([])
            .window(2, step: 2, includePartial: true)
            .toList(),
      ).isEmpty();
      check(
        await Stream.fromIterable([1])
            .window(2, step: 2, includePartial: true)
            .toList(),
      ).deepEquals([
        [1],
      ]);
      check(
        await Stream.fromIterable([1, 2])
            .window(2, step: 2, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
      ]);
      check(
        await Stream.fromIterable([1, 2, 3])
            .window(2, step: 2, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
        [3],
      ]);
      check(
        await Stream.fromIterable([1, 2, 3, 4])
            .window(2, step: 2, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
        [3, 4],
      ]);
    });
    test('size = 2, step = 3, includePartial', () async {
      check(
        await Stream.fromIterable([])
            .window(2, step: 3, includePartial: true)
            .toList(),
      ).isEmpty();
      check(
        await Stream.fromIterable([1])
            .window(2, step: 3, includePartial: true)
            .toList(),
      ).deepEquals([
        [1],
      ]);
      check(
        await Stream.fromIterable([1, 2])
            .window(2, step: 3, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
      ]);
      check(
        await Stream.fromIterable([1, 2, 3])
            .window(2, step: 3, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
      ]);
      check(
        await Stream.fromIterable([1, 2, 3, 4])
            .window(2, step: 3, includePartial: true)
            .toList(),
      ).deepEquals([
        [1, 2],
        [4],
      ]);
    });
    test('cancellation cancels upstream subscription', () async {
      var cancelled = false;
      final controller = StreamController<int>(
        onCancel: () {
          cancelled = true;
        },
      );
      controller.add(1);
      controller.add(2);
      controller.add(3);
      await controller.stream.window(2).take(1).toList();
      check(cancelled).isTrue();
    });
  });
}
