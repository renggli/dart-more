import 'package:more/tuple.dart';
import 'package:test/test.dart';

void main() {
  group('Tuple0', () {
    const tuple = ();
    test('fromList', () {
      final other = Tuple0.fromList([]);
      expect(other, tuple);
      expect(() => Tuple0.fromList([51]), throwsArgumentError);
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
      expect(tuple.map(() => 430), 430);
    });
  });
  group('Tuple1', () {
    const tuple = (196,);
    test('fromList', () {
      final other = Tuple1.fromList([196]);
      expect(other, tuple);
      expect(() => Tuple1.fromList([93, 181]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 196);
      expect(tuple.last, 196);
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
      expect(other.second, 196);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 196);
      expect(other.second, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 196);
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
      expect(tuple.iterable, <Object>[196]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[196]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{196});
    });
    test('map', () {
      expect(tuple.map((first) {
        expect(first, 196);
        return 104;
      }), 104);
    });
  });
  group('Tuple2', () {
    const tuple = (143, 61);
    test('fromList', () {
      final other = Tuple2.fromList([143, 61]);
      expect(other, tuple);
      expect(() => Tuple2.fromList([48, 184, 255]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 143);
      expect(tuple.second, 61);
      expect(tuple.last, 61);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 61);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 143);
      expect(other.second, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 143);
      expect(other.second, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 143);
      expect(other.third, 61);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 143);
      expect(other.second, 'a');
      expect(other.third, 61);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 143);
      expect(other.second, 61);
      expect(other.third, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 143);
      expect(other.second, 61);
      expect(other.third, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 61);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 143);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 143);
    });
    test('length', () {
      expect(tuple.length, 2);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[143, 61]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[143, 61]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{143, 61});
    });
    test('map', () {
      expect(tuple.map((first, second) {
        expect(first, 143);
        expect(second, 61);
        return 740;
      }), 740);
    });
  });
  group('Tuple3', () {
    const tuple = (51, 115, 77);
    test('fromList', () {
      final other = Tuple3.fromList([51, 115, 77]);
      expect(other, tuple);
      expect(() => Tuple3.fromList([26, 167, 89, 231]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 51);
      expect(tuple.second, 115);
      expect(tuple.third, 77);
      expect(tuple.last, 77);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 115);
      expect(other.third, 77);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 51);
      expect(other.second, 'a');
      expect(other.third, 77);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 51);
      expect(other.second, 115);
      expect(other.third, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 51);
      expect(other.second, 115);
      expect(other.third, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 51);
      expect(other.third, 115);
      expect(other.fourth, 77);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 51);
      expect(other.second, 'a');
      expect(other.third, 115);
      expect(other.fourth, 77);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 51);
      expect(other.second, 115);
      expect(other.third, 'a');
      expect(other.fourth, 77);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 51);
      expect(other.second, 115);
      expect(other.third, 77);
      expect(other.fourth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 51);
      expect(other.second, 115);
      expect(other.third, 77);
      expect(other.fourth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 115);
      expect(other.second, 77);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 51);
      expect(other.second, 77);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 51);
      expect(other.second, 115);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 51);
      expect(other.second, 115);
    });
    test('length', () {
      expect(tuple.length, 3);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[51, 115, 77]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[51, 115, 77]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{51, 115, 77});
    });
    test('map', () {
      expect(tuple.map((first, second, third) {
        expect(first, 51);
        expect(second, 115);
        expect(third, 77);
        return 430;
      }), 430);
    });
  });
  group('Tuple4', () {
    const tuple = (164, 26, 79, 32);
    test('fromList', () {
      final other = Tuple4.fromList([164, 26, 79, 32]);
      expect(other, tuple);
      expect(
          () => Tuple4.fromList([90, 100, 110, 80, 160]), throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 164);
      expect(tuple.second, 26);
      expect(tuple.third, 79);
      expect(tuple.fourth, 32);
      expect(tuple.last, 32);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 26);
      expect(other.third, 79);
      expect(other.fourth, 32);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 164);
      expect(other.second, 'a');
      expect(other.third, 79);
      expect(other.fourth, 32);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 'a');
      expect(other.fourth, 32);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 79);
      expect(other.fourth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 79);
      expect(other.fourth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 164);
      expect(other.third, 26);
      expect(other.fourth, 79);
      expect(other.fifth, 32);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 164);
      expect(other.second, 'a');
      expect(other.third, 26);
      expect(other.fourth, 79);
      expect(other.fifth, 32);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 'a');
      expect(other.fourth, 79);
      expect(other.fifth, 32);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 79);
      expect(other.fourth, 'a');
      expect(other.fifth, 32);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 79);
      expect(other.fourth, 32);
      expect(other.fifth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 79);
      expect(other.fourth, 32);
      expect(other.fifth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 26);
      expect(other.second, 79);
      expect(other.third, 32);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 164);
      expect(other.second, 79);
      expect(other.third, 32);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 32);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 79);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 164);
      expect(other.second, 26);
      expect(other.third, 79);
    });
    test('length', () {
      expect(tuple.length, 4);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[164, 26, 79, 32]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[164, 26, 79, 32]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{164, 26, 79, 32});
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth) {
        expect(first, 164);
        expect(second, 26);
        expect(third, 79);
        expect(fourth, 32);
        return 341;
      }), 341);
    });
  });
  group('Tuple5', () {
    const tuple = (136, 148, 159, 123, 142);
    test('fromList', () {
      final other = Tuple5.fromList([136, 148, 159, 123, 142]);
      expect(other, tuple);
      expect(() => Tuple5.fromList([224, 17, 183, 144, 195, 3]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 136);
      expect(tuple.second, 148);
      expect(tuple.third, 159);
      expect(tuple.fourth, 123);
      expect(tuple.fifth, 142);
      expect(tuple.last, 142);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 123);
      expect(other.fifth, 142);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 136);
      expect(other.second, 'a');
      expect(other.third, 159);
      expect(other.fourth, 123);
      expect(other.fifth, 142);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 'a');
      expect(other.fourth, 123);
      expect(other.fifth, 142);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 'a');
      expect(other.fifth, 142);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 123);
      expect(other.fifth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 123);
      expect(other.fifth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 136);
      expect(other.third, 148);
      expect(other.fourth, 159);
      expect(other.fifth, 123);
      expect(other.sixth, 142);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 136);
      expect(other.second, 'a');
      expect(other.third, 148);
      expect(other.fourth, 159);
      expect(other.fifth, 123);
      expect(other.sixth, 142);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 'a');
      expect(other.fourth, 159);
      expect(other.fifth, 123);
      expect(other.sixth, 142);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 'a');
      expect(other.fifth, 123);
      expect(other.sixth, 142);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 123);
      expect(other.fifth, 'a');
      expect(other.sixth, 142);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 123);
      expect(other.fifth, 142);
      expect(other.sixth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 123);
      expect(other.fifth, 142);
      expect(other.sixth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 148);
      expect(other.second, 159);
      expect(other.third, 123);
      expect(other.fourth, 142);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 136);
      expect(other.second, 159);
      expect(other.third, 123);
      expect(other.fourth, 142);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 123);
      expect(other.fourth, 142);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 142);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 123);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 136);
      expect(other.second, 148);
      expect(other.third, 159);
      expect(other.fourth, 123);
    });
    test('length', () {
      expect(tuple.length, 5);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[136, 148, 159, 123, 142]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[136, 148, 159, 123, 142]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{136, 148, 159, 123, 142});
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth) {
        expect(first, 136);
        expect(second, 148);
        expect(third, 159);
        expect(fourth, 123);
        expect(fifth, 142);
        return 686;
      }), 686);
    });
  });
  group('Tuple6', () {
    const tuple = (10, 221, 217, 145, 204, 250);
    test('fromList', () {
      final other = Tuple6.fromList([10, 221, 217, 145, 204, 250]);
      expect(other, tuple);
      expect(() => Tuple6.fromList([23, 39, 140, 220, 127, 11, 73]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 10);
      expect(tuple.second, 221);
      expect(tuple.third, 217);
      expect(tuple.fourth, 145);
      expect(tuple.fifth, 204);
      expect(tuple.sixth, 250);
      expect(tuple.last, 250);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
      expect(other.sixth, 250);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 10);
      expect(other.second, 'a');
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
      expect(other.sixth, 250);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 'a');
      expect(other.fourth, 145);
      expect(other.fifth, 204);
      expect(other.sixth, 250);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 'a');
      expect(other.fifth, 204);
      expect(other.sixth, 250);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 'a');
      expect(other.sixth, 250);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
      expect(other.sixth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
      expect(other.sixth, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 10);
      expect(other.third, 221);
      expect(other.fourth, 217);
      expect(other.fifth, 145);
      expect(other.sixth, 204);
      expect(other.seventh, 250);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 'a');
      expect(other.third, 221);
      expect(other.fourth, 217);
      expect(other.fifth, 145);
      expect(other.sixth, 204);
      expect(other.seventh, 250);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 'a');
      expect(other.fourth, 217);
      expect(other.fifth, 145);
      expect(other.sixth, 204);
      expect(other.seventh, 250);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 'a');
      expect(other.fifth, 145);
      expect(other.sixth, 204);
      expect(other.seventh, 250);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 'a');
      expect(other.sixth, 204);
      expect(other.seventh, 250);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
      expect(other.sixth, 'a');
      expect(other.seventh, 250);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
      expect(other.sixth, 250);
      expect(other.seventh, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
      expect(other.sixth, 250);
      expect(other.seventh, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 221);
      expect(other.second, 217);
      expect(other.third, 145);
      expect(other.fourth, 204);
      expect(other.fifth, 250);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 217);
      expect(other.third, 145);
      expect(other.fourth, 204);
      expect(other.fifth, 250);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 145);
      expect(other.fourth, 204);
      expect(other.fifth, 250);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 204);
      expect(other.fifth, 250);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 250);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 10);
      expect(other.second, 221);
      expect(other.third, 217);
      expect(other.fourth, 145);
      expect(other.fifth, 204);
    });
    test('length', () {
      expect(tuple.length, 6);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[10, 221, 217, 145, 204, 250]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[10, 221, 217, 145, 204, 250]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{10, 221, 217, 145, 204, 250});
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth, sixth) {
        expect(first, 10);
        expect(second, 221);
        expect(third, 217);
        expect(fourth, 145);
        expect(fifth, 204);
        expect(sixth, 250);
        return 283;
      }), 283);
    });
  });
  group('Tuple7', () {
    const tuple = (195, 133, 23, 42, 211, 158, 121);
    test('fromList', () {
      final other = Tuple7.fromList([195, 133, 23, 42, 211, 158, 121]);
      expect(other, tuple);
      expect(() => Tuple7.fromList([55, 119, 54, 178, 209, 198, 186, 130]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 195);
      expect(tuple.second, 133);
      expect(tuple.third, 23);
      expect(tuple.fourth, 42);
      expect(tuple.fifth, 211);
      expect(tuple.sixth, 158);
      expect(tuple.seventh, 121);
      expect(tuple.last, 121);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 121);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 195);
      expect(other.second, 'a');
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 121);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 'a');
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 121);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 'a');
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 121);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 'a');
      expect(other.sixth, 158);
      expect(other.seventh, 121);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 'a');
      expect(other.seventh, 121);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 'a');
      expect(other.second, 195);
      expect(other.third, 133);
      expect(other.fourth, 23);
      expect(other.fifth, 42);
      expect(other.sixth, 211);
      expect(other.seventh, 158);
      expect(other.eighth, 121);
    });
    test('addSecond', () {
      final other = tuple.addSecond('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 195);
      expect(other.second, 'a');
      expect(other.third, 133);
      expect(other.fourth, 23);
      expect(other.fifth, 42);
      expect(other.sixth, 211);
      expect(other.seventh, 158);
      expect(other.eighth, 121);
    });
    test('addThird', () {
      final other = tuple.addThird('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 'a');
      expect(other.fourth, 23);
      expect(other.fifth, 42);
      expect(other.sixth, 211);
      expect(other.seventh, 158);
      expect(other.eighth, 121);
    });
    test('addFourth', () {
      final other = tuple.addFourth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 'a');
      expect(other.fifth, 42);
      expect(other.sixth, 211);
      expect(other.seventh, 158);
      expect(other.eighth, 121);
    });
    test('addFifth', () {
      final other = tuple.addFifth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 'a');
      expect(other.sixth, 211);
      expect(other.seventh, 158);
      expect(other.eighth, 121);
    });
    test('addSixth', () {
      final other = tuple.addSixth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 'a');
      expect(other.seventh, 158);
      expect(other.eighth, 121);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 'a');
      expect(other.eighth, 121);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 121);
      expect(other.eighth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
      expect(other.seventh, 121);
      expect(other.eighth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 133);
      expect(other.second, 23);
      expect(other.third, 42);
      expect(other.fourth, 211);
      expect(other.fifth, 158);
      expect(other.sixth, 121);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 195);
      expect(other.second, 23);
      expect(other.third, 42);
      expect(other.fourth, 211);
      expect(other.fifth, 158);
      expect(other.sixth, 121);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 42);
      expect(other.fourth, 211);
      expect(other.fifth, 158);
      expect(other.sixth, 121);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 211);
      expect(other.fifth, 158);
      expect(other.sixth, 121);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 158);
      expect(other.sixth, 121);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 121);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 195);
      expect(other.second, 133);
      expect(other.third, 23);
      expect(other.fourth, 42);
      expect(other.fifth, 211);
      expect(other.sixth, 158);
    });
    test('length', () {
      expect(tuple.length, 7);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[195, 133, 23, 42, 211, 158, 121]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[195, 133, 23, 42, 211, 158, 121]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{195, 133, 23, 42, 211, 158, 121});
    });
    test('map', () {
      expect(tuple.map((first, second, third, fourth, fifth, sixth, seventh) {
        expect(first, 195);
        expect(second, 133);
        expect(third, 23);
        expect(fourth, 42);
        expect(fifth, 211);
        expect(sixth, 158);
        expect(seventh, 121);
        return 923;
      }), 923);
    });
  });
  group('Tuple8', () {
    const tuple = (32, 108, 10, 131, 83, 137, 102, 140);
    test('fromList', () {
      final other = Tuple8.fromList([32, 108, 10, 131, 83, 137, 102, 140]);
      expect(other, tuple);
      expect(() => Tuple8.fromList([254, 112, 223, 77, 47, 35, 113, 0, 0]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 32);
      expect(tuple.second, 108);
      expect(tuple.third, 10);
      expect(tuple.fourth, 131);
      expect(tuple.fifth, 83);
      expect(tuple.sixth, 137);
      expect(tuple.seventh, 102);
      expect(tuple.eighth, 140);
      expect(tuple.last, 140);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 140);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 32);
      expect(other.second, 'a');
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 140);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 'a');
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 140);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 'a');
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 140);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 'a');
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 140);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 'a');
      expect(other.seventh, 102);
      expect(other.eighth, 140);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 'a');
      expect(other.eighth, 140);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 'a');
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
      expect(other.seventh, 137);
      expect(other.eighth, 102);
      expect(other.ninth, 140);
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
      expect(other.seventh, 137);
      expect(other.eighth, 102);
      expect(other.ninth, 140);
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
      expect(other.seventh, 137);
      expect(other.eighth, 102);
      expect(other.ninth, 140);
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
      expect(other.seventh, 137);
      expect(other.eighth, 102);
      expect(other.ninth, 140);
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
      expect(other.seventh, 137);
      expect(other.eighth, 102);
      expect(other.ninth, 140);
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
      expect(other.seventh, 137);
      expect(other.eighth, 102);
      expect(other.ninth, 140);
    });
    test('addSeventh', () {
      final other = tuple.addSeventh('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 'a');
      expect(other.eighth, 102);
      expect(other.ninth, 140);
    });
    test('addEighth', () {
      final other = tuple.addEighth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 'a');
      expect(other.ninth, 140);
    });
    test('addNinth', () {
      final other = tuple.addNinth('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 140);
      expect(other.ninth, 'a');
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
      expect(other.eighth, 140);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 108);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 137);
      expect(other.sixth, 102);
      expect(other.seventh, 140);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 10);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 137);
      expect(other.sixth, 102);
      expect(other.seventh, 140);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 131);
      expect(other.fourth, 83);
      expect(other.fifth, 137);
      expect(other.sixth, 102);
      expect(other.seventh, 140);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 83);
      expect(other.fifth, 137);
      expect(other.sixth, 102);
      expect(other.seventh, 140);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 137);
      expect(other.sixth, 102);
      expect(other.seventh, 140);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 102);
      expect(other.seventh, 140);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 140);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 32);
      expect(other.second, 108);
      expect(other.third, 10);
      expect(other.fourth, 131);
      expect(other.fifth, 83);
      expect(other.sixth, 137);
      expect(other.seventh, 102);
    });
    test('length', () {
      expect(tuple.length, 8);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[32, 108, 10, 131, 83, 137, 102, 140]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[32, 108, 10, 131, 83, 137, 102, 140]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{32, 108, 10, 131, 83, 137, 102, 140});
    });
    test('map', () {
      expect(tuple
          .map((first, second, third, fourth, fifth, sixth, seventh, eighth) {
        expect(first, 32);
        expect(second, 108);
        expect(third, 10);
        expect(fourth, 131);
        expect(fifth, 83);
        expect(sixth, 137);
        expect(seventh, 102);
        expect(eighth, 140);
        return 493;
      }), 493);
    });
  });
  group('Tuple9', () {
    const tuple = (45, 241, 0, 46, 5, 70, 64, 157, 108);
    test('fromList', () {
      final other = Tuple9.fromList([45, 241, 0, 46, 5, 70, 64, 157, 108]);
      expect(other, tuple);
      expect(() => Tuple9.fromList([217, 93, 20, 166, 21, 181, 57, 70, 180, 1]),
          throwsArgumentError);
    });
    test('read', () {
      expect(tuple.first, 45);
      expect(tuple.second, 241);
      expect(tuple.third, 0);
      expect(tuple.fourth, 46);
      expect(tuple.fifth, 5);
      expect(tuple.sixth, 70);
      expect(tuple.seventh, 64);
      expect(tuple.eighth, 157);
      expect(tuple.ninth, 108);
      expect(tuple.last, 108);
    });
    test('withFirst', () {
      final other = tuple.withFirst('a');
      expect(other.first, 'a');
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
      expect(other.ninth, 108);
    });
    test('withSecond', () {
      final other = tuple.withSecond('a');
      expect(other.first, 45);
      expect(other.second, 'a');
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
      expect(other.ninth, 108);
    });
    test('withThird', () {
      final other = tuple.withThird('a');
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 'a');
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
      expect(other.ninth, 108);
    });
    test('withFourth', () {
      final other = tuple.withFourth('a');
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 'a');
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
      expect(other.ninth, 108);
    });
    test('withFifth', () {
      final other = tuple.withFifth('a');
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 'a');
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
      expect(other.ninth, 108);
    });
    test('withSixth', () {
      final other = tuple.withSixth('a');
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 'a');
      expect(other.seventh, 64);
      expect(other.eighth, 157);
      expect(other.ninth, 108);
    });
    test('withSeventh', () {
      final other = tuple.withSeventh('a');
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 'a');
      expect(other.eighth, 157);
      expect(other.ninth, 108);
    });
    test('withEighth', () {
      final other = tuple.withEighth('a');
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 'a');
      expect(other.ninth, 108);
    });
    test('withNinth', () {
      final other = tuple.withNinth('a');
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
      expect(other.ninth, 'a');
    });
    test('withLast', () {
      final other = tuple.withLast('a');
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
      expect(other.ninth, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.first, 241);
      expect(other.second, 0);
      expect(other.third, 46);
      expect(other.fourth, 5);
      expect(other.fifth, 70);
      expect(other.sixth, 64);
      expect(other.seventh, 157);
      expect(other.eighth, 108);
    });
    test('removeSecond', () {
      final other = tuple.removeSecond();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 0);
      expect(other.third, 46);
      expect(other.fourth, 5);
      expect(other.fifth, 70);
      expect(other.sixth, 64);
      expect(other.seventh, 157);
      expect(other.eighth, 108);
    });
    test('removeThird', () {
      final other = tuple.removeThird();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 46);
      expect(other.fourth, 5);
      expect(other.fifth, 70);
      expect(other.sixth, 64);
      expect(other.seventh, 157);
      expect(other.eighth, 108);
    });
    test('removeFourth', () {
      final other = tuple.removeFourth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 5);
      expect(other.fifth, 70);
      expect(other.sixth, 64);
      expect(other.seventh, 157);
      expect(other.eighth, 108);
    });
    test('removeFifth', () {
      final other = tuple.removeFifth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 70);
      expect(other.sixth, 64);
      expect(other.seventh, 157);
      expect(other.eighth, 108);
    });
    test('removeSixth', () {
      final other = tuple.removeSixth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 64);
      expect(other.seventh, 157);
      expect(other.eighth, 108);
    });
    test('removeSeventh', () {
      final other = tuple.removeSeventh();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 157);
      expect(other.eighth, 108);
    });
    test('removeEighth', () {
      final other = tuple.removeEighth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 108);
    });
    test('removeNinth', () {
      final other = tuple.removeNinth();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.first, 45);
      expect(other.second, 241);
      expect(other.third, 0);
      expect(other.fourth, 46);
      expect(other.fifth, 5);
      expect(other.sixth, 70);
      expect(other.seventh, 64);
      expect(other.eighth, 157);
    });
    test('length', () {
      expect(tuple.length, 9);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[45, 241, 0, 46, 5, 70, 64, 157, 108]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[45, 241, 0, 46, 5, 70, 64, 157, 108]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{45, 241, 0, 46, 5, 70, 64, 157, 108});
    });
    test('map', () {
      expect(tuple.map(
          (first, second, third, fourth, fifth, sixth, seventh, eighth, ninth) {
        expect(first, 45);
        expect(second, 241);
        expect(third, 0);
        expect(fourth, 46);
        expect(fifth, 5);
        expect(sixth, 70);
        expect(seventh, 64);
        expect(eighth, 157);
        expect(ninth, 108);
        return 572;
      }), 572);
    });
  });
}
