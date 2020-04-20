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
          () => Tuple.fromList([174, 196, 93, 181, 104, 143, 61, 48, 184, 255]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple0.fromList([]);
      expect(other, tuple);
      expect(() => Tuple0.fromList([228]), throwsArgumentError);
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
    const tuple = Tuple1(51);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([51]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([115, 77, 26, 167, 89, 231, 174, 164, 26, 79]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple1.fromList([51]);
      expect(other, tuple);
      expect(() => Tuple1.fromList([32, 90]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 51);
      expect(tuple.last, 51);
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
      expect(other.second, 51);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 51);
      expect(other.second, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 51);
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
      expect(tuple.iterable, <Object>[51]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[51]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{51});
    });
    test('toString', () {
      expect(tuple.toString(), '(51)');
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
    const tuple = Tuple2(100, 110);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([100, 110]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([80, 160, 85, 136, 148, 159, 123, 142, 224, 17]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple2.fromList([100, 110]);
      expect(other, tuple);
      expect(() => Tuple2.fromList([183, 144, 195]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 100);
      expect(tuple.second, 110);
      expect(tuple.last, 110);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 110);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 100);
      expect(other.second, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 100);
      expect(other.second, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 100);
      expect(other.third, 110);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 100);
      expect(other.second, 'a');
      expect(other.third, 110);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 100);
      expect(other.second, 110);
      expect(other.third, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 100);
      expect(other.second, 110);
      expect(other.third, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 110);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 100);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 100);
    });
    test('length', () {
      expect(tuple.length, 2);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[100, 110]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[100, 110]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{100, 110});
    });
    test('toString', () {
      expect(tuple.toString(), '(100, 110)');
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
    const tuple = Tuple3(3, 174, 10);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([3, 174, 10]);
      expect(other, tuple);
      expect(
          () =>
              Tuple.fromList([221, 217, 145, 204, 250, 23, 39, 140, 220, 127]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple3.fromList([3, 174, 10]);
      expect(other, tuple);
      expect(() => Tuple3.fromList([11, 73, 27, 195]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 3);
      expect(tuple.second, 174);
      expect(tuple.third, 10);
      expect(tuple.last, 10);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 174);
      expect(other.third, 10);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 3);
      expect(other.second, 'a');
      expect(other.third, 10);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 3);
      expect(other.second, 174);
      expect(other.third, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 3);
      expect(other.second, 174);
      expect(other.third, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 3);
      expect(other.third, 174);
      expect(other.fourth, 10);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 3);
      expect(other.second, 'a');
      expect(other.third, 174);
      expect(other.fourth, 10);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 3);
      expect(other.second, 174);
      expect(other.third, 'a');
      expect(other.fourth, 10);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 3);
      expect(other.second, 174);
      expect(other.third, 10);
      expect(other.fourth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 3);
      expect(other.second, 174);
      expect(other.third, 10);
      expect(other.fourth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 174);
      expect(other.second, 10);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 3);
      expect(other.second, 10);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 3);
      expect(other.second, 174);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 3);
      expect(other.second, 174);
    });
    test('length', () {
      expect(tuple.length, 3);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[3, 174, 10]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[3, 174, 10]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{3, 174, 10});
    });
    test('toString', () {
      expect(tuple.toString(), '(3, 174, 10)');
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
    const tuple = Tuple4(133, 23, 42, 211);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([133, 23, 42, 211]);
      expect(other, tuple);
      expect(
          () =>
              Tuple.fromList([158, 121, 55, 119, 54, 178, 209, 198, 186, 130]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple4.fromList([133, 23, 42, 211]);
      expect(other, tuple);
      expect(
          () => Tuple4.fromList([155, 175, 159, 93, 164]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 133);
      expect(tuple.second, 23);
      expect(tuple.third, 42);
      expect(tuple.fourth, 211);
      expect(tuple.last, 211);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 23);
      expect(other.third, 42);
      expect(other.fourth, 211);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 133);
      expect(other.second, 'a');
      expect(other.third, 42);
      expect(other.fourth, 211);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 'a');
      expect(other.fourth, 211);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 42);
      expect(other.fourth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 42);
      expect(other.fourth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 133);
      expect(other.second, 'a');
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 'a');
      expect(other.fourth, 42);
      expect(other.fifth, 211);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 42);
      expect(other.fourth, 'a');
      expect(other.fifth, 211);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 42);
      expect(other.fourth, 211);
      expect(other.fifth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 42);
      expect(other.fourth, 211);
      expect(other.fifth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 23);
      expect(other.second, 42);
      expect(other.third, 211);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 133);
      expect(other.second, 42);
      expect(other.third, 211);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 211);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 42);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 42);
    });
    test('length', () {
      expect(tuple.length, 4);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[133, 23, 42, 211]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[133, 23, 42, 211]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{133, 23, 42, 211});
    });
    test('toString', () {
      expect(tuple.toString(), '(133, 23, 42, 211)');
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
    const tuple = Tuple5(180, 175, 192, 242, 32);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([180, 175, 192, 242, 32]);
      expect(other, tuple);
      expect(
          () =>
              Tuple.fromList([108, 10, 131, 83, 137, 102, 140, 254, 112, 223]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple5.fromList([180, 175, 192, 242, 32]);
      expect(other, tuple);
      expect(
          () => Tuple5.fromList([77, 47, 35, 113, 0, 0]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 180);
      expect(tuple.second, 175);
      expect(tuple.third, 192);
      expect(tuple.fourth, 242);
      expect(tuple.fifth, 32);
      expect(tuple.last, 32);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 242);
      expect(other.fifth, 32);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 180);
      expect(other.second, 'a');
      expect(other.third, 192);
      expect(other.fourth, 242);
      expect(other.fifth, 32);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 'a');
      expect(other.fourth, 242);
      expect(other.fifth, 32);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 'a');
      expect(other.fifth, 32);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 242);
      expect(other.fifth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 242);
      expect(other.fifth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 180);
      expect(other.third, 175);
      expect(other.fourth, 192);
      expect(other.fifth, 242);
      expect(other.sixth, 32);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 180);
      expect(other.second, 'a');
      expect(other.third, 175);
      expect(other.fourth, 192);
      expect(other.fifth, 242);
      expect(other.sixth, 32);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 'a');
      expect(other.fourth, 192);
      expect(other.fifth, 242);
      expect(other.sixth, 32);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 'a');
      expect(other.fifth, 242);
      expect(other.sixth, 32);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 242);
      expect(other.fifth, 'a');
      expect(other.sixth, 32);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 242);
      expect(other.fifth, 32);
      expect(other.sixth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 242);
      expect(other.fifth, 32);
      expect(other.sixth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 175);
      expect(other.second, 192);
      expect(other.third, 242);
      expect(other.fourth, 32);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 180);
      expect(other.second, 192);
      expect(other.third, 242);
      expect(other.fourth, 32);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 242);
      expect(other.fourth, 32);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 32);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 242);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 180);
      expect(other.second, 175);
      expect(other.third, 192);
      expect(other.fourth, 242);
    });
    test('length', () {
      expect(tuple.length, 5);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[180, 175, 192, 242, 32]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[180, 175, 192, 242, 32]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{180, 175, 192, 242, 32});
    });
    test('toString', () {
      expect(tuple.toString(), '(180, 175, 192, 242, 32)');
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
    const tuple = Tuple6(237, 45, 241, 0, 46, 5);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([237, 45, 241, 0, 46, 5]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([70, 64, 157, 108, 217, 93, 20, 166, 21, 181]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple6.fromList([237, 45, 241, 0, 46, 5]);
      expect(other, tuple);
      expect(() => Tuple6.fromList([57, 70, 180, 1, 60, 182, 117]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 237);
      expect(tuple.second, 45);
      expect(tuple.third, 241);
      expect(tuple.fourth, 0);
      expect(tuple.fifth, 46);
      expect(tuple.sixth, 5);
      expect(tuple.last, 5);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
      expect(other.sixth, 5);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 237);
      expect(other.second, 'a');
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
      expect(other.sixth, 5);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 'a');
      expect(other.fourth, 0);
      expect(other.fifth, 46);
      expect(other.sixth, 5);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 'a');
      expect(other.fifth, 46);
      expect(other.sixth, 5);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 'a');
      expect(other.sixth, 5);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
      expect(other.sixth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
      expect(other.sixth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 237);
      expect(other.third, 45);
      expect(other.fourth, 241);
      expect(other.fifth, 0);
      expect(other.sixth, 46);
      expect(other.seventh, 5);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 237);
      expect(other.second, 'a');
      expect(other.third, 45);
      expect(other.fourth, 241);
      expect(other.fifth, 0);
      expect(other.sixth, 46);
      expect(other.seventh, 5);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 'a');
      expect(other.fourth, 241);
      expect(other.fifth, 0);
      expect(other.sixth, 46);
      expect(other.seventh, 5);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 'a');
      expect(other.fifth, 0);
      expect(other.sixth, 46);
      expect(other.seventh, 5);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 'a');
      expect(other.sixth, 46);
      expect(other.seventh, 5);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
      expect(other.sixth, 'a');
      expect(other.seventh, 5);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
      expect(other.sixth, 5);
      expect(other.seventh, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
      expect(other.sixth, 5);
      expect(other.seventh, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 237);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 5);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 237);
      expect(other.second, 45);
      expect(other.third, 241);
      expect(other.fourth, 0);
      expect(other.fifth, 46);
    });
    test('length', () {
      expect(tuple.length, 6);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[237, 45, 241, 0, 46, 5]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[237, 45, 241, 0, 46, 5]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{237, 45, 241, 0, 46, 5});
    });
    test('toString', () {
      expect(tuple.toString(), '(237, 45, 241, 0, 46, 5)');
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
    const tuple = Tuple7(95, 32, 200, 176, 125, 21, 81);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([95, 32, 200, 176, 125, 21, 81]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([171, 110, 138, 191, 17, 53, 115, 80, 129, 100]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple7.fromList([95, 32, 200, 176, 125, 21, 81]);
      expect(other, tuple);
      expect(() => Tuple7.fromList([144, 152, 96, 72, 32, 127, 39, 236]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 95);
      expect(tuple.second, 32);
      expect(tuple.third, 200);
      expect(tuple.fourth, 176);
      expect(tuple.fifth, 125);
      expect(tuple.sixth, 21);
      expect(tuple.seventh, 81);
      expect(tuple.last, 81);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 81);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 95);
      expect(other.second, 'a');
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 81);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 'a');
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 81);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 'a');
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 81);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 'a');
      expect(other.sixth, 21);
      expect(other.seventh, 81);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 'a');
      expect(other.seventh, 81);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 95);
      expect(other.third, 32);
      expect(other.fourth, 200);
      expect(other.fifth, 176);
      expect(other.sixth, 125);
      expect(other.seventh, 21);
      expect(other.eighth, 81);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 95);
      expect(other.second, 'a');
      expect(other.third, 32);
      expect(other.fourth, 200);
      expect(other.fifth, 176);
      expect(other.sixth, 125);
      expect(other.seventh, 21);
      expect(other.eighth, 81);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 'a');
      expect(other.fourth, 200);
      expect(other.fifth, 176);
      expect(other.sixth, 125);
      expect(other.seventh, 21);
      expect(other.eighth, 81);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 'a');
      expect(other.fifth, 176);
      expect(other.sixth, 125);
      expect(other.seventh, 21);
      expect(other.eighth, 81);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 'a');
      expect(other.sixth, 125);
      expect(other.seventh, 21);
      expect(other.eighth, 81);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 'a');
      expect(other.seventh, 21);
      expect(other.eighth, 81);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 'a');
      expect(other.eighth, 81);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 81);
      expect(other.eighth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
      expect(other.seventh, 81);
      expect(other.eighth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 200);
      expect(other.third, 176);
      expect(other.fourth, 125);
      expect(other.fifth, 21);
      expect(other.sixth, 81);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 95);
      expect(other.second, 200);
      expect(other.third, 176);
      expect(other.fourth, 125);
      expect(other.fifth, 21);
      expect(other.sixth, 81);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 176);
      expect(other.fourth, 125);
      expect(other.fifth, 21);
      expect(other.sixth, 81);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 125);
      expect(other.fifth, 21);
      expect(other.sixth, 81);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 21);
      expect(other.sixth, 81);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 81);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 95);
      expect(other.second, 32);
      expect(other.third, 200);
      expect(other.fourth, 176);
      expect(other.fifth, 125);
      expect(other.sixth, 21);
    });
    test('length', () {
      expect(tuple.length, 7);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[95, 32, 200, 176, 125, 21, 81]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[95, 32, 200, 176, 125, 21, 81]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{95, 32, 200, 176, 125, 21, 81});
    });
    test('toString', () {
      expect(tuple.toString(), '(95, 32, 200, 176, 125, 21, 81)');
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
    const tuple = Tuple8(171, 122, 66, 13, 78, 228, 183, 153);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([171, 122, 66, 13, 78, 228, 183, 153]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([63, 4, 238, 254, 200, 37, 244, 31, 234, 132]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple8.fromList([171, 122, 66, 13, 78, 228, 183, 153]);
      expect(other, tuple);
      expect(() => Tuple8.fromList([24, 19, 211, 220, 206, 56, 54, 10, 16]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 171);
      expect(tuple.second, 122);
      expect(tuple.third, 66);
      expect(tuple.fourth, 13);
      expect(tuple.fifth, 78);
      expect(tuple.sixth, 228);
      expect(tuple.seventh, 183);
      expect(tuple.eighth, 153);
      expect(tuple.last, 153);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 153);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 171);
      expect(other.second, 'a');
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 153);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 'a');
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 153);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 'a');
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 153);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 'a');
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 153);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 'a');
      expect(other.seventh, 183);
      expect(other.eighth, 153);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 'a');
      expect(other.eighth, 153);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 171);
      expect(other.third, 122);
      expect(other.fourth, 66);
      expect(other.fifth, 13);
      expect(other.sixth, 78);
      expect(other.seventh, 228);
      expect(other.eighth, 183);
      expect(other.ninth, 153);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 'a');
      expect(other.third, 122);
      expect(other.fourth, 66);
      expect(other.fifth, 13);
      expect(other.sixth, 78);
      expect(other.seventh, 228);
      expect(other.eighth, 183);
      expect(other.ninth, 153);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 'a');
      expect(other.fourth, 66);
      expect(other.fifth, 13);
      expect(other.sixth, 78);
      expect(other.seventh, 228);
      expect(other.eighth, 183);
      expect(other.ninth, 153);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 'a');
      expect(other.fifth, 13);
      expect(other.sixth, 78);
      expect(other.seventh, 228);
      expect(other.eighth, 183);
      expect(other.ninth, 153);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 'a');
      expect(other.sixth, 78);
      expect(other.seventh, 228);
      expect(other.eighth, 183);
      expect(other.ninth, 153);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 'a');
      expect(other.seventh, 228);
      expect(other.eighth, 183);
      expect(other.ninth, 153);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 'a');
      expect(other.eighth, 183);
      expect(other.ninth, 153);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 'a');
      expect(other.ninth, 153);
    });
    test('addNinth', () {
      final other = tuple.addNinth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 153);
      expect(other.ninth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
      expect(other.eighth, 153);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 122);
      expect(other.second, 66);
      expect(other.third, 13);
      expect(other.fourth, 78);
      expect(other.fifth, 228);
      expect(other.sixth, 183);
      expect(other.seventh, 153);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 66);
      expect(other.third, 13);
      expect(other.fourth, 78);
      expect(other.fifth, 228);
      expect(other.sixth, 183);
      expect(other.seventh, 153);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 13);
      expect(other.fourth, 78);
      expect(other.fifth, 228);
      expect(other.sixth, 183);
      expect(other.seventh, 153);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 78);
      expect(other.fifth, 228);
      expect(other.sixth, 183);
      expect(other.seventh, 153);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 228);
      expect(other.sixth, 183);
      expect(other.seventh, 153);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 183);
      expect(other.seventh, 153);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 153);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 122);
      expect(other.third, 66);
      expect(other.fourth, 13);
      expect(other.fifth, 78);
      expect(other.sixth, 228);
      expect(other.seventh, 183);
    });
    test('length', () {
      expect(tuple.length, 8);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[171, 122, 66, 13, 78, 228, 183, 153]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[171, 122, 66, 13, 78, 228, 183, 153]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{171, 122, 66, 13, 78, 228, 183, 153});
    });
    test('toString', () {
      expect(tuple.toString(), '(171, 122, 66, 13, 78, 228, 183, 153)');
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
    const tuple = Tuple9(9, 219, 36, 6, 81, 93, 76, 9, 209);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([9, 219, 36, 6, 81, 93, 76, 9, 209]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([229, 246, 244, 122, 206, 164, 55, 173, 2, 172]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple9.fromList([9, 219, 36, 6, 81, 93, 76, 9, 209]);
      expect(other, tuple);
      expect(
          () =>
              Tuple9.fromList([190, 123, 156, 135, 27, 188, 100, 29, 17, 134]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 9);
      expect(tuple.second, 219);
      expect(tuple.third, 36);
      expect(tuple.fourth, 6);
      expect(tuple.fifth, 81);
      expect(tuple.sixth, 93);
      expect(tuple.seventh, 76);
      expect(tuple.eighth, 9);
      expect(tuple.ninth, 209);
      expect(tuple.last, 209);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
      expect(other.ninth, 209);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 9);
      expect(other.second, 'a');
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
      expect(other.ninth, 209);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 'a');
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
      expect(other.ninth, 209);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 'a');
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
      expect(other.ninth, 209);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 'a');
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
      expect(other.ninth, 209);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 'a');
      expect(other.seventh, 76);
      expect(other.eighth, 9);
      expect(other.ninth, 209);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 'a');
      expect(other.eighth, 9);
      expect(other.ninth, 209);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 'a');
      expect(other.ninth, 209);
    });
    test('withNinth', () {
      final other = tuple.withNinth('a');
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
      expect(other.ninth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 219);
      expect(other.second, 36);
      expect(other.third, 6);
      expect(other.fourth, 81);
      expect(other.fifth, 93);
      expect(other.sixth, 76);
      expect(other.seventh, 9);
      expect(other.eighth, 209);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 36);
      expect(other.third, 6);
      expect(other.fourth, 81);
      expect(other.fifth, 93);
      expect(other.sixth, 76);
      expect(other.seventh, 9);
      expect(other.eighth, 209);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 6);
      expect(other.fourth, 81);
      expect(other.fifth, 93);
      expect(other.sixth, 76);
      expect(other.seventh, 9);
      expect(other.eighth, 209);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 81);
      expect(other.fifth, 93);
      expect(other.sixth, 76);
      expect(other.seventh, 9);
      expect(other.eighth, 209);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 93);
      expect(other.sixth, 76);
      expect(other.seventh, 9);
      expect(other.eighth, 209);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 76);
      expect(other.seventh, 9);
      expect(other.eighth, 209);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 9);
      expect(other.eighth, 209);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 209);
    });
    test('removeNinth', () {
      final other = tuple.removeNinth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 9);
      expect(other.second, 219);
      expect(other.third, 36);
      expect(other.fourth, 6);
      expect(other.fifth, 81);
      expect(other.sixth, 93);
      expect(other.seventh, 76);
      expect(other.eighth, 9);
    });
    test('length', () {
      expect(tuple.length, 9);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[9, 219, 36, 6, 81, 93, 76, 9, 209]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[9, 219, 36, 6, 81, 93, 76, 9, 209]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{9, 219, 36, 6, 81, 93, 76, 9, 209});
    });
    test('toString', () {
      expect(tuple.toString(), '(9, 219, 36, 6, 81, 93, 76, 9, 209)');
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
