---
name: more-dart-use-tuple-library
description: "Positional Record (tuple) extensions in package:more/tuple.dart: uniform accessors, immutable updates, growing/shrinking, mapping, and collection conversions for arities 0 to 9."
---

# MoreDart Tuple Library (`package:more/tuple.dart`)

Extends native Dart positional `Record`s of arity 0 (`()`) through 9 (`(T1, ..., T9)`) via `Tuple0`..`Tuple9` with uniform element accessors, functional updates, arity growth/removal, splatted mapping, and list/set conversions.

---

## Element Access & Immutable Updates

```dart
import 'package:more/tuple.dart';

const record = ('Alice', 30, true);

// Uniform named getters: first, second, third, ..., ninth, and last
final len = record.length; // 3
final name = record.first; // 'Alice'
final age = record.second; // 30
final active = record.last; // true (alias for third on a 3-tuple)

// Copy-with replacement at any position
final updated = record.withSecond(31).withLast(false); // ('Alice', 31, false)
```

---

## Growing & Shrinking Arity

Add or remove elements at specific positions or at the ends (up to arity 9):

```dart
const pair = (10, 20);

// Adding elements (returns a (n+1)-tuple)
final triple = pair.addLast(30); // (10, 20, 30)
final prepended = pair.addFirst(0); // (0, 10, 20)
final inserted = pair.addSecond(15); // (10, 15, 20)

// Removing elements (returns a (n-1)-tuple)
final shrunk = triple.removeSecond(); // (10, 30)
final withoutLast = triple.removeLast(); // (10, 20)
```

---

## Mapping & Collection Conversions

```dart
const point = (3, 4);

// Splat elements as positional arguments to a callback
final distSquared = point.map((x, y) => x * x + y * y); // 25

// Convert homogeneously or heterogeneously typed tuples to Iterable, List, or Set
final asList = point.toList(); // [3, 4]
final asSet = point.toSet(); // {3, 4}

// Construct a fixed-arity tuple from a List
final fromList = Tuple3.fromList(['a', 'b', 'c']); // ('a', 'b', 'c')
```
