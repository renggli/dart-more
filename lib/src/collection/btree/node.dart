part of '../btree.dart';

/// Base class for nodes in a [BTreeMap] or [BTreeSet].
@visibleForTesting
sealed class BTreeNode<K, V> {
  /// Total number of leaf elements in this subtree.
  int get size;
}

/// Leaf node storing sorted keys, optional values, and sibling links.
@visibleForTesting
final class BTreeLeafNode<K, V> extends BTreeNode<K, V> {
  /// Creates a leaf node with optional initial [keys] and [values].
  new({List<K>? keys, this.values}) : keys = keys ?? <K>[];

  /// Sorted keys stored in this leaf.
  final List<K> keys;

  /// Values corresponding to [keys], or `null` for key-only trees ([BTreeSet]).
  final List<V>? values;

  /// Link to the preceding leaf node in key order, if any.
  BTreeLeafNode<K, V>? previous;

  /// Link to the following leaf node in key order, if any.
  BTreeLeafNode<K, V>? next;

  @override
  int get size => keys.length;
}

/// Internal routing node storing separator keys, child nodes, and subtree size.
@visibleForTesting
final class BTreeInternalNode<K, V> extends BTreeNode<K, V> {
  /// Creates an internal node with optional initial [keys], [children], and
  /// subtree [size].
  new({List<K>? keys, List<BTreeNode<K, V>>? children, this.size = 0})
    : keys = keys ?? <K>[],
      children = children ?? <BTreeNode<K, V>>[];

  /// Separator keys partitioning [children] (`keys.length == children.length - 1`).
  final List<K> keys;

  /// Child nodes of this internal node.
  final List<BTreeNode<K, V>> children;

  @override
  int size;
}
