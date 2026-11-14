// ignore_for_file: collection_methods_unrelated_type

import 'dart:collection' show SplayTreeMap;
import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/src/collection/btree/map.dart'
    show BTreeMapTestingExtension;
import 'package:more/src/collection/btree/node.dart';
import 'package:test/scaffolding.dart';

void validate<K, V>(BTreeMap<K, V> tree) {
  final root = tree.debugRoot;
  final firstLeaf = tree.debugFirstLeaf;
  final lastLeaf = tree.debugLastLeaf;
  check(tree.length).equals(root.size);

  if (tree.isEmpty) {
    check(root).isA<BTreeLeafNode<K, V>>();
    check(root.size).equals(0);
    check(firstLeaf).identicalTo(root as BTreeLeafNode<K, V>);
    check(lastLeaf).identicalTo(root);
    check(firstLeaf.previous).isNull();
    check(lastLeaf.next).isNull();
    return;
  }

  final dfsLeaves = <BTreeLeafNode<K, V>>[];
  int? leafDepth;

  void visit(BTreeNode<K, V> node, {required bool isRoot, required int depth}) {
    if (node is BTreeLeafNode<K, V>) {
      check(node.keys.length).equals(node.values.length);
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
      check(tree.comparator(internal.children[i].lastKey, internal.keys[i]))
          .isLessThan(0);
      check(
        tree.comparator(internal.keys[i], internal.children[i + 1].firstKey),
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
    });

    test('custom comparator', () {
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
    });

    test('fromIterables', () {
      final map = BTreeMap<int, String>.fromIterables([2, 1], ['b', 'a']);
      check(map.keys.toList()).deepEquals([1, 2]);
      check(map.values.toList()).deepEquals(['a', 'b']);
      check(() => BTreeMap<int, String>.fromIterables([1, 2], ['a']))
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
      map.clear();
      check(map.isEmpty).isTrue();
    });

    test('nullable values', () {
      final map = BTreeMap<String, int?>();
      map['a'] = null;
      map['b'] = 2;
      check(map.length).equals(2);
      check(map.containsKey('a')).isTrue();
      check(map['a']).isNull();
      check(map.containsKey('c')).isFalse();
      check(map.putIfAbsent('a', () => 99)).isNull();
      check(map['a']).isNull();
      check(map.remove('a')).isNull();
      check(map.containsKey('a')).isFalse();
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
    for (final (minE, maxE) in [(2, 4), (3, 6), (16, 32)]) {
      test('ascending, descending, and random ($minE, $maxE)', () {
        final map = BTreeMap<int, int>(minEntries: minE, maxEntries: maxE);
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
      check(() => map.keyAt(-1)).throws<RangeError>();
      check(() => map.keyAt(50)).throws<RangeError>();
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

      final map = BTreeMap<int, int>(minEntries: 2, maxEntries: 4);
      for (var i = 10; i <= 100; i += 10) {
        map[i] = i;
      }
      // Below min
      check(map.lowerKey(10)).isNull();
      check(map.floorKey(10)).equals(10);
      check(map.ceilingKey(5)).equals(10);
      check(map.higherKey(5)).equals(10);

      // Exact hit across leaf boundaries
      for (var i = 10; i <= 100; i += 10) {
        check(map.floorKey(i)).equals(i);
        check(map.ceilingKey(i)).equals(i);
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
    });

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
    });
  });

  group('BTreeSet', () {
    test('standard set and order-statistic operations', () {
      final set = BTreeSet<int>(minEntries: 2, maxEntries: 4);
      check(set.add(3)).isTrue();
      check(set.add(1)).isTrue();
      check(set.add(2)).isTrue();
      check(set.add(2)).isFalse();
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
      check(set.reversed.toList()).deepEquals([3, 2, 1]);

      final copy = set.toSet();
      check(copy).isA<BTreeSet<int>>();
      check(copy.toList()).deepEquals([1, 2, 3]);

      check(set.remove(2)).isTrue();
      check(set.remove(2)).isFalse();
      check(set.removeAt(0)).equals(1);
      check(set.removeLast()).equals(3);
      check(set.isEmpty).isTrue();
    });

    test('navigable, range, and toBTreeSet', () {
      final set = [10, 20, 30, 40, 50].toBTreeSet(minEntries: 2, maxEntries: 4);
      check(set.lower(30)).equals(20);
      check(set.floor(35)).equals(30);
      check(set.ceiling(35)).equals(40);
      check(set.higher(30)).equals(40);
      check(set.range(min: 15, max: 45).toList()).deepEquals([20, 30, 40]);
      check(set.removeFirst()).equals(10);
      set.clear();
      check(set.isEmpty).isTrue();
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
          final actual = btree.keysInRange(min: minKey, max: maxKey).toList();
          final expected = splay.keys
              .where((k) => k >= minKey && k <= maxKey)
              .toList();
          check(actual).deepEquals(expected);
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
