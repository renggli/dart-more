import 'dart:math';

import 'package:collection/collection.dart';

import '../builder.dart';
import '../graph.dart';
import 'empty.dart';

/// Creates m-ary trees (also known as n-ary, k-ary or k-way tree) in which each
/// node has no more than m children.
///
/// See https://en.wikipedia.org/wiki/M-ary_tree.
extension TreeGraphBuilderExtension<V, E> on GraphBuilder<V, E> {
  /// Creates a complete tree with [vertexCount] nodes and a branching factor of
  /// [arity]. By definition it is completely filled on every level except for
  /// the last one; where all the nodes are as far left as possible.
  Graph<V, E> completeTree({required int vertexCount, int arity = 2}) {
    assert(arity >= 1, 'Branching factor must be positive');
    final graph = empty();
    if (vertexCount <= 0) {
      return graph;
    }
    final parents = QueueList<int>.from([0]);
    addVertexIndex(graph, 0);
    for (var child = 1; child < vertexCount;) {
      final parent = parents.removeFirst();
      for (var i = 0; i < arity && child < vertexCount; i++, child++) {
        parents.addLast(child);
        addVertexIndex(graph, child);
        addEdgeIndex(graph, parent, child);
      }
    }
    return graph;
  }

  /// Creates a perfectly balanced tree of [height] and a branching factor of
  /// [arity]. In the resulting tree all leaf nodes are at the same depth.
  Graph<V, E> prefectTree({required int height, int arity = 2}) => completeTree(
        vertexCount: arity == 1
            ? height + 1
            : (pow(arity, height + 1) - 1) ~/ (arity - 1),
        arity: arity,
      );
}
