---
name: more-dart-use-cache-library
description: "Self-loading caches in package:more/cache.dart: Cache<K, V> with LRU, FIFO, time-based expiry, and no-op policies."
---

# MoreDart Cache Library (`package:more/cache.dart`)

`Cache<K, V>` provides an asynchronous, self-loading key-value cache interface backed by a `Loader<K, V> = FutureOr<V> Function(K key)` and pluggable eviction strategies.

---

## Eviction Strategies & Factories

```dart
import 'package:more/cache.dart';

// 1. Least Recently Used (LRU) bounded by maximum item count
final lruCache = Cache<String, int>.lru(
  loader: (key) => key.length,
  maximumSize: 100,
);

// 2. First-In First-Out (FIFO) bounded by maximum item count
final fifoCache = Cache<String, int>.fifo(
  loader: (key) async => key.hashCode,
  maximumSize: 100,
);

// 3. Time-based expiration (after write/update and/or after last access)
final expiryCache = Cache<String, String>.expiry(
  loader: (key) => key.toUpperCase(),
  updateExpiry: const Duration(minutes: 10),
  accessExpiry: const Duration(minutes: 2),
);

// 4. Empty (no-op) cache that always invokes loader (useful in tests/benchmarks)
final noOpCache = Cache<String, int>.empty(loader: (key) => key.length);
```

---

## Reading, Writing & Invalidating

All cache operations return `Future`s:

```dart
Future<void> runCacheExample() async {
  final cache = Cache<String, int>.lru(
    loader: (key) => key.length,
    maximumSize: 10,
  );

  // Load on miss, return cached value on hit
  final len = await cache.get('hello'); // 5

  // Peek without triggering loader (returns null on miss)
  final present = await cache.getIfPresent('unknown'); // null

  // Batch operations
  final many = await cache.getAll(['a', 'bb']); // {'a': 1, 'bb': 2}
  await cache.set('custom', 42);
  await cache.setAll({'x': 10, 'y': 20});

  // Invalidation & maintenance
  await cache.invalidate('custom');
  await cache.invalidateAll(); // clears all entries
  await cache.reap(); // explicitly purges expired entries (returns reaped count)
  final currentSize = await cache.size(); // 0
}
```
