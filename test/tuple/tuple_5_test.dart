// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  const tuple = (17, 183, 144, 195, 3);
  test('fromList', () {
    final other = Tuple5.fromList([17, 183, 144, 195, 3]);
    check(other).equals(tuple);
    check(() => Tuple5.fromList([174, 10, 221, 217, 145, 204]))
        .throws<ArgumentError>();
    check(() => Tuple5.fromList([250, 23, 39, 140])).throws<ArgumentError>();
    check(() => Tuple5.fromList(<int>[])).throws<ArgumentError>();
  });
  test('read', () {
    check(tuple.first).equals(17);
    check(tuple.second).equals(183);
    check(tuple.third).equals(144);
    check(tuple.fourth).equals(195);
    check(tuple.fifth).equals(3);
    check(tuple.last).equals(3);
  });
  test('withFirst', () {
    final other = tuple.withFirst('a');
    check(other.first).equals('a');
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(195);
    check(other.fifth).equals(3);
  });
  test('withSecond', () {
    final other = tuple.withSecond('a');
    check(other.first).equals(17);
    check(other.second).equals('a');
    check(other.third).equals(144);
    check(other.fourth).equals(195);
    check(other.fifth).equals(3);
  });
  test('withThird', () {
    final other = tuple.withThird('a');
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals('a');
    check(other.fourth).equals(195);
    check(other.fifth).equals(3);
  });
  test('withFourth', () {
    final other = tuple.withFourth('a');
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals('a');
    check(other.fifth).equals(3);
  });
  test('withFifth', () {
    final other = tuple.withFifth('a');
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(195);
    check(other.fifth).equals('a');
  });
  test('withLast', () {
    final other = tuple.withLast('a');
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(195);
    check(other.fifth).equals('a');
  });
  test('addFirst', () {
    final other = tuple.addFirst('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals('a');
    check(other.second).equals(17);
    check(other.third).equals(183);
    check(other.fourth).equals(144);
    check(other.fifth).equals(195);
    check(other.sixth).equals(3);
  });
  test('addSecond', () {
    final other = tuple.addSecond('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(17);
    check(other.second).equals('a');
    check(other.third).equals(183);
    check(other.fourth).equals(144);
    check(other.fifth).equals(195);
    check(other.sixth).equals(3);
  });
  test('addThird', () {
    final other = tuple.addThird('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals('a');
    check(other.fourth).equals(144);
    check(other.fifth).equals(195);
    check(other.sixth).equals(3);
  });
  test('addFourth', () {
    final other = tuple.addFourth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals('a');
    check(other.fifth).equals(195);
    check(other.sixth).equals(3);
  });
  test('addFifth', () {
    final other = tuple.addFifth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(195);
    check(other.fifth).equals('a');
    check(other.sixth).equals(3);
  });
  test('addSixth', () {
    final other = tuple.addSixth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(195);
    check(other.fifth).equals(3);
    check(other.sixth).equals('a');
  });
  test('addLast', () {
    final other = tuple.addLast('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(195);
    check(other.fifth).equals(3);
    check(other.sixth).equals('a');
  });
  test('removeFirst', () {
    final other = tuple.removeFirst();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(183);
    check(other.second).equals(144);
    check(other.third).equals(195);
    check(other.fourth).equals(3);
  });
  test('removeSecond', () {
    final other = tuple.removeSecond();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(17);
    check(other.second).equals(144);
    check(other.third).equals(195);
    check(other.fourth).equals(3);
  });
  test('removeThird', () {
    final other = tuple.removeThird();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(195);
    check(other.fourth).equals(3);
  });
  test('removeFourth', () {
    final other = tuple.removeFourth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(3);
  });
  test('removeFifth', () {
    final other = tuple.removeFifth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(195);
  });
  test('removeLast', () {
    final other = tuple.removeLast();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(17);
    check(other.second).equals(183);
    check(other.third).equals(144);
    check(other.fourth).equals(195);
  });
  test('length', () {
    check(tuple.length).equals(5);
  });
  test('map', () {
    check(
      tuple.map((first, second, third, fourth, fifth) {
        check(first).equals(17);
        check(second).equals(183);
        check(third).equals(144);
        check(fourth).equals(195);
        check(fifth).equals(3);
        return 988;
      }),
    ).equals(988);
  });
  test('iterable', () {
    check(tuple.iterable).deepEquals(<Object?>[17, 183, 144, 195, 3]);
  });
  test('toList', () {
    final list = tuple.toList();
    check(list).deepEquals(<Object?>[17, 183, 144, 195, 3]);
    list.add('extra');
    check(list).deepEquals(<Object?>[17, 183, 144, 195, 3, 'extra']);
  });
  test('toSet', () {
    final set = tuple.toSet();
    check(set).deepEquals(<Object?>{17, 183, 144, 195, 3});
    set.add('extra');
    check(set).deepEquals(<Object?>{17, 183, 144, 195, 3, 'extra'});
    check((1, 1, 1, 1, 1).toSet()).deepEquals(<Object?>{1});
  });
  test('nullable and heterogeneous values', () {
    const mixed = (null, 's1', 2, 's3', 4);
    check(mixed.first).isNull;
    check(mixed.toList()).deepEquals(<Object?>[null, 's1', 2, 's3', 4]);
  });
}
