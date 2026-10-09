import 'dart:async';

import 'package:checks/checks.dart';
import 'package:more/async.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('flatten (stream)', () {
    test('empty', () async {
      final stream = Stream.fromIterable(<Stream<int>>[]);
      check(await stream.flatten().toList()).deepEquals([]);
    });
    test('basic', () async {
      final stream = Stream.fromIterable([
        const Stream<int>.empty(),
        Stream.fromIterable([1]),
        Stream.fromIterable([2, 3]),
      ]);
      check(await stream.flatten().toList()).deepEquals([1, 2, 3]);
    });
  });
}
