library more.test.tuple_test;

import 'package:more/tuple.dart';
import 'package:test/test.dart';

void main() {
  group('Tuple0', () {
    const tuple = Tuple0();
    test('Tuple.fromList', () {
      final other = Tuple.fromList([]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([255, 228, 51, 115, 77, 26, 167, 89, 231, 174]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple0.fromList([]);
      expect(other, tuple);
      expect(() => Tuple0.fromList([164]), throwsArgumentError);
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
    });
    test('remove', () {
      expect(() => tuple.removeFirst(), throwsStateError);
      expect(() => tuple.removeLast(), throwsStateError);
    });
    test('length', () {
      expect(tuple.length, 0);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{});
    });
    test('toString', () {
      expect(tuple.toString(), '()');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == const Tuple1(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
    });
  });
  group('Tuple1', () {
    const tuple = Tuple1(26);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([26]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([79, 32, 90, 100, 110, 80, 160, 85, 136, 148]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple1.fromList([26]);
      expect(other, tuple);
      expect(() => Tuple1.fromList([159, 123]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 26);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 26);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 26);
      expect(other.value1, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 26);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 26);
      expect(other.value1, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
    });
    test('length', () {
      expect(tuple.length, 1);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[26]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[26]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{26});
    });
    test('toString', () {
      expect(tuple.toString(), '(26)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with0(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with0('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with0(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with0('a').hashCode, isFalse);
    });
  });
  group('Tuple2', () {
    const tuple = Tuple2(142, 224);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([142, 224]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([17, 183, 144, 195, 3, 174, 10, 221, 217, 145]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple2.fromList([142, 224]);
      expect(other, tuple);
      expect(() => Tuple2.fromList([204, 250, 23]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 142);
      expect(tuple.value1, 224);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 224);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 142);
      expect(other.value1, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 142);
      expect(other.value2, 224);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 142);
      expect(other.value1, 224);
      expect(other.value2, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 142);
      expect(other.value2, 224);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 142);
      expect(other.value1, 'a');
      expect(other.value2, 224);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 142);
      expect(other.value1, 224);
      expect(other.value2, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 224);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 142);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 224);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 142);
    });
    test('length', () {
      expect(tuple.length, 2);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[142, 224]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[142, 224]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{142, 224});
    });
    test('toString', () {
      expect(tuple.toString(), '(142, 224)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with1(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with1('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with1(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with1('a').hashCode, isFalse);
    });
  });
  group('Tuple3', () {
    const tuple = Tuple3(39, 140, 220);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([39, 140, 220]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([127, 11, 73, 27, 195, 133, 23, 42, 211, 158]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple3.fromList([39, 140, 220]);
      expect(other, tuple);
      expect(() => Tuple3.fromList([121, 55, 119, 54]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 39);
      expect(tuple.value1, 140);
      expect(tuple.value2, 220);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 140);
      expect(other.value2, 220);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 39);
      expect(other.value1, 'a');
      expect(other.value2, 220);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 39);
      expect(other.value1, 140);
      expect(other.value2, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 39);
      expect(other.value2, 140);
      expect(other.value3, 220);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 39);
      expect(other.value1, 140);
      expect(other.value2, 220);
      expect(other.value3, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 39);
      expect(other.value2, 140);
      expect(other.value3, 220);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 39);
      expect(other.value1, 'a');
      expect(other.value2, 140);
      expect(other.value3, 220);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 39);
      expect(other.value1, 140);
      expect(other.value2, 'a');
      expect(other.value3, 220);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 39);
      expect(other.value1, 140);
      expect(other.value2, 220);
      expect(other.value3, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 140);
      expect(other.value1, 220);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 39);
      expect(other.value1, 140);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 140);
      expect(other.value1, 220);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 39);
      expect(other.value1, 220);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 39);
      expect(other.value1, 140);
    });
    test('length', () {
      expect(tuple.length, 3);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[39, 140, 220]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[39, 140, 220]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{39, 140, 220});
    });
    test('toString', () {
      expect(tuple.toString(), '(39, 140, 220)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with2(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with2('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with2(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with2('a').hashCode, isFalse);
    });
  });
  group('Tuple4', () {
    const tuple = Tuple4(178, 209, 198, 186);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([178, 209, 198, 186]);
      expect(other, tuple);
      expect(
          () =>
              Tuple.fromList([130, 155, 175, 159, 93, 164, 180, 175, 192, 242]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple4.fromList([178, 209, 198, 186]);
      expect(other, tuple);
      expect(
          () => Tuple4.fromList([32, 108, 10, 131, 83]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 178);
      expect(tuple.value1, 209);
      expect(tuple.value2, 198);
      expect(tuple.value3, 186);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 209);
      expect(other.value2, 198);
      expect(other.value3, 186);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 178);
      expect(other.value1, 'a');
      expect(other.value2, 198);
      expect(other.value3, 186);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 'a');
      expect(other.value3, 186);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 198);
      expect(other.value3, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 178);
      expect(other.value2, 209);
      expect(other.value3, 198);
      expect(other.value4, 186);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 198);
      expect(other.value3, 186);
      expect(other.value4, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 178);
      expect(other.value2, 209);
      expect(other.value3, 198);
      expect(other.value4, 186);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 178);
      expect(other.value1, 'a');
      expect(other.value2, 209);
      expect(other.value3, 198);
      expect(other.value4, 186);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 'a');
      expect(other.value3, 198);
      expect(other.value4, 186);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 198);
      expect(other.value3, 'a');
      expect(other.value4, 186);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 198);
      expect(other.value3, 186);
      expect(other.value4, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 209);
      expect(other.value1, 198);
      expect(other.value2, 186);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 198);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 209);
      expect(other.value1, 198);
      expect(other.value2, 186);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 178);
      expect(other.value1, 198);
      expect(other.value2, 186);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 186);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 178);
      expect(other.value1, 209);
      expect(other.value2, 198);
    });
    test('length', () {
      expect(tuple.length, 4);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[178, 209, 198, 186]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[178, 209, 198, 186]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{178, 209, 198, 186});
    });
    test('toString', () {
      expect(tuple.toString(), '(178, 209, 198, 186)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with3(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with3('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with3(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with3('a').hashCode, isFalse);
    });
  });
  group('Tuple5', () {
    const tuple = Tuple5(137, 102, 140, 254, 112);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([137, 102, 140, 254, 112]);
      expect(other, tuple);
      expect(() => Tuple.fromList([223, 77, 47, 35, 113, 0, 0, 237, 45, 241]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple5.fromList([137, 102, 140, 254, 112]);
      expect(other, tuple);
      expect(
          () => Tuple5.fromList([0, 46, 5, 70, 64, 157]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 137);
      expect(tuple.value1, 102);
      expect(tuple.value2, 140);
      expect(tuple.value3, 254);
      expect(tuple.value4, 112);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 254);
      expect(other.value4, 112);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 137);
      expect(other.value1, 'a');
      expect(other.value2, 140);
      expect(other.value3, 254);
      expect(other.value4, 112);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 'a');
      expect(other.value3, 254);
      expect(other.value4, 112);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 'a');
      expect(other.value4, 112);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 254);
      expect(other.value4, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 137);
      expect(other.value2, 102);
      expect(other.value3, 140);
      expect(other.value4, 254);
      expect(other.value5, 112);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 254);
      expect(other.value4, 112);
      expect(other.value5, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 137);
      expect(other.value2, 102);
      expect(other.value3, 140);
      expect(other.value4, 254);
      expect(other.value5, 112);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 137);
      expect(other.value1, 'a');
      expect(other.value2, 102);
      expect(other.value3, 140);
      expect(other.value4, 254);
      expect(other.value5, 112);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 'a');
      expect(other.value3, 140);
      expect(other.value4, 254);
      expect(other.value5, 112);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 'a');
      expect(other.value4, 254);
      expect(other.value5, 112);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 254);
      expect(other.value4, 'a');
      expect(other.value5, 112);
    });
    test('addAt5', () {
      final other = tuple.addAt5('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 254);
      expect(other.value4, 112);
      expect(other.value5, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 102);
      expect(other.value1, 140);
      expect(other.value2, 254);
      expect(other.value3, 112);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 254);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 102);
      expect(other.value1, 140);
      expect(other.value2, 254);
      expect(other.value3, 112);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 137);
      expect(other.value1, 140);
      expect(other.value2, 254);
      expect(other.value3, 112);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 254);
      expect(other.value3, 112);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 112);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 137);
      expect(other.value1, 102);
      expect(other.value2, 140);
      expect(other.value3, 254);
    });
    test('length', () {
      expect(tuple.length, 5);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[137, 102, 140, 254, 112]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[137, 102, 140, 254, 112]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{137, 102, 140, 254, 112});
    });
    test('toString', () {
      expect(tuple.toString(), '(137, 102, 140, 254, 112)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with4(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with4('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with4(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with4('a').hashCode, isFalse);
    });
  });
  group('Tuple6', () {
    const tuple = Tuple6(108, 217, 93, 20, 166, 21);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([108, 217, 93, 20, 166, 21]);
      expect(other, tuple);
      expect(() => Tuple.fromList([181, 57, 70, 180, 1, 60, 182, 117, 95, 32]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple6.fromList([108, 217, 93, 20, 166, 21]);
      expect(other, tuple);
      expect(() => Tuple6.fromList([200, 176, 125, 21, 81, 171, 110]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 108);
      expect(tuple.value1, 217);
      expect(tuple.value2, 93);
      expect(tuple.value3, 20);
      expect(tuple.value4, 166);
      expect(tuple.value5, 21);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 166);
      expect(other.value5, 21);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 108);
      expect(other.value1, 'a');
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 166);
      expect(other.value5, 21);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 'a');
      expect(other.value3, 20);
      expect(other.value4, 166);
      expect(other.value5, 21);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 'a');
      expect(other.value4, 166);
      expect(other.value5, 21);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 'a');
      expect(other.value5, 21);
    });
    test('with5', () {
      final other = tuple.with5('a');
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 166);
      expect(other.value5, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 108);
      expect(other.value2, 217);
      expect(other.value3, 93);
      expect(other.value4, 20);
      expect(other.value5, 166);
      expect(other.value6, 21);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 166);
      expect(other.value5, 21);
      expect(other.value6, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 108);
      expect(other.value2, 217);
      expect(other.value3, 93);
      expect(other.value4, 20);
      expect(other.value5, 166);
      expect(other.value6, 21);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 108);
      expect(other.value1, 'a');
      expect(other.value2, 217);
      expect(other.value3, 93);
      expect(other.value4, 20);
      expect(other.value5, 166);
      expect(other.value6, 21);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 'a');
      expect(other.value3, 93);
      expect(other.value4, 20);
      expect(other.value5, 166);
      expect(other.value6, 21);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 'a');
      expect(other.value4, 20);
      expect(other.value5, 166);
      expect(other.value6, 21);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 'a');
      expect(other.value5, 166);
      expect(other.value6, 21);
    });
    test('addAt5', () {
      final other = tuple.addAt5('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 166);
      expect(other.value5, 'a');
      expect(other.value6, 21);
    });
    test('addAt6', () {
      final other = tuple.addAt6('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 166);
      expect(other.value5, 21);
      expect(other.value6, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 217);
      expect(other.value1, 93);
      expect(other.value2, 20);
      expect(other.value3, 166);
      expect(other.value4, 21);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 166);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 217);
      expect(other.value1, 93);
      expect(other.value2, 20);
      expect(other.value3, 166);
      expect(other.value4, 21);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 108);
      expect(other.value1, 93);
      expect(other.value2, 20);
      expect(other.value3, 166);
      expect(other.value4, 21);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 20);
      expect(other.value3, 166);
      expect(other.value4, 21);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 166);
      expect(other.value4, 21);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 21);
    });
    test('removeAt5', () {
      final other = tuple.removeAt5();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 108);
      expect(other.value1, 217);
      expect(other.value2, 93);
      expect(other.value3, 20);
      expect(other.value4, 166);
    });
    test('length', () {
      expect(tuple.length, 6);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[108, 217, 93, 20, 166, 21]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[108, 217, 93, 20, 166, 21]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{108, 217, 93, 20, 166, 21});
    });
    test('toString', () {
      expect(tuple.toString(), '(108, 217, 93, 20, 166, 21)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with5(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with5('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with5(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with5('a').hashCode, isFalse);
    });
  });
  group('Tuple7', () {
    const tuple = Tuple7(138, 191, 17, 53, 115, 80, 129);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([138, 191, 17, 53, 115, 80, 129]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([100, 144, 152, 96, 72, 32, 127, 39, 236, 171]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple7.fromList([138, 191, 17, 53, 115, 80, 129]);
      expect(other, tuple);
      expect(() => Tuple7.fromList([122, 66, 13, 78, 228, 183, 153, 63]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 138);
      expect(tuple.value1, 191);
      expect(tuple.value2, 17);
      expect(tuple.value3, 53);
      expect(tuple.value4, 115);
      expect(tuple.value5, 80);
      expect(tuple.value6, 129);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
      expect(other.value6, 129);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 138);
      expect(other.value1, 'a');
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
      expect(other.value6, 129);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 'a');
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
      expect(other.value6, 129);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 'a');
      expect(other.value4, 115);
      expect(other.value5, 80);
      expect(other.value6, 129);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 'a');
      expect(other.value5, 80);
      expect(other.value6, 129);
    });
    test('with5', () {
      final other = tuple.with5('a');
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 'a');
      expect(other.value6, 129);
    });
    test('with6', () {
      final other = tuple.with6('a');
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
      expect(other.value6, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 138);
      expect(other.value2, 191);
      expect(other.value3, 17);
      expect(other.value4, 53);
      expect(other.value5, 115);
      expect(other.value6, 80);
      expect(other.value7, 129);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
      expect(other.value6, 129);
      expect(other.value7, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 138);
      expect(other.value2, 191);
      expect(other.value3, 17);
      expect(other.value4, 53);
      expect(other.value5, 115);
      expect(other.value6, 80);
      expect(other.value7, 129);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 138);
      expect(other.value1, 'a');
      expect(other.value2, 191);
      expect(other.value3, 17);
      expect(other.value4, 53);
      expect(other.value5, 115);
      expect(other.value6, 80);
      expect(other.value7, 129);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 'a');
      expect(other.value3, 17);
      expect(other.value4, 53);
      expect(other.value5, 115);
      expect(other.value6, 80);
      expect(other.value7, 129);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 'a');
      expect(other.value4, 53);
      expect(other.value5, 115);
      expect(other.value6, 80);
      expect(other.value7, 129);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 'a');
      expect(other.value5, 115);
      expect(other.value6, 80);
      expect(other.value7, 129);
    });
    test('addAt5', () {
      final other = tuple.addAt5('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 'a');
      expect(other.value6, 80);
      expect(other.value7, 129);
    });
    test('addAt6', () {
      final other = tuple.addAt6('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
      expect(other.value6, 'a');
      expect(other.value7, 129);
    });
    test('addAt7', () {
      final other = tuple.addAt7('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
      expect(other.value6, 129);
      expect(other.value7, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 191);
      expect(other.value1, 17);
      expect(other.value2, 53);
      expect(other.value3, 115);
      expect(other.value4, 80);
      expect(other.value5, 129);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 191);
      expect(other.value1, 17);
      expect(other.value2, 53);
      expect(other.value3, 115);
      expect(other.value4, 80);
      expect(other.value5, 129);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 138);
      expect(other.value1, 17);
      expect(other.value2, 53);
      expect(other.value3, 115);
      expect(other.value4, 80);
      expect(other.value5, 129);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 53);
      expect(other.value3, 115);
      expect(other.value4, 80);
      expect(other.value5, 129);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 115);
      expect(other.value4, 80);
      expect(other.value5, 129);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 80);
      expect(other.value5, 129);
    });
    test('removeAt5', () {
      final other = tuple.removeAt5();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 129);
    });
    test('removeAt6', () {
      final other = tuple.removeAt6();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 138);
      expect(other.value1, 191);
      expect(other.value2, 17);
      expect(other.value3, 53);
      expect(other.value4, 115);
      expect(other.value5, 80);
    });
    test('length', () {
      expect(tuple.length, 7);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[138, 191, 17, 53, 115, 80, 129]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[138, 191, 17, 53, 115, 80, 129]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{138, 191, 17, 53, 115, 80, 129});
    });
    test('toString', () {
      expect(tuple.toString(), '(138, 191, 17, 53, 115, 80, 129)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with6(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with6('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with6(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with6('a').hashCode, isFalse);
    });
  });
  group('Tuple8', () {
    const tuple = Tuple8(4, 238, 254, 200, 37, 244, 31, 234);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([4, 238, 254, 200, 37, 244, 31, 234]);
      expect(other, tuple);
      expect(() => Tuple.fromList([132, 24, 19, 211, 220, 206, 56, 54, 10, 16]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple8.fromList([4, 238, 254, 200, 37, 244, 31, 234]);
      expect(other, tuple);
      expect(() => Tuple8.fromList([9, 219, 36, 6, 81, 93, 76, 9, 209]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 4);
      expect(tuple.value1, 238);
      expect(tuple.value2, 254);
      expect(tuple.value3, 200);
      expect(tuple.value4, 37);
      expect(tuple.value5, 244);
      expect(tuple.value6, 31);
      expect(tuple.value7, 234);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 234);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 4);
      expect(other.value1, 'a');
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 234);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 'a');
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 234);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 'a');
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 234);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 'a');
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 234);
    });
    test('with5', () {
      final other = tuple.with5('a');
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 'a');
      expect(other.value6, 31);
      expect(other.value7, 234);
    });
    test('with6', () {
      final other = tuple.with6('a');
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 'a');
      expect(other.value7, 234);
    });
    test('with7', () {
      final other = tuple.with7('a');
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 4);
      expect(other.value2, 238);
      expect(other.value3, 254);
      expect(other.value4, 200);
      expect(other.value5, 37);
      expect(other.value6, 244);
      expect(other.value7, 31);
      expect(other.value8, 234);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 234);
      expect(other.value8, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 4);
      expect(other.value2, 238);
      expect(other.value3, 254);
      expect(other.value4, 200);
      expect(other.value5, 37);
      expect(other.value6, 244);
      expect(other.value7, 31);
      expect(other.value8, 234);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 'a');
      expect(other.value2, 238);
      expect(other.value3, 254);
      expect(other.value4, 200);
      expect(other.value5, 37);
      expect(other.value6, 244);
      expect(other.value7, 31);
      expect(other.value8, 234);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 'a');
      expect(other.value3, 254);
      expect(other.value4, 200);
      expect(other.value5, 37);
      expect(other.value6, 244);
      expect(other.value7, 31);
      expect(other.value8, 234);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 'a');
      expect(other.value4, 200);
      expect(other.value5, 37);
      expect(other.value6, 244);
      expect(other.value7, 31);
      expect(other.value8, 234);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 'a');
      expect(other.value5, 37);
      expect(other.value6, 244);
      expect(other.value7, 31);
      expect(other.value8, 234);
    });
    test('addAt5', () {
      final other = tuple.addAt5('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 'a');
      expect(other.value6, 244);
      expect(other.value7, 31);
      expect(other.value8, 234);
    });
    test('addAt6', () {
      final other = tuple.addAt6('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 'a');
      expect(other.value7, 31);
      expect(other.value8, 234);
    });
    test('addAt7', () {
      final other = tuple.addAt7('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 'a');
      expect(other.value8, 234);
    });
    test('addAt8', () {
      final other = tuple.addAt8('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
      expect(other.value7, 234);
      expect(other.value8, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 238);
      expect(other.value1, 254);
      expect(other.value2, 200);
      expect(other.value3, 37);
      expect(other.value4, 244);
      expect(other.value5, 31);
      expect(other.value6, 234);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 238);
      expect(other.value1, 254);
      expect(other.value2, 200);
      expect(other.value3, 37);
      expect(other.value4, 244);
      expect(other.value5, 31);
      expect(other.value6, 234);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 4);
      expect(other.value1, 254);
      expect(other.value2, 200);
      expect(other.value3, 37);
      expect(other.value4, 244);
      expect(other.value5, 31);
      expect(other.value6, 234);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 200);
      expect(other.value3, 37);
      expect(other.value4, 244);
      expect(other.value5, 31);
      expect(other.value6, 234);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 37);
      expect(other.value4, 244);
      expect(other.value5, 31);
      expect(other.value6, 234);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 244);
      expect(other.value5, 31);
      expect(other.value6, 234);
    });
    test('removeAt5', () {
      final other = tuple.removeAt5();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 31);
      expect(other.value6, 234);
    });
    test('removeAt6', () {
      final other = tuple.removeAt6();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 234);
    });
    test('removeAt7', () {
      final other = tuple.removeAt7();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 4);
      expect(other.value1, 238);
      expect(other.value2, 254);
      expect(other.value3, 200);
      expect(other.value4, 37);
      expect(other.value5, 244);
      expect(other.value6, 31);
    });
    test('length', () {
      expect(tuple.length, 8);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[4, 238, 254, 200, 37, 244, 31, 234]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[4, 238, 254, 200, 37, 244, 31, 234]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{4, 238, 254, 200, 37, 244, 31, 234});
    });
    test('toString', () {
      expect(tuple.toString(), '(4, 238, 254, 200, 37, 244, 31, 234)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with7(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with7('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with7(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with7('a').hashCode, isFalse);
    });
  });
  group('Tuple9', () {
    const tuple = Tuple9(229, 246, 244, 122, 206, 164, 55, 173, 2);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([229, 246, 244, 122, 206, 164, 55, 173, 2]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([172, 190, 123, 156, 135, 27, 188, 100, 29, 17]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple9.fromList([229, 246, 244, 122, 206, 164, 55, 173, 2]);
      expect(other, tuple);
      expect(
          () =>
              Tuple9.fromList([134, 68, 251, 48, 174, 226, 226, 42, 197, 245]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.value0, 229);
      expect(tuple.value1, 246);
      expect(tuple.value2, 244);
      expect(tuple.value3, 122);
      expect(tuple.value4, 206);
      expect(tuple.value5, 164);
      expect(tuple.value6, 55);
      expect(tuple.value7, 173);
      expect(tuple.value8, 2);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 173);
      expect(other.value8, 2);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 229);
      expect(other.value1, 'a');
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 173);
      expect(other.value8, 2);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 'a');
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 173);
      expect(other.value8, 2);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 'a');
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 173);
      expect(other.value8, 2);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 'a');
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 173);
      expect(other.value8, 2);
    });
    test('with5', () {
      final other = tuple.with5('a');
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 'a');
      expect(other.value6, 55);
      expect(other.value7, 173);
      expect(other.value8, 2);
    });
    test('with6', () {
      final other = tuple.with6('a');
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 'a');
      expect(other.value7, 173);
      expect(other.value8, 2);
    });
    test('with7', () {
      final other = tuple.with7('a');
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 'a');
      expect(other.value8, 2);
    });
    test('with8', () {
      final other = tuple.with8('a');
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 173);
      expect(other.value8, 'a');
    });
    test('add', () {
      expect(() => tuple.addFirst(-1), throwsStateError);
      expect(() => tuple.addLast(-1), throwsStateError);
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 246);
      expect(other.value1, 244);
      expect(other.value2, 122);
      expect(other.value3, 206);
      expect(other.value4, 164);
      expect(other.value5, 55);
      expect(other.value6, 173);
      expect(other.value7, 2);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 173);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 246);
      expect(other.value1, 244);
      expect(other.value2, 122);
      expect(other.value3, 206);
      expect(other.value4, 164);
      expect(other.value5, 55);
      expect(other.value6, 173);
      expect(other.value7, 2);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 244);
      expect(other.value2, 122);
      expect(other.value3, 206);
      expect(other.value4, 164);
      expect(other.value5, 55);
      expect(other.value6, 173);
      expect(other.value7, 2);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 122);
      expect(other.value3, 206);
      expect(other.value4, 164);
      expect(other.value5, 55);
      expect(other.value6, 173);
      expect(other.value7, 2);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 206);
      expect(other.value4, 164);
      expect(other.value5, 55);
      expect(other.value6, 173);
      expect(other.value7, 2);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 164);
      expect(other.value5, 55);
      expect(other.value6, 173);
      expect(other.value7, 2);
    });
    test('removeAt5', () {
      final other = tuple.removeAt5();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 55);
      expect(other.value6, 173);
      expect(other.value7, 2);
    });
    test('removeAt6', () {
      final other = tuple.removeAt6();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 173);
      expect(other.value7, 2);
    });
    test('removeAt7', () {
      final other = tuple.removeAt7();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 2);
    });
    test('removeAt8', () {
      final other = tuple.removeAt8();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 229);
      expect(other.value1, 246);
      expect(other.value2, 244);
      expect(other.value3, 122);
      expect(other.value4, 206);
      expect(other.value5, 164);
      expect(other.value6, 55);
      expect(other.value7, 173);
    });
    test('length', () {
      expect(tuple.length, 9);
    });
    test('iterable', () {
      expect(
          tuple.iterable, <Object>[229, 246, 244, 122, 206, 164, 55, 173, 2]);
    });
    test('toList', () {
      expect(
          tuple.toList(), <Object>[229, 246, 244, 122, 206, 164, 55, 173, 2]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{229, 246, 244, 122, 206, 164, 55, 173, 2});
    });
    test('toString', () {
      expect(tuple.toString(), '(229, 246, 244, 122, 206, 164, 55, 173, 2)');
    });
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == tuple.with8(-1), isFalse);
// ignore: unrelated_type_equality_checks
      expect(tuple == tuple.with8('a'), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == tuple.hashCode, isTrue);
      expect(tuple.hashCode == tuple.with8(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.with8('a').hashCode, isFalse);
    });
  });
}
