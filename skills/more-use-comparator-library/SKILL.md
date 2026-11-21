---
name: more-use-comparator-library
description: "Composable comparators and ordering algorithms in package:more/comparator.dart: natural/reverse/key/explicit comparators, thenCompare chaining, null handling, lexicographical ordering, top-K selection, binary search/bounds, and CompareOperators. Use when sorting by multiple keys, handling nullable sort fields, running binary search or lower/upper bound queries, selecting top-K elements, or adding <, <=, >, >= operators to Comparable classes. Don't use for maintaining an always-sorted mutable collection (use BTreeMap/BTreeSet/SortedList in more-use-collection-library)."
---

# MoreDart Comparator Library (`package:more/comparator.dart`)

Provides constructors, algebraic combinators, and ordering algorithms as extensions directly on Dart's standard `Comparator<T>` typedef (`int Function(T a, T b)`).

---

## Creating & Composing Comparators

```dart
import 'package:more/comparator.dart';

// 1. Built-in constructors
const nat = naturalComparable<num>;
const rev = reverseComparable<num>;
final byLength = keyOf<String, num>((s) => s.length);
final priority = explicitComparator(['high', 'medium', 'low']);

// 2. Chaining (lexicographical tie-breaking), reversal, and null handling
final lengthThenAlpha = byLength.thenCompare(naturalComparable<String>);
final nullableOrder = lengthThenAlpha.reversed.nullsLast;

// 3. Comparing iterables lexicographically element-by-element
final listOrder = naturalComparable<num>.lexicographical;
```

---

## Sorting, Min/Max, Top-K & Order Checks

Every `Comparator<T>` exposes collection operations without mutating inputs unless `.sort()` is called:

```dart
const words = ['pear', 'fig', 'apple', 'banana', 'kiwi'];

// Out-of-place sorted copy & in-place sort (with optional merge-sort stability)
final sortedWords = lengthThenAlpha.sorted(words, stable: true);
// ['fig', 'kiwi', 'pear', 'apple', 'banana']

// Order verification
final ordered = lengthThenAlpha.isOrdered(sortedWords); // true
final strictlyOrdered = byLength.isStrictlyOrdered(sortedWords); // false ('kiwi' & 'pear' tie)

// Extremes & Top-K selection
final shortest = byLength.minOf(words); // 'fig'
final longest = byLength.maxOf(words); // 'banana'
final (:min, :max) = byLength.minMaxOf(words);
final twoShortest = lengthThenAlpha.smallest(words, 2); // ['fig', 'kiwi']
final twoLongest = lengthThenAlpha.largest(words, 2); // ['banana', 'apple']

// Binary predicates directly from a comparator
final isShorter = byLength.lessThan('fig', 'apple'); // true
```

---

## Binary Search

Perform binary search and lower/upper bound insertion index lookups on lists ordered by the receiver comparator:

```dart
final list = [10, 20, 20, 20, 30];
const comp = naturalComparable<num>;

final exactIndex = comp.binarySearch(list, 20); // index of a matching element (>= 0)
final lowerBound = comp.binarySearchLower(list, 20); // 1 (first index >= 20)
final upperBound = comp.binarySearchUpper(list, 20); // 4 (first index > 20)
```

---

## `CompareOperators<T>` Mixin & `Comparable` Extensions

Add `<`, `<=`, `>`, `>=` operators to any class implementing `Comparable<T>`, or use range helpers `.between(min, max)` and `.clip(min, max)`:

```dart
class Version with CompareOperators<Version> implements Comparable<Version> {
  const new(this.major, this.minor);
  final int major;
  final int minor;

  static final _comparator = keyOf<Version, num>((v) => v.major)
      .thenCompare(keyOf<Version, num>((v) => v.minor));

  @override
  int compareTo(Version other) => _comparator(this, other);
}

const v1 = Version(1, 2);
const v2 = Version(2, 0);
final isOlder = v1 < v2; // true
final inRange = v1.between(const Version(1, 0), const Version(1, 5)); // true
final clamped = v2.clip(const Version(1, 0), const Version(1, 5)); // Version(1, 5)
```

---

## Common Pitfalls

- **`int`/`double` type parameter**: Use `naturalComparable<num>` (not `<int>`) because `int` and `double` implement `Comparable<num>`, not `Comparable<int>`.
- **`binarySearch` miss value**: Returns a negative value when absent (`-(insertIndex + 1)`); use `binarySearchLower` / `binarySearchUpper` when you always want a non-negative insertion index.
- **Stable sorting**: Pass `stable: true` to `.sort()` / `.sorted()` when equal keys must preserve original relative order.
