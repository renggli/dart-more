// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  final example = BiMap.of({1: 'a', 2: 'b', 3: 'c'});
  group('construction', () {
    test('empty', () {
      final target = BiMap<int, String>();
      expect(target, isEmpty);
      expect(target.isEmpty, isTrue);
      expect(target.isNotEmpty, isFalse);
      expect(target, hasLength(0));
    });
    test('identity', () {
      final target = BiMap<int, String>.identity();
      expect(target, isEmpty);
      expect(target.isEmpty, isTrue);
      expect(target.isNotEmpty, isFalse);
      expect(target, hasLength(0));
    });
    test('of', () {
      final target = BiMap<int, String>.of(example);
      expect(target.keys, [1, 2, 3]);
      expect(target.values, ['a', 'b', 'c']);
    });
    test('from', () {
      final target = BiMap<int, String>.from(example);
      expect(target.keys, [1, 2, 3]);
      expect(target.values, ['a', 'b', 'c']);
    });
    test('iterable', () {
      final target = BiMap<int, int>.fromIterable(example.keys);
      expect(target.keys, [1, 2, 3]);
      expect(target.values, [1, 2, 3]);
    });
    test('iterable (key)', () {
      final target = BiMap<int, int>.fromIterable(
        example.keys,
        key: (e) => (e as int) + 1,
      );
      expect(target.keys, [2, 3, 4]);
      expect(target.values, [1, 2, 3]);
    });
    test('iterable (value)', () {
      final target = BiMap<int, int>.fromIterable(
        example.keys,
        value: (e) => (e as int) + 1,
      );
      expect(target.keys, [1, 2, 3]);
      expect(target.values, [2, 3, 4]);
    });
    test('iterables', () {
      final target = BiMap.fromIterables(example.keys, example.values);
      expect(target.keys, [1, 2, 3]);
      expect(target.values, ['a', 'b', 'c']);
    });
    test('iterables (reverse)', () {
      final target = BiMap.fromIterables(example.values, example.keys);
      expect(target.keys, ['a', 'b', 'c']);
      expect(target.values, [1, 2, 3]);
    });
    test('iterables (error)', () {
      expect(() => BiMap.fromIterables([1], []), throwsArgumentError);
      expect(() => BiMap.fromIterables([], [1]), throwsArgumentError);
    });
    test('map converter', () {
      final target = example.toBiMap();
      expect(target.keys, [1, 2, 3]);
      expect(target.values, ['a', 'b', 'c']);
    });
    test('iterable converter', () {
      final target = [
        0,
        1,
        2,
      ].toBiMap(key: (e) => e + 1, value: (e) => String.fromCharCode(97 + e));
      expect(target.keys, [1, 2, 3]);
      expect(target.values, ['a', 'b', 'c']);
    });
    test('iterable converter (default key and value providers)', () {
      final target = ['a', 'b'].toBiMap<String, String>();
      expect(target.keys, ['a', 'b']);
      expect(target.values, ['a', 'b']);
    });
  });
  group('accessing', () {
    test('indexed', () {
      expect(example[2], 'b');
      expect(example['b'], isNull);
    });
    test('indexed of inverse', () {
      expect(example.inverse['b'], 2);
      expect(example.inverse[2], isNull);
    });
    test('keys', () {
      expect(example.keys, [1, 2, 3]);
      expect(example.containsKey(2), isTrue);
      expect(example.containsKey('b'), isFalse);
    });
    test('keys of inverse', () {
      expect(example.inverse.keys, ['a', 'b', 'c']);
      expect(example.inverse.containsKey(2), isFalse);
      expect(example.inverse.containsKey('b'), isTrue);
    });
    test('values', () {
      expect(example.values, ['a', 'b', 'c']);
      expect(example.containsValue(2), isFalse);
      expect(example.containsValue('b'), isTrue);
    });
    test('values of inverse', () {
      expect(example.inverse.values, [1, 2, 3]);
      expect(example.inverse.containsValue(2), isTrue);
      expect(example.inverse.containsValue('b'), isFalse);
    });
    test('inverse updates', () {
      final target = BiMap.of(example);
      final inverse = target.inverse;
      target[4] = 'd';
      expect(inverse['d'], 4, reason: 'inverse sees addition');
      target.remove(3);
      expect(inverse[3], isNull, reason: 'inverse sees removal');
      inverse['e'] = 5;
      expect(target[5], 'e', reason: 'inverse updates target');
      inverse.remove('d');
      expect(target[4], isNull, reason: 'inverse updates target');
    });
    test('forward updates', () {
      final target = BiMap.of(example);
      final forward = target.forward;
      target[4] = 'd';
      expect(forward[4], 'd', reason: 'inverse sees addition');
      target.remove(3);
      expect(forward[3], isNull, reason: 'inverse sees removal');
      forward[5] = 'e';
      expect(target[5], 'e', reason: 'inverse updates target');
      forward.remove(4);
      expect(target[4], isNull, reason: 'inverse updates target');
    });
    test('backward updates', () {
      final target = BiMap.of(example);
      final backward = target.backward;
      target[4] = 'd';
      expect(backward['d'], 4, reason: 'inverse sees addition');
      target.remove(3);
      expect(backward[3], isNull, reason: 'inverse sees removal');
      backward['e'] = 5;
      expect(target[5], 'e', reason: 'inverse updates target');
      backward.remove('d');
      expect(target[4], isNull, reason: 'inverse updates target');
    });
    test('iteration', () {
      final keys = <int>[];
      final values = <String>[];
      example.forEach((key, value) {
        keys.add(key);
        values.add(value);
      });
      expect(example.keys, keys);
      expect(example.values, values);
    });
  });
  group('writing', () {
    test('define', () {
      final target = BiMap<int, String>();
      target[1] = 'a';
      expect(target.keys, [1]);
      expect(target.values, ['a']);
    });
    test('define inverse', () {
      final target = BiMap<String, int>();
      target.inverse[1] = 'a';
      expect(target.keys, ['a']);
      expect(target.values, [1]);
    });
    test('redefine key to new value', () {
      final target = BiMap.of(example);
      target[2] = 'd';
      expect(target.keys, [1, 3, 2]);
      expect(target.values, ['a', 'c', 'd']);
    });
    test('redefine value to new key', () {
      final target = BiMap.of(example);
      target[4] = 'b';
      expect(target.keys, [1, 3, 4]);
      expect(target.values, ['a', 'c', 'b']);
    });
    test('redefine key and value', () {
      final target = BiMap.of(example);
      target[1] = 'c';
      expect(target.keys, [2, 1]);
      expect(target.values, ['b', 'c']);
    });
    test('remove key', () {
      final target = BiMap.of(example);
      expect(target.remove(2), 'b');
      expect(target.keys, [1, 3]);
      expect(target.values, ['a', 'c']);
      expect(target.inverse.keys, ['a', 'c']);
      expect(target.inverse.values, [1, 3]);
    });
    test('remove value', () {
      final target = BiMap.of(example);
      expect(target.inverse.remove('b'), 2);
      expect(target.keys, [1, 3]);
      expect(target.values, ['a', 'c']);
      expect(target.inverse.keys, ['a', 'c']);
      expect(target.inverse.values, [1, 3]);
    });
    test('clear', () {
      final target = BiMap.of(example);
      target.clear();
      expect(target, isEmpty);
      expect(target.inverse, isEmpty);
    });
    test('define if absent', () {
      final target = BiMap.of(example);
      target.putIfAbsent(1, () => throw StateError('Value already present!'));
      target.putIfAbsent(4, () => 'd');
      expect(target[4], 'd');
    });
  });
}
