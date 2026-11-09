import 'package:more/graph.dart' hide GraphLayout;

import 'io.dart';
import 'layout.dart';
import 'node.dart';
import 'state.dart';

/// Categories for organizing graph operations in menus and hotkeys.
enum CommandCategory {
  file('File'),
  edit('Edit'),
  select('Select'),
  vertex('Vertex'),
  edge('Edge'),
  graph('Graph');

  new(this.label);
  final String label;
}

/// Abstract command encapsulating an action performed on the graph state.
abstract class GraphCommand {
  const new();

  String get id;
  String get title;
  List<String> get shortcuts => shortcut != null ? [shortcut!] : const [];
  String? get shortcut => null;
  CommandCategory get category;

  bool canExecute(AppState state);
  void execute(AppState state);

  bool matchesKey(
    String key, {
    bool ctrl = false,
    bool shift = false,
    bool alt = false,
  }) {
    for (final sc in shortcuts) {
      if (_matchesShortcut(sc, key, ctrl: ctrl, shift: shift, alt: alt)) {
        return true;
      }
    }
    return false;
  }

  static bool _matchesShortcut(
    String shortcutStr,
    String key, {
    required bool ctrl,
    required bool shift,
    required bool alt,
  }) {
    final parts = shortcutStr.split('+');
    var reqCtrl = false;
    var reqShift = false;
    var reqAlt = false;
    var targetKey = '';
    for (final part in parts) {
      if (part == 'Ctrl' || part == 'Cmd') {
        reqCtrl = true;
      } else if (part == 'Shift') {
        reqShift = true;
      } else if (part == 'Alt') {
        reqAlt = true;
      } else {
        targetKey = part;
      }
    }
    if (ctrl != reqCtrl || alt != reqAlt || shift != reqShift) return false;
    if (targetKey == '+' && (key == '+' || key == '=')) return true;
    if (targetKey == '-' && (key == '-' || key == '_')) return true;
    return key.toLowerCase() == targetKey.toLowerCase();
  }
}

// ---------------------------------------------------------------------------
// File Operations
// ---------------------------------------------------------------------------

class NewGraphCommand extends GraphCommand {
  const new();

  @override
  String get id => 'file.new';

  @override
  String get title => 'New';

  @override
  String? get shortcut => 'Ctrl+N';

  @override
  CommandCategory get category => CommandCategory.file;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.saveSnapshot();
    state.reset();
  }
}

class OpenGraphCommand extends GraphCommand {
  const new();

  @override
  String get id => 'file.open';

  @override
  String get title => 'Open...';

  @override
  String? get shortcut => 'Ctrl+O';

  @override
  CommandCategory get category => CommandCategory.file;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.onOpenFile?.call();
  }
}

class SaveGraphCommand extends GraphCommand {
  const new();

  @override
  String get id => 'file.save';

  @override
  String get title => 'Save...';

  @override
  String? get shortcut => 'Ctrl+S';

  @override
  CommandCategory get category => CommandCategory.file;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    final jsonStr = GraphIO.exportToJson(state);
    GraphIO.downloadTextFile('graph.json', jsonStr, 'application/json');
  }
}

class ImportGraphCommand extends GraphCommand {
  const new();

  @override
  String get id => 'file.import';

  @override
  String get title => 'Import...';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.file;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.onOpenImport?.call();
  }
}

class ExportGraphCommand extends GraphCommand {
  const new();

  @override
  String get id => 'file.export';

  @override
  String get title => 'Export...';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.file;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.onOpenExport?.call();
  }
}

// ---------------------------------------------------------------------------
// Edit Operations
// ---------------------------------------------------------------------------

class UndoCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edit.undo';

  @override
  String get title => 'Undo';

  @override
  String? get shortcut => 'Ctrl+Z';

  @override
  CommandCategory get category => CommandCategory.edit;

  @override
  bool canExecute(AppState state) => state.undoStack.isNotEmpty;

  @override
  void execute(AppState state) {
    if (canExecute(state)) {
      state.undo();
    }
  }
}

class RedoCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edit.redo';

  @override
  String get title => 'Redo';

  @override
  List<String> get shortcuts => const ['Ctrl+Shift+Z', 'Ctrl+Y'];

  @override
  String? get shortcut => 'Ctrl+Shift+Z';

  @override
  CommandCategory get category => CommandCategory.edit;

  @override
  bool canExecute(AppState state) => state.redoStack.isNotEmpty;

  @override
  void execute(AppState state) {
    if (canExecute(state)) {
      state.redo();
    }
  }
}

class CutCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edit.cut';

  @override
  String get title => 'Cut';

  @override
  String? get shortcut => 'Ctrl+X';

  @override
  CommandCategory get category => CommandCategory.edit;

  @override
  bool canExecute(AppState state) =>
      state.selectedVertices.isNotEmpty ||
      state.selectedEdges.isNotEmpty ||
      state.selectedEdge != null;

  @override
  void execute(AppState state) {
    const CopyCommand().execute(state);
    const DeleteCommand().execute(state);
  }
}

class CopyCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edit.copy';

  @override
  String get title => 'Copy';

  @override
  String? get shortcut => 'Ctrl+C';

  @override
  CommandCategory get category => CommandCategory.edit;

  @override
  bool canExecute(AppState state) =>
      state.selectedVertices.isNotEmpty ||
      state.selectedEdges.isNotEmpty ||
      state.selectedEdge != null;

  @override
  void execute(AppState state) {
    final vertSet = Set<String>.from(state.selectedVertices);
    for (final (u, v) in state.selectedEdges) {
      vertSet.add(u);
      vertSet.add(v);
    }
    if (state.selectedEdge != null) {
      vertSet.add(state.selectedEdge!.$1);
      vertSet.add(state.selectedEdge!.$2);
    }
    if (vertSet.isEmpty) return;

    final copiedNodes = <GraphNode>[
      for (final v in vertSet)
        if (state.nodes[v] != null)
          GraphNode(
            id: v,
            label: state.nodes[v]!.label,
            x: state.nodes[v]!.x,
            y: state.nodes[v]!.y,
          )
        else
          GraphNode(id: v, label: v),
    ];

    final copiedEdges = <(String, String, num)>[];
    for (final edge in state.primaryGraph.edges) {
      final inVertices =
          vertSet.contains(edge.source) && vertSet.contains(edge.target);
      final isExplicitEdge =
          state.selectedEdges.contains((edge.source, edge.target)) ||
          state.selectedEdge == (edge.source, edge.target);
      if (inVertices || isExplicitEdge) {
        copiedEdges.add((edge.source, edge.target, edge.value));
      }
    }

    state.clipboard = GraphClipboard(nodes: copiedNodes, edges: copiedEdges);
  }
}

class PasteCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edit.paste';

  @override
  String get title => 'Paste';

  @override
  String? get shortcut => 'Ctrl+V';

  @override
  CommandCategory get category => CommandCategory.edit;

  @override
  bool canExecute(AppState state) =>
      state.clipboard != null && !state.clipboard!.isEmpty;

  @override
  void execute(AppState state) {
    final clipboard = state.clipboard;
    if (clipboard == null || clipboard.isEmpty) return;
    state.saveSnapshot();

    const offsetX = 40.0;
    const offsetY = 40.0;
    final oldToNew = <String, String>{};
    for (final node in clipboard.nodes) {
      final newId = state.nextAvailableNodeId();
      oldToNew[node.id] = newId;
      state.primaryGraph.addVertex(newId);
      final newX = node.x != null ? node.x! + offsetX : null;
      final newY = node.y != null ? node.y! + offsetY : null;
      state.getOrCreateNode(newId, label: node.label, x: newX, y: newY);
    }

    for (final (source, target, value) in clipboard.edges) {
      final newSource = oldToNew[source];
      final newTarget = oldToNew[target];
      if (newSource != null && newTarget != null) {
        state.primaryGraph.addEdge(newSource, newTarget, value: value);
      }
    }

    state.selectedVertices = oldToNew.values.toSet();
    state.activeVertex = state.selectedVertices.isNotEmpty
        ? state.selectedVertices.last
        : null;
    state.selectedEdges.clear();
    for (final (source, target, _) in clipboard.edges) {
      final newSource = oldToNew[source];
      final newTarget = oldToNew[target];
      if (newSource != null && newTarget != null) {
        state.selectedEdges.add((newSource, newTarget));
      }
    }
    state.selectedEdge = state.selectedEdges.isNotEmpty
        ? state.selectedEdges.last
        : null;
    state.syncSelectionSourceTarget();
  }
}

class DuplicateCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edit.duplicate';

  @override
  String get title => 'Duplicate';

  @override
  String? get shortcut => 'Shift+D';

  @override
  CommandCategory get category => CommandCategory.edit;

  @override
  bool canExecute(AppState state) =>
      state.selectedVertices.isNotEmpty ||
      state.selectedEdges.isNotEmpty ||
      state.selectedEdge != null;

  @override
  void execute(AppState state) {
    const CopyCommand().execute(state);
    const PasteCommand().execute(state);
  }
}

class DeleteCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edit.delete';

  @override
  String get title => 'Delete';

  @override
  List<String> get shortcuts => const ['Delete', 'Backspace', 'X'];

  @override
  String? get shortcut => 'Delete';

  @override
  CommandCategory get category => CommandCategory.edit;

  @override
  bool canExecute(AppState state) =>
      state.selectedVertices.isNotEmpty ||
      state.selectedEdges.isNotEmpty ||
      state.selectedEdge != null;

  @override
  void execute(AppState state) {
    if (state.selectedVertices.isEmpty &&
        state.selectedEdges.isEmpty &&
        state.selectedEdge == null) {
      return;
    }
    state.saveSnapshot();

    if (state.selectedEdges.isNotEmpty) {
      for (final (u, v) in state.selectedEdges.toList()) {
        state.primaryGraph.removeEdge(u, v);
      }
      state.selectedEdges.clear();
      state.selectedEdge = null;
    } else if (state.selectedEdge != null) {
      state.primaryGraph.removeEdge(
        state.selectedEdge!.$1,
        state.selectedEdge!.$2,
      );
      state.selectedEdge = null;
    }

    if (state.selectedVertices.isNotEmpty) {
      for (final v in state.selectedVertices.toList()) {
        state.primaryGraph.removeVertex(v);
        state.nodes.remove(v);
      }
      state.selectedVertices.clear();
      state.activeVertex = null;
      state.syncSelectionSourceTarget();
    }
  }
}

// ---------------------------------------------------------------------------
// Vertex Operations
// ---------------------------------------------------------------------------

class AddVertexCommand extends GraphCommand {
  const new();

  @override
  String get id => 'vertex.add';

  @override
  String get title => 'Add Vertex';

  @override
  String? get shortcut => 'C';

  @override
  CommandCategory get category => CommandCategory.vertex;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.saveSnapshot();
    final id = state.nextAvailableNodeId();
    state.primaryGraph.addVertex(id);
    state.getOrCreateNode(id, label: id, x: state.cursorX, y: state.cursorY);
    state.selectVertex(id, clearOthers: true);
    state.pendingPlacementVertex = id;
  }
}

class ExpandVertexCommand extends GraphCommand {
  const new();

  @override
  String get id => 'vertex.expand';

  @override
  String get title => 'Expand';

  @override
  String? get shortcut => 'E';

  @override
  CommandCategory get category => CommandCategory.vertex;

  @override
  bool canExecute(AppState state) =>
      state.selectedVertices.isNotEmpty || state.activeVertex != null;

  @override
  void execute(AppState state) {
    state.saveSnapshot();
    final newId = state.nextAvailableNodeId();
    state.primaryGraph.addVertex(newId);
    state.getOrCreateNode(
      newId,
      label: newId,
      x: state.cursorX,
      y: state.cursorY,
    );

    final targets = state.selectedVertices.isNotEmpty
        ? state.selectedVertices.toList()
        : (state.activeVertex != null ? [state.activeVertex!] : <String>[]);

    for (final v in targets) {
      state.primaryGraph.addEdge(v, newId, value: 1);
    }

    state.selectedEdges.clear();
    state.selectedEdge = null;
    state.selectedVertices = {newId};
    state.activeVertex = newId;
    state.selectedSource = null;
    state.selectedTarget = null;
    state.pendingPlacementVertex = newId;
  }
}

/// Backwards compatibility alias for [ExpandVertexCommand].
class ExtrudeVertexCommand extends ExpandVertexCommand {
  const new();

