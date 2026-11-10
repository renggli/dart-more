import 'dart:math' as math;

import 'geometry.dart';
import 'graph_layout.dart';
import 'support/arc_placement.dart';

/// Positions vertices in concentric circular shells.
///
/// Vertices are partitioned into concentric circular rings either by an explicit
/// list of shells or by a [shellOf] index mapping function.
///
/// ```dart
/// final graph = Graph<int, void>.undirected()
///   ..addEdge(0, 1)
///   ..addEdge(1, 2);
/// final result = graph.layout(ShellLayout(shellOf: (v) => v % 2));
/// print(result.positions[0]);
/// ```
class ShellLayout<V> extends GraphLayout<V> {
  /// Constructs a multi-shell layout strategy.
  const new({
    this.shells,
    this.shellOf,
    this.layerDistance = 50.0,
    this.vertexDistance = 20.0,
    this.center = const LayoutPoint(0, 0),
    this.startAngle = -math.pi / 2,
    this.sweepAngle = 2 * math.pi,
  }) : _singleRadius = null;

  /// Constructs a single-shell (circular) layout strategy.
  const new single({
    double radius = 0.0,
    this.vertexDistance = 20.0,
    this.center = const LayoutPoint(0, 0),
    this.startAngle = -math.pi / 2,
    this.sweepAngle = 2 * math.pi,
  }) : shells = null,
       shellOf = null,
       layerDistance = 0.0,
       _singleRadius = radius;

  /// Explicit shells defining vertex groups from inside out.
  final List<List<V>>? shells;

  /// Function assigning each vertex to a shell index (0 = innermost).
  final int Function(V vertex)? shellOf;

  /// Spacing between consecutive shells.
  final double layerDistance;

  /// Spacing between vertices on the same shell.
  final double vertexDistance;

  /// Center point of the concentric rings.
  final LayoutPoint center;

  /// Angle in radians where placement begins.
  final double startAngle;

  /// Arc angle in radians spanned by each shell.
  final double sweepAngle;

  final double? _singleRadius;

  @override
  bool get packDisconnectedComponents => false;

  @override
  LayoutResult<V> layoutComponent(LayoutInput<V> input) {
    final sizes = <V, LayoutSize>{
      for (final v in input.vertices) v: input.sizeOf(v),
    };

    if (_singleRadius != null || (shells == null && shellOf == null)) {
      final (positions, _) = arcPlacement<V>(
        vertices: input.vertices,
        sizeOf: input.sizeOf,
        radius: _singleRadius ?? 0.0,
        center: center,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        vertexDistance: vertexDistance,
      );
      return LayoutResult<V>(positions: positions, vertexSizes: sizes);
    }

    final List<List<V>> effectiveShells;
    if (shells != null) {
      effectiveShells = shells!;
    } else {
      final groups = <int, List<V>>{};
      for (final v in input.vertices) {
        final idx = shellOf!(v);
        groups.putIfAbsent(idx, () => []).add(v);
      }
      final sortedKeys = groups.keys.toList()..sort();
      effectiveShells = [for (final k in sortedKeys) groups[k]!];
    }

    final positions = <V, LayoutPoint>{};
    var currentRadius = 0.0;

    for (var i = 0; i < effectiveShells.length; i++) {
      final shellVertices = effectiveShells[i];
      if (shellVertices.isEmpty) continue;

      if (i == 0 && shellVertices.length == 1) {
        positions[shellVertices.first] = center;
        continue;
      }

      currentRadius = (i == 0) ? layerDistance : currentRadius + layerDistance;

      final (ringPositions, effRadius) = arcPlacement<V>(
        vertices: shellVertices,
        sizeOf: input.sizeOf,
        radius: currentRadius,
        center: center,
        startAngle: startAngle,
        sweepAngle: sweepAngle,
        vertexDistance: vertexDistance,
      );
      positions.addAll(ringPositions);
      currentRadius = effRadius;
    }

    return LayoutResult<V>(positions: positions, vertexSizes: sizes);
  }
}
