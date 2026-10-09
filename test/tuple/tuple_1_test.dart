// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple1', () {
    const tuple = (196,);
    test('fromList', () {
      final other = Tuple1.fromList([196]);
      check(other).equals(tuple);
      check(() => Tuple1.fromList([93, 181])).throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(196);
      check(tuple.last).equals(196);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals('a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
      check(other.second).equals(196);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(196);
      check(other.second).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(196);
      check(other.second).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
    });
    test('length', () {
      check(tuple.length).equals(1);
    });
    test('map', () {
      check(
        tuple.map((first) {
          check(first).equals(196);
          return 104;
        }),
      ).equals(104);
    });
    test('iterable', () {
      check(tuple.iterable).deepEquals(<dynamic>[196]);
    });
    test('toList', () {
      check(tuple.toList()).deepEquals(<dynamic>[196]);
    });
    test('toSet', () {
      check(tuple.toSet()).deepEquals(<dynamic>{196});
    });
  });
}
