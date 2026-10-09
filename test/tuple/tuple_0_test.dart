// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple0', () {
    const tuple = ();
    test('fromList', () {
      final other = Tuple0.fromList([]);
      check(other).equals(tuple);
      check(() => Tuple0.fromList([51])).throws<ArgumentError>();
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
    });
    test('length', () {
      check(tuple.length).equals(0);
    });
    test('map', () {
      check(tuple.map(() => 430)).equals(430);
    });
    test('iterable', () {
      check(tuple.iterable).deepEquals(<dynamic>[]);
    });
    test('toList', () {
      check(tuple.toList()).deepEquals(<dynamic>[]);
    });
    test('toSet', () {
      check(tuple.toSet()).deepEquals(<dynamic>{});
    });
  });
}
