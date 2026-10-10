import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('default', () {
    test('basic', () {
      final map = {'a': 1}.withDefault(42);
      check(map.containsKey('a')).isTrue();
      check(map['a']).equals(1);
      check(map.containsKey('z')).isFalse();
      check(map['z']).equals(42);
    });
    test('typing', () {
      final map = <String, int>{}.withDefault(42);
      check(map['what'] + map['ever']).equals(84);
    });
    test('modify', () {
      final map = {'a': 1}.withDefault(-1);
      check(map['b']).equals(-1);
      map['b'] = 42;
      check(map['b']).equals(42);
    });
  });
}
