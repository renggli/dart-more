import '../../../functional.dart';
import '../rtree.dart';
import 'bounds.dart';
import 'entry.dart';

/// An R-Tree node, which is a container for R-Tree entries. The node is a leaf
/// node if its entries contain data; otherwise, if it is a non-leaf node, then
/// its entries contain pointers to children nodes.
class RTreeNode<T> {
  RTreeNode(
    this.tree, {
    this.parent,
    this.isLeaf = false,
    List<RTreeEntry<T>>? entries,
  }) : entries = entries ?? <RTreeEntry<T>>[];

  final RTree<T> tree;
  RTreeNode<T>? parent;
  List<RTreeEntry<T>> entries;
  bool isLeaf;

  bool get isRoot => parent == null;

  Iterable<RTreeEntry<T>> get siblingEntries =>
      parent?.entries ?? <RTreeEntry<T>>[];

  RTreeEntry<T>? get parentEntry {
    for (final entry in siblingEntries) {
      if (entry.child == this) {
        return entry;
      }
    }
    return null;
  }

  Bounds get bounds => Bounds.unionAll(entries.map((entry) => entry.bounds));

  /// Traverses the tree starting from a given node in depth-first order,
  /// calling the given function on each node. A condition function may
  /// optionally be passed to filter which nodes get traversed. If condition
  /// returns False, then neither the node nor any of its descendants will be
  /// traversed.
  Iterable<R> traverse<R>(
    Map1<RTreeNode<T>, Iterable<R>> callback, {
    Predicate1<RTreeNode<T>>? condition,
  }) sync* {
    if (condition == null || condition(this)) {
      yield* callback(this);
      if (!isLeaf) {
        for (final entry in entries) {
          yield* entry.child!.traverse(callback, condition: condition);
        }
      }
    }
  }

  void fixChildren() {
    if (!isLeaf) {
      for (final entry in entries) {
        entry.child!.parent = this;
      }
    }
  }
}
