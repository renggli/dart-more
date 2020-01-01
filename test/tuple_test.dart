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
      expect(other.first, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
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
// ignore: prefer_const_constructors
    final copy = Tuple0();
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
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
      expect(tuple.first, 26);
      expect(tuple.last, 26);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 26);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 26);
      expect(other.second, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 26);
      expect(other.second, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
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
    final copy = Tuple1(tuple.first);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
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
      expect(tuple.first, 142);
      expect(tuple.second, 224);
      expect(tuple.last, 224);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 224);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 142);
      expect(other.second, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 142);
      expect(other.second, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 142);
      expect(other.third, 224);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 142);
      expect(other.second, 'a');
      expect(other.third, 224);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 142);
      expect(other.second, 224);
      expect(other.third, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 142);
      expect(other.second, 224);
      expect(other.third, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 224);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 142);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 142);
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
    final copy = Tuple2(tuple.first, tuple.second);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
      expect(tuple == tuple.withSecond(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSecond(-1).hashCode, isFalse);
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
      expect(tuple.first, 39);
      expect(tuple.second, 140);
      expect(tuple.third, 220);
      expect(tuple.last, 220);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 140);
      expect(other.third, 220);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 39);
      expect(other.second, 'a');
      expect(other.third, 220);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 39);
      expect(other.second, 140);
      expect(other.third, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 39);
      expect(other.second, 140);
      expect(other.third, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 39);
      expect(other.third, 140);
      expect(other.fourth, 220);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 39);
      expect(other.second, 'a');
      expect(other.third, 140);
      expect(other.fourth, 220);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 39);
      expect(other.second, 140);
      expect(other.third, 'a');
      expect(other.fourth, 220);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 39);
      expect(other.second, 140);
      expect(other.third, 220);
      expect(other.fourth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 39);
      expect(other.second, 140);
      expect(other.third, 220);
      expect(other.fourth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 140);
      expect(other.second, 220);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 39);
      expect(other.second, 220);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 39);
      expect(other.second, 140);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 39);
      expect(other.second, 140);
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
    final copy = Tuple3(tuple.first, tuple.second, tuple.third);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
      expect(tuple == tuple.withSecond(-1), isFalse);
      expect(tuple == tuple.withThird(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSecond(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withThird(-1).hashCode, isFalse);
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
      expect(tuple.first, 178);
      expect(tuple.second, 209);
      expect(tuple.third, 198);
      expect(tuple.fourth, 186);
      expect(tuple.last, 186);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 209);
      expect(other.third, 198);
      expect(other.fourth, 186);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 178);
      expect(other.second, 'a');
      expect(other.third, 198);
      expect(other.fourth, 186);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 'a');
      expect(other.fourth, 186);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 198);
      expect(other.fourth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 198);
      expect(other.fourth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 178);
      expect(other.third, 209);
      expect(other.fourth, 198);
      expect(other.fifth, 186);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 178);
      expect(other.second, 'a');
      expect(other.third, 209);
      expect(other.fourth, 198);
      expect(other.fifth, 186);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 'a');
      expect(other.fourth, 198);
      expect(other.fifth, 186);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 198);
      expect(other.fourth, 'a');
      expect(other.fifth, 186);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 198);
      expect(other.fourth, 186);
      expect(other.fifth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 198);
      expect(other.fourth, 186);
      expect(other.fifth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 198);
      expect(other.third, 186);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 178);
      expect(other.second, 198);
      expect(other.third, 186);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 186);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 198);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 178);
      expect(other.second, 209);
      expect(other.third, 198);
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
    final copy = Tuple4(tuple.first, tuple.second, tuple.third, tuple.fourth);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
      expect(tuple == tuple.withSecond(-1), isFalse);
      expect(tuple == tuple.withThird(-1), isFalse);
      expect(tuple == tuple.withFourth(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSecond(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withThird(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFourth(-1).hashCode, isFalse);
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
      expect(tuple.first, 137);
      expect(tuple.second, 102);
      expect(tuple.third, 140);
      expect(tuple.fourth, 254);
      expect(tuple.fifth, 112);
      expect(tuple.last, 112);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 254);
      expect(other.fifth, 112);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 137);
      expect(other.second, 'a');
      expect(other.third, 140);
      expect(other.fourth, 254);
      expect(other.fifth, 112);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 'a');
      expect(other.fourth, 254);
      expect(other.fifth, 112);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 'a');
      expect(other.fifth, 112);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 254);
      expect(other.fifth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 254);
      expect(other.fifth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 137);
      expect(other.third, 102);
      expect(other.fourth, 140);
      expect(other.fifth, 254);
      expect(other.sixth, 112);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 137);
      expect(other.second, 'a');
      expect(other.third, 102);
      expect(other.fourth, 140);
      expect(other.fifth, 254);
      expect(other.sixth, 112);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 'a');
      expect(other.fourth, 140);
      expect(other.fifth, 254);
      expect(other.sixth, 112);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 'a');
      expect(other.fifth, 254);
      expect(other.sixth, 112);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 254);
      expect(other.fifth, 'a');
      expect(other.sixth, 112);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 254);
      expect(other.fifth, 112);
      expect(other.sixth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 254);
      expect(other.fifth, 112);
      expect(other.sixth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 102);
      expect(other.second, 140);
      expect(other.third, 254);
      expect(other.fourth, 112);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 137);
      expect(other.second, 140);
      expect(other.third, 254);
      expect(other.fourth, 112);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 254);
      expect(other.fourth, 112);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 112);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 254);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 137);
      expect(other.second, 102);
      expect(other.third, 140);
      expect(other.fourth, 254);
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
    final copy = Tuple5(
        tuple.first, tuple.second, tuple.third, tuple.fourth, tuple.fifth);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
      expect(tuple == tuple.withSecond(-1), isFalse);
      expect(tuple == tuple.withThird(-1), isFalse);
      expect(tuple == tuple.withFourth(-1), isFalse);
      expect(tuple == tuple.withFifth(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSecond(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withThird(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFourth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFifth(-1).hashCode, isFalse);
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
      expect(tuple.first, 108);
      expect(tuple.second, 217);
      expect(tuple.third, 93);
      expect(tuple.fourth, 20);
      expect(tuple.fifth, 166);
      expect(tuple.sixth, 21);
      expect(tuple.last, 21);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
      expect(other.sixth, 21);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 108);
      expect(other.second, 'a');
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
      expect(other.sixth, 21);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 'a');
      expect(other.fourth, 20);
      expect(other.fifth, 166);
      expect(other.sixth, 21);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 'a');
      expect(other.fifth, 166);
      expect(other.sixth, 21);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 'a');
      expect(other.sixth, 21);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
      expect(other.sixth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
      expect(other.sixth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 108);
      expect(other.third, 217);
      expect(other.fourth, 93);
      expect(other.fifth, 20);
      expect(other.sixth, 166);
      expect(other.seventh, 21);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 'a');
      expect(other.third, 217);
      expect(other.fourth, 93);
      expect(other.fifth, 20);
      expect(other.sixth, 166);
      expect(other.seventh, 21);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 'a');
      expect(other.fourth, 93);
      expect(other.fifth, 20);
      expect(other.sixth, 166);
      expect(other.seventh, 21);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 'a');
      expect(other.fifth, 20);
      expect(other.sixth, 166);
      expect(other.seventh, 21);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 'a');
      expect(other.sixth, 166);
      expect(other.seventh, 21);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
      expect(other.sixth, 'a');
      expect(other.seventh, 21);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
      expect(other.sixth, 21);
      expect(other.seventh, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
      expect(other.sixth, 21);
      expect(other.seventh, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 217);
      expect(other.second, 93);
      expect(other.third, 20);
      expect(other.fourth, 166);
      expect(other.fifth, 21);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 93);
      expect(other.third, 20);
      expect(other.fourth, 166);
      expect(other.fifth, 21);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 20);
      expect(other.fourth, 166);
      expect(other.fifth, 21);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 166);
      expect(other.fifth, 21);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 21);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 217);
      expect(other.third, 93);
      expect(other.fourth, 20);
      expect(other.fifth, 166);
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
    final copy = Tuple6(tuple.first, tuple.second, tuple.third, tuple.fourth,
        tuple.fifth, tuple.sixth);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
      expect(tuple == tuple.withSecond(-1), isFalse);
      expect(tuple == tuple.withThird(-1), isFalse);
      expect(tuple == tuple.withFourth(-1), isFalse);
      expect(tuple == tuple.withFifth(-1), isFalse);
      expect(tuple == tuple.withSixth(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSecond(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withThird(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFourth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFifth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSixth(-1).hashCode, isFalse);
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
      expect(tuple.first, 138);
      expect(tuple.second, 191);
      expect(tuple.third, 17);
      expect(tuple.fourth, 53);
      expect(tuple.fifth, 115);
      expect(tuple.sixth, 80);
      expect(tuple.seventh, 129);
      expect(tuple.last, 129);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 129);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 138);
      expect(other.second, 'a');
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 129);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 'a');
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 129);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 'a');
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 129);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 'a');
      expect(other.sixth, 80);
      expect(other.seventh, 129);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 'a');
      expect(other.seventh, 129);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 138);
      expect(other.third, 191);
      expect(other.fourth, 17);
      expect(other.fifth, 53);
      expect(other.sixth, 115);
      expect(other.seventh, 80);
      expect(other.eighth, 129);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 138);
      expect(other.second, 'a');
      expect(other.third, 191);
      expect(other.fourth, 17);
      expect(other.fifth, 53);
      expect(other.sixth, 115);
      expect(other.seventh, 80);
      expect(other.eighth, 129);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 'a');
      expect(other.fourth, 17);
      expect(other.fifth, 53);
      expect(other.sixth, 115);
      expect(other.seventh, 80);
      expect(other.eighth, 129);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 'a');
      expect(other.fifth, 53);
      expect(other.sixth, 115);
      expect(other.seventh, 80);
      expect(other.eighth, 129);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 'a');
      expect(other.sixth, 115);
      expect(other.seventh, 80);
      expect(other.eighth, 129);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 'a');
      expect(other.seventh, 80);
      expect(other.eighth, 129);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 'a');
      expect(other.eighth, 129);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 129);
      expect(other.eighth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
      expect(other.seventh, 129);
      expect(other.eighth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 191);
      expect(other.second, 17);
      expect(other.third, 53);
      expect(other.fourth, 115);
      expect(other.fifth, 80);
      expect(other.sixth, 129);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 138);
      expect(other.second, 17);
      expect(other.third, 53);
      expect(other.fourth, 115);
      expect(other.fifth, 80);
      expect(other.sixth, 129);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 53);
      expect(other.fourth, 115);
      expect(other.fifth, 80);
      expect(other.sixth, 129);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 115);
      expect(other.fifth, 80);
      expect(other.sixth, 129);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 80);
      expect(other.sixth, 129);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 129);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 138);
      expect(other.second, 191);
      expect(other.third, 17);
      expect(other.fourth, 53);
      expect(other.fifth, 115);
      expect(other.sixth, 80);
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
    final copy = Tuple7(tuple.first, tuple.second, tuple.third, tuple.fourth,
        tuple.fifth, tuple.sixth, tuple.seventh);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
      expect(tuple == tuple.withSecond(-1), isFalse);
      expect(tuple == tuple.withThird(-1), isFalse);
      expect(tuple == tuple.withFourth(-1), isFalse);
      expect(tuple == tuple.withFifth(-1), isFalse);
      expect(tuple == tuple.withSixth(-1), isFalse);
      expect(tuple == tuple.withSeventh(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSecond(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withThird(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFourth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFifth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSixth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSeventh(-1).hashCode, isFalse);
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
      expect(tuple.first, 4);
      expect(tuple.second, 238);
      expect(tuple.third, 254);
      expect(tuple.fourth, 200);
      expect(tuple.fifth, 37);
      expect(tuple.sixth, 244);
      expect(tuple.seventh, 31);
      expect(tuple.eighth, 234);
      expect(tuple.last, 234);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 234);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 4);
      expect(other.second, 'a');
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 234);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 'a');
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 234);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 'a');
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 234);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 'a');
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 234);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 'a');
      expect(other.seventh, 31);
      expect(other.eighth, 234);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 'a');
      expect(other.eighth, 234);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
      expect(other.ninth, 234);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 'a');
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
      expect(other.ninth, 234);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 'a');
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
      expect(other.ninth, 234);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 'a');
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
      expect(other.ninth, 234);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 'a');
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
      expect(other.ninth, 234);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 'a');
      expect(other.seventh, 244);
      expect(other.eighth, 31);
      expect(other.ninth, 234);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 'a');
      expect(other.eighth, 31);
      expect(other.ninth, 234);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 'a');
      expect(other.ninth, 234);
    });
    test('addNinth', () {
      final other = tuple.addNinth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 234);
      expect(other.ninth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
      expect(other.eighth, 234);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 238);
      expect(other.second, 254);
      expect(other.third, 200);
      expect(other.fourth, 37);
      expect(other.fifth, 244);
      expect(other.sixth, 31);
      expect(other.seventh, 234);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 254);
      expect(other.third, 200);
      expect(other.fourth, 37);
      expect(other.fifth, 244);
      expect(other.sixth, 31);
      expect(other.seventh, 234);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 200);
      expect(other.fourth, 37);
      expect(other.fifth, 244);
      expect(other.sixth, 31);
      expect(other.seventh, 234);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 37);
      expect(other.fifth, 244);
      expect(other.sixth, 31);
      expect(other.seventh, 234);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 244);
      expect(other.sixth, 31);
      expect(other.seventh, 234);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 31);
      expect(other.seventh, 234);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 234);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
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
    final copy = Tuple8(tuple.first, tuple.second, tuple.third, tuple.fourth,
        tuple.fifth, tuple.sixth, tuple.seventh, tuple.eighth);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
      expect(tuple == tuple.withSecond(-1), isFalse);
      expect(tuple == tuple.withThird(-1), isFalse);
      expect(tuple == tuple.withFourth(-1), isFalse);
      expect(tuple == tuple.withFifth(-1), isFalse);
      expect(tuple == tuple.withSixth(-1), isFalse);
      expect(tuple == tuple.withSeventh(-1), isFalse);
      expect(tuple == tuple.withEighth(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSecond(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withThird(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFourth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFifth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSixth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSeventh(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withEighth(-1).hashCode, isFalse);
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
      expect(tuple.first, 229);
      expect(tuple.second, 246);
      expect(tuple.third, 244);
      expect(tuple.fourth, 122);
      expect(tuple.fifth, 206);
      expect(tuple.sixth, 164);
      expect(tuple.seventh, 55);
      expect(tuple.eighth, 173);
      expect(tuple.ninth, 2);
      expect(tuple.last, 2);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
      expect(other.ninth, 2);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 229);
      expect(other.second, 'a');
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
      expect(other.ninth, 2);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 'a');
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
      expect(other.ninth, 2);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 'a');
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
      expect(other.ninth, 2);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 'a');
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
      expect(other.ninth, 2);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 'a');
      expect(other.seventh, 55);
      expect(other.eighth, 173);
      expect(other.ninth, 2);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 'a');
      expect(other.eighth, 173);
      expect(other.ninth, 2);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 'a');
      expect(other.ninth, 2);
    });
    test('withNinth', () {
      final other = tuple.withNinth('a');
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
      expect(other.ninth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 246);
      expect(other.second, 244);
      expect(other.third, 122);
      expect(other.fourth, 206);
      expect(other.fifth, 164);
      expect(other.sixth, 55);
      expect(other.seventh, 173);
      expect(other.eighth, 2);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 244);
      expect(other.third, 122);
      expect(other.fourth, 206);
      expect(other.fifth, 164);
      expect(other.sixth, 55);
      expect(other.seventh, 173);
      expect(other.eighth, 2);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 122);
      expect(other.fourth, 206);
      expect(other.fifth, 164);
      expect(other.sixth, 55);
      expect(other.seventh, 173);
      expect(other.eighth, 2);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 206);
      expect(other.fifth, 164);
      expect(other.sixth, 55);
      expect(other.seventh, 173);
      expect(other.eighth, 2);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 164);
      expect(other.sixth, 55);
      expect(other.seventh, 173);
      expect(other.eighth, 2);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 55);
      expect(other.seventh, 173);
      expect(other.eighth, 2);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 173);
      expect(other.eighth, 2);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 2);
    });
    test('removeNinth', () {
      final other = tuple.removeNinth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 229);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
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
    final copy = Tuple9(tuple.first, tuple.second, tuple.third, tuple.fourth,
        tuple.fifth, tuple.sixth, tuple.seventh, tuple.eighth, tuple.ninth);
    test('equals', () {
      expect(tuple == tuple, isTrue);
      expect(tuple == copy, isTrue);
      expect(copy == tuple, isTrue);
      expect(tuple == tuple.withFirst(-1), isFalse);
      expect(tuple == tuple.withSecond(-1), isFalse);
      expect(tuple == tuple.withThird(-1), isFalse);
      expect(tuple == tuple.withFourth(-1), isFalse);
      expect(tuple == tuple.withFifth(-1), isFalse);
      expect(tuple == tuple.withSixth(-1), isFalse);
      expect(tuple == tuple.withSeventh(-1), isFalse);
      expect(tuple == tuple.withEighth(-1), isFalse);
      expect(tuple == tuple.withNinth(-1), isFalse);
    });
    test('hashCode', () {
      expect(tuple.hashCode == copy.hashCode, isTrue);
      expect(tuple.hashCode == tuple.withFirst(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSecond(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withThird(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFourth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withFifth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSixth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withSeventh(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withEighth(-1).hashCode, isFalse);
      expect(tuple.hashCode == tuple.withNinth(-1).hashCode, isFalse);
    });
  });
}
