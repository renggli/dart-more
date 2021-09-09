/// Combines multiple hash values.

/// Combines the hash code of multiple objects.
@Deprecated('Use Object.hashAll from the core library.')
int hash(Iterable objects) => Object.hashAll(objects);

/// Combines the hash code of one object [a].
@Deprecated('Use a.hashCode from the core library.')
int hash1(dynamic a) => a.hashCode;

/// Combines the hash code of two objects [a] and [b].
@Deprecated('Use Object.hash from the core library.')
int hash2(dynamic a, dynamic b) => Object.hash(a, b);

/// Combines the hash code of three objects [a], [b] and [c].
@Deprecated('Use Object.hash from the core library.')
int hash3(dynamic a, dynamic b, dynamic c) => Object.hash(a, b, c);

/// Combines the hash code of four objects [a], [b], [c] and [d].
@Deprecated('Use Object.hash from the core library.')
int hash4(dynamic a, dynamic b, dynamic c, dynamic d) =>
    Object.hash(a, b, c, d);

/// Combines the hash code of four objects [a], [b], [c], [d], and [e].
@Deprecated('Use Object.hash from the core library.')
int hash5(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e) =>
    Object.hash(a, b, c, d, e);

/// Combines the hash code of four objects [a], [b], [c], [d], [e], and [f].
@Deprecated('Use Object.hash from the core library.')
int hash6(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e, dynamic f) =>
    Object.hash(a, b, c, d, e, f);

/// Combines the hash code of four objects [a], [b], [c], [d], [e], [f], and
/// [g].
@Deprecated('Use Object.hash from the core library.')
int hash7(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e, dynamic f,
        dynamic g) =>
    Object.hash(a, b, c, d, e, f, g);

/// Combines the hash code of four objects [a], [b], [c], [d], [e], [f], [g],
/// and [h].
@Deprecated('Use Object.hash from the core library.')
int hash8(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e, dynamic f,
        dynamic g, dynamic h) =>
    Object.hash(a, b, c, d, e, f, g, h);

/// Combines the hash code of four objects [a], [b], [c], [d], [e], [f], [g],
/// [h], and [i].
@Deprecated('Use Object.hash from the core library.')
int hash9(dynamic a, dynamic b, dynamic c, dynamic d, dynamic e, dynamic f,
        dynamic g, dynamic h, dynamic i) =>
    Object.hash(a, b, c, d, e, f, g, h, i);
