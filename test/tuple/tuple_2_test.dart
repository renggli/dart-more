// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple2', () {
    const tuple = (143, 61);
    test('fromList', () {
      final other = Tuple2.fromList([143, 61]);
      check(other).equals(tuple);
      check(() => Tuple2.fromList([48, 184, 255])).throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(143);
      check(tuple.second).equals(61);
      check(tuple.last).equals(61);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
      check(other.second).equals(61);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      check(other.first).equals(143);
      check(other.second).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals(143);
      check(other.second).equals('a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
      check(other.second).equals(143);
      check(other.third).equals(61);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(143);
      check(other.second).equals('a');
      check(other.third).equals(61);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(143);
      check(other.second).equals(61);
      check(other.third).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(143);
      check(other.second).equals(61);
      check(other.third).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(61);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(143);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(143);
    });
    test('length', () {
      check(tuple.length).equals(2);
    });
    test('map', () {
      check(
        tuple.map((first, second) {
          check(first).equals(143);
          check(second).equals(61);
          return 740;
        }),
      ).equals(740);
    });
    test('iterable', () {
      check(tuple.iterable).deepEquals(<dynamic>[143, 61]);
    });
    test('toList', () {
      check(tuple.toList()).deepEquals(<dynamic>[143, 61]);
    });
    test('toSet', () {
      check(tuple.toSet()).deepEquals(<dynamic>{143, 61});
    });
  });
}
