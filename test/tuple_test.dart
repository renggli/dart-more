// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:more/tuple.dart';
import 'package:test/test.dart';

void main() {
  group('Tuple0', () {
    const tuple = ();
    test('Tuple.fromList', () {
      final other = Tuple.fromList([]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([51, 174, 196, 93, 181, 104, 143, 61, 48, 184]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple0.fromList([]);
      expect(other, tuple);
      expect(() => Tuple0.fromList([255]), throwsArgumentError);
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
    test('map', () {
      expect(tuple.map(() => 740), 740);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{});
    });
  });
  group('Tuple1', () {
    const tuple = (51,);
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
    test('map', () {
      expect(tuple.map((first) {
        expect(first, 51);
        return 100;
      }), 100);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[51]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[51]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{51});
    });
  });
  group('Tuple2', () {
    const tuple = (110, 80);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([110, 80]);
      expect(other, tuple);
      expect(
          () =>
              Tuple.fromList([160, 85, 136, 148, 159, 123, 142, 224, 17, 183]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple2.fromList([110, 80]);
      expect(other, tuple);
      expect(() => Tuple2.fromList([144, 195, 3]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 110);
      expect(tuple.second, 80);
      expect(tuple.last, 80);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 80);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 110);
      expect(other.second, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 110);
      expect(other.second, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 110);
      expect(other.third, 80);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 110);
      expect(other.second, 'a');
      expect(other.third, 80);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 110);
      expect(other.second, 80);
      expect(other.third, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 110);
      expect(other.second, 80);
      expect(other.third, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 80);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 110);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 110);
    });
    test('length', () {
      expect(tuple.length, 2);
    });
    test('map', () {
      expect(tuple.map((first, second) {
        expect(first, 110);
        expect(second, 80);
        return 686;
      }), 686);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[110, 80]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[110, 80]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{110, 80});
    });
  });
  group('Tuple3', () {
    const tuple = (10, 221, 217);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([10, 221, 217]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([145, 204, 250, 23, 39, 140, 220, 127, 11, 73]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple3.fromList([10, 221, 217]);
      expect(other, tuple);
      expect(() => Tuple3.fromList([27, 195, 133, 23]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 10);
      expect(tuple.second, 221);
      expect(tuple.third, 217);
      expect(tuple.last, 217);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 221);
      expect(other.third, 217);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 10);
      expect(other.second, 'a');
      expect(other.third, 217);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 10);
      expect(other.third, 221);
      expect(other.fourth, 217);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 'a');
      expect(other.third, 221);
      expect(other.fourth, 217);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 'a');
      expect(other.fourth, 217);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 221);
      expect(other.second, 217);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 217);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 221);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 221);
    });
    test('length', () {
      expect(tuple.length, 3);
    });
    test('map', () {
      expect(tuple.map((first, second, third) {
        expect(first, 10);
        expect(second, 221);
        expect(third, 217);
        return 298;
      }), 298);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[10, 221, 217]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[10, 221, 217]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{10, 221, 217});
    });
  });
  group('Tuple4', () {
    const tuple = (211, 158, 121, 55);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([211, 158, 121, 55]);
      expect(other, tuple);
      expect(
          () =>
              Tuple.fromList([119, 54, 178, 209, 198, 186, 130, 155, 175, 159]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple4.fromList([211, 158, 121, 55]);
      expect(other, tuple);
      expect(
          () => Tuple4.fromList([93, 164, 180, 175, 192]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 211);
      expect(tuple.second, 158);
      expect(tuple.third, 121);
      expect(tuple.fourth, 55);
      expect(tuple.last, 55);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 158);
      expect(other.third, 121);
      expect(other.fourth, 55);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 211);
      expect(other.second, 'a');
      expect(other.third, 121);
      expect(other.fourth, 55);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 'a');
      expect(other.fourth, 55);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 121);
      expect(other.fourth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 121);
      expect(other.fourth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 211);
      expect(other.third, 158);
      expect(other.fourth, 121);
      expect(other.fifth, 55);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 211);
      expect(other.second, 'a');
      expect(other.third, 158);
      expect(other.fourth, 121);
      expect(other.fifth, 55);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 'a');
      expect(other.fourth, 121);
      expect(other.fifth, 55);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 121);
      expect(other.fourth, 'a');
      expect(other.fifth, 55);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 121);
      expect(other.fourth, 55);
      expect(other.fifth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 121);
      expect(other.fourth, 55);
      expect(other.fifth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 158);
      expect(other.second, 121);
      expect(other.third, 55);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 211);
      expect(other.second, 121);
      expect(other.third, 55);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 55);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 121);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 211);
      expect(other.second, 158);
      expect(other.third, 121);
    });
    test('length', () {
      expect(tuple.length, 4);
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth) {
        expect(first, 211);
        expect(second, 158);
        expect(third, 121);
        expect(fourth, 55);
        return 498;
      }), 498);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[211, 158, 121, 55]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[211, 158, 121, 55]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{211, 158, 121, 55});
    });
  });
  group('Tuple5', () {
    const tuple = (32, 108, 10, 131, 83);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([32, 108, 10, 131, 83]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([137, 102, 140, 254, 112, 223, 77, 47, 35, 113]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple5.fromList([32, 108, 10, 131, 83]);
      expect(other, tuple);
      expect(
          () => Tuple5.fromList([0, 0, 237, 45, 241, 0]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 32);
      expect(tuple.second, 108);
      expect(tuple.third, 10);
      expect(tuple.fourth, 131);
      expect(tuple.fifth, 83);
      expect(tuple.last, 83);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 32);
      expect(other.second, 'a');
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 'a');
      expect(other.fourth, 131);
      expect(other.fifth, 83);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 'a');
      expect(other.fifth, 83);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 32);
      expect(other.third, 108);
      expect(other.fourth, 10);
      expect(other.fifth, 131);
      expect(other.sixth, 83);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 'a');
      expect(other.third, 108);
      expect(other.fourth, 10);
      expect(other.fifth, 131);
      expect(other.sixth, 83);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 'a');
      expect(other.fourth, 10);
      expect(other.fifth, 131);
      expect(other.sixth, 83);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 'a');
      expect(other.fifth, 131);
      expect(other.sixth, 83);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 'a');
      expect(other.sixth, 83);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 131);
      expect(other.fourth, 83);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 83);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
    });
    test('length', () {
      expect(tuple.length, 5);
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth) {
        expect(first, 32);
        expect(second, 108);
        expect(third, 10);
        expect(fourth, 131);
        expect(fifth, 83);
        return 558;
      }), 558);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[32, 108, 10, 131, 83]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[32, 108, 10, 131, 83]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{32, 108, 10, 131, 83});
    });
  });
  group('Tuple6', () {
    const tuple = (5, 70, 64, 157, 108, 217);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([5, 70, 64, 157, 108, 217]);
      expect(other, tuple);
      expect(() => Tuple.fromList([93, 20, 166, 21, 181, 57, 70, 180, 1, 60]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple6.fromList([5, 70, 64, 157, 108, 217]);
      expect(other, tuple);
      expect(() => Tuple6.fromList([182, 117, 95, 32, 200, 176, 125]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 5);
      expect(tuple.second, 70);
      expect(tuple.third, 64);
      expect(tuple.fourth, 157);
      expect(tuple.fifth, 108);
      expect(tuple.sixth, 217);
      expect(tuple.last, 217);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 217);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 5);
      expect(other.second, 'a');
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 217);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 'a');
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 217);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 'a');
      expect(other.fifth, 108);
      expect(other.sixth, 217);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 'a');
      expect(other.sixth, 217);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 5);
      expect(other.third, 70);
      expect(other.fourth, 64);
      expect(other.fifth, 157);
      expect(other.sixth, 108);
      expect(other.seventh, 217);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 5);
      expect(other.second, 'a');
      expect(other.third, 70);
      expect(other.fourth, 64);
      expect(other.fifth, 157);
      expect(other.sixth, 108);
      expect(other.seventh, 217);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 'a');
      expect(other.fourth, 64);
      expect(other.fifth, 157);
      expect(other.sixth, 108);
      expect(other.seventh, 217);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 'a');
      expect(other.fifth, 157);
      expect(other.sixth, 108);
      expect(other.seventh, 217);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 'a');
      expect(other.sixth, 108);
      expect(other.seventh, 217);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 'a');
      expect(other.seventh, 217);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 217);
      expect(other.seventh, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
      expect(other.sixth, 217);
      expect(other.seventh, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 70);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 5);
      expect(other.second, 64);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 157);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 108);
      expect(other.fifth, 217);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 217);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 5);
      expect(other.second, 70);
      expect(other.third, 64);
      expect(other.fourth, 157);
      expect(other.fifth, 108);
    });
    test('length', () {
      expect(tuple.length, 6);
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth, sixth) {
        expect(first, 5);
        expect(second, 70);
        expect(third, 64);
        expect(fourth, 157);
        expect(fifth, 108);
        expect(sixth, 217);
        return 533;
      }), 533);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[5, 70, 64, 157, 108, 217]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[5, 70, 64, 157, 108, 217]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{5, 70, 64, 157, 108, 217});
    });
  });
  group('Tuple7', () {
    const tuple = (81, 171, 110, 138, 191, 17, 53);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([81, 171, 110, 138, 191, 17, 53]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([115, 80, 129, 100, 144, 152, 96, 72, 32, 127]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple7.fromList([81, 171, 110, 138, 191, 17, 53]);
      expect(other, tuple);
      expect(() => Tuple7.fromList([39, 236, 171, 122, 66, 13, 78, 228]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 81);
      expect(tuple.second, 171);
      expect(tuple.third, 110);
      expect(tuple.fourth, 138);
      expect(tuple.fifth, 191);
      expect(tuple.sixth, 17);
      expect(tuple.seventh, 53);
      expect(tuple.last, 53);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 81);
      expect(other.second, 'a');
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 'a');
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 'a');
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 'a');
      expect(other.sixth, 17);
      expect(other.seventh, 53);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 'a');
      expect(other.seventh, 53);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 81);
      expect(other.third, 171);
      expect(other.fourth, 110);
      expect(other.fifth, 138);
      expect(other.sixth, 191);
      expect(other.seventh, 17);
      expect(other.eighth, 53);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 81);
      expect(other.second, 'a');
      expect(other.third, 171);
      expect(other.fourth, 110);
      expect(other.fifth, 138);
      expect(other.sixth, 191);
      expect(other.seventh, 17);
      expect(other.eighth, 53);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 'a');
      expect(other.fourth, 110);
      expect(other.fifth, 138);
      expect(other.sixth, 191);
      expect(other.seventh, 17);
      expect(other.eighth, 53);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 'a');
      expect(other.fifth, 138);
      expect(other.sixth, 191);
      expect(other.seventh, 17);
      expect(other.eighth, 53);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 'a');
      expect(other.sixth, 191);
      expect(other.seventh, 17);
      expect(other.eighth, 53);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 'a');
      expect(other.seventh, 17);
      expect(other.eighth, 53);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 'a');
      expect(other.eighth, 53);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
      expect(other.eighth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
      expect(other.seventh, 53);
      expect(other.eighth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 171);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 81);
      expect(other.second, 110);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 138);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 191);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 17);
      expect(other.sixth, 53);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 53);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 81);
      expect(other.second, 171);
      expect(other.third, 110);
      expect(other.fourth, 138);
      expect(other.fifth, 191);
      expect(other.sixth, 17);
    });
    test('length', () {
      expect(tuple.length, 7);
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth, sixth, seventh) {
        expect(first, 81);
        expect(second, 171);
        expect(third, 110);
        expect(fourth, 138);
        expect(fifth, 191);
        expect(sixth, 17);
        expect(seventh, 53);
        return 439;
      }), 439);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[81, 171, 110, 138, 191, 17, 53]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[81, 171, 110, 138, 191, 17, 53]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{81, 171, 110, 138, 191, 17, 53});
    });
  });
  group('Tuple8', () {
    const tuple = (153, 63, 4, 238, 254, 200, 37, 244);
    test('Tuple.fromList', () {
      final other = Tuple.fromList([153, 63, 4, 238, 254, 200, 37, 244]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([31, 234, 132, 24, 19, 211, 220, 206, 56, 54]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other = Tuple8.fromList([153, 63, 4, 238, 254, 200, 37, 244]);
      expect(other, tuple);
      expect(() => Tuple8.fromList([10, 16, 9, 219, 36, 6, 81, 93, 76]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 153);
      expect(tuple.second, 63);
      expect(tuple.third, 4);
      expect(tuple.fourth, 238);
      expect(tuple.fifth, 254);
      expect(tuple.sixth, 200);
      expect(tuple.seventh, 37);
      expect(tuple.eighth, 244);
      expect(tuple.last, 244);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 153);
      expect(other.second, 'a');
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 'a');
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 'a');
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 'a');
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 'a');
      expect(other.seventh, 37);
      expect(other.eighth, 244);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 'a');
      expect(other.eighth, 244);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 153);
      expect(other.third, 63);
      expect(other.fourth, 4);
      expect(other.fifth, 238);
      expect(other.sixth, 254);
      expect(other.seventh, 200);
      expect(other.eighth, 37);
      expect(other.ninth, 244);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 'a');
      expect(other.third, 63);
      expect(other.fourth, 4);
      expect(other.fifth, 238);
      expect(other.sixth, 254);
      expect(other.seventh, 200);
      expect(other.eighth, 37);
      expect(other.ninth, 244);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 'a');
      expect(other.fourth, 4);
      expect(other.fifth, 238);
      expect(other.sixth, 254);
      expect(other.seventh, 200);
      expect(other.eighth, 37);
      expect(other.ninth, 244);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 'a');
      expect(other.fifth, 238);
      expect(other.sixth, 254);
      expect(other.seventh, 200);
      expect(other.eighth, 37);
      expect(other.ninth, 244);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 'a');
      expect(other.sixth, 254);
      expect(other.seventh, 200);
      expect(other.eighth, 37);
      expect(other.ninth, 244);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 'a');
      expect(other.seventh, 200);
      expect(other.eighth, 37);
      expect(other.ninth, 244);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 'a');
      expect(other.eighth, 37);
      expect(other.ninth, 244);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 'a');
      expect(other.ninth, 244);
    });
    test('addNinth', () {
      final other = tuple.addNinth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
      expect(other.ninth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
      expect(other.eighth, 244);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 63);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 153);
      expect(other.second, 4);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 238);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 254);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 200);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 37);
      expect(other.seventh, 244);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 244);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 153);
      expect(other.second, 63);
      expect(other.third, 4);
      expect(other.fourth, 238);
      expect(other.fifth, 254);
      expect(other.sixth, 200);
      expect(other.seventh, 37);
    });
    test('length', () {
      expect(tuple.length, 8);
    });
    test('map', () {
      expect(tuple
          .map((first, second, third, fourth, fifth, sixth, seventh, eighth) {
        expect(first, 153);
        expect(second, 63);
        expect(third, 4);
        expect(fourth, 238);
        expect(fifth, 254);
        expect(sixth, 200);
        expect(seventh, 37);
        expect(eighth, 244);
        return 777;
      }), 777);
    });
    test('iterable', () {
      expect(tuple.iterable, <dynamic>[153, 63, 4, 238, 254, 200, 37, 244]);
    });
    test('toList', () {
      expect(tuple.toList(), <dynamic>[153, 63, 4, 238, 254, 200, 37, 244]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <dynamic>{153, 63, 4, 238, 254, 200, 37, 244});
    });
  });
  group('Tuple9', () {
    const tuple = (209, 229, 246, 244, 122, 206, 164, 55, 173);
    test('Tuple.fromList', () {
      final other =
          Tuple.fromList([209, 229, 246, 244, 122, 206, 164, 55, 173]);
      expect(other, tuple);
      expect(
          () => Tuple.fromList([2, 172, 190, 123, 156, 135, 27, 188, 100, 29]),
          throwsArgumentError);
    });
    test('fromList', () {
      final other =
          Tuple9.fromList([209, 229, 246, 244, 122, 206, 164, 55, 173]);
      expect(other, tuple);
      expect(
          () => Tuple9.fromList([17, 134, 68, 251, 48, 174, 226, 226, 42, 197]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 209);
      expect(tuple.second, 229);
      expect(tuple.third, 246);
      expect(tuple.fourth, 244);
      expect(tuple.fifth, 122);
      expect(tuple.sixth, 206);
      expect(tuple.seventh, 164);
      expect(tuple.eighth, 55);
      expect(tuple.ninth, 173);
      expect(tuple.last, 173);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
      expect(other.ninth, 173);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 209);
      expect(other.second, 'a');
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
      expect(other.ninth, 173);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 'a');
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
      expect(other.ninth, 173);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 'a');
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
      expect(other.ninth, 173);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 'a');
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
      expect(other.ninth, 173);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 'a');
      expect(other.seventh, 164);
      expect(other.eighth, 55);
      expect(other.ninth, 173);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 'a');
      expect(other.eighth, 55);
      expect(other.ninth, 173);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 'a');
      expect(other.ninth, 173);
    });
    test('withNinth', () {
      final other = tuple.withNinth('a');
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
      expect(other.ninth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
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
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 246);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 244);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 122);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 206);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 164);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 55);
      expect(other.eighth, 173);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 173);
    });
    test('removeNinth', () {
      final other = tuple.removeNinth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 209);
      expect(other.second, 229);
      expect(other.third, 246);
      expect(other.fourth, 244);
      expect(other.fifth, 122);
      expect(other.sixth, 206);
      expect(other.seventh, 164);
      expect(other.eighth, 55);
    });
    test('length', () {
      expect(tuple.length, 9);
    });
    test('map', () {
      expect(tuple.map(
          (first, second, third, fourth, fifth, sixth, seventh, eighth, ninth) {
        expect(first, 209);
        expect(second, 229);
        expect(third, 246);
        expect(fourth, 244);
        expect(fifth, 122);
        expect(sixth, 206);
        expect(seventh, 164);
        expect(eighth, 55);
        expect(ninth, 173);
        return 757;
      }), 757);
    });
    test('iterable', () {
      expect(tuple.iterable,
          <dynamic>[209, 229, 246, 244, 122, 206, 164, 55, 173]);
    });
    test('toList', () {
      expect(tuple.toList(),
          <dynamic>[209, 229, 246, 244, 122, 206, 164, 55, 173]);
    });
    test('toSet', () {
      expect(
          tuple.toSet(), <dynamic>{209, 229, 246, 244, 122, 206, 164, 55, 173});
    });
  });
}
