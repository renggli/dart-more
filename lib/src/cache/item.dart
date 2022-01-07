import 'dart:async' show FutureOr;

class CacheItem<V> {
  CacheItem(this.value);
  FutureOr<V> value;
}
