import 'dart:math' as math;
import 'dart:typed_data';

import '../geometry.dart';
import '../graph_layout.dart';
import '../postprocess.dart';
import '../support/arc_placement.dart';
import '../support/components.dart';
import 'barnes_hut.dart';
import 'force_config.dart';

/// Positions vertices using a physical simulation of spring attraction and electrical repulsion.
///
/// Supports exact $O(V^2)$ simulation or Barnes-Hut $O(V \log V)$ approximation
/// for large graphs via [RepulsionMode.barnesHut].
///
/// ```dart
/// final graph = Graph<String, void>.undirected()
///   ..addEdge('A', 'B')
///   ..addEdge('B', 'C');
/// final result = graph.layout(const ForceLayout(seed: 42));
/// print(result.positions['A']);
/// ```
final class ForceLayout<V> implements GraphLayout<V> {
  /// Constructs a force-directed layout strategy.
  const new({
    this.config = const ForceConfig(),
    this.bounds = const LayoutRectangle(0, 0, 800, 600),
    this.pinned,
    this.initialPositions,
    this.seed,
    this.random,
    this.vertexDistance = 20.0,
  });

  /// Simulation parameters governing forces, cooling, and repulsion mode.
  final ForceConfig config;

  /// Bounding area guiding the simulation scale and gravity center.
  final LayoutRectangle bounds;

  /// Optional set of vertices whose positions remain fixed during simulation.
  final Set<V>? pinned;

  /// Optional initial positions for vertices.
  final Map<V, LayoutPoint>? initialPositions;

  /// Optional pseudo-random seed for deterministic simulation.
  final int? seed;

  /// Optional explicit random number generator.
  final math.Random? random;

  /// Spacing factor between vertices.
  final double vertexDistance;

