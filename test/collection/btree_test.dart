// ignore_for_file: collection_methods_unrelated_type

import 'dart:collection' show SplayTreeMap;
import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/src/collection/btree.dart'
    show
        BTreeInternalNode,
        BTreeLeafNode,
        BTreeMapTestingExtension,
        BTreeNode,
        BTreeSetTestingExtension;
import 'package:test/scaffolding.dart';

K _firstKeyOf<K, V>(BTreeNode<K, V> node) => switch (node) {
  BTreeLeafNode<K, V>() => node.keys.first,
  BTreeInternalNode<K, V>() => _firstKeyOf(node.children.first),
};

K _lastKeyOf<K, V>(BTreeNode<K, V> node) => switch (node) {
  BTreeLeafNode<K, V>() => node.keys.last,
  BTreeInternalNode<K, V>() => _lastKeyOf(node.children.last),
};

void validate<K, V>(BTreeMap<K, V> tree, {bool expectValues = true}) {
  final root = tree.debugRoot;
  final firstLeaf = tree.debugFirstLeaf;
  final lastLeaf = tree.debugLastLeaf;
  check(tree.length).equals(root.size);

  if (tree.isEmpty) {
    check(root).isA<BTreeLeafNode<K, V>>();
    check(root.size).equals(0);
    final leaf = root as BTreeLeafNode<K, V>;
    if (expectValues) {
      check(leaf.values).isNotNull().isEmpty();
    } else {
      check(leaf.values).isNull();
    }
    check(firstLeaf).identicalTo(leaf);
    check(lastLeaf).identicalTo(leaf);
    check(firstLeaf.previous).isNull();
    check(lastLeaf.next).isNull();
    return;
  }

  final dfsLeaves = <BTreeLeafNode<K, V>>[];
  int? leafDepth;

  void visit(BTreeNode<K, V> node, {required bool isRoot, required int depth}) {
    if (node is BTreeLeafNode<K, V>) {
      if (expectValues) {
        check(node.values).isNotNull().length.equals(node.keys.length);
      } else {
        check(node.values).isNull();
      }
      if (isRoot) {
        check(node.keys.length).isLessOrEqual(tree.maxEntries);
      } else {
        check(node.keys.length).isGreaterOrEqual(tree.minEntries);
        check(node.keys.length).isLessOrEqual(tree.maxEntries);
      }
      for (var i = 1; i < node.keys.length; i++) {
        check(tree.comparator(node.keys[i - 1], node.keys[i])).isLessThan(0);
      }
      if (leafDepth == null) {
        leafDepth = depth;
      } else {
        check(depth).equals(leafDepth!);
      }
      dfsLeaves.add(node);
      return;
    }

    final internal = node as BTreeInternalNode<K, V>;
    check(internal.keys.length).equals(internal.children.length - 1);
    if (isRoot) {
      check(internal.children.length).isGreaterOrEqual(2);
      check(internal.children.length).isLessOrEqual(tree.maxEntries);
    } else {
      check(internal.children.length).isGreaterOrEqual(tree.minEntries);
      check(internal.children.length).isLessOrEqual(tree.maxEntries);
    }
    var sumSize = 0;
    for (final child in internal.children) {
      sumSize += child.size;
    }
    check(internal.size).equals(sumSize);

    for (var i = 1; i < internal.keys.length; i++) {
      check(tree.comparator(internal.keys[i - 1], internal.keys[i]))
          .isLessThan(0);
    }
    for (var i = 0; i < internal.keys.length; i++) {
      check(tree.comparator(_lastKeyOf(internal.children[i]), internal.keys[i]))
          .isLessThan(0);
      check(
        tree.comparator(
          internal.keys[i],
          _firstKeyOf(internal.children[i + 1]),
        ),
      ).isLessOrEqual(0);
    }
    for (final child in internal.children) {
      visit(child, isRoot: false, depth: depth + 1);
    }
  }

  visit(root, isRoot: true, depth: 0);

  final linkedLeaves = <BTreeLeafNode<K, V>>[];
  BTreeLeafNode<K, V>? current = firstLeaf;
  BTreeLeafNode<K, V>? prev;
  while (current != null) {
    check(current.previous).identicalTo(prev);
    linkedLeaves.add(current);
    prev = current;
    current = current.next;
  }
  check(prev).identicalTo(lastLeaf);
  check(linkedLeaves.length).equals(dfsLeaves.length);
  for (var i = 0; i < dfsLeaves.length; i++) {
    check(linkedLeaves[i]).identicalTo(dfsLeaves[i]);
  }
}

