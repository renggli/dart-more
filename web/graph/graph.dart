import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'renderer.dart';
import 'state.dart';

void main() async {
  final state = AppState();

  // Elements
  final canvasContainer =
      web.document.querySelector('#graph-canvas') as web.HTMLElement;
  final btnDirected =
      web.document.querySelector('#btn-directed') as web.HTMLButtonElement;
  final btnWeighted =
      web.document.querySelector('#btn-weighted') as web.HTMLButtonElement;
  final selectLayout =
      web.document.querySelector('#select-layout') as web.HTMLSelectElement;
  final selectRankDir =
      web.document.querySelector('#select-rankdir') as web.HTMLSelectElement;
  final groupRankDir =
      web.document.querySelector('#group-rankdir') as web.HTMLElement;
  final btnUndo =
      web.document.querySelector('#btn-undo') as web.HTMLButtonElement;
  final btnRedo =
      web.document.querySelector('#btn-redo') as web.HTMLButtonElement;
  final btnClear =
      web.document.querySelector('#btn-clear') as web.HTMLButtonElement;
  final pillSource =
      web.document.querySelector('#pill-source') as web.HTMLElement;
  final pillTarget =
      web.document.querySelector('#pill-target') as web.HTMLElement;
  final btnClearSelection = web.document.querySelector(
    '#btn-clear-selection',
  ) as web.HTMLButtonElement;
  final btnZoomIn =
      web.document.querySelector('#btn-zoom-in') as web.HTMLButtonElement;
  final btnZoomOut =
      web.document.querySelector('#btn-zoom-out') as web.HTMLButtonElement;
  final btnZoomFit =
      web.document.querySelector('#btn-zoom-fit') as web.HTMLButtonElement;
  final codeDot = web.document.querySelector('#code-dot') as web.HTMLPreElement;
  final drawerHeader =
      web.document.querySelector('#drawer-header') as web.HTMLElement;
  final bottomDrawer =
      web.document.querySelector('#bottom-drawer') as web.HTMLElement;
  final drawerToggleIcon =
      web.document.querySelector('#drawer-toggle-icon') as web.HTMLElement;

  late final GraphRenderer renderer;

  void updateUI() {
    btnDirected.classList.toggle('active', state.primaryGraph.isDirected);
    btnDirected.textContent = state.primaryGraph.isDirected
        ? 'Directed'
        : 'Undirected';

    btnWeighted.classList.toggle('active', state.isWeighted);
    btnWeighted.textContent = state.isWeighted ? 'Weighted' : 'Unweighted';

    groupRankDir.style.display = state.layoutEngine == 'dot' ? 'flex' : 'none';

    btnUndo.disabled = !state.canUndo();
    btnRedo.disabled = !state.canRedo();

    pillSource.textContent = state.selectedSource ?? 'None';
    pillTarget.textContent = state.selectedTarget ?? 'None';

    codeDot.textContent = renderer.generateDot(state);

    renderer.render(state);
  }

  String getCanvasMode() {
    final radios = web.document.querySelectorAll('input[name="canvas-mode"]');
    for (var i = 0; i < radios.length; i++) {
      final radio = radios.item(i) as web.HTMLInputElement?;
      if (radio?.checked ?? false) {
        return radio!.value;
      }
    }
    return 'select';
  }

  void handleVertexClick(String vertex, web.MouseEvent event) {
    final mode = getCanvasMode();
    if (mode == 'delete') {
      state.saveSnapshot();
      state.primaryGraph.removeVertex(vertex);
      if (state.selectedSource == vertex) state.selectedSource = null;
      if (state.selectedTarget == vertex) state.selectedTarget = null;
      state.selectedVertices.remove(vertex);
      updateUI();
    } else if (mode == 'add-edge') {
      if (state.selectedSource == null) {
        state.selectedSource = vertex;
        updateUI();
      } else {
        final source = state.selectedSource!;
        state.saveSnapshot();
        state.primaryGraph.addEdge(source, vertex, value: 1);
        state.selectedSource = null;
        updateUI();
      }
    } else {
      // Select mode
      if (event.shiftKey || event.altKey) {
        state.selectedTarget = state.selectedTarget == vertex ? null : vertex;
      } else {
        if (state.selectedSource == vertex) {
          state.selectedSource = null;
        } else if (state.selectedTarget == vertex) {
          state.selectedTarget = null;
        } else if (state.selectedSource == null) {
          state.selectedSource = vertex;
        } else if (state.selectedTarget == null) {
          state.selectedTarget = vertex;
        } else {
          state.selectedSource = vertex;
        }
      }
      state.selectedEdge = null;
      updateUI();
    }
  }

  void handleEdgeClick(String source, String target, web.MouseEvent event) {
    final mode = getCanvasMode();
    if (mode == 'delete') {
      state.saveSnapshot();
      state.primaryGraph.removeEdge(source, target);
      if (state.selectedEdge == (source, target)) {
        state.selectedEdge = null;
      }
      updateUI();
    } else {
      state.selectedEdge = state.selectedEdge == (source, target)
          ? null
          : (source, target);
      updateUI();
    }
  }

  void handleBackgroundClick(web.MouseEvent event) {
    final mode = getCanvasMode();
    if (mode == 'add-node') {
      state.saveSnapshot();
      // Generate unique name
      var idx = state.primaryGraph.vertices.length;
      var name = String.fromCharCode(65 + idx % 26);
      while (state.primaryGraph.containsVertex(name)) {
        idx++;
        name = idx < 26 ? String.fromCharCode(65 + idx) : 'V$idx';
      }
      state.primaryGraph.addVertex(name);
      updateUI();
    }
  }

  renderer = GraphRenderer(
    container: canvasContainer,
    onVertexClick: handleVertexClick,
    onEdgeClick: handleEdgeClick,
    onBackgroundClick: handleBackgroundClick,
  );

  await renderer.initialize();

  // Header listeners
  btnDirected.onClick.listen((_) {
    state.setDirected(!state.primaryGraph.isDirected);
    updateUI();
  });

  btnWeighted.onClick.listen((_) {
    state.isWeighted = !state.isWeighted;
    updateUI();
  });

  selectLayout.onChange.listen((_) {
    state.layoutEngine = selectLayout.value;
    updateUI();
  });

  selectRankDir.onChange.listen((_) {
    state.rankDir = selectRankDir.value;
    updateUI();
  });

  btnUndo.onClick.listen((_) {
    state.undo();
    updateUI();
  });

  btnRedo.onClick.listen((_) {
    state.redo();
    updateUI();
  });

  btnClear.onClick.listen((_) {
    state.saveSnapshot();
    final newGraph = Graph<String, num>(
      isDirected: state.primaryGraph.isDirected,
    );
    state.primaryGraph = newGraph;
    state.clearSelection();
    state.activeOverlay = null;
    updateUI();
  });

  btnClearSelection.onClick.listen((_) {
    state.clearSelection();
    updateUI();
  });

  // Zoom listeners
  btnZoomIn.onClick.listen((_) => renderer.zoomIn());
  btnZoomOut.onClick.listen((_) => renderer.zoomOut());
  btnZoomFit.onClick.listen((_) => renderer.resetView());

  // Drawer toggle
  drawerHeader.onClick.listen((_) {
    final isCollapsed = bottomDrawer.classList.toggle('collapsed');
    drawerToggleIcon.textContent = isCollapsed ? '▲ Expand' : '▼ Collapse';
  });

  // Drawer tabs
  final tabs = web.document.querySelectorAll('.drawer-tab');
  for (var i = 0; i < tabs.length; i++) {
    final tab = tabs.item(i) as web.HTMLElement?;
    if (tab == null) continue;
    tab.onClick.listen((_) {
      for (var j = 0; j < tabs.length; j++) {
        (tabs.item(j) as web.HTMLElement?)?.classList.remove('active');
      }
      tab.classList.add('active');
      final targetId = tab.getAttribute('data-tab');
      final panes = web.document.querySelectorAll('.tab-pane');
      for (var k = 0; k < panes.length; k++) {
        final pane = panes.item(k) as web.HTMLElement?;
        if (pane == null) continue;
        pane.style.display = pane.id == targetId ? 'block' : 'none';
      }
    });
  }

  updateUI();
}
