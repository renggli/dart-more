import 'dart:collection';

/// Function to extract the parts of type [P] from a key of type [K].
typedef TrieGetParts<K, P> = Iterable<P> Function(K key);

/// A generalized [Trie] (or prefix tree) where keys of type [K] are split into
/// ordered parts of type [P], storing values of type [V].
///
/// Key equivalence and iteration order are determined by the sequence of parts
/// returned by the `parts` function, rather than `K.==`.
///
/// ```dart
/// final trie = Trie<String, int, int>(parts: (s) => s.codeUnits);
/// trie['apple'] = 1;
/// trie['app'] = 2;
/// print(trie.keysWithPrefix('app').toList()); // ['app', 'apple']
/// ```
class Trie<K, P extends Comparable<Object?>, V> extends MapBase<K, V> {
  /// Creates an empty [Trie] that splits the keys of type [K] into [parts] of
  /// type [P] with the provided function. Optionally a custom [root] node can
  /// be provided.
  factory({required TrieGetParts<K, P> parts, TrieNode<K, P, V>? root}) =>
      Trie._(root ?? TrieNodeList<K, P, V>(), parts);

  /// Creates a [Trie] from another instance. Optionally redefines how the
  /// [parts] of the keys are computed and provides a custom [root] node.
  factory fromTrie(
    Trie<K, P, V> other, {
    TrieGetParts<K, P>? parts,
    TrieNode<K, P, V>? root,
  }) =>
      Trie<K, P, V>.fromMap(other, parts: parts ?? other._getParts, root: root);

  /// Creates a [Trie] from a [Map]. The [parts] define how the keys are
  /// computed and optionally provides a custom [root] node.
  factory fromMap(
    Map<K, V> other, {
    required TrieGetParts<K, P> parts,
    TrieNode<K, P, V>? root,
  }) {
    final result = Trie<K, P, V>(parts: parts, root: root);
    result.addAll(other);
    return result;
  }

  /// Creates a [Trie] from an [iterable] in a single pass (with optional [key]
  /// and [value] transformation functions).
  ///
  /// The [parts] define how the keys are computed and optionally provides a
  /// custom [root] node.
  factory fromIterable(
    Iterable<Object?> iterable, {
    required TrieGetParts<K, P> parts,
    TrieNode<K, P, V>? root,
    K Function(Object? element)? key,
    V Function(Object? element)? value,
  }) {
    final result = Trie<K, P, V>(parts: parts, root: root);
    final keyProvider = key ?? (element) => element as K;
    final valueProvider = value ?? (element) => element as V;
    for (final element in iterable) {
      result[keyProvider(element)] = valueProvider(element);
    }
    return result;
  }

  /// Creates a [Trie] from two equal-length iterables. The [parts] define how
  /// the keys are computed and optionally provides a custom [root] node.
  ///
  /// Throws an [ArgumentError] if [keys] and [values] have different lengths.
  factory fromIterables(
    Iterable<K> keys,
    Iterable<V> values, {
    required TrieGetParts<K, P> parts,
    TrieNode<K, P, V>? root,
  }) {
    final result = Trie<K, P, V>(parts: parts, root: root);
    final keyIterator = keys.iterator;
    final valueIterator = values.iterator;
    var moreKeys = keyIterator.moveNext();
    var moreValues = valueIterator.moveNext();
    while (moreKeys && moreValues) {
      result[keyIterator.current] = valueIterator.current;
      moreKeys = keyIterator.moveNext();
      moreValues = valueIterator.moveNext();
    }
    if (moreKeys || moreValues) {
      throw ArgumentError('Iterables do not have same length');
    }
    return result;
  }

  /// Internal constructor of the [Trie].
  new _(this._root, this._getParts)
    : assert(
        !_root.hasKeyAndValue,
        'The initial root should not have a key or value.',
      ),
      assert(
        !_root.hasChildren,
        'The initial root node should not have children.',
      );

  /// Internal function to extract the parts from the key.
  final TrieGetParts<K, P> _getParts;

  /// Internal root node of the tree.
  final TrieNode<K, P, V> _root;

  /// Internal cache of the size of the tree.
  int _length = 0;

  @override
  int get length => _length;

  @override
  bool get isEmpty => _length == 0;

  @override
  bool get isNotEmpty => _length > 0;

  TrieNode<K, P, V>? _findNode(K key) {
    var current = _root;
    for (final part in _getParts(key)) {
      final node = current.getChild(part);
      if (node == null) return null;
      current = node;
    }
    return current;
  }

  @override
  V? operator [](Object? key) {
    if (key is! K || _length == 0) return null;
    final node = _findNode(key);
    return node != null && node.hasKeyAndValue ? node.value : null;
  }

  @override
  bool containsKey(Object? key) {
    if (key is! K || _length == 0) return false;
    final node = _findNode(key);
    return node != null && node.hasKeyAndValue;
  }

  @override
  bool containsValue(Object? value) {
    if (_length == 0) return false;
    for (final node in _root._nodes) {
      if (node.value == value) return true;
    }
    return false;
  }

