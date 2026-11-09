---
name: more-dart-use-async-library
description: "Stream transformations in package:more/async.dart: buffer, sliding window, flatMap/asyncFlatMap, flatten, tap, and whereType."
---

# MoreDart Async Library (`package:more/async.dart`)

Provides reactive stream transformation extensions on `Stream<E>` for batching, sliding windows, flattening, type filtering, and lifecycle observation.

---

## Buffering & Sliding Windows

```dart
import 'package:more/async.dart';

Future<void> streamBatchingExample() async {
  final source = Stream.fromIterable([1, 2, 3, 4, 5]);

  // Collect elements into non-overlapping batches by maxLength, maxAge, or trigger stream
  final batches = await source.buffer(maxLength: 2).toList();
  // [[1, 2], [3, 4], [5]]

  // Sliding window of fixed size and step (with optional partial windows)
  final windows = await source.window(3, step: 2).toList();
  // [[1, 2, 3], [3, 4, 5]]
}
```

---

## Flattening, Mapping, Type Filtering & Tap

```dart
Future<void> streamOperatorsExample() async {
  // flatMap (Iterable) & asyncFlatMap (Stream)
  final expanded = await Stream.fromIterable([1, 2])
      .flatMap((x) => [x, x * 10])
      .toList(); // [1, 10, 2, 20]

  final asyncExpanded = await Stream.fromIterable([1, 2])
      .asyncFlatMap((x) => Stream.fromIterable([x, -x]))
      .toList(); // [1, -1, 2, -2]

  // flatten() on Stream<Iterable<T>> or Stream<Stream<T>>
  final flat = await Stream.fromIterable([
    [1, 2],
    [3],
  ]).flatten().toList(); // [1, 2, 3]

  // whereType<T>() filters and promotes stream elements to subtype T
  final stringsOnly = await Stream<Object>.fromIterable([1, 'a', 2, 'b'])
      .whereType<String>()
      .toList(); // ['a', 'b']

  // tap() observes stream data, errors, and lifecycle events without altering emissions
  final observed = <int>[];
  await Stream.fromIterable([10, 20])
      .tap(onData: observed.add)
      .drain<void>();
}
```
