import 'dart:async';

import 'package:checks/checks.dart';
import 'package:more/async.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('flatten (iterable)', () {
    test('empty', () async {
      final stream = Stream.fromIterable(<Iterable<int>>[]);
      check(await stream.flatten().toList()).deepEquals([]);
    });
    test('basic', () async {
      final stream = Stream.fromIterable(<Iterable<int>>[
        [],
        [1],
        [2, 3],
      ]);
      check(await stream.flatten().toList()).deepEquals([1, 2, 3]);
    });
  });
}
