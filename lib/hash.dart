/// The Jenkins hash function copied and adapted from 'package:math'.
library more.hash;

/// Mask to keep integers in range (31 bits).
const int _hashMask = 0x7fffffff;

/// Helper to combine a [hash] with a new [value].
int _combine(int hash, int value) {
  hash = 0x1fffffff & (hash + value);
  hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
  return hash ^ (hash >> 6);
}

/// Helper to finish the creation of the [hash] value.
int _finish(int hash) {
  hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
  hash = hash ^ (hash >> 11);
  return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
}

/// Combines the hash code of multiple objects.
int hash(Iterable<Object> objects) =>
    _finish(objects.fold(0, (a, b) => _combine(a, b.hashCode)));

/// Combines the hash code of one object [a].
int hash1(Object a) => _finish(_combine(0, a.hashCode));

/// Combines the hash code of two objects [a] and [b].
int hash2(Object a, Object b) =>
    _finish(_combine(_combine(0, a.hashCode), b.hashCode));

/// Combines the hash code of three objects [a], [b] and [c].
int hash3(Object a, Object b, Object c) => _finish(
    _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode));

/// Combines the hash code of four objects [a], [b], [c] and [d].
int hash4(Object a, Object b, Object c, Object d) => _finish(_combine(
    _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
    d.hashCode));

/// Combines the hash code of four objects [a], [b], [c] and [d].
int hash5(Object a, Object b, Object c, Object d, Object e) => _finish(_combine(
    _combine(
        _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
        d.hashCode),
    e.hashCode));

/// Combines the hash code of four objects [a], [b], [c] and [d].
int hash6(Object a, Object b, Object c, Object d, Object e, Object f) =>
    _finish(_combine(
        _combine(
            _combine(
                _combine(
                    _combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
                d.hashCode),
            e.hashCode),
        f.hashCode));
