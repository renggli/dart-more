import 'package:more/graph.dart';

import 'node.dart';

/// Sealed class representing visual overlays that decorate graph visualization.
sealed class VisualOverlay {
  const new({required this.title, this.summary = const {}});

  final String title;
  final Map<String, String> summary;
}

/// Overlay that highlights an ordered path or traversal sequence.
final class PathOverlay extends VisualOverlay {
  const new({
    required super.title,
    required this.vertices,
    this.edges = const [],
    this.stepNumbers = true,
    this.activeStep,
    super.summary,
  });

  final List<String> vertices;
  final List<(String, String)> edges;
  final bool stepNumbers;
  final int? activeStep;
}

/// Overlay that highlights sets of vertices and edges.
final class HighlightOverlay extends VisualOverlay {
  const new({
    required super.title,
    this.highlightedVertices = const {},
    this.secondaryVertices = const {},
    this.highlightedEdges = const {},
    this.edgeLabels = const {},
    super.summary,
  });

  final Set<String> highlightedVertices;
  final Set<String> secondaryVertices;
  final Set<(String, String)> highlightedEdges;
  final Map<(String, String), String> edgeLabels;
}

/// Overlay that colors vertices into discrete categories or components.
final class PartitionOverlay extends VisualOverlay {
  const new({
    required super.title,
    required this.vertexGroup,
    this.renderClusters = false,
    this.highlightedEdges = const {},
    super.summary,
  });

  final Map<String, int> vertexGroup;
  final bool renderClusters;
  final Set<(String, String)> highlightedEdges;
}

/// Overlay that colors vertices along a continuous numeric heatmap.
final class HeatmapOverlay extends VisualOverlay {
  const new({required super.title, required this.scores, super.summary});

  final Map<String, num> scores;
}

/// Snapshot of a graph state for undo/redo history.
final class GraphSnapshot {
  new({
    required this.isDirected,
    required this.isWeighted,
    required this.vertices,
    required this.edges,
    required this.nodes,
  });

  factory fromGraph(
    Graph<String, num> graph,
    bool isWeighted,
    Map<String, GraphNode> nodes,
  ) => GraphSnapshot(
    isDirected: graph.isDirected,
    isWeighted: isWeighted,
    vertices: graph.vertices.toList(),
    edges: [
      for (final edge in graph.edges) (edge.source, edge.target, edge.value),
    ],
    nodes: {
      for (final MapEntry(:key, :value) in nodes.entries)
        key: GraphNode(
          id: value.id,
          label: value.label,
          x: value.x,
          y: value.y,
        ),
    },
  );

  final bool isDirected;
  final bool isWeighted;
  final List<String> vertices;
  final List<(String, String, num)> edges;
  final Map<String, GraphNode> nodes;

  Graph<String, num> restore() {
    final graph = Graph<String, num>(isDirected: isDirected);
    for (final v in vertices) {
      graph.addVertex(v);
    }
    for (final (source, target, value) in edges) {
      graph.addEdge(source, target, value: value);
    }
    return graph;
  }
}

/// Workspace state for the graph web application.
final class AppState {
  new({Graph<String, num>? initialGraph})
    : primaryGraph = initialGraph ?? _createDefaultGraph() {
    syncNodes();
  }

  Graph<String, num> primaryGraph;
  Graph<String, num>? secondaryGraph;

  /// Dedicated node objects storing user labels and canvas positions.
  final Map<String, GraphNode> nodes = {};

  bool isWeighted = true;
  String layoutEngine = 'dot';
  String rankDir = 'LR';

  String? selectedSource;
  String? selectedTarget;
  Set<String> selectedVertices = {};
  (String, String)? selectedEdge;

  VisualOverlay? activeOverlay;

  final List<GraphSnapshot> undoStack = [];
  final List<GraphSnapshot> redoStack = [];

