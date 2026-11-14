import 'package:more/graph.dart' hide GraphLayout;

import 'app_ui.dart';
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
  const new({
    required this.id,
    required this.title,
    required this.category,
    this.shortcuts = const [],
  });

  /// Unique identifier of the command.
  final String id;

  /// User-facing display title.
  final String title;

  /// Category under which this command is organized.
  final CommandCategory category;

  /// Keyboard shortcuts that trigger this command.
  final List<String> shortcuts;

  /// Primary keyboard shortcut for display.
  String? get shortcut => shortcuts.isNotEmpty ? shortcuts.first : null;

  /// Whether this command can currently execute given the application state.
  bool canExecute(AppState state, [AppUi? ui]);

  /// Executes this command against the application state.
  void execute(AppState state, [AppUi? ui]);

  /// Checks whether a keyboard event matches any shortcut of this command.
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

/// Lightweight command wrapping closures for execution and validation.
final class SimpleCommand extends GraphCommand {
  const new({
    required super.id,
    required super.title,
    required super.category,
    super.shortcuts = const [],
    this.canExecuteCallback,
    this.executeCallback,
    this.executeWithUiCallback,
  });

  /// Optional predicate for [canExecute].
  final bool Function(AppState state)? canExecuteCallback;

  /// Function to run during [execute].
  final void Function(AppState state)? executeCallback;

  /// Function to run during [execute] with access to [AppUi].
  final void Function(AppState state, AppUi? ui)? executeWithUiCallback;

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      canExecuteCallback?.call(state) ?? true;

  @override
  void execute(AppState state, [AppUi? ui]) {
    if (executeWithUiCallback != null) {
      executeWithUiCallback!(state, ui);
    } else {
      executeCallback?.call(state);
    }
  }
}

// ---------------------------------------------------------------------------
// Complex Edit Operations
// ---------------------------------------------------------------------------

