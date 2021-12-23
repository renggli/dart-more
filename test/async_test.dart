import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:more/async.dart';
import 'package:test/test.dart';

const seconds1 = Duration(seconds: 1);
const seconds2 = Duration(seconds: 2);
const seconds3 = Duration(seconds: 3);
const seconds4 = Duration(seconds: 4);
const seconds5 = Duration(seconds: 5);

void main() {
  group('buffer', () {
    final input = [1, 2, 3, 4, 5];
    test('no constraints', () {
      final stream = Stream.fromIterable(input);
      expect(
          stream.buffer(),
          emitsInOrder([
            [1, 2, 3, 4, 5]
          ]));
    });
    test('max length', () {
      final stream = Stream.fromIterable(input);
      expect(
          stream.buffer(maxLength: 2),
          emitsInOrder([
            [1, 2],
            [3, 4],
            [5]
          ]));
    });
    test('max age', () {
      fakeAsync((async) {
        final stream = Stream.fromIterable([
          Stream.fromIterable([1, 2]),
          Stream.fromFuture(Future.delayed(seconds3, () => 3)),
          Stream.fromIterable([4, 5]),
        ]).flatten();
        expectLater(
            stream.buffer(maxAge: seconds1),
            emitsInOrder([
              [1, 2],
              [3, 4, 5],
            ]));
        async.elapse(seconds4);
      });
    });
    test('errors', () {
      final stream = Stream.error(StateError('Data Error'));
      expect(
          stream.buffer(),
          emitsError(const TypeMatcher<StateError>()
              .having((e) => e.message, 'message', 'Data Error')));
    });
    test('trigger', () {
      fakeAsync((async) {
        final trigger = Stream.periodic(seconds2);
        final stream = Stream.periodic(seconds1, (count) => 1 + count).take(4);
        expectLater(
            stream.buffer(trigger: trigger),
            emitsInOrder([
              [1, 2],
              [3, 4],
            ]));
        async.elapse(seconds5);
      });
    });
    test('trigger (errors)', () {
      fakeAsync((async) {
        final trigger = Stream.error(StateError('Trigger Error'));
        final stream = Stream.periodic(seconds1, (count) => 1 + count).take(4);
        expectLater(
            stream.buffer(trigger: trigger),
            emitsError(const TypeMatcher<StateError>()
                .having((e) => e.message, 'message', 'Trigger Error')));
        async.elapse(seconds5);
      });
    });
    test('trigger (completes early)', () {
      fakeAsync((async) {
        final trigger = Stream.periodic(seconds2).take(1);
        final stream = Stream.periodic(seconds1, (count) => 1 + count).take(4);
        expectLater(
            stream.buffer(trigger: trigger),
            emitsInOrder([
              [1, 2]
            ]));
        async.elapse(seconds5);
      });
    });
  });
  group('flatMap', () {
    group('iterable', () {
      Iterable<String> mapper(int value) => ['$value', '$value'];
      test('empty', () {
        final stream = Stream.fromIterable(<int>[]);
        expect(stream.flatMap(mapper), emitsInOrder([]));
      });
      test('basic', () {
        final stream = Stream.fromIterable([1, 2]);
        expect(stream.flatMap(mapper), emitsInOrder(['1', '1', '2', '2']));
      });
    });
    group('stream', () {
      Stream<String> mapper(int value) =>
          Stream.fromIterable(['$value', '$value']);
      test('empty', () {
        final stream = Stream.fromIterable(<int>[]);
        expect(stream.asyncFlatMap(mapper), emitsInOrder([]));
      });
      test('basic', () {
        final stream = Stream.fromIterable([1, 2]);
        expect(stream.asyncFlatMap(mapper), emitsInOrder(['1', '1', '2', '2']));
      });
    });
  });
  group('flatten', () {
    group('iterable', () {
      test('empty', () {
        final stream = Stream.fromIterable(<Iterable>[]);
        expect(stream.flatten(), emitsInOrder([]));
      });
      test('basic', () {
        final stream = Stream.fromIterable([
          [],
          [1],
          [2, 3]
        ]);
        expect(stream.flatten(), emitsInOrder([1, 2, 3]));
      });
    });
    group('stream', () {
      test('empty', () {
        final stream = Stream.fromIterable(<Stream>[]);
        expect(stream.flatten(), emitsInOrder([]));
      });
      test('basic', () {
        final stream = Stream.fromIterable([
          const Stream.empty(),
          Stream.fromIterable([1]),
          Stream.fromIterable([2, 3])
        ]);
        expect(stream.flatten(), emitsInOrder([1, 2, 3]));
      });
    });
  });
  group('tap', () {
    Stream<T> wrap<T>(List<String> events, Stream<T> stream) => stream.tap(
          onListen: () => events.add('onListen'),
          onData: (value) => events.add('onData: $value'),
          onError: (error, [stackTrace]) => events.add('onError: $error'),
          onPause: () => events.add('onPause'),
          onResume: () => events.add('onResume'),
          onCancel: () => events.add('onCancel'),
          onDone: () => events.add('onDone'),
        );
    test('basic', () async {
      final events = <String>[];
      final stream = Stream.fromIterable([1, 2, 3]);
      await wrap(events, stream)
          .forEach((value) => events.add('value: $value'));
      expect(events, [
        'onListen',
        'onData: 1',
        'value: 1',
        'onData: 2',
        'value: 2',
        'onData: 3',
        'value: 3',
        'onDone',
        'onCancel',
      ]);
    });
    test('error', () async {
      final events = <String>[];
      final stream = Stream.fromIterable([
        Stream.value(42),
        Stream.error('Expected error'),
      ]).flatten();
      await wrap(events, stream)
          .listen((value) => events.add('value: $value'))
          .asFuture()
          .catchError((error) => events.add('error: $error'));
      expect(events, [
        'onListen',
        'onData: 42',
        'value: 42',
        'onError: Expected error',
        'onCancel',
        'error: Expected error'
      ]);
    });
    test('pause/resume', () async {
      late StreamSubscription<int> subscription;
      final events = <String>[];
      final stream = Stream.fromIterable([
        Stream.value(1),
        Stream.fromFuture(Future(() {
          subscription.pause();
          subscription.resume();
          return 2;
        })),
        Stream.value(3),
      ]).flatten();
      subscription =
          wrap(events, stream).listen((value) => events.add('value: $value'));
      await subscription.asFuture();
      await subscription.cancel();
      expect(events, [
        'onListen',
        'onData: 1',
        'value: 1',
        'onPause',
        'onResume',
        'onData: 2',
        'value: 2',
        'onData: 3',
        'value: 3',
        'onDone',
        'onCancel',
      ]);
    });
    test('cancel', () async {
      StreamSubscription<int> subscription;
      final events = <String>[];
      final stream = Stream.fromIterable([
        Stream.value(1),
        Stream.fromFuture(
            Future.delayed(const Duration(milliseconds: 10), () => 2)),
        Stream.value(3),
      ]).flatten();
      subscription =
          wrap(events, stream).listen((value) => events.add('value: $value'));
      await Future.delayed(const Duration(milliseconds: 5));
      await subscription.cancel();
      expect(events, [
        'onListen',
        'onData: 1',
        'value: 1',
        'onCancel',
      ]);
    });
  });
  group('whereType', () {
    final input = ['foo', 32, 42, 'bar', #symbol];
    test('<int>', () {
      final stream = Stream.fromIterable(input);
      expect(stream.whereType<int>(), emitsInOrder([32, 42]));
    });
    test('<String>', () {
      final stream = Stream.fromIterable(input);
      expect(stream.whereType<String>(), emitsInOrder(['foo', 'bar']));
    });
    test('<Symbol>', () {
      final stream = Stream.fromIterable(input);
      expect(stream.whereType<Symbol>(), emitsInOrder([#symbol]));
    });
    test('<Void>', () {
      final stream = Stream.fromIterable(input);
      expect(stream.whereType<void>(), emitsInOrder([]));
    });
  });
  group('window stream', () {
    // all tests are based from iterable window
    test('error', () {
      expect(() => Stream.fromIterable([1, 2, 3]).window(0).toList(),
          throwsRangeError);
      expect(() => Stream.fromIterable([1, 2, 3]).window(1, step: 0).toList(),
          throwsRangeError);
    });
    test('size = 1', () async {
      expect(await Stream.empty().window(1).toList(), []);
      expect(await Stream.fromIterable([1]).window(1).toList(), [
        [1]
      ]);
      expect(await Stream.fromIterable([1, 2]).window(1).toList(), [
        [1],
        [2]
      ]);
      expect(await Stream.fromIterable([1, 2, 3]).window(1).toList(), [
        [1],
        [2],
        [3]
      ]);
      expect(await Stream.fromIterable([1, 2, 3, 4]).window(1).toList(), [
        [1],
        [2],
        [3],
        [4]
      ]);
    });
    test('size = 2', () async {
      expect(await Stream.fromIterable([]).window(2).toList(), []);
      expect(await Stream.fromIterable([1]).window(2).toList(), []);
      expect(await Stream.fromIterable([1, 2]).window(2).toList(), [
        [1, 2]
      ]);
      expect(await Stream.fromIterable([1, 2, 3]).window(2).toList(), [
        [1, 2],
        [2, 3]
      ]);
      expect(await Stream.fromIterable([1, 2, 3, 4]).window(2).toList(), [
        [1, 2],
        [2, 3],
        [3, 4]
      ]);
    });
    test('size = 2, step = 2', () async {
      expect(await Stream.fromIterable([]).window(2, step: 2).toList(), []);
      expect(await Stream.fromIterable([1]).window(2, step: 2).toList(), []);
      expect(await Stream.fromIterable([1, 2]).window(2, step: 2).toList(), [
        [1, 2]
      ]);
      expect(await Stream.fromIterable([1, 2, 3]).window(2, step: 2).toList(), [
        [1, 2]
      ]);
      expect(
          await Stream.fromIterable([1, 2, 3, 4]).window(2, step: 2).toList(), [
        [1, 2],
        [3, 4]
      ]);
    });
    test('size = 2, step = 3', () async {
      expect(await Stream.fromIterable([]).window(2, step: 3).toList(), []);
      expect(await Stream.fromIterable([1]).window(2, step: 3).toList(), []);
      expect(await Stream.fromIterable([1, 2]).window(2, step: 3).toList(), [
        [1, 2]
      ]);
      expect(await Stream.fromIterable([1, 2, 3]).window(2, step: 3).toList(), [
        [1, 2]
      ]);
      expect(
          await Stream.fromIterable([1, 2, 3, 4]).window(2, step: 3).toList(), [
        [1, 2]
      ]);
    });
    test('size = 2, includePartial', () async {
      expect(
          await Stream.fromIterable([])
              .window(2, includePartial: true)
              .toList(),
          []);
      expect(
          await Stream.fromIterable([1])
              .window(2, includePartial: true)
              .toList(),
          [
            [1]
          ]);
      expect(
          await Stream.fromIterable([1, 2])
              .window(2, includePartial: true)
              .toList(),
          [
            [1, 2],
            [2]
          ]);
      expect(
          await Stream.fromIterable([1, 2, 3])
              .window(2, includePartial: true)
              .toList(),
          [
            [1, 2],
            [2, 3],
            [3]
          ]);
      expect(
          await Stream.fromIterable([1, 2, 3, 4])
              .window(2, includePartial: true)
              .toList(),
          [
            [1, 2],
            [2, 3],
            [3, 4],
            [4]
          ]);
    });
    test('size = 2, step = 2, includePartial', () async {
      expect(
          await Stream.fromIterable([])
              .window(2, step: 2, includePartial: true)
              .toList(),
          []);
      expect(
          await Stream.fromIterable([1])
              .window(2, step: 2, includePartial: true)
              .toList(),
          [
            [1]
          ]);
      expect(
          await Stream.fromIterable([1, 2])
              .window(2, step: 2, includePartial: true)
              .toList(),
          [
            [1, 2]
          ]);
      expect(
          await Stream.fromIterable([1, 2, 3])
              .window(2, step: 2, includePartial: true)
              .toList(),
          [
            [1, 2],
            [3]
          ]);
      expect(
          await Stream.fromIterable([1, 2, 3, 4])
              .window(2, step: 2, includePartial: true)
              .toList(),
          [
            [1, 2],
            [3, 4]
          ]);
    });
    test('size = 2, step = 3, includePartial', () async {
      expect(
          await Stream.fromIterable([])
              .window(2, step: 3, includePartial: true)
              .toList(),
          []);
      expect(
          await Stream.fromIterable([1])
              .window(2, step: 3, includePartial: true)
              .toList(),
          [
            [1]
          ]);
      expect(
          await Stream.fromIterable([1, 2])
              .window(2, step: 3, includePartial: true)
              .toList(),
          [
            [1, 2]
          ]);
      expect(
          await Stream.fromIterable([1, 2, 3])
              .window(2, step: 3, includePartial: true)
              .toList(),
          [
            [1, 2]
          ]);
      expect(
          await Stream.fromIterable([1, 2, 3, 4])
              .window(2, step: 3, includePartial: true)
              .toList(),
          [
            [1, 2],
            [4]
          ]);
    });
  });
}
