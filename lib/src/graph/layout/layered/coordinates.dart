import 'dart:math' as math;

import 'dummy_vertices.dart';

/// Computes horizontal and vertical coordinates for [graph] using the Brandes-Köpf algorithm.
void assignCoordinates<V>(
  LayeredGraph<V> graph, {
  double vertexDistance = 20.0,
  double? layerDistance,
}) {
  final layers = graph.layers;
  if (layers.isEmpty) return;

  // 1. Cross-axis coordinate assignment (Brandes-Köpf median of 4 alignments)
  final xCoords = _brandesKoepf(graph, vertexDistance);
  for (final layer in layers) {
    for (final node in layer) {
      node.x = xCoords[node] ?? 0.0;
    }
  }

  // 2. Depth-axis coordinate assignment (layer spacing based on layer heights)
  var currentY = 0.0;
  var prevMaxHeight = 0.0;

  for (var l = 0; l < layers.length; l++) {
    final layer = layers[l];
    var currMaxHeight = 0.0;
    for (final node in layer) {
      if (node.height > currMaxHeight) currMaxHeight = node.height;
    }

    if (l > 0) {
      final sep =
          layerDistance ?? ((prevMaxHeight + currMaxHeight) / 2.0 + 50.0);
      currentY += sep;
    }
    for (final node in layer) {
      node.y = currentY;
    }
    prevMaxHeight = currMaxHeight;
  }
}

Map<LayerNode<V>, double> _brandesKoepf<V>(
  LayeredGraph<V> graph,
  double vertexDistance,
) {
  final layers = graph.layers;
  final allNodes = [for (final layer in layers) ...layer];
  if (allNodes.isEmpty) return const {};
  if (allNodes.length == 1) return {allNodes.first: 0.0};

  // Run 4 alignments
  final xDL = _alignAndPlace(
    graph,
    vertexDistance,
    isDownward: true,
    isLeftToRight: true,
  );
  final xDR = _alignAndPlace(
    graph,
    vertexDistance,
    isDownward: true,
    isLeftToRight: false,
  );
  final xUL = _alignAndPlace(
    graph,
    vertexDistance,
    isDownward: false,
    isLeftToRight: true,
  );
  final xUR = _alignAndPlace(
    graph,
    vertexDistance,
    isDownward: false,
    isLeftToRight: false,
  );

  // Normalize each alignment to have minX = 0
  double normalize(Map<LayerNode<V>, double> xMap) {
    final minX = xMap.values.reduce(math.min);
    final maxX = xMap.values.reduce(math.max);
    for (final node in allNodes) {
      xMap[node] = (xMap[node] ?? 0.0) - minX;
    }
    return maxX - minX;
  }

  final widthDL = normalize(xDL);
  final widthDR = normalize(xDR);
  final widthUL = normalize(xUL);
  final widthUR = normalize(xUR);

  // Shift right-to-left alignments to align with left-to-right
  final minWidth = [widthDL, widthDR, widthUL, widthUR].reduce(math.min);
  for (final node in allNodes) {
    xDR[node] = xDR[node]! + (minWidth - widthDR);
    xUR[node] = xUR[node]! + (minWidth - widthUR);
  }

  // Balanced median of the 4 candidate assignments
  final balanced = <LayerNode<V>, double>{};
  for (final node in allNodes) {
    final values = [xDL[node]!, xDR[node]!, xUL[node]!, xUR[node]!]..sort();
    balanced[node] = (values[1] + values[2]) / 2.0;
  }

  return balanced;
}

