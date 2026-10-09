import 'item.dart';
import 'lru.dart';

/// First-in/First-out (FIFO) cache.
class FifoCache<K, V> extends LruCache<K, V> {
  /// Creates a FIFO cache with the given [loader] and [maximumSize].
  new(super.loader, super.maximumSize);

  // The FIFO cache is the same as the LRU cache, with the exception that we do
  // not rearrange the items in the cache when accessed.
  @override
  CacheItem<V>? promote(K key) => cached[key];
}