  @override
  void operator []=(K key, V value) {
    var current = _root;
    for (final part in _getParts(key)) {
      current = current.addChild(part);
    }
    if (!current.hasKeyAndValue) {
      _length++;
    }
    current.setKeyAndValue(key, value);
  }

  @override
  V putIfAbsent(K key, V Function() ifAbsent) {
    var current = _root;
    for (final part in _getParts(key)) {
      current = current.addChild(part);
    }
    if (current.hasKeyAndValue) {
      return current.value;
    }
    final value = ifAbsent();
    if (!current.hasKeyAndValue) {
      _length++;
    }
    current.setKeyAndValue(key, value);
    return value;
  }

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) {
    if (ifAbsent == null) {
      final node = _findNode(key);
      if (node != null && node.hasKeyAndValue) {
        final value = update(node.value);
        node.setKeyAndValue(node.key, value);
        return value;
      }
      throw ArgumentError.value(key, 'key', 'Key not in map.');
    }
    var current = _root;
    for (final part in _getParts(key)) {
      current = current.addChild(part);
    }
    if (current.hasKeyAndValue) {
      final value = update(current.value);
      current.setKeyAndValue(current.key, value);
      return value;
    }
    final value = ifAbsent();
    if (!current.hasKeyAndValue) {
      _length++;
    }
    current.setKeyAndValue(key, value);
    return value;
  }

  @override
  void updateAll(V Function(K key, V value) update) {
    if (_length == 0) return;
    for (final node in _root._nodes) {
      node.setKeyAndValue(node.key, update(node.key, node.value));
    }
  }

  @override
  void forEach(void Function(K key, V value) action) {
    if (_length == 0) return;
    for (final node in _root._nodes) {
      action(node.key, node.value);
    }
  }

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) transform) {
    final result = <K2, V2>{};
    if (_length == 0) return result;
    for (final node in _root._nodes) {
      final entry = transform(node.key, node.value);
      result[entry.key] = entry.value;
    }
    return result;
  }

  @override
  void clear() {
    _root.clearChildren();
    _root.clearKeyAndValue();
    _length = 0;
  }

  @override
  V? remove(Object? key) {
    if (key is! K || _length == 0) return null;
    final iterator = _getParts(key).iterator;
    if (!iterator.moveNext()) {
      if (!_root.hasKeyAndValue) return null;
      final value = _root.value;
      _root.clearKeyAndValue();
      _length--;
      return value;
    }
    final firstPart = iterator.current;
    final firstChild = _root.getChild(firstPart);
    if (firstChild == null) return null;

    final parts = <P>[firstPart];
    final nodes = <TrieNode<K, P, V>>[_root, firstChild];
    while (iterator.moveNext()) {
      final part = iterator.current;
      final node = nodes.last.getChild(part);
      if (node == null) return null;
      parts.add(part);
      nodes.add(node);
    }
    var current = nodes.removeLast();
    if (!current.hasKeyAndValue) return null;
    final value = current.value;
    current.clearKeyAndValue();
    _length--;
    while (nodes.isNotEmpty &&
        parts.isNotEmpty &&
        !current.hasKeyAndValue &&
        !current.hasChildren) {
      current = nodes.removeLast();
      current.removeChild(parts.removeLast());
    }
    return value;
  }

  @override
  Iterable<MapEntry<K, V>> get entries => _root.entries;

  @override
  Iterable<K> get keys => _root._nodes.map((node) => node.key);

  @override
  Iterable<V> get values => _root._nodes.map((node) => node.value);

  /// An [Iterable] over the [MapEntry] objects with [prefix].
  Iterable<MapEntry<K, V>> entriesWithPrefix(K prefix) {
    if (_length == 0) return const [];
    final node = _findNode(prefix);
    return node == null ? const [] : node.entries;
  }

  /// An [Iterable] over all keys starting with [prefix].
  Iterable<K> keysWithPrefix(K prefix) {
    if (_length == 0) return const [];
    final node = _findNode(prefix);
    return node == null ? const [] : node._nodes.map((each) => each.key);
  }
}

/// Abstract implementation of the nodes in a [Trie].
abstract class TrieNode<K, P extends Comparable<Object?>, V> {
  /// Parts of the child nodes.
  Iterable<P> get parts;

  /// Ordered child nodes.
  Iterable<TrieNode<K, P, V>> get children;

  /// Returns `true`, if the node has child nodes.
  bool get hasChildren;

  /// Adds a new node with the provided [part], or returns the existing one.
  TrieNode<K, P, V> addChild(P part);

  /// Returns the node with the provided [part], or `null`.
  TrieNode<K, P, V>? getChild(P part);

  /// Returns the removed node with the provided [part], or `null`.
  TrieNode<K, P, V>? removeChild(P part);

  /// Clears all the child nodes.
  void clearChildren();

  /// Returns the key of the node.
  ///
  /// Throws a [StateError] if [hasKeyAndValue] is `false`.
  K get key;

  /// Returns the value of the node.
  ///
  /// Throws a [StateError] if [hasKeyAndValue] is `false`.
  V get value;

