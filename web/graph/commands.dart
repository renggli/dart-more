import 'state.dart';

/// Categories for organizing graph operations in menus and hotkeys.
enum CommandCategory {
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
  String? get shortcut;
  CommandCategory get category;

  bool canExecute(AppState state);
  void execute(AppState state, {CommandContext? context});
}

/// Context passed to commands for cursor-aware or UI-aware execution.
class CommandContext {
  const new({
    this.cursorX,
    this.cursorY,
    this.startVertexPlacement,
    this.showToast,
    this.showInlineEditor,
    this.openIoModal,
    this.runLayout,
  });

  final double? cursorX;
  final double? cursorY;
  final void Function(String vertexId)? startVertexPlacement;
  final void Function(String message)? showToast;
  final void Function(String vertexId)? showInlineEditor;
  final void Function()? openIoModal;
  final void Function()? runLayout;
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
  void execute(AppState state, {CommandContext? context}) {
    final newId = state.createVertexAt(
      x: context?.cursorX,
      y: context?.cursorY,
    );
    if (context?.startVertexPlacement != null) {
      context!.startVertexPlacement!(newId);
    } else if (state.showLabels) {
      context?.showInlineEditor?.call(newId);
    }
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
  void execute(AppState state, {CommandContext? context}) {
    final newId = state.expandSelectedVertices(
      atX: context?.cursorX,
      atY: context?.cursorY,
    );
    if (context?.startVertexPlacement != null) {
      context!.startVertexPlacement!(newId);
    } else if (state.showLabels) {
      context?.showInlineEditor?.call(newId);
    }
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
  void execute(AppState state, {CommandContext? context}) {
    final v = state.activeVertex;
    if (v != null) {
      context?.showInlineEditor?.call(v);
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
  void execute(AppState state, {CommandContext? context}) {
    if (state.mergeSelectedVertices()) {
      context?.showToast?.call('Merged vertices into "${state.activeVertex}"');
    }
  }
}

class GrowVertexSelectionCommand extends GraphCommand {
  const new();

  @override
  String get id => 'vertex.grow';

  @override
  String get title => 'Grow Selection';

  @override
  String? get shortcut => '+';

  @override
  CommandCategory get category => CommandCategory.vertex;

  @override
  bool canExecute(AppState state) => state.selectedVertices.isNotEmpty;

  @override
  void execute(AppState state, {CommandContext? context}) {
    state.growSelection();
    context?.showToast?.call(
      'Selected ${state.selectedVertices.length} vertices',
    );
  }
}

class DeleteVerticesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'vertex.delete';

  @override
  String get title => 'Delete Vertices';

  @override
  String? get shortcut => 'X';

  @override
  CommandCategory get category => CommandCategory.vertex;

  @override
  bool canExecute(AppState state) => state.selectedVertices.isNotEmpty;

  @override
  void execute(AppState state, {CommandContext? context}) {
    final count = state.selectedVertices.length;
    state.deleteSelection();
    context?.showToast?.call('Deleted $count vertic${count > 1 ? "es" : "ex"}');
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
  void execute(AppState state, {CommandContext? context}) {
    if (state.connectSelectedVertices()) {
      context?.showToast?.call('Connected vertices with edge');
    }
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
  void execute(AppState state, {CommandContext? context}) {
    final count = state.subdivideSelectedEdges();
    if (count > 0) {
      context?.showToast?.call('Subdivided $count edge${count > 1 ? "s" : ""}');
    }
  }
}

class ReverseEdgesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edge.reverse';

  @override
  String get title => 'Reverse Edge Directions';

  @override
  String? get shortcut => 'Alt+R';

  @override
  CommandCategory get category => CommandCategory.edge;

  @override
  bool canExecute(AppState state) => state.primaryGraph.isDirected;

  @override
  void execute(AppState state, {CommandContext? context}) {
    state.reverseDirections();
    context?.showToast?.call('Reversed edge directions');
  }
}

class DeleteEdgesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edge.delete';

  @override
  String get title => 'Delete Edges';

  @override
  String? get shortcut => 'Alt+X';

  @override
  CommandCategory get category => CommandCategory.edge;

  @override
  bool canExecute(AppState state) =>
      state.selectedEdges.isNotEmpty || state.selectedEdge != null;

  @override
  void execute(AppState state, {CommandContext? context}) {
    state.selectedVertices.clear();
    final count = state.deleteSelection();
    context?.showToast?.call('Deleted $count edge${count > 1 ? "s" : ""}');
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
  void execute(AppState state, {CommandContext? context}) {
    context?.showToast?.call('Computing layout (${state.layoutEngine})...');
    context?.runLayout?.call();
  }
}

class DuplicateCommand extends GraphCommand {
  const new();

  @override
  String get id => 'graph.duplicate';

  @override
  String get title => 'Duplicate Subgraph';

  @override
  String? get shortcut => 'Shift+D';

  @override
  CommandCategory get category => CommandCategory.graph;

  @override
  bool canExecute(AppState state) => state.selectedVertices.isNotEmpty;

  @override
  void execute(AppState state, {CommandContext? context}) {
    final count = state.duplicateSelected();
    if (count > 0) {
      context?.showToast?.call(
        'Duplicated $count vertic${count > 1 ? "es" : "ex"}',
      );
    }
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
  void execute(AppState state, {CommandContext? context}) {
    state.complementGraph();
    context?.showToast?.call('Computed graph complement');
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
  void execute(AppState state, {CommandContext? context}) {
    state.transitiveClosure();
    context?.showToast?.call('Computed transitive closure');
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
  void execute(AppState state, {CommandContext? context}) {
    state.transitiveReduction();
    context?.showToast?.call('Computed transitive reduction');
  }
}

class ClearGraphCommand extends GraphCommand {
  const new();

  @override
  String get id => 'graph.clear';

  @override
  String get title => 'Clear All';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.graph;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state, {CommandContext? context}) {
    state.clearGraph();
    context?.showToast?.call('Cleared all vertices and edges');
  }
}

class ImportExportCommand extends GraphCommand {
  const new();

  @override
  String get id => 'graph.import_export';

  @override
  String get title => 'Import / Export...';

  @override
  String? get shortcut => null;

  @override
  CommandCategory get category => CommandCategory.graph;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state, {CommandContext? context}) {
    context?.openIoModal?.call();
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
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state, {CommandContext? context}) {
    state.selectAll();
    context?.showToast?.call('Selected all vertices and edges');
  }
}

class SelectAllVerticesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.vertices';

  @override
  String get title => 'Select All Vertices';

  @override
  String? get shortcut => 'Alt+1';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state, {CommandContext? context}) {
    state.selectAllVertices();
    context?.showToast?.call('Selected all vertices');
  }
}

class SelectAllEdgesCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.edges';

  @override
  String get title => 'Select All Edges';

  @override
  String? get shortcut => 'Alt+2';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state, {CommandContext? context}) {
    state.selectAllEdges();
    context?.showToast?.call('Selected all edges');
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
  void execute(AppState state, {CommandContext? context}) {
    state.expandSelection();
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
  void execute(AppState state, {CommandContext? context}) {
    state.collapseSelection();
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
  void execute(AppState state, {CommandContext? context}) {
    state.invertSelection();
  }
}

class DeselectAllCommand extends GraphCommand {
  const new();

  @override
  String get id => 'select.none';

  @override
  String get title => 'Deselect All';

  @override
  String? get shortcut => 'Alt+A';

  @override
  CommandCategory get category => CommandCategory.select;

  @override
  bool canExecute(AppState state) => true;

  @override
  void execute(AppState state, {CommandContext? context}) {
    state.clearSelection();
  }
}

/// Registry providing all available commands grouped by category.
class CommandRegistry {
  static const List<GraphCommand> all = [
    // Select
    SelectAllCommand(),
    ExpandSelectionCommand(),
    CollapseSelectionCommand(),
    InvertSelectionCommand(),
    DeselectAllCommand(),
    SelectAllVerticesCommand(),
    SelectAllEdgesCommand(),

    // Vertex
    AddVertexCommand(),
    ExpandVertexCommand(),
    ExtrudeVertexCommand(),
    RenameVertexCommand(),
    MergeVerticesCommand(),
    DeleteVerticesCommand(),

    // Edge
    ConnectVerticesCommand(),
    SubdivideEdgeCommand(),
    ReverseEdgesCommand(),
    DeleteEdgesCommand(),

    // Graph
    AutoLayoutCommand(),
    DuplicateCommand(),
    ComplementCommand(),
    TransitiveClosureCommand(),
    TransitiveReductionCommand(),
    ClearGraphCommand(),
    ImportExportCommand(),
  ];

  static List<GraphCommand> byCategory(CommandCategory category) =>
      all.where((cmd) => cmd.category == category).toList();

  static GraphCommand? findById(String id) {
    for (final cmd in all) {
      if (cmd.id == id) return cmd;
    }
    return null;
  }
}
