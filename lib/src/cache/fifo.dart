library more.cache.fifo;

import 'item.dart';
import 'loader.dart';
import 'lru.dart';

/// First-in/First-out (FIFO) cache.
class FifoCache<K, V> extends LruCache<K, V> {
  FifoCache(Loader<K, V> loader, int maximumSize) : super(loader, maximumSize);

  // The FIFO cache is the same as the LRU cache, with the exception that we do
  // not rearrange the items in the cache when accessed.
  @override
  CacheItem<V> promote(K key) => cached[key];
}
