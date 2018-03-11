library more.cache.loader;

import 'dart:async' show FutureOr;

/// Function asynchronously loading missing cache values.
typedef FutureOr<V> Loader<K, V>(K key);
