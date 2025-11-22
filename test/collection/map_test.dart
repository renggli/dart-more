// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('computed', () {
    test('basic', () {
      final map = <String, int>{}.withComputed(int.parse);
      expect(map.containsKey('42'), false);
      expect(map['42'], 42);
      expect(map.containsKey('42'), true);
    });
    test('typing', () {
      final map = <String, int>{}.withComputed(int.parse);
      expect(map['5'] + map['42'], 47);
    });
    test('modify', () {
      final map = {'1': -1}.withComputed(int.parse);
      expect(map['1'], -1);
      map['2'] = -2;
      expect(map['2'], -2);
    });
    test('throws computation error', () {
      final map = <String, int>{}.withComputed(int.parse);
      expect(() => map['a'], throwsFormatException);
      expect(map.isEmpty, isTrue);
    });
    test('throws type error', () {
      final map = <String, int>{}.withComputed(int.parse);
      expect(() => map[1], throwsA(isA<TypeError>()));
      expect(map.isEmpty, isTrue);
    });
  });
  group('default', () {
    test('basic', () {
      final map = {'a': 1}.withDefault(42);
      expect(map.containsKey('a'), isTrue);
      expect(map['a'], 1);
      expect(map.containsKey('z'), isFalse);
      expect(map['z'], 42);
    });
    test('typing', () {
      final map = <String, int>{}.withDefault(42);
      expect(map['what'] + map['ever'], 84);
    });
    test('modify', () {
      final map = {'a': 1}.withDefault(-1);
      expect(map['b'], -1);
      map['b'] = 42;
      expect(map['b'], 42);
    });
  });
}
