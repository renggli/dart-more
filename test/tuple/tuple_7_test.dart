// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  const tuple = (192, 242, 32, 108, 10, 131, 83);
  test('fromList', () {
    final other = Tuple7.fromList([192, 242, 32, 108, 10, 131, 83]);
    check(other).equals(tuple);
    check(() => Tuple7.fromList([137, 102, 140, 254, 112, 223, 77, 47]))
        .throws<ArgumentError>();
    check(() => Tuple7.fromList([35, 113, 0, 0, 237, 45]))
        .throws<ArgumentError>();
    check(() => Tuple7.fromList(<int>[])).throws<ArgumentError>();
  });
  test('read', () {
    check(tuple.first).equals(192);
    check(tuple.second).equals(242);
    check(tuple.third).equals(32);
    check(tuple.fourth).equals(108);
    check(tuple.fifth).equals(10);
    check(tuple.sixth).equals(131);
    check(tuple.seventh).equals(83);
    check(tuple.last).equals(83);
  });
  test('withFirst', () {
    final other = tuple.withFirst('a');
    check(other.first).equals('a');
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals(83);
  });
  test('withSecond', () {
    final other = tuple.withSecond('a');
    check(other.first).equals(192);
    check(other.second).equals('a');
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals(83);
  });
  test('withThird', () {
    final other = tuple.withThird('a');
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals('a');
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals(83);
  });
  test('withFourth', () {
    final other = tuple.withFourth('a');
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals('a');
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals(83);
  });
  test('withFifth', () {
    final other = tuple.withFifth('a');
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals('a');
    check(other.sixth).equals(131);
    check(other.seventh).equals(83);
  });
  test('withSixth', () {
    final other = tuple.withSixth('a');
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals('a');
    check(other.seventh).equals(83);
  });
  test('withSeventh', () {
    final other = tuple.withSeventh('a');
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals('a');
  });
  test('withLast', () {
    final other = tuple.withLast('a');
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals('a');
  });
  test('addFirst', () {
    final other = tuple.addFirst('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals('a');
    check(other.second).equals(192);
    check(other.third).equals(242);
    check(other.fourth).equals(32);
    check(other.fifth).equals(108);
    check(other.sixth).equals(10);
    check(other.seventh).equals(131);
    check(other.eighth).equals(83);
  });
  test('addSecond', () {
    final other = tuple.addSecond('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(192);
    check(other.second).equals('a');
    check(other.third).equals(242);
    check(other.fourth).equals(32);
    check(other.fifth).equals(108);
    check(other.sixth).equals(10);
    check(other.seventh).equals(131);
    check(other.eighth).equals(83);
  });
  test('addThird', () {
    final other = tuple.addThird('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals('a');
    check(other.fourth).equals(32);
    check(other.fifth).equals(108);
    check(other.sixth).equals(10);
    check(other.seventh).equals(131);
    check(other.eighth).equals(83);
  });
  test('addFourth', () {
    final other = tuple.addFourth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals('a');
    check(other.fifth).equals(108);
    check(other.sixth).equals(10);
    check(other.seventh).equals(131);
    check(other.eighth).equals(83);
  });
  test('addFifth', () {
    final other = tuple.addFifth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals('a');
    check(other.sixth).equals(10);
    check(other.seventh).equals(131);
    check(other.eighth).equals(83);
  });
  test('addSixth', () {
    final other = tuple.addSixth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals('a');
    check(other.seventh).equals(131);
    check(other.eighth).equals(83);
  });
  test('addSeventh', () {
    final other = tuple.addSeventh('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals('a');
    check(other.eighth).equals(83);
  });
  test('addEighth', () {
    final other = tuple.addEighth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals(83);
    check(other.eighth).equals('a');
  });
  test('addLast', () {
    final other = tuple.addLast('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
    check(other.seventh).equals(83);
    check(other.eighth).equals('a');
  });
  test('removeFirst', () {
    final other = tuple.removeFirst();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(242);
    check(other.second).equals(32);
    check(other.third).equals(108);
    check(other.fourth).equals(10);
    check(other.fifth).equals(131);
    check(other.sixth).equals(83);
  });
  test('removeSecond', () {
    final other = tuple.removeSecond();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(192);
    check(other.second).equals(32);
    check(other.third).equals(108);
    check(other.fourth).equals(10);
    check(other.fifth).equals(131);
    check(other.sixth).equals(83);
  });
  test('removeThird', () {
    final other = tuple.removeThird();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(108);
    check(other.fourth).equals(10);
    check(other.fifth).equals(131);
    check(other.sixth).equals(83);
  });
  test('removeFourth', () {
    final other = tuple.removeFourth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(10);
    check(other.fifth).equals(131);
    check(other.sixth).equals(83);
  });
  test('removeFifth', () {
    final other = tuple.removeFifth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(131);
    check(other.sixth).equals(83);
  });
  test('removeSixth', () {
    final other = tuple.removeSixth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(83);
  });
  test('removeSeventh', () {
    final other = tuple.removeSeventh();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
  });
  test('removeLast', () {
    final other = tuple.removeLast();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(192);
    check(other.second).equals(242);
    check(other.third).equals(32);
    check(other.fourth).equals(108);
    check(other.fifth).equals(10);
    check(other.sixth).equals(131);
  });
  test('length', () {
    check(tuple.length).equals(7);
  });
  test('map', () {
    check(
      tuple.map((first, second, third, fourth, fifth, sixth, seventh) {
        check(first).equals(192);
        check(second).equals(242);
        check(third).equals(32);
        check(fourth).equals(108);
        check(fifth).equals(10);
        check(sixth).equals(131);
        check(seventh).equals(83);
        return 497;
      }),
    ).equals(497);
  });
  test('iterable', () {
    check(tuple.iterable).deepEquals(<Object?>[192, 242, 32, 108, 10, 131, 83]);
  });
  test('toList', () {
    final list = tuple.toList();
    check(list).deepEquals(<Object?>[192, 242, 32, 108, 10, 131, 83]);
    list.add('extra');
    check(list).deepEquals(<Object?>[192, 242, 32, 108, 10, 131, 83, 'extra']);
  });
  test('toSet', () {
    final set = tuple.toSet();
    check(set).deepEquals(<Object?>{192, 242, 32, 108, 10, 131, 83});
    set.add('extra');
    check(set).deepEquals(<Object?>{192, 242, 32, 108, 10, 131, 83, 'extra'});
    check((1, 1, 1, 1, 1, 1, 1).toSet()).deepEquals(<Object?>{1});
  });
  test('nullable and heterogeneous values', () {
    const mixed = (null, 's1', 2, 's3', 4, 's5', 6);
    check(mixed.first).isNull;
    check(mixed.toList())
        .deepEquals(<Object?>[null, 's1', 2, 's3', 4, 's5', 6]);
  });
}
