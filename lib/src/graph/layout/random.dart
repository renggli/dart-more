import 'dart:math' as math;

import 'geometry.dart';
import 'graph_layout.dart';

/// Randomly positions vertices uniformly within [bounds].
///
/// Useful for testing, benchmarking, or randomized initial state generation.
///
/// ```dart
/// final graph = Graph<String, void>.undirected()
///   ..addVertices(['A', 'B', 'C']);
/// final result = graph.layout(const RandomLayout(seed: 42));
/// print(result.positions['A']);
/// ```
final class RandomLayout<V> extends GraphLayout<V> {
  /// Constructs a random layout strategy.
  const new({
    this.bounds = const LayoutRectangle(0, 0, 800, 600),
    this.seed,
    this.random,
  });

  /// Bounding rectangle in which vertices are positioned.
  final LayoutRectangle bounds;

  /// Optional pseudo-random seed for deterministic positioning.
  final int? seed;

  /// Optional explicit [math.Random] instance.
  final math.Random? random;

  @override
  bool get packDisconnectedComponents => false;

  @override
  LayoutResult<V> layoutComponent(LayoutInput<V> input) {
    final list = input.vertices;
    final rng = random ?? (seed != null ? math.Random(seed) : math.Random());
    final positions = <V, LayoutPoint>{};
    final sizes = <V, LayoutSize>{};

    for (final v in list) {
      final size = input.sizeOf(v);
      sizes[v] = size;
      final (w, h) = (size.width, size.height);
      final availW = math.max(1.0, bounds.width - w);
      final availH = math.max(1.0, bounds.height - h);
      final x = bounds.minX + (w / 2.0) + rng.nextDouble() * availW;
      final y = bounds.minY + (h / 2.0) + rng.nextDouble() * availH;
      positions[v] = LayoutPoint(x, y);
    }

    return LayoutResult<V>(positions: positions, vertexSizes: sizes);
  }
}
