---
name: more-use-collection-library
description: "Specialized data structures and Iterable/List/Map/Set/String extensions in package:more/collection.dart: BTreeMap, BTreeSet, RTree, BiMap, Multimap, Multiset, BitList, Range, DisjointSet, FenwickTree, Trie, OrderedList, SortedList, TypeMap, combinatorics, chunking, zipping, and string utilities. Use when choosing or using advanced Dart collections, spatial/prefix/range indexes, combinatorics, or string wrapping/slicing/normalization. Don't use for 1D intervals (use more-use-interval-library) or graphs (use more-use-graph-library)."
---

# MoreDart Collection Library (`package:more/collection.dart`)

Provides specialized data structures (order-statistic B+Trees, spatial R-Trees, bi-directional maps, multimaps, multisets, bit lists, numeric ranges, union-find, Fenwick trees, tries, circular deques, sorted lists, type maps) and lazy functional extensions on `Iterable`, `List`, `Queue`, `Map`, and `String`.

---

## Choosing the Right Container

| Need | Container | Complexity / Notes |
| :--- | :--- | :--- |
| Sorted map/set with rank (`keyAt`/`indexOfKey`) & range scans | `BTreeMap<K, V>` / `BTreeSet<E>` | `O(log n)` lookup, insert, remove, rank, and range scans |
| Compact, always-sorted `List` / `PriorityQueue` | `SortedList<E>` | `O(1)` index, `O(log n)` search, `O(n)` insert/remove |
| Double-ended queue with random access | `OrderedList<E>` | `O(1)` both ends and `O(1)` random index |
| 1-to-1 reversible map | `BiMap<K, V>` | `O(1)` lookup in both directions via `.inverse` |
| 1-to-many map | `ListMultimap` / `SetMultimap` | Preserves duplicates/order (`List`) or uniqueness (`Set`) |
| Element frequency bag + set algebra | `Multiset<E>` | `O(1)` counts, live `.asMap()` view, union/intersection |
| Prefix / autocomplete map | `Trie<K, P, V>` | `P extends Comparable<Object?>`, `keysWithPrefix` |
| 2D / nD bounding-box & k-NN spatial index | `RTree<T>` | Prefer `RTree.rStar()` (default), `linear()`, or `guttman()` |
| Prefix & range sums with point updates | `FenwickTree<T>` | `O(log n)` update/prefix/range, `O(n)` iteration |
| Dynamic connectivity / equivalence classes | `DisjointSet<E>` | Near-`O(1)` amortized `find` & `union` |
| Compact bit vector + bitwise algebra | `BitList` | `Uint32List`-backed `List<bool>` with `&`, `|`, `^`, `~` |
| Runtime-type-keyed heterogeneous container | `TypeMap<V>` | Type-safe `getInstance<T>()`, `setInstance<T>()`, live `.asMap()` |

---

## Specialized Data Structures

### Associative & Multi-Valued Containers

