---
name: more-dart-use-collection-library
description: "Data structures and Iterable/List/Map/Set/String extensions in package:more/collection.dart: BiMap, Multimap, Multiset, BitList, Range, DisjointSet, FenwickTree, Trie, RTree, combinatorics, chunking, and zipping."
---

# MoreDart Collection Library (`package:more/collection.dart`)

Provides specialized data structures (bi-directional maps, multimaps, multisets, bit lists, numeric ranges, union-find, Fenwick trees, tries, spatial R-trees) and lazy functional extensions on `Iterable`, `List`, `Queue`, `Map`, and `String`.

---

## Specialized Data Structures

### Associative & Multi-Valued Containers

```dart
import 'package:more/collection.dart';

// BiMap: 1-to-1 bidirectional mapping with O(1) inverse view
final bimap = BiMap.of({1: 'a', 2: 'b'});
final key = bimap.inverse['a']; // 1

// ListMultimap / SetMultimap: 1-to-many key-value mappings
final multimap = ListMultimap<String, int>()
  ..add('odd', 1)
  ..addAll('odd', [3, 5]);
final odds = multimap['odd']; // [1, 3, 5]

// Multiset (Bag): element frequency counter with set algebra
final bag = Multiset.of(['a', 'b', 'a']);
bag.add('a', 2);
final countA = bag['a']; // 4
final unique = bag.distinct; // ['a', 'b']

// TypeMap: maps runtime types to instances of those types
final typeMap = TypeMap<Object>()..setInstance<String>('hello');
final str = typeMap.getInstance<String>(); // 'hello'
```

### Compact, Ordered & Range Lists

```dart
// BitList: compact Uint32List-backed List<bool> with bitwise operators
final bits = BitList(8)..[1] = true..[3] = true;
bits.flip(0);
final setCount = bits.count(); // 3
final combined = bits & BitList.of([true, true, false, false, false, false, false, false]);

// OrderedList: circular-buffer deque with O(1) ends and O(1) random access
final deque = OrderedList.of([2, 3])
  ..addFirst(1)
  ..addLast(4);

// SortedList: always-sorted list implementing PriorityQueue<E>
final sorted = SortedList<int>()..addAll([5, 1, 3]);
final minVal = sorted.removeFirst(); // 1

// Range: lazy arithmetic progressions implementing List<E>
final evens = 0.to(10, step: 2); // [0, 2, 4, 6, 8]
final floats = 0.0.to(1.0, step: 0.25); // [0.0, 0.25, 0.5, 0.75]
final reversed = 10.to(0, step: -2); // [10, 8, 6, 4, 2]
```

### Trees, Spatial Indexes & Disjoint Sets

```dart
// DisjointSet (Union-Find): path-compressed equivalence classes
final ds = DisjointSet(['a', 'b', 'c', 'd']);
ds.union('a', 'b');
final sameComponent = ds.find('a') == ds.find('b'); // true

// FenwickTree (Binary Indexed Tree): O(log n) prefix/range sums and point updates
final fenwick = FenwickTree.of([1, 2, 3, 4, 5]);
fenwick.update(2, 10); // adds 10 at index 2
final rangeSum = fenwick.range(1, 4); // sum of indices [1, 4) -> 19

// Trie: prefix tree supporting prefix lookups
final trie = Trie<String, num, int>(parts: (s) => s.codeUnits);
trie['app'] = 1;
trie['apple'] = 2;
final matches = trie.keysWithPrefix('app'); // ['app', 'apple']

// RTree: spatial index for points and bounding boxes
final rtree = RTree<String>.guttman()
  ..insert(Bounds.fromPoint([10, 20]), 'Target');
final hits = rtree.queryEntries(Bounds.fromLists([0, 0], [15, 25]));
```

---

## `Iterable`, `List`, `Map`, and `String` Extensions

### Combinatorics

```dart
final items = [1, 2, 3];
final combs = items.combinations(2); // [[1, 2], [1, 3], [2, 3]]
final perms = items.permutations(2); // [[1, 2], [1, 3], [2, 1], [2, 3], [3, 1], [3, 2]]
final pset = items.powerSet(); // [[], [1], [2], [3], [1, 2], ...]
final cart = ([1, 2], ['a', 'b']).product(); // [(1, 'a'), (1, 'b'), (2, 'a'), (2, 'b')]

// In-place lexicographical permutation stepping on List:
final perm = [1, 2, 3];
perm.nextPermutation(); // true, perm is now [1, 3, 2]
```

### Chunking, Windowing, Zipping & Grouping

```dart
final nums = [1, 2, 3, 4, 5];
final chunks = nums.chunked(2); // [[1, 2], [3, 4], [5]]
final padded = nums.chunkedWithPadding(2, 0); // [[1, 2], [3, 4], [5, 0]]
final windows = nums.window(3, step: 2); // [[1, 2, 3], [3, 4, 5]]
final pairs = nums.pairwise(); // [(1, 2), (2, 3), (3, 4), (4, 5)]

// Typed record zip and iterable zip
final zipped = ([1, 2], ['a', 'b']).zip(); // [(1, 'a'), (2, 'b')]
final parted = nums.partition((n) => n.isEven); // (truthy: [2, 4], falsey: [1, 3, 5])
final grouped = [1, 1, 2, 2, 1].groupBy<int>(); // groups consecutive equal keys
```

### Filtering, Aggregation & Generation

- **Selection & Deduplication**: `unique()`, `flatten()`, `deepFlatten<T>()`, `flatMap(fn)`, `indexed(start: 0)`, `separatedBy(() => sep)`
- **Aggregation**: `count(predicate)`, `occurrences(element)`, `min()`, `max()`, `minMax()`, `smallest(k)`, `largest(k)`, `atRandom()`, `toMap(key: ..., value: ...)`
- **Generators**: `iterate(seed, (prev) => next)`, `repeat(element, count: n)`
- **`List` / `Queue` Slicing**: `rotate(steps)`, `takeLast(n)`, `skipLast(n)`, `takeTo(e)`, `skipTo(e)`
- **`Map` Defaults**: `map.withDefault(fallback)`, `map.withComputed((key) => value)`

### `String` Manipulation

```dart
// Mutable or immutable code-unit / rune list views
final chars = 'hello'.toList(mutable: true);
chars.rotate(2);
final rotatedStr = chars.join(); // 'lohel'

// Partitioning, affixes, wrapping, indentation, and Unicode normalization
final [head, sep, tail] = 'key=value=1'.partition('='); // ['key', '=', 'value=1']
final trimmed = 'foobar'.removePrefix('foo').removeSuffix('bar'); // ''
final wrapped = 'long text here'.wrap(8);
final normalized = 'e\u0301'.normalize(form: NormalizationForm.nfc); // 'é'
```
