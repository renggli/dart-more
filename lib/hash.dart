/// Combines multiple hash values.

/// The Jenkins hash function copied and adapted from Dart SDK.
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
int hash(Iterable objects) =>
    _finish(objects.fold(0, (a, b) => _combine(a, b.hashCode)));

/// Combines the hash code of one object [a].
int hash1(dynamic a) => _finish(_combine(0, a.hashCode));

/// Combines the hash code of two objects [a] and [b].
int hash2(dynamic a, dynamic b) =>
    _finish(_combine(_combine(0, a.hashCode), b.hashCode));

/// Combines the hash code of three objects [a], [b] and [c].
int hash3(dynamic a, dynamic b, dynamic c) => _finish(
    _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode));

/// Combines the hash code of four objects [a], [b], [c] and [d].
int hash4(dynamic a, dynamic b, dynamic c, dynamic d) => _finish(_combine(
    _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
    d.hashCode));

/// Combines the hash code of four objects [a], [b], [c], [d], and [e].
int hash5(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e) =>
    _finish(_combine(
        _combine(
            _combine(_combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
            d.hashCode),
        e.hashCode));

/// Combines the hash code of four objects [a], [b], [c], [d], [e], and [f].
int hash6(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e, dynamic f) =>
    _finish(_combine(
        _combine(
            _combine(
                _combine(
                    _combine(_combine(0, a.hashCode), b.hashCode), c.hashCode),
                d.hashCode),
            e.hashCode),
        f.hashCode));

/// Combines the hash code of four objects [a], [b], [c], [d], [e], [f], and
/// [g].
int hash7(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e, dynamic f,
        dynamic g) =>
    _finish(_combine(
        _combine(
            _combine(
                _combine(
                    _combine(_combine(_combine(0, a.hashCode), b.hashCode),
                        c.hashCode),
                    d.hashCode),
                e.hashCode),
            f.hashCode),
        g.hashCode));

/// Combines the hash code of four objects [a], [b], [c], [d], [e], [f], [g],
/// and [h].
int hash8(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e, dynamic f,
        dynamic g, dynamic h) =>
    _finish(_combine(
        _combine(
            _combine(
                _combine(
                    _combine(
                        _combine(_combine(_combine(0, a.hashCode), b.hashCode),
                            c.hashCode),
                        d.hashCode),
                    e.hashCode),
                f.hashCode),
            g.hashCode),
        h.hashCode));

/// Combines the hash code of four objects [a], [b], [c], [d], [e], [f], [g],
/// [h], and [i].
int hash9(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e, dynamic f,
        dynamic g, dynamic h, dynamic i) =>
    _finish(_combine(
        _combine(
            _combine(
                _combine(
                    _combine(
                        _combine(
                            _combine(
                                _combine(_combine(0, a.hashCode), b.hashCode),
                                c.hashCode),
                            d.hashCode),
                        e.hashCode),
                    f.hashCode),
                g.hashCode),
            h.hashCode),
        i.hashCode));
