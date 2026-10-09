// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple6', () {
    const tuple = (10, 221, 217, 145, 204, 250);
    test('fromList', () {
      final other = Tuple6.fromList([10, 221, 217, 145, 204, 250]);
      check(other).equals(tuple);
      check(() => Tuple6.fromList([23, 39, 140, 220, 127, 11, 73]))
          .throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(10);
      check(tuple.second).equals(221);
      check(tuple.third).equals(217);
      check(tuple.fourth).equals(145);
      check(tuple.fifth).equals(204);
      check(tuple.sixth).equals(250);
      check(tuple.last).equals(250);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
      check(other.sixth).equals(250);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      check(other.first).equals(10);
      check(other.second).equals('a');
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
      check(other.sixth).equals(250);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals('a');
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
      check(other.sixth).equals(250);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals('a');
      check(other.fifth).equals(204);
      check(other.sixth).equals(250);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals('a');
      check(other.sixth).equals(250);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
      check(other.sixth).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
      check(other.sixth).equals('a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
      check(other.second).equals(10);
      check(other.third).equals(221);
      check(other.fourth).equals(217);
      check(other.fifth).equals(145);
      check(other.sixth).equals(204);
      check(other.seventh).equals(250);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(10);
      check(other.second).equals('a');
      check(other.third).equals(221);
      check(other.fourth).equals(217);
      check(other.fifth).equals(145);
      check(other.sixth).equals(204);
      check(other.seventh).equals(250);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals('a');
      check(other.fourth).equals(217);
      check(other.fifth).equals(145);
      check(other.sixth).equals(204);
      check(other.seventh).equals(250);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals('a');
      check(other.fifth).equals(145);
      check(other.sixth).equals(204);
      check(other.seventh).equals(250);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals('a');
      check(other.sixth).equals(204);
      check(other.seventh).equals(250);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
      check(other.sixth).equals('a');
      check(other.seventh).equals(250);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
      check(other.sixth).equals(250);
      check(other.seventh).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
      check(other.sixth).equals(250);
      check(other.seventh).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(221);
      check(other.second).equals(217);
      check(other.third).equals(145);
      check(other.fourth).equals(204);
      check(other.fifth).equals(250);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(10);
      check(other.second).equals(217);
      check(other.third).equals(145);
      check(other.fourth).equals(204);
      check(other.fifth).equals(250);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(145);
      check(other.fourth).equals(204);
      check(other.fifth).equals(250);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(204);
      check(other.fifth).equals(250);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(250);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(10);
      check(other.second).equals(221);
      check(other.third).equals(217);
      check(other.fourth).equals(145);
      check(other.fifth).equals(204);
    });
    test('length', () {
      check(tuple.length).equals(6);
    });
    test('map', () {
      check(
        tuple.map((first, second, third, fourth, fifth, sixth) {
          check(first).equals(10);
          check(second).equals(221);
          check(third).equals(217);
          check(fourth).equals(145);
          check(fifth).equals(204);
          check(sixth).equals(250);
          return 283;
        }),
      ).equals(283);
    });
    test('iterable', () {
      check(tuple.iterable).deepEquals(<dynamic>[10, 221, 217, 145, 204, 250]);
    });
    test('toList', () {
      check(tuple.toList()).deepEquals(<dynamic>[10, 221, 217, 145, 204, 250]);
    });
    test('toSet', () {
      check(tuple.toSet()).deepEquals(<dynamic>{10, 221, 217, 145, 204, 250});
    });
  });
}
