import 'bounds.dart';
import 'node.dart';

/// R-Tree entry, containing either a pointer to a child RTreeNode instance (if
/// this is not a leaf entry), or data (if this is a leaf entry).
class RTreeEntry<T> {
  RTreeEntry(this.bounds, {this.data, this.child});

  Bounds bounds;

  T? data;

  RTreeNode<T>? child;

  bool get isLeaf => child == null;
}
