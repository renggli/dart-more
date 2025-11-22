// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  test('empty', () {
    final map = TypeMap<Object>();
    expect(map.hasInstance<String>(), isFalse);
    expect(map.getInstance<String>(), isNull);
    expect(map.types, isEmpty);
    expect(map.instances, isEmpty);
    expect(map.length, 0);
    expect(map.isEmpty, isTrue);
    expect(map.isNotEmpty, isFalse);
    expect(map.asMap(), isEmpty);
    expect(map.toString(), '{}');
  });
  test('single', () {
    final map = TypeMap<Object>();
    map.setInstance('hello');
    expect(map.hasInstance<String>(), isTrue);
    expect(map.getInstance<String>(), 'hello');
    expect(map.hasInstance<int>(), isFalse);
    expect(map.getInstance<int>(), isNull);
    expect(map.types, [String]);
    expect(map.instances, ['hello']);
    expect(map.length, 1);
    expect(map.isEmpty, isFalse);
    expect(map.isNotEmpty, isTrue);
    expect(map.asMap(), {String: 'hello'});
    expect(map.toString(), '{String: hello}');
  });
  test('double', () {
    final map = TypeMap<Object>();
    map.setInstance('hello');
    expect(map.hasInstance<String>(), isTrue);
    expect(map.getInstance<String>(), 'hello');
    expect(map.hasInstance<int>(), isFalse);
    expect(map.getInstance<int>(ifAbsentPut: () => 42), 42);
    expect(map.hasInstance<int>(), isTrue);
    expect(map.getInstance<int>(ifAbsentPut: () => 52), 42);
    expect(map.types, [String, int]);
    expect(map.instances, ['hello', 42]);
    expect(map.length, 2);
    expect(map.isEmpty, isFalse);
    expect(map.isNotEmpty, isTrue);
    expect(map.asMap(), {String: 'hello', int: 42});
    expect(map.toString(), '{String: hello, int: 42}');
  });
}
