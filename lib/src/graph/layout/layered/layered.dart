import '../geometry.dart';
import '../graph_layout.dart';
import '../orientation.dart';
import 'coordinates.dart';
import 'cycle_removal.dart';
import 'dummy_vertices.dart';
import 'ordering.dart';
import 'ranking.dart';

/// Positions vertices in hierarchical ranks using a Sugiyama-style layered DAG layout.
///
/// Uses cycle removal, ranking, dummy vertex insertion for long edges,
/// iterated crossing reduction sweeps, and Brandes-Köpf horizontal coordinate
/// assignment. Edge routing paths are provided in [LayoutResult.edgeRoutes].
///
/// ```dart
/// final graph = Graph<String, void>.directed()
///   ..addEdge('A', 'B')
///   ..addEdge('B', 'C')
///   ..addEdge('A', 'C');
/// final result = graph.layout(const LayeredLayout());
/// print(result.positions['A']);
/// print(result.edgeRoutes[('A', 'C')]);
/// ```
final class LayeredLayout<V> extends GraphLayout<V> {
  /// Constructs a layered layout strategy.
  const new({
    this.layers,
    this.layerOf,
    this.layerDistance,
    this.vertexDistance = 35.0,
    this.orientation = LayoutOrientation.topToBottom,
    this.ranking = RankingAlgorithm.longestPath,
    this.sweeps = 24,
  });

  /// Explicit predefined vertex lists for each layer.
  final List<List<V>>? layers;

  /// Function assigning each vertex to its fixed layer index (0 = first layer).
  final int Function(V vertex)? layerOf;

  /// Spacing between consecutive layers. If null, calculated from vertex extents and [vertexDistance].
  final double? layerDistance;

  /// Spacing between vertices on the same layer.
  final double vertexDistance;

  /// Flow direction of the layered hierarchy.
  final LayoutOrientation orientation;

  /// Algorithm used to assign layers/ranks.
  final RankingAlgorithm ranking;

  /// Number of alternating sweeps used for edge crossing reduction.
  final int sweeps;

  @override
  bool get packDisconnectedComponents => layers == null && layerOf == null;

  @override
  LayoutResult<V> layoutComponent(LayoutInput<V> input) {
    final allVertices = input.vertices;
    final (sizes, _) = input.computeExtents(allVertices);

    final Map<V, int> ranks;
    final Map<V, List<V>> dagSuccessors;
    final Set<(V, V)> reversedEdges;

    if (layers != null || layerOf != null) {
      ranks = <V, int>{};
      if (layers != null) {
        for (var l = 0; l < layers!.length; l++) {
          for (final v in layers![l]) {
            ranks[v] = l;
          }
        }
      } else {
        for (final v in allVertices) {
          ranks[v] = layerOf!(v);
        }
      }

      dagSuccessors = <V, List<V>>{for (final v in allVertices) v: []};
      reversedEdges = <(V, V)>{};

      if (input.isDirected) {
        for (final u in allVertices) {
          final uRank = ranks[u] ?? 0;
          for (final v in input.successorsOf(u)) {
            if (!allVertices.contains(v) || u == v) continue;
            final vRank = ranks[v] ?? 0;
            if (uRank < vRank) {
              dagSuccessors[u]!.add(v);
            } else if (uRank > vRank) {
              dagSuccessors[v]!.add(u);
              reversedEdges.add((u, v));
            }
          }
        }
      } else {
        final processed = <(V, V)>{};
        for (final u in allVertices) {
          final uRank = ranks[u] ?? 0;
          for (final v in input.successorsOf(u)) {
            if (!allVertices.contains(v) || u == v) continue;
            if (processed.contains((u, v)) || processed.contains((v, u))) {
              continue;
            }
            processed.add((u, v));
            final vRank = ranks[v] ?? 0;
            if (uRank < vRank) {
              dagSuccessors[u]!.add(v);
            } else if (vRank < uRank) {
              dagSuccessors[v]!.add(u);
            }
          }
        }
      }
    } else {
      // 1. Cycle removal
      final (cycleFree, cycleReversed) = removeCycles<V>(
        allVertices,
        input.successorsOf,
        isDirected: input.isDirected,
      );
      dagSuccessors = cycleFree;
      reversedEdges = cycleReversed;

      // 2. Ranking
      ranks = assignRanks<V>(allVertices, dagSuccessors, algorithm: ranking);
    }

    // 3. Dummy vertex insertion
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

    // 4. Crossing reduction
    orderLayers<V>(graph, sweeps: sweeps);

    // 5. Coordinate assignment
    assignCoordinates<V>(
      graph,
      vertexDistance: vertexDistance,
      layerDistance: layerDistance,
    );

    // 6. Map coordinates and extract positions & edge routes
    final positions = <V, LayoutPoint>{};
    for (final v in allVertices) {
      final node = graph.realNodes[v]!;
      positions[v] = orientation.apply(crossAxis: node.x, depthAxis: node.y);
    }

    final edgeRoutes = <(V, V), List<LayoutPoint>>{};
    for (final entry in graph.dummyChains.entries) {
      final edge = entry.key;
      final chain = entry.value;
      final isReversed = reversedEdges.contains((edge.$2, edge.$1));
      final originalEdge = isReversed ? (edge.$2, edge.$1) : edge;

      final pts = chain.map(
        (node) => orientation.apply(crossAxis: node.x, depthAxis: node.y),
      );

      edgeRoutes[originalEdge] = isReversed
          ? pts.toList().reversed.toList()
          : pts.toList();
    }

    return LayoutResult<V>(
      positions: positions,
      edgeRoutes: edgeRoutes,
      vertexSizes: sizes,
    );
  }
}
