import 'package:more/graph.dart';

import 'modifiers.dart';
import 'node.dart';

/// Sealed class representing visual overlays that decorate graph visualization.
sealed class VisualOverlay {
  const new({this.title = '', this.summary = const {}});

  final String title;
  final Map<String, String> summary;
}

/// Overlay that highlights an ordered path or traversal sequence.
final class PathOverlay extends VisualOverlay {
  const new({
    super.title = '',
    required this.vertices,
    this.edges = const [],
    this.color,
    super.summary,
  });

  final List<String> vertices;
  final List<(String, String)> edges;
  final String? color;
}

/// Overlay that colors vertices into discrete categories or components.
final class PartitionOverlay extends VisualOverlay {
  const new({super.title = '', required this.vertexGroup, super.summary});

  final Map<String, int> vertexGroup;
}

/// Overlay that colors vertices along a continuous numeric heatmap.
final class HeatmapOverlay extends VisualOverlay {
  const new({super.title = '', required this.scores, super.summary});

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
          userFillColor: value.userFillColor,
          userBorderColor: value.userBorderColor,
          userTextColor: value.userTextColor,
          userBorderWidth: value.userBorderWidth,
          userOpacity: value.userOpacity,
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

/// In-memory clipboard snapshot for cut/copy/paste operations.
final class GraphClipboard {
  const new({required this.nodes, required this.edges});

  final List<GraphNode> nodes;
  final List<(String, String, num)> edges;

  bool get isEmpty => nodes.isEmpty && edges.isEmpty;
}

/// Workspace state for the graph web application.
final class AppState {
  new({Graph<String, num>? initialGraph})
    : primaryGraph = initialGraph ?? Graph<String, num>(isDirected: true) {
    syncNodes();
  }

  Graph<String, num> primaryGraph;

  /// Dedicated node objects storing user labels, spatial positions, and styling.
  final Map<String, GraphNode> nodes = {};

  /// Clipboard buffer for cut/copy/paste operations.
  GraphClipboard? clipboard;

  /// Visual edge styling attributes dynamically styled by modifiers.
  final Map<(String, String), GraphEdgeStyle> edgeStyles = {};

  /// Normalizes edge endpoints for undirected graphs so that (u, v) and (v, u) share the same key.
  static (String, String) edgeKey(
    String u,
    String v, {
    required bool isDirected,
  }) => isDirected ? (u, v) : (u.compareTo(v) <= 0 ? (u, v) : (v, u));

  /// Normalizes edge endpoints according to the primary graph's directedness.
  (String, String) normalizeEdge(String u, String v, {bool? isDirected}) =>
      edgeKey(u, v, isDirected: isDirected ?? primaryGraph.isDirected);

  /// Retrieves or initializes the edge styling object for an edge.
  GraphEdgeStyle getEdgeStyle(String u, String v, {bool? isDirected}) =>
      edgeStyles.putIfAbsent(
        edgeKey(u, v, isDirected: isDirected ?? renderGraph.isDirected),
        GraphEdgeStyle.new,
      );

  /// Resets modifier-applied visual styles on vertices and edges.
  void resetVisualStyles() {
    for (final node in nodes.values) {
      node.style.reset();
    }
    edgeStyles.clear();
  }

  /// Callback triggered when state is completely reset (e.g. File > New).
  void Function()? onReset;

  /// Resets workspace state completely back to an empty graph and clears all modifiers.
  void reset() {
    primaryGraph = Graph<String, num>(isDirected: primaryGraph.isDirected);
    nodes.clear();
    modifiers.clear();
    lastModifierOutputs.clear();
    effectiveGraph = null;
    activeOverlay = null;
    activeModifierTable = null;
    edgeStyles.clear();
    edgeRoutes.clear();
    clearSelection();
    onReset?.call();
  }

  bool isWeighted = true;
  bool showLabels = true;
  bool showStats = true;
  String? pendingPlacementVertex;
  double cursorX = 400.0;
  double cursorY = 300.0;

  /// UI delegate callbacks for view-layer triggers.
  void Function()? onOpenFile;
  void Function()? onOpenImport;
  void Function()? onOpenExport;
  void Function(String vertex)? onShowInlineEditor;

  String layoutEngine = 'stress';
  String rankDir = 'LR';
  Map<(String, String), List<LayoutPoint>> edgeRoutes = {};

  // Selection mode flags (like Blender, both can be active simultaneously)
  bool selectVerticesMode = true;
  bool selectEdgesMode = true;

  String? selectedSource;
  String? selectedTarget;
  String? activeVertex;
  Set<String> selectedVertices = {};
  (String, String)? selectedEdge;
  Set<(String, String)> selectedEdges = {};

  VisualOverlay? activeOverlay;

  final List<GraphSnapshot> undoStack = [];
  final List<GraphSnapshot> redoStack = [];

  /// Modifier stack evaluating non-destructively over the primary graph.
  final List<GraphModifier> modifiers = [];
  final Map<String, ModifierOutput> lastModifierOutputs = {};
  Graph<String, num>? effectiveGraph;
  ModifierTableData? activeModifierTable;

