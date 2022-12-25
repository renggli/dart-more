import '../builder.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/Completek-PartiteGraph.html
extension PartiteGraphBuilder<V, E> on GraphBuilder<V, E> {
  Graph<V, E> partite({required Iterable<int> vertexCounts}) {
    final parts = vertexCounts.toList();
    final offsets = parts
        .fold<List<int>>(<int>[0], (list, each) => list..add(list.last + each));
    final graph = empty();
    for (var l = 0; l < parts.length; l++) {
      for (var i = 0; i < parts[l]; i++) {
        addVertexIndex(graph, offsets[l] + i);
      }
    }
    for (var s = 0; s < parts.length - 1; s++) {
      for (var t = s + 1; t < parts.length; t++) {
        for (var i = 0; i < parts[s]; i++) {
          for (var j = 0; j < parts[t]; j++) {
            addEdgeIndex(graph, offsets[s] + i, offsets[t] + j);
          }
        }
      }
    }
    return graph;
  }
}
