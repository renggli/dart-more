import 'dart:collection';

/// Function to extract the parts of type [P] from a key of type [K].
typedef GetParts<K, P> = Iterable<P> Function(K key);

/// A generalized [Trie] (or prefix tree) in which the keys [K] of values [V]
/// are split into smaller parts of type [P].
class Trie<K, P extends Comparable<P>, V> extends MapBase<K, V> {
  /// Creates an empty [Trie] that splits the keys of type [K] with into [parts]
  /// with the provided function. Optionally a custom [root] node can be
  /// provided.
  factory Trie({required GetParts<K, P> parts, TrieNode<K, P, V>? root}) =>
      Trie._(root ?? TrieNodeImpl<K, P, V>(), parts);

  /// Creates trie from another instance. Optionally redefines how the [parts]
  /// of the keys are computed and optionally provides a custom [root] node.
  factory Trie.fromTrie(Trie<K, P, V> other,
          {GetParts<K, P>? parts, TrieNode<K, P, V>? root}) =>
      Trie<K, P, V>.fromMap(other, parts: parts ?? other._getParts, root: root);

  /// Creates trie from a [Map]. Optionally provides a custom root
  /// node [root], and/or redefines how the [parts] of the keys are computed.
  factory Trie.fromMap(Map<K, V> other,
      {required GetParts<K, P> parts, TrieNode<K, P, V>? root}) {
    final result = Trie<K, P, V>(parts: parts, root: root);
    result.addAll(other);
    return result;
  }

  /// Creates trie from an iterable (and possible transformation functions).
  factory Trie.fromIterable(
    Iterable iterable, {
    required GetParts<K, P> parts,
    TrieNode<K, P, V>? root,
    K key(element)?, // ignore: use_function_type_syntax_for_parameters
    V value(element)?, // ignore: use_function_type_syntax_for_parameters
  }) =>
      Trie<K, P, V>.fromIterables(
          key == null ? iterable.cast<K>() : iterable.map(key),
          value == null ? iterable.cast<V>() : iterable.map(value),
          parts: parts,
          root: root);

  /// Creates a trie from two equal length iterables.
  factory Trie.fromIterables(Iterable<K> keys, Iterable<V> values,
      {required GetParts<K, P> parts, TrieNode<K, P, V>? root}) {
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
      throw ArgumentError('Keys and values iterables have different length.');
    }
    return result;
  }

  /// Function to extract the parts from the key.
  final GetParts<K, P> _getParts;

  /// Root node of the tree.
  final TrieNode<K, P, V> _root;

  /// Number of values in the tree.
  int _length = 0;

  /// Internal constructor for the [Trie].
  Trie._(this._root, this._getParts)
      : assert(!_root.hasKeyAndValue,
            'The initial root should not have a key or value.'),
        assert(!_root.hasNodes,
            'The initial root node should not have child nodes.');

  @override
  int get length => _length;

  @override
  V? operator [](Object? key) {
    if (key is K) {
      var current = _root;
      // Navigate to the right node,
      for (final part in _getParts(key)) {
        final node = current.getNode(part);
        if (node == null) {
          return null;
        }
        current = node;
      }
      // Verify we found the value node.
      if (current.hasKeyAndValue) {
        return current.value;
      }
    }
    return null;
  }

  @override
  bool containsKey(Object? key) {
    if (key is K) {
      var current = _root;
      // Navigate to the right node,
      for (final part in _getParts(key)) {
        final node = current.getNode(part);
        if (node == null) {
          return false;
        }
        current = node;
      }
      // Verify we found the value node.
      return current.hasKeyAndValue;
    }
    return false;
  }

  @override
  void operator []=(K key, V value) {
    var current = _root;
    // Navigate to the right node, create intermediaries if necessary.
    for (final part in _getParts(key)) {
      current = current.addNode(part);
    }
    // Increment the length only if no value existed before.
    if (!current.hasKeyAndValue) {
      _length++;
    }
    // Update key and value of the node.
    current.setKeyAndValue(key, value);
  }

  @override
  void clear() {
    _root.clearNodes();
    _root.clearKeyAndValue();
    _length = 0;
  }

  @override
  V? remove(Object? key) {
    if (key is K) {
      final parts = <P>[];
      final nodes = <TrieNode<K, P, V>>[_root];
      // Navigate to the right node.
      for (final part in _getParts(key)) {
        final node = nodes.last.getNode(part);
        if (node == null) {
          return null;
        }
        parts.add(part);
        nodes.add(node);
      }
      // Only proceed if we have a value.
      var current = nodes.removeLast();
      if (current.hasKeyAndValue) {
        // Remove the value from the tree.
        final value = current.value;
        current.clearKeyAndValue();
        _length--;
        // Cleanup no longer needed subtrees.
        while (nodes.isNotEmpty &&
            parts.isNotEmpty &&
            !current.hasKeyAndValue &&
            !current.hasNodes) {
          current = nodes.removeLast();
          current.removeNode(parts.removeLast());
        }
        // Return the value of the remove node.
        return value;
      }
    }
    return null;
  }

  @override
  Iterable<MapEntry<K, V>> get entries => _root.entries;

  @override
  Iterable<K> get keys => entries.map((entry) => entry.key);

  @override
  Iterable<V> get values => entries.map((entry) => entry.value);

  /// An [Iterable] over the [MapEntry] objects with [prefix].
  Iterable<MapEntry<K, V>> entriesWithPrefix(K prefix) {
    var current = _root;
    for (final part in _getParts(prefix)) {
      final node = current.getNode(part);
      if (node == null) {
        return const [];
      }
      current = node;
    }
    return current.entries;
  }

  /// An [Iterable] over all keys starting with [prefix].
  Iterable<K> keysWithPrefix(K prefix) =>
      entriesWithPrefix(prefix).map((entry) => entry.key);
}

