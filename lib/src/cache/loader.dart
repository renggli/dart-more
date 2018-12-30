library more.cache.loader;

import 'dart:async' show FutureOr;

/// Function asynchronously loading missing cache values.
typedef Loader<K, V> = FutureOr<V> Function(K key);
