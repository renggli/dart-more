import 'package:web/web.dart' as web;

import 'app_ui.dart';
import 'canvas_input.dart';
import 'commands.dart';
import 'inspector.dart';
import 'io.dart';
import 'menu.dart';
import 'modifier_panel.dart';
import 'renderer.dart';
import 'state.dart';
import 'toolbar.dart';

class AppUiImpl implements AppUi {
  new({
    required this.openFileCallback,
    required this.openImportCallback,
    required this.openExportCallback,
    required this.showInlineEditorCallback,
    required this.resetViewCallback,
  });

  final void Function() openFileCallback;
  final void Function() openImportCallback;
  final void Function() openExportCallback;
  final void Function(String vertex) showInlineEditorCallback;
  final void Function() resetViewCallback;

  @override
  double cursorX = 400.0;

  @override
  double cursorY = 300.0;

  @override
  String? pendingPlacementVertex;

  @override
  void openFile() => openFileCallback();

  @override
  void openImport() => openImportCallback();

  @override
  void openExport() => openExportCallback();

  @override
  void showInlineEditor(String vertex) => showInlineEditorCallback(vertex);

  @override
  void resetView() => resetViewCallback();
}

void main() {
  final state = AppState();

  // Restore from URL hash if available
  if (web.window.location.hash.isNotEmpty) {
    try {
      final restored = GraphIO.importFromUrlHash(web.window.location.hash);
      if (restored != null) {
        state.primaryGraph = restored.$1;
        state.isWeighted = restored.$2;
        state.nodes
          ..clear()
          ..addAll(restored.$3);
      }
    } catch (e) {
      web.window.alert('Failed to load graph from URL hash: $e');
    }
  }

  // Elements
  final canvasContainer =
      web.document.querySelector('#graph-canvas') as web.HTMLElement;
  final transformLayer = web.document.querySelector(
    '#viewport-transform-layer',
  ) as web.HTMLElement;

  final selectAddModifier = web.document.querySelector(
    '#select-add-modifier',
  ) as web.HTMLSelectElement;
  final modifiersStackList =
      web.document.querySelector('#modifiers-stack-list') as web.HTMLElement;

  late final GraphRenderer renderer;
  late final AppUiImpl ui;
  late final MenuController menuController;
  late final ToolbarController toolbarController;
  late final ModifierPanel modifierPanel;
  late final CanvasInput canvasInput;
  late final void Function() updateUI;

  void executeCommand(String cmdId) {
    final cmd = CommandRegistry.findById(cmdId);
    if (cmd == null) return;
    if (!cmd.canExecute(state, ui)) return;
    cmd.execute(state, ui);
    updateUI();
    modifierPanel.renderModifierStack(state, ui, updateUI);
  }

  ui = AppUiImpl(
    openFileCallback: () => toolbarController.triggerOpenFile(),
    openImportCallback: () => toolbarController.openImportModal(),
    openExportCallback: () => toolbarController.openExportModal(),
    showInlineEditorCallback: (v) {
      renderer.showInlineNodeEditor(
        state,
        v,
        onCommit: (newLabel) {
          state.saveSnapshot();
          state.getOrCreateNode(v).label = newLabel;
          updateUI();
        },
      );
    },
    resetViewCallback: () {
      toolbarController.dismissedEmpty = false;
      renderer.resetView();
      modifierPanel.renderModifierStack(state, ui, updateUI);
      updateUI();
    },
  );

  menuController = MenuController(
    state: state,
    ui: ui,
    onExecuteCommand: executeCommand,
  );

  modifierPanel = ModifierPanel(
    selectAddModifier: selectAddModifier,
    modifiersStackList: modifiersStackList,
  );

  renderer = GraphRenderer(
    container: canvasContainer,
    transformLayer: transformLayer,
    ui: ui,
    onVertexClick: (v, e) => canvasInput.handleVertexClick(v, e),
    onVertexDblClick: (v) => canvasInput.handleVertexDblClick(v),
    onEdgeClick: (s, t, e) => canvasInput.handleEdgeClick(s, t, e),
    onBackgroundClick: (e) => canvasInput.handleBackgroundClick(e),
    onLassoSelection: (v, e, shift) =>
        canvasInput.handleLassoSelection(v, e, shift),
    onPlacementConfirmed: (v) => canvasInput.handlePlacementConfirmed(v),
    onEdgeWeightEdit: (u, v, w) => canvasInput.handleEdgeWeightEdit(u, v, w),
    onNodesMoved: (moves) => canvasInput.handleNodesMoved(moves),
  );

  toolbarController = ToolbarController(
    state: state,
    ui: ui,
    renderer: renderer,
    onExecuteCommand: executeCommand,
    onUpdateUI: () => updateUI(),
    onRenderModifierStack: () =>
        modifierPanel.renderModifierStack(state, ui, updateUI),
  );

  canvasInput = CanvasInput(
    state: state,
    ui: ui,
    renderer: renderer,
    menuController: menuController,
    toolbarController: toolbarController,
    onExecuteCommand: executeCommand,
    onUpdateUI: () => updateUI(),
  );

  updateUI = () {
    state.evaluateModifiers();

    state.syncNodes();
    state.selectedVertices.removeWhere(
      (v) => !state.renderGraph.containsVertex(v),
    );
    if (state.selectedSource != null &&
        !state.renderGraph.containsVertex(state.selectedSource!)) {
      state.selectedSource = null;
    }
    if (state.selectedTarget != null &&
        !state.renderGraph.containsVertex(state.selectedTarget!)) {
      state.selectedTarget = null;
    }
    if (state.selectedEdge != null) {
      final (u, v) = state.selectedEdge!;
      if (!state.renderGraph.containsEdge(u, v) &&
          !(!state.renderGraph.isDirected &&
              state.renderGraph.containsEdge(v, u))) {
        state.selectedEdge = null;
      }
    }
    state.selectedEdges.removeWhere(
      (e) =>
          !state.renderGraph.containsEdge(e.$1, e.$2) &&
          !(!state.renderGraph.isDirected &&
              state.renderGraph.containsEdge(e.$2, e.$1)),
    );

    toolbarController.btnToggleStats?.classList.toggle(
      'active',
      state.showStats,
    );
    toolbarController.btnToggleLabels?.classList.toggle(
      'active',
      state.showLabels,
    );
    toolbarController.btnToggleWeights?.classList.toggle(
      'active',
      state.isWeighted,
    );

    toolbarController.btnModeVertex.classList.toggle(
      'active',
      state.selectVerticesMode,
    );
    toolbarController.btnModeEdge.classList.toggle(
      'active',
      state.selectEdgesMode,
    );

    toolbarController.selectDirectedness.value = state.primaryGraph.isDirected
        ? 'directed'
        : 'undirected';

    modifierPanel.updateModifierVertexDropdowns(state);
    modifierPanel.updateModifierCards();
    toolbarController.updateCanvasStats();
    toolbarController.updateIntroOverlay();
    menuController.syncMenuChecks();

    GraphInspector.updateInspector(
      state,
      onSelectVertex: (v, {isShift = false}) {
        if (!isShift) {
          state.clearSelection();
          state.selectVertex(v, clearOthers: true);
        } else {
          state.selectVertex(v, toggle: false, clearOthers: false);
        }
        updateUI();
      },
      onSelectEdge: (u, v, {isShift = false}) {
        state.selectEdge(u, v, toggle: false, clearOthers: !isShift);
        updateUI();
      },
    );

    renderer.render(state);
  };

  menuController.init();
  toolbarController.init();
  modifierPanel.init(state, ui, updateUI);
  canvasInput.init();

  renderer.autoLayout(state);
  modifierPanel.renderModifierStack(state, ui, updateUI);
  updateUI();
}
