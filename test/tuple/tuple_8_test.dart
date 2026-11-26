// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  const tuple = (0, 46, 5, 70, 64, 157, 108, 217);
  test('fromList', () {
    final other = Tuple8.fromList([0, 46, 5, 70, 64, 157, 108, 217]);
    check(other).equals(tuple);
    check(() => Tuple8.fromList([93, 20, 166, 21, 181, 57, 70, 180, 1]))
        .throws<ArgumentError>();
    check(() => Tuple8.fromList([60, 182, 117, 95, 32, 200, 176]))
        .throws<ArgumentError>();
    check(() => Tuple8.fromList(<int>[])).throws<ArgumentError>();
  });
  test('read', () {
    check(tuple.first).equals(0);
    check(tuple.second).equals(46);
    check(tuple.third).equals(5);
    check(tuple.fourth).equals(70);
    check(tuple.fifth).equals(64);
    check(tuple.sixth).equals(157);
    check(tuple.seventh).equals(108);
    check(tuple.eighth).equals(217);
    check(tuple.last).equals(217);
  });
  test('withFirst', () {
    final other = tuple.withFirst('a');
    check(other.first).equals('a');
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals(217);
  });
  test('withSecond', () {
    final other = tuple.withSecond('a');
    check(other.first).equals(0);
    check(other.second).equals('a');
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals(217);
  });
  test('withThird', () {
    final other = tuple.withThird('a');
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals('a');
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals(217);
  });
  test('withFourth', () {
    final other = tuple.withFourth('a');
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals('a');
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals(217);
  });
  test('withFifth', () {
    final other = tuple.withFifth('a');
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals('a');
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals(217);
  });
  test('withSixth', () {
    final other = tuple.withSixth('a');
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals('a');
    check(other.seventh).equals(108);
    check(other.eighth).equals(217);
  });
  test('withSeventh', () {
    final other = tuple.withSeventh('a');
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals('a');
    check(other.eighth).equals(217);
  });
  test('withEighth', () {
    final other = tuple.withEighth('a');
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals('a');
  });
  test('withLast', () {
    final other = tuple.withLast('a');
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals('a');
  });
  test('addFirst', () {
    final other = tuple.addFirst('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals('a');
    check(other.second).equals(0);
    check(other.third).equals(46);
    check(other.fourth).equals(5);
    check(other.fifth).equals(70);
    check(other.sixth).equals(64);
    check(other.seventh).equals(157);
    check(other.eighth).equals(108);
    check(other.ninth).equals(217);
  });
  test('addSecond', () {
    final other = tuple.addSecond('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals('a');
    check(other.third).equals(46);
    check(other.fourth).equals(5);
    check(other.fifth).equals(70);
    check(other.sixth).equals(64);
    check(other.seventh).equals(157);
    check(other.eighth).equals(108);
    check(other.ninth).equals(217);
  });
  test('addThird', () {
    final other = tuple.addThird('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals('a');
    check(other.fourth).equals(5);
    check(other.fifth).equals(70);
    check(other.sixth).equals(64);
    check(other.seventh).equals(157);
    check(other.eighth).equals(108);
    check(other.ninth).equals(217);
  });
  test('addFourth', () {
    final other = tuple.addFourth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals('a');
    check(other.fifth).equals(70);
    check(other.sixth).equals(64);
    check(other.seventh).equals(157);
    check(other.eighth).equals(108);
    check(other.ninth).equals(217);
  });
  test('addFifth', () {
    final other = tuple.addFifth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals('a');
    check(other.sixth).equals(64);
    check(other.seventh).equals(157);
    check(other.eighth).equals(108);
    check(other.ninth).equals(217);
  });
  test('addSixth', () {
    final other = tuple.addSixth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals('a');
    check(other.seventh).equals(157);
    check(other.eighth).equals(108);
    check(other.ninth).equals(217);
  });
  test('addSeventh', () {
    final other = tuple.addSeventh('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals('a');
    check(other.eighth).equals(108);
    check(other.ninth).equals(217);
  });
  test('addEighth', () {
    final other = tuple.addEighth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals('a');
    check(other.ninth).equals(217);
  });
  test('addNinth', () {
    final other = tuple.addNinth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals(217);
    check(other.ninth).equals('a');
  });
  test('addLast', () {
    final other = tuple.addLast('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
    check(other.eighth).equals(217);
    check(other.ninth).equals('a');
  });
  test('removeFirst', () {
    final other = tuple.removeFirst();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(46);
    check(other.second).equals(5);
    check(other.third).equals(70);
    check(other.fourth).equals(64);
    check(other.fifth).equals(157);
    check(other.sixth).equals(108);
    check(other.seventh).equals(217);
  });
  test('removeSecond', () {
    final other = tuple.removeSecond();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(0);
    check(other.second).equals(5);
    check(other.third).equals(70);
    check(other.fourth).equals(64);
    check(other.fifth).equals(157);
    check(other.sixth).equals(108);
    check(other.seventh).equals(217);
  });
  test('removeThird', () {
    final other = tuple.removeThird();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(70);
    check(other.fourth).equals(64);
    check(other.fifth).equals(157);
    check(other.sixth).equals(108);
    check(other.seventh).equals(217);
  });
  test('removeFourth', () {
    final other = tuple.removeFourth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(64);
    check(other.fifth).equals(157);
    check(other.sixth).equals(108);
    check(other.seventh).equals(217);
  });
  test('removeFifth', () {
    final other = tuple.removeFifth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(157);
    check(other.sixth).equals(108);
    check(other.seventh).equals(217);
  });
  test('removeSixth', () {
    final other = tuple.removeSixth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(108);
    check(other.seventh).equals(217);
  });
  test('removeSeventh', () {
    final other = tuple.removeSeventh();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(217);
  });
  test('removeEighth', () {
    final other = tuple.removeEighth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
  });
  test('removeLast', () {
    final other = tuple.removeLast();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(0);
    check(other.second).equals(46);
    check(other.third).equals(5);
    check(other.fourth).equals(70);
    check(other.fifth).equals(64);
    check(other.sixth).equals(157);
    check(other.seventh).equals(108);
  });
  test('length', () {
    check(tuple.length).equals(8);
  });
  test('map', () {
    check(
      tuple.map((first, second, third, fourth, fifth, sixth, seventh, eighth) {
        check(first).equals(0);
        check(second).equals(46);
        check(third).equals(5);
        check(fourth).equals(70);
        check(fifth).equals(64);
        check(sixth).equals(157);
        check(seventh).equals(108);
        check(eighth).equals(217);
        return 125;
      }),
    ).equals(125);
  });
  test('iterable', () {
    check(tuple.iterable)
        .deepEquals(<Object?>[0, 46, 5, 70, 64, 157, 108, 217]);
  });
  test('toList', () {
    final list = tuple.toList();
    check(list).deepEquals(<Object?>[0, 46, 5, 70, 64, 157, 108, 217]);
    list.add('extra');
    check(list).deepEquals(<Object?>[0, 46, 5, 70, 64, 157, 108, 217, 'extra']);
  });
  test('toSet', () {
    final set = tuple.toSet();
    check(set).deepEquals(<Object?>{0, 46, 5, 70, 64, 157, 108, 217});
    set.add('extra');
    check(set).deepEquals(<Object?>{0, 46, 5, 70, 64, 157, 108, 217, 'extra'});
    check((1, 1, 1, 1, 1, 1, 1, 1).toSet()).deepEquals(<Object?>{1});
  });
  test('nullable and heterogeneous values', () {
    const mixed = (null, 's1', 2, 's3', 4, 's5', 6, 's7');
    check(mixed.first).isNull;
    check(mixed.toList())
        .deepEquals(<Object?>[null, 's1', 2, 's3', 4, 's5', 6, 's7']);
  });
}
