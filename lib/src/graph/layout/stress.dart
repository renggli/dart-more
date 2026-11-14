import 'dart:collection';
import 'dart:math' as math;
import 'dart:typed_data';

import 'geometry.dart';
import 'graph_layout.dart';
import 'spectral.dart';
import 'support/arc_placement.dart';

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
final class StressLayout<V> extends GraphLayout<V> {
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
  LayoutResult<V> layoutComponent(LayoutInput<V> input) {
    final list = input.vertices;
    final n = list.length;
    final (sizes, avgExtent) = input.computeExtents(list);
    final extents = Float64List.fromList([
      for (final v in list) math.max(sizes[v]!.width, sizes[v]!.height),
    ]);
    final baseStep = avgExtent + vertexDistance;
    final vertexIndex = <V, int>{for (var i = 0; i < n; i++) list[i]: i};

    // 1. All-pairs shortest path distances D[i * n + j]
    final distMatrix = Float64List(n * n);
    var maxGraphDist = 1.0;
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
        final d = dists[j];
        distMatrix[i * n + j] = d;
        if (d < double.infinity && d > maxGraphDist) {
          maxGraphDist = d;
        }
      }
    }

    final stepLength =
        baseStep * math.max(1.0, math.sqrt(2.0 * n) / maxGraphDist);

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
        scale: stepLength * math.sqrt(n),
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
        radius: stepLength / 2.0,
        center: center,
        vertexDistance: vertexDistance,
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
        final extI = extents[i];

        for (var j = 0; j < n; j++) {
          if (i != j) {
            final w = weightMatrix[i * n + j];
            if (w > 0.0) {
              final minPairDist = (extI + extents[j]) / 2.0 + vertexDistance;
              final dIdeal = math.max(
                minPairDist,
                distMatrix[i * n + j] * stepLength,
              );
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
