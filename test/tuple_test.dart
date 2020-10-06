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
    test('map', () {
      expect(tuple.map(() => 819), 819);
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
    const tuple = Tuple1(115);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([115]);
      expect(other, tuple);
      expect(() => Tuple.fromList([77, 26, 167, 89, 231, 174, 164, 26, 79, 32]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple1.fromList([115]);
      expect(other, tuple);
      expect(() => Tuple1.fromList([90, 100]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 115);
      expect(tuple.last, 115);
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
      expect(other.second, 115);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 115);
      expect(other.second, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 115);
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
      expect(tuple.iterable, <Object>[115]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[115]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{115});
    });
    test('map', () {
      expect(tuple.map((first) {
        expect(first, 115);
        return 366;
      }), 366);
    });
    test('toString', () {
      expect(tuple.toString(), '(115)');
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
    const tuple = Tuple2(80, 160);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([80, 160]);
      expect(other, tuple);
      expect(
          () =>
              Tuple.fromList([85, 136, 148, 159, 123, 142, 224, 17, 183, 144]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple2.fromList([80, 160]);
      expect(other, tuple);
      expect(() => Tuple2.fromList([195, 3, 174]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 80);
      expect(tuple.second, 160);
      expect(tuple.last, 160);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 160);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 80);
      expect(other.second, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 80);
      expect(other.second, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 80);
      expect(other.third, 160);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 80);
      expect(other.second, 'a');
      expect(other.third, 160);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 80);
      expect(other.second, 160);
      expect(other.third, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 80);
      expect(other.second, 160);
      expect(other.third, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 160);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 80);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 80);
    });
    test('length', () {
      expect(tuple.length, 2);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[80, 160]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[80, 160]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{80, 160});
    });
    test('map', () {
      expect(tuple.map((first, second) {
        expect(first, 80);
        expect(second, 160);
        return 266;
      }), 266);
    });
    test('toString', () {
      expect(tuple.toString(), '(80, 160)');
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
    const tuple = Tuple3(221, 217, 145);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([221, 217, 145]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([204, 250, 23, 39, 140, 220, 127, 11, 73, 27]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple3.fromList([221, 217, 145]);
      expect(other, tuple);
      expect(() => Tuple3.fromList([195, 133, 23, 42]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 221);
      expect(tuple.second, 217);
      expect(tuple.third, 145);
      expect(tuple.last, 145);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 217);
      expect(other.third, 145);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 221);
      expect(other.second, 'a');
      expect(other.third, 145);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 221);
      expect(other.second, 217);
      expect(other.third, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 221);
      expect(other.second, 217);
      expect(other.third, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 221);
      expect(other.second, 'a');
      expect(other.third, 217);
      expect(other.fourth, 145);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 221);
      expect(other.second, 217);
      expect(other.third, 'a');
      expect(other.fourth, 145);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 221);
      expect(other.second, 217);
      expect(other.third, 145);
      expect(other.fourth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 221);
      expect(other.second, 217);
      expect(other.third, 145);
      expect(other.fourth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 217);
      expect(other.second, 145);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 221);
      expect(other.second, 145);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 221);
      expect(other.second, 217);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 221);
      expect(other.second, 217);
    });
    test('length', () {
      expect(tuple.length, 3);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[221, 217, 145]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[221, 217, 145]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{221, 217, 145});
    });
    test('map', () {
      expect(tuple.map((first, second, third) {
        expect(first, 221);
        expect(second, 217);
        expect(third, 145);
        return 467;
      }), 467);
    });
    test('toString', () {
      expect(tuple.toString(), '(221, 217, 145)');
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
    const tuple = Tuple4(158, 121, 55, 119);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([158, 121, 55, 119]);
      expect(other, tuple);
      expect(
          () =>
              Tuple.fromList([54, 178, 209, 198, 186, 130, 155, 175, 159, 93]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple4.fromList([158, 121, 55, 119]);
      expect(other, tuple);
      expect(() => Tuple4.fromList([164, 180, 175, 192, 242]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 158);
      expect(tuple.second, 121);
      expect(tuple.third, 55);
      expect(tuple.fourth, 119);
      expect(tuple.last, 119);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 121);
      expect(other.third, 55);
      expect(other.fourth, 119);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 158);
      expect(other.second, 'a');
      expect(other.third, 55);
      expect(other.fourth, 119);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 'a');
      expect(other.fourth, 119);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 55);
      expect(other.fourth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 55);
      expect(other.fourth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 158);
      expect(other.third, 121);
      expect(other.fourth, 55);
      expect(other.fifth, 119);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 158);
      expect(other.second, 'a');
      expect(other.third, 121);
      expect(other.fourth, 55);
      expect(other.fifth, 119);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 'a');
      expect(other.fourth, 55);
      expect(other.fifth, 119);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 55);
      expect(other.fourth, 'a');
      expect(other.fifth, 119);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 55);
      expect(other.fourth, 119);
      expect(other.fifth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 55);
      expect(other.fourth, 119);
      expect(other.fifth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 121);
      expect(other.second, 55);
      expect(other.third, 119);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 158);
      expect(other.second, 55);
      expect(other.third, 119);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 119);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 55);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 55);
    });
    test('length', () {
      expect(tuple.length, 4);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[158, 121, 55, 119]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[158, 121, 55, 119]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{158, 121, 55, 119});
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth) {
        expect(first, 158);
        expect(second, 121);
        expect(third, 55);
        expect(fourth, 119);
        return 32;
      }), 32);
    });
    test('toString', () {
      expect(tuple.toString(), '(158, 121, 55, 119)');
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
    const tuple = Tuple5(108, 10, 131, 83, 137);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([108, 10, 131, 83, 137]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([102, 140, 254, 112, 223, 77, 47, 35, 113, 0]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple5.fromList([108, 10, 131, 83, 137]);
      expect(other, tuple);
      expect(
          () => Tuple5.fromList([0, 237, 45, 241, 0, 46]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 108);
      expect(tuple.second, 10);
      expect(tuple.third, 131);
      expect(tuple.fourth, 83);
      expect(tuple.fifth, 137);
      expect(tuple.last, 137);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 137);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 108);
      expect(other.second, 'a');
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 137);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 'a');
      expect(other.fourth, 83);
      expect(other.fifth, 137);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 'a');
      expect(other.fifth, 137);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 'a');
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 'a');
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 'a');
      expect(other.fifth, 83);
      expect(other.sixth, 137);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 'a');
      expect(other.sixth, 137);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 137);
      expect(other.sixth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 137);
      expect(other.sixth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 131);
      expect(other.third, 83);
      expect(other.fourth, 137);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 131);
      expect(other.third, 83);
      expect(other.fourth, 137);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 83);
      expect(other.fourth, 137);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 137);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
    });
    test('length', () {
      expect(tuple.length, 5);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[108, 10, 131, 83, 137]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[108, 10, 131, 83, 137]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{108, 10, 131, 83, 137});
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth) {
        expect(first, 108);
        expect(second, 10);
        expect(third, 131);
        expect(fourth, 83);
        expect(fifth, 137);
        return 773;
      }), 773);
    });
    test('toString', () {
      expect(tuple.toString(), '(108, 10, 131, 83, 137)');
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
    const tuple = Tuple6(70, 64, 157, 108, 217, 93);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([70, 64, 157, 108, 217, 93]);
      expect(other, tuple);
      expect(() => Tuple.fromList([20, 166, 21, 181, 57, 70, 180, 1, 60, 182]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple6.fromList([70, 64, 157, 108, 217, 93]);
      expect(other, tuple);
      expect(() => Tuple6.fromList([117, 95, 32, 200, 176, 125, 21]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 70);
      expect(tuple.second, 64);
      expect(tuple.third, 157);
      expect(tuple.fourth, 108);
      expect(tuple.fifth, 217);
      expect(tuple.sixth, 93);
      expect(tuple.last, 93);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
      expect(other.sixth, 93);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 70);
      expect(other.second, 'a');
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
      expect(other.sixth, 93);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 'a');
      expect(other.fourth, 108);
      expect(other.fifth, 217);
      expect(other.sixth, 93);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 'a');
      expect(other.fifth, 217);
      expect(other.sixth, 93);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 'a');
      expect(other.sixth, 93);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
      expect(other.sixth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
      expect(other.sixth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 217);
      expect(other.seventh, 93);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 70);
      expect(other.second, 'a');
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 217);
      expect(other.seventh, 93);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 'a');
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 217);
      expect(other.seventh, 93);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 'a');
      expect(other.fifth, 108);
      expect(other.sixth, 217);
      expect(other.seventh, 93);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 'a');
      expect(other.sixth, 217);
      expect(other.seventh, 93);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
      expect(other.sixth, 'a');
      expect(other.seventh, 93);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
      expect(other.sixth, 93);
      expect(other.seventh, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
      expect(other.sixth, 93);
      expect(other.seventh, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 64);
      expect(other.second, 157);
      expect(other.third, 108);
      expect(other.fourth, 217);
      expect(other.fifth, 93);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 70);
      expect(other.second, 157);
      expect(other.third, 108);
      expect(other.fourth, 217);
      expect(other.fifth, 93);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 108);
      expect(other.fourth, 217);
      expect(other.fifth, 93);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 217);
      expect(other.fifth, 93);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 93);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
    });
    test('length', () {
      expect(tuple.length, 6);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[70, 64, 157, 108, 217, 93]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[70, 64, 157, 108, 217, 93]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{70, 64, 157, 108, 217, 93});
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth, sixth) {
        expect(first, 70);
        expect(second, 64);
        expect(third, 157);
        expect(fourth, 108);
        expect(fifth, 217);
        expect(sixth, 93);
        return 849;
      }), 849);
    });
    test('toString', () {
      expect(tuple.toString(), '(70, 64, 157, 108, 217, 93)');
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
    const tuple = Tuple7(171, 110, 138, 191, 17, 53, 115);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([171, 110, 138, 191, 17, 53, 115]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([80, 129, 100, 144, 152, 96, 72, 32, 127, 39]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple7.fromList([171, 110, 138, 191, 17, 53, 115]);
      expect(other, tuple);
      expect(() => Tuple7.fromList([236, 171, 122, 66, 13, 78, 228, 183]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 171);
      expect(tuple.second, 110);
      expect(tuple.third, 138);
      expect(tuple.fourth, 191);
      expect(tuple.fifth, 17);
      expect(tuple.sixth, 53);
      expect(tuple.seventh, 115);
      expect(tuple.last, 115);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 115);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 171);
      expect(other.second, 'a');
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 115);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 'a');
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 115);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 'a');
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 115);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 'a');
      expect(other.sixth, 53);
      expect(other.seventh, 115);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 'a');
      expect(other.seventh, 115);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
      expect(other.eighth, 115);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 'a');
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
      expect(other.eighth, 115);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 'a');
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
      expect(other.eighth, 115);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 'a');
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
      expect(other.eighth, 115);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 'a');
      expect(other.sixth, 17);
      expect(other.seventh, 53);
      expect(other.eighth, 115);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 'a');
      expect(other.seventh, 53);
      expect(other.eighth, 115);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 'a');
      expect(other.eighth, 115);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 115);
      expect(other.eighth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
      expect(other.seventh, 115);
      expect(other.eighth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 110);
      expect(other.second, 138);
      expect(other.third, 191);
      expect(other.fourth, 17);
      expect(other.fifth, 53);
      expect(other.sixth, 115);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 138);
      expect(other.third, 191);
      expect(other.fourth, 17);
      expect(other.fifth, 53);
      expect(other.sixth, 115);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 191);
      expect(other.fourth, 17);
      expect(other.fifth, 53);
      expect(other.sixth, 115);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 17);
      expect(other.fifth, 53);
      expect(other.sixth, 115);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 53);
      expect(other.sixth, 115);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 115);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
    });
    test('length', () {
      expect(tuple.length, 7);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[171, 110, 138, 191, 17, 53, 115]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[171, 110, 138, 191, 17, 53, 115]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{171, 110, 138, 191, 17, 53, 115});
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth, sixth, seventh) {
        expect(first, 171);
        expect(second, 110);
        expect(third, 138);
        expect(fourth, 191);
        expect(fifth, 17);
        expect(sixth, 53);
        expect(seventh, 115);
        return 665;
      }), 665);
    });
    test('toString', () {
      expect(tuple.toString(), '(171, 110, 138, 191, 17, 53, 115)');
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
    const tuple = Tuple8(63, 4, 238, 254, 200, 37, 244, 31);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([63, 4, 238, 254, 200, 37, 244, 31]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([234, 132, 24, 19, 211, 220, 206, 56, 54, 10]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple8.fromList([63, 4, 238, 254, 200, 37, 244, 31]);
      expect(other, tuple);
      expect(() => Tuple8.fromList([16, 9, 219, 36, 6, 81, 93, 76, 9]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 63);
      expect(tuple.second, 4);
      expect(tuple.third, 238);
      expect(tuple.fourth, 254);
      expect(tuple.fifth, 200);
      expect(tuple.sixth, 37);
      expect(tuple.seventh, 244);
      expect(tuple.eighth, 31);
      expect(tuple.last, 31);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 63);
      expect(other.second, 'a');
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 'a');
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 'a');
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 'a');
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 'a');
      expect(other.seventh, 244);
      expect(other.eighth, 31);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 'a');
      expect(other.eighth, 31);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
      expect(other.ninth, 31);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 'a');
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
      expect(other.ninth, 31);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 'a');
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
      expect(other.ninth, 31);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 'a');
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
      expect(other.ninth, 31);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 'a');
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
      expect(other.ninth, 31);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 'a');
      expect(other.seventh, 37);
      expect(other.eighth, 244);
      expect(other.ninth, 31);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 'a');
      expect(other.eighth, 244);
      expect(other.ninth, 31);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 'a');
      expect(other.ninth, 31);
    });
    test('addNinth', () {
      final other = tuple.addNinth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
      expect(other.ninth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
      expect(other.eighth, 31);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 4);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 238);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 254);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 200);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 37);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 244);
      expect(other.seventh, 31);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 31);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
    });
    test('length', () {
      expect(tuple.length, 8);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[63, 4, 238, 254, 200, 37, 244, 31]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[63, 4, 238, 254, 200, 37, 244, 31]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{63, 4, 238, 254, 200, 37, 244, 31});
    });
    test('map', () {
      expect(tuple
          .map((first, second, third, fourth, fifth, sixth, seventh, eighth) {
        expect(first, 63);
        expect(second, 4);
        expect(third, 238);
        expect(fourth, 254);
        expect(fifth, 200);
        expect(sixth, 37);
        expect(seventh, 244);
        expect(eighth, 31);
        return 209;
      }), 209);
    });
    test('toString', () {
      expect(tuple.toString(), '(63, 4, 238, 254, 200, 37, 244, 31)');
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
    test('map', () {
      expect(tuple.map(
          (first, second, third, fourth, fifth, sixth, seventh, eighth, ninth) {
        expect(first, 229);
        expect(second, 246);
        expect(third, 244);
        expect(fourth, 122);
        expect(fifth, 206);
        expect(sixth, 164);
        expect(seventh, 55);
        expect(eighth, 173);
        expect(ninth, 2);
        return 917;
      }), 917);
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
