import 'dart:math' as math;

import '../layout.dart';
import 'result.dart';

/// Extension on [LayoutGraph] for Sugiyama-style hierarchical layered DAG layouts.
extension LayeredLayoutExtension<V> on LayoutGraph<V> {
  /// Positions vertices in hierarchical ranks using a Sugiyama-style layered DAG layout,
  /// calculating layer and node spacing from vertex dimensions to prevent overlaps.
  LayoutResult<V> layered({
    double? layerDistance,
    double nodeDistance = 20.0,
    LayoutOrientation orientation = LayoutOrientation.topToBottom,
  }) {
    final allVertices = vertices.toSet();
    if (allVertices.isEmpty) {
      return const LayoutResult(
        positions: {},
        bounds: LayoutRect(minX: 0, minY: 0, maxX: 0, maxY: 0),
      );
    }

    final forwardAdj = <V, List<V>>{};
    final reverseAdj = <V, List<V>>{};
    for (final v in allVertices) {
      forwardAdj[v] = [];
      reverseAdj.putIfAbsent(v, () => []);
    }
    for (final u in allVertices) {
      for (final v in successorsOf(u)) {
        if (allVertices.contains(v) && u != v) {
          forwardAdj[u]!.add(v);
          reverseAdj.putIfAbsent(v, () => []).add(u);
        }
      }
    }

    final layers = _assignLayers(allVertices, forwardAdj, reverseAdj);
    _barycenterOrdering(layers, forwardAdj, reverseAdj);

    final rawPositions = <V, (double, double)>{};
    var currentY = 0.0;
    var prevMaxHeight = 0.0;

    for (var layerIdx = 0; layerIdx < layers.length; layerIdx++) {
      final layerNodes = layers[layerIdx];
      final count = layerNodes.length;

      var currMaxHeight = 0.0;
      for (final v in layerNodes) {
        final h = heightOf(v);
        if (h > currMaxHeight) currMaxHeight = h;
      }

      if (layerIdx > 0) {
        final vSeparation =
            layerDistance ?? ((prevMaxHeight + currMaxHeight) / 2.0 + 30.0);
        currentY += vSeparation;
      }
      prevMaxHeight = currMaxHeight;

      final xOffsets = <double>[];
      var totalW = 0.0;
      for (var i = 0; i < count; i++) {
        final v = layerNodes[i];
        if (i == 0) {
          xOffsets.add(0.0);
        } else {
          final prevV = layerNodes[i - 1];
          final gap = (widthOf(prevV) + widthOf(v)) / 2.0 + nodeDistance;
          totalW += gap;
          xOffsets.add(totalW);
        }
      }

      final shiftX = -totalW / 2.0;
      for (var i = 0; i < count; i++) {
        rawPositions[layerNodes[i]] = (xOffsets[i] + shiftX, currentY);
      }
    }

    final orientedPositions = <V, LayoutPoint>{};
    for (final entry in rawPositions.entries) {
      final x = entry.value.$1;
      final y = entry.value.$2;
      final (ox, oy) = switch (orientation) {
        LayoutOrientation.topToBottom => (x, y),
        LayoutOrientation.bottomToTop => (x, -y),
        LayoutOrientation.leftToRight => (y, x),
        LayoutOrientation.rightToLeft => (-y, x),
      };
      orientedPositions[entry.key] = LayoutPoint(ox, oy);
    }

    final rawBounds = LayoutRect.fromPoints(orientedPositions.values);
    final finalPositions = <V, LayoutPoint>{};
    final dx = -rawBounds.minX;
    final dy = -rawBounds.minY;

    for (final entry in orientedPositions.entries) {
      finalPositions[entry.key] = entry.value.translate(dx, dy);
    }

    return LayoutResult<V>(
      positions: finalPositions,
      bounds: LayoutRect.fromPoints(finalPositions.values),
    );
  }
}

