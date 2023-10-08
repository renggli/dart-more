import '../factory.dart';
import '../graph.dart';

/// https://mathworld.wolfram.com/Completek-PartiteGraph.html
extension PartiteGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Creates a partite [Graph] with a number of vertices on each layer.
  Graph<V, E> partite({required Iterable<int> vertexCounts}) {
    final parts = vertexCounts.toList();
    final offsets = parts
        .fold<List<int>>(<int>[0], (list, each) => list..add(list.last + each));
    final builder = newBuilder();
    for (var l = 0; l < parts.length; l++) {
      for (var i = 0; i < parts[l]; i++) {
        builder.addVertexIndex(offsets[l] + i);
      }
    }
    for (var s = 0; s < parts.length - 1; s++) {
      for (var t = s + 1; t < parts.length; t++) {
        for (var i = 0; i < parts[s]; i++) {
          for (var j = 0; j < parts[t]; j++) {
            builder.addEdgeIndex(offsets[s] + i, offsets[t] + j);
          }
        }
      }
    }
    return builder.build();
  }
}
