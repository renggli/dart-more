// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple4', () {
    const tuple = (164, 26, 79, 32);
    test('fromList', () {
      final other = Tuple4.fromList([164, 26, 79, 32]);
      check(other).equals(tuple);
      check(() => Tuple4.fromList([90, 100, 110, 80, 160]))
          .throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(164);
      check(tuple.second).equals(26);
      check(tuple.third).equals(79);
      check(tuple.fourth).equals(32);
      check(tuple.last).equals(32);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
      check(other.second).equals(26);
      check(other.third).equals(79);
      check(other.fourth).equals(32);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      check(other.first).equals(164);
      check(other.second).equals('a');
      check(other.third).equals(79);
      check(other.fourth).equals(32);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals('a');
      check(other.fourth).equals(32);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals(79);
      check(other.fourth).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals(79);
      check(other.fourth).equals('a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
      check(other.second).equals(164);
      check(other.third).equals(26);
      check(other.fourth).equals(79);
      check(other.fifth).equals(32);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(164);
      check(other.second).equals('a');
      check(other.third).equals(26);
      check(other.fourth).equals(79);
      check(other.fifth).equals(32);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals('a');
      check(other.fourth).equals(79);
      check(other.fifth).equals(32);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals(79);
      check(other.fourth).equals('a');
      check(other.fifth).equals(32);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals(79);
      check(other.fourth).equals(32);
      check(other.fifth).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals(79);
      check(other.fourth).equals(32);
      check(other.fifth).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(26);
      check(other.second).equals(79);
      check(other.third).equals(32);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(164);
      check(other.second).equals(79);
      check(other.third).equals(32);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals(32);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals(79);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(164);
      check(other.second).equals(26);
      check(other.third).equals(79);
    });
    test('length', () {
      check(tuple.length).equals(4);
    });
    test('map', () {
      check(
        tuple.map((first, second, third, fourth) {
          check(first).equals(164);
          check(second).equals(26);
          check(third).equals(79);
          check(fourth).equals(32);
          return 341;
        }),
      ).equals(341);
    });
    test('iterable', () {
      check(tuple.iterable).deepEquals(<dynamic>[164, 26, 79, 32]);
    });
    test('toList', () {
      check(tuple.toList()).deepEquals(<dynamic>[164, 26, 79, 32]);
    });
    test('toSet', () {
      check(tuple.toSet()).deepEquals(<dynamic>{164, 26, 79, 32});
    });
  });
}