/// Abstract implementation of the nodes in a [Trie].
abstract class TrieNode<K, P, V> implements MapEntry<K, V> {
  /// Parts of the child nodes.
  List<P> get parts;

  /// Ordered child nodes.
  List<TrieNode<K, P, V>> get nodes;

  /// Returns `true`, if the node has child nodes.
  bool get hasNodes;

  /// Adds a new node with the provided [part], or returns the existing one.
  TrieNode<K, P, V> addNode(P part);

  /// Returns the node with the provided [part], or `null`.
  TrieNode<K, P, V>? getNode(P part);

  /// Returns the removed node with the provided [part], or `null`.
  TrieNode<K, P, V>? removeNode(P part);

  /// Clears all the child nodes.
  void clearNodes();

  /// Returns the key of the node, if this node has a key and value.
  @override
  K get key;

  /// Returns the value of the node, if this node has a key and value.
  @override
  V get value;

  /// Returns `true`, if the node has a key and value.
  bool get hasKeyAndValue;

  /// Clears the key and value, if present.
  void clearKeyAndValue();

  /// Sets (or replaces) the key and value.
  void setKeyAndValue(K key, V value);

  /// An iterable over this node and all its  children
  Iterable<MapEntry<K, V>> get entries sync* {
    final queue = [this];
    while (queue.isNotEmpty) {
      final element = queue.removeLast();
      if (element.hasKeyAndValue) {
        yield element;
      }
      queue.addAll(element.nodes.reversed
          .where((element) => element.hasKeyAndValue || element.hasNodes));
    }
  }
}

class TrieNodeImpl<K, P extends Comparable<P>, V> extends TrieNode<K, P, V> {
  @override
  final List<P> parts = [];

  @override
  final List<TrieNode<K, P, V>> nodes = [];

  @override
  bool get hasNodes => nodes.isNotEmpty;

  @override
  TrieNode<K, P, V> addNode(P part) {
    final index = binarySearch(part);
    if (index < 0) {
      final node = TrieNodeImpl<K, P, V>();
      parts.insert(-index - 1, part);
      nodes.insert(-index - 1, node);
      return node;
    } else {
      return nodes[index];
    }
  }

  @override
  TrieNode<K, P, V>? getNode(P part) {
    final index = binarySearch(part);
    return index < 0 ? null : nodes[index];
  }

  @override
  TrieNode<K, P, V>? removeNode(P part) {
    final index = binarySearch(part);
    if (index < 0) {
      return null;
    }
    final node = nodes[index];
    parts.removeAt(index);
    nodes.removeAt(index);
    return node;
  }

  @override
  void clearNodes() {
    parts.clear();
    nodes.clear();
  }

  K? _key;

  V? _value;

  @override
  K get key => hasKeyAndValue ? _key! : throw UnimplementedError();

  @override
  V get value => hasKeyAndValue ? _value! : throw UnimplementedError();

  @override
  bool hasKeyAndValue = false;

  @override
  void clearKeyAndValue() {
    _key = null;
    _value = null;
    hasKeyAndValue = false;
  }

  @override
  void setKeyAndValue(K key, V value) {
    _key = key;
    _value = value;
    hasKeyAndValue = true;
  }

  int binarySearch(P key) {
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
