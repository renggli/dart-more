import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'io.dart';
import 'presets.dart';
import 'renderer.dart';
import 'state.dart';

void main() async {
  final state = AppState();

  // Restore from URL hash if available
  if (web.window.location.hash.isNotEmpty) {
    final restored = GraphIO.importFromUrlHash(web.window.location.hash);
    if (restored != null) {
      state.primaryGraph = restored.$1;
      state.isWeighted = restored.$2;
    }
  }

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
  final codeDart =
      web.document.querySelector('#code-dart') as web.HTMLPreElement;
  final drawerHeader =
      web.document.querySelector('#drawer-header') as web.HTMLElement;
  final bottomDrawer =
      web.document.querySelector('#bottom-drawer') as web.HTMLElement;
  final drawerToggleIcon =
      web.document.querySelector('#drawer-toggle-icon') as web.HTMLElement;

  // Preset & Atlas elements
  final selectPreset =
      web.document.querySelector('#select-preset') as web.HTMLSelectElement;
  final inputVertexCount =
      web.document.querySelector('#input-vertex-count') as web.HTMLInputElement;
  final btnGenerate =
      web.document.querySelector('#btn-generate') as web.HTMLButtonElement;
  final inputAtlasNum =
      web.document.querySelector('#input-atlas-num') as web.HTMLInputElement;
  final btnAtlasPrev =
      web.document.querySelector('#btn-atlas-prev') as web.HTMLButtonElement;
  final btnAtlasNext =
      web.document.querySelector('#btn-atlas-next') as web.HTMLButtonElement;
  final btnAtlasLoad =
      web.document.querySelector('#btn-atlas-load') as web.HTMLButtonElement;

  // Quick edit elements
  final inputNewVertex =
      web.document.querySelector('#input-new-vertex') as web.HTMLInputElement;
  final btnAddVertex =
      web.document.querySelector('#btn-add-vertex') as web.HTMLButtonElement;
  final inputEdgeU =
      web.document.querySelector('#input-edge-u') as web.HTMLInputElement;
  final inputEdgeV =
      web.document.querySelector('#input-edge-v') as web.HTMLInputElement;
  final inputEdgeWeight =
      web.document.querySelector('#input-edge-weight') as web.HTMLInputElement;
  final btnAddEdge =
      web.document.querySelector('#btn-add-edge') as web.HTMLButtonElement;
  final btnRemoveSelected = web.document.querySelector(
    '#btn-remove-selected',
  ) as web.HTMLButtonElement;

  // Transformations
  final btnReverse =
      web.document.querySelector('#btn-reverse') as web.HTMLButtonElement;
  final btnComplement =
      web.document.querySelector('#btn-complement') as web.HTMLButtonElement;
  final btnTransClosure =
      web.document.querySelector('#btn-trans-closure') as web.HTMLButtonElement;
  final btnTransReduction = web.document.querySelector(
    '#btn-trans-reduction',
  ) as web.HTMLButtonElement;
  final btnKCore =
      web.document.querySelector('#btn-kcore') as web.HTMLButtonElement;
  final inputKCoreK =
      web.document.querySelector('#input-kcore-k') as web.HTMLInputElement;

  // Import / Export modal elements
  final btnIoModal =
      web.document.querySelector('#btn-io-modal') as web.HTMLButtonElement;
  final modalIo = web.document.querySelector('#modal-io') as web.HTMLElement;
  final btnCloseModal =
      web.document.querySelector('#btn-close-modal') as web.HTMLButtonElement;
  final selectIoFormat =
      web.document.querySelector('#select-io-format') as web.HTMLSelectElement;
  final textareaIo =
      web.document.querySelector('#textarea-io') as web.HTMLTextAreaElement;
  final btnIoImport =
      web.document.querySelector('#btn-io-import') as web.HTMLButtonElement;
  final btnExportCopy =
      web.document.querySelector('#btn-export-copy') as web.HTMLButtonElement;
  final btnExportShare =
      web.document.querySelector('#btn-export-share') as web.HTMLButtonElement;
  final btnDownloadJson =
      web.document.querySelector('#btn-download-json') as web.HTMLButtonElement;
  final btnDownloadDot =
      web.document.querySelector('#btn-download-dot') as web.HTMLButtonElement;
  final btnDownloadSvg =
      web.document.querySelector('#btn-download-svg') as web.HTMLButtonElement;
  final btnDownloadPng =
      web.document.querySelector('#btn-download-png') as web.HTMLButtonElement;
  final ioStatus = web.document.querySelector('#io-status') as web.HTMLElement;

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
    codeDart.textContent = GraphIO.exportToDartCode(state);

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

  // Quick edit listeners
  btnAddVertex.onClick.listen((_) {
    final name = inputNewVertex.value.trim();
    if (name.isNotEmpty) {
      state.saveSnapshot();
      state.primaryGraph.addVertex(name);
      inputNewVertex.value = '';
      updateUI();
    }
  });

  btnAddEdge.onClick.listen((_) {
    final u = inputEdgeU.value.trim();
    final v = inputEdgeV.value.trim();
    final w = num.tryParse(inputEdgeWeight.value.trim()) ?? 1;
    if (u.isNotEmpty && v.isNotEmpty) {
      state.saveSnapshot();
      state.primaryGraph.addEdge(u, v, value: w);
      updateUI();
    }
  });

  btnRemoveSelected.onClick.listen((_) {
    state.saveSnapshot();
    var changed = false;
    if (state.selectedEdge != null) {
      state.primaryGraph.removeEdge(
        state.selectedEdge!.$1,
        state.selectedEdge!.$2,
      );
      state.selectedEdge = null;
      changed = true;
    }
    if (state.selectedSource != null) {
      state.primaryGraph.removeVertex(state.selectedSource!);
      state.selectedSource = null;
      changed = true;
    }
    if (state.selectedTarget != null) {
      state.primaryGraph.removeVertex(state.selectedTarget!);
      state.selectedTarget = null;
      changed = true;
    }
    if (changed) {
      updateUI();
    }
  });

  // Preset loader
  void loadPreset(String key) {
    state.saveSnapshot();
    state.clearSelection();
    state.activeOverlay = null;

    final n = int.tryParse(inputVertexCount.value.trim()) ?? 6;
    final isDir = state.primaryGraph.isDirected;

    switch (key) {
      case 'preset_default':
        state.primaryGraph = GraphPresets.negativeEdges();
        state.isWeighted = true;
      case 'preset_petersen':
        state.primaryGraph = GraphPresets.petersen();
        state.isWeighted = false;
      case 'preset_karate':
        state.primaryGraph = GraphPresets.karateClub();
        state.isWeighted = false;
        state.layoutEngine = 'neato';
        selectLayout.value = 'neato';
      case 'preset_road':
        state.primaryGraph = GraphPresets.roadNetwork();
        state.isWeighted = true;
      case 'preset_negative':
        state.primaryGraph = GraphPresets.negativeEdges();
        state.isWeighted = true;
      case 'preset_dag':
        state.primaryGraph = GraphPresets.compilerDag();
        state.isWeighted = false;
      case 'preset_bridges':
        state.primaryGraph = GraphPresets.bridgesAndCutVertices();
        state.isWeighted = false;
      case 'factory_complete':
        state.primaryGraph = GraphPresets.complete(
          vertexCount: n,
          isDirected: isDir,
        );
      case 'factory_path':
        state.primaryGraph = GraphPresets.path(
          vertexCount: n,
          isDirected: isDir,
        );
      case 'factory_ring':
        state.primaryGraph = GraphPresets.ring(
          vertexCount: n,
          isDirected: isDir,
        );
      case 'factory_star':
        state.primaryGraph = GraphPresets.star(
          vertexCount: n,
          isDirected: isDir,
        );
      case 'factory_tree':
        state.primaryGraph = GraphPresets.tree(
          vertexCount: n,
          isDirected: isDir,
        );
      case 'factory_partite':
        state.primaryGraph = GraphPresets.partite(
          vertexCounts: [3, 3],
          isDirected: isDir,
        );
      case 'factory_random':
        state.primaryGraph = GraphPresets.randomErdosRenyi(
          vertexCount: n,
          probability: 0.35,
          isDirected: isDir,
        );
    }
    updateUI();
  }

  selectPreset.onChange.listen((_) => loadPreset(selectPreset.value));
  btnGenerate.onClick.listen((_) => loadPreset(selectPreset.value));

  // Atlas loader
  void loadAtlasNumber(int num) {
    state.saveSnapshot();
    state.clearSelection();
    state.activeOverlay = null;
    state.primaryGraph = GraphPresets.atlas(num);
    state.isWeighted = false;
    inputAtlasNum.value = num.toString();
    updateUI();
  }

  btnAtlasLoad.onClick.listen((_) {
    final num = int.tryParse(inputAtlasNum.value.trim()) ?? 0;
    loadAtlasNumber(num);
  });

  btnAtlasPrev.onClick.listen((_) {
    final curr = int.tryParse(inputAtlasNum.value.trim()) ?? 0;
    loadAtlasNumber((curr - 1).clamp(0, 1252));
  });

  btnAtlasNext.onClick.listen((_) {
    final curr = int.tryParse(inputAtlasNum.value.trim()) ?? 0;
    loadAtlasNumber((curr + 1).clamp(0, 1252));
  });

  // Transformations
  btnReverse.onClick.listen((_) {
    if (!state.primaryGraph.isDirected) return;
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.reversed.copy();
    updateUI();
  });

  btnComplement.onClick.listen((_) {
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.complement();
    updateUI();
  });

  btnTransClosure.onClick.listen((_) {
    if (!state.primaryGraph.isDirected) return;
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.transitiveClosure().map(
      edge: (_) => 1,
    );
    updateUI();
  });

  btnTransReduction.onClick.listen((_) {
    if (!state.primaryGraph.isDirected) return;
    try {
      state.saveSnapshot();
      state.primaryGraph = state.primaryGraph.transitiveReduction();
      updateUI();
    } catch (_) {
      // e.g. Graph contains cycle
    }
  });

  btnKCore.onClick.listen((_) {
    if (state.primaryGraph.isDirected) return;
    final k = int.tryParse(inputKCoreK.value.trim()) ?? 2;
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.kCore(k);
    updateUI();
  });

  // Import / Export modal logic
  void syncModalContent() {
    ioStatus.textContent = '';
    switch (selectIoFormat.value) {
      case 'json':
        textareaIo.value = GraphIO.exportToJson(state);
      case 'dsl':
        final buffer = StringBuffer();
        final arrow = state.primaryGraph.isDirected ? '->' : '--';
        for (final e in state.primaryGraph.edges) {
          buffer.writeln('${e.source} $arrow ${e.target} : ${e.value}');
        }
        for (final v in state.primaryGraph.vertices) {
          if (state.primaryGraph.degreeOf(v) == 0) {
            buffer.writeln(v);
          }
        }
        textareaIo.value = buffer.toString();
      case 'dot':
        textareaIo.value = renderer.generateDot(state);
      case 'dart':
        textareaIo.value = GraphIO.exportToDartCode(state);
    }
  }

  btnIoModal.onClick.listen((_) {
    syncModalContent();
    modalIo.style.display = 'flex';
  });

  btnCloseModal.onClick.listen((_) {
    modalIo.style.display = 'none';
  });

  selectIoFormat.onChange.listen((_) => syncModalContent());

  btnIoImport.onClick.listen((_) {
    try {
      final text = textareaIo.value.trim();
      if (text.isEmpty) return;
      state.saveSnapshot();
      if (selectIoFormat.value == 'json') {
        final (g, weighted) = GraphIO.importFromJson(text);
        state.primaryGraph = g;
        state.isWeighted = weighted;
      } else {
        // DSL or other
        final g = GraphIO.importFromDsl(
          text,
          isDirected: state.primaryGraph.isDirected,
        );
        state.primaryGraph = g;
      }
      ioStatus.textContent = 'Import successful!';
      updateUI();
    } catch (e) {
      ioStatus.textContent = 'Import error: $e';
    }
  });

  btnExportCopy.onClick.listen((_) {
    web.window.navigator.clipboard.writeText(textareaIo.value);
    ioStatus.textContent = 'Copied to clipboard!';
  });

  btnExportShare.onClick.listen((_) {
    final hash = GraphIO.exportToUrlHash(state);
    final fullUrl =
        '${web.window.location.origin}${web.window.location.pathname}#$hash';
    web.window.navigator.clipboard.writeText(fullUrl);
    ioStatus.textContent = 'Shareable URL copied to clipboard!';
  });

  btnDownloadJson.onClick.listen((_) {
    GraphIO.downloadTextFile(
      'graph.json',
      GraphIO.exportToJson(state),
      'application/json',
    );
  });

  btnDownloadDot.onClick.listen((_) {
    GraphIO.downloadTextFile(
      'graph.dot',
      renderer.generateDot(state),
      'text/vnd.graphviz',
    );
  });

  btnDownloadSvg.onClick.listen((_) {
    final svg = renderer.currentSvg;
    if (svg != null) {
      GraphIO.downloadSvgFile('graph.svg', svg);
    }
  });

  btnDownloadPng.onClick.listen((_) {
    final svg = renderer.currentSvg;
    if (svg != null) {
      GraphIO.downloadPngFile('graph.png', svg);
    }
  });

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
