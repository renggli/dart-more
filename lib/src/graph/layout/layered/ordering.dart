import 'dummy_vertices.dart';

/// Reduces edge crossings across layers using iterated barycenter sweeps and adjacent transposition.
void orderLayers<V>(LayeredGraph<V> graph, {int sweeps = 24}) {
  final layers = graph.layers;
  if (layers.length <= 1) {
    for (final layer in layers) {
      for (var i = 0; i < layer.length; i++) {
        layer[i].order = i;
      }
    }
    return;
  }

  // Initialize initial order
  for (final layer in layers) {
    for (var i = 0; i < layer.length; i++) {
      layer[i].order = i;
    }
  }

  var bestCrossings = totalCrossings(graph);
  var bestOrdering = [for (final layer in layers) List<LayerNode<V>>.of(layer)];

  for (var sweep = 0; sweep < sweeps; sweep++) {
    final isDownward = sweep.isEven;

    if (isDownward) {
      // Downward sweep: layer 1 to k-1
      for (var l = 1; l < layers.length; l++) {
        _sweepLayer(layers[l], graph.predecessors);
        _adjacentTranspositions(
          layers[l - 1],
          layers[l],
          l + 1 < layers.length ? layers[l + 1] : null,
          graph,
        );
      }
    } else {
      // Upward sweep: layer k-2 down to 0
      for (var l = layers.length - 2; l >= 0; l--) {
        _sweepLayer(layers[l], graph.successors);
        _adjacentTranspositions(
          l > 0 ? layers[l - 1] : null,
          layers[l],
          layers[l + 1],
          graph,
        );
      }
    }

    final currentCrossings = totalCrossings(graph);
    if (currentCrossings < bestCrossings) {
      bestCrossings = currentCrossings;
      bestOrdering = [for (final layer in layers) List<LayerNode<V>>.of(layer)];
      if (bestCrossings == 0) break;
    }
  }

  // Restore best ordering
  for (var l = 0; l < layers.length; l++) {
    layers[l].clear();
    layers[l].addAll(bestOrdering[l]);
    for (var i = 0; i < layers[l].length; i++) {
      layers[l][i].order = i;
    }
  }
}

void _sweepLayer<V>(
  List<LayerNode<V>> layer,
  Map<LayerNode<V>, List<LayerNode<V>>> adjacent,
) {
  final barycenters = <LayerNode<V>, double>{};

  for (var i = 0; i < layer.length; i++) {
    final node = layer[i];
    final neighbors = adjacent[node] ?? const [];
    if (neighbors.isEmpty) {
      // Keep current relative position (preserve order, not 0.0)
      barycenters[node] = i.toDouble();
    } else {
      var sum = 0.0;
      for (final n in neighbors) {
        sum += n.order;
      }
      barycenters[node] = sum / neighbors.length;
    }
  }

  layer.sort((a, b) {
    final bcA = barycenters[a]!;
    final bcB = barycenters[b]!;
    final cmp = bcA.compareTo(bcB);
    if (cmp != 0) return cmp;
    return a.order.compareTo(b.order);
  });

  for (var i = 0; i < layer.length; i++) {
    layer[i].order = i;
  }
}

void _adjacentTranspositions<V>(
  List<LayerNode<V>>? prevLayer,
  List<LayerNode<V>> currentLayer,
  List<LayerNode<V>>? nextLayer,
  LayeredGraph<V> graph,
) {
  var improved = true;
  while (improved) {
    improved = false;
    for (var i = 0; i < currentLayer.length - 1; i++) {
      final u = currentLayer[i];
      final v = currentLayer[i + 1];

      // Calculate crossings before swap
      var before = 0;
      if (prevLayer != null) {
        before += countCrossings(prevLayer, currentLayer, graph.successors);
      }
      if (nextLayer != null) {
        before += countCrossings(currentLayer, nextLayer, graph.successors);
      }

      // Swap
      currentLayer[i] = v;
      currentLayer[i + 1] = u;
      v.order = i;
      u.order = i + 1;

      // Calculate crossings after swap
      var after = 0;
      if (prevLayer != null) {
        after += countCrossings(prevLayer, currentLayer, graph.successors);
      }
      if (nextLayer != null) {
        after += countCrossings(currentLayer, nextLayer, graph.successors);
      }

      if (after < before) {
        improved = true;
      } else {
        // Revert swap
        currentLayer[i] = u;
        currentLayer[i + 1] = v;
        u.order = i;
        v.order = i + 1;
      }
    }
  }
}

/// Computes the total number of crossings across all consecutive layers in [graph].
int totalCrossings<V>(LayeredGraph<V> graph) {
  var total = 0;
  for (var l = 0; l < graph.layers.length - 1; l++) {
    total += countCrossings(
      graph.layers[l],
      graph.layers[l + 1],
      graph.successors,
    );
  }
  return total;
}

/// Counts crossings between [layerA] and [layerB] using a Fenwick tree (Binary Indexed Tree).
int countCrossings<V>(
  List<LayerNode<V>> layerA,
  List<LayerNode<V>> layerB,
  Map<LayerNode<V>, List<LayerNode<V>>> successors,
) {
  if (layerA.isEmpty || layerB.isEmpty) return 0;

  // Collect destination indices for edges from layerA to layerB
  final endpoints = <int>[];
  for (final u in layerA) {
    final targets =
        (successors[u] ?? const [])
            .where(layerB.contains)
            .map((v) => v.order)
            .toList()
          ..sort();
    endpoints.addAll(targets);
  }

  if (endpoints.length <= 1) return 0;

  // Count inversions using Fenwick tree
  final maxVal = layerB.length;
  final tree = List<int>.filled(maxVal + 2, 0);

  int query(int idx) {
    var sum = 0;
    var i = idx + 1;
    while (i > 0) {
      sum += tree[i];
      i -= i & -i;
    }
    return sum;
  }

  void update(int idx, int delta) {
    var i = idx + 1;
    while (i < tree.length) {
      tree[i] += delta;
      i += i & -i;
    }
  }

  var crossings = 0;
  for (var i = 0; i < endpoints.length; i++) {
    final target = endpoints[i];
    final count = i - query(target);
    crossings += count;
    update(target, 1);
  }

  return crossings;
}