  @override
  String get id => 'vertex.extrude';
}

class RenameVertexCommand extends GraphCommand {
  const new();

  @override
  String get id => 'vertex.rename';

  @override
  String get title => 'Rename Active Vertex';

  @override
  String? get shortcut => 'F2';

  @override
  CommandCategory get category => CommandCategory.vertex;

  @override
  bool canExecute(AppState state) => state.activeVertex != null;

  @override
  void execute(AppState state) {
    final v = state.activeVertex;
    if (v != null) {
      state.onShowInlineEditor?.call(v);
    }
  }
}

class MergeVerticesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'vertex.merge';

  @override
  String get title => 'Merge Vertices';

  @override
  String? get shortcut => 'M';

  @override
  CommandCategory get category => CommandCategory.vertex;

  @override
  bool canExecute(AppState state) => state.selectedVertices.length >= 2;

  @override
  void execute(AppState state) {
    if (state.selectedVertices.length < 2) return;
    final target = state.activeVertex ?? state.selectedVertices.first;
    state.saveSnapshot();
    final toMerge = state.selectedVertices.where((v) => v != target).toList();

    for (final v in toMerge) {
      for (final edge in state.primaryGraph.edgesOf(v).toList()) {
        final other = edge.source == v ? edge.target : edge.source;
        if (other != v && other != target) {
          if (edge.source == v) {
            state.primaryGraph.addEdge(target, other, value: edge.value);
          } else {
            state.primaryGraph.addEdge(other, target, value: edge.value);
          }
        }
      }
      state.primaryGraph.removeVertex(v);
      state.nodes.remove(v);
    }
    state.selectedVertices = {target};
    state.activeVertex = target;
    state.syncSelectionSourceTarget();
  }
}

// ---------------------------------------------------------------------------
// Edge Operations
// ---------------------------------------------------------------------------

class ConnectVerticesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edge.connect';

  @override
  String get title => 'Connect Vertices';

  @override
  String? get shortcut => 'F';

  @override
  CommandCategory get category => CommandCategory.edge;

  @override
  bool canExecute(AppState state) => state.selectedVertices.length >= 2;

  @override
  void execute(AppState state) {
    if (state.selectedVertices.length < 2) return;
    state.saveSnapshot();
    final list = state.selectedVertices.toList();
    state.selectedEdges.clear();

    if (list.length == 2) {
      state.primaryGraph.addEdge(list[0], list[1], value: 1);
      state.selectedEdge = (list[0], list[1]);
      state.selectedEdges.add((list[0], list[1]));
    } else {
      for (var i = 0; i < list.length - 1; i++) {
        state.primaryGraph.addEdge(list[i], list[i + 1], value: 1);
        state.selectedEdges.add((list[i], list[i + 1]));
      }
      state.selectedEdge = state.selectedEdges.isNotEmpty
          ? state.selectedEdges.last
          : null;
    }

    state.selectedVertices.clear();
    state.activeVertex = null;
    state.selectedSource = null;
    state.selectedTarget = null;
  }
}

class SubdivideEdgeCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edge.subdivide';

  @override
  String get title => 'Subdivide Edges';

  @override
  String? get shortcut => 'W';

  @override
  CommandCategory get category => CommandCategory.edge;

  @override
  bool canExecute(AppState state) =>
      state.selectedEdges.isNotEmpty || state.selectedEdge != null;

  @override
  void execute(AppState state) {
    final edgesToSplit = <(String, String, num)>[];
    for (final e in state.selectedEdges) {
      final edge =
          state.primaryGraph.getEdge(e.$1, e.$2) ??
          (!state.primaryGraph.isDirected
              ? state.primaryGraph.getEdge(e.$2, e.$1)
              : null);
      if (edge != null) {
        edgesToSplit.add((edge.source, edge.target, edge.value));
      }
    }
    if (edgesToSplit.isEmpty && state.selectedEdge != null) {
      final edge = state.primaryGraph.getEdge(
        state.selectedEdge!.$1,
        state.selectedEdge!.$2,
      );
      if (edge != null) {
        edgesToSplit.add((edge.source, edge.target, edge.value));
      }
    }
    if (edgesToSplit.isEmpty) return;

    state.saveSnapshot();
    for (final (u, v, w) in edgesToSplit) {
      final mid = state.nextAvailableNodeId();
      final nodeU = state.nodes[u];
      final nodeV = state.nodes[v];
      double? midX;
      double? midY;
      if (nodeU?.x != null &&
          nodeV?.x != null &&
          nodeU?.y != null &&
          nodeV?.y != null) {
        midX = (nodeU!.x! + nodeV!.x!) / 2;
        midY = (nodeU.y! + nodeV.y!) / 2;
      }
      state.primaryGraph.removeEdge(u, v);
      state.primaryGraph.addVertex(mid);
      state.getOrCreateNode(mid, label: mid, x: midX, y: midY);
      state.primaryGraph.addEdge(u, mid, value: w);
      state.primaryGraph.addEdge(mid, v, value: w);
      state.selectedVertices.add(mid);
    }
    state.selectedEdges.clear();
    state.selectedEdge = null;
  }
}

class ReverseEdgesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edge.reverse';

  @override
  String get title => 'Reverse Edge Directions';

  @override
  String? get shortcut => 'R';

  @override
  CommandCategory get category => CommandCategory.edge;

  @override
  bool canExecute(AppState state) => state.primaryGraph.isDirected;

  @override
  void execute(AppState state) {
    if (!state.primaryGraph.isDirected) return;
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.reversed.copy();
  }
}

// ---------------------------------------------------------------------------
// Graph Operations
// ---------------------------------------------------------------------------

class AutoLayoutCommand extends GraphCommand {
  const new();

  @override
  String get id => 'graph.layout';

  @override
  String get title => 'Auto Layout';

  @override
  String? get shortcut => 'L';

  @override
  CommandCategory get category => CommandCategory.graph;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    GraphLayout.applyLayout(state);
  }
}

class ComplementCommand extends GraphCommand {
  const new();

  @override
  String get id => 'graph.complement';

  @override
  String get title => 'Complement Graph';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.graph;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.complement(edge: (u, v) => 1);
  }
}

class TransitiveClosureCommand extends GraphCommand {
  const new();

  @override
  String get id => 'graph.transitive_closure';

  @override
  String get title => 'Transitive Closure';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.graph;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    if (!state.primaryGraph.isDirected) return;
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.transitiveClosure().map(
      edge: (_) => 1,
    );
  }
}

class TransitiveReductionCommand extends GraphCommand {
  const new();

  @override
  String get id => 'graph.transitive_reduction';

  @override
  String get title => 'Transitive Reduction';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.graph;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    if (!state.primaryGraph.isDirected) return;
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.transitiveReduction();
  }
}

// ---------------------------------------------------------------------------
// Select Operations
// ---------------------------------------------------------------------------

class SelectAllCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.all';

  @override
  String get title => 'Select All';

  @override
  String? get shortcut => 'A';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) =>
      state.selectedVertices.isEmpty &&
      state.selectedEdges.isEmpty &&
      state.selectedEdge == null;

  @override
  void execute(AppState state) {
    state.selectedVertices = state.primaryGraph.vertices.toSet();
    state.activeVertex = state.selectedVertices.isNotEmpty
        ? state.selectedVertices.first
        : null;
    state.syncSelectionSourceTarget();
    state.selectedEdges = {
      for (final e in state.primaryGraph.edges) (e.source, e.target),
    };
    state.selectedEdge = state.selectedEdges.isNotEmpty
        ? state.selectedEdges.first
        : null;
  }
}

class DeselectAllCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.none';

  @override
  String get title => 'Deselect All';

  @override
  String? get shortcut => 'A';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) =>
      state.selectedVertices.isNotEmpty ||
      state.selectedEdges.isNotEmpty ||
      state.selectedEdge != null;

  @override
  void execute(AppState state) {
    state.clearSelection();
  }
}

class ToggleVertexSelectionModeCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.mode_vertex';

  @override
  String get title => 'Vertex Selection Mode';

  @override
  String? get shortcut => '1';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.selectVerticesMode = !state.selectVerticesMode;
    if (!state.selectVerticesMode && !state.selectEdgesMode) {
      state.selectEdgesMode = true;
    }
  }
}

class ToggleEdgeSelectionModeCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.mode_edge';

  @override
  String get title => 'Edge Selection Mode';

  @override
  String? get shortcut => '2';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.selectEdgesMode = !state.selectEdgesMode;
    if (!state.selectVerticesMode && !state.selectEdgesMode) {
      state.selectVerticesMode = true;
    }
  }
}

class SelectAllVerticesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.vertices';

  @override
  String get title => 'Select All Vertices';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.selectedVertices = state.primaryGraph.vertices.toSet();
    state.activeVertex = state.selectedVertices.isNotEmpty
        ? state.selectedVertices.first
        : null;
    state.syncSelectionSourceTarget();
  }
}

class SelectAllEdgesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.edges';

  @override
  String get title => 'Select All Edges';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    state.selectedEdges = {
      for (final e in state.primaryGraph.edges) (e.source, e.target),
    };
    state.selectedEdge = state.selectedEdges.isNotEmpty
        ? state.selectedEdges.first
        : null;
  }
}

class ExpandSelectionCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.expand';

  @override
  String get title => 'Expand Selection';

  @override
  String? get shortcut => '+';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => state.selectedVertices.isNotEmpty;

  @override
  void execute(AppState state) {
    final toAdd = <String>{};
    for (final v in state.selectedVertices) {
      toAdd.addAll(state.primaryGraph.neighboursOf(v));
    }
    state.selectedVertices.addAll(toAdd);
    state.syncSelectionSourceTarget();
  }
}

class CollapseSelectionCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.collapse';

  @override
  String get title => 'Collapse Selection';

  @override
  String? get shortcut => '-';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => state.selectedVertices.isNotEmpty;

  @override
  void execute(AppState state) {
    if (state.selectedVertices.isEmpty) return;
    final toRemove = <String>{};
    for (final v in state.selectedVertices) {
      final neighbours = state.primaryGraph.neighboursOf(v);
      if (neighbours.isNotEmpty &&
          neighbours.any((nb) => !state.selectedVertices.contains(nb))) {
        toRemove.add(v);
      }
    }
    if (toRemove.length == state.selectedVertices.length) {
      state.selectedVertices.clear();
    } else {
      state.selectedVertices.removeAll(toRemove);
    }
    state.syncSelectionSourceTarget();
  }
}

class InvertSelectionCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.invert';

  @override
  String get title => 'Invert Selection';

  @override
  String? get shortcut => 'Ctrl+I';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state) {
    final all = state.primaryGraph.vertices.toSet();
    state.selectedVertices = all.difference(state.selectedVertices);
    state.activeVertex = state.selectedVertices.isNotEmpty
        ? state.selectedVertices.last
        : null;
    state.syncSelectionSourceTarget();
  }
}

/// Registry providing all available commands grouped by category.
class CommandRegistry {
  static const List<GraphCommand> all = [
    // File
    NewGraphCommand(),
    OpenGraphCommand(),
    SaveGraphCommand(),
    ImportGraphCommand(),
    ExportGraphCommand(),

    // Edit
    UndoCommand(),
    RedoCommand(),
    CutCommand(),
    CopyCommand(),
    PasteCommand(),
    DuplicateCommand(),
    DeleteCommand(),

    // Select
    SelectAllCommand(),
    DeselectAllCommand(),
    ExpandSelectionCommand(),
    CollapseSelectionCommand(),
    InvertSelectionCommand(),
    ToggleVertexSelectionModeCommand(),
    ToggleEdgeSelectionModeCommand(),
    SelectAllVerticesCommand(),
    SelectAllEdgesCommand(),

    // Vertex
    AddVertexCommand(),
    ExpandVertexCommand(),
    ExtrudeVertexCommand(),
    RenameVertexCommand(),
    MergeVerticesCommand(),

    // Edge
    ConnectVerticesCommand(),
    SubdivideEdgeCommand(),
    ReverseEdgesCommand(),

    // Graph
    AutoLayoutCommand(),
    ComplementCommand(),
    TransitiveClosureCommand(),
    TransitiveReductionCommand(),
  ];

  static final Map<String, GraphCommand> _byId = {
    for (final cmd in all) cmd.id: cmd,
  };

  static GraphCommand? findById(String id) => _byId[id];
}
