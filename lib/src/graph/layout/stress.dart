import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'geometry.dart';
import 'graph_layout.dart';
import 'postprocess.dart';
import 'spectral.dart';
import 'support/arc_placement.dart';
import 'support/components.dart';

/// Positions vertices using Stress Majorization (SMACOF) on graph-theoretic shortest path distances.
///
/// Iteratively minimizes the difference between graph-theoretic distances and
/// Euclidean distances. Produces organic, aesthetic layouts and handles disconnected
/// components automatically.
///
/// ```dart
/// final graph = Graph<String, void>.undirected()
///   ..addEdge('A', 'B')
///   ..addEdge('B', 'C')
///   ..addEdge('C', 'A');
/// final result = graph.layout(const StressLayout());
/// print(result.positions['A']);
/// ```
final class StressLayout<V> implements GraphLayout<V> {
  /// Constructs a stress majorization layout strategy.
  const new({
    this.iterations = 100,
    this.tolerance = 1e-4,
    this.vertexDistance = 50.0,
    this.center = const LayoutPoint(0, 0),
    this.seed = 42,
  });

  /// Maximum number of SMACOF majorization iterations.
  final int iterations;

  /// Convergence threshold on maximum vertex displacement per iteration.
  final double tolerance;

  /// Target average Euclidean length for graph edges.
  final double vertexDistance;

  /// Center coordinate of the resulting layout.
  final LayoutPoint center;

  /// Pseudo-random seed used for initial placement fallback.
  final int seed;

  @override
  LayoutResult<V> layout(LayoutInput<V> input) {
    final list = input.vertices;
    if (list.isEmpty) {
      return LayoutResult<V>(
        positions: const {},
        bounds: LayoutRectangle(center.x, center.y, 0, 0),
      );
    }
    if (list.length == 1) {
      return LayoutResult<V>(
        positions: {list.first: center},
        vertexSizes: {list.first: input.sizeOf(list.first)},
      );
    }

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
        );
        compResults.add(_layoutComponent(compInput));
      }
      return packComponents(compResults, vertexDistance: vertexDistance);
    }

    return _layoutComponent(input);
  }

  LayoutResult<V> _layoutComponent(LayoutInput<V> input) {
    final list = input.vertices;
    final n = list.length;
    final sizes = <V, LayoutSize>{for (final v in list) v: input.sizeOf(v)};
    final vertexIndex = <V, int>{for (var i = 0; i < n; i++) list[i]: i};

    // 1. All-pairs shortest path distances D[i * n + j]
    final distMatrix = Float64List(n * n);
    for (var i = 0; i < n; i++) {
      final queue = Queue<int>()..add(i);
      final visited = List<bool>.filled(n, false)..[i] = true;
      final dists = List<double>.filled(n, double.infinity)..[i] = 0.0;

      while (queue.isNotEmpty) {
        final u = queue.removeFirst();
        final dU = dists[u];
        for (final v in input.neighboursOf(list[u])) {
          final j = vertexIndex[v];
          if (j != null && !visited[j]) {
            visited[j] = true;
            dists[j] = dU + 1.0;
            queue.add(j);
          }
        }
      }

      for (var j = 0; j < n; j++) {
        distMatrix[i * n + j] = dists[j];
      }
    }

    // 2. Weights W[i * n + j] = 1 / (d_ij * d_ij)
    final weightMatrix = Float64List(n * n);
    final weightSum = Float64List(n);
    for (var i = 0; i < n; i++) {
      var sum = 0.0;
      for (var j = 0; j < n; j++) {
        if (i != j) {
          final d = distMatrix[i * n + j];
          if (d < double.infinity && d > 0.0) {
            final w = 1.0 / (d * d);
            weightMatrix[i * n + j] = w;
            sum += w;
          }
        }
      }
      weightSum[i] = sum > 0 ? sum : 1.0;
    }

    // 3. Initial placement from Spectral or circular
    final posX = Float64List(n);
    final posY = Float64List(n);

    if (n > 2) {
      final spectral = SpectralLayout<V>(
        scale: vertexDistance * math.sqrt(n),
        seed: seed,
      );
      final specResult = spectral.layout(input);
      for (var i = 0; i < n; i++) {
        final p = specResult[list[i]] ?? center;
        posX[i] = p.x;
        posY[i] = p.y;
      }
    } else {
      final (initPos, _) = arcPlacement<V>(
        vertices: list,
        sizeOf: input.sizeOf,
        radius: vertexDistance,
        center: center,
      );
      for (var i = 0; i < n; i++) {
        final p = initPos[list[i]] ?? center;
        posX[i] = p.x;
        posY[i] = p.y;
      }
    }

    // 4. SMACOF iterations
    final rng = math.Random(seed);
    for (var iter = 0; iter < iterations; iter++) {
      var maxDisplacement = 0.0;

      for (var i = 0; i < n; i++) {
        var newX = 0.0;
        var newY = 0.0;
        final pxI = posX[i];
        final pyI = posY[i];

        for (var j = 0; j < n; j++) {
          if (i != j) {
            final w = weightMatrix[i * n + j];
            if (w > 0.0) {
              final dIdeal = distMatrix[i * n + j] * vertexDistance;
              var dx = pxI - posX[j];
              var dy = pyI - posY[j];
              var dist = math.sqrt(dx * dx + dy * dy);
              if (dist < 1e-4) {
                dx = (rng.nextDouble() - 0.5) * 0.1;
                dy = (rng.nextDouble() - 0.5) * 0.1;
                dist = 1e-4;
              }
              newX += w * (posX[j] + dIdeal * (dx / dist));
              newY += w * (posY[j] + dIdeal * (dy / dist));
            }
          }
        }

        final updatedX = newX / weightSum[i];
        final updatedY = newY / weightSum[i];
        final disp = math.sqrt(
          (updatedX - pxI) * (updatedX - pxI) +
              (updatedY - pyI) * (updatedY - pyI),
        );
        if (disp > maxDisplacement) maxDisplacement = disp;

        posX[i] = updatedX;
        posY[i] = updatedY;
      }

      if (maxDisplacement < tolerance) break;
    }

    // Translate center of mass to center
    var avgX = 0.0;
    var avgY = 0.0;
    for (var i = 0; i < n; i++) {
      avgX += posX[i];
      avgY += posY[i];
    }
    avgX /= n;
    avgY /= n;

    final positions = <V, LayoutPoint>{};
    for (var i = 0; i < n; i++) {
      positions[list[i]] = LayoutPoint(
        center.x + (posX[i] - avgX),
        center.y + (posY[i] - avgY),
      );
    }

    return LayoutResult<V>(positions: positions, vertexSizes: sizes);
  }
}
