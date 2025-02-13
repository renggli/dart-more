import 'dart:math';

import 'package:collection/collection.dart';

import '../factory.dart';
import '../graph.dart';

/// Creates m-ary trees (also known as n-ary, k-ary or k-way tree) in which each
/// node has no more than m children.
///
/// See https://en.wikipedia.org/wiki/M-ary_tree.
extension TreeGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Creates a complete tree with [vertexCount] nodes and a branching factor of
  /// [arity]. By definition it is completely filled on every level except for
  /// the last one; where all the nodes are as far left as possible.
  Graph<V, E> completeTree({required int vertexCount, int arity = 2}) {
    assert(arity >= 1, 'Branching factor must be positive');
    final builder = newBuilder();
    if (vertexCount <= 0) {
      return builder.build();
    }
    final parents = QueueList<int>.from([0]);
    builder.addVertexIndex(0);
    for (var child = 1; child < vertexCount;) {
      final parent = parents.removeFirst();
      for (var i = 0; i < arity && child < vertexCount; i++, child++) {
        parents.addLast(child);
        builder.addVertexIndex(child);
        builder.addEdgeIndex(parent, child);
      }
    }
    return builder.build();
  }

  /// Creates a perfectly balanced tree of [height] and a branching factor of
  /// [arity]. In the resulting tree all leaf nodes are at the same depth.
  Graph<V, E> prefectTree({required int height, int arity = 2}) => completeTree(
    vertexCount:
        arity == 1 ? height + 1 : (pow(arity, height + 1) - 1) ~/ (arity - 1),
    arity: arity,
  );
}
