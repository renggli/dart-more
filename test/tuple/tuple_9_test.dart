// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  const tuple = (21, 81, 171, 110, 138, 191, 17, 53, 115);
  test('fromList', () {
    final other = Tuple9.fromList([21, 81, 171, 110, 138, 191, 17, 53, 115]);
    check(other).equals(tuple);
    check(() => Tuple9.fromList([80, 129, 100, 144, 152, 96, 72, 32, 127, 39]))
        .throws<ArgumentError>();
    check(() => Tuple9.fromList([236, 171, 122, 66, 13, 78, 228, 183]))
        .throws<ArgumentError>();
    check(() => Tuple9.fromList(<int>[])).throws<ArgumentError>();
  });
  test('read', () {
    check(tuple.first).equals(21);
    check(tuple.second).equals(81);
    check(tuple.third).equals(171);
    check(tuple.fourth).equals(110);
    check(tuple.fifth).equals(138);
    check(tuple.sixth).equals(191);
    check(tuple.seventh).equals(17);
    check(tuple.eighth).equals(53);
    check(tuple.ninth).equals(115);
    check(tuple.last).equals(115);
  });
  test('withFirst', () {
    final other = tuple.withFirst('a');
    check(other.first).equals('a');
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
    check(other.ninth).equals(115);
  });
  test('withSecond', () {
    final other = tuple.withSecond('a');
    check(other.first).equals(21);
    check(other.second).equals('a');
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
    check(other.ninth).equals(115);
  });
  test('withThird', () {
    final other = tuple.withThird('a');
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals('a');
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
    check(other.ninth).equals(115);
  });
  test('withFourth', () {
    final other = tuple.withFourth('a');
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals('a');
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
    check(other.ninth).equals(115);
  });
  test('withFifth', () {
    final other = tuple.withFifth('a');
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals('a');
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
    check(other.ninth).equals(115);
  });
  test('withSixth', () {
    final other = tuple.withSixth('a');
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals('a');
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
    check(other.ninth).equals(115);
  });
  test('withSeventh', () {
    final other = tuple.withSeventh('a');
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals('a');
    check(other.eighth).equals(53);
    check(other.ninth).equals(115);
  });
  test('withEighth', () {
    final other = tuple.withEighth('a');
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals('a');
    check(other.ninth).equals(115);
  });
  test('withNinth', () {
    final other = tuple.withNinth('a');
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
    check(other.ninth).equals('a');
  });
  test('withLast', () {
    final other = tuple.withLast('a');
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
    check(other.ninth).equals('a');
  });
  test('removeFirst', () {
    final other = tuple.removeFirst();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(81);
    check(other.second).equals(171);
    check(other.third).equals(110);
    check(other.fourth).equals(138);
    check(other.fifth).equals(191);
    check(other.sixth).equals(17);
    check(other.seventh).equals(53);
    check(other.eighth).equals(115);
  });
  test('removeSecond', () {
    final other = tuple.removeSecond();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(171);
    check(other.third).equals(110);
    check(other.fourth).equals(138);
    check(other.fifth).equals(191);
    check(other.sixth).equals(17);
    check(other.seventh).equals(53);
    check(other.eighth).equals(115);
  });
  test('removeThird', () {
    final other = tuple.removeThird();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(110);
    check(other.fourth).equals(138);
    check(other.fifth).equals(191);
    check(other.sixth).equals(17);
    check(other.seventh).equals(53);
    check(other.eighth).equals(115);
  });
  test('removeFourth', () {
    final other = tuple.removeFourth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(138);
    check(other.fifth).equals(191);
    check(other.sixth).equals(17);
    check(other.seventh).equals(53);
    check(other.eighth).equals(115);
  });
  test('removeFifth', () {
    final other = tuple.removeFifth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(191);
    check(other.sixth).equals(17);
    check(other.seventh).equals(53);
    check(other.eighth).equals(115);
  });
  test('removeSixth', () {
    final other = tuple.removeSixth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(17);
    check(other.seventh).equals(53);
    check(other.eighth).equals(115);
  });
  test('removeSeventh', () {
    final other = tuple.removeSeventh();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(53);
    check(other.eighth).equals(115);
  });
  test('removeEighth', () {
    final other = tuple.removeEighth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(115);
  });
  test('removeNinth', () {
    final other = tuple.removeNinth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
  });
  test('removeLast', () {
    final other = tuple.removeLast();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(21);
    check(other.second).equals(81);
    check(other.third).equals(171);
    check(other.fourth).equals(110);
    check(other.fifth).equals(138);
    check(other.sixth).equals(191);
    check(other.seventh).equals(17);
    check(other.eighth).equals(53);
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
        check(first).equals(21);
        check(second).equals(81);
        check(third).equals(171);
        check(fourth).equals(110);
        check(fifth).equals(138);
        check(sixth).equals(191);
        check(seventh).equals(17);
        check(eighth).equals(53);
        check(ninth).equals(115);
        return 665;
      }),
    ).equals(665);
  });
  test('iterable', () {
    check(tuple.iterable)
        .deepEquals(<Object?>[21, 81, 171, 110, 138, 191, 17, 53, 115]);
  });
  test('toList', () {
    final list = tuple.toList();
    check(list).deepEquals(<Object?>[21, 81, 171, 110, 138, 191, 17, 53, 115]);
    list.add('extra');
    check(
      list,
    ).deepEquals(<Object?>[21, 81, 171, 110, 138, 191, 17, 53, 115, 'extra']);
  });
  test('toSet', () {
    final set = tuple.toSet();
    check(set).deepEquals(<Object?>{21, 81, 171, 110, 138, 191, 17, 53, 115});
    set.add('extra');
    check(
      set,
    ).deepEquals(<Object?>{21, 81, 171, 110, 138, 191, 17, 53, 115, 'extra'});
    check((1, 1, 1, 1, 1, 1, 1, 1, 1).toSet()).deepEquals(<Object?>{1});
  });
  test('nullable and heterogeneous values', () {
    const mixed = (null, 's1', 2, 's3', 4, 's5', 6, 's7', 8);
    check(mixed.first).isNull;
    check(mixed.toList())
        .deepEquals(<Object?>[null, 's1', 2, 's3', 4, 's5', 6, 's7', 8]);
  });
}
