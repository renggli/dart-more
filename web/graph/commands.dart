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
  String? get shortcut;
  CommandCategory get category;

  bool canExecute(AppState state);
  void execute(AppState state, {CommandContext? context});

  bool matchesKey(
    String key, {
    bool ctrl = false,
    bool shift = false,
    bool alt = false,
  }) {
    if (shortcut == null) return false;
    if (id == 'edit.delete') {
      if (!ctrl &&
          !alt &&
          (key == 'x' || key == 'X' || key == 'Delete' || key == 'Backspace')) {
        return true;
      }
    }
    if (id == 'select.all' || id == 'select.none') {
      if (!ctrl && !shift && !alt && (key == 'a' || key == 'A')) {
        return true;
      }
    }
    final parts = shortcut!.split('+');
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
    if (ctrl != reqCtrl || alt != reqAlt) return false;
    if (id == 'edit.redo' &&
        ctrl &&
        !alt &&
        (key == 'y' || key == 'Y' || (shift && (key == 'z' || key == 'Z')))) {
      return true;
    }
    if (shift != reqShift) return false;
    if (targetKey == '+' && (key == '+' || key == '=')) return true;
    if (targetKey == '-' && (key == '-' || key == '_')) return true;
    return key.toLowerCase() == targetKey.toLowerCase();
  }
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
    this.openImportModal,
    this.openExportModal,
    this.openFile,
    this.saveFile,
    this.runLayout,
    this.showIntro,
  });

  final double? cursorX;
  final double? cursorY;
  final void Function(String vertexId)? startVertexPlacement;
  final void Function(String message)? showToast;
  final void Function(String vertexId)? showInlineEditor;
  final void Function()? openIoModal;
  final void Function()? openImportModal;
  final void Function()? openExportModal;
  final void Function()? openFile;
  final void Function()? saveFile;
  final void Function()? runLayout;
  final void Function()? showIntro;
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
  void execute(AppState state, {CommandContext? context}) {
    state.clearGraph();
    context?.showIntro?.call();
    context?.showToast?.call('New graph');
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
  void execute(AppState state, {CommandContext? context}) {
    context?.openFile?.call();
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
  void execute(AppState state, {CommandContext? context}) {
    context?.saveFile?.call();
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
  void execute(AppState state, {CommandContext? context}) {
    context?.openImportModal?.call();
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
  void execute(AppState state, {CommandContext? context}) {
    context?.openExportModal?.call();
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
  void execute(AppState state, {CommandContext? context}) {
    if (canExecute(state)) {
      state.undo();
      context?.showToast?.call('Undo');
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
  String? get shortcut => 'Ctrl+Y';

  @override
  CommandCategory get category => CommandCategory.edit;

  @override
  bool canExecute(AppState state) => state.redoStack.isNotEmpty;

  @override
  void execute(AppState state, {CommandContext? context}) {
    if (canExecute(state)) {
      state.redo();
      context?.showToast?.call('Redo');
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
  void execute(AppState state, {CommandContext? context}) {
    if (state.cutSelected()) {
      context?.showToast?.call('Cut selection');
    }
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
  void execute(AppState state, {CommandContext? context}) {
    if (state.copySelected()) {
      context?.showToast?.call('Copied selection');
    }
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
  void execute(AppState state, {CommandContext? context}) {
    if (state.pasteClipboard()) {
      context?.showToast?.call('Pasted');
    }
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
  void execute(AppState state, {CommandContext? context}) {
    final count = state.duplicateSelected();
    if (count > 0) {
      context?.showToast?.call('Duplicated');
    }
  }
}

class DeleteCommand extends GraphCommand {
  const new();

  @override
  String get id => 'edit.delete';

  @override
  String get title => 'Delete';

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
  void execute(AppState state, {CommandContext? context}) {
    final count = state.deleteSelection();
    if (count > 0) {
      context?.showToast?.call('Deleted selection');
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
  String? get shortcut => 'R';

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
  void execute(AppState state, {CommandContext? context}) {
    state.selectAll();
    context?.showToast?.call('Selected all vertices and edges');
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
  void execute(AppState state, {CommandContext? context}) {
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
  void execute(AppState state, {CommandContext? context}) {
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
  void execute(AppState state, {CommandContext? context}) {
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
  String? get shortcut => null;

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

  static List<GraphCommand> byCategory(CommandCategory category) =>
      all.where((cmd) => cmd.category == category).toList();

  static GraphCommand? findById(String id) {
    for (final cmd in all) {
      if (cmd.id == id) return cmd;
    }
    return null;
  }
}
