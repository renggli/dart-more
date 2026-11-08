import 'package:more/graph.dart';

import 'modifiers.dart';
import 'node.dart';
import 'viz_interop.dart';

typedef GraphOverlay = VisualOverlay;

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
    super.title = '',
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
    super.title = '',
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

  /// Dedicated node objects storing user labels, spatial positions, and styling.
  final Map<String, GraphNode> nodes = {};

  /// Visual edge styling attributes dynamically styled by modifiers.
  final Map<(String, String), GraphEdgeStyle> edgeStyles = {};

  /// Retrieves or initializes the edge styling object for an edge.
  GraphEdgeStyle getEdgeStyle(String u, String v) =>
      edgeStyles.putIfAbsent((u, v), GraphEdgeStyle.new);

  /// Resets modifier-applied visual styles on vertices and edges.
  void resetVisualStyles() {
    for (final node in nodes.values) {
      node.resetVisuals();
    }
    edgeStyles.clear();
  }

  bool isWeighted = true;
  bool showLabels = true;
  String? pendingPlacementVertex;
  String layoutEngine = 'force';
  String rankDir = 'LR';

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
  VizInstance? viz;

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
      } catch (error) {
        final errOut = ModifierOutput(
          hasError: true,
          errorMessage: error.toString(),
          statusSummary: 'Error: $error',
        );
        lastModifierOutputs[mod.id] = errOut;
        // Skip applying graph or overlay changes on error
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

  void selectAllVertices() {
    selectedVertices = primaryGraph.vertices.toSet();
    activeVertex = selectedVertices.isNotEmpty ? selectedVertices.first : null;
    syncSelectionSourceTarget();
  }

  void selectAllEdges() {
    selectedEdges = {for (final e in primaryGraph.edges) (e.source, e.target)};
    selectedEdge = selectedEdges.isNotEmpty ? selectedEdges.first : null;
  }

  void selectAll() {
    selectAllVertices();
    selectAllEdges();
  }

  void invertSelection() {
    final all = primaryGraph.vertices.toSet();
    selectedVertices = all.difference(selectedVertices);
    activeVertex = selectedVertices.isNotEmpty ? selectedVertices.last : null;
    syncSelectionSourceTarget();
  }

  void growSelection() => expandSelection();

  /// Expands selection to include all direct neighbors of selected vertices.
  void expandSelection() {
    final toAdd = <String>{};
    for (final v in selectedVertices) {
      toAdd.addAll(primaryGraph.neighboursOf(v));
    }
    selectedVertices.addAll(toAdd);
    syncSelectionSourceTarget();
  }

  /// Collapses selection by deselecting boundary vertices that have external neighbors.
  void collapseSelection() {
    if (selectedVertices.isEmpty) return;
    final toRemove = <String>{};
    for (final v in selectedVertices) {
      final neighbours = primaryGraph.neighboursOf(v);
      if (neighbours.isNotEmpty &&
          neighbours.any((nb) => !selectedVertices.contains(nb))) {
        toRemove.add(v);
      }
    }
    if (toRemove.length == selectedVertices.length) {
      selectedVertices.clear();
    } else {
      selectedVertices.removeAll(toRemove);
    }
    syncSelectionSourceTarget();
  }

  /// Creates a new standalone vertex at ([x], [y]) with optional [label].
  String createVertexAt({double? x, double? y, String? label}) {
    saveSnapshot();
    final id = nextAvailableNodeId();
    primaryGraph.addVertex(id);
    getOrCreateNode(id, label: label ?? id, x: x, y: y);
    selectVertex(id, clearOthers: true);
    return id;
  }

  /// Expands a new vertex connected to all currently selected vertices (Blender 'E'),
  /// placing it at ([atX], [atY]) or offset from the selection centroid.
  String expandSelectedVertices({double? atX, double? atY, num weight = 1}) {
    saveSnapshot();
    final newId = nextAvailableNodeId();
    primaryGraph.addVertex(newId);

    var posX = atX;
    var posY = atY;
    if (posX == null || posY == null) {
      if (selectedVertices.isNotEmpty) {
        var sumX = 0.0;
        var sumY = 0.0;
        var count = 0;
        for (final v in selectedVertices) {
          final n = nodes[v];
          if (n != null && n.x != null && n.y != null) {
            sumX += n.x!;
            sumY += n.y!;
            count++;
          }
        }
        if (count > 0) {
          posX = (sumX / count) + 60.0;
          posY = (sumY / count) + 40.0;
        }
      }
      posX ??= 300.0;
      posY ??= 250.0;
    }

    getOrCreateNode(newId, label: newId, x: posX, y: posY);

    final targets = selectedVertices.isNotEmpty
        ? selectedVertices.toList()
        : (activeVertex != null ? [activeVertex!] : <String>[]);

    for (final v in targets) {
      primaryGraph.addEdge(v, newId, value: weight);
    }

    // Newly created vertex is selected and becomes the active vertex
    selectedEdges.clear();
    selectedEdge = null;
    selectedVertices = {newId};
    activeVertex = newId;
    selectedSource = null;
    selectedTarget = null;
    return newId;
  }

  /// Alias for [expandSelectedVertices] (Blender 'E').
  String extrudeSelectedVertices({double? atX, double? atY, num weight = 1}) =>
      expandSelectedVertices(atX: atX, atY: atY, weight: weight);

  /// Connects currently selected vertices (Blender 'F' hotkey).
  bool connectSelectedVertices({num weight = 1}) {
    if (selectedVertices.length < 2) return false;
    saveSnapshot();
    final list = selectedVertices.toList();
    selectedEdges.clear();

    if (list.length == 2) {
      primaryGraph.addEdge(list[0], list[1], value: weight);
      selectedEdge = (list[0], list[1]);
      selectedEdges.add((list[0], list[1]));
    } else {
      for (var i = 0; i < list.length - 1; i++) {
        primaryGraph.addEdge(list[i], list[i + 1], value: weight);
        selectedEdges.add((list[i], list[i + 1]));
      }
      selectedEdge = selectedEdges.isNotEmpty ? selectedEdges.last : null;
    }

    // On creation of an edge, only the edge is highlighted, not vertices before and afterward.
    selectedVertices.clear();
    activeVertex = null;
    selectedSource = null;
    selectedTarget = null;
    return true;
  }

  /// Adds a direct edge between [source] and [target], selecting only the created edge.
  bool addEdge(String source, String target, {num weight = 1}) {
    if (!primaryGraph.containsVertex(source) ||
        !primaryGraph.containsVertex(target)) {
      return false;
    }
    saveSnapshot();
    primaryGraph.addEdge(source, target, value: weight);

    // Only highlight the created edge
    selectedVertices.clear();
    activeVertex = null;
    selectedSource = null;
    selectedTarget = null;
    selectedEdges = {(source, target)};
    selectedEdge = (source, target);
    return true;
  }

  /// Subdivides selected edges by inserting midpoint vertices.
  int subdivideSelectedEdges() {
    final edgesToSplit = <(String, String, num)>[];
    for (final e in selectedEdges) {
      final edge =
          primaryGraph.getEdge(e.$1, e.$2) ??
          (!primaryGraph.isDirected ? primaryGraph.getEdge(e.$2, e.$1) : null);
      if (edge != null) {
        edgesToSplit.add((edge.source, edge.target, edge.value));
      }
    }
    if (edgesToSplit.isEmpty && selectedEdge != null) {
      final edge = primaryGraph.getEdge(selectedEdge!.$1, selectedEdge!.$2);
      if (edge != null) {
        edgesToSplit.add((edge.source, edge.target, edge.value));
      }
    }
    if (edgesToSplit.isEmpty) return 0;

    saveSnapshot();
    for (final (u, v, w) in edgesToSplit) {
      final mid = nextAvailableNodeId();
      final nodeU = nodes[u];
      final nodeV = nodes[v];
      double? midX;
      double? midY;
      if (nodeU?.x != null &&
          nodeV?.x != null &&
          nodeU?.y != null &&
          nodeV?.y != null) {
        midX = (nodeU!.x! + nodeV!.x!) / 2;
        midY = (nodeU.y! + nodeV.y!) / 2;
      }
      primaryGraph.removeEdge(u, v);
      primaryGraph.addVertex(mid);
      getOrCreateNode(mid, label: mid, x: midX, y: midY);
      primaryGraph.addEdge(u, mid, value: w);
      primaryGraph.addEdge(mid, v, value: w);
      selectedVertices.add(mid);
    }
    selectedEdges.clear();
    selectedEdge = null;
    return edgesToSplit.length;
  }

  /// Merges all selected vertices into the active vertex.
  bool mergeSelectedVertices() {
    if (selectedVertices.length < 2) return false;
    final target = activeVertex ?? selectedVertices.first;
    saveSnapshot();
    final toMerge = selectedVertices.where((v) => v != target).toList();

    for (final v in toMerge) {
      for (final edge in primaryGraph.edgesOf(v).toList()) {
        final other = edge.source == v ? edge.target : edge.source;
        if (other != v && other != target) {
          if (edge.source == v) {
            primaryGraph.addEdge(target, other, value: edge.value);
          } else {
            primaryGraph.addEdge(other, target, value: edge.value);
          }
        }
      }
      primaryGraph.removeVertex(v);
      nodes.remove(v);
    }
    selectedVertices = {target};
    activeVertex = target;
    syncSelectionSourceTarget();
    return true;
  }

  /// Duplicates selected vertices and the edges connecting them.
  int duplicateSelected({double offsetX = 40.0, double offsetY = 40.0}) {
    if (selectedVertices.isEmpty) return 0;
    saveSnapshot();

    final oldToNew = <String, String>{};
    for (final oldV in selectedVertices) {
      final newV = nextAvailableNodeId();
      oldToNew[oldV] = newV;
      primaryGraph.addVertex(newV);
      final oldNode = nodes[oldV];
      final newX = oldNode?.x != null ? oldNode!.x! + offsetX : null;
      final newY = oldNode?.y != null ? oldNode!.y! + offsetY : null;
      getOrCreateNode(
        newV,
        label: '${oldNode?.label ?? oldV}\'',
        x: newX,
        y: newY,
      );
    }

    // Duplicate internal edges between selected vertices
    for (final edge in primaryGraph.edges.toList()) {
      final newU = oldToNew[edge.source];
      final newV = oldToNew[edge.target];
      if (newU != null && newV != null) {
        primaryGraph.addEdge(newU, newV, value: edge.value);
      }
    }

    selectedVertices = oldToNew.values.toSet();
    activeVertex = selectedVertices.last;
    syncSelectionSourceTarget();
    return oldToNew.length;
  }

  /// Deletes selected vertices or selected edges.
  int deleteSelection() {
    var count = 0;
    if (selectedVertices.isNotEmpty) {
      saveSnapshot();
      count = selectedVertices.length;
      for (final v in selectedVertices.toList()) {
        primaryGraph.removeVertex(v);
        nodes.remove(v);
      }
      selectedVertices.clear();
      activeVertex = null;
      syncSelectionSourceTarget();
    } else if (selectedEdges.isNotEmpty) {
      saveSnapshot();
      count = selectedEdges.length;
      for (final (u, v) in selectedEdges.toList()) {
        primaryGraph.removeEdge(u, v);
      }
      selectedEdges.clear();
      selectedEdge = null;
    } else if (selectedEdge != null) {
      saveSnapshot();
      count = 1;
      primaryGraph.removeEdge(selectedEdge!.$1, selectedEdge!.$2);
      selectedEdge = null;
    }
    return count;
  }

  /// Reverses all directed edge orientations.
  void reverseDirections() {
    if (!primaryGraph.isDirected) return;
    saveSnapshot();
    primaryGraph = primaryGraph.reversed.copy();
  }

  /// Inverts edge connectivity.
  void complementGraph() {
    saveSnapshot();
    primaryGraph = primaryGraph.complement(edge: (u, v) => 1);
  }

  /// Adds direct edges for all reachable pairs in a directed graph.
  void transitiveClosure() {
    if (!primaryGraph.isDirected) return;
    saveSnapshot();
    primaryGraph = primaryGraph.transitiveClosure().map(edge: (_) => 1);
  }

  /// Removes redundant reachable edges in a directed acyclic graph.
  void transitiveReduction() {
    if (!primaryGraph.isDirected) return;
    saveSnapshot();
    primaryGraph = primaryGraph.transitiveReduction();
  }

  /// Clears all vertices and edges.
  void clearGraph() {
    saveSnapshot();
    primaryGraph = Graph<String, num>(isDirected: primaryGraph.isDirected);
    nodes.clear();
    clearSelection();
  }
}