/// Cuts selected vertices and edges into the clipboard.
class CutCommand extends GraphCommand {
  const new()
    : super(
        id: 'edit.cut',
        title: 'Cut',
        category: CommandCategory.edit,
        shortcuts: const ['Ctrl+X'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.selection.vertices.isNotEmpty || state.selection.edges.isNotEmpty;

  @override
  void execute(AppState state, [AppUi? ui]) {
    const CopyCommand().execute(state, ui);
    const DeleteCommand().execute(state, ui);
  }
}

/// Copies selected vertices and edges into the clipboard.
class CopyCommand extends GraphCommand {
  const new()
    : super(
        id: 'edit.copy',
        title: 'Copy',
        category: CommandCategory.edit,
        shortcuts: const ['Ctrl+C'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.selection.vertices.isNotEmpty || state.selection.edges.isNotEmpty;

  @override
  void execute(AppState state, [AppUi? ui]) {
    if (state.selection.isEmpty) return;

    final vertSet = Set<String>.from(state.selection.vertices);
    for (final (u, v) in state.selection.edges) {
      vertSet.add(u);
      vertSet.add(v);
    }

    final copiedEdges = <(String, String, num)>[];
    for (final edge in state.primaryGraph.edges) {
      final matchesSelected =
          state.selection.edges.contains((edge.source, edge.target)) ||
          state.selection.edges.contains(
            state.normalizeEdge(edge.source, edge.target),
          );
      if (matchesSelected ||
          (vertSet.contains(edge.source) && vertSet.contains(edge.target))) {
        copiedEdges.add((edge.source, edge.target, edge.value));
      }
    }

    final copiedNodes = <GraphNode>[];
    for (final v in vertSet) {
      final node = state.nodes[v];
      if (node != null) {
        copiedNodes.add(
          GraphNode(
            id: node.id,
            label: node.label,
            x: node.x,
            y: node.y,
            style: NodeStyle()
              ..fillColor = node.style.fillColor
              ..borderColor = node.style.borderColor
              ..textColor = node.style.textColor
              ..borderWidth = node.style.borderWidth
              ..opacity = node.style.opacity
              ..visible = node.style.visible,
          ),
        );
      }
    }

    state.clipboard = GraphClipboard(nodes: copiedNodes, edges: copiedEdges);
  }
}

/// Pastes graph data from the clipboard.
class PasteCommand extends GraphCommand {
  const new()
    : super(
        id: 'edit.paste',
        title: 'Paste',
        category: CommandCategory.edit,
        shortcuts: const ['Ctrl+V'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.clipboard != null && !state.clipboard!.isEmpty;

  @override
  void execute(AppState state, [AppUi? ui]) {
    final cb = state.clipboard;
    if (cb == null || cb.isEmpty) return;
    state.saveSnapshot();

    final oldToNew = <String, String>{};
    for (final oldNode in cb.nodes) {
      final oldId = oldNode.id;
      final newId = state.nextAvailableNodeId();
      oldToNew[oldId] = newId;
      state.primaryGraph.addVertex(newId);
      state.getOrCreateNode(
        newId,
        label: oldNode.label,
        x: (oldNode.x ?? 0.0) + 40.0,
        y: (oldNode.y ?? 0.0) + 40.0,
      );
    }

    final pastedEdges = <(String, String)>[];
    for (final (source, target, value) in cb.edges) {
      final newSource = oldToNew[source] ?? source;
      final newTarget = oldToNew[target] ?? target;
      state.primaryGraph.addEdge(newSource, newTarget, value: value);
      pastedEdges.add(state.normalizeEdge(newSource, newTarget));
    }

    state.selection.setVertices(oldToNew.values);
    state.selection.setEdges(pastedEdges);
  }
}

/// Duplicates the current selection.
class DuplicateCommand extends GraphCommand {
  const new()
    : super(
        id: 'edit.duplicate',
        title: 'Duplicate',
        category: CommandCategory.edit,
        shortcuts: const ['Shift+D'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.selection.vertices.isNotEmpty || state.selection.edges.isNotEmpty;

  @override
  void execute(AppState state, [AppUi? ui]) {
    const CopyCommand().execute(state, ui);
    const PasteCommand().execute(state, ui);
  }
}

/// Deletes selected vertices and edges.
class DeleteCommand extends GraphCommand {
  const new()
    : super(
        id: 'edit.delete',
        title: 'Delete Selected',
        category: CommandCategory.edit,
        shortcuts: const ['X', 'Delete', 'Backspace'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.selection.vertices.isNotEmpty || state.selection.edges.isNotEmpty;

  @override
  void execute(AppState state, [AppUi? ui]) {
    if (state.selection.isEmpty) return;
    state.saveSnapshot();

    if (state.selection.edges.isNotEmpty) {
      for (final (u, v) in state.selection.edges.toList()) {
        state.primaryGraph.removeEdge(u, v);
        if (!state.primaryGraph.isDirected) {
          state.primaryGraph.removeEdge(v, u);
        }
      }
    }

    if (state.selection.vertices.isNotEmpty) {
      for (final v in state.selection.vertices.toList()) {
        state.primaryGraph.removeVertex(v);
        state.nodes.remove(v);
      }
    }

    state.selection.clear();
  }
}

// ---------------------------------------------------------------------------
// Complex Vertex Operations
// ---------------------------------------------------------------------------

/// Adds a new vertex at the cursor position.
class AddVertexCommand extends GraphCommand {
  const new()
    : super(
        id: 'vertex.add',
        title: 'Add Vertex',
        category: CommandCategory.vertex,
        shortcuts: const ['V'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) => true;

  @override
  void execute(AppState state, [AppUi? ui]) {
    state.saveSnapshot();
    final newId = state.nextAvailableNodeId();
    state.primaryGraph.addVertex(newId);
    state.getOrCreateNode(
      newId,
      label: newId,
      x: ui?.cursorX ?? 400.0,
      y: ui?.cursorY ?? 300.0,
    );
    state.selection.clear();
    state.selection.selectVertex(newId);
    if (ui != null) ui.pendingPlacementVertex = newId;
  }
}

/// Expands a vertex by creating a new adjacent vertex.
class ExpandVertexCommand extends GraphCommand {
  const new({
    super.id = 'vertex.expand',
    super.title = 'Expand',
    super.category = CommandCategory.vertex,
    super.shortcuts = const ['E'],
  });

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.selection.vertices.isNotEmpty || state.activeVertex != null;

  @override
  void execute(AppState state, [AppUi? ui]) {
    state.saveSnapshot();
    final newId = state.nextAvailableNodeId();
    state.primaryGraph.addVertex(newId);
    state.getOrCreateNode(
      newId,
      label: newId,
      x: ui?.cursorX ?? 400.0,
      y: ui?.cursorY ?? 300.0,
    );

    final targets = state.selection.vertices.isNotEmpty
        ? state.selection.vertices.toList()
        : (state.activeVertex != null ? [state.activeVertex!] : <String>[]);

    for (final v in targets) {
      state.primaryGraph.addEdge(v, newId, value: 1);
    }

    state.selection.clear();
    state.selection.selectVertex(newId);
    if (ui != null) ui.pendingPlacementVertex = newId;
  }
}

/// Backwards compatibility alias for [ExpandVertexCommand].
class ExtrudeVertexCommand extends ExpandVertexCommand {
  const new()
    : super(id: 'vertex.extrude', title: 'Extrude', shortcuts: const []);
}

/// Merges multiple selected vertices into one.
class MergeVerticesCommand extends GraphCommand {
  const new()
    : super(
        id: 'vertex.merge',
        title: 'Merge Vertices',
        category: CommandCategory.vertex,
        shortcuts: const ['M'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.selection.vertices.length >= 2;

  @override
  void execute(AppState state, [AppUi? ui]) {
    if (state.selection.vertices.length < 2) return;
    final target = state.activeVertex ?? state.selection.vertices.first;
    state.saveSnapshot();
    final toMerge = state.selection.vertices.where((v) => v != target).toList();

    for (final v in toMerge) {
      for (final edge in state.primaryGraph.edgesOf(v).toList()) {
        final other = edge.source == v ? edge.target : edge.source;
        if (other != v && other != target) {
          if (state.primaryGraph.isDirected) {
            if (edge.source == v) {
              state.primaryGraph.addEdge(target, other, value: edge.value);
            } else {
              state.primaryGraph.addEdge(other, target, value: edge.value);
            }
          } else {
            state.primaryGraph.addEdge(target, other, value: edge.value);
          }
        }
      }
      state.primaryGraph.removeVertex(v);
      state.nodes.remove(v);
    }

    state.selection.clear();
    state.selection.selectVertex(target);
  }
}

// ---------------------------------------------------------------------------
// Complex Edge Operations
// ---------------------------------------------------------------------------

/// Connects all selected vertices with edges.
class ConnectVerticesCommand extends GraphCommand {
  const new()
    : super(
        id: 'edge.connect',
        title: 'Connect Selected Vertices',
        category: CommandCategory.edge,
        shortcuts: const ['F'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.selection.vertices.length >= 2;

  @override
  void execute(AppState state, [AppUi? ui]) {
    if (state.selection.vertices.length < 2) return;
    state.saveSnapshot();
    final list = state.selection.vertices.toList();

    for (var i = 0; i < list.length; i++) {
      for (var j = i + 1; j < list.length; j++) {
        final u = list[i];
        final v = list[j];
        final exists = state.primaryGraph.edges.any(
          (e) =>
              (e.source == u && e.target == v) ||
              (!state.primaryGraph.isDirected &&
                  e.source == v &&
                  e.target == u),
        );
        if (!exists) {
          state.primaryGraph.addEdge(u, v, value: 1);
        }
      }
    }
  }
}

/// Subdivides selected edges by inserting a vertex in the middle.
class SubdivideEdgeCommand extends GraphCommand {
  const new()
    : super(
        id: 'edge.subdivide',
        title: 'Subdivide Edge',
        category: CommandCategory.edge,
        shortcuts: const ['S'],
      );

  @override
  bool canExecute(AppState state, [AppUi? ui]) =>
      state.selection.edges.isNotEmpty || state.selection.selectedEdge != null;

  @override
  void execute(AppState state, [AppUi? ui]) {
    final edges = state.selection.edges.isNotEmpty
        ? state.selection.edges.toList()
        : (state.selection.selectedEdge != null
              ? [state.selection.selectedEdge!]
              : <(String, String)>[]);
    if (edges.isEmpty) return;

    state.saveSnapshot();
    final createdVertices = <String>{};

    for (final (u, v) in edges) {
      final edge =
          state.primaryGraph.getEdge(u, v) ??
          (!state.primaryGraph.isDirected
              ? state.primaryGraph.getEdge(v, u)
              : null);
      if (edge == null) continue;

      final val = edge.value;
      state.primaryGraph.removeEdge(u, v);
      if (!state.primaryGraph.isDirected) {
        state.primaryGraph.removeEdge(v, u);
      }

      final midId = state.nextAvailableNodeId();
      state.primaryGraph.addVertex(midId);
      createdVertices.add(midId);

      final nodeU = state.nodes[u];
      final nodeV = state.nodes[v];
      final midX = (nodeU != null && nodeV != null)
          ? ((nodeU.x ?? 0) + (nodeV.x ?? 0)) / 2
          : (ui?.cursorX ?? 400.0);
      final midY = (nodeU != null && nodeV != null)
          ? ((nodeU.y ?? 0) + (nodeV.y ?? 0)) / 2
          : (ui?.cursorY ?? 300.0);

      state.getOrCreateNode(midId, label: midId, x: midX, y: midY);
      state.primaryGraph.addEdge(u, midId, value: val);
      state.primaryGraph.addEdge(midId, v, value: val);
    }

    state.selection.clear();
    state.selection.setVertices(createdVertices);
  }
}

// ---------------------------------------------------------------------------
// Command Registry
// ---------------------------------------------------------------------------

/// Registry providing all available commands grouped by category.
class CommandRegistry {
  /// All available commands in the application.
  static final List<GraphCommand> all = [
    // File
    SimpleCommand(
      id: 'file.new',
      title: 'New',
      category: CommandCategory.file,
      shortcuts: const ['Ctrl+N'],
      executeWithUiCallback: (state, ui) {
        state.reset();
        ui?.resetView();
      },
    ),
    SimpleCommand(
      id: 'file.open',
      title: 'Open...',
      category: CommandCategory.file,
      shortcuts: const ['Ctrl+O'],
      executeWithUiCallback: (state, ui) => ui?.openFile(),
    ),
    SimpleCommand(
      id: 'file.save',
      title: 'Save',
      category: CommandCategory.file,
      shortcuts: const ['Ctrl+S'],
      canExecuteCallback: (state) => state.primaryGraph.vertices.isNotEmpty,
      executeCallback: (state) {
        final jsonStr = GraphIO.exportToJson(state);
        GraphIO.downloadTextFile('graph.json', jsonStr, 'application/json');
      },
    ),
    SimpleCommand(
      id: 'file.import',
      title: 'Import...',
      category: CommandCategory.file,
      shortcuts: const ['Ctrl+Shift+I'],
      executeWithUiCallback: (state, ui) => ui?.openImport(),
    ),
    SimpleCommand(
      id: 'file.export',
      title: 'Export...',
      category: CommandCategory.file,
      shortcuts: const ['Ctrl+Shift+E'],
      canExecuteCallback: (state) => state.primaryGraph.vertices.isNotEmpty,
      executeWithUiCallback: (state, ui) => ui?.openExport(),
    ),

    // Edit
    SimpleCommand(
      id: 'edit.undo',
      title: 'Undo',
      category: CommandCategory.edit,
      shortcuts: const ['Ctrl+Z'],
      canExecuteCallback: (state) => state.undoStack.isNotEmpty,
      executeCallback: (state) => state.undo(),
    ),
    SimpleCommand(
      id: 'edit.redo',
      title: 'Redo',
      category: CommandCategory.edit,
      shortcuts: const ['Ctrl+Shift+Z', 'Ctrl+Y'],
      canExecuteCallback: (state) => state.redoStack.isNotEmpty,
      executeCallback: (state) => state.redo(),
    ),
    const CutCommand(),
    const CopyCommand(),
    const PasteCommand(),
    const DuplicateCommand(),
    const DeleteCommand(),
    SimpleCommand(
      id: 'edit.clear_modifiers',
      title: 'Clear All Modifiers',
      category: CommandCategory.edit,
      canExecuteCallback: (state) => state.modifiers.isNotEmpty,
      executeCallback: (state) => state.clearModifiers(),
    ),
    SimpleCommand(
      id: 'edit.add_all_modifiers',
      title: 'Add All Modifiers (Disabled)',
      category: CommandCategory.edit,
      executeCallback: (state) => state.addAllModifiersDisabled(),
    ),

    // Select
    SimpleCommand(
      id: 'select.all',
      title: 'Select All',
      category: CommandCategory.select,
      shortcuts: const ['A'],
      canExecuteCallback: (state) =>
          state.primaryGraph.vertices.isNotEmpty && state.selection.isEmpty,
      executeCallback: (state) {
        state.selection.setVertices(state.primaryGraph.vertices);
        state.selection.setEdges({
          for (final e in state.primaryGraph.edges.toSet())
            state.normalizeEdge(e.source, e.target),
        });
      },
    ),
    SimpleCommand(
      id: 'select.none',
      title: 'Deselect All',
      category: CommandCategory.select,
      shortcuts: const ['A'],
      canExecuteCallback: (state) => state.selection.isNotEmpty,
      executeCallback: (state) => state.clearSelection(),
    ),
    SimpleCommand(
      id: 'select.expand',
      title: 'Expand Selection',
      category: CommandCategory.select,
      shortcuts: const ['+'],
      canExecuteCallback: (state) => state.selection.vertices.isNotEmpty,
      executeCallback: (state) {
        final toAdd = <String>{};
        for (final v in state.selection.vertices) {
          toAdd.addAll(state.primaryGraph.neighboursOf(v));
        }
        state.selection.setVertices({...state.selection.vertices, ...toAdd});
      },
    ),
    SimpleCommand(
      id: 'select.collapse',
      title: 'Collapse Selection',
      category: CommandCategory.select,
      shortcuts: const ['-'],
      canExecuteCallback: (state) => state.selection.vertices.isNotEmpty,
      executeCallback: (state) {
        if (state.selection.vertices.isEmpty) return;
        final toRemove = <String>{};
        for (final v in state.selection.vertices) {
          final neighbours = state.primaryGraph.neighboursOf(v);
          if (neighbours.isNotEmpty &&
              neighbours.any((nb) => !state.selection.vertices.contains(nb))) {
            toRemove.add(v);
          }
        }
        if (toRemove.length == state.selection.vertices.length) {
          state.selection.clear();
        } else {
          state.selection.setVertices(
            state.selection.vertices.difference(toRemove),
          );
        }
      },
    ),
    SimpleCommand(
      id: 'select.invert',
      title: 'Invert Selection',
      category: CommandCategory.select,
      shortcuts: const ['Ctrl+I'],
      canExecuteCallback: (state) => state.primaryGraph.vertices.isNotEmpty,
      executeCallback: (state) {
        final all = state.primaryGraph.vertices.toSet();
        state.selection.setVertices(all.difference(state.selection.vertices));
      },
    ),
    SimpleCommand(
      id: 'select.mode_vertex',
      title: 'Vertex Selection Mode',
      category: CommandCategory.select,
      shortcuts: const ['1'],
      executeCallback: (state) {
        state.selectVerticesMode = !state.selectVerticesMode;
        if (!state.selectVerticesMode && !state.selectEdgesMode) {
          state.selectEdgesMode = true;
        }
      },
    ),
    SimpleCommand(
      id: 'select.mode_edge',
      title: 'Edge Selection Mode',
      category: CommandCategory.select,
      shortcuts: const ['2'],
      executeCallback: (state) {
        state.selectEdgesMode = !state.selectEdgesMode;
        if (!state.selectVerticesMode && !state.selectEdgesMode) {
          state.selectVerticesMode = true;
        }
      },
    ),
    SimpleCommand(
      id: 'select.vertices',
      title: 'Select All Vertices',
      category: CommandCategory.select,
      canExecuteCallback: (state) => state.primaryGraph.vertices.isNotEmpty,
      executeCallback: (state) =>
          state.selection.setVertices(state.primaryGraph.vertices),
    ),
    SimpleCommand(
      id: 'select.edges',
      title: 'Select All Edges',
      category: CommandCategory.select,
      canExecuteCallback: (state) => state.primaryGraph.edges.isNotEmpty,
      executeCallback: (state) => state.selection.setEdges({
        for (final e in state.primaryGraph.edges.toSet())
          state.normalizeEdge(e.source, e.target),
      }),
    ),

    // Vertex
    const AddVertexCommand(),
    const ExpandVertexCommand(),
    const ExtrudeVertexCommand(),
    SimpleCommand(
      id: 'vertex.rename',
      title: 'Rename Active Vertex',
      category: CommandCategory.vertex,
      shortcuts: const ['F2'],
      canExecuteCallback: (state) => state.activeVertex != null,
      executeWithUiCallback: (state, ui) {
        final v = state.activeVertex;
        if (v != null) {
          ui?.showInlineEditor(v);
        }
      },
    ),
    const MergeVerticesCommand(),

    // Edge
    const ConnectVerticesCommand(),
    const SubdivideEdgeCommand(),
    SimpleCommand(
      id: 'edge.reverse',
      title: 'Reverse Edge Directions',
      category: CommandCategory.edge,
      shortcuts: const ['R'],
      canExecuteCallback: (state) =>
          state.primaryGraph.isDirected && state.primaryGraph.edges.isNotEmpty,
      executeCallback: (state) {
        if (!state.primaryGraph.isDirected) return;
        state.saveSnapshot();
        state.primaryGraph = state.primaryGraph.reversed.copy();
      },
    ),

    // Graph
    SimpleCommand(
      id: 'graph.layout',
      title: 'Auto Layout',
      category: CommandCategory.graph,
      shortcuts: const ['L'],
      canExecuteCallback: (state) => state.primaryGraph.vertices.isNotEmpty,
      executeCallback: GraphLayout.applyLayout,
    ),
    SimpleCommand(
      id: 'graph.complement',
      title: 'Complement Graph',
      category: CommandCategory.graph,
      canExecuteCallback: (state) => state.primaryGraph.vertices.length >= 2,
      executeCallback: (state) {
        state.saveSnapshot();
        state.primaryGraph = state.primaryGraph.complement(edge: (u, v) => 1);
      },
    ),
    SimpleCommand(
      id: 'graph.transitive_closure',
      title: 'Transitive Closure',
      category: CommandCategory.graph,
      canExecuteCallback: (state) =>
          state.primaryGraph.isDirected &&
          state.primaryGraph.vertices.isNotEmpty,
      executeCallback: (state) {
        if (!state.primaryGraph.isDirected) return;
        state.saveSnapshot();
        state.primaryGraph = state.primaryGraph.transitiveClosure().map(
          edge: (_) => 1,
        );
      },
    ),
    SimpleCommand(
      id: 'graph.transitive_reduction',
      title: 'Transitive Reduction',
      category: CommandCategory.graph,
      canExecuteCallback: (state) =>
          state.primaryGraph.isDirected &&
          state.primaryGraph.vertices.isNotEmpty,
      executeCallback: (state) {
        if (!state.primaryGraph.isDirected) return;
        state.saveSnapshot();
        state.primaryGraph = state.primaryGraph.transitiveReduction();
      },
    ),
  ];

  static final Map<String, GraphCommand> _byId = {
    for (final cmd in all) cmd.id: cmd,
  };

  /// Finds a command by its unique identifier.
  static GraphCommand? findById(String id) => _byId[id];
}