List<List<V>> _assignLayers<V>(
  Set<V> allVertices,
  Map<V, List<V>> forwardAdj,
  Map<V, List<V>> reverseAdj,
) {
  final rank = <V, int>{};
  final inDegree = <V, int>{
    for (final v in allVertices) v: reverseAdj[v]!.length,
  };

  final queue = <V>[
    for (final v in allVertices)
      if (inDegree[v] == 0) v,
  ];
  for (final v in queue) {
    rank[v] = 0;
  }

  final remaining = allVertices.toSet();

  while (queue.isNotEmpty) {
    final u = queue.removeAt(0);
    remaining.remove(u);
    final currentRank = rank[u]!;

    for (final v in forwardAdj[u]!) {
      final newRank = currentRank + 1;
      if (newRank > (rank[v] ?? 0)) {
        rank[v] = newRank;
      }
      inDegree[v] = inDegree[v]! - 1;
      if (inDegree[v] == 0) {
        queue.add(v);
      }
    }
  }

  while (remaining.isNotEmpty) {
    final cycleNode = remaining.first;
    remaining.remove(cycleNode);
    var maxPredRank = -1;
    for (final p in reverseAdj[cycleNode]!) {
      if (rank.containsKey(p) && rank[p]! > maxPredRank) {
        maxPredRank = rank[p]!;
      }
    }
    final r = maxPredRank + 1;
    rank[cycleNode] = r;

    for (final next in forwardAdj[cycleNode]!) {
      if (remaining.contains(next)) {
        rank[next] = r + 1;
      }
    }
  }

  final maxRank = rank.values.isEmpty ? 0 : rank.values.reduce(math.max);
  final layers = List<List<V>>.generate(maxRank + 1, (_) => <V>[]);
  for (final v in allVertices) {
    final r = rank[v] ?? 0;
    layers[r].add(v);
  }

  layers.removeWhere((l) => l.isEmpty);
  if (layers.isEmpty) {
    layers.add(allVertices.toList());
  }
  return layers;
}

void _barycenterOrdering<V>(
  List<List<V>> layers,
  Map<V, List<V>> forwardAdj,
  Map<V, List<V>> reverseAdj,
) {
  if (layers.length <= 1) return;

  for (var i = 1; i < layers.length; i++) {
    final prevLayer = layers[i - 1];
    final prevPos = <V, int>{
      for (var idx = 0; idx < prevLayer.length; idx++) prevLayer[idx]: idx,
    };
    final currLayer = layers[i];

    currLayer.sort((a, b) {
      final predsA = reverseAdj[a]!.where(prevPos.containsKey).toList();
      final predsB = reverseAdj[b]!.where(prevPos.containsKey).toList();

      final bcA = predsA.isEmpty
          ? 0.0
          : predsA.map((p) => prevPos[p]!).reduce((x, y) => x + y) /
                predsA.length;
      final bcB = predsB.isEmpty
          ? 0.0
          : predsB.map((p) => prevPos[p]!).reduce((x, y) => x + y) /
                predsB.length;

      return bcA.compareTo(bcB);
    });
  }

  for (var i = layers.length - 2; i >= 0; i--) {
    final nextLayer = layers[i + 1];
    final nextPos = <V, int>{
      for (var idx = 0; idx < nextLayer.length; idx++) nextLayer[idx]: idx,
    };
    final currLayer = layers[i];

    currLayer.sort((a, b) {
      final succsA = forwardAdj[a]!.where(nextPos.containsKey).toList();
      final succsB = forwardAdj[b]!.where(nextPos.containsKey).toList();

      final bcA = succsA.isEmpty
          ? 0.0
          : succsA.map((s) => nextPos[s]!).reduce((x, y) => x + y) /
                succsA.length;
      final bcB = succsB.isEmpty
          ? 0.0
          : succsB.map((s) => nextPos[s]!).reduce((x, y) => x + y) /
                succsB.length;

      return bcA.compareTo(bcB);
    });
  }
}
