// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  const tuple = (127, 11, 73, 27, 195, 133);
  test('fromList', () {
    final other = Tuple6.fromList([127, 11, 73, 27, 195, 133]);
    check(other).equals(tuple);
    check(() => Tuple6.fromList([23, 42, 211, 158, 121, 55, 119]))
        .throws<ArgumentError>();
    check(() => Tuple6.fromList([54, 178, 209, 198, 186]))
        .throws<ArgumentError>();
    check(() => Tuple6.fromList(<int>[])).throws<ArgumentError>();
  });
  test('read', () {
    check(tuple.first).equals(127);
    check(tuple.second).equals(11);
    check(tuple.third).equals(73);
    check(tuple.fourth).equals(27);
    check(tuple.fifth).equals(195);
    check(tuple.sixth).equals(133);
    check(tuple.last).equals(133);
  });
  test('withFirst', () {
    final other = tuple.withFirst('a');
    check(other.first).equals('a');
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
    check(other.sixth).equals(133);
  });
  test('withSecond', () {
    final other = tuple.withSecond('a');
    check(other.first).equals(127);
    check(other.second).equals('a');
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
    check(other.sixth).equals(133);
  });
  test('withThird', () {
    final other = tuple.withThird('a');
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals('a');
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
    check(other.sixth).equals(133);
  });
  test('withFourth', () {
    final other = tuple.withFourth('a');
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals('a');
    check(other.fifth).equals(195);
    check(other.sixth).equals(133);
  });
  test('withFifth', () {
    final other = tuple.withFifth('a');
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals('a');
    check(other.sixth).equals(133);
  });
  test('withSixth', () {
    final other = tuple.withSixth('a');
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
    check(other.sixth).equals('a');
  });
  test('withLast', () {
    final other = tuple.withLast('a');
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
    check(other.sixth).equals('a');
  });
  test('addFirst', () {
    final other = tuple.addFirst('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals('a');
    check(other.second).equals(127);
    check(other.third).equals(11);
    check(other.fourth).equals(73);
    check(other.fifth).equals(27);
    check(other.sixth).equals(195);
    check(other.seventh).equals(133);
  });
  test('addSecond', () {
    final other = tuple.addSecond('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(127);
    check(other.second).equals('a');
    check(other.third).equals(11);
    check(other.fourth).equals(73);
    check(other.fifth).equals(27);
    check(other.sixth).equals(195);
    check(other.seventh).equals(133);
  });
  test('addThird', () {
    final other = tuple.addThird('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals('a');
    check(other.fourth).equals(73);
    check(other.fifth).equals(27);
    check(other.sixth).equals(195);
    check(other.seventh).equals(133);
  });
  test('addFourth', () {
    final other = tuple.addFourth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals('a');
    check(other.fifth).equals(27);
    check(other.sixth).equals(195);
    check(other.seventh).equals(133);
  });
  test('addFifth', () {
    final other = tuple.addFifth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals('a');
    check(other.sixth).equals(195);
    check(other.seventh).equals(133);
  });
  test('addSixth', () {
    final other = tuple.addSixth('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
    check(other.sixth).equals('a');
    check(other.seventh).equals(133);
  });
  test('addSeventh', () {
    final other = tuple.addSeventh('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
    check(other.sixth).equals(133);
    check(other.seventh).equals('a');
  });
  test('addLast', () {
    final other = tuple.addLast('a');
    check(other.length).equals(tuple.length + 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
    check(other.sixth).equals(133);
    check(other.seventh).equals('a');
  });
  test('removeFirst', () {
    final other = tuple.removeFirst();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(11);
    check(other.second).equals(73);
    check(other.third).equals(27);
    check(other.fourth).equals(195);
    check(other.fifth).equals(133);
  });
  test('removeSecond', () {
    final other = tuple.removeSecond();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(127);
    check(other.second).equals(73);
    check(other.third).equals(27);
    check(other.fourth).equals(195);
    check(other.fifth).equals(133);
  });
  test('removeThird', () {
    final other = tuple.removeThird();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(27);
    check(other.fourth).equals(195);
    check(other.fifth).equals(133);
  });
  test('removeFourth', () {
    final other = tuple.removeFourth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(195);
    check(other.fifth).equals(133);
  });
  test('removeFifth', () {
    final other = tuple.removeFifth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(133);
  });
  test('removeSixth', () {
    final other = tuple.removeSixth();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
  });
  test('removeLast', () {
    final other = tuple.removeLast();
    check(other.length).equals(tuple.length - 1);
    check(other.first).equals(127);
    check(other.second).equals(11);
    check(other.third).equals(73);
    check(other.fourth).equals(27);
    check(other.fifth).equals(195);
  });
  test('length', () {
    check(tuple.length).equals(6);
  });
  test('map', () {
    check(
      tuple.map((first, second, third, fourth, fifth, sixth) {
        check(first).equals(127);
        check(second).equals(11);
        check(third).equals(73);
        check(fourth).equals(27);
        check(fifth).equals(195);
        check(sixth).equals(133);
        return 898;
      }),
    ).equals(898);
  });
  test('iterable', () {
    check(tuple.iterable).deepEquals(<Object?>[127, 11, 73, 27, 195, 133]);
  });
  test('toList', () {
    final list = tuple.toList();
    check(list).deepEquals(<Object?>[127, 11, 73, 27, 195, 133]);
    list.add('extra');
    check(list).deepEquals(<Object?>[127, 11, 73, 27, 195, 133, 'extra']);
  });
  test('toSet', () {
    final set = tuple.toSet();
    check(set).deepEquals(<Object?>{127, 11, 73, 27, 195, 133});
    set.add('extra');
    check(set).deepEquals(<Object?>{127, 11, 73, 27, 195, 133, 'extra'});
    check((1, 1, 1, 1, 1, 1).toSet()).deepEquals(<Object?>{1});
  });
  test('nullable and heterogeneous values', () {
    const mixed = (null, 's1', 2, 's3', 4, 's5');
    check(mixed.first).isNull;
    check(mixed.toList()).deepEquals(<Object?>[null, 's1', 2, 's3', 4, 's5']);
  });
}
