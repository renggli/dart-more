// ignore_for_file: collection_methods_unrelated_type

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('computed', () {
    test('basic', () {
      final map = <String, int>{}.withComputed(int.parse);
      check(map.containsKey('42')).isFalse();
      check(map['42']).equals(42);
      check(map.containsKey('42')).isTrue();
    });
    test('typing', () {
      final map = <String, int>{}.withComputed(int.parse);
      check(map['5'] + map['42']).equals(47);
    });
    test('modify', () {
      final map = {'1': -1}.withComputed(int.parse);
      check(map['1']).equals(-1);
      map['2'] = -2;
      check(map['2']).equals(-2);
    });
    test('throws computation error', () {
      final map = <String, int>{}.withComputed(int.parse);
      check(() => map['a']).throws<FormatException>();
      check(map.isEmpty).isTrue();
    });
    test('throws type error', () {
      final map = <String, int>{}.withComputed(int.parse);
      check(() => map[1]).throws<TypeError>();
      check(map.isEmpty).isTrue();
    });
  });
}
