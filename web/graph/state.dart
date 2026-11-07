import 'package:more/graph.dart';

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
  });

  factory fromGraph(Graph<String, num> graph, bool isWeighted) => GraphSnapshot(
    isDirected: graph.isDirected,
    isWeighted: isWeighted,
    vertices: graph.vertices.toList(),
    edges: [
      for (final edge in graph.edges) (edge.source, edge.target, edge.value),
    ],
  );

  final bool isDirected;
  final bool isWeighted;
  final List<String> vertices;
  final List<(String, String, num)> edges;

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
    : primaryGraph = initialGraph ?? _createDefaultGraph();

  Graph<String, num> primaryGraph;
  Graph<String, num>? secondaryGraph;

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

  void saveSnapshot() {
    undoStack.add(GraphSnapshot.fromGraph(primaryGraph, isWeighted));
    if (undoStack.length > 50) {
      undoStack.removeAt(0);
    }
    redoStack.clear();
  }

  bool canUndo() => undoStack.isNotEmpty;
  bool canRedo() => redoStack.isNotEmpty;

  void undo() {
    if (!canUndo()) return;
    redoStack.add(GraphSnapshot.fromGraph(primaryGraph, isWeighted));
    final snapshot = undoStack.removeLast();
    primaryGraph = snapshot.restore();
    isWeighted = snapshot.isWeighted;
    clearSelection();
    activeOverlay = null;
  }

  void redo() {
    if (!canRedo()) return;
    undoStack.add(GraphSnapshot.fromGraph(primaryGraph, isWeighted));
    final snapshot = redoStack.removeLast();
    primaryGraph = snapshot.restore();
    isWeighted = snapshot.isWeighted;
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
