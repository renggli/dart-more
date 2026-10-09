// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple3', () {
    const tuple = (51, 115, 77);
    test('fromList', () {
      final other = Tuple3.fromList([51, 115, 77]);
      check(other).equals(tuple);
      check(() => Tuple3.fromList([26, 167, 89, 231])).throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(51);
      check(tuple.second).equals(115);
      check(tuple.third).equals(77);
      check(tuple.last).equals(77);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
      check(other.second).equals(115);
      check(other.third).equals(77);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      check(other.first).equals(51);
      check(other.second).equals('a');
      check(other.third).equals(77);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      check(other.first).equals(51);
      check(other.second).equals(115);
      check(other.third).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals(51);
      check(other.second).equals(115);
      check(other.third).equals('a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
      check(other.second).equals(51);
      check(other.third).equals(115);
      check(other.fourth).equals(77);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(51);
      check(other.second).equals('a');
      check(other.third).equals(115);
      check(other.fourth).equals(77);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(51);
      check(other.second).equals(115);
      check(other.third).equals('a');
      check(other.fourth).equals(77);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(51);
      check(other.second).equals(115);
      check(other.third).equals(77);
      check(other.fourth).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(51);
      check(other.second).equals(115);
      check(other.third).equals(77);
      check(other.fourth).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(115);
      check(other.second).equals(77);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(51);
      check(other.second).equals(77);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(51);
      check(other.second).equals(115);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(51);
      check(other.second).equals(115);
    });
    test('length', () {
      check(tuple.length).equals(3);
    });
    test('map', () {
      check(
        tuple.map((first, second, third) {
          check(first).equals(51);
          check(second).equals(115);
          check(third).equals(77);
          return 430;
        }),
      ).equals(430);
    });
    test('iterable', () {
      check(tuple.iterable).deepEquals(<dynamic>[51, 115, 77]);
    });
    test('toList', () {
      check(tuple.toList()).deepEquals(<dynamic>[51, 115, 77]);
    });
    test('toSet', () {
      check(tuple.toSet()).deepEquals(<dynamic>{51, 115, 77});
    });
  });
}
