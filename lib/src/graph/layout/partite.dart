import 'geometry.dart';
import 'graph_layout.dart';
import 'layered/coordinates.dart';
import 'layered/dummy_vertices.dart';
import 'layered/ordering.dart';
import 'orientation.dart';

/// Positions vertices in fixed parallel columns/layers for bipartite or multipartite graphs.
///
/// Assigns vertices to layers according to [layerOf] or [layers] and optimizes
/// vertex ordering within columns to minimize edge crossings.
///
/// ```dart
/// final graph = Graph<String, void>.directed()
///   ..addEdge('u1', 'v1')
///   ..addEdge('u2', 'v2');
/// final result = graph.layout(PartiteLayout(
///   layerOf: (v) => v.startsWith('u') ? 0 : 1,
/// ));
/// print(result.positions['u1']);
/// ```
final class PartiteLayout<V> implements GraphLayout<V> {
  /// Constructs a multipartite column layout strategy.
  const new({
    this.layerOf,
    this.layers,
    this.layerDistance,
    this.vertexDistance = 35.0,
    this.orientation = LayoutOrientation.leftToRight,
    this.sweeps = 24,
  });

  /// Function assigning each vertex to its fixed layer/column index (0 = first layer).
  final int Function(V vertex)? layerOf;

  /// Explicit pre-defined vertex lists for each layer/column.
  final List<List<V>>? layers;

  /// Spacing between consecutive parallel columns.
  final double? layerDistance;

  /// Spacing between vertices within the same column.
  final double vertexDistance;

  /// Flow direction across columns. Defaults to [LayoutOrientation.leftToRight].
  final LayoutOrientation orientation;

  /// Number of alternating sweeps used for edge crossing minimization.
  final int sweeps;

  @override
  LayoutResult<V> layout(LayoutInput<V> input) {
    final allVertices = input.vertices;
    if (allVertices.isEmpty) {
      return LayoutResult.empty<V>();
    }

    final sizes = <V, LayoutSize>{
      for (final v in allVertices) v: input.sizeOf(v),
    };
    final List<List<V>> effectiveLayers;
    final ranks = <V, int>{};

    if (layers != null) {
      effectiveLayers = layers!;
      for (var l = 0; l < effectiveLayers.length; l++) {
        for (final v in effectiveLayers[l]) {
          ranks[v] = l;
        }
      }
    } else if (layerOf != null) {
      final groups = <int, List<V>>{};
      for (final v in allVertices) {
        final r = layerOf!(v);
        ranks[v] = r;
        groups.putIfAbsent(r, () => []).add(v);
      }
      final sortedRanks = groups.keys.toList()..sort();
      effectiveLayers = [for (final r in sortedRanks) groups[r]!];
    } else {
      // Automatically partition vertices using greedy BFS graph coloring
      final visited = <V>{};
      final groups = <int, List<V>>{};
      for (final start in allVertices) {
        if (visited.contains(start)) continue;
        final queue = <V>[start];
        visited.add(start);
        ranks[start] = 0;
        groups.putIfAbsent(0, () => []).add(start);

        var head = 0;
        while (head < queue.length) {
          final curr = queue[head++];
          for (final next in input.neighboursOf(curr)) {
            if (!visited.contains(next)) {
              visited.add(next);
              final usedRanks = <int>{};
              for (final nbr in input.neighboursOf(next)) {
                if (ranks.containsKey(nbr)) {
                  usedRanks.add(ranks[nbr]!);
                }
              }
              var r = 0;
              while (usedRanks.contains(r)) {
                r++;
              }
              ranks[next] = r;
              groups.putIfAbsent(r, () => []).add(next);
              queue.add(next);
            }
          }
        }
      }
      final sortedRanks = groups.keys.toList()..sort();
      effectiveLayers = [for (final r in sortedRanks) groups[r]!];
    }

    // Build DAG successors respecting forward direction across layers
    final dagSuccessors = <V, List<V>>{for (final v in allVertices) v: []};
    for (final u in allVertices) {
      final uRank = ranks[u] ?? 0;
      for (final v in input.neighboursOf(u)) {
        final vRank = ranks[v] ?? 0;
        if (vRank > uRank) {
          dagSuccessors[u]!.add(v);
        }
      }
    }

    final graph = LayeredGraph<V>.build(
      vertices: allVertices,
      dagSuccessors: dagSuccessors,
      ranks: ranks,
      sizeOf: (v) {
        final sz = sizes[v]!;
        final w = orientation.crossAxisExtent(sz);
        final h = orientation.depthAxisExtent(sz);
        return (width: w, height: h);
      },
    );

    orderLayers<V>(graph, sweeps: sweeps);
    assignCoordinates<V>(
      graph,
      vertexDistance: vertexDistance,
      layerDistance: layerDistance,
    );

    final positions = <V, LayoutPoint>{};
    for (final v in allVertices) {
      final node = graph.realNodes[v]!;
      positions[v] = orientation.apply(crossAxis: node.x, depthAxis: node.y);
    }

    final edgeRoutes = <(V, V), List<LayoutPoint>>{};
    for (final entry in graph.dummyChains.entries) {
      final edge = entry.key;
      final chain = entry.value;
      edgeRoutes[edge] = [
        for (final node in chain)
          orientation.apply(crossAxis: node.x, depthAxis: node.y),
      ];
    }

    return LayoutResult<V>(
      positions: positions,
      edgeRoutes: edgeRoutes,
      vertexSizes: sizes,
    );
  }
}
