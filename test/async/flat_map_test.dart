import 'dart:async';

import 'package:checks/checks.dart';
import 'package:more/async.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('flatMap', () {
    group('iterable', () {
      Iterable<String> mapper(int value) => ['$value', '$value'];
      test('empty', () async {
        final stream = Stream.fromIterable(<int>[]);
        check(await stream.flatMap(mapper).toList()).deepEquals([]);
      });
      test('basic', () async {
        final stream = Stream.fromIterable([1, 2]);
        check(await stream.flatMap(mapper).toList())
            .deepEquals(['1', '1', '2', '2']);
      });
    });
    group('stream', () {
      Stream<String> mapper(int value) =>
          Stream.fromIterable(['$value', '$value']);
      test('empty', () async {
        final stream = Stream.fromIterable(<int>[]);
        check(await stream.asyncFlatMap(mapper).toList()).deepEquals([]);
      });
      test('basic', () async {
        final stream = Stream.fromIterable([1, 2]);
        check(await stream.asyncFlatMap(mapper).toList())
            .deepEquals(['1', '1', '2', '2']);
      });
    });
  });
}
