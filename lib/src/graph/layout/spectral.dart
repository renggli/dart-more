import 'dart:math' as math;
import 'dart:typed_data';

import 'geometry.dart';
import 'graph_layout.dart';

/// Positions vertices using the Laplacian eigenvectors (Fiedler vectors) via power iteration.
///
/// Deterministically computes vertex coordinates from the algebraic connectivity
/// of the graph without external linear algebra dependencies.
///
/// ```dart
/// final graph = Graph<String, void>.undirected()
///   ..addEdge('A', 'B')
///   ..addEdge('B', 'C')
///   ..addEdge('C', 'A');
/// final result = graph.layout(const SpectralLayout());
/// print(result.positions['A']);
/// ```
final class SpectralLayout<V> extends GraphLayout<V> {
  /// Constructs a spectral layout strategy.
  const new({
    this.scale = 200.0,
    this.center = const LayoutPoint(0, 0),
    this.iterations = 100,
    this.seed = 42,
    this.vertexDistance = 20.0,
  });

  /// Scale multiplier applied to the normalized eigenvectors.
  final double scale;

  /// Center point of the layout.
  final LayoutPoint center;

  /// Power iteration iterations per eigenvector.
  final int iterations;

  /// Pseudo-random seed for eigenvector initialization.
  final int seed;

  /// Spacing between packed components.
  final double vertexDistance;

  @override
  LayoutResult<V> layoutComponent(LayoutInput<V> input) {
    final list = input.vertices;
    if (list.length == 1) {
      return LayoutResult<V>(
        positions: {list.first: center},
        vertexSizes: {list.first: input.sizeOf(list.first)},
      );
    }
    if (list.length == 2) {
      final s = scale / 2.0;
      return LayoutResult<V>(
        positions: {
          list[0]: LayoutPoint(center.x - s, center.y),
          list[1]: LayoutPoint(center.x + s, center.y),
        },
        vertexSizes: {
          list[0]: input.sizeOf(list[0]),
          list[1]: input.sizeOf(list[1]),
        },
      );
    }
    final n = list.length;
    final (sizes, avgExtent) = input.computeExtents(list);
    final effectiveScale = math.max(
      scale,
      (avgExtent + vertexDistance) * n * 0.45,
    );
    final vertexIndex = <V, int>{for (var i = 0; i < n; i++) list[i]: i};

    final adj = List<List<int>>.generate(n, (_) => <int>[]);
    var maxDegree = 0;
    for (var i = 0; i < n; i++) {
      final seen = <int>{};
      for (final neighbor in input.neighboursOf(list[i])) {
        final j = vertexIndex[neighbor];
        if (j != null && j != i && seen.add(j)) {
          adj[i].add(j);
        }
      }
      if (adj[i].length > maxDegree) maxDegree = adj[i].length;
    }

    // Shift matrix M = alpha * I - L where alpha = maxDegree + 1
    final alpha = maxDegree + 1.0;
    final rng = math.Random(seed);

    void orthogonalizeToOne(Float64List v) {
      var sum = 0.0;
      for (var i = 0; i < n; i++) {
        sum += v[i];
      }
      final mean = sum / n;
      for (var i = 0; i < n; i++) {
        v[i] -= mean;
      }
    }

    double normalize(Float64List v) {
      var sumSq = 0.0;
      for (var i = 0; i < n; i++) {
        sumSq += v[i] * v[i];
      }
      final norm = math.sqrt(sumSq);
      if (norm > 1e-9) {
        for (var i = 0; i < n; i++) {
          v[i] /= norm;
        }
      }
      return norm;
    }

    Float64List powerIteration(void Function(Float64List v) project) {
      var v = Float64List(n);
      for (var i = 0; i < n; i++) {
        v[i] = rng.nextDouble() - 0.5;
      }
      project(v);
      normalize(v);

      for (var iter = 0; iter < iterations; iter++) {
        final y = Float64List(n);
        for (var i = 0; i < n; i++) {
          var sumNeighbors = 0.0;
          for (final j in adj[i]) {
            sumNeighbors += v[j];
          }
          y[i] = (alpha - adj[i].length) * v[i] + sumNeighbors;
        }
        project(y);
        if (normalize(y) < 1e-9) break;
        v = y;
      }
      return v;
    }

    final v2 = powerIteration(orthogonalizeToOne);
    final v3 = powerIteration((v) {
      orthogonalizeToOne(v);
      var dot = 0.0;
      for (var i = 0; i < n; i++) {
        dot += v[i] * v2[i];
      }
      for (var i = 0; i < n; i++) {
        v[i] -= dot * v2[i];
      }
    });

    final positions = <V, LayoutPoint>{};
    for (var i = 0; i < n; i++) {
      final x = center.x + v2[i] * effectiveScale;
      final y = center.y + v3[i] * effectiveScale;
      positions[list[i]] = LayoutPoint(x, y);
    }

    return LayoutResult<V>(positions: positions, vertexSizes: sizes);
  }
}