  @override
  LayoutResult<V> layout(LayoutInput<V> input) {
    final list = input.vertices;
    if (list.isEmpty) {
      return LayoutResult<V>(positions: const {}, bounds: bounds);
    }
    if (list.length == 1) {
      final v = list.first;
      final pos = initialPositions?[v] ?? bounds.center;
      return LayoutResult<V>(
        positions: {v: pos},
        vertexSizes: {v: input.sizeOf(v)},
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
    final rng = random ?? (seed != null ? math.Random(seed) : math.Random(42));

    final width = bounds.width > 0 ? bounds.width : 800.0;
    final height = bounds.height > 0 ? bounds.height : 600.0;
    final area = width * height;
    final k =
        config.optimalDistance ??
        math.max(vertexDistance * 2.0, 0.75 * math.sqrt(area / n));
    final k2 = k * k;

    final posMap = <V, (double, double)>{};
    final sizes = <V, LayoutSize>{for (final v in list) v: input.sizeOf(v)};

    if (initialPositions != null) {
      for (final v in list) {
        final p = initialPositions![v];
        if (p != null) {
          posMap[v] = (p.x, p.y);
        }
      }
    }

    final missing = list.where((v) => !posMap.containsKey(v)).toList();
    if (missing.isNotEmpty) {
      final (seedPositions, _) = arcPlacement<V>(
        vertices: missing,
        sizeOf: input.sizeOf,
        radius: math.min(width, height) * 0.35,
        center: bounds.center,
        vertexDistance: vertexDistance,
      );
      for (final v in missing) {
        final p = seedPositions[v]!;
        final jx = (rng.nextDouble() - 0.5) * 5.0;
        final jy = (rng.nextDouble() - 0.5) * 5.0;
        posMap[v] = (p.x + jx, p.y + jy);
      }
    }

    final vertexIndex = <V, int>{for (var i = 0; i < n; i++) list[i]: i};
    final adj = List<List<int>>.generate(n, (_) => <int>[]);
    final weights = List<List<double>>.generate(n, (_) => <double>[]);

    for (var i = 0; i < n; i++) {
      final u = list[i];
      final seen = <int>{};
      for (final v in input.neighboursOf(u)) {
        final j = vertexIndex[v];
        if (j != null && j != i && seen.add(j)) {
          adj[i].add(j);
          weights[i].add(input.weightOf(u, v).toDouble());
        }
      }
    }

    final posX = Float64List(n);
    final posY = Float64List(n);
    final dispX = Float64List(n);
    final dispY = Float64List(n);

    for (var i = 0; i < n; i++) {
      final p = posMap[list[i]]!;
      posX[i] = p.$1;
      posY[i] = p.$2;
    }

    var temp = math.min(width, height) / 10.0;
    final initialTemp = temp;
    final cx = bounds.center.x;
    final cy = bounds.center.y;

    final useBarnesHut =
        config.repulsionMode == RepulsionMode.barnesHut ||
        (config.repulsionMode == RepulsionMode.exact && n > 200);

    for (var iter = 0; iter < config.iterations; iter++) {
      for (var i = 0; i < n; i++) {
        dispX[i] = (cx - posX[i]) * config.gravity;
        dispY[i] = (cy - posY[i]) * config.gravity;
      }

      // 1. Repulsive forces
      if (useBarnesHut) {
        final tree = Quadtree.build(posX, posY, n);
        for (var i = 0; i < n; i++) {
          tree.accumulateRepulsion(
            i,
            posX[i],
            posY[i],
            k2 * config.repulsionMultiplier,
            config.theta,
            dispX,
            dispY,
            rng,
          );
        }
      } else {
        final repK = k2 * config.repulsionMultiplier;
        for (var i = 0; i < n; i++) {
          final pxI = posX[i];
          final pyI = posY[i];
          for (var j = i + 1; j < n; j++) {
            var dx = pxI - posX[j];
            var dy = pyI - posY[j];
            var dist = math.sqrt(dx * dx + dy * dy);
            if (dist < 0.01) {
              dx = (rng.nextDouble() - 0.5) * 2.0;
              dy = (rng.nextDouble() - 0.5) * 2.0;
              dist = 0.01;
            }
            final force = repK / dist;
            final fx = (dx / dist) * force;
            final fy = (dy / dist) * force;

            dispX[i] += fx;
            dispY[i] += fy;
            dispX[j] -= fx;
            dispY[j] -= fy;
          }
        }
      }

      // 2. Attractive spring forces
      for (var i = 0; i < n; i++) {
        final pxI = posX[i];
        final pyI = posY[i];
        final neighbors = adj[i];
        final wList = weights[i];
        for (var idx = 0; idx < neighbors.length; idx++) {
          final j = neighbors[idx];
          if (i < j) {
            final dx = pxI - posX[j];
            final dy = pyI - posY[j];
            final dist = math.sqrt(dx * dx + dy * dy);
            if (dist > 0.01) {
              final w = wList[idx];
              final force =
                  ((dist * dist) / k) * config.attractionMultiplier * w;
              final fx = (dx / dist) * force;
              final fy = (dy / dist) * force;

              dispX[i] -= fx;
              dispY[i] -= fy;
              dispX[j] += fx;
              dispY[j] += fy;
            }
          }
        }
      }

      // 3. Position update clamped by temperature
      const margin = 20.0;
      for (var i = 0; i < n; i++) {
        final v = list[i];
        if (pinned != null && pinned!.contains(v)) continue;

        final dx = dispX[i];
        final dy = dispY[i];
        final disp = math.sqrt(dx * dx + dy * dy);
        if (disp > 0.001) {
          final step = math.min(disp, temp);
          posX[i] += (dx / disp) * step;
          posY[i] += (dy / disp) * step;
        }
        posX[i] = posX[i].clamp(bounds.minX + margin, bounds.maxX - margin);
        posY[i] = posY[i].clamp(bounds.minY + margin, bounds.maxY - margin);
      }

      temp =
          initialTemp *
          math.pow(1.0 - (iter + 1) / config.iterations, config.coolingFactor);
    }

    final finalPositions = <V, LayoutPoint>{};
    for (var i = 0; i < n; i++) {
      finalPositions[list[i]] = LayoutPoint(posX[i], posY[i]);
    }

    return LayoutResult<V>(positions: finalPositions, vertexSizes: sizes);
  }
}
