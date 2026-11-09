---
name: more-dart-use-interval-library
description: "Closed intervals and 1D range queries in package:more/interval.dart: Interval<T> set algebra (intersection, union, difference) and IntervalTree<K, V> point/overlap queries."
---

# MoreDart Interval Library (`package:more/interval.dart`)

Provides `Interval<T extends Comparable<T>>` for closed continuous ranges `[lower, upper]` and `IntervalTree<K, V>` for fast 1D stabbing and range-overlap queries.

---

## `Interval<T>` Operations

Intervals represent closed bounds `[lower, upper]` where `lower <= upper`:

```dart
import 'package:more/interval.dart';

final a = Interval<num>(1, 5);
final b = Interval<num>(4, 8);
final point = Interval<num>(3); // degenerate [3, 3], point.isSingle == true

// Containment and spatial relations
final has3 = a.contains(3); // true
final enclosesSub = a.encloses(Interval<num>(2, 4)); // true
final overlaps = a.intersects(b); // true

// Set algebra
final common = a.intersection(b); // Interval(4, 5) (or null if disjoint)
final spanned = a.union(b); // Interval(1, 8) (smallest enclosing interval)
final remaining = a.difference(b); // [Interval(1, 4)] (0, 1, or 2 intervals)
```

---

## `IntervalTree<K, V>` (1D Range Index)

An immutable augmented binary search tree built in `O(n log n)` time that answers point-stabbing and interval-overlap queries in `O(log n)`:

```dart
// 1. Tree of intervals only (where V == Interval<K>)
final tree = IntervalTree.fromIntervals<num>([
  Interval(1, 5),
  Interval(3, 9),
  Interval(10, 15),
]);
final at4 = tree.queryPoint(4); // [Interval(3, 9), Interval(1, 5)]
final inRange = tree.queryInterval(Interval(8, 12)); // [Interval(3, 9), Interval(10, 15)]

// 2. Tree associating arbitrary values V with an interval extractor
typedef Task = ({String name, Interval<num> slot});
final tasks = IntervalTree.fromValues<num, Task>(
  [
    (name: 'Build', slot: Interval(0, 10)),
    (name: 'Test', slot: Interval(8, 20)),
  ],
  (task) => task.slot,
);
final activeAt9 = tasks.queryPoint(9).map((t) => t.name).toSet(); // {'Build', 'Test'}
```