Map<LayerNode<V>, double> _alignAndPlace<V>(
  LayeredGraph<V> graph,
  double vertexDistance, {
  required bool isDownward,
  required bool isLeftToRight,
}) {
  final layers = graph.layers;
  final root = <LayerNode<V>, LayerNode<V>>{};
  final align = <LayerNode<V>, LayerNode<V>>{};
  final pos = <LayerNode<V>, double>{};

  for (final layer in layers) {
    for (final node in layer) {
      root[node] = node;
      align[node] = node;
    }
  }

  // Root & block alignment
  final layerIndices = isDownward
      ? List.generate(layers.length, (i) => i)
      : List.generate(layers.length, (i) => layers.length - 1 - i);

  for (final l in layerIndices) {
    final layer = layers[l];
    var r = isLeftToRight ? -1 : 0x7fffffff;
    final nodeIndices = isLeftToRight
        ? List.generate(layer.length, (i) => i)
        : List.generate(layer.length, (i) => layer.length - 1 - i);

    for (final k in nodeIndices) {
      final v = layer[k];
      final adjacent = isDownward
          ? (graph.predecessors[v] ?? const [])
          : (graph.successors[v] ?? const []);

      if (adjacent.isNotEmpty) {
        final sortedAdj = adjacent.toList()
          ..sort((a, b) => a.order.compareTo(b.order));

        final medians = <LayerNode<V>>[];
        final m = (sortedAdj.length - 1) / 2.0;
        medians.add(sortedAdj[m.floor()]);
        if (m.ceil() != m.floor()) medians.add(sortedAdj[m.ceil()]);

        for (final u in medians) {
          if (align[v] == v) {
            final orderCondition = isLeftToRight ? u.order > r : u.order < r;
            if (orderCondition) {
              align[u] = v;
              root[v] = root[u]!;
              align[v] = root[v]!;
              r = u.order;
            }
          }
        }
      }
    }
  }

  // Horizontal compaction (block placement)
  final sink = <LayerNode<V>, LayerNode<V>>{};
  final shift = <LayerNode<V>, double>{};

  for (final layer in layers) {
    for (final node in layer) {
      sink[node] = node;
      shift[node] = double.infinity;
    }
  }

  for (final l in layerIndices) {
    final layer = layers[l];
    final nodeIndices = isLeftToRight
        ? List.generate(layer.length, (i) => i)
        : List.generate(layer.length, (i) => layer.length - 1 - i);

    for (final k in nodeIndices) {
      final v = layer[k];
      if (root[v] == v) {
        _placeBlock(
          v,
          sink,
          shift,
          pos,
          root,
          align,
          layers,
          vertexDistance,
          isLeftToRight,
        );
      }
    }
  }

  // Apply shifts and assign coordinates
  final result = <LayerNode<V>, double>{};
  for (final layer in layers) {
    for (final v in layer) {
      final r = root[v]!;
      var x = pos[r] ?? 0.0;
      final s = shift[sink[r]!];
      if (s != null && s < double.infinity) {
        x += s;
      }
      result[v] = isLeftToRight ? x : -x;
    }
  }

  return result;
}

void _placeBlock<V>(
  LayerNode<V> v,
  Map<LayerNode<V>, LayerNode<V>> sink,
  Map<LayerNode<V>, double> shift,
  Map<LayerNode<V>, double> pos,
  Map<LayerNode<V>, LayerNode<V>> root,
  Map<LayerNode<V>, LayerNode<V>> align,
  List<List<LayerNode<V>>> layers,
  double vertexDistance,
  bool isLeftToRight,
) {
  if (pos.containsKey(v)) return;
  pos[v] = 0.0;

  var w = v;
  do {
    final layer = layers[w.rank];
    final order = w.order;
    final neighborOrder = isLeftToRight ? order - 1 : order + 1;

    if (neighborOrder >= 0 && neighborOrder < layer.length) {
      final neighbor = layer[neighborOrder];
      final u = root[neighbor]!;
      _placeBlock(
        u,
        sink,
        shift,
        pos,
        root,
        align,
        layers,
        vertexDistance,
        isLeftToRight,
      );

      if (sink[v] == v) {
        sink[v] = sink[u]!;
      }

      final requiredSep = (w.width + neighbor.width) / 2.0 + vertexDistance;
      if (sink[v] != sink[u]) {
        final curShift = shift[sink[u]!]!;
        final newShift = pos[v]! - pos[u]! - requiredSep;
        shift[sink[u]!] = math.min(curShift, newShift);
      } else {
        pos[v] = math.max(pos[v]!, pos[u]! + requiredSep);
      }
    }
    w = align[w]!;
  } while (w != v);
}
