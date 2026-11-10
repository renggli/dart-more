import 'geometry.dart';
import 'graph_layout.dart';
import 'postprocess.dart';
import 'support/arc_placement.dart';
import 'support/bfs_levels.dart';
import 'support/components.dart';

/// Positions vertices on concentric rings expanding radially outwards from a root vertex.
///
/// Levels correspond to topological BFS distances from the selected [root].
/// Disconnected components are individually laid out and packed.
///
/// ```dart
/// final graph = Graph<String, void>.undirected()
///   ..addEdge('Root', 'A')
///   ..addEdge('Root', 'B')
///   ..addEdge('A', 'C');
/// final result = graph.layout(const RadialLayout(root: 'Root'));
/// print(result.positions['Root']);
/// ```
final class RadialLayout<V> implements GraphLayout<V> {
  /// Constructs a radial layout strategy.
  const new({
    this.root,
    this.rootSelector,
    this.layerDistance,
    this.vertexDistance = 20.0,
    this.center = const LayoutPoint(0, 0),
    this.startAngle = 0.0,
  });

  /// The root vertex placed at the center of the innermost ring.
  ///
  /// If null, [rootSelector] or the vertex with the highest total degree is selected.
  final V? root;

  /// Function to select the root vertex for a given layout input.
  final V Function(LayoutInput<V> input)? rootSelector;

  /// Distance between consecutive concentric rings. If null, dynamically calculated
  /// from vertex heights and [vertexDistance].
  final double? layerDistance;

  /// Spacing between adjacent vertices along the same concentric ring.
  final double vertexDistance;

  /// Center point where the root vertex is located.
  final LayoutPoint center;

  /// Starting angle in radians for ring placement.
  final double startAngle;

  @override
  LayoutResult<V> layout(LayoutInput<V> input) {
    if (input.vertices.isEmpty) {
      return LayoutResult<V>(
        positions: const {},
        bounds: LayoutRectangle(center.x, center.y, 0, 0),
      );
    }
    if (input.vertices.length == 1) {
      final v = input.vertices.first;
      return LayoutResult<V>(
        positions: {v: center},
        vertexSizes: {v: input.sizeOf(v)},
      );
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
          compResults.add(_layoutSingleComponent(compInput));
        }
        return packComponents(compResults, vertexDistance: vertexDistance);
      }
    }

    return _layoutSingleComponent(input);
  }

  LayoutResult<V> _layoutSingleComponent(LayoutInput<V> input) {
    final V effectiveRoot;
    if (root != null && input.vertices.contains(root)) {
      effectiveRoot = root as V;
    } else if (rootSelector != null) {
      effectiveRoot = rootSelector!(input);
    } else {
      var best = input.vertices.first;
      var maxDeg = -1;
      for (final v in input.vertices) {
        final deg = input.neighboursOf(v).length;
        if (deg > maxDeg) {
          maxDeg = deg;
          best = v;
        }
      }
      effectiveRoot = best;
    }

    final levels = bfsLevels<V>(input, [
      effectiveRoot,
    ], successors: input.neighboursOf);

    final positions = <V, LayoutPoint>{};
    final sizes = <V, LayoutSize>{
      for (final v in input.vertices) v: input.sizeOf(v),
    };
    positions[effectiveRoot] = center;

    var currentRadius = 0.0;
    var prevMaxHeight = input.heightOf(effectiveRoot);

    for (var depth = 1; depth < levels.length; depth++) {
      final ringVertices = levels[depth];
      if (ringVertices.isEmpty) continue;

      var currMaxHeight = 0.0;
      for (final v in ringVertices) {
        final h = input.heightOf(v);
        if (h > currMaxHeight) currMaxHeight = h;
      }

      final radialIncrement =
          layerDistance ??
          ((prevMaxHeight + currMaxHeight) / 2.0 + vertexDistance);
      currentRadius += radialIncrement;

      final (ringPositions, effRadius) = arcPlacement<V>(
        vertices: ringVertices,
        sizeOf: input.sizeOf,
        radius: currentRadius,
        center: center,
        startAngle: startAngle,
        vertexDistance: vertexDistance,
      );
      positions.addAll(ringPositions);
      currentRadius = effRadius;
      prevMaxHeight = currMaxHeight;
    }

    return LayoutResult<V>(positions: positions, vertexSizes: sizes);
  }
}
