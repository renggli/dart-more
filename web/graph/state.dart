import 'package:more/graph.dart';

import 'enums.dart';
import 'modifiers.dart';
import 'node.dart';
import 'selection.dart';

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

  /// Normalizes edge endpoints according to the rendered graph's directedness.
  (String, String) normalizeEdge(String u, String v, {bool? isDirected}) =>
      edgeKey(u, v, isDirected: isDirected ?? renderGraph.isDirected);

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

  /// Clears all modifiers from the stack and re-evaluates the pipeline.
  void clearModifiers() {
    saveSnapshot();
    modifiers.clear();
    lastModifierOutputs.clear();
    activeOverlay = null;
    activeModifierTable = null;
    evaluateModifiers();
  }

  /// Restores modifier stack from serialized modifier JSON objects.
  void restoreModifiers(List<Map<String, dynamic>> serializedModifiers) {
    modifiers.clear();
    for (final json in serializedModifiers) {
      final mod = ModifierRegistry.fromJson(json);
      if (mod != null) {
        modifiers.add(mod);
      }
    }
    evaluateModifiers();
  }

  /// Populates all available modifiers in a disabled, collapsed state for quick experimentation.
  void addAllModifiersDisabled() {
    saveSnapshot();
    modifiers.clear();
    final combineSpec = ModifierRegistry.getSpec('combine');
    modifiers.add(
      combineSpec.factory()
        ..enabled = false
        ..collapsed = true,
    );
    for (final spec in ModifierRegistry.specs) {
      if (spec.type == 'combine') continue;
      final mod = spec.factory()
        ..enabled = false
        ..collapsed = true;
      modifiers.add(mod);
    }
    evaluateModifiers();
  }

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
    edgeRoutes = {};
    clearSelection();
    undoStack.clear();
    redoStack.clear();
  }

  bool isWeighted = true;
  bool showLabels = true;
  bool showStats = true;

  LayoutEngine layoutEngine = LayoutEngine.stress;
  RankDir rankDir = RankDir.lr;
  RankDir componentDirection = RankDir.tb;
  Map<(String, String), List<LayoutPoint>> edgeRoutes = {};

  // Selection mode flags (like Blender, both can be active simultaneously)
  bool selectVerticesMode = true;
  bool selectEdgesMode = true;

  /// Encapsulated selection state.
  final selection = Selection();

  String? get selectedSource => selection.source;
  set selectedSource(String? _) {}

  String? get selectedTarget => selection.target;
  set selectedTarget(String? _) {}

  String? get activeVertex => selection.activeVertex;
  set activeVertex(String? v) => selection.activeVertex = v;

  Set<String> get selectedVertices => selection.vertices;
  set selectedVertices(Set<String> v) => selection.setVertices(v);

  (String, String)? get selectedEdge => selection.selectedEdge;
  set selectedEdge((String, String)? e) =>
      selection.selectedEdge = e != null ? normalizeEdge(e.$1, e.$2) : null;

  Set<(String, String)> get selectedEdges => selection.edges;
  set selectedEdges(Set<(String, String)> e) =>
      selection.setEdges(e.map((edge) => normalizeEdge(edge.$1, edge.$2)));

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
    effectiveGraph = g;
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
          effectiveGraph = g;
        }
        if (out.overlay != null) {
          finalOverlay = out.overlay;
        }
        if (out.tableData != null) {
          finalTable = out.tableData;
        }
      } catch (error, stackTrace) {
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
    nodes.removeWhere(
      (id, _) =>
          !primaryGraph.containsVertex(id) && !renderGraph.containsVertex(id),
    );
    for (final v in renderGraph.vertices) {
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

  void clearSelection() => selection.clear();

  /// Blender-style vertex selection with active element tracking.
  void selectVertex(String v, {bool toggle = false, bool clearOthers = true}) =>
      selection.selectVertex(v, toggle: toggle, clearOthers: clearOthers);

  /// Edge selection normalizing endpoint order for undirected graphs.
  void selectEdge(
    String u,
    String v, {
    bool toggle = false,
    bool clearOthers = true,
  }) => selection.selectEdge(
    normalizeEdge(u, v),
    toggle: toggle,
    clearOthers: clearOthers,
  );

  /// Whether the edge between [u] and [v] is currently selected.
  bool isEdgeSelected(String u, String v) =>
      selection.edges.contains(normalizeEdge(u, v));

  /// Synchronizes source and target algorithm endpoints with active selection.
  void syncSelectionSourceTarget() {
    selection.filterVertices(renderGraph.containsVertex);
  }
}
