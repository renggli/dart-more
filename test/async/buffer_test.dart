import 'dart:async';

import 'package:checks/checks.dart';
import 'package:fake_async/fake_async.dart';
import 'package:more/async.dart';
import 'package:test/scaffolding.dart';

const seconds1 = Duration(seconds: 1);
const seconds2 = Duration(seconds: 2);
const seconds3 = Duration(seconds: 3);
const seconds4 = Duration(seconds: 4);
const seconds5 = Duration(seconds: 5);

void main() {
  group('buffer', () {
    final input = [1, 2, 3, 4, 5];
    test('no constraints', () async {
      final stream = Stream.fromIterable(input);
      check(await stream.buffer().toList()).deepEquals([
        [1, 2, 3, 4, 5],
      ]);
    });
    test('max length', () async {
      final stream = Stream.fromIterable(input);
      check(await stream.buffer(maxLength: 2).toList()).deepEquals([
        [1, 2],
        [3, 4],
        [5],
      ]);
    });
    test('max age', () {
      fakeAsync((async) {
        final stream = Stream.fromIterable([
          Stream.fromIterable([1, 2]),
          Stream.fromFuture(Future.delayed(seconds3, () => 3)),
          Stream.fromIterable([4, 5]),
        ]).flatten();
        final results = <List<int>>[];
        final sub = stream.buffer(maxAge: seconds1).listen(results.add);
        async.elapse(seconds4);
        check(results).deepEquals([
          [1, 2],
          [3, 4, 5],
        ]);
        sub.cancel();
      });
    });
    test('errors', () async {
      final stream = Stream<void>.error(StateError('Data Error'));
      await check(stream.buffer().toList()).throws<StateError>(
        (it) => it.has((e) => e.message, 'message').equals('Data Error'),
      );
    });
    test('trigger', () {
      fakeAsync((async) {
        final trigger = Stream<void>.periodic(seconds2);
        final stream = Stream.periodic(seconds1, (count) => 1 + count).take(4);
        final results = <List<int>>[];
        final sub = stream.buffer(trigger: trigger).listen(results.add);
        async.elapse(seconds5);
        check(results).deepEquals([
          [1, 2],
          [3, 4],
        ]);
        sub.cancel();
      });
    });
    test('trigger (errors)', () {
      fakeAsync((async) {
        final trigger = Stream<void>.error(StateError('Trigger Error'));
        final stream = Stream.periodic(seconds1, (count) => 1 + count).take(4);
        Object? actualError;
        final sub = stream
            .buffer(trigger: trigger)
            .listen(null, onError: (Object error) => actualError = error);
        async.elapse(seconds5);
        check(actualError)
            .isA<StateError>()
            .has((e) => e.message, 'message')
            .equals('Trigger Error');
        sub.cancel();
      });
    });
    test('trigger (completes early)', () {
      fakeAsync((async) {
        final trigger = Stream<void>.periodic(seconds2).take(1);
        final stream = Stream.periodic(seconds1, (count) => 1 + count).take(4);
        final results = <List<int>>[];
        final sub = stream.buffer(trigger: trigger).listen(results.add);
        async.elapse(seconds5);
        check(results).deepEquals([
          [1, 2],
        ]);
        sub.cancel();
      });
    });
    test('broadcast', () async {
      final controller = StreamController<int>.broadcast();
      final results1 = <List<int>>[];
      final results2 = <List<int>>[];
      final sub1 = controller.stream.buffer(maxLength: 1).listen(results1.add);
      final sub2 = controller.stream.buffer(maxLength: 2).listen(results2.add);
      controller
        ..add(1)
        ..add(2);
      await Future<void>.delayed(Duration.zero);
      check(results1).deepEquals([
        [1],
        [2],
      ]);
      check(results2).deepEquals([
        [1, 2],
      ]);
      await sub1.cancel();
      await sub2.cancel();
    });
  });
}
