// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple8', () {
    const tuple = (32, 108, 10, 131, 83, 137, 102, 140);
    test('fromList', () {
      final other = Tuple8.fromList([32, 108, 10, 131, 83, 137, 102, 140]);
      check(other).equals(tuple);
      check(() => Tuple8.fromList([254, 112, 223, 77, 47, 35, 113, 0, 0]))
          .throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(32);
      check(tuple.second).equals(108);
      check(tuple.third).equals(10);
      check(tuple.fourth).equals(131);
      check(tuple.fifth).equals(83);
      check(tuple.sixth).equals(137);
      check(tuple.seventh).equals(102);
      check(tuple.eighth).equals(140);
      check(tuple.last).equals(140);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals(140);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      check(other.first).equals(32);
      check(other.second).equals('a');
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals(140);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals('a');
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals(140);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals('a');
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals(140);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals('a');
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals(140);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals('a');
      check(other.seventh).equals(102);
      check(other.eighth).equals(140);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals('a');
      check(other.eighth).equals(140);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals('a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
      check(other.second).equals(32);
      check(other.third).equals(108);
      check(other.fourth).equals(10);
      check(other.fifth).equals(131);
      check(other.sixth).equals(83);
      check(other.seventh).equals(137);
      check(other.eighth).equals(102);
      check(other.ninth).equals(140);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals('a');
      check(other.third).equals(108);
      check(other.fourth).equals(10);
      check(other.fifth).equals(131);
      check(other.sixth).equals(83);
      check(other.seventh).equals(137);
      check(other.eighth).equals(102);
      check(other.ninth).equals(140);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals('a');
      check(other.fourth).equals(10);
      check(other.fifth).equals(131);
      check(other.sixth).equals(83);
      check(other.seventh).equals(137);
      check(other.eighth).equals(102);
      check(other.ninth).equals(140);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals('a');
      check(other.fifth).equals(131);
      check(other.sixth).equals(83);
      check(other.seventh).equals(137);
      check(other.eighth).equals(102);
      check(other.ninth).equals(140);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals('a');
      check(other.sixth).equals(83);
      check(other.seventh).equals(137);
      check(other.eighth).equals(102);
      check(other.ninth).equals(140);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals('a');
      check(other.seventh).equals(137);
      check(other.eighth).equals(102);
      check(other.ninth).equals(140);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals('a');
      check(other.eighth).equals(102);
      check(other.ninth).equals(140);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals('a');
      check(other.ninth).equals(140);
    });
    test('addNinth', () {
      final other = tuple.addNinth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals(140);
      check(other.ninth).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
      check(other.eighth).equals(140);
      check(other.ninth).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(108);
      check(other.second).equals(10);
      check(other.third).equals(131);
      check(other.fourth).equals(83);
      check(other.fifth).equals(137);
      check(other.sixth).equals(102);
      check(other.seventh).equals(140);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(32);
      check(other.second).equals(10);
      check(other.third).equals(131);
      check(other.fourth).equals(83);
      check(other.fifth).equals(137);
      check(other.sixth).equals(102);
      check(other.seventh).equals(140);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(131);
      check(other.fourth).equals(83);
      check(other.fifth).equals(137);
      check(other.sixth).equals(102);
      check(other.seventh).equals(140);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(83);
      check(other.fifth).equals(137);
      check(other.sixth).equals(102);
      check(other.seventh).equals(140);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(137);
      check(other.sixth).equals(102);
      check(other.seventh).equals(140);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(102);
      check(other.seventh).equals(140);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(140);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(32);
      check(other.second).equals(108);
      check(other.third).equals(10);
      check(other.fourth).equals(131);
      check(other.fifth).equals(83);
      check(other.sixth).equals(137);
      check(other.seventh).equals(102);
    });
    test('length', () {
      check(tuple.length).equals(8);
    });
    test('map', () {
      check(
        tuple.map((
          first,
          second,
          third,
          fourth,
          fifth,
          sixth,
          seventh,
          eighth,
        ) {
          check(first).equals(32);
          check(second).equals(108);
          check(third).equals(10);
          check(fourth).equals(131);
          check(fifth).equals(83);
          check(sixth).equals(137);
          check(seventh).equals(102);
          check(eighth).equals(140);
          return 493;
        }),
      ).equals(493);
    });
    test('iterable', () {
      check(tuple.iterable)
          .deepEquals(<dynamic>[32, 108, 10, 131, 83, 137, 102, 140]);
    });
    test('toList', () {
      check(tuple.toList())
          .deepEquals(<dynamic>[32, 108, 10, 131, 83, 137, 102, 140]);
    });
    test('toSet', () {
      check(tuple.toSet())
          .deepEquals(<dynamic>{32, 108, 10, 131, 83, 137, 102, 140});
    });
  });
}
