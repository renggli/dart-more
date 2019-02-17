/// A collection of common mathematical functions on integers.
library more.int_math;

/// The [Jenkins hash function][1] copied and adapted from 'dart:math'. It is
/// using masking to ensure the hash values stay in the SMI range.
///
/// [1]: http://en.wikipedia.org/wiki/Jenkins_hash_function
class HashCode {
  /// Helper to combine a [hash] with a new [value].
  static int _combine(int hash, int value) {
    hash = 0x1fffffff & (hash + value);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  /// Helper to finish the creation of a [hash] value.
  static int _finish(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  /// Current hash accumulator.
  int _hash = 0;

  /// Adds an object to the hash code.
  HashCode add(Object object) {
    _hash = _combine(_hash, object.hashCode);
    return this;
  }

  /// Adds multiple objects to the hash code.
  HashCode addAll(Iterable<Object> objects) {
    objects.forEach(add);
    return this;
  }

  /// Returns the hash code.
  int get value => _finish(_hash);
}