  /// Returns the current rendered graph (either transformed by modifiers or the base graph).
  Graph<String, num> get renderGraph => effectiveGraph ?? primaryGraph;

  /// Evaluates all active modifiers in sequence across the graph pipeline.
  void evaluateModifiers() {
    resetVisualStyles();
    var g = primaryGraph;
    VisualOverlay? finalOverlay;
    ModifierTableData? finalTable;
    lastModifierOutputs.clear();

    for (final mod in modifiers) {
      if (!mod.enabled) continue;
      try {
        final out = mod.apply(g, this);
        lastModifierOutputs[mod.id] = out;
        if (out.hasError) {
          // Skip applying graph or overlay changes from an erroring modifier
          continue;
        }
        if (out.transformedGraph != null) {
          g = out.transformedGraph!;
        }
        if (out.overlay != null) {
          finalOverlay = out.overlay;
        }
        if (out.tableData != null) {
          finalTable = out.tableData;
        }
      } on Exception catch (error, stackTrace) {
        final errOut = ModifierOutput(
          hasError: true,
          errorMessage: '$error\n$stackTrace',
          statusSummary: 'Error: $error',
        );
        lastModifierOutputs[mod.id] = errOut;
      }
    }

    effectiveGraph = g;
    activeOverlay = finalOverlay;
    activeModifierTable = finalTable;

    // Ensure all vertices in rendered graph have nodes
    for (final v in renderGraph.vertices) {
      nodes.putIfAbsent(v, () => GraphNode(id: v, label: v));
    }
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

  /// Checks whether [vertex] already exists in either the primary graph or node map.
  bool containsVertexOrNode(String vertex) =>
      primaryGraph.containsVertex(vertex) || nodes.containsKey(vertex);

  /// Generates the next clean available node identifier (A..Z, then N1, N2..).
  String nextAvailableNodeId() {
    for (var i = 0; i < 26; i++) {
      final candidate = String.fromCharCode(65 + i);
      if (!containsVertexOrNode(candidate)) {
        return candidate;
      }
    }
    var count = primaryGraph.vertices.length + 1;
    while (containsVertexOrNode('N$count')) {
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

  bool get canUndo => undoStack.isNotEmpty;
  bool get canRedo => redoStack.isNotEmpty;

  void undo() {
    if (!canUndo) return;
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
            userFillColor: value.userFillColor,
            userBorderColor: value.userBorderColor,
            userTextColor: value.userTextColor,
            userBorderWidth: value.userBorderWidth,
            userOpacity: value.userOpacity,
          ),
      });
    clearSelection();
    activeOverlay = null;
  }

  void redo() {
    if (!canRedo) return;
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
            userFillColor: value.userFillColor,
            userBorderColor: value.userBorderColor,
            userTextColor: value.userTextColor,
            userBorderWidth: value.userBorderWidth,
            userOpacity: value.userOpacity,
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
    activeVertex = null;
    selectedVertices.clear();
    selectedEdge = null;
    selectedEdges.clear();
  }

  /// Blender-style vertex selection with active element tracking.
  void selectVertex(String v, {bool toggle = false, bool clearOthers = true}) {
    if (clearOthers) {
      selectedVertices.clear();
      selectedEdge = null;
      selectedEdges.clear();
    }
    if (toggle) {
      if (selectedVertices.contains(v)) {
        selectedVertices.remove(v);
        if (activeVertex == v) {
          activeVertex = selectedVertices.isNotEmpty
              ? selectedVertices.last
              : null;
        }
      } else {
        selectedVertices.add(v);
        activeVertex = v;
      }
    } else {
      selectedVertices.add(v);
      activeVertex = v;
    }
    syncSelectionSourceTarget();
  }

  /// Edge selection normalizing endpoint order for undirected graphs.
  void selectEdge(
    String u,
    String v, {
    bool toggle = false,
    bool clearOthers = true,
  }) {
    final key = normalizeEdge(u, v);
    if (clearOthers) {
      selectedVertices.clear();
      selectedEdges.clear();
      selectedEdge = null;
    }
    if (toggle) {
      if (selectedEdges.contains(key)) {
        selectedEdges.remove(key);
        if (selectedEdge == key) {
          selectedEdge = selectedEdges.isNotEmpty ? selectedEdges.last : null;
        }
      } else {
        selectedEdges.add(key);
        selectedEdge = key;
      }
    } else {
      selectedEdges.add(key);
      selectedEdge = key;
    }
  }

  /// Whether the edge between [u] and [v] is currently selected.
  bool isEdgeSelected(String u, String v) =>
      selectedEdges.contains(normalizeEdge(u, v));

  /// Synchronizes source and target algorithm endpoints with active selection.
  void syncSelectionSourceTarget() {
    selectedVertices.removeWhere((v) => !renderGraph.containsVertex(v));
    if (activeVertex != null && !renderGraph.containsVertex(activeVertex!)) {
      activeVertex = null;
    }
    selectedSource =
        activeVertex ??
        (selectedVertices.isNotEmpty ? selectedVertices.first : null);
    selectedTarget = selectedVertices.firstWhere(
      (v) => v != selectedSource,
      orElse: () => '',
    );
    if (selectedTarget!.isEmpty) selectedTarget = null;
  }
}