void main() {
  group('configuration', () {
    test('defaults', () {
      final map = BTreeMap<int, String>();
      check(map.minEntries).equals(16);
      check(map.maxEntries).equals(32);
      check(map.isEmpty).isTrue();
      validate(map);
    });

    test('custom capacities', () {
      final map = BTreeMap<int, String>(minEntries: 2, maxEntries: 4);
      check(map.minEntries).equals(2);
      check(map.maxEntries).equals(4);
      validate(map);
    });

    test('invalid capacities throw ArgumentError', () {
      check(() => BTreeMap<int, int>(maxEntries: 3)).throws<ArgumentError>();
      check(() => BTreeMap<int, int>(minEntries: 1, maxEntries: 4))
          .throws<ArgumentError>();
      check(() => BTreeMap<int, int>(minEntries: 5, maxEntries: 8))
          .throws<ArgumentError>();
      check(() => BTreeSet<int>(maxEntries: 3)).throws<ArgumentError>();
      check(() => BTreeSet<int>(minEntries: 1, maxEntries: 4))
          .throws<ArgumentError>();
    });

    test('custom comparator preserves existing key on update', () {
      final map = BTreeMap<String, int>(
        comparator: (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
        minEntries: 2,
        maxEntries: 4,
      );
      map['B'] = 2;
      map['a'] = 1;
      map['C'] = 3;
      check(map['A']).equals(1);
      check(map['b']).equals(2);
      check(map.keys.toList()).deepEquals(['a', 'B', 'C']);
      map['A'] = 10;
      check(map.length).equals(3);
      check(map['a']).equals(10);
      check(map.keys.toList()).deepEquals(['a', 'B', 'C']);
      validate(map);
    });
  });

  group('BTreeMap constructors', () {
    test('of', () {
      final map = BTreeMap<String, int>.of({'c': 3, 'a': 1, 'b': 2});
      check(map.keys.toList()).deepEquals(['a', 'b', 'c']);
      check(map.values.toList()).deepEquals([1, 2, 3]);
      validate(map);
    });

    test('of clones BTreeMap with matching configuration independently', () {
      final original = BTreeMap<int, String>(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 40; i++) {
        original[i] = 'v$i';
      }
      final clone = BTreeMap<int, String>.of(
        original,
        minEntries: 2,
        maxEntries: 4,
      );
      validate(clone);
      check(clone.keys.toList()).deepEquals(original.keys.toList());
      check(clone.values.toList()).deepEquals(original.values.toList());

      // Mutating clone does not affect original.
      clone[0] = 'changed';
      clone[100] = 'added';
      clone.remove(10);
      check(original[0]).equals('v0');
      check(original.containsKey(100)).isFalse();
      check(original[10]).equals('v10');
      validate(original);
      validate(clone);

      // Different capacities fall back to rebuild.
      final rebuilt = BTreeMap<int, String>.of(
        original,
        minEntries: 3,
        maxEntries: 6,
      );
      check(rebuilt.keys.toList()).deepEquals(original.keys.toList());
      validate(rebuilt);
    });

    test('from', () {
      final source = <Object?, Object?>{'b': 2, 'a': 1, 'c': 3};
      final map = BTreeMap<String, int>.from(
        source,
        minEntries: 2,
        maxEntries: 4,
      );
      check(map.keys.toList()).deepEquals(['a', 'b', 'c']);
      check(map.values.toList()).deepEquals([1, 2, 3]);
      validate(map);
    });

    test('fromEntries', () {
      final map = BTreeMap<int, String>.fromEntries([
        const MapEntry(3, 'three'),
        const MapEntry(1, 'one'),
        const MapEntry(2, 'two'),
      ]);
      check(map.keys.toList()).deepEquals([1, 2, 3]);
      check(map.values.toList()).deepEquals(['one', 'two', 'three']);
      validate(map);
    });

    test('fromIterable', () {
      final map = BTreeMap<int, String>.fromIterable(
        [3, 1, 2],
        key: (e) => e! as int,
        value: (e) => '#$e',
      );
      check(map.keys.toList()).deepEquals([1, 2, 3]);
      check(map.values.toList()).deepEquals(['#1', '#2', '#3']);
      validate(map);

      // Default key and value providers.
      final identity = BTreeMap<int, int>.fromIterable([3, 1, 2]);
      check(identity.keys.toList()).deepEquals([1, 2, 3]);
      check(identity.values.toList()).deepEquals([1, 2, 3]);
      validate(identity);

      // Single-pass iterable must only be iterated once.
      var iterations = 0;
      Iterable<int> singlePass() sync* {
        iterations++;
        if (iterations > 1) throw StateError('Iterated more than once');
        yield 2;
        yield 1;
        yield 3;
      }

      final single = BTreeMap<int, String>.fromIterable(
        singlePass(),
        key: (e) => e! as int,
        value: (e) => '$e',
      );
      check(iterations).equals(1);
      check(single.keys.toList()).deepEquals([1, 2, 3]);
      validate(single);
    });

    test('fromIterables', () {
      final map = BTreeMap<int, String>.fromIterables([2, 1], ['b', 'a']);
      check(map.keys.toList()).deepEquals([1, 2]);
      check(map.values.toList()).deepEquals(['a', 'b']);
      check(() => BTreeMap<int, String>.fromIterables([1, 2], ['a']))
          .throws<ArgumentError>();
      check(() => BTreeMap<int, String>.fromIterables([1], ['a', 'b']))
          .throws<ArgumentError>();
      validate(map);
    });

    test('toBTreeMap extension', () {
      final map = {'z': 26, 'a': 1}.toBTreeMap(minEntries: 2, maxEntries: 4);
      check(map.keys.toList()).deepEquals(['a', 'z']);
      check(map.minEntries).equals(2);
      check(map.maxEntries).equals(4);
      validate(map);
    });
  });

  group('BTreeMap basic operations', () {
    test('empty map', () {
      final map = BTreeMap<String, int>();
      check(map.isEmpty).isTrue();
      check(map.isNotEmpty).isFalse();
      check(map.length).equals(0);
      check(map['missing']).isNull();
      check(map[123]).isNull();
      check(map.containsKey('missing')).isFalse();
      check(map.containsKey(123)).isFalse();
      check(map.containsValue(1)).isFalse();
      check(map.indexOfKey('missing')).equals(-1);
      check(map.indexOfKey(123)).equals(-1);
      check(map.remove('missing')).isNull();
      check(map.remove(123)).isNull();
      check(() => map.firstKey).throws<StateError>();
      check(() => map.lastKey).throws<StateError>();
      check(() => map.firstEntry).throws<StateError>();
      check(() => map.lastEntry).throws<StateError>();
      check(map.removeFirst).throws<StateError>();
      check(map.removeLast).throws<StateError>();
      check(map.keys).isEmpty();
      check(map.values).isEmpty();
      check(map.entries).isEmpty();
      check(map.reversedKeys).isEmpty();
      check(map.reversedValues).isEmpty();
      check(map.reversedEntries).isEmpty();
      check(() => map.keys.first).throws<StateError>();
      check(() => map.keys.last).throws<StateError>();
      check(map.keys.contains('a')).isFalse();
      check(map.keys.contains(123)).isFalse();
      map.clear();
      check(map.isEmpty).isTrue();
    });

    test('nullable values', () {
      final map = BTreeMap<String, int?>();
      map['a'] = null;
      map['b'] = 2;
      check(map.length).equals(2);
      check(map.containsKey('a')).isTrue();
      check(map.containsValue(null)).isTrue();
      check(map.containsValue(2)).isTrue();
      check(map.containsValue(3)).isFalse();
      check(map['a']).isNull();
      check(map.containsKey('c')).isFalse();
      check(map.putIfAbsent('a', () => 99)).isNull();
      check(map['a']).isNull();
      check(map.remove('a')).isNull();
      check(map.containsKey('a')).isFalse();
      check(map.containsValue(null)).isFalse();
      check(map.length).equals(1);
      validate(map);
    });

    test('putIfAbsent and update', () {
      final map = BTreeMap<String, int>();
      check(map.putIfAbsent('a', () => 1)).equals(1);
      check(map.putIfAbsent('a', () => 2)).equals(1);
      check(map.update('a', (v) => v + 10)).equals(11);
      check(map.update('b', (v) => v, ifAbsent: () => 5)).equals(5);
      check(() => map.update('c', (v) => v)).throws<ArgumentError>();
      check(map.keys.toList()).deepEquals(['a', 'b']);
      check(map.values.toList()).deepEquals([11, 5]);
      validate(map);
    });

    test('putIfAbsent and update detect concurrent modification', () {
      final map = BTreeMap<String, int>.of({'a': 1});
      check(
        () => map.putIfAbsent('b', () {
          map['c'] = 3;
          return 2;
        }),
      ).throws<ConcurrentModificationError>();
      check(
        () => map.update('a', (v) {
          map['d'] = 4;
          return v + 1;
        }),
      ).throws<ConcurrentModificationError>();
      check(
        () => map.update(
          'e',
          (v) => v,
          ifAbsent: () {
            map['f'] = 6;
            return 5;
          },
        ),
      ).throws<ConcurrentModificationError>();
    });

    test('forEach, containsValue, updateAll, map, removeWhere', () {
      final map = BTreeMap<int, String>(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 20; i++) {
        map[i] = 'v$i';
      }
      check(map.containsValue('v0')).isTrue();
      check(map.containsValue('v19')).isTrue();
      check(map.containsValue('missing')).isFalse();

      final visited = <int>[];
      map.forEach((k, v) {
        check(v).equals('v$k');
        visited.add(k);
      });
      check(visited).deepEquals(List.generate(20, (i) => i));

      map.updateAll((k, v) => '$v!');
      check(map[5]).equals('v5!');
      check(map[19]).equals('v19!');

      final mapped = map.map((k, v) => MapEntry('$k', v.length));
      check(mapped.length).equals(20);
      check(mapped['0']).equals(3);
      check(mapped['19']).equals(4);

      map.removeWhere((k, v) => k.isEven);
      check(map.length).equals(10);
      check(map.keys.toList()).deepEquals([1, 3, 5, 7, 9, 11, 13, 15, 17, 19]);
      validate(map);

      // Concurrent modification in forEach, updateAll, map.
      check(() => map.forEach((k, v) => map[100] = 'x'))
          .throws<ConcurrentModificationError>();
      check(
        () => map.updateAll((k, v) {
          map[101] = 'y';
          return v;
        }),
      ).throws<ConcurrentModificationError>();
      check(
        () => map.map((k, v) {
          map[102] = 'z';
          return MapEntry(k, v);
        }),
      ).throws<ConcurrentModificationError>();
    });

    test('clear', () {
      final map = BTreeMap<int, int>(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 50; i++) {
        map[i] = i;
      }
      check(map.length).equals(50);
      map.clear();
      check(map.isEmpty).isTrue();
      check(map.length).equals(0);
      validate(map);
      map[10] = 100;
      check(map[10]).equals(100);
      validate(map);
    });
  });

  group('BTreeMap splits and merges', () {
    for (final (:minEntries, :maxEntries) in [
      (minEntries: 2, maxEntries: 4),
      (minEntries: 3, maxEntries: 6),
      (minEntries: 16, maxEntries: 32),
    ]) {
      test('ascending, descending, and random ($minEntries, $maxEntries)', () {
        final map = BTreeMap<int, int>(
          minEntries: minEntries,
          maxEntries: maxEntries,
        );
        // Ascending
        for (var i = 0; i < 200; i++) {
          map[i] = i * 2;
          validate(map);
        }
        check(map.length).equals(200);
        check(map.firstKey).equals(0);
        check(map.lastKey).equals(199);

        // Remove all in descending order (exercises right-to-left merges)
        for (var i = 199; i >= 0; i--) {
          check(map.remove(i)).equals(i * 2);
          validate(map);
        }
        check(map.isEmpty).isTrue();

        // Descending insert
        for (var i = 199; i >= 0; i--) {
          map[i] = i;
          validate(map);
        }
        // Remove all in ascending order (exercises left-to-right borrows/merges)
        for (var i = 0; i < 200; i++) {
          check(map.remove(i)).equals(i);
          validate(map);
        }
        check(map.isEmpty).isTrue();

        // Random insert and remove
        final random = Random(42);
        final keys = List<int>.generate(250, (i) => i)..shuffle(random);
        for (final k in keys) {
          map[k] = k + 1;
          validate(map);
        }
        keys.shuffle(random);
        for (final k in keys) {
          check(map.remove(k)).equals(k + 1);
          validate(map);
        }
        check(map.isEmpty).isTrue();
      });
    }
  });

  group('BTreeMap order statistics', () {
    test('keyAt, valueAt, entryAt, indexOfKey', () {
      final map = BTreeMap<int, String>(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 50; i++) {
        map[i * 2] = 'v${i * 2}';
      }
      for (var i = 0; i < 50; i++) {
        check(map.keyAt(i)).equals(i * 2);
        check(map.valueAt(i)).equals('v${i * 2}');
        final entry = map.entryAt(i);
        check(entry.key).equals(i * 2);
        check(entry.value).equals('v${i * 2}');
        check(map.indexOfKey(i * 2)).equals(i);
        check(map.indexOfKey(i * 2 + 1)).equals(-1);
      }
      check(map.indexOfKey('wrong-type')).equals(-1);
      check(() => map.keyAt(-1)).throws<RangeError>();
      check(() => map.keyAt(50)).throws<RangeError>();
      check(() => map.valueAt(-1)).throws<RangeError>();
      check(() => map.entryAt(50)).throws<RangeError>();
      check(() => map.removeAt(-1)).throws<RangeError>();
      check(() => map.removeAt(50)).throws<RangeError>();
    });

    test('removeAt, removeFirst, removeLast', () {
      final map = BTreeMap<int, int>(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 40; i++) {
        map[i] = i * 10;
      }
      check(map.removeFirst().key).equals(0);
      check(map.removeLast().key).equals(39);
      validate(map);
      check(map.length).equals(38);
      check(map.removeAt(10).key).equals(11);
      validate(map);
      check(map.keyAt(10)).equals(12);
      check(map.indexOfKey(12)).equals(10);
      while (map.isNotEmpty) {
        map.removeAt(map.length ~/ 2);
        validate(map);
      }
    });
  });

  group('BTreeMap navigable & range queries', () {
    test('lower, floor, ceiling, higher', () {
      final empty = BTreeMap<int, int>();
      check(empty.lowerKey(5)).isNull();
      check(empty.floorKey(5)).isNull();
      check(empty.ceilingKey(5)).isNull();
      check(empty.higherKey(5)).isNull();
      check(empty.lowerEntry(5)).isNull();
      check(empty.floorEntry(5)).isNull();
      check(empty.ceilingEntry(5)).isNull();
      check(empty.higherEntry(5)).isNull();

      final map = BTreeMap<int, int>(minEntries: 2, maxEntries: 4);
      for (var i = 10; i <= 100; i += 10) {
        map[i] = i * 2;
      }
      // Below min
      check(map.lowerKey(10)).isNull();
      check(map.floorKey(10)).equals(10);
      check(map.ceilingKey(5)).equals(10);
      check(map.higherKey(5)).equals(10);

      // Exact hit across leaf boundaries
      for (var i = 10; i <= 100; i += 10) {
        check(map.floorKey(i)).equals(i);
        check(map.floorEntry(i)?.value).equals(i * 2);
        check(map.ceilingKey(i)).equals(i);
        check(map.ceilingEntry(i)?.value).equals(i * 2);
        check(map.lowerKey(i)).equals(i == 10 ? null : i - 10);
        check(map.higherKey(i)).equals(i == 100 ? null : i + 10);
      }

      // Between keys
      check(map.lowerKey(35)).equals(30);
      check(map.floorKey(35)).equals(30);
      check(map.ceilingKey(35)).equals(40);
      check(map.higherKey(35)).equals(40);

      // Above max
      check(map.lowerKey(105)).equals(100);
      check(map.floorKey(100)).equals(100);
      check(map.ceilingKey(105)).isNull();
      check(map.higherKey(100)).isNull();
    });

    test('range, keysInRange, valuesInRange, reversed', () {
      final map = BTreeMap<int, String>(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 30; i += 2) {
        map[i] = 'v$i';
      }
      check(map.keysInRange(min: 4, max: 10).toList())
          .deepEquals([4, 6, 8, 10]);
      check(map.keysInRange(min: 4, max: 10, includeMin: false).toList())
          .deepEquals([6, 8, 10]);
      check(map.keysInRange(min: 4, max: 10, includeMax: false).toList())
          .deepEquals([4, 6, 8]);
      check(
        map
            .keysInRange(min: 4, max: 10, includeMin: false, includeMax: false)
            .toList(),
      ).deepEquals([6, 8]);
      check(map.keysInRange(min: 4, max: 10, reversed: true).toList())
          .deepEquals([10, 8, 6, 4]);
      check(
        map
            .keysInRange(
              min: 4,
              max: 10,
              includeMin: false,
              includeMax: false,
              reversed: true,
            )
            .toList(),
      ).deepEquals([8, 6]);
      check(map.keysInRange(min: 10, max: 4)).isEmpty();
      check(map.keysInRange(min: 4, max: 4, includeMin: false)).isEmpty();
      check(map.keysInRange(min: 4, max: 4, includeMax: false)).isEmpty();
      check(map.keysInRange(min: 4, max: 4).toList()).deepEquals([4]);
      check(map.valuesInRange(min: 4, max: 8).toList())
          .deepEquals(['v4', 'v6', 'v8']);
      check(map.range(min: 26).map((e) => e.key).toList()).deepEquals([26, 28]);
      check(map.range(max: 4, reversed: true).map((e) => e.key).toList())
          .deepEquals([4, 2, 0]);
      check(map.reversedKeys.take(3).toList()).deepEquals([28, 26, 24]);
      check(map.reversedValues.take(2).toList()).deepEquals(['v28', 'v26']);
      check(map.reversedEntries.take(2).map((e) => e.key).toList())
          .deepEquals([28, 26]);

      // Out-of-span bounds (both forward and reversed).
      check(map.keysInRange(min: 100)).isEmpty();
      check(map.keysInRange(max: -10)).isEmpty();
      check(map.keysInRange(min: 100, reversed: true)).isEmpty();
      check(map.keysInRange(max: -10, reversed: true)).isEmpty();
      check(map.keysInRange(min: -10, max: 100).length).equals(15);
    });

    test(
      'range iterable O(1)/O(log n) length, first, last, elementAt, contains',
      () {
        final map = BTreeMap<int, String>(minEntries: 2, maxEntries: 4);
        for (var i = 0; i < 30; i += 2) {
          map[i] = 'v$i';
        }

        // Unbounded forward & reversed.
        check(map.keys.length).equals(15);
        check(map.keys.isEmpty).isFalse();
        check(map.keys.isNotEmpty).isTrue();
        check(map.keys.first).equals(0);
        check(map.keys.last).equals(28);
        check(map.keys.elementAt(0)).equals(0);
        check(map.keys.elementAt(7)).equals(14);
        check(map.keys.elementAt(14)).equals(28);
        check(map.keys.contains(14)).isTrue();
        check(map.keys.contains(15)).isFalse();
        check(map.keys.contains('x')).isFalse();
        check(() => map.keys.elementAt(-1)).throws<RangeError>();
        check(() => map.keys.elementAt(15)).throws<RangeError>();

        check(map.reversedKeys.length).equals(15);
        check(map.reversedKeys.first).equals(28);
        check(map.reversedKeys.last).equals(0);
        check(map.reversedKeys.elementAt(0)).equals(28);
        check(map.reversedKeys.elementAt(14)).equals(0);

        check(map.values.first).equals('v0');
        check(map.values.last).equals('v28');
        check(map.values.elementAt(3)).equals('v6');
        check(map.entries.first.key).equals(0);
        check(map.entries.last.key).equals(28);
        check(map.entries.elementAt(3).value).equals('v6');

        // Bounded forward.
        final sub = map.keysInRange(min: 4, max: 12);
        check(sub.length).equals(5);
        check(sub.isEmpty).isFalse();
        check(sub.isNotEmpty).isTrue();
        check(sub.first).equals(4);
        check(sub.last).equals(12);
        check(sub.elementAt(0)).equals(4);
        check(sub.elementAt(2)).equals(8);
        check(sub.elementAt(4)).equals(12);
        check(() => sub.elementAt(5)).throws<RangeError>();
        check(sub.contains(4)).isTrue();
        check(sub.contains(8)).isTrue();
        check(sub.contains(12)).isTrue();
        check(sub.contains(2)).isFalse();
        check(sub.contains(14)).isFalse();
        check(sub.contains(5)).isFalse();

        // Exclusive bounds.
        final exclusive = map.keysInRange(
          min: 4,
          max: 12,
          includeMin: false,
          includeMax: false,
        );
        check(exclusive.length).equals(3);
        check(exclusive.first).equals(6);
        check(exclusive.last).equals(10);
        check(exclusive.contains(4)).isFalse();
        check(exclusive.contains(6)).isTrue();
        check(exclusive.contains(12)).isFalse();

        // Bounded reversed.
        final revSub = map.keysInRange(min: 4, max: 12, reversed: true);
        check(revSub.length).equals(5);
        check(revSub.first).equals(12);
        check(revSub.last).equals(4);
        check(revSub.elementAt(0)).equals(12);
        check(revSub.elementAt(2)).equals(8);
        check(revSub.elementAt(4)).equals(4);

        // Empty bounded range.
        final emptyRange = map.keysInRange(min: 10, max: 4);
        check(emptyRange.length).equals(0);
        check(emptyRange.isEmpty).isTrue();
        check(emptyRange.isNotEmpty).isFalse();
        check(emptyRange.contains(6)).isFalse();
        check(() => emptyRange.first).throws<StateError>();
        check(() => emptyRange.last).throws<StateError>();
        check(() => emptyRange.elementAt(0)).throws<RangeError>();
      },
    );

    test('concurrent modification detection', () {
      final map = BTreeMap<int, int>.of({1: 1, 2: 2, 3: 3});
      final iter = map.keys.iterator;
      check(iter.moveNext()).isTrue();
      map[4] = 4;
      check(iter.moveNext).throws<ConcurrentModificationError>();

      final rangeIter = map.range(min: 1, max: 4).iterator;
      check(rangeIter.moveNext()).isTrue();
      map.remove(2);
      check(rangeIter.moveNext).throws<ConcurrentModificationError>();

      final removeAtIter = map.keys.iterator;
      check(removeAtIter.moveNext()).isTrue();
      map.removeAt(0);
      check(removeAtIter.moveNext).throws<ConcurrentModificationError>();

      final clearIter = map.keys.iterator;
      check(clearIter.moveNext()).isTrue();
      map.clear();
      check(clearIter.moveNext).throws<ConcurrentModificationError>();

      // Iterator created on empty map then mutated.
      final emptyIter = map.keys.iterator;
      map[10] = 10;
      check(emptyIter.moveNext).throws<ConcurrentModificationError>();
    });
  });

  group('BTreeSet', () {
    test('empty set', () {
      final set = BTreeSet<int>(minEntries: 2, maxEntries: 4);
      check(set.minEntries).equals(2);
      check(set.maxEntries).equals(4);
      check(set.isEmpty).isTrue();
      check(set.isNotEmpty).isFalse();
      check(set.length).equals(0);
      check(set.contains(1)).isFalse();
      check(set.contains('x')).isFalse();
      check(set.lookup(1)).isNull();
      check(set.indexOf(1)).equals(-1);
      check(set.indexOf('x')).equals(-1);
      check(set.remove(1)).isFalse();
      check(set.lower(1)).isNull();
      check(set.floor(1)).isNull();
      check(set.ceiling(1)).isNull();
      check(set.higher(1)).isNull();
      check(() => set.first).throws<StateError>();
      check(() => set.last).throws<StateError>();
      check(set.removeFirst).throws<StateError>();
      check(set.removeLast).throws<StateError>();
      check(() => set.elementAt(0)).throws<RangeError>();
      check(() => set.removeAt(0)).throws<RangeError>();
      validate(set.debugMap, expectValues: false);
    });

    test('standard set and order-statistic operations', () {
      final set = BTreeSet<int>(minEntries: 2, maxEntries: 4);
      check(set.add(3)).isTrue();
      check(set.add(1)).isTrue();
      check(set.add(2)).isTrue();
      check(set.add(2)).isFalse();
      validate(set.debugMap, expectValues: false);
      check(set.length).equals(3);
      check(set.first).equals(1);
      check(set.last).equals(3);
      check(set.contains(2)).isTrue();
      check(set.contains(99)).isFalse();
      check(set.lookup(2)).equals(2);
      check(set.lookup(99)).isNull();
      check(set.elementAt(1)).equals(2);
      check(set.indexOf(3)).equals(2);
      check(set.indexOf(99)).equals(-1);
      check(set.indexOf('wrong')).equals(-1);
      check(set.reversed.toList()).deepEquals([3, 2, 1]);

      final copy = set.toSet();
      check(copy).isA<BTreeSet<int>>();
      check(copy.toList()).deepEquals([1, 2, 3]);
      validate((copy as BTreeSet<int>).debugMap, expectValues: false);
      copy.add(99);
      check(set.contains(99)).isFalse();

      check(set.remove(2)).isTrue();
      check(set.remove(2)).isFalse();
      check(set.removeAt(0)).equals(1);
      check(set.removeLast()).equals(3);
      check(set.isEmpty).isTrue();
      validate(set.debugMap, expectValues: false);
    });

    test('of, from, custom comparator, splits and merges', () {
      int ciCompare(String a, String b) =>
          a.toLowerCase().compareTo(b.toLowerCase());
      final set = BTreeSet<String>.of(
        ['b', 'A', 'c'],
        comparator: ciCompare,
        minEntries: 2,
        maxEntries: 4,
      );
      check(set.comparator).equals(ciCompare);
      check(set.lookup('a')).equals('A');
      check(set.add('a')).isFalse();
      check(set.lookup('a')).equals('A');
      validate(set.debugMap, expectValues: false);

      // Clone via of with matching config.
      final cloned = BTreeSet<String>.of(
        set,
        comparator: ciCompare,
        minEntries: 2,
        maxEntries: 4,
      );
      check(cloned.toList()).deepEquals(['A', 'b', 'c']);
      validate(cloned.debugMap, expectValues: false);

      // Construct via from.
      final fromSet = BTreeSet<int>.from(
        <Object?>[30, 10, 20],
        minEntries: 2,
        maxEntries: 4,
      );
      check(fromSet.toList()).deepEquals([10, 20, 30]);
      validate(fromSet.debugMap, expectValues: false);

      // Multi-level splits, borrows, and merges without value lists.
      final large = BTreeSet<int>(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 100; i++) {
        check(large.add(i)).isTrue();
      }
      validate(large.debugMap, expectValues: false);
      for (var i = 0; i < 100; i += 2) {
        check(large.remove(i)).isTrue();
      }
      validate(large.debugMap, expectValues: false);
      for (var i = 99; i >= 1; i -= 2) {
        check(large.remove(i)).isTrue();
      }
      check(large.isEmpty).isTrue();
      validate(large.debugMap, expectValues: false);
    });

    test('navigable, range, and toBTreeSet', () {
      final set = [10, 20, 30, 40, 50].toBTreeSet(minEntries: 2, maxEntries: 4);
      check(set.lower(30)).equals(20);
      check(set.floor(35)).equals(30);
      check(set.ceiling(35)).equals(40);
      check(set.higher(30)).equals(40);
      check(set.range(min: 15, max: 45).toList()).deepEquals([20, 30, 40]);
      check(set.range(min: 15, max: 45).length).equals(3);
      check(set.range(min: 15, max: 45).contains(30)).isTrue();
      check(set.range(min: 15, max: 45).contains(10)).isFalse();
      check(set.removeFirst()).equals(10);
      set.clear();
      check(set.isEmpty).isTrue();
      validate(set.debugMap, expectValues: false);
    });
  });

  group('differential stress test against SplayTreeMap', () {
    test('5000 random operations', () {
      final btree = BTreeMap<int, int>(minEntries: 2, maxEntries: 5);
      final splay = SplayTreeMap<int, int>();
      final random = Random(1337);
      const keySpace = 200;

      for (var step = 0; step < 5000; step++) {
        final op = random.nextInt(10);
        final key = random.nextInt(keySpace);
        if (op < 4) {
          final value = random.nextInt(10000);
          btree[key] = value;
          splay[key] = value;
        } else if (op < 7) {
          check(btree.remove(key)).equals(splay.remove(key));
        } else if (op == 7 && btree.isNotEmpty) {
          final index = random.nextInt(btree.length);
          final removed = btree.removeAt(index);
          final expectedKey = splay.keys.elementAt(index);
          final expectedValue = splay.remove(expectedKey);
          check(removed.key).equals(expectedKey);
          check<int?>(removed.value).equals(expectedValue);
        } else if (op == 8) {
          check(btree.floorKey(key)).equals(splay.lastKeyBefore(key + 1));
          check(btree.lowerKey(key)).equals(splay.lastKeyBefore(key));
          check(btree.ceilingKey(key)).equals(splay.firstKeyAfter(key - 1));
          check(btree.higherKey(key)).equals(splay.firstKeyAfter(key));
        } else {
          final minKey = random.nextInt(keySpace);
          final maxKey = random.nextInt(keySpace);
          final range = btree.keysInRange(min: minKey, max: maxKey);
          final actual = range.toList();
          final expected = splay.keys
              .where((k) => k >= minKey && k <= maxKey)
              .toList();
          check(actual).deepEquals(expected);
          check(range.length).equals(expected.length);
          check(range.isEmpty).equals(expected.isEmpty);
          if (expected.isNotEmpty) {
            check(range.first).equals(expected.first);
            check(range.last).equals(expected.last);
            final mid = expected.length ~/ 2;
            check(range.elementAt(mid)).equals(expected[mid]);
          }
        }

        if (step % 50 == 0) {
          validate(btree);
          check(btree.length).equals(splay.length);
          check(btree.keys.toList()).deepEquals(splay.keys.toList());
          check(btree.values.toList()).deepEquals(splay.values.toList());
        }
      }
      validate(btree);
    });
  });
}
