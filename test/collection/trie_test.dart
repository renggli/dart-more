// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/math.dart';
import 'package:test/test.dart' show group, test;

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
      check(trie).length.equals(1);
      check(trie.keys).deepEquals(['disobey']);
      check(trie.values).deepEquals([42]);
      check(trie['disobey']).equals(42);
      check(trie.containsKey('disobey')).isTrue();
      check(trie['dis']).isNull();
      check(trie.containsKey('dis')).isFalse();
      check(trie['disobeying']).isNull();
      check(trie.containsKey('disobeying')).isFalse();
    });
    test('null value', () {
      final trie = Trie<String, String, int?>(
        parts: (key) => key.toList(),
        root: createRoot<String, String, int?>(),
      );
      trie['foo'] = null;
      check(trie).length.equals(1);
      check(trie.containsKey('foo')).isTrue();
      check(trie['foo']).isNull();
      check(trie.entries.first.value).isNull();
    });
    test('multiple', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disorder'] = 43;
      trie['disown'] = 44;
      trie['distrust'] = 45;
      check(trie).length.equals(4);
      check(trie.keys)
          .deepEquals(['disobey', 'disorder', 'disown', 'distrust']);
      check(trie.values).deepEquals([42, 43, 44, 45]);
      check(trie.keysWithPrefix('dis'))
          .deepEquals(['disobey', 'disorder', 'disown', 'distrust']);
      check(trie.keysWithPrefix('diso'))
          .deepEquals(['disobey', 'disorder', 'disown']);
      check(trie.keysWithPrefix('disobeying')).isEmpty();
      check(trie['disobey']).equals(42);
      check(trie.containsKey('disobey')).isTrue();
      check(trie['disorder']).equals(43);
      check(trie.containsKey('disorder')).isTrue();
      check(trie['disown']).equals(44);
      check(trie.containsKey('disown')).isTrue();
      check(trie['distrust']).equals(45);
      check(trie.containsKey('distrust')).isTrue();
      check(trie['dis']).isNull();
      check(trie.containsKey('dis')).isFalse();
      check(trie['disobeying']).isNull();
      check(trie.containsKey('disobeying')).isFalse();
    });
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      check(trie).length.equals(1);
      check(trie.keys).deepEquals(['']);
      check(trie.values).deepEquals([42]);
      check(trie['']).equals(42);
      check(trie.containsKey('')).isTrue();
      check(trie['dis']).isNull();
      check(trie.containsKey('dis')).isFalse();
    });
    test('replace', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disobey'] = 43;
      check(trie).length.equals(1);
      check(trie.keys).deepEquals(['disobey']);
      check(trie.values).deepEquals([43]);
      check(trie['disobey']).equals(43);
      check(trie.containsKey('disobey')).isTrue();
      check(trie['dis']).isNull();
      check(trie.containsKey('dis')).isFalse();
      check(trie['disobeying']).isNull();
      check(trie.containsKey('disobeying')).isFalse();
    });
    test('enhancing', () {
      final trie = newTrie();
      trie['disobeying'] = 42;
      trie['disobey'] = 43;
      check(trie).length.equals(2);
      check(trie.keys).deepEquals(['disobey', 'disobeying']);
      check(trie.values).deepEquals([43, 42]);
      check(trie['disobeying']).equals(42);
      check(trie.containsKey('disobeying')).isTrue();
      check(trie['disobey']).equals(43);
      check(trie.containsKey('disobey')).isTrue();
      check(trie['dis']).isNull();
      check(trie.containsKey('dis')).isFalse();
    });
  });
  group('remove', () {
    test('missing', () {
      final trie = newTrie();
      check(trie.remove('disobey')).isNull();
      check(trie.containsKey('disobey')).isFalse();
      check(trie).length.equals(0);
      check(trie.keys).isEmpty();
      check(trie.values).isEmpty();
    });
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      check(trie.remove('')).equals(42);
      check(trie.containsKey('')).isFalse();
      check(trie).length.equals(0);
      check(trie.keys).isEmpty();
      check(trie.values).isEmpty();
    });
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      check(trie.remove('disobey')).equals(42);
      check(trie.containsKey('disobey')).isFalse();
      check(trie).length.equals(0);
      check(trie.keys).isEmpty();
      check(trie.values).isEmpty();
    });
    test('prefix', () {
      final trie = newTrie();
      trie['dis'] = 42;
      trie['disorder'] = 43;
      check(trie.remove('dis')).equals(42);
      check(trie.containsKey('dis')).isFalse();
      check(trie.containsKey('disorder')).isTrue();
      check(trie).length.equals(1);
      check(trie.keys).deepEquals(['disorder']);
      check(trie.values).deepEquals([43]);
    });
    test('root prefix', () {
      final trie = newTrie();
      trie[''] = 42;
      trie['disorder'] = 43;
      check(trie.remove('')).equals(42);
      check(trie.containsKey('')).isFalse();
      check(trie.containsKey('disorder')).isTrue();
      check(trie).length.equals(1);
      check(trie.keys).deepEquals(['disorder']);
      check(trie.values).deepEquals([43]);
    });
  });
  group('clear', () {
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      trie.clear();
      check(trie.containsKey('')).isFalse();
      check(trie).length.equals(0);
      check(trie.keys).isEmpty();
      check(trie.values).isEmpty();
    });
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie.clear();
      check(trie.containsKey('disobey')).isFalse();
      check(trie).length.equals(0);
      check(trie.keys).isEmpty();
      check(trie.values).isEmpty();
    });
    test('multiple', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disobeying'] = 43;
      trie.clear();
      check(trie.containsKey('disobey')).isFalse();
      check(trie.containsKey('disobeying')).isFalse();
      check(trie).length.equals(0);
      check(trie.keys).isEmpty();
      check(trie.values).isEmpty();
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
      check(firstTrie).length.equals(1);
      check(firstTrie.keys).deepEquals(['abc']);
      check(firstTrie.values).deepEquals([42]);
      check(secondTrie).length.equals(2);
      check(secondTrie.keys).deepEquals(['abc', 'abcdef']);
      check(secondTrie.values).deepEquals([42, 43]);
    });
    test('fromMap', () {
      final trie = Trie<String, String, int>.fromMap(
        {'abc': 42, 'abcdef': 43},
        parts: (key) => key.toList(),
        root: createRoot(),
      );
      check(trie).length.equals(2);
      check(trie.keys).deepEquals(['abc', 'abcdef']);
      check(trie.values).deepEquals([42, 43]);
    });
    test('fromIterable', () {
      final trie = Trie<String, String, int>.fromIterable(
        ['abc', 'abcdef'],
        parts: (key) => key.toList(),
        value: (value) => (value as String).length,
        root: createRoot(),
      );
      check(trie).length.equals(2);
      check(trie.keys).deepEquals(['abc', 'abcdef']);
      check(trie.values).deepEquals([3, 6]);
    });
    test('fromIterables', () {
      final trie = Trie<String, String, int>.fromIterables(
        ['abc', 'abcdef'],
        [42, 43],
        parts: (key) => key.toList(),
        root: createRoot(),
      );
      check(trie).length.equals(2);
      check(trie.keys).deepEquals(['abc', 'abcdef']);
      check(trie.values).deepEquals([42, 43]);
    });
    test('fromIterables (error)', () {
      check(
        () => Trie<String, String, int>.fromIterables(
          ['abc', 'abcdef'],
          [42],
          parts: (key) => key.toList(),
          root: createRoot(),
        ),
      ).throws<ArgumentError>();
    });
  });
  group('other', () {
    test('typed', () {
      final trie = newTrie();
      check(trie.containsKey(42)).isFalse();
      check(trie[42]).isNull();
    });
    test('nodes', () {
      final trie = newTrie();
      trie.addAll({'a': 1, 'aa': 2, 'ab': 3});
      final root = createRoot<String, String, num>();
      check(root.hasKeyAndValue).isFalse();
      check(root.hasChildren).isFalse();
      check(root.parts).isEmpty();
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
      check(trie).length.equals(values.length);
      for (final value in values) {
        check(trie.containsKey(value)).isTrue();
        check(trie[value]).isNotNull().isTrue();
      }
      // Remove values in different order.
      values.shuffle(random);
      for (final value in values) {
        check(trie.remove(value)).isNotNull().isTrue();
      }
      // Verify all values are gone.
      check(trie).isEmpty();
      for (final value in values) {
        check(trie.containsKey(value)).isFalse();
        check(trie[value]).isNull();
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