  static Graph<String, num> _createDefaultGraph() {
    final g = Graph<String, num>(isDirected: true);
    g.addEdge('A', 'B', value: 4);
    g.addEdge('A', 'C', value: 2);
    g.addEdge('B', 'C', value: 1);
    g.addEdge('B', 'D', value: 5);
    g.addEdge('C', 'D', value: 8);
    g.addEdge('C', 'E', value: 10);
    g.addEdge('D', 'E', value: 2);
    g.addEdge('D', 'Z', value: 6);
    g.addEdge('E', 'Z', value: 3);
    return g;
  }

  /// Synchronizes node records with current graph vertices.
  void syncNodes() {
    nodes.removeWhere((id, _) => !primaryGraph.containsVertex(id));
    for (final v in primaryGraph.vertices) {
      nodes.putIfAbsent(v, () => GraphNode(id: v, label: v));
    }
  }

  /// Retrieves or creates a node record for a given vertex id.
  GraphNode getOrCreateNode(String id, {String? label, double? x, double? y}) =>
      nodes.putIfAbsent(
        id,
        () => GraphNode(id: id, label: label ?? id, x: x, y: y),
      );

  /// Generates the next clean available node identifier (A..Z, then N1, N2..).
  String nextAvailableNodeId() {
    for (var i = 0; i < 26; i++) {
      final candidate = String.fromCharCode(65 + i);
      if (!primaryGraph.containsVertex(candidate) &&
          !nodes.containsKey(candidate)) {
        return candidate;
      }
    }
    var count = primaryGraph.vertices.length + 1;
    while (primaryGraph.containsVertex('N$count') ||
        nodes.containsKey('N$count')) {
      count++;
    }
    return 'N$count';
  }

  void saveSnapshot() {
    syncNodes();
    undoStack.add(GraphSnapshot.fromGraph(primaryGraph, isWeighted, nodes));
    if (undoStack.length > 50) {
      undoStack.removeAt(0);
    }
    redoStack.clear();
  }

  bool canUndo() => undoStack.isNotEmpty;
  bool canRedo() => redoStack.isNotEmpty;

  void undo() {
    if (!canUndo()) return;
    syncNodes();
    redoStack.add(GraphSnapshot.fromGraph(primaryGraph, isWeighted, nodes));
    final snapshot = undoStack.removeLast();
    primaryGraph = snapshot.restore();
    isWeighted = snapshot.isWeighted;
    nodes
      ..clear()
      ..addAll({
        for (final MapEntry(:key, :value) in snapshot.nodes.entries)
          key: GraphNode(
            id: value.id,
            label: value.label,
            x: value.x,
            y: value.y,
          ),
      });
    clearSelection();
    activeOverlay = null;
  }

  void redo() {
    if (!canRedo()) return;
    syncNodes();
    undoStack.add(GraphSnapshot.fromGraph(primaryGraph, isWeighted, nodes));
    final snapshot = redoStack.removeLast();
    primaryGraph = snapshot.restore();
    isWeighted = snapshot.isWeighted;
    nodes
      ..clear()
      ..addAll({
        for (final MapEntry(:key, :value) in snapshot.nodes.entries)
          key: GraphNode(
            id: value.id,
            label: value.label,
            x: value.x,
            y: value.y,
          ),
      });
    clearSelection();
    activeOverlay = null;
  }

  void setDirected(bool directed) {
    if (primaryGraph.isDirected == directed) return;
    saveSnapshot();
    final newGraph = Graph<String, num>(isDirected: directed);
    for (final v in primaryGraph.vertices) {
      newGraph.addVertex(v);
    }
    for (final e in primaryGraph.edges) {
      newGraph.addEdge(e.source, e.target, value: e.value);
    }
    primaryGraph = newGraph;
    clearSelection();
    activeOverlay = null;
  }

  void clearSelection() {
    selectedSource = null;
    selectedTarget = null;
    selectedVertices.clear();
    selectedEdge = null;
  }
}
