import 'dart:async' show FutureOr;

class CacheItem<V> {
  new(this.value);
  FutureOr<V> value;
}