  /// Returns `true`, if the node has a key and value.
  bool get hasKeyAndValue;

  /// Clears the key and value, if present.
  void clearKeyAndValue();

  /// Sets (or replaces) the key and value.
  void setKeyAndValue(K key, V value);

  Iterable<TrieNode<K, P, V>> get _nodes sync* {
    final stack = <TrieNode<K, P, V>>[this];
    while (stack.isNotEmpty) {
      final element = stack.removeLast();
      if (element.hasKeyAndValue) {
        yield element;
      }
      if (!element.hasChildren) continue;
      final childIterable = element.children;
      if (childIterable is List<TrieNode<K, P, V>>) {
        for (var i = childIterable.length - 1; i >= 0; i--) {
          final child = childIterable[i];
          if (child.hasKeyAndValue || child.hasChildren) {
            stack.add(child);
          }
        }
      } else {
        final list = childIterable.toList(growable: false);
        for (var i = list.length - 1; i >= 0; i--) {
          final child = list[i];
          if (child.hasKeyAndValue || child.hasChildren) {
            stack.add(child);
          }
        }
      }
    }
  }

  /// An iterable over this node and all its children.
  Iterable<MapEntry<K, V>> get entries =>
      _nodes.map((node) => MapEntry(node.key, node.value));
}

/// Abstract [TrieNode] with a possible key and value.
abstract class TrieNodeEntry<K, P extends Comparable<Object?>, V>
    extends TrieNode<K, P, V> {
  /// Default generative constructor.
  new();

  K? _key;
  V? _value;
  bool _hasKeyAndValue = false;

  @override
  K get key => _hasKeyAndValue ? _key as K : throw StateError('No key present');

  @override
  V get value =>
      _hasKeyAndValue ? _value as V : throw StateError('No value present');

  @override
  bool get hasKeyAndValue => _hasKeyAndValue;

  @override
  void clearKeyAndValue() {
    _key = null;
    _value = null;
    _hasKeyAndValue = false;
  }

  @override
  void setKeyAndValue(K key, V value) {
    _key = key;
    _value = value;
    _hasKeyAndValue = true;
  }
}

/// [TrieNode] that holds children in a [Map].
class TrieNodeMap<K, P extends Comparable<Object?>, V>
    extends TrieNodeEntry<K, P, V> {
  /// Default generative constructor.
  new();

  Map<P, TrieNode<K, P, V>>? _children;

  @override
  Iterable<P> get parts => _children?.keys ?? const [];

  @override
  Iterable<TrieNode<K, P, V>> get children => _children?.values ?? const [];

  @override
  bool get hasChildren {
    final children = _children;
    return children != null && children.isNotEmpty;
  }

  @override
  TrieNode<K, P, V> addChild(P part) {
    final children = _children ??= SplayTreeMap<P, TrieNode<K, P, V>>();
    return children.putIfAbsent(part, TrieNodeMap<K, P, V>.new);
  }

  @override
  TrieNode<K, P, V>? getChild(P part) => _children?[part];

  @override
  TrieNode<K, P, V>? removeChild(P part) => _children?.remove(part);

  @override
  void clearChildren() => _children?.clear();
}

/// [TrieNode] that holds children in a sorted [List].
class TrieNodeList<K, P extends Comparable<Object?>, V>
    extends TrieNodeEntry<K, P, V> {
  /// Default generative constructor.
  new();

  List<P>? _parts;
  List<TrieNode<K, P, V>>? _children;

  @override
  List<P> get parts => _parts ?? const [];

  @override
  List<TrieNode<K, P, V>> get children => _children ?? const [];

  @override
  bool get hasChildren {
    final children = _children;
    return children != null && children.isNotEmpty;
  }

  @override
  TrieNode<K, P, V> addChild(P part) {
    final parts = _parts ??= <P>[];
    final children = _children ??= <TrieNode<K, P, V>>[];
    final index = _binarySearch(parts, part);
    if (index < 0) {
      final node = TrieNodeList<K, P, V>();
      parts.insert(-index - 1, part);
      children.insert(-index - 1, node);
      return node;
    } else {
      return children[index];
    }
  }

  @override
  TrieNode<K, P, V>? getChild(P part) {
    final parts = _parts;
    final children = _children;
    if (parts == null || children == null) return null;
    final index = _binarySearch(parts, part);
    return index < 0 ? null : children[index];
  }

  @override
  TrieNode<K, P, V>? removeChild(P part) {
    final parts = _parts;
    final children = _children;
    if (parts == null || children == null) return null;
    final index = _binarySearch(parts, part);
    if (index < 0) return null;
    final node = children[index];
    parts.removeAt(index);
    children.removeAt(index);
    return node;
  }

  @override
  void clearChildren() {
    _parts?.clear();
    _children?.clear();
  }

  static int _binarySearch<P extends Comparable<Object?>>(
    List<P> parts,
    P key,
  ) {
    var min = 0;
    var max = parts.length;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      final comp = parts[mid].compareTo(key);
      if (comp == 0) {
        return mid;
      } else if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return -min - 1;
  }
}
