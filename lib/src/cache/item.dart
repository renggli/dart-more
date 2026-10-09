import 'dart:async' show FutureOr;

/// An item stored in a cache holding its [value].
class CacheItem<V> {
  /// Creates a cache item holding the [value].
  new(this.value);

  /// The value or future value stored in this item.
  FutureOr<V> value;
}
