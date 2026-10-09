import 'dart:async';

import 'package:checks/checks.dart';
import 'package:more/async.dart';
import 'package:test/scaffolding.dart';

void main() {
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
      await wrap(
        events,
        stream,
      ).forEach((value) => events.add('value: $value'));
      check(events).deepEquals([
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
      final stream = Stream.fromIterable(<Stream<int>>[
        Stream.value(42),
        Stream.error('Expected error'),
      ]).flatten();
      await wrap(events, stream)
          .listen((value) => events.add('value: $value'))
          .asFuture<void>()
          .catchError((Object error) => events.add('error: $error'));
      check(events).deepEquals([
        'onListen',
        'onData: 42',
        'value: 42',
        'onError: Expected error',
        'onCancel',
        'error: Expected error',
      ]);
    });
    test('pause/resume', () async {
      late StreamSubscription<int> subscription;
      final events = <String>[];
      final stream = Stream.fromIterable([
        Stream.value(1),
        Stream.fromFuture(
          Future(() {
            subscription.pause();
            subscription.resume();
            return 2;
          }),
        ),
        Stream.value(3),
      ]).flatten();
      subscription = wrap(
        events,
        stream,
      ).listen((value) => events.add('value: $value'));
      await subscription.asFuture<void>();
      await subscription.cancel();
      check(events).deepEquals([
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
          Future.delayed(const Duration(milliseconds: 10), () => 2),
        ),
        Stream.value(3),
      ]).flatten();
      subscription = wrap(
        events,
        stream,
      ).listen((value) => events.add('value: $value'));
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await subscription.cancel();
      check(events)
          .deepEquals(['onListen', 'onData: 1', 'value: 1', 'onCancel']);
    });
  });
}
