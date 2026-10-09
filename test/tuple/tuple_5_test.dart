// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple5', () {
    const tuple = (136, 148, 159, 123, 142);
    test('fromList', () {
      final other = Tuple5.fromList([136, 148, 159, 123, 142]);
      check(other).equals(tuple);
      check(() => Tuple5.fromList([224, 17, 183, 144, 195, 3]))
          .throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(136);
      check(tuple.second).equals(148);
      check(tuple.third).equals(159);
      check(tuple.fourth).equals(123);
      check(tuple.fifth).equals(142);
      check(tuple.last).equals(142);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(123);
      check(other.fifth).equals(142);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      check(other.first).equals(136);
      check(other.second).equals('a');
      check(other.third).equals(159);
      check(other.fourth).equals(123);
      check(other.fifth).equals(142);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals('a');
      check(other.fourth).equals(123);
      check(other.fifth).equals(142);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals('a');
      check(other.fifth).equals(142);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(123);
      check(other.fifth).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(123);
      check(other.fifth).equals('a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
      check(other.second).equals(136);
      check(other.third).equals(148);
      check(other.fourth).equals(159);
      check(other.fifth).equals(123);
      check(other.sixth).equals(142);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(136);
      check(other.second).equals('a');
      check(other.third).equals(148);
      check(other.fourth).equals(159);
      check(other.fifth).equals(123);
      check(other.sixth).equals(142);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals('a');
      check(other.fourth).equals(159);
      check(other.fifth).equals(123);
      check(other.sixth).equals(142);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals('a');
      check(other.fifth).equals(123);
      check(other.sixth).equals(142);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(123);
      check(other.fifth).equals('a');
      check(other.sixth).equals(142);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(123);
      check(other.fifth).equals(142);
      check(other.sixth).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(123);
      check(other.fifth).equals(142);
      check(other.sixth).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(148);
      check(other.second).equals(159);
      check(other.third).equals(123);
      check(other.fourth).equals(142);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(136);
      check(other.second).equals(159);
      check(other.third).equals(123);
      check(other.fourth).equals(142);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(123);
      check(other.fourth).equals(142);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(142);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(123);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(136);
      check(other.second).equals(148);
      check(other.third).equals(159);
      check(other.fourth).equals(123);
    });
    test('length', () {
      check(tuple.length).equals(5);
    });
    test('map', () {
      check(
        tuple.map((first, second, third, fourth, fifth) {
          check(first).equals(136);
          check(second).equals(148);
          check(third).equals(159);
          check(fourth).equals(123);
          check(fifth).equals(142);
          return 686;
        }),
      ).equals(686);
    });
    test('iterable', () {
      check(tuple.iterable).deepEquals(<dynamic>[136, 148, 159, 123, 142]);
    });
    test('toList', () {
      check(tuple.toList()).deepEquals(<dynamic>[136, 148, 159, 123, 142]);
    });
    test('toSet', () {
      check(tuple.toSet()).deepEquals(<dynamic>{136, 148, 159, 123, 142});
    });
  });
}
