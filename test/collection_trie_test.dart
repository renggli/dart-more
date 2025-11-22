// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/math.dart';
import 'package:test/test.dart';

void allTrieTests(
  TrieNode<K, P, V> Function<K, P extends Comparable<P>, V>() createRoot,
) {
  Trie<String, String, num> newTrie() => Trie<String, String, num>(
    parts: (key) => key.toList(),
    root: createRoot<String, String, num>(),
  );
  group('add', () {
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      expect(trie, hasLength(1));
      expect(trie.keys, ['disobey']);
      expect(trie.values, [42]);
      expect(trie['disobey'], 42);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('multiple', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disorder'] = 43;
      trie['disown'] = 44;
      trie['distrust'] = 45;
      expect(trie, hasLength(4));
      expect(trie.keys, ['disobey', 'disorder', 'disown', 'distrust']);
      expect(trie.values, [42, 43, 44, 45]);
      expect(trie.keysWithPrefix('dis'), [
        'disobey',
        'disorder',
        'disown',
        'distrust',
      ]);
      expect(trie.keysWithPrefix('diso'), ['disobey', 'disorder', 'disown']);
      expect(trie.keysWithPrefix('disobeying'), isEmpty);
      expect(trie['disobey'], 42);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['disorder'], 43);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie['disown'], 44);
      expect(trie.containsKey('disown'), isTrue);
      expect(trie['distrust'], 45);
      expect(trie.containsKey('distrust'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      expect(trie, hasLength(1));
      expect(trie.keys, ['']);
      expect(trie.values, [42]);
      expect(trie[''], 42);
      expect(trie.containsKey(''), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
    });
    test('replace', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disobey'] = 43;
      expect(trie, hasLength(1));
      expect(trie.keys, ['disobey']);
      expect(trie.values, [43]);
      expect(trie['disobey'], 43);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('enhancing', () {
      final trie = newTrie();
      trie['disobeying'] = 42;
      trie['disobey'] = 43;
      expect(trie, hasLength(2));
      expect(trie.keys, ['disobey', 'disobeying']);
      expect(trie.values, [43, 42]);
      expect(trie['disobeying'], 42);
      expect(trie.containsKey('disobeying'), isTrue);
      expect(trie['disobey'], 43);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
    });
  });
  group('remove', () {
    test('missing', () {
      final trie = newTrie();
      expect(trie.remove('disobey'), isNull);
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      expect(trie.remove(''), 42);
      expect(trie.containsKey(''), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      expect(trie.remove('disobey'), 42);
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('prefix', () {
      final trie = newTrie();
      trie['dis'] = 42;
      trie['disorder'] = 43;
      expect(trie.remove('dis'), 42);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie, hasLength(1));
      expect(trie.keys, ['disorder']);
      expect(trie.values, [43]);
    });
    test('root prefix', () {
      final trie = newTrie();
      trie[''] = 42;
      trie['disorder'] = 43;
      expect(trie.remove(''), 42);
      expect(trie.containsKey(''), isFalse);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie, hasLength(1));
      expect(trie.keys, ['disorder']);
      expect(trie.values, [43]);
    });
  });
  group('clear', () {
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      trie.clear();
      expect(trie.containsKey(''), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie.clear();
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('multiple', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disobeying'] = 43;
      trie.clear();
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie.containsKey('disobeying'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
  });
  group('constructor', () {
    test('fromTrie', () {
      final firstTrie = newTrie();
      firstTrie['abc'] = 42;
      final secondTrie = Trie<String, String, num>.fromTrie(
        firstTrie,
        root: createRoot<String, String, num>(),
      );
      secondTrie['abcdef'] = 43;
      expect(firstTrie, hasLength(1));
      expect(firstTrie.keys, ['abc']);
      expect(firstTrie.values, [42]);
      expect(secondTrie, hasLength(2));
      expect(secondTrie.keys, ['abc', 'abcdef']);
      expect(secondTrie.values, [42, 43]);
    });
    test('fromMap', () {
      final trie = Trie<String, String, int>.fromMap(
        {'abc': 42, 'abcdef': 43},
        parts: (key) => key.toList(),
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [42, 43]);
    });
    test('fromIterable', () {
      final trie = Trie<String, String, int>.fromIterable(
        ['abc', 'abcdef'],
        parts: (key) => key.toList(),
        value: (value) => (value as String).length,
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [3, 6]);
    });
    test('fromIterables', () {
      final trie = Trie<String, String, int>.fromIterables(
        ['abc', 'abcdef'],
        [42, 43],
        parts: (key) => key.toList(),
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [42, 43]);
    });
    test('fromIterables (error)', () {
      expect(
        () => Trie<String, String, int>.fromIterables(
          ['abc', 'abcdef'],
          [42],
          parts: (key) => key.toList(),
          root: createRoot(),
        ),
        throwsArgumentError,
      );
    });
  });
  group('other', () {
    test('typed', () {
      final trie = newTrie();
      expect(trie.containsKey(42), isFalse);
      expect(trie[42], isNull);
    });
    test('nodes', () {
      final trie = newTrie();
      trie.addAll({'a': 1, 'aa': 2, 'ab': 3});
      final root = createRoot<String, String, num>();
      expect(root.hasKeyAndValue, isFalse);
      expect(root.hasChildren, isFalse);
      expect(root.parts, isEmpty);
    });
    test('stress', () {
      final random = Random(42);
      final numbers = <int>{};
      // Create 1000 unique numbers.
      while (numbers.length < 1000) {
        numbers.add(random.nextInt(0xffffff));
      }
      final values = List.of(numbers);
      // Create a trie from digit of the values.
      final trie = Trie<int, String, bool>(
        parts: (value) => value.digits().map((digit) => digit.toString()),
        root: createRoot(),
      );
      for (final value in values) {
        trie[value] = true;
      }
      // Verify all values are present.
      expect(trie, hasLength(values.length));
      for (final value in values) {
        expect(trie.containsKey(value), isTrue);
        expect(trie[value], isTrue);
      }
      // Remove values in different order.
      values.shuffle(random);
      for (final value in values) {
        expect(trie.remove(value), isTrue);
      }
      // Verify all values are gone.
      expect(trie, isEmpty);
      for (final value in values) {
        expect(trie.containsKey(value), isFalse);
        expect(trie[value], isNull);
      }
    });
  });
}

void main() {
  group(
    'list-based',
    () => allTrieTests(
      <K, P extends Comparable<P>, V>() => TrieNodeList<K, P, V>(),
    ),
  );
  group(
    'map-based',
    () => allTrieTests(
      <K, P extends Comparable<P>, V>() => TrieNodeMap<K, P, V>(),
    ),
  );
}
