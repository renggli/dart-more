// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  const tuple = (32, 90, 100, 110);
  test('fromList', () {
    final other = Tuple4.fromList([32, 90, 100, 110]);
    check(other).equals(tuple);
    check(() => Tuple4.fromList([80, 160, 85, 136, 148]))
        .throws<ArgumentError>();
    check(() => Tuple4.fromList([159, 123, 142])).throws<ArgumentError>();
    check(() => Tuple4.fromList(<int>[])).throws<ArgumentError>();
  });
  test('read', () {
    check(tuple.first).equals(32);
    check(tuple.second).equals(90);
    check(tuple.third).equals(100);
    check(tuple.fourth).equals(110);
    check(tuple.last).equals(110);
  });
  test('withFirst', () {
    final other = tuple.withFirst('a');
    check(other.first).equals('a');
    check(other.second).equals(90);
    check(other.third).equals(100);
    check(other.fourth).equals(110);
  });
  test('withSecond', () {
    final other = tuple.withSecond('a');
    check(other.first).equals(32);
    check(other.second).equals('a');
    check(other.third).equals(100);
    check(other.fourth).equals(110);
  });
  test('withThird', () {
    final other = tuple.withThird('a');
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals('a');
    check(other.fourth).equals(110);
  });
  test('withFourth', () {
    final other = tuple.withFourth('a');
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals(100);
    check(other.fourth).equals('a');
  });
  test('withLast', () {
    final other = tuple.withLast('a');
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals(100);
    check(other.fourth).equals('a');
  });
  test('addFirst', () {
    final other = tuple.addFirst('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals('a');
    check(other.second).equals(32);
    check(other.third).equals(90);
    check(other.fourth).equals(100);
    check(other.fifth).equals(110);
  });
  test('addSecond', () {
    final other = tuple.addSecond('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(32);
    check(other.second).equals('a');
    check(other.third).equals(90);
    check(other.fourth).equals(100);
    check(other.fifth).equals(110);
  });
  test('addThird', () {
    final other = tuple.addThird('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals('a');
    check(other.fourth).equals(100);
    check(other.fifth).equals(110);
  });
  test('addFourth', () {
    final other = tuple.addFourth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals(100);
    check(other.fourth).equals('a');
    check(other.fifth).equals(110);
  });
  test('addFifth', () {
    final other = tuple.addFifth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals(100);
    check(other.fourth).equals(110);
    check(other.fifth).equals('a');
  });
  test('addLast', () {
    final other = tuple.addLast('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals(100);
    check(other.fourth).equals(110);
    check(other.fifth).equals('a');
  });
  test('removeFirst', () {
    final other = tuple.removeFirst();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(90);
    check(other.second).equals(100);
    check(other.third).equals(110);
  });
  test('removeSecond', () {
    final other = tuple.removeSecond();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(32);
    check(other.second).equals(100);
    check(other.third).equals(110);
  });
  test('removeThird', () {
    final other = tuple.removeThird();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals(110);
  });
  test('removeFourth', () {
    final other = tuple.removeFourth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals(100);
  });
  test('removeLast', () {
    final other = tuple.removeLast();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(32);
    check(other.second).equals(90);
    check(other.third).equals(100);
  });
  test('length', () {
    check(tuple.length).equals(4);
  });
  test('map', () {
    check(
      tuple.map((first, second, third, fourth) {
        check(first).equals(32);
        check(second).equals(90);
        check(third).equals(100);
        check(fourth).equals(110);
        return 224;
      }),
    ).equals(224);
  });
  test('iterable', () {
    check(tuple.iterable).deepEquals(<Object?>[32, 90, 100, 110]);
  });
  test('toList', () {
    final list = tuple.toList();
    check(list).deepEquals(<Object?>[32, 90, 100, 110]);
    list.add('extra');
    check(list).deepEquals(<Object?>[32, 90, 100, 110, 'extra']);
  });
  test('toSet', () {
    final set = tuple.toSet();
    check(set).deepEquals(<Object?>{32, 90, 100, 110});
    set.add('extra');
    check(set).deepEquals(<Object?>{32, 90, 100, 110, 'extra'});
    check((1, 1, 1, 1).toSet()).deepEquals(<Object?>{1});
  });
  test('nullable and heterogeneous values', () {
    const mixed = (null, 's1', 2, 's3');
    check(mixed.first).isNull;
    check(mixed.toList()).deepEquals(<Object?>[null, 's1', 2, 's3']);
  });
}
