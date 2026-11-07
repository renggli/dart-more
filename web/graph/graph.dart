import 'dart:async';
import 'dart:js_interop';

import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'algorithms_runner.dart';
import 'inspector.dart';
import 'io.dart';
import 'presets.dart';
import 'renderer.dart';
import 'state.dart';
import 'traversal_player.dart';

void main() async {
  final state = AppState();

  // Elements
  final canvasContainer =
      web.document.querySelector('#graph-canvas') as web.HTMLElement;
  final transformLayer = web.document.querySelector(
    '#viewport-transform-layer',
  ) as web.HTMLElement;
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
  final labelSelectionInfo =
      web.document.querySelector('#label-selection-info') as web.HTMLElement;
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
  final bottomDrawer =
      web.document.querySelector('#bottom-drawer') as web.HTMLElement;
  final notificationBanner =
      web.document.querySelector('#notification-banner') as web.HTMLElement;

  // Preset elements
  final selectPreset =
      web.document.querySelector('#select-preset') as web.HTMLSelectElement;
  final creatorParamsContainer = web.document.querySelector(
    '#creator-params-container',
  ) as web.HTMLElement;
  final btnGenerate =
      web.document.querySelector('#btn-generate') as web.HTMLButtonElement;

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

  // Playback elements
  final playbackBar =
      web.document.querySelector('#playback-bar') as web.HTMLElement;
  final btnPlayFirst =
      web.document.querySelector('#btn-play-first') as web.HTMLButtonElement;
  final btnPlayPrev =
      web.document.querySelector('#btn-play-prev') as web.HTMLButtonElement;
  final btnPlayPause =
      web.document.querySelector('#btn-play-pause') as web.HTMLButtonElement;
  final btnPlayNext =
      web.document.querySelector('#btn-play-next') as web.HTMLButtonElement;
  final btnPlayLast =
      web.document.querySelector('#btn-play-last') as web.HTMLButtonElement;
  final labelPlaybackStep =
      web.document.querySelector('#label-playback-step') as web.HTMLElement;
  final selectPlaybackSpeed = web.document.querySelector(
    '#select-playback-speed',
  ) as web.HTMLSelectElement;

  // Bottom drawer refresh buttons
  final btnRefreshMetrics = web.document.querySelector(
    '#btn-refresh-metrics',
  ) as web.HTMLButtonElement?;
  final btnRefreshMatrix = web.document.querySelector(
    '#btn-refresh-matrix',
  ) as web.HTMLButtonElement?;

  // Algorithm elements
  final selectAlgoCategory = web.document.querySelector(
    '#select-algorithm-category',
  ) as web.HTMLSelectElement;
  final selectAlgorithm =
      web.document.querySelector('#select-algorithm') as web.HTMLSelectElement;
  final algoParamsContainer =
      web.document.querySelector('#algorithm-params') as web.HTMLElement;
  final btnRunAlgo =
      web.document.querySelector('#btn-run-algo') as web.HTMLButtonElement;
  final btnClearOverlay =
      web.document.querySelector('#btn-clear-overlay') as web.HTMLButtonElement;
  final cardResults =
      web.document.querySelector('#card-results') as web.HTMLElement;
  final algorithmResults =
      web.document.querySelector('#algorithm-results') as web.HTMLElement;

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
  late final TraversalPlayer player;
  Timer? toastTimer;

  // Interactive edge drawing state
  String? edgeDrawingSource;

  // Toast notification
  void showToast(String message, {bool isWarning = false}) {
    toastTimer?.cancel();
    notificationBanner.textContent = message;
    notificationBanner.className =
        'notification-banner ${isWarning ? "warning" : "success"}';
    notificationBanner.style.display = 'block';
    toastTimer = Timer(const Duration(milliseconds: 2800), () {
      notificationBanner.style.display = 'none';
    });
  }

  // Restore from URL hash if available
  if (web.window.location.hash.isNotEmpty) {
    final restored = GraphIO.importFromUrlHash(web.window.location.hash);
    if (restored != null) {
      state.primaryGraph = restored.$1;
      state.isWeighted = restored.$2;
      state.nodes
        ..clear()
        ..addAll(restored.$3);
    }
  }

  void updateUI() {
    // Validate selection against active graph
    state.syncNodes();
    state.selectedVertices.removeWhere(
      (v) => !state.primaryGraph.containsVertex(v),
    );
    if (state.selectedSource != null &&
        !state.primaryGraph.containsVertex(state.selectedSource!)) {
      state.selectedSource = null;
    }
    if (state.selectedTarget != null &&
        !state.primaryGraph.containsVertex(state.selectedTarget!)) {
      state.selectedTarget = null;
    }
    if (state.selectedEdge != null) {
      final (u, v) = state.selectedEdge!;
      if (!state.primaryGraph.containsEdge(u, v) &&
          !(!state.primaryGraph.isDirected &&
              state.primaryGraph.containsEdge(v, u))) {
        state.selectedEdge = null;
      }
    }

    btnDirected.classList.toggle('active', state.primaryGraph.isDirected);
    btnDirected.textContent = state.primaryGraph.isDirected
        ? 'Directed'
        : 'Undirected';

    btnWeighted.classList.toggle('active', state.isWeighted);
    btnWeighted.textContent = state.isWeighted
        ? 'Show Weights'
        : 'Hide Weights';

    groupRankDir.style.display = state.layoutEngine == 'dot' ? 'flex' : 'none';

    btnUndo.disabled = !state.canUndo();
    btnRedo.disabled = !state.canRedo();

    // Selection text info
    if (edgeDrawingSource != null) {
      labelSelectionInfo.textContent =
          'Drawing edge from "$edgeDrawingSource" → Click target node';
    } else if (state.selectedEdge != null) {
      final (u, v) = state.selectedEdge!;
      final edge =
          state.primaryGraph.getEdge(u, v) ?? state.primaryGraph.getEdge(v, u);
      final arrow = state.primaryGraph.isDirected ? '→' : '—';
      labelSelectionInfo.textContent =
          'Edge: $u $arrow $v (Weight: ${edge?.value ?? 1})';
    } else if (state.selectedVertices.isNotEmpty) {
      final list = state.selectedVertices.toList();
      if (list.length == 1) {
        labelSelectionInfo.textContent = 'Selected: ${list.first}';
      } else if (list.length == 2) {
        labelSelectionInfo.textContent =
            'Source: ${list[0]} | Target: ${list[1]}';
      } else {
        labelSelectionInfo.textContent =
            'Selected (${list.length}): ${list.take(3).join(", ")}${list.length > 3 ? "..." : ""}';
      }
    } else {
      labelSelectionInfo.textContent = 'No selection';
    }

    codeDot.textContent = renderer.generateDot(state);
    codeDart.textContent = GraphIO.exportToDartCode(state);

    GraphInspector.updateInvariants(state);
    GraphInspector.updateInspector(
      state,
      onSelectVertex: (v) {
        state.selectedVertices = {v};
        state.selectedSource = v;
        updateUI();
      },
      onUpdateWeight: (u, v, newWeight) {
        state.saveSnapshot();
        state.primaryGraph.addEdge(u, v, value: newWeight);
        showToast('Updated weight of ($u, $v) to $newWeight');
        updateUI();
      },
      onRenameNode: (v, newLabel) {
        state.saveSnapshot();
        final node = state.getOrCreateNode(v);
        node.label = newLabel;
        showToast('Renamed node "$v" to "$newLabel"');
        updateUI();
      },
    );

    renderer.render(state);
  }

  // Active tool mode
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

  // Interactive Node Click handler
  void handleVertexClick(String vertex, web.MouseEvent event) {
    final mode = getCanvasMode();

    if (mode == 'delete') {
      state.saveSnapshot();
      state.primaryGraph.removeVertex(vertex);
      state.selectedVertices.remove(vertex);
      if (state.selectedSource == vertex) state.selectedSource = null;
      if (state.selectedTarget == vertex) state.selectedTarget = null;
      showToast('Deleted node "$vertex"');
      updateUI();
      return;
    }

    if (mode == 'add-edge') {
      if (edgeDrawingSource == null) {
        edgeDrawingSource = vertex;
        showToast('Selected "$vertex" as origin. Now click target node.');
        updateUI();
      } else if (edgeDrawingSource == vertex) {
        // Self-loop
        state.saveSnapshot();
        state.primaryGraph.addEdge(vertex, vertex, value: 1);
        showToast('Added self-loop on "$vertex"');
        edgeDrawingSource = null;
        updateUI();
      } else {
        final src = edgeDrawingSource!;
        state.saveSnapshot();
        state.primaryGraph.addEdge(src, vertex, value: 1);
        showToast('Connected edge $src → $vertex');
        edgeDrawingSource = null;
        updateUI();
      }
      return;
    }

    // Select mode (Illustrator style)
    edgeDrawingSource = null;
    state.selectedEdge = null;

    if (event.shiftKey) {
      // Toggle in multi-selection
      if (state.selectedVertices.contains(vertex)) {
        state.selectedVertices.remove(vertex);
      } else {
        state.selectedVertices.add(vertex);
      }
    } else {
      // Single selection
      state.selectedVertices = {vertex};
    }

    // Keep source and target in sync for algorithms
    final list = state.selectedVertices.toList();
    state.selectedSource = list.isNotEmpty ? list.first : null;
    state.selectedTarget = list.length > 1 ? list[1] : null;

    updateUI();
  }

  // Interactive Edge Click handler
  void handleEdgeClick(String source, String target, web.MouseEvent event) {
    final mode = getCanvasMode();
    edgeDrawingSource = null;

    if (mode == 'delete') {
      state.saveSnapshot();
      state.primaryGraph.removeEdge(source, target);
      if (state.selectedEdge == (source, target) ||
          state.selectedEdge == (target, source)) {
        state.selectedEdge = null;
      }
      showToast('Deleted edge ($source, $target)');
      updateUI();
      return;
    }

    // Select mode
    state.selectedVertices.clear();
    state.selectedSource = null;
    state.selectedTarget = null;
    state.selectedEdge = (source, target);
    updateUI();
  }

  // Interactive Canvas Surface Click handler
  void handleBackgroundClick(web.MouseEvent event) {
    final mode = getCanvasMode();

    if (mode == 'add-node') {
      state.saveSnapshot();
      final name = state.nextAvailableNodeId();
      state.primaryGraph.addVertex(name);
      final viewport =
          (canvasContainer.parentElement ?? canvasContainer) as web.HTMLElement;
      final rect = viewport.getBoundingClientRect();
      final canvasX =
          (event.clientX - rect.left - renderer.panX) / renderer.scale;
      final canvasY =
          (event.clientY - rect.top - renderer.panY) / renderer.scale;
      state.getOrCreateNode(name, label: name, x: canvasX, y: canvasY);
      state.selectedVertices = {name};
      state.selectedSource = name;
      showToast('Created node "$name"');
      updateUI();
      return;
    }

    if (mode == 'add-edge') {
      if (edgeDrawingSource != null) {
        edgeDrawingSource = null;
        showToast('Cancelled edge drawing.');
        updateUI();
      }
      return;
    }

    // Select mode: clear selection when clicking background
    state.selectedVertices.clear();
    state.selectedSource = null;
    state.selectedTarget = null;
    state.selectedEdge = null;
    edgeDrawingSource = null;
    updateUI();
  }

  // Initialize renderer
  renderer = GraphRenderer(
    container: canvasContainer,
    transformLayer: transformLayer,
    onVertexClick: handleVertexClick,
    onEdgeClick: handleEdgeClick,
    onBackgroundClick: handleBackgroundClick,
    onNodeMoved: (v, x, y) {
      final node = state.getOrCreateNode(v);
      node.x = x;
      node.y = y;
      renderer.render(state);
    },
  );

  await renderer.initialize();

  // Playback engine
  player = TraversalPlayer(
    onStepChanged: (step, total) {
      labelPlaybackStep.textContent = total > 0
          ? 'Step ${step + 1} / $total'
          : 'Step 0 / 0';
      final overlay = state.activeOverlay;
      if (overlay is PathOverlay) {
        state.activeOverlay = PathOverlay(
          title: overlay.title,
          vertices: overlay.vertices,
          edges: overlay.edges,
          stepNumbers: overlay.stepNumbers,
          activeStep: step,
          summary: overlay.summary,
        );
        renderer.render(state);
      }
    },
  );

  // Dynamic Creator Parameters Builder
  void updateCreatorParams() {
    creatorParamsContainer.textContent = '';
    final preset = selectPreset.value;

    switch (preset) {
      case 'preset_default':
      case 'preset_petersen':
      case 'preset_karate':
      case 'preset_road':
      case 'preset_negative':
      case 'preset_dag':
      case 'preset_bridges':
        final desc = switch (preset) {
          'preset_default' => '6 nodes, 9 edges. Standard weighted network.',
          'preset_petersen' =>
            '10 nodes, 15 edges. 3-regular, non-planar graph.',
          'preset_karate' => '34 nodes, 78 edges. Benchmark community graph.',
          'preset_road' => '8 cities with road travel distances in km.',
          'preset_negative' => 'Directed graph with negative edge weights.',
          'preset_dag' => '9 compiler task nodes. Directed acyclic graph.',
          'preset_bridges' =>
            'Graph demonstrating cut vertices and bridge edges.',
          _ => '',
        };
        creatorParamsContainer.appendChild(
          web.HTMLParagraphElement()
            ..style.fontSize = '1.1rem'
            ..style.color = 'var(--text-muted)'
            ..style.margin = '4px 0'
            ..textContent = desc,
        );

      case 'factory_complete':
      case 'factory_path':
      case 'factory_ring':
      case 'factory_star':
        final row = web.HTMLDivElement()..className = 'param-row';
        row.appendChild(web.HTMLLabelElement()..textContent = 'Node count:');
        row.appendChild(
          web.HTMLInputElement()
            ..id = 'param-vertex-count'
            ..type = 'number'
            ..value = preset == 'factory_complete' ? '5' : '6'
            ..min = '1'
            ..max = '40',
        );
        creatorParamsContainer.appendChild(row);

      case 'factory_tree':
        final rowNodes = web.HTMLDivElement()..className = 'param-row';
        rowNodes.appendChild(
          web.HTMLLabelElement()..textContent = 'Node count:',
        );
        rowNodes.appendChild(
          web.HTMLInputElement()
            ..id = 'param-tree-nodes'
            ..type = 'number'
            ..value = '10'
            ..min = '1'
            ..max = '50',
        );
        creatorParamsContainer.appendChild(rowNodes);

        final rowArity = web.HTMLDivElement()..className = 'param-row';
        rowArity.appendChild(
          web.HTMLLabelElement()..textContent = 'Branching (m):',
        );
        rowArity.appendChild(
          web.HTMLInputElement()
            ..id = 'param-tree-arity'
            ..type = 'number'
            ..value = '2'
            ..min = '1'
            ..max = '5',
        );
        creatorParamsContainer.appendChild(rowArity);

      case 'factory_partite':
        final row = web.HTMLDivElement()..className = 'param-row';
        row.appendChild(web.HTMLLabelElement()..textContent = 'Partitions:');
        row.appendChild(
          web.HTMLInputElement()
            ..id = 'param-partite-layers'
            ..type = 'text'
            ..value = '3, 3'
            ..placeholder = 'e.g. 3, 3 or 2, 3, 2',
        );
        creatorParamsContainer.appendChild(row);

      case 'factory_random':
        final rowNodes = web.HTMLDivElement()..className = 'param-row';
        rowNodes.appendChild(
          web.HTMLLabelElement()..textContent = 'Node count:',
        );
        rowNodes.appendChild(
          web.HTMLInputElement()
            ..id = 'param-random-nodes'
            ..type = 'number'
            ..value = '8'
            ..min = '1'
            ..max = '40',
        );
        creatorParamsContainer.appendChild(rowNodes);

        final rowProb = web.HTMLDivElement()..className = 'param-row';
        rowProb.appendChild(web.HTMLLabelElement()..textContent = 'Edge prob:');
        rowProb.appendChild(
          web.HTMLInputElement()
            ..id = 'param-random-prob'
            ..type = 'number'
            ..value = '0.35'
            ..step = '0.05'
            ..min = '0.0'
            ..max = '1.0',
        );
        creatorParamsContainer.appendChild(rowProb);

      case 'atlas_graph':
        final row = web.HTMLDivElement()..className = 'param-row';
        row.appendChild(web.HTMLLabelElement()..textContent = 'Atlas index:');
        final navDiv = web.HTMLDivElement()
          ..style.display = 'flex'
          ..style.gap = '4px'
          ..style.flex = '1';
        final btnPrev = web.HTMLButtonElement()
          ..className = 'button-outline button-small'
          ..textContent = '←';
        final inputNum = web.HTMLInputElement()
          ..id = 'param-atlas-num'
          ..type = 'number'
          ..value = '18'
          ..min = '0'
          ..max = '1252'
          ..style.textAlign = 'center'
          ..style.flex = '1';
        final btnNext = web.HTMLButtonElement()
          ..className = 'button-outline button-small'
          ..textContent = '→';

        btnPrev.onClick.listen((_) {
          final curr = int.tryParse(inputNum.value) ?? 0;
          inputNum.value = (curr - 1).clamp(0, 1252).toString();
          btnGenerate.click();
        });
        btnNext.onClick.listen((_) {
          final curr = int.tryParse(inputNum.value) ?? 0;
          inputNum.value = (curr + 1).clamp(0, 1252).toString();
          btnGenerate.click();
        });

        navDiv.appendChild(btnPrev);
        navDiv.appendChild(inputNum);
        navDiv.appendChild(btnNext);
        row.appendChild(navDiv);
        creatorParamsContainer.appendChild(row);
    }
  }

  selectPreset.onChange.listen((_) => updateCreatorParams());
  updateCreatorParams();

  // Unified Generate Button
  btnGenerate.onClick.listen((_) {
    state.saveSnapshot();
    state.clearSelection();
    state.activeOverlay = null;
    player.stop();
    playbackBar.style.display = 'none';
    cardResults.style.display = 'none';

    final preset = selectPreset.value;
    final isDir = state.primaryGraph.isDirected;

    switch (preset) {
      case 'preset_default':
        state.primaryGraph = GraphPresets.negativeEdges();
        state.isWeighted = true;
        showToast('Loaded Default Network (6 nodes)');
      case 'preset_petersen':
        state.primaryGraph = GraphPresets.petersen();
        state.isWeighted = false;
        showToast('Loaded Petersen Graph (10 nodes)');
      case 'preset_karate':
        state.primaryGraph = GraphPresets.karateClub();
        state.isWeighted = false;
        state.layoutEngine = 'neato';
        selectLayout.value = 'neato';
        showToast('Loaded Zachary\'s Karate Club (34 nodes)');
      case 'preset_road':
        state.primaryGraph = GraphPresets.roadNetwork();
        state.isWeighted = true;
        showToast('Loaded Swiss Road Network (8 cities)');
      case 'preset_negative':
        state.primaryGraph = GraphPresets.negativeEdges();
        state.isWeighted = true;
        showToast('Loaded Negative Edges Graph');
      case 'preset_dag':
        state.primaryGraph = GraphPresets.compilerDag();
        state.isWeighted = false;
        showToast('Loaded Compiler Task DAG (9 nodes)');
      case 'preset_bridges':
        state.primaryGraph = GraphPresets.bridgesAndCutVertices();
        state.isWeighted = false;
        showToast('Loaded Bridges & Cut Vertices Graph');
      case 'factory_complete':
        final n =
            int.tryParse(
              (web.document.querySelector(
                    '#param-vertex-count',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            5;
        state.primaryGraph = GraphPresets.complete(
          vertexCount: n,
          isDirected: isDir,
        );
        showToast('Generated Complete Graph K$n');
      case 'factory_path':
        final n =
            int.tryParse(
              (web.document.querySelector(
                    '#param-vertex-count',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            6;
        state.primaryGraph = GraphPresets.path(
          vertexCount: n,
          isDirected: isDir,
        );
        showToast('Generated Path Graph P$n');
      case 'factory_ring':
        final n =
            int.tryParse(
              (web.document.querySelector(
                    '#param-vertex-count',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            6;
        state.primaryGraph = GraphPresets.ring(
          vertexCount: n,
          isDirected: isDir,
        );
        showToast('Generated Ring Graph C$n');
      case 'factory_star':
        final n =
            int.tryParse(
              (web.document.querySelector(
                    '#param-vertex-count',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            6;
        state.primaryGraph = GraphPresets.star(
          vertexCount: n,
          isDirected: isDir,
        );
        showToast('Generated Star Graph S$n');
      case 'factory_tree':
        final nodes =
            int.tryParse(
              (web.document.querySelector(
                    '#param-tree-nodes',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            10;
        final arity =
            int.tryParse(
              (web.document.querySelector(
                    '#param-tree-arity',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            2;
        state.primaryGraph = GraphPresets.tree(
          vertexCount: nodes,
          isDirected: isDir,
          arity: arity,
        );
        showToast('Generated $arity-ary Tree ($nodes nodes)');
      case 'factory_partite':
        final raw =
            (web.document.querySelector(
              '#param-partite-layers',
            ) as web.HTMLInputElement?)?.value ??
            '3, 3';
        final layers = raw
            .split(',')
            .map((s) => int.tryParse(s.trim()) ?? 2)
            .toList();
        state.primaryGraph = GraphPresets.partite(
          vertexCounts: layers,
          isDirected: isDir,
        );
        showToast('Generated Partite Graph [${layers.join(", ")}]');
      case 'factory_random':
        final n =
            int.tryParse(
              (web.document.querySelector(
                    '#param-random-nodes',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            8;
        final p =
            double.tryParse(
              (web.document.querySelector(
                    '#param-random-prob',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            0.35;
        state.primaryGraph = GraphPresets.randomErdosRenyi(
          vertexCount: n,
          probability: p,
          isDirected: isDir,
        );
        showToast('Generated Erdős–Rényi Graph G($n, $p)');
      case 'atlas_graph':
        final num =
            int.tryParse(
              (web.document.querySelector(
                    '#param-atlas-num',
                  ) as web.HTMLInputElement?)?.value ??
                  '',
            ) ??
            18;
        state.primaryGraph = GraphPresets.atlas(num);
        state.isWeighted = false;
        showToast('Loaded Read-Wilson Atlas Graph #$num');
    }

    updateUI();
  });

  // Non-destructive directedness toggle
  btnDirected.onClick.listen((_) {
    final willBeDirected = !state.primaryGraph.isDirected;
    state.saveSnapshot();

    final newGraph = Graph<String, num>(isDirected: willBeDirected);
    for (final v in state.primaryGraph.vertices) {
      newGraph.addVertex(v);
    }

    if (willBeDirected) {
      // Convert undirected to directed: make bidirectional edges
      for (final e in state.primaryGraph.edges) {
        newGraph.addEdge(e.source, e.target, value: e.value);
        newGraph.addEdge(e.target, e.source, value: e.value);
      }
      showToast('Converted to Directed mode (bidirectional edges preserved)');
    } else {
      // Convert directed to undirected: merge opposing edges
      for (final e in state.primaryGraph.edges) {
        newGraph.addEdge(e.source, e.target, value: e.value);
      }
      showToast('Converted to Undirected mode (merged edges)');
    }

    state.primaryGraph = newGraph;
    state.clearSelection();
    updateUI();
  });

  // Weighted display toggle (non-destructive)
  btnWeighted.onClick.listen((_) {
    state.isWeighted = !state.isWeighted;
    showToast(
      state.isWeighted ? 'Edge weights displayed' : 'Edge weights hidden',
    );
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
    showToast('Undo action');
    updateUI();
  });

  btnRedo.onClick.listen((_) {
    state.redo();
    showToast('Redo action');
    updateUI();
  });

  btnClear.onClick.listen((_) {
    state.saveSnapshot();
    state.primaryGraph = Graph<String, num>(
      isDirected: state.primaryGraph.isDirected,
    );
    state.clearSelection();
    state.activeOverlay = null;
    player.stop();
    playbackBar.style.display = 'none';
    cardResults.style.display = 'none';
    showToast('Cleared canvas');
    updateUI();
  });

  btnClearSelection.onClick.listen((_) {
    state.clearSelection();
    edgeDrawingSource = null;
    updateUI();
  });

  // Zoom listeners
  btnZoomIn.onClick.listen((_) => renderer.zoomIn());
  btnZoomOut.onClick.listen((_) => renderer.zoomOut());
  btnZoomFit.onClick.listen((_) => renderer.resetView());

  // Quick edit: Add vertex
  btnAddVertex.onClick.listen((_) {
    var name = inputNewVertex.value.trim();
    if (name.isEmpty) {
      name = state.nextAvailableNodeId();
    }
    if (state.primaryGraph.containsVertex(name)) {
      showToast('Vertex "$name" already exists', isWarning: true);
      return;
    }
    state.saveSnapshot();
    state.primaryGraph.addVertex(name);
    state.getOrCreateNode(name, label: name);
    state.selectedVertices = {name};
    state.selectedSource = name;
    inputNewVertex.value = '';
    showToast('Added node "$name"');
    updateUI();
  });

  // Quick edit: Add edge
  btnAddEdge.onClick.listen((_) {
    final u = inputEdgeU.value.trim();
    final v = inputEdgeV.value.trim();
    final w = num.tryParse(inputEdgeWeight.value.trim()) ?? 1;
    if (u.isNotEmpty && v.isNotEmpty) {
      state.saveSnapshot();
      state.primaryGraph.addEdge(u, v, value: w);
      showToast('Connected edge $u → $v (weight $w)');
      updateUI();
    }
  });

  // Delete selected nodes or edges
  btnRemoveSelected.onClick.listen((_) {
    state.saveSnapshot();
    var changed = false;
    if (state.selectedEdge != null) {
      state.primaryGraph.removeEdge(
        state.selectedEdge!.$1,
        state.selectedEdge!.$2,
      );
      showToast(
        'Deleted edge (${state.selectedEdge!.$1}, ${state.selectedEdge!.$2})',
      );
      state.selectedEdge = null;
      changed = true;
    }
    if (state.selectedVertices.isNotEmpty) {
      final count = state.selectedVertices.length;
      for (final v in state.selectedVertices.toList()) {
        state.primaryGraph.removeVertex(v);
      }
      state.selectedVertices.clear();
      state.selectedSource = null;
      state.selectedTarget = null;
      showToast('Deleted $count node(s)');
      changed = true;
    }
    if (changed) {
      updateUI();
    }
  });

  // Keyboard shortcut for deleting (Backspace / Delete)
  web.window.onkeydown = ((web.KeyboardEvent event) {
    final target = event.target;
    if (target != null &&
        (target.isA<web.HTMLInputElement>() ||
            target.isA<web.HTMLTextAreaElement>())) {
      return;
    }
    if (event.key == 'Backspace' || event.key == 'Delete') {
      btnRemoveSelected.click();
    } else if ((event.ctrlKey || event.metaKey) && event.key == 'z') {
      if (event.shiftKey) {
        btnRedo.click();
      } else {
        btnUndo.click();
      }
    }
  }).toJS;

  // Transformations with explicit feedback
  btnReverse.onClick.listen((_) {
    if (!state.primaryGraph.isDirected) {
      showToast('Cannot reverse: Graph is undirected', isWarning: true);
      return;
    }
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.reversed.copy();
    showToast('Reversed all directed edges');
    updateUI();
  });

  btnComplement.onClick.listen((_) {
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.complement(edge: (u, v) => 1);
    showToast('Inverted graph connectivity (complement)');
    updateUI();
  });

  btnTransClosure.onClick.listen((_) {
    if (!state.primaryGraph.isDirected) {
      showToast(
        'Transitive closure requires a directed graph',
        isWarning: true,
      );
      return;
    }
    state.saveSnapshot();
    state.primaryGraph = state.primaryGraph.transitiveClosure().map(
      edge: (_) => 1,
    );
    showToast('Computed transitive closure (added direct edges)');
    updateUI();
  });

  btnTransReduction.onClick.listen((_) {
    if (!state.primaryGraph.isDirected) {
      showToast(
        'Transitive reduction requires a directed DAG',
        isWarning: true,
      );
      return;
    }
    try {
      state.saveSnapshot();
      state.primaryGraph = state.primaryGraph.transitiveReduction();
      showToast('Computed transitive reduction (removed redundant edges)');
      updateUI();
    } catch (_) {
      showToast(
        'Cannot reduce: Graph contains a cycle (must be a DAG)',
        isWarning: true,
      );
    }
  });

  btnKCore.onClick.listen((_) {
    if (state.primaryGraph.isDirected) {
      showToast(
        'k-Core is defined for undirected graphs. Switch to Undirected first.',
        isWarning: true,
      );
      return;
    }
    final k = int.tryParse(inputKCoreK.value.trim()) ?? 2;
    state.saveSnapshot();
    final before = state.primaryGraph.vertices.length;
    state.primaryGraph = state.primaryGraph.kCore(k);
    final after = state.primaryGraph.vertices.length;
    showToast(
      'Extracted $k-Core ($after nodes remaining, removed ${before - after})',
    );
    updateUI();
  });

  // Playback listeners
  btnPlayFirst.onClick.listen((_) => player.first());
  btnPlayPrev.onClick.listen((_) => player.prev());
  btnPlayPause.onClick.listen((_) {
    if (player.isPlaying) {
      player.pause();
      btnPlayPause.textContent = 'Play';
    } else {
      player.play();
      btnPlayPause.textContent = 'Pause';
    }
  });
  btnPlayNext.onClick.listen((_) => player.next());
  btnPlayLast.onClick.listen((_) => player.last());
  selectPlaybackSpeed.onChange.listen((_) {
    player.speedMs = int.tryParse(selectPlaybackSpeed.value) ?? 500;
  });

  // Drawer helpers
  void switchDrawerTab(String tabId) {
    bottomDrawer.classList.remove('collapsed');
    final tabs = web.document.querySelectorAll('.drawer-tab');
    for (var j = 0; j < tabs.length; j++) {
      final t = tabs.item(j) as web.HTMLElement?;
      t?.classList.toggle('active', t.getAttribute('data-tab') == tabId);
    }
    final panes = web.document.querySelectorAll('.tab-pane');
    for (var k = 0; k < panes.length; k++) {
      final pane = panes.item(k) as web.HTMLElement?;
      if (pane != null) {
        pane.style.display = pane.id == tabId ? 'block' : 'none';
      }
    }
  }

  void renderDistanceMatrix(FloydWarshall<String> fw) {
    final matrixContainer =
        web.document.querySelector('#matrix-container') as web.HTMLElement?;
    if (matrixContainer == null) return;
    matrixContainer.textContent = '';

    final table = web.HTMLTableElement()..className = 'data-table';
    final thead = table.createTHead();
    final headerRow = thead.insertRow();
    headerRow.insertCell().textContent = 'From \\ To';

    final vertices = state.primaryGraph.vertices.toList();
    for (final v in vertices) {
      headerRow.insertCell().textContent = v;
    }

    final tbody = table.createTBody();
    for (final u in vertices) {
      final row = tbody.insertRow();
      final rowHead = row.insertCell()..textContent = u;
      rowHead.style.fontWeight = 'bold';
      for (final v in vertices) {
        final cell = row.insertCell();
        final dist = fw.distance(u, v);
        cell.textContent = dist.isInfinite ? '∞' : dist.toString();
        if (!dist.isInfinite) {
          cell.style.cursor = 'pointer';
          cell.title = 'Click to show shortest path from $u to $v';
          cell.onClick.listen((_) {
            final path = fw.path(u, v);
            if (path != null) {
              final pathEdges = <(String, String)>[];
              for (var i = 0; i < path.vertices.length - 1; i++) {
                pathEdges.add((path.vertices[i], path.vertices[i + 1]));
              }
              state.activeOverlay = PathOverlay(
                title: 'Path: $u to $v (Cost ${path.cost})',
                vertices: path.vertices,
                edges: pathEdges,
              );
              updateUI();
            }
          });
        }
      }
    }

    matrixContainer.appendChild(table);
  }

  void renderMetricsTable(Map<String, Map<String, num>> metrics) {
    final metricsContainer = web.document.querySelector(
      '#metrics-table-container',
    ) as web.HTMLElement?;
    if (metricsContainer == null) return;
    metricsContainer.textContent = '';

    final table = web.HTMLTableElement()..className = 'data-table';
    final thead = table.createTHead();
    final headerRow = thead.insertRow();
    headerRow.insertCell().textContent = 'Vertex';

    final firstEntry = metrics.values.firstOrNull;
    if (firstEntry == null) return;
    final metricNames = firstEntry.keys.toList();

    for (final m in metricNames) {
      final cell = headerRow.insertCell();
      cell.textContent = m;
      cell.style.cursor = 'pointer';
      cell.title = 'Click to color graph heatmap by $m';
      cell.onClick.listen((_) {
        final scores = <String, num>{};
        for (final MapEntry(:key, :value) in metrics.entries) {
          scores[key] = value[m] ?? 0;
        }
        state.activeOverlay = HeatmapOverlay(title: m, scores: scores);
        updateUI();
      });
    }

    final tbody = table.createTBody();
    for (final MapEntry(:key, :value) in metrics.entries) {
      final row = tbody.insertRow();
      final headCell = row.insertCell()..textContent = key;
      headCell.style.fontWeight = 'bold';
      for (final m in metricNames) {
        final val = value[m] ?? 0;
        final cell = row.insertCell();
        cell.textContent = (val is int || val == val.roundToDouble())
            ? val.toInt().toString()
            : val.toStringAsFixed(3);
      }
    }

    metricsContainer.appendChild(table);
  }

  void computeAndRenderMetrics() {
    final result = AlgorithmsRunner.run('all_centralities', state);
    if (result.metricsTable != null) {
      renderMetricsTable(result.metricsTable!);
    }
  }

  void computeAndRenderMatrix() {
    final result = AlgorithmsRunner.run('floyd_warshall', state);
    if (result.distanceMatrix != null) {
      renderDistanceMatrix(result.distanceMatrix!);
    }
  }

  btnRefreshMetrics?.onClick.listen((_) => computeAndRenderMetrics());
  btnRefreshMatrix?.onClick.listen((_) => computeAndRenderMatrix());

  // Algorithms & Traversals setup
  void updateAlgorithmOptions() {
    selectAlgorithm.textContent = '';
    algoParamsContainer.textContent = '';

    final cat = selectAlgoCategory.value;
    final algos = AlgorithmsRunner.getAlgorithmsForCategory(cat);
    for (final (id, label) in algos) {
      selectAlgorithm.appendChild(
        web.HTMLOptionElement()
          ..value = id
          ..text = label,
      );
    }
    if (algos.isNotEmpty) {
      AlgorithmsRunner.renderParams(algos.first.$1, state, algoParamsContainer);
    }
  }

  selectAlgoCategory.onChange.listen((_) => updateAlgorithmOptions());
  selectAlgorithm.onChange.listen((_) {
    AlgorithmsRunner.renderParams(
      selectAlgorithm.value,
      state,
      algoParamsContainer,
    );
  });
  updateAlgorithmOptions();

  // Run Traversal / Algorithm
  btnRunAlgo.onClick.listen((_) {
    final algo = selectAlgorithm.value;
    final result = AlgorithmsRunner.run(algo, state);

    state.activeOverlay = result.overlay;

    if (result.isPathSequence) {
      playbackBar.style.display = 'flex';
      player.load(vertices: result.pathVertices, edges: result.pathEdges);
      player.play();
      btnPlayPause.textContent = 'Pause';
    } else {
      player.stop();
      playbackBar.style.display = 'none';
    }

    cardResults.style.display = 'block';
    final resP = web.HTMLParagraphElement()
      ..innerHTML = result.summaryHtml.toJS;
    algorithmResults.replaceChildren(resP);

    if (result.distanceMatrix != null) {
      renderDistanceMatrix(result.distanceMatrix!);
      switchDrawerTab('tab-matrix');
    }

    if (result.metricsTable != null) {
      renderMetricsTable(result.metricsTable!);
      switchDrawerTab('tab-metrics');
    }

    updateUI();
  });

  btnClearOverlay.onClick.listen((_) {
    player.stop();
    playbackBar.style.display = 'none';
    cardResults.style.display = 'none';
    state.activeOverlay = null;
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
        final (g, weighted, nodes) = GraphIO.importFromJson(text);
        state.primaryGraph = g;
        state.isWeighted = weighted;
        state.nodes
          ..clear()
          ..addAll(nodes);
      } else {
        final g = GraphIO.importFromDsl(
          text,
          isDirected: state.primaryGraph.isDirected,
        );
        state.primaryGraph = g;
      }
      ioStatus.textContent = 'Import successful!';
      showToast('Imported graph successfully');
      updateUI();
    } catch (e) {
      ioStatus.textContent = 'Import error: $e';
      showToast('Import error: $e', isWarning: true);
    }
  });

  btnExportCopy.onClick.listen((_) {
    web.window.navigator.clipboard.writeText(textareaIo.value);
    ioStatus.textContent = 'Copied to clipboard!';
    showToast('Copied text to clipboard');
  });

  btnExportShare.onClick.listen((_) {
    final hash = GraphIO.exportToUrlHash(state);
    final fullUrl =
        '${web.window.location.origin}${web.window.location.pathname}#$hash';
    web.window.navigator.clipboard.writeText(fullUrl);
    ioStatus.textContent = 'Shareable URL copied to clipboard!';
    showToast('Copied shareable link');
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

  // Drawer tabs: clicking active tab toggles collapsed; clicking inactive tab opens and switches to it
  final tabs = web.document.querySelectorAll('.drawer-tab');
  for (var i = 0; i < tabs.length; i++) {
    final tab = tabs.item(i) as web.HTMLElement?;
    if (tab == null) continue;
    tab.onClick.listen((_) {
      final wasActive = tab.classList.contains('active');

      if (wasActive) {
        bottomDrawer.classList.toggle('collapsed');
      } else {
        bottomDrawer.classList.remove('collapsed');
        for (var j = 0; j < tabs.length; j++) {
          (tabs.item(j) as web.HTMLElement?)?.classList.remove('active');
        }
        tab.classList.add('active');
        final targetId = tab.getAttribute('data-tab');
        final panes = web.document.querySelectorAll('.tab-pane');
        for (var k = 0; k < panes.length; k++) {
          final pane = panes.item(k) as web.HTMLElement?;
          if (pane != null) {
            pane.style.display = pane.id == targetId ? 'block' : 'none';
          }
        }

        // Auto-compute when opening metrics or matrix tabs
        if (targetId == 'tab-metrics') {
          computeAndRenderMetrics();
        } else if (targetId == 'tab-matrix') {
          computeAndRenderMatrix();
        }
      }
    });
  }

  updateUI();
}
