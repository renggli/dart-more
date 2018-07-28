library more.cache.item;

import 'dart:async' show Future, FutureOr;

class CacheItem<V> {
  FutureOr<V> value;

  CacheItem(this.value) {
    if (value is Future<V>) {
      Future<V> future = value;
      future.then((v) => value = v);
    }
  }
}
