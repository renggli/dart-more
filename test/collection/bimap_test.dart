// ignore_for_file: collection_methods_unrelated_type

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  final example = BiMap.of({1: 'a', 2: 'b', 3: 'c'});

  group('construction', () {
    test('empty', () {
      final target = BiMap<int, String>();
      check(target).isEmpty();
      check(target.isEmpty).isTrue();
      check(target.isNotEmpty).isFalse();
      check(target).length.equals(0);
    });
    test('identity', () {
      final target = BiMap<int, String>.identity();
      check(target).isEmpty();
      check(target.isEmpty).isTrue();
      check(target.isNotEmpty).isFalse();
      check(target).length.equals(0);
    });
    test('of', () {
      final target = BiMap<int, String>.of(example);
      check(target.keys).deepEquals([1, 2, 3]);
      check(target.values).deepEquals(['a', 'b', 'c']);
    });
    test('from', () {
      final target = BiMap<int, String>.from(example);
      check(target.keys).deepEquals([1, 2, 3]);
      check(target.values).deepEquals(['a', 'b', 'c']);
    });
    test('iterable', () {
      final target = BiMap<int, int>.fromIterable(example.keys);
      check(target.keys).deepEquals([1, 2, 3]);
      check(target.values).deepEquals([1, 2, 3]);
    });
    test('iterable (key)', () {
      final target = BiMap<int, int>.fromIterable(
        example.keys,
        key: (e) => (e as int) + 1,
      );
      check(target.keys).deepEquals([2, 3, 4]);
      check(target.values).deepEquals([1, 2, 3]);
    });
    test('iterable (value)', () {
      final target = BiMap<int, int>.fromIterable(
        example.keys,
        value: (e) => (e as int) + 1,
      );
      check(target.keys).deepEquals([1, 2, 3]);
      check(target.values).deepEquals([2, 3, 4]);
    });
    test('iterables', () {
      final target = BiMap.fromIterables(example.keys, example.values);
      check(target.keys).deepEquals([1, 2, 3]);
      check(target.values).deepEquals(['a', 'b', 'c']);
    });
    test('iterables (reverse)', () {
      final target = BiMap.fromIterables(example.values, example.keys);
      check(target.keys).deepEquals(['a', 'b', 'c']);
      check(target.values).deepEquals([1, 2, 3]);
    });
    test('iterables (error)', () {
      check(() => BiMap.fromIterables([1], [])).throws<ArgumentError>();
      check(() => BiMap.fromIterables([], [1])).throws<ArgumentError>();
    });
    test('map converter', () {
      final target = example.toBiMap();
      check(target.keys).deepEquals([1, 2, 3]);
      check(target.values).deepEquals(['a', 'b', 'c']);
    });
    test('iterable converter', () {
      final target = [
        0,
        1,
        2,
      ].toBiMap(key: (e) => e + 1, value: (e) => String.fromCharCode(97 + e));
      check(target.keys).deepEquals([1, 2, 3]);
      check(target.values).deepEquals(['a', 'b', 'c']);
    });
    test('iterable converter (default key and value providers)', () {
      final target = ['a', 'b'].toBiMap<String, String>();
      check(target.keys).deepEquals(['a', 'b']);
      check(target.values).deepEquals(['a', 'b']);
    });
  });

  group('accessing', () {
    test('indexed', () {
      check(example[2]).equals('b');
      check(example['b']).isNull();
    });
    test('indexed of inverse', () {
      check(example.inverse['b']).equals(2);
      check(example.inverse[2]).isNull();
    });
    test('keys', () {
      check(example.keys).deepEquals([1, 2, 3]);
      check(example.containsKey(2)).isTrue();
      check(example.containsKey('b')).isFalse();
    });
    test('keys of inverse', () {
      check(example.inverse.keys).deepEquals(['a', 'b', 'c']);
      check(example.inverse.containsKey(2)).isFalse();
      check(example.inverse.containsKey('b')).isTrue();
    });
    test('values', () {
      check(example.values).deepEquals(['a', 'b', 'c']);
      check(example.containsValue(2)).isFalse();
      check(example.containsValue('b')).isTrue();
    });
    test('values of inverse', () {
      check(example.inverse.values).deepEquals([1, 2, 3]);
      check(example.inverse.containsValue(2)).isTrue();
      check(example.inverse.containsValue('b')).isFalse();
    });
    test('inverse updates', () {
      final target = BiMap.of(example);
      final inverse = target.inverse;
      target[4] = 'd';
      check(inverse['d'], because: 'inverse sees addition').equals(4);
      target.remove(3);
      check(inverse[3], because: 'inverse sees removal').isNull();
      inverse['e'] = 5;
      check(target[5], because: 'inverse updates target').equals('e');
      inverse.remove('d');
      check(target[4], because: 'inverse updates target').isNull();
    });
    test('forward updates', () {
      final target = BiMap.of(example);
      final forward = target.forward;
      target[4] = 'd';
      check(forward[4], because: 'inverse sees addition').equals('d');
      target.remove(3);
      check(forward[3], because: 'inverse sees removal').isNull();
      forward[5] = 'e';
      check(target[5], because: 'inverse updates target').equals('e');
      forward.remove(4);
      check(target[4], because: 'inverse updates target').isNull();
    });
    test('backward updates', () {
      final target = BiMap.of(example);
      final backward = target.backward;
      target[4] = 'd';
      check(backward['d'], because: 'inverse sees addition').equals(4);
      target.remove(3);
      check(backward[3], because: 'inverse sees removal').isNull();
      backward['e'] = 5;
      check(target[5], because: 'inverse updates target').equals('e');
      backward.remove('d');
      check(target[4], because: 'inverse updates target').isNull();
    });
    test('iteration', () {
      final keys = <int>[];
      final values = <String>[];
      example.forEach((key, value) {
        keys.add(key);
        values.add(value);
      });
      check(example.keys).deepEquals(keys);
      check(example.values).deepEquals(values);
    });
  });

  group('writing', () {
    test('define', () {
      final target = BiMap<int, String>();
      target[1] = 'a';
      check(target.keys).deepEquals([1]);
      check(target.values).deepEquals(['a']);
    });
    test('define inverse', () {
      final target = BiMap<String, int>();
      target.inverse[1] = 'a';
      check(target.keys).deepEquals(['a']);
      check(target.values).deepEquals([1]);
    });
    test('redefine key to new value', () {
      final target = BiMap.of(example);
      target[2] = 'd';
      check(target.keys).deepEquals([1, 3, 2]);
      check(target.values).deepEquals(['a', 'c', 'd']);
    });
    test('redefine value to new key', () {
      final target = BiMap.of(example);
      target[4] = 'b';
      check(target.keys).deepEquals([1, 3, 4]);
      check(target.values).deepEquals(['a', 'c', 'b']);
    });
    test('redefine key and value', () {
      final target = BiMap.of(example);
      target[1] = 'c';
      check(target.keys).deepEquals([2, 1]);
      check(target.values).deepEquals(['b', 'c']);
    });
    test('remove key', () {
      final target = BiMap.of(example);
      check(target.remove(2)).equals('b');
      check(target.keys).deepEquals([1, 3]);
      check(target.values).deepEquals(['a', 'c']);
      check(target.inverse.keys).deepEquals(['a', 'c']);
      check(target.inverse.values).deepEquals([1, 3]);
    });
    test('remove value', () {
      final target = BiMap.of(example);
      check(target.inverse.remove('b')).equals(2);
      check(target.keys).deepEquals([1, 3]);
      check(target.values).deepEquals(['a', 'c']);
      check(target.inverse.keys).deepEquals(['a', 'c']);
      check(target.inverse.values).deepEquals([1, 3]);
    });
    test('clear', () {
      final target = BiMap.of(example);
      target.clear();
      check(target).isEmpty();
      check(target.inverse).isEmpty();
    });
    test('define if absent', () {
      final target = BiMap.of(example);
      target.putIfAbsent(1, () => throw StateError('Value already present!'));
      target.putIfAbsent(4, () => 'd');
      check(target[4]).equals('d');
    });
    test('putIfAbsent with null value', () {
      final target = BiMap<String, int?>()..['a'] = null;
      check(target.putIfAbsent('a', () => 42)).isNull();
    });
  });
}
