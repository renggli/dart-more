library more.test.tuple_test;

import 'package:test/test.dart';
import 'package:more/tuple.dart';

void main() {
  group('Tuple0', () {
    const tuple = Tuple0();
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
    const tuple = Tuple1(255);
    test('fromList', () {
      final other = Tuple.fromList([255]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 255);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 255);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 255);
      expect(other.value1, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 255);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 255);
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
      expect(tuple.iterable, <Object>[255]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[255]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{255});
    });
    test('toString', () {
      expect(tuple.toString(), '(255)');
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
    const tuple = Tuple2(228, 51);
    test('fromList', () {
      final other = Tuple.fromList([228, 51]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 228);
      expect(tuple.value1, 51);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 51);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 228);
      expect(other.value1, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 228);
      expect(other.value2, 51);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 228);
      expect(other.value1, 51);
      expect(other.value2, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 228);
      expect(other.value2, 51);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 228);
      expect(other.value1, 'a');
      expect(other.value2, 51);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 228);
      expect(other.value1, 51);
      expect(other.value2, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 51);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 228);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 51);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 228);
    });
    test('length', () {
      expect(tuple.length, 2);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[228, 51]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[228, 51]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{228, 51});
    });
    test('toString', () {
      expect(tuple.toString(), '(228, 51)');
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
    const tuple = Tuple3(115, 77, 26);
    test('fromList', () {
      final other = Tuple.fromList([115, 77, 26]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 115);
      expect(tuple.value1, 77);
      expect(tuple.value2, 26);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 77);
      expect(other.value2, 26);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 115);
      expect(other.value1, 'a');
      expect(other.value2, 26);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 115);
      expect(other.value1, 77);
      expect(other.value2, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 115);
      expect(other.value2, 77);
      expect(other.value3, 26);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 115);
      expect(other.value1, 77);
      expect(other.value2, 26);
      expect(other.value3, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 115);
      expect(other.value2, 77);
      expect(other.value3, 26);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 115);
      expect(other.value1, 'a');
      expect(other.value2, 77);
      expect(other.value3, 26);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 115);
      expect(other.value1, 77);
      expect(other.value2, 'a');
      expect(other.value3, 26);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 115);
      expect(other.value1, 77);
      expect(other.value2, 26);
      expect(other.value3, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 77);
      expect(other.value1, 26);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 115);
      expect(other.value1, 77);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 77);
      expect(other.value1, 26);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 115);
      expect(other.value1, 26);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 115);
      expect(other.value1, 77);
    });
    test('length', () {
      expect(tuple.length, 3);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[115, 77, 26]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[115, 77, 26]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{115, 77, 26});
    });
    test('toString', () {
      expect(tuple.toString(), '(115, 77, 26)');
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
    const tuple = Tuple4(167, 89, 231, 174);
    test('fromList', () {
      final other = Tuple.fromList([167, 89, 231, 174]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 167);
      expect(tuple.value1, 89);
      expect(tuple.value2, 231);
      expect(tuple.value3, 174);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 89);
      expect(other.value2, 231);
      expect(other.value3, 174);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 167);
      expect(other.value1, 'a');
      expect(other.value2, 231);
      expect(other.value3, 174);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 'a');
      expect(other.value3, 174);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 231);
      expect(other.value3, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 167);
      expect(other.value2, 89);
      expect(other.value3, 231);
      expect(other.value4, 174);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 231);
      expect(other.value3, 174);
      expect(other.value4, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 167);
      expect(other.value2, 89);
      expect(other.value3, 231);
      expect(other.value4, 174);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 167);
      expect(other.value1, 'a');
      expect(other.value2, 89);
      expect(other.value3, 231);
      expect(other.value4, 174);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 'a');
      expect(other.value3, 231);
      expect(other.value4, 174);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 231);
      expect(other.value3, 'a');
      expect(other.value4, 174);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 231);
      expect(other.value3, 174);
      expect(other.value4, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 89);
      expect(other.value1, 231);
      expect(other.value2, 174);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 231);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 89);
      expect(other.value1, 231);
      expect(other.value2, 174);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 167);
      expect(other.value1, 231);
      expect(other.value2, 174);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 174);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 167);
      expect(other.value1, 89);
      expect(other.value2, 231);
    });
    test('length', () {
      expect(tuple.length, 4);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[167, 89, 231, 174]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[167, 89, 231, 174]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{167, 89, 231, 174});
    });
    test('toString', () {
      expect(tuple.toString(), '(167, 89, 231, 174)');
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
    const tuple = Tuple5(164, 26, 79, 32, 90);
    test('fromList', () {
      final other = Tuple.fromList([164, 26, 79, 32, 90]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 164);
      expect(tuple.value1, 26);
      expect(tuple.value2, 79);
      expect(tuple.value3, 32);
      expect(tuple.value4, 90);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 32);
      expect(other.value4, 90);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 164);
      expect(other.value1, 'a');
      expect(other.value2, 79);
      expect(other.value3, 32);
      expect(other.value4, 90);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 'a');
      expect(other.value3, 32);
      expect(other.value4, 90);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 'a');
      expect(other.value4, 90);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 32);
      expect(other.value4, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 164);
      expect(other.value2, 26);
      expect(other.value3, 79);
      expect(other.value4, 32);
      expect(other.value5, 90);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 32);
      expect(other.value4, 90);
      expect(other.value5, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 164);
      expect(other.value2, 26);
      expect(other.value3, 79);
      expect(other.value4, 32);
      expect(other.value5, 90);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 164);
      expect(other.value1, 'a');
      expect(other.value2, 26);
      expect(other.value3, 79);
      expect(other.value4, 32);
      expect(other.value5, 90);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 'a');
      expect(other.value3, 79);
      expect(other.value4, 32);
      expect(other.value5, 90);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 'a');
      expect(other.value4, 32);
      expect(other.value5, 90);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 32);
      expect(other.value4, 'a');
      expect(other.value5, 90);
    });
    test('addAt5', () {
      final other = tuple.addAt5('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 32);
      expect(other.value4, 90);
      expect(other.value5, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 26);
      expect(other.value1, 79);
      expect(other.value2, 32);
      expect(other.value3, 90);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 32);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 26);
      expect(other.value1, 79);
      expect(other.value2, 32);
      expect(other.value3, 90);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 164);
      expect(other.value1, 79);
      expect(other.value2, 32);
      expect(other.value3, 90);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 32);
      expect(other.value3, 90);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 90);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 164);
      expect(other.value1, 26);
      expect(other.value2, 79);
      expect(other.value3, 32);
    });
    test('length', () {
      expect(tuple.length, 5);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[164, 26, 79, 32, 90]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[164, 26, 79, 32, 90]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{164, 26, 79, 32, 90});
    });
    test('toString', () {
      expect(tuple.toString(), '(164, 26, 79, 32, 90)');
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
    const tuple = Tuple6(100, 110, 80, 160, 85, 136);
    test('fromList', () {
      final other = Tuple.fromList([100, 110, 80, 160, 85, 136]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 100);
      expect(tuple.value1, 110);
      expect(tuple.value2, 80);
      expect(tuple.value3, 160);
      expect(tuple.value4, 85);
      expect(tuple.value5, 136);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 85);
      expect(other.value5, 136);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 100);
      expect(other.value1, 'a');
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 85);
      expect(other.value5, 136);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 'a');
      expect(other.value3, 160);
      expect(other.value4, 85);
      expect(other.value5, 136);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 'a');
      expect(other.value4, 85);
      expect(other.value5, 136);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 'a');
      expect(other.value5, 136);
    });
    test('with5', () {
      final other = tuple.with5('a');
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 85);
      expect(other.value5, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 100);
      expect(other.value2, 110);
      expect(other.value3, 80);
      expect(other.value4, 160);
      expect(other.value5, 85);
      expect(other.value6, 136);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 85);
      expect(other.value5, 136);
      expect(other.value6, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 100);
      expect(other.value2, 110);
      expect(other.value3, 80);
      expect(other.value4, 160);
      expect(other.value5, 85);
      expect(other.value6, 136);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 100);
      expect(other.value1, 'a');
      expect(other.value2, 110);
      expect(other.value3, 80);
      expect(other.value4, 160);
      expect(other.value5, 85);
      expect(other.value6, 136);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 'a');
      expect(other.value3, 80);
      expect(other.value4, 160);
      expect(other.value5, 85);
      expect(other.value6, 136);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 'a');
      expect(other.value4, 160);
      expect(other.value5, 85);
      expect(other.value6, 136);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 'a');
      expect(other.value5, 85);
      expect(other.value6, 136);
    });
    test('addAt5', () {
      final other = tuple.addAt5('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 85);
      expect(other.value5, 'a');
      expect(other.value6, 136);
    });
    test('addAt6', () {
      final other = tuple.addAt6('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 85);
      expect(other.value5, 136);
      expect(other.value6, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 110);
      expect(other.value1, 80);
      expect(other.value2, 160);
      expect(other.value3, 85);
      expect(other.value4, 136);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 85);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 110);
      expect(other.value1, 80);
      expect(other.value2, 160);
      expect(other.value3, 85);
      expect(other.value4, 136);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 100);
      expect(other.value1, 80);
      expect(other.value2, 160);
      expect(other.value3, 85);
      expect(other.value4, 136);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 160);
      expect(other.value3, 85);
      expect(other.value4, 136);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 85);
      expect(other.value4, 136);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 136);
    });
    test('removeAt5', () {
      final other = tuple.removeAt5();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 100);
      expect(other.value1, 110);
      expect(other.value2, 80);
      expect(other.value3, 160);
      expect(other.value4, 85);
    });
    test('length', () {
      expect(tuple.length, 6);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[100, 110, 80, 160, 85, 136]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[100, 110, 80, 160, 85, 136]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{100, 110, 80, 160, 85, 136});
    });
    test('toString', () {
      expect(tuple.toString(), '(100, 110, 80, 160, 85, 136)');
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
    const tuple = Tuple7(148, 159, 123, 142, 224, 17, 183);
    test('fromList', () {
      final other = Tuple.fromList([148, 159, 123, 142, 224, 17, 183]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 148);
      expect(tuple.value1, 159);
      expect(tuple.value2, 123);
      expect(tuple.value3, 142);
      expect(tuple.value4, 224);
      expect(tuple.value5, 17);
      expect(tuple.value6, 183);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
      expect(other.value6, 183);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 148);
      expect(other.value1, 'a');
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
      expect(other.value6, 183);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 'a');
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
      expect(other.value6, 183);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 'a');
      expect(other.value4, 224);
      expect(other.value5, 17);
      expect(other.value6, 183);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 'a');
      expect(other.value5, 17);
      expect(other.value6, 183);
    });
    test('with5', () {
      final other = tuple.with5('a');
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 'a');
      expect(other.value6, 183);
    });
    test('with6', () {
      final other = tuple.with6('a');
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
      expect(other.value6, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 148);
      expect(other.value2, 159);
      expect(other.value3, 123);
      expect(other.value4, 142);
      expect(other.value5, 224);
      expect(other.value6, 17);
      expect(other.value7, 183);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
      expect(other.value6, 183);
      expect(other.value7, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 148);
      expect(other.value2, 159);
      expect(other.value3, 123);
      expect(other.value4, 142);
      expect(other.value5, 224);
      expect(other.value6, 17);
      expect(other.value7, 183);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 148);
      expect(other.value1, 'a');
      expect(other.value2, 159);
      expect(other.value3, 123);
      expect(other.value4, 142);
      expect(other.value5, 224);
      expect(other.value6, 17);
      expect(other.value7, 183);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 'a');
      expect(other.value3, 123);
      expect(other.value4, 142);
      expect(other.value5, 224);
      expect(other.value6, 17);
      expect(other.value7, 183);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 'a');
      expect(other.value4, 142);
      expect(other.value5, 224);
      expect(other.value6, 17);
      expect(other.value7, 183);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 'a');
      expect(other.value5, 224);
      expect(other.value6, 17);
      expect(other.value7, 183);
    });
    test('addAt5', () {
      final other = tuple.addAt5('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 'a');
      expect(other.value6, 17);
      expect(other.value7, 183);
    });
    test('addAt6', () {
      final other = tuple.addAt6('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
      expect(other.value6, 'a');
      expect(other.value7, 183);
    });
    test('addAt7', () {
      final other = tuple.addAt7('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
      expect(other.value6, 183);
      expect(other.value7, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 159);
      expect(other.value1, 123);
      expect(other.value2, 142);
      expect(other.value3, 224);
      expect(other.value4, 17);
      expect(other.value5, 183);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 159);
      expect(other.value1, 123);
      expect(other.value2, 142);
      expect(other.value3, 224);
      expect(other.value4, 17);
      expect(other.value5, 183);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 148);
      expect(other.value1, 123);
      expect(other.value2, 142);
      expect(other.value3, 224);
      expect(other.value4, 17);
      expect(other.value5, 183);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 142);
      expect(other.value3, 224);
      expect(other.value4, 17);
      expect(other.value5, 183);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 224);
      expect(other.value4, 17);
      expect(other.value5, 183);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 17);
      expect(other.value5, 183);
    });
    test('removeAt5', () {
      final other = tuple.removeAt5();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 183);
    });
    test('removeAt6', () {
      final other = tuple.removeAt6();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 148);
      expect(other.value1, 159);
      expect(other.value2, 123);
      expect(other.value3, 142);
      expect(other.value4, 224);
      expect(other.value5, 17);
    });
    test('length', () {
      expect(tuple.length, 7);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[148, 159, 123, 142, 224, 17, 183]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[148, 159, 123, 142, 224, 17, 183]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{148, 159, 123, 142, 224, 17, 183});
    });
    test('toString', () {
      expect(tuple.toString(), '(148, 159, 123, 142, 224, 17, 183)');
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
    const tuple = Tuple8(144, 195, 3, 174, 10, 221, 217, 145);
    test('fromList', () {
      final other = Tuple.fromList([144, 195, 3, 174, 10, 221, 217, 145]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 144);
      expect(tuple.value1, 195);
      expect(tuple.value2, 3);
      expect(tuple.value3, 174);
      expect(tuple.value4, 10);
      expect(tuple.value5, 221);
      expect(tuple.value6, 217);
      expect(tuple.value7, 145);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 145);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 144);
      expect(other.value1, 'a');
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 145);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 'a');
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 145);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 'a');
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 145);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 'a');
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 145);
    });
    test('with5', () {
      final other = tuple.with5('a');
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 'a');
      expect(other.value6, 217);
      expect(other.value7, 145);
    });
    test('with6', () {
      final other = tuple.with6('a');
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 'a');
      expect(other.value7, 145);
    });
    test('with7', () {
      final other = tuple.with7('a');
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 'a');
    });
    test('addFirst', () {
      final other = tuple.addFirst('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 144);
      expect(other.value2, 195);
      expect(other.value3, 3);
      expect(other.value4, 174);
      expect(other.value5, 10);
      expect(other.value6, 221);
      expect(other.value7, 217);
      expect(other.value8, 145);
    });
    test('addLast', () {
      final other = tuple.addLast('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 145);
      expect(other.value8, 'a');
    });
    test('addAt0', () {
      final other = tuple.addAt0('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 'a');
      expect(other.value1, 144);
      expect(other.value2, 195);
      expect(other.value3, 3);
      expect(other.value4, 174);
      expect(other.value5, 10);
      expect(other.value6, 221);
      expect(other.value7, 217);
      expect(other.value8, 145);
    });
    test('addAt1', () {
      final other = tuple.addAt1('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 'a');
      expect(other.value2, 195);
      expect(other.value3, 3);
      expect(other.value4, 174);
      expect(other.value5, 10);
      expect(other.value6, 221);
      expect(other.value7, 217);
      expect(other.value8, 145);
    });
    test('addAt2', () {
      final other = tuple.addAt2('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 'a');
      expect(other.value3, 3);
      expect(other.value4, 174);
      expect(other.value5, 10);
      expect(other.value6, 221);
      expect(other.value7, 217);
      expect(other.value8, 145);
    });
    test('addAt3', () {
      final other = tuple.addAt3('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 'a');
      expect(other.value4, 174);
      expect(other.value5, 10);
      expect(other.value6, 221);
      expect(other.value7, 217);
      expect(other.value8, 145);
    });
    test('addAt4', () {
      final other = tuple.addAt4('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 'a');
      expect(other.value5, 10);
      expect(other.value6, 221);
      expect(other.value7, 217);
      expect(other.value8, 145);
    });
    test('addAt5', () {
      final other = tuple.addAt5('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 'a');
      expect(other.value6, 221);
      expect(other.value7, 217);
      expect(other.value8, 145);
    });
    test('addAt6', () {
      final other = tuple.addAt6('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 'a');
      expect(other.value7, 217);
      expect(other.value8, 145);
    });
    test('addAt7', () {
      final other = tuple.addAt7('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 'a');
      expect(other.value8, 145);
    });
    test('addAt8', () {
      final other = tuple.addAt8('a');
      expect(other.length, tuple.length + 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
      expect(other.value7, 145);
      expect(other.value8, 'a');
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 195);
      expect(other.value1, 3);
      expect(other.value2, 174);
      expect(other.value3, 10);
      expect(other.value4, 221);
      expect(other.value5, 217);
      expect(other.value6, 145);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 195);
      expect(other.value1, 3);
      expect(other.value2, 174);
      expect(other.value3, 10);
      expect(other.value4, 221);
      expect(other.value5, 217);
      expect(other.value6, 145);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 144);
      expect(other.value1, 3);
      expect(other.value2, 174);
      expect(other.value3, 10);
      expect(other.value4, 221);
      expect(other.value5, 217);
      expect(other.value6, 145);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 174);
      expect(other.value3, 10);
      expect(other.value4, 221);
      expect(other.value5, 217);
      expect(other.value6, 145);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 10);
      expect(other.value4, 221);
      expect(other.value5, 217);
      expect(other.value6, 145);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 221);
      expect(other.value5, 217);
      expect(other.value6, 145);
    });
    test('removeAt5', () {
      final other = tuple.removeAt5();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 217);
      expect(other.value6, 145);
    });
    test('removeAt6', () {
      final other = tuple.removeAt6();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 145);
    });
    test('removeAt7', () {
      final other = tuple.removeAt7();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 144);
      expect(other.value1, 195);
      expect(other.value2, 3);
      expect(other.value3, 174);
      expect(other.value4, 10);
      expect(other.value5, 221);
      expect(other.value6, 217);
    });
    test('length', () {
      expect(tuple.length, 8);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[144, 195, 3, 174, 10, 221, 217, 145]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[144, 195, 3, 174, 10, 221, 217, 145]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{144, 195, 3, 174, 10, 221, 217, 145});
    });
    test('toString', () {
      expect(tuple.toString(), '(144, 195, 3, 174, 10, 221, 217, 145)');
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
    const tuple = Tuple9(204, 250, 23, 39, 140, 220, 127, 11, 73);
    test('fromList', () {
      final other = Tuple.fromList([204, 250, 23, 39, 140, 220, 127, 11, 73]);
      expect(other, tuple);
    });
    test('read', () {
      expect(tuple.value0, 204);
      expect(tuple.value1, 250);
      expect(tuple.value2, 23);
      expect(tuple.value3, 39);
      expect(tuple.value4, 140);
      expect(tuple.value5, 220);
      expect(tuple.value6, 127);
      expect(tuple.value7, 11);
      expect(tuple.value8, 73);
    });
    test('with0', () {
      final other = tuple.with0('a');
      expect(other.value0, 'a');
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 11);
      expect(other.value8, 73);
    });
    test('with1', () {
      final other = tuple.with1('a');
      expect(other.value0, 204);
      expect(other.value1, 'a');
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 11);
      expect(other.value8, 73);
    });
    test('with2', () {
      final other = tuple.with2('a');
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 'a');
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 11);
      expect(other.value8, 73);
    });
    test('with3', () {
      final other = tuple.with3('a');
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 'a');
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 11);
      expect(other.value8, 73);
    });
    test('with4', () {
      final other = tuple.with4('a');
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 'a');
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 11);
      expect(other.value8, 73);
    });
    test('with5', () {
      final other = tuple.with5('a');
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 'a');
      expect(other.value6, 127);
      expect(other.value7, 11);
      expect(other.value8, 73);
    });
    test('with6', () {
      final other = tuple.with6('a');
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 'a');
      expect(other.value7, 11);
      expect(other.value8, 73);
    });
    test('with7', () {
      final other = tuple.with7('a');
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 'a');
      expect(other.value8, 73);
    });
    test('with8', () {
      final other = tuple.with8('a');
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 11);
      expect(other.value8, 'a');
    });
    test('add', () {
      expect(() => tuple.addFirst(-1), throwsStateError);
      expect(() => tuple.addLast(-1), throwsStateError);
    });
    test('removeFirst', () {
      final other = tuple.removeFirst();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 250);
      expect(other.value1, 23);
      expect(other.value2, 39);
      expect(other.value3, 140);
      expect(other.value4, 220);
      expect(other.value5, 127);
      expect(other.value6, 11);
      expect(other.value7, 73);
    });
    test('removeLast', () {
      final other = tuple.removeLast();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 11);
    });
    test('removeAt0', () {
      final other = tuple.removeAt0();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 250);
      expect(other.value1, 23);
      expect(other.value2, 39);
      expect(other.value3, 140);
      expect(other.value4, 220);
      expect(other.value5, 127);
      expect(other.value6, 11);
      expect(other.value7, 73);
    });
    test('removeAt1', () {
      final other = tuple.removeAt1();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 23);
      expect(other.value2, 39);
      expect(other.value3, 140);
      expect(other.value4, 220);
      expect(other.value5, 127);
      expect(other.value6, 11);
      expect(other.value7, 73);
    });
    test('removeAt2', () {
      final other = tuple.removeAt2();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 39);
      expect(other.value3, 140);
      expect(other.value4, 220);
      expect(other.value5, 127);
      expect(other.value6, 11);
      expect(other.value7, 73);
    });
    test('removeAt3', () {
      final other = tuple.removeAt3();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 140);
      expect(other.value4, 220);
      expect(other.value5, 127);
      expect(other.value6, 11);
      expect(other.value7, 73);
    });
    test('removeAt4', () {
      final other = tuple.removeAt4();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 220);
      expect(other.value5, 127);
      expect(other.value6, 11);
      expect(other.value7, 73);
    });
    test('removeAt5', () {
      final other = tuple.removeAt5();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 127);
      expect(other.value6, 11);
      expect(other.value7, 73);
    });
    test('removeAt6', () {
      final other = tuple.removeAt6();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 11);
      expect(other.value7, 73);
    });
    test('removeAt7', () {
      final other = tuple.removeAt7();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 73);
    });
    test('removeAt8', () {
      final other = tuple.removeAt8();
      expect(other.length, tuple.length - 1);
      expect(other.value0, 204);
      expect(other.value1, 250);
      expect(other.value2, 23);
      expect(other.value3, 39);
      expect(other.value4, 140);
      expect(other.value5, 220);
      expect(other.value6, 127);
      expect(other.value7, 11);
    });
    test('length', () {
      expect(tuple.length, 9);
    });
    test('iterable', () {
      expect(tuple.iterable, <Object>[204, 250, 23, 39, 140, 220, 127, 11, 73]);
    });
    test('toList', () {
      expect(tuple.toList(), <Object>[204, 250, 23, 39, 140, 220, 127, 11, 73]);
    });
    test('toSet', () {
      expect(tuple.toSet(), <Object>{204, 250, 23, 39, 140, 220, 127, 11, 73});
    });
    test('toString', () {
      expect(tuple.toString(), '(204, 250, 23, 39, 140, 220, 127, 11, 73)');
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
  test('fromList (error)', () {
    expect(
        () => Tuple.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]), throwsStateError);
  });
}
