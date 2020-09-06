import 'dart:async' show FutureOr;

class CacheItem<V> {
  FutureOr<V> value;
  CacheItem(this.value);
}
