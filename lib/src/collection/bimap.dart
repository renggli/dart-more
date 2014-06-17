part of collection;

class BiMap<K, V> implements Map<K, V> {

  factory BiMap() => new BiMap._(new Map(), new Map());

  factory BiMap.identity() => new BiMap._(new Map.identity(), new Map.identity());

  final Map<K, V> _forward;
  final Map<V, K> _backward;

  BiMap._(this._forward, this._backward);

  /**
   * Returns the inverse bi-map.
   */
  BiMap<V, K> get inverse => new BiMap._(_backward, _forward);

  @override
  V operator [](Object key) => _forward[key];

  @override
  void operator []=(K key, V value) {
    if (_forward.containsKey(key)) {
      _backward.remove(_forward[key]);
    }
    if (_backward.containsKey(value)) {
      _forward.remove(_backward[value]);
    }
    _forward[key] = value;
    _backward[value] = key;
  }

  @override
  V putIfAbsent(K key, V ifAbsent()) {
    if (_forward.containsKey(key)) {
      return _forward[key];
    } else {
      var value = ifAbsent();
      this[key] = value;
      return value;
    }
  }

  @override
  void addAll(Map<K, V> other) {
    other.forEach((key, value) => this[key] = value);
  }

  @override
  V remove(Object key) {
    if (_forward.containsKey(key)) {
      var value = _forward[key];
      _forward.remove(key);
      _backward.remove(value);
      return value;
    }
    return null;
  }

  @override
  void clear() {
    _forward.clear();
    _backward.clear();
  }

  @override
  bool containsKey(Object key) {
    return _forward.containsKey(key);
  }

  @override
  bool containsValue(Object value) {
    return _backward.containsKey(value);
  }

  @override
  void forEach(void f(K key, V value)) {
    _forward.forEach(f);
  }

  @override
  bool get isEmpty => _forward.isEmpty;

  @override
  bool get isNotEmpty => _forward.isNotEmpty;


  @override
  int get length => _forward.length;

  @override
  Iterable<K> get keys => _forward.keys;

  @override
  Iterable<V> get values => _backward.keys;
}