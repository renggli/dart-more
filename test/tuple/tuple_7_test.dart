// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple7', () {
    const tuple = (195, 133, 23, 42, 211, 158, 121);
    test('fromList', () {
      final other = Tuple7.fromList([195, 133, 23, 42, 211, 158, 121]);
      check(other).equals(tuple);
      check(() => Tuple7.fromList([55, 119, 54, 178, 209, 198, 186, 130]))
          .throws<ArgumentError>();
    });
    test('read', () {
      check(tuple.first).equals(195);
      check(tuple.second).equals(133);
      check(tuple.third).equals(23);
      check(tuple.fourth).equals(42);
      check(tuple.fifth).equals(211);
      check(tuple.sixth).equals(158);
      check(tuple.seventh).equals(121);
      check(tuple.last).equals(121);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      check(other.first).equals('a');
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals(121);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      check(other.first).equals(195);
      check(other.second).equals('a');
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals(121);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals('a');
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals(121);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals('a');
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals(121);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals('a');
      check(other.sixth).equals(158);
      check(other.seventh).equals(121);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals('a');
      check(other.seventh).equals(121);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals('a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals('a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals('a');
      check(other.second).equals(195);
      check(other.third).equals(133);
      check(other.fourth).equals(23);
      check(other.fifth).equals(42);
      check(other.sixth).equals(211);
      check(other.seventh).equals(158);
      check(other.eighth).equals(121);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(195);
      check(other.second).equals('a');
      check(other.third).equals(133);
      check(other.fourth).equals(23);
      check(other.fifth).equals(42);
      check(other.sixth).equals(211);
      check(other.seventh).equals(158);
      check(other.eighth).equals(121);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals('a');
      check(other.fourth).equals(23);
      check(other.fifth).equals(42);
      check(other.sixth).equals(211);
      check(other.seventh).equals(158);
      check(other.eighth).equals(121);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals('a');
      check(other.fifth).equals(42);
      check(other.sixth).equals(211);
      check(other.seventh).equals(158);
      check(other.eighth).equals(121);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals('a');
      check(other.sixth).equals(211);
      check(other.seventh).equals(158);
      check(other.eighth).equals(121);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals('a');
      check(other.seventh).equals(158);
      check(other.eighth).equals(121);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals('a');
      check(other.eighth).equals(121);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals(121);
      check(other.eighth).equals('a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      check(other.length).equals(tuple.length + 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
      check(other.seventh).equals(121);
      check(other.eighth).equals('a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(133);
      check(other.second).equals(23);
      check(other.third).equals(42);
      check(other.fourth).equals(211);
      check(other.fifth).equals(158);
      check(other.sixth).equals(121);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(195);
      check(other.second).equals(23);
      check(other.third).equals(42);
      check(other.fourth).equals(211);
      check(other.fifth).equals(158);
      check(other.sixth).equals(121);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(42);
      check(other.fourth).equals(211);
      check(other.fifth).equals(158);
      check(other.sixth).equals(121);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(211);
      check(other.fifth).equals(158);
      check(other.sixth).equals(121);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(158);
      check(other.sixth).equals(121);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(121);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      check(other.length).equals(tuple.length - 1);
      check(other.first).equals(195);
      check(other.second).equals(133);
      check(other.third).equals(23);
      check(other.fourth).equals(42);
      check(other.fifth).equals(211);
      check(other.sixth).equals(158);
    });
    test('length', () {
      check(tuple.length).equals(7);
    });
    test('map', () {
      check(
        tuple.map((first, second, third, fourth, fifth, sixth, seventh) {
          check(first).equals(195);
          check(second).equals(133);
          check(third).equals(23);
          check(fourth).equals(42);
          check(fifth).equals(211);
          check(sixth).equals(158);
          check(seventh).equals(121);
          return 923;
        }),
      ).equals(923);
    });
    test('iterable', () {
      check(tuple.iterable)
          .deepEquals(<dynamic>[195, 133, 23, 42, 211, 158, 121]);
    });
    test('toList', () {
      check(tuple.toList())
          .deepEquals(<dynamic>[195, 133, 23, 42, 211, 158, 121]);
    });
    test('toSet', () {
      check(tuple.toSet())
          .deepEquals(<dynamic>{195, 133, 23, 42, 211, 158, 121});
    });
  });
}
