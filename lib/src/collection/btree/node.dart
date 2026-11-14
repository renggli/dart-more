/// Base class for nodes in a `BTreeMap`.
sealed class BTreeNode<K, V> {
  /// Total number of leaf elements in this subtree.
  int get size;

  /// Whether this node is a leaf node.
  bool get isLeaf;

  /// The smallest key in this non-empty subtree.
  K get firstKey;

  /// The largest key in this non-empty subtree.
  K get lastKey;
}

/// Leaf node storing sorted keys, corresponding values, and sibling links.
final class BTreeLeafNode<K, V> extends BTreeNode<K, V> {
  /// Sorted keys stored in this leaf.
  final List<K> keys = <K>[];

  /// Values corresponding to [keys].
  final List<V> values = <V>[];

  /// Link to the preceding leaf node in key order, if any.
  BTreeLeafNode<K, V>? previous;

  /// Link to the following leaf node in key order, if any.
  BTreeLeafNode<K, V>? next;

  @override
  int get size => keys.length;

  @override
  bool get isLeaf => true;

  @override
  K get firstKey => keys.first;

  @override
  K get lastKey => keys.last;
}

/// Internal routing node storing separator keys, child nodes, and subtree size.
final class BTreeInternalNode<K, V> extends BTreeNode<K, V> {
  /// Separator keys partitioning [children] (`keys.length == children.length - 1`).
  final List<K> keys = <K>[];

  /// Child nodes of this internal node.
  final List<BTreeNode<K, V>> children = <BTreeNode<K, V>>[];

  @override
  int size = 0;

  @override
  bool get isLeaf => false;

  @override
  K get firstKey => children.first.firstKey;

  @override
  K get lastKey => children.last.lastKey;
}
