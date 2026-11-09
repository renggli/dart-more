import '../geometry.dart';

/// An internal node in a layered layout, representing either a real graph vertex
/// or a dummy node inserted along an edge spanning multiple layers.
final class LayerNode<V> {
  new real(this.vertex, {this.width = 40.0, this.height = 40.0})
    : isDummy = false,
      source = null,
      target = null;

  new dummy({required this.source, required this.target})
    : isDummy = true,
      vertex = null,
      width = 0.0,
      height = 0.0;

  final bool isDummy;
  final V? vertex;
  final V? source;
  final V? target;
  final double width;
  final double height;

  bool get isReal => !isDummy;

  int rank = 0;
  int order = 0;
  double x = 0.0;
  double y = 0.0;

  @override
  String toString() =>
      isDummy ? 'Dummy($source->$target, r:$rank)' : 'Node($vertex, r:$rank)';
}

/// A layered graph structure with dummy vertices inserted for all multi-rank edges.
final class LayeredGraph<V> {
  new({
    required this.layers,
    required this.realNodes,
    required this.dummyChains,
    required this.successors,
    required this.predecessors,
  });

  /// Nodes organized by layer/rank.
  final List<List<LayerNode<V>>> layers;

  /// Mapping from real vertex to its [LayerNode].
  final Map<V, LayerNode<V>> realNodes;

  /// Chains of dummy nodes inserted for multi-layer edges.
  final Map<(V, V), List<LayerNode<V>>> dummyChains;

  /// Successors of each [LayerNode].
  final Map<LayerNode<V>, List<LayerNode<V>>> successors;

  /// Predecessors of each [LayerNode].
  final Map<LayerNode<V>, List<LayerNode<V>>> predecessors;

  /// Inserts dummy vertices for all edges in [dagSuccessors] that span more than one rank.
  factory build({
    required Iterable<V> vertices,
    required Map<V, List<V>> dagSuccessors,
    required Map<V, int> ranks,
    required LayoutSize Function(V vertex) sizeOf,
  }) {
    final realNodes = <V, LayerNode<V>>{};
    final maxRank = ranks.values.isEmpty
        ? 0
        : ranks.values.reduce((a, b) => a > b ? a : b);
    final layers = List<List<LayerNode<V>>>.generate(
      maxRank + 1,
      (_) => <LayerNode<V>>[],
    );

    for (final v in vertices) {
      final size = sizeOf(v);
      final (w, h) = (size.width, size.height);
      final node = LayerNode<V>.real(v, width: w, height: h)
        ..rank = ranks[v] ?? 0;
      realNodes[v] = node;
      layers[node.rank].add(node);
    }

    final dummyChains = <(V, V), List<LayerNode<V>>>{};
    final successors = <LayerNode<V>, List<LayerNode<V>>>{};
    final predecessors = <LayerNode<V>, List<LayerNode<V>>>{};

    void addEdge(LayerNode<V> from, LayerNode<V> to) {
      successors.putIfAbsent(from, () => []).add(to);
      predecessors.putIfAbsent(to, () => []).add(from);
    }

    for (final u in vertices) {
      final uNode = realNodes[u]!;
      final uRank = ranks[u]!;
      final succs = dagSuccessors[u];
      if (succs == null) continue;

      for (final v in succs) {
        final vNode = realNodes[v];
        if (vNode == null) continue;
        final vRank = ranks[v]!;
        final span = vRank - uRank;

        if (span <= 1) {
          addEdge(uNode, vNode);
        } else {
          final chain = <LayerNode<V>>[];
          var prev = uNode;
          for (var r = uRank + 1; r < vRank; r++) {
            final dummy = LayerNode<V>.dummy(source: u, target: v)..rank = r;
            layers[r].add(dummy);
            chain.add(dummy);
            addEdge(prev, dummy);
            prev = dummy;
          }
          addEdge(prev, vNode);
          dummyChains[(u, v)] = chain;
        }
      }
    }

    // Ensure all nodes exist in adjacency maps
    for (final layer in layers) {
      for (final node in layer) {
        successors.putIfAbsent(node, () => []);
        predecessors.putIfAbsent(node, () => []);
      }
    }

    return LayeredGraph(
      layers: layers,
      realNodes: realNodes,
      dummyChains: dummyChains,
      successors: successors,
      predecessors: predecessors,
    );
  }
}
