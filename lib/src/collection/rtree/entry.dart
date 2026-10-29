import 'bounds.dart';
import 'node.dart';

/// R-Tree entry, containing either a pointer to a child RTreeNode instance (if
/// this is not a leaf entry), or data (if this is a leaf entry).
class RTreeEntry<T> {
  /// Creates an R-Tree entry with the given [bounds], optional [data], and
  /// optional [child] node.
  new(this.bounds, {this.data, this.child});

  /// The bounding box of this entry.
  Bounds bounds;

  /// The user data associated with this leaf entry, if any.
  T? data;

  /// The child node pointed to by this internal entry, if any.
  RTreeNode<T>? child;

  /// Whether this entry is a leaf entry holding data rather than a child node.
  bool get isLeaf => child == null;
}
