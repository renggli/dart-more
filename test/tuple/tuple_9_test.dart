// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple9', () {
    const tuple = (45, 241, 0, 46, 5, 70, 64, 157, 108);
    test('fromList', () {
      final other = Tuple9.fromList([45, 241, 0, 46, 5, 70, 64, 157, 108]);
      check(other).equals(tuple);
      check(() => Tuple9.fromList([217, 93, 20, 166, 21, 181, 57, 70, 180, 1]))
          .throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(45);
      check(tuple.second).equals(241);
      check(tuple.third).equals(0);
      check(tuple.fourth).equals(46);
      check(tuple.fifth).equals(5);
      check(tuple.sixth).equals(70);
      check(tuple.seventh).equals(64);
      check(tuple.eighth).equals(157);
      check(tuple.ninth).equals(108);
      check(tuple.last).equals(108);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
      check(other.ninth).equals(108);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      check(other.first).equals(45);
      check(other.second).equals('a');
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
      check(other.ninth).equals(108);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals('a');
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
      check(other.ninth).equals(108);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals('a');
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
      check(other.ninth).equals(108);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals('a');
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
      check(other.ninth).equals(108);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals('a');
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
      check(other.ninth).equals(108);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals('a');
      check(other.eighth).equals(157);
      check(other.ninth).equals(108);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals('a');
      check(other.ninth).equals(108);
    });
    test('withNinth', () {
      final other = tuple.withNinth('a');
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
      check(other.ninth).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
      check(other.ninth).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(241);
      check(other.second).equals(0);
      check(other.third).equals(46);
      check(other.fourth).equals(5);
      check(other.fifth).equals(70);
      check(other.sixth).equals(64);
      check(other.seventh).equals(157);
      check(other.eighth).equals(108);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(0);
      check(other.third).equals(46);
      check(other.fourth).equals(5);
      check(other.fifth).equals(70);
      check(other.sixth).equals(64);
      check(other.seventh).equals(157);
      check(other.eighth).equals(108);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(46);
      check(other.fourth).equals(5);
      check(other.fifth).equals(70);
      check(other.sixth).equals(64);
      check(other.seventh).equals(157);
      check(other.eighth).equals(108);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(5);
      check(other.fifth).equals(70);
      check(other.sixth).equals(64);
      check(other.seventh).equals(157);
      check(other.eighth).equals(108);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(70);
      check(other.sixth).equals(64);
      check(other.seventh).equals(157);
      check(other.eighth).equals(108);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(64);
      check(other.seventh).equals(157);
      check(other.eighth).equals(108);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(157);
      check(other.eighth).equals(108);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(108);
    });
    test('removeNinth', () {
      final other = tuple.removeNinth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(45);
      check(other.second).equals(241);
      check(other.third).equals(0);
      check(other.fourth).equals(46);
      check(other.fifth).equals(5);
      check(other.sixth).equals(70);
      check(other.seventh).equals(64);
      check(other.eighth).equals(157);
    });
    test('length', () {
      check(tuple.length).equals(9);
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
          ninth,
        ) {
          check(first).equals(45);
          check(second).equals(241);
          check(third).equals(0);
          check(fourth).equals(46);
          check(fifth).equals(5);
          check(sixth).equals(70);
          check(seventh).equals(64);
          check(eighth).equals(157);
          check(ninth).equals(108);
          return 572;
        }),
      ).equals(572);
    });
    test('iterable', () {
      check(tuple.iterable)
          .deepEquals(<dynamic>[45, 241, 0, 46, 5, 70, 64, 157, 108]);
    });
    test('toList', () {
      check(tuple.toList())
          .deepEquals(<dynamic>[45, 241, 0, 46, 5, 70, 64, 157, 108]);
    });
    test('toSet', () {
      check(tuple.toSet())
          .deepEquals(<dynamic>{45, 241, 0, 46, 5, 70, 64, 157, 108});
    });
  });
}
