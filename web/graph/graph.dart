import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'commands.dart';
import 'dom_utils.dart';
import 'inspector.dart';
import 'io.dart';
import 'modifiers.dart';
import 'renderer.dart';
import 'state.dart';

void main() async {
  final state = AppState();

  // Elements
  final canvasContainer =
      web.document.querySelector('#graph-canvas') as web.HTMLElement;
  final transformLayer = web.document.querySelector(
    '#viewport-transform-layer',
  ) as web.HTMLElement;
  final btnUndo =
      web.document.querySelector('#btn-undo') as web.HTMLButtonElement;
  final btnRedo =
      web.document.querySelector('#btn-redo') as web.HTMLButtonElement;
  final btnZoomIn =
      web.document.querySelector('#btn-zoom-in') as web.HTMLButtonElement;
  final btnZoomOut =
      web.document.querySelector('#btn-zoom-out') as web.HTMLButtonElement;
  final btnZoomFit =
      web.document.querySelector('#btn-zoom-fit') as web.HTMLButtonElement;
  final codeDot = web.document.querySelector('#code-dot') as web.HTMLPreElement;
  final codeDart =
      web.document.querySelector('#code-dart') as web.HTMLPreElement;

  // Blender-style selection mode buttons and display toggles
  final btnModeVertex =
      web.document.querySelector('#btn-mode-vertex') as web.HTMLButtonElement;
  final btnModeEdge =
      web.document.querySelector('#btn-mode-edge') as web.HTMLButtonElement;
  final btnToggleLabels = web.document.querySelector(
    '#btn-toggle-labels',
  ) as web.HTMLButtonElement?;
  final btnToggleWeights = web.document.querySelector(
    '#btn-toggle-weights',
  ) as web.HTMLButtonElement?;

  // Modifier Stack elements
  final selectAddModifier = web.document.querySelector(
    '#select-add-modifier',
  ) as web.HTMLSelectElement;
  final modifiersStackList =
      web.document.querySelector('#modifiers-stack-list') as web.HTMLElement;

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

  // Toast notification (banner removed per design request)
  void showToast(String message, {bool isWarning = false}) {}

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

  late void Function() updateUI;

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

  void handleVertexDblClick(String vertex) {
    renderer.showInlineNodeEditor(
      state,
      vertex,
      onCommit: (newLabel) {
        state.saveSnapshot();
        state.getOrCreateNode(vertex).label = newLabel;
        showToast('Renamed vertex "$vertex" to "$newLabel"');
        updateUI();
      },
    );
  }

  void renderModifierStack() {
    modifiersStackList.textContent = '';
    if (state.modifiers.isEmpty) {
      final emptyMsg = div()..style.color = 'var(--text-muted)';
      emptyMsg.textContent = 'No modifiers active. Add a modifier above to run live analysis or transformations.';
      modifiersStackList.appendChild(emptyMsg);
      return;
    }

    for (var i = 0; i < state.modifiers.length; i++) {
      final idx = i;
      final mod = state.modifiers[idx];
      final card = div('modifier-card');
      if (!mod.enabled) card.classList.add('disabled');

      final output = state.lastModifierOutputs[mod.id];
      final hasError = output?.hasError ?? false;
      if (hasError) {
        card.classList.add('error');
      }

      // Header
      final header = div('modifier-header');
      final headerLeft = div('modifier-header-left');

      if (!mod.isPinned) {
        final toggleCheckbox =
            web.document.createElement('input') as web.HTMLInputElement;
        toggleCheckbox.type = 'checkbox';
        toggleCheckbox.checked = mod.enabled;
        toggleCheckbox.title = 'Enable / Disable modifier';
        toggleCheckbox.style.cursor = 'pointer';
        toggleCheckbox.style.margin = '0';
        toggleCheckbox.onChange.listen((_) {
          mod.enabled = toggleCheckbox.checked;
          state.evaluateModifiers();
          updateUI();
          renderModifierStack();
        });
        headerLeft.appendChild(toggleCheckbox);
      }

      final titleSpan = span(
        mod.name,
        hasError ? 'modifier-title error' : 'modifier-title',
      )..style.cursor = 'pointer';
      titleSpan.onClick.listen((_) {
        mod.collapsed = !mod.collapsed;
        renderModifierStack();
      });
      headerLeft.appendChild(titleSpan);
      header.appendChild(headerLeft);

      final actions = div('modifier-header-actions');
      if (mod.canApply && !hasError) {
        final btnApply = button('Apply', 'modifier-btn-apply')
          ..title = 'Apply modifier permanently into base graph'
          ..onClick.listen((_) {
            mod.applyPermanent(state);
            state.evaluateModifiers();
            updateUI();
            renderModifierStack();
            showToast('Applied ${mod.name} permanently');
          });
        actions.appendChild(btnApply);
      }
      if (!mod.isPinned) {
        if (idx > 1) {
          final btnUp = button('', 'modifier-btn-icon')
            ..title = 'Move Up'
            ..innerHTML = '<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 8 L6 4 L10 8"/></svg>'
                .toJS
            ..onClick.listen((_) {
              final temp = state.modifiers[idx];
              state.modifiers[idx] = state.modifiers[idx - 1];
              state.modifiers[idx - 1] = temp;
              state.evaluateModifiers();
              updateUI();
              renderModifierStack();
            });
          actions.appendChild(btnUp);
        }
        if (idx < state.modifiers.length - 1) {
          final btnDown = button('', 'modifier-btn-icon')
            ..title = 'Move Down'
            ..innerHTML = '<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 4 L6 8 L10 4"/></svg>'
                .toJS
            ..onClick.listen((_) {
              final temp = state.modifiers[idx];
              state.modifiers[idx] = state.modifiers[idx + 1];
              state.modifiers[idx + 1] = temp;
              state.evaluateModifiers();
              updateUI();
              renderModifierStack();
            });
          actions.appendChild(btnDown);
        }
        final btnRemove = button('', 'modifier-btn-icon')
          ..title = 'Remove'
          ..innerHTML = '<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="2"><path d="M2.5 2.5 L9.5 9.5 M9.5 2.5 L2.5 9.5"/></svg>'
              .toJS
          ..onClick.listen((_) {
            state.modifiers.removeAt(idx);
            state.evaluateModifiers();
            updateUI();
            renderModifierStack();
          });
        actions.appendChild(btnRemove);
      }
      header.appendChild(actions);
      card.appendChild(header);

      // Body (if not collapsed)
      if (!mod.collapsed) {
        final body = div('modifier-body');
        final configUI = mod.buildConfigUI(state, () {
          state.evaluateModifiers();
          updateUI();
          renderModifierStack();
        });
        body.appendChild(configUI);

        final summary = output?.statusSummary;
        if (hasError) {
          final errBox = div('modifier-error-alert')
            ..textContent =
                output?.errorMessage ?? 'An error occurred in this modifier.';
          body.appendChild(errBox);
        } else if (summary != null && summary.isNotEmpty) {
          body.appendChild(div('modifier-status')..textContent = summary);
        }

        final tableData = output?.tableData;
        if (tableData != null && tableData.rows.isNotEmpty) {
          final tableWrapper = div('modifier-table-wrapper');
          final tbl = tableElement('table');
          final thead = web.document.createElement('thead');
          final headerRow = web.document.createElement('tr');
          for (final h in tableData.headers) {
            final th =
                web.document.createElement('th') as web.HTMLTableCellElement;
            th.textContent = h;
            headerRow.appendChild(th);
          }
          thead.appendChild(headerRow);
          tbl.appendChild(thead);

          final tbody = web.document.createElement('tbody');
          for (final r in tableData.rows) {
            final row = web.document.createElement('tr');
            for (final cell in r) {
              final td =
                  web.document.createElement('td') as web.HTMLTableCellElement;
              td.textContent = cell;
              row.appendChild(td);
            }
            tbody.appendChild(row);
          }
          tbl.appendChild(tbody);
          tableWrapper.appendChild(tbl);
          body.appendChild(tableWrapper);
        }

        card.appendChild(body);
      }

      modifiersStackList.appendChild(card);
    }
  }

  void executeCommand(String cmdId) {
    final cmd = CommandRegistry.findById(cmdId);
    if (cmd == null) return;
    if (!cmd.canExecute(state)) return;
    cmd.execute(
      state,
      context: CommandContext(
        cursorX: renderer.canvasMouseX,
        cursorY: renderer.canvasMouseY,
        startVertexPlacement: (vertexId) {
          state.pendingPlacementVertex = vertexId;
          updateUI();
        },
        showInlineEditor: (v) {
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
        openIoModal: () {
          syncModalContent();
          modalIo.style.display = 'flex';
        },
        runLayout: () {
          renderer.autoLayout(state);
          updateUI();
        },
      ),
    );
    updateUI();
  }

  void updateModifierVertexDropdowns(AppState state) {
    final dropdowns = web.document.querySelectorAll('.vertex-select');
    final vertices = state.renderGraph.vertices.toList();

    for (var i = 0; i < dropdowns.length; i++) {
      final select = dropdowns.item(i) as web.HTMLSelectElement?;
      if (select == null) continue;

      final currentVal = select.value;
      final allowPlaceholder = select.dataset['allowPlaceholder'] == 'true';
      final placeholderText = select.dataset['placeholderText'];

      select.textContent = '';
      if (allowPlaceholder) {
        select.appendChild(optionElement('', placeholderText));
      }
      for (final v in vertices) {
        select.appendChild(optionElement(v, v));
      }

      if (vertices.contains(currentVal)) {
        select.value = currentVal;
      } else if (allowPlaceholder) {
        select.value = '';
      } else if (vertices.isNotEmpty) {
        select.value = vertices.first;
      }
    }
  }

  updateUI = () {
    // Evaluate modifier stack pipeline
    state.evaluateModifiers();

    // Validate selection against active graph
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

    btnToggleLabels?.classList.toggle('active', state.showLabels);
    btnToggleWeights?.classList.toggle('active', state.isWeighted);

    btnUndo.disabled = !state.canUndo();
    btnRedo.disabled = !state.canRedo();

    btnModeVertex.classList.toggle('active', state.selectVerticesMode);
    btnModeEdge.classList.toggle('active', state.selectEdgesMode);

    codeDot.textContent = renderer.generateDot(state);
    codeDart.textContent = GraphIO.exportToDartCode(state);

    updateModifierVertexDropdowns(state);

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
        showToast('Renamed vertex "$v" to "$newLabel"');
        updateUI();
      },
    );

    renderer.render(state);
  };

  // Blender-style selection mode ('vertex' or 'edge')
  // Selection mode toggles: Vertex (1) and Edge (2) (both active by default)
  btnModeVertex.onClick.listen((_) {
    if (state.selectVerticesMode && !state.selectEdgesMode) {
      return; // Keep at least one mode active
    }
    state.selectVerticesMode = !state.selectVerticesMode;
    updateUI();
  });

  btnModeEdge.onClick.listen((_) {
    if (state.selectEdgesMode && !state.selectVerticesMode) {
      return; // Keep at least one mode active
    }
    state.selectEdgesMode = !state.selectEdgesMode;
    updateUI();
  });

  btnToggleLabels?.onClick.listen((_) {
    state.showLabels = !state.showLabels;
    updateUI();
  });

  btnToggleWeights?.onClick.listen((_) {
    state.isWeighted = !state.isWeighted;
    updateUI();
  });

  // Interactive Vertex Click handler (clicking an already selected vertex enters in-place edit mode)
  void handleVertexClick(String vertex, web.MouseEvent event) {
    if (!state.selectVerticesMode) return;
    if (state.showLabels &&
        !event.shiftKey &&
        state.selectedVertices.length == 1 &&
        state.selectedVertices.contains(vertex)) {
      // In-place editing on clicking an already selected vertex
      handleVertexDblClick(vertex);
      return;
    }
    state.selectVertex(
      vertex,
      toggle: event.shiftKey,
      clearOthers: !event.shiftKey,
    );
    updateUI();
  }

  // Interactive Edge Click handler
  void handleEdgeClick(String source, String target, web.MouseEvent event) {
    if (!state.selectEdgesMode) return;
    if (event.shiftKey) {
      if (state.selectedEdges.contains((source, target)) ||
          (!state.primaryGraph.isDirected &&
              state.selectedEdges.contains((target, source)))) {
        state.selectedEdges.remove((source, target));
        state.selectedEdges.remove((target, source));
      } else {
        state.selectedEdges.add((source, target));
      }
      state.selectedEdge = state.selectedEdges.isNotEmpty
          ? state.selectedEdges.first
          : null;
    } else {
      state.selectedVertices.clear();
      state.activeVertex = null;
      state.selectedSource = null;
      state.selectedTarget = null;
      state.selectedEdge = (source, target);
      state.selectedEdges = {(source, target)};
    }
    updateUI();
  }

  // Unified Lasso / Marquee selection handler
  void handleLassoSelection(
    List<String> matchedVertices,
    List<(String, String)> matchedEdges,
    bool isShift,
  ) {
    if (!isShift) {
      state.clearSelection();
    }
    if (state.selectVerticesMode && matchedVertices.isNotEmpty) {
      state.selectedVertices.addAll(matchedVertices);
      state.activeVertex = matchedVertices.last;
      state.syncSelectionSourceTarget();
    }
    if (state.selectEdgesMode && matchedEdges.isNotEmpty) {
      state.selectedEdges.addAll(matchedEdges);
      state.selectedEdge = matchedEdges.last;
    }
    updateUI();
  }

  // Interactive Canvas Surface Click handler (click on empty background clears selection)
  void handleBackgroundClick(web.MouseEvent event) {
    state.clearSelection();
    updateUI();
  }

  // Initialize renderer
  renderer = GraphRenderer(
    container: canvasContainer,
    transformLayer: transformLayer,
    onVertexClick: handleVertexClick,
    onVertexDblClick: handleVertexDblClick,
    onEdgeClick: handleEdgeClick,
    onBackgroundClick: handleBackgroundClick,
    onLassoSelection: handleLassoSelection,
    onPlacementConfirmed: (placedVertex) {
      state.selectVertex(placedVertex, clearOthers: true);
      updateUI();
      if (state.showLabels) {
        renderer.showInlineNodeEditor(
          state,
          placedVertex,
          onCommit: (newLabel) {
            state.saveSnapshot();
            state.getOrCreateNode(placedVertex).label = newLabel;
            updateUI();
          },
        );
      }
    },
    onEdgeWeightEdit: (u, v, newWeight) {
      state.saveSnapshot();
      state.primaryGraph.addEdge(u, v, value: newWeight);
      updateUI();
    },
    onNodesMoved: (moves) {
      state.saveSnapshot();
      for (final MapEntry(:key, :value) in moves.entries) {
        final node = state.nodes[key];
        if (node != null) {
          node.x = value.$1;
          node.y = value.$2;
        }
      }
      updateUI();
    },
  );

  await renderer.initialize();
  state.viz = renderer.viz;
  renderer.autoLayout(state);

  // Undo / Redo top bar button listeners
  btnUndo.onClick.listen((_) {
    state.undo();
    updateUI();
  });

  btnRedo.onClick.listen((_) {
    state.redo();
    updateUI();
  });

  // Zoom listeners
  btnZoomIn.onClick.listen((_) => renderer.zoomIn());
  btnZoomOut.onClick.listen((_) => renderer.zoomOut());
  btnZoomFit.onClick.listen((_) => renderer.resetView());

  // Blender-style keyboard shortcuts
  web.window.onkeydown = ((web.KeyboardEvent event) {
    final target = event.target;
    if (target != null &&
        (target.isA<web.HTMLInputElement>() ||
            target.isA<web.HTMLTextAreaElement>())) {
      return;
    }

    final key = event.key;
    final isModifier = event.ctrlKey || event.metaKey;

    if (key == 'Escape') {
      if (state.pendingPlacementVertex != null) {
        state.pendingPlacementVertex = null;
        updateUI();
        event.preventDefault();
        return;
      }
    }

    if (isModifier && (key == 'z' || key == 'Z')) {
      if (event.shiftKey) {
        btnRedo.click();
      } else {
        btnUndo.click();
      }
      event.preventDefault();
      return;
    }

    if (isModifier && (key == 'i' || key == 'I')) {
      executeCommand('select.invert');
      event.preventDefault();
      return;
    }

    if (event.shiftKey && (key == 'd' || key == 'D')) {
      executeCommand('graph.duplicate');
      event.preventDefault();
      return;
    }

    if (key == 'Backspace' || key == 'Delete' || key == 'x' || key == 'X') {
      if (state.selectedVertices.isNotEmpty) {
        executeCommand('vertex.delete');
      } else {
        executeCommand('edge.delete');
      }
      event.preventDefault();
      return;
    }

    if (key == '1') {
      btnModeVertex.click();
      event.preventDefault();
      return;
    }

    if (key == '2') {
      btnModeEdge.click();
      event.preventDefault();
      return;
    }

    if (key == 'c' || key == 'C') {
      executeCommand('vertex.add');
      event.preventDefault();
      return;
    }

    if (key == 'e' || key == 'E') {
      executeCommand('vertex.expand');
      event.preventDefault();
      return;
    }

    if (key == 'a' || key == 'A') {
      if (state.selectedVertices.isNotEmpty ||
          state.selectedEdges.isNotEmpty ||
          state.selectedEdge != null) {
        executeCommand('select.none');
      } else {
        executeCommand('select.all');
      }
      event.preventDefault();
      return;
    }

    if (key == 'f' || key == 'F') {
      executeCommand('edge.connect');
      event.preventDefault();
      return;
    }

    if (key == 'w' || key == 'W') {
      executeCommand('edge.subdivide');
      event.preventDefault();
      return;
    }

    if (key == 'm' || key == 'M') {
      executeCommand('vertex.merge');
      event.preventDefault();
      return;
    }

    if (key == '+' || key == '=') {
      executeCommand('select.expand');
      event.preventDefault();
      return;
    }

    if (key == '-' || key == '_') {
      executeCommand('select.collapse');
      event.preventDefault();
      return;
    }

    if (key == 'l' || key == 'L') {
      executeCommand('graph.layout');
      event.preventDefault();
      return;
    }
  }).toJS;

  var isAnyMenuOpen = false;

  void closeAllMenus() {
    final openMenus = web.document.querySelectorAll('.menu-item.open');
    for (var i = 0; i < openMenus.length; i++) {
      (openMenus.item(i) as web.HTMLElement?)?.classList.remove('open');
    }
    isAnyMenuOpen = false;
  }

  void openMenu(web.HTMLElement parent) {
    final openMenus = web.document.querySelectorAll('.menu-item.open');
    for (var i = 0; i < openMenus.length; i++) {
      (openMenus.item(i) as web.HTMLElement?)?.classList.remove('open');
    }
    parent.classList.add('open');
    isAnyMenuOpen = true;
  }

  // Setup Menu triggers
  final menuTriggers = web.document.querySelectorAll('.menu-label');
  for (var i = 0; i < menuTriggers.length; i++) {
    final trigger = menuTriggers.item(i) as web.HTMLButtonElement?;
    if (trigger == null) continue;
    trigger.onClick.listen((event) {
      event.stopPropagation();
      final parent = trigger.parentElement as web.HTMLElement?;
      if (parent == null) return;
      if (parent.classList.contains('open')) {
        closeAllMenus();
      } else {
        openMenu(parent);
      }
    });

    trigger.onMouseEnter.listen((event) {
      if (isAnyMenuOpen) {
        final parent = trigger.parentElement as web.HTMLElement?;
        if (parent != null && !parent.classList.contains('open')) {
          openMenu(parent);
        }
      }
    });
  }

  // Close menus on outside click
  web.document.addEventListener(
    'click',
    ((web.MouseEvent event) {
      closeAllMenus();
    }).toJS,
  );

  // Setup Menu dropdown items
  final menuItems = web.document.querySelectorAll('.dropdown-item');
  for (var i = 0; i < menuItems.length; i++) {
    final item = menuItems.item(i) as web.HTMLElement?;
    if (item == null) continue;
    final cmdId = item.getAttribute('data-cmd');
    if (cmdId != null) {
      item.onClick.listen((event) {
        event.stopPropagation();
        closeAllMenus();
        executeCommand(cmdId);
      });
    }
  }

  // Modifier Stack setup
  selectAddModifier.onChange.listen((_) {
    final type = selectAddModifier.value;
    if (type.isNotEmpty) {
      final mod = ModifierRegistry.create(type);
      state.modifiers.add(mod);
      selectAddModifier.value = '';
      state.evaluateModifiers();
      updateUI();
      renderModifierStack();
      showToast('Added modifier: ${mod.name}');
    }
  });

  // Pinned Base Graph Modifier at index 0 (non-movable, non-removable)
  state.modifiers.add(BaseGraphModifier());
  // Default active modifier: Shortest Path
  state.modifiers.add(ShortestPathModifier());
  renderModifierStack();

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

  updateUI();
}
