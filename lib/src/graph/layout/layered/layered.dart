import '../geometry.dart';
import '../graph_layout.dart';
import '../orientation.dart';
import '../postprocess.dart';
import '../support/components.dart';
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
final class LayeredLayout<V> implements GraphLayout<V> {
  /// Constructs a layered layout strategy.
  const new({
    this.layerDistance,
    this.vertexDistance = 35.0,
    this.orientation = LayoutOrientation.topToBottom,
    this.ranking = RankingAlgorithm.longestPath,
    this.sweeps = 24,
  });

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
  LayoutResult<V> layout(LayoutInput<V> input) {
    final allVertices = input.vertices;
    if (allVertices.isEmpty) {
      return LayoutResult.empty<V>();
    }

    if (input.packComponents) {
      final comps = components(input);
      if (comps.length > 1) {
        final compResults = <LayoutResult<V>>[];
        for (final comp in comps) {
          final compSet = comp.toSet();
          final compInput = LayoutInput<V>(
            vertices: comp,
            successorsOf: (v) => input.successorsOf(v).where(compSet.contains),
            predecessorsOf: input.isDirected
                ? (v) => input.predecessorsOf!(v).where(compSet.contains)
                : null,
            vertexSize: input.vertexSize,
            edgeWeight: input.edgeWeight,
            vertexStrategy: input.vertexStrategy,
            packComponents: false,
          );
          compResults.add(_layoutComponent(compInput));
        }
        return packComponents(compResults, vertexDistance: vertexDistance);
      }
    }

    return _layoutComponent(input);
  }

  LayoutResult<V> _layoutComponent(LayoutInput<V> input) {
    final allVertices = input.vertices;
    final sizes = <V, LayoutSize>{
      for (final v in allVertices) v: input.sizeOf(v),
    };

    // 1. Cycle removal
    final (dagSuccessors, reversedEdges) = removeCycles<V>(
      allVertices,
      input.successorsOf,
    );

    // 2. Ranking
    final ranks = assignRanks<V>(
      allVertices,
      dagSuccessors,
      algorithm: ranking,
    );

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
