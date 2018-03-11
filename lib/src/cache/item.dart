library more.cache.item;

import 'dart:async' show Future, FutureOr;

class CacheItem<V> {
  FutureOr<V> value;

  CacheItem(this.value) {
    if (value is Future) {
      var future = value as Future;
      future.then((v) => value = v);
    }
  }
}
