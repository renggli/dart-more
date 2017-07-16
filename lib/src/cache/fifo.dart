library more.cache.fifo;

import 'package:more/src/cache/item.dart';
import 'package:more/src/cache/loader.dart';
import 'package:more/src/cache/lru.dart';

/// First-in/First-out (FIFO) cache.
class FifoCache<K, V> extends LruCache<K, V> {

  FifoCache(Loader<K, V> loader, int maxSize) : super(loader, maxSize);

  // The FIFO cache is the same as the LRU cache, with the exception that we
  // do not rearrange the items in the cache when accessed.
  @override
  CacheItem<V> promote(K key) => cached[key];
}
