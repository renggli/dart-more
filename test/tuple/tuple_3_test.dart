// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  const tuple = (115, 77, 26);
  test('fromList', () {
    final other = Tuple3.fromList([115, 77, 26]);
    check(other).equals(tuple);
    check(() => Tuple3.fromList([167, 89, 231, 174])).throws<ArgumentError>();
    check(() => Tuple3.fromList([164, 26])).throws<ArgumentError>();
    check(() => Tuple3.fromList(<int>[])).throws<ArgumentError>();
  });
  test('read', () {
    check(tuple.first).equals(115);
    check(tuple.second).equals(77);
    check(tuple.third).equals(26);
    check(tuple.last).equals(26);
  });
  test('withFirst', () {
    final other = tuple.withFirst('a');
    check(other.first).equals('a');
    check(other.second).equals(77);
    check(other.third).equals(26);
  });
  test('withSecond', () {
    final other = tuple.withSecond('a');
    check(other.first).equals(115);
    check(other.second).equals('a');
    check(other.third).equals(26);
  });
  test('withThird', () {
    final other = tuple.withThird('a');
    check(other.first).equals(115);
    check(other.second).equals(77);
    check(other.third).equals('a');
  });
  test('withLast', () {
    final other = tuple.withLast('a');
    check(other.first).equals(115);
    check(other.second).equals(77);
    check(other.third).equals('a');
  });
  test('addFirst', () {
    final other = tuple.addFirst('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals('a');
    check(other.second).equals(115);
    check(other.third).equals(77);
    check(other.fourth).equals(26);
  });
  test('addSecond', () {
    final other = tuple.addSecond('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(115);
    check(other.second).equals('a');
    check(other.third).equals(77);
    check(other.fourth).equals(26);
  });
  test('addThird', () {
    final other = tuple.addThird('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(115);
    check(other.second).equals(77);
    check(other.third).equals('a');
    check(other.fourth).equals(26);
  });
  test('addFourth', () {
    final other = tuple.addFourth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(115);
    check(other.second).equals(77);
    check(other.third).equals(26);
    check(other.fourth).equals('a');
  });
  test('addLast', () {
    final other = tuple.addLast('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(115);
    check(other.second).equals(77);
    check(other.third).equals(26);
    check(other.fourth).equals('a');
  });
  test('removeFirst', () {
    final other = tuple.removeFirst();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(77);
    check(other.second).equals(26);
  });
  test('removeSecond', () {
    final other = tuple.removeSecond();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(115);
    check(other.second).equals(26);
  });
  test('removeThird', () {
    final other = tuple.removeThird();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(115);
    check(other.second).equals(77);
  });
  test('removeLast', () {
    final other = tuple.removeLast();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(115);
    check(other.second).equals(77);
  });
  test('length', () {
    check(tuple.length).equals(3);
  });
  test('map', () {
    check(
      tuple.map((first, second, third) {
        check(first).equals(115);
        check(second).equals(77);
        check(third).equals(26);
        return 335;
      }),
    ).equals(335);
  });
  test('iterable', () {
    check(tuple.iterable).deepEquals(<Object?>[115, 77, 26]);
  });
  test('toList', () {
    final list = tuple.toList();
    check(list).deepEquals(<Object?>[115, 77, 26]);
    list.add('extra');
    check(list).deepEquals(<Object?>[115, 77, 26, 'extra']);
  });
  test('toSet', () {
    final set = tuple.toSet();
    check(set).deepEquals(<Object?>{115, 77, 26});
    set.add('extra');
    check(set).deepEquals(<Object?>{115, 77, 26, 'extra'});
    check((1, 1, 1).toSet()).deepEquals(<Object?>{1});
  });
  test('nullable and heterogeneous values', () {
    const mixed = (null, 's1', 2);
    check(mixed.first).isNull;
    check(mixed.toList()).deepEquals(<Object?>[null, 's1', 2]);
  });
}
