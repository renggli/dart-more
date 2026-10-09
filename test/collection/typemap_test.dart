// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart' show test;

void main() {
  test('empty', () {
    final map = TypeMap<Object>();
    check(map.hasInstance<String>()).isFalse();
    check(map.getInstance<String>()).isNull();
    check(map.types).isEmpty();
    check(map.instances).isEmpty();
    check(map.length).equals(0);
    check(map.isEmpty).isTrue();
    check(map.isNotEmpty).isFalse();
    check(map.asMap()).isEmpty();
    check(map.toString()).equals('{}');
  });
  test('single', () {
    final map = TypeMap<Object>();
    map.setInstance('hello');
    check(map.hasInstance<String>()).isTrue();
    check(map.getInstance<String>()).equals('hello');
    check(map.hasInstance<int>()).isFalse();
    check(map.getInstance<int>()).isNull();
    check(map.types).deepEquals([String]);
    check(map.instances).deepEquals(['hello']);
    check(map.length).equals(1);
    check(map.isEmpty).isFalse();
    check(map.isNotEmpty).isTrue();
    check(map.asMap()).deepEquals({String: 'hello'});
    check(map.toString()).equals('{String: hello}');
  });
  test('double', () {
    final map = TypeMap<Object>();
    map.setInstance('hello');
    check(map.hasInstance<String>()).isTrue();
    check(map.getInstance<String>()).equals('hello');
    check(map.hasInstance<int>()).isFalse();
    check(map.getInstance<int>(ifAbsentPut: () => 42)).equals(42);
    check(map.hasInstance<int>()).isTrue();
    check(map.getInstance<int>(ifAbsentPut: () => 52)).equals(42);
    check(map.types).deepEquals([String, int]);
    check(map.instances).deepEquals(['hello', 42]);
    check(map.length).equals(2);
    check(map.isEmpty).isFalse();
    check(map.isNotEmpty).isTrue();
    check(map.asMap()).deepEquals({String: 'hello', int: 42});
    check(map.toString()).equals('{String: hello, int: 42}');
  });
}
