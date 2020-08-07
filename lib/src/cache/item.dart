import 'dart:async' show Future, FutureOr;

class CacheItem<V> {
  FutureOr<V> value;

  CacheItem(this.value) {
    final future = value;
    if (future is Future<V>) {
      future.then((value) => this.value = value);
    }
  }
}