```dart
import 'package:more/collection.dart';

// BTreeMap / BTreeSet: order-statistic B+Tree with rank & range queries
final btree = BTreeMap<String, int>.of({'b': 2, 'a': 1, 'c': 3});
final secondKey = btree.keyAt(1); // 'b'
final rankC = btree.indexOfKey('c'); // 2
final rangeKeys = btree.keysInRange(min: 'a', max: 'b').toList(); // ['a', 'b']

// BiMap: 1-to-1 bidirectional mapping with O(1) inverse view
final bimap = BiMap.of({1: 'a', 2: 'b'});
final key = bimap.inverse['a']; // 1

// ListMultimap / SetMultimap: 1-to-many key-value mappings
final multimap = ListMultimap<String, int>()
  ..add('odd', 1)
  ..addAll('odd', [3, 5]);
final odds = multimap['odd']; // [1, 3, 5]

// Multiset (Bag): element frequency counter with set algebra & live asMap() view
final bag = Multiset.of(['a', 'b', 'a']);
bag.add('a', 2);
final countA = bag['a']; // 4
final unique = bag.distinct; // ['a', 'b']
final countsView = bag.asMap(); // live Map<String, int>

// TypeMap: maps runtime types to instances of those types
final typeMap = TypeMap<Object>()..setInstance<String>('hello');
final str = typeMap.getInstance<String>(); // 'hello'
final removed = typeMap.removeInstance<String>(); // 'hello'
typeMap.clear();
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

// Trie: prefix tree supporting any Comparable<Object?> part type
final trie = Trie<String, int, int>(parts: (s) => s.codeUnits);
trie['app'] = 1;
trie['apple'] = 2;
final matches = trie.keysWithPrefix('app'); // ['app', 'apple']

// RTree: spatial index (RTree.rStar recommended default; also .linear / .guttman)
final rtree = RTree<String>.rStar()
  ..insert(Bounds.from2D(10.0, 20.0), 'Target');
final hits = rtree.query(Bounds.from2D(0.0, 0.0, 15.0, 25.0)).toList(); // ['Target']
final closest = rtree.nearest(Bounds.from2D(11.0, 19.0)).first; // 'Target'
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

### `String` Extensions

- **Slicing (`take*` / `skip*`)**: `take(count)`, `takeLast(count)`, `takeTo(pattern)`, `takeLastTo(pattern)`, `skip(count)`, `skipLast(count)`, `skipTo(pattern)`, `skipLastTo(pattern)`
- **Affixes & Partitioning**: `removePrefix(pattern)`, `removeSuffix(pattern)`, `partition(pattern)`, `lastPartition(pattern)`
- **Wrapping & Indentation**: `wrap(width, whitespace: ..., breakLongWords: true)`, `unwrap()`, `indent(prefix, firstPrefix: ..., trimWhitespace: true, indentEmpty: false)`, `dedent(whitespace: ..., ignoreEmpty: true)`
- **Case, Chunking, Normalization & List Views**: `toUpperCaseFirstCharacter()`, `toLowerCaseFirstCharacter()`, `convertFirstCharacters(fn, count: 1)`, `convertLastCharacters(fn, count: 1)`, `chunked(size)`, `normalize(form: NormalizationForm.nfc/nfd/nfkc/nfkd)`, `toList(mutable: false, unicode: false)`

```dart
const path = '/usr/local/bin/dart';
final dir = path.skipLastTo('/'); // '/usr/local/bin'
final bin = path.takeLastTo('/'); // 'dart'
final bare = 'https://dart.dev/'.removePrefix('https://').removeSuffix('/'); // 'dart.dev'
final [head, sep, tail] = 'key=value=1'.partition('='); // ['key', '=', 'value=1']
final wrapped = 'The quick brown fox jumps'.wrap(10); // 'The quick\nbrown fox\njumps'
final normalized = 'e\u0301'.normalize(form: NormalizationForm.nfc); // 'é'
final chars = 'hello'.toList(mutable: true)..rotate(2); // ['l', 'o', 'h', 'e', 'l']
```

---

## Common Pitfalls

- **`BitList` mutability**: `BitList(n)` is fixed-length; pass `growable: true` (e.g. `BitList.empty(growable: true)`) if resizing.
- **`FenwickTree.range(start, end)`**: Half-open `[start, end)` — `start` is inclusive, `end` is exclusive.
- **Live views**: `TypeMap.asMap()`, `Multiset.asMap()`, `BiMap.inverse`, and `Multimap[key]` return live views backed by the container; mutations reflect in both directions.
- **`RTree` variants**: Prefer `RTree.rStar()` for best query/k-NN performance; use `RTree.linear()` for write-heavy streaming ingestion.
- **`groupBy()`**: Groups *consecutive* equal keys (like Python's `itertools.groupby`), not global buckets; use `ListMultimap.fromIterable` for global grouping.
