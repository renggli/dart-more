import 'dart:js_interop';
import 'dart:math' as math;

import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'commands.dart';
import 'dom_utils.dart';
import 'icons.dart';
import 'inspector.dart';
import 'io.dart';
import 'modifiers.dart';
import 'renderer.dart';
import 'state.dart';

void main() {
  final state = AppState();

  // Elements
  final canvasContainer =
      web.document.querySelector('#graph-canvas') as web.HTMLElement;
  final transformLayer = web.document.querySelector(
    '#viewport-transform-layer',
  ) as web.HTMLElement;
  final btnZoomIn =
      web.document.querySelector('#btn-zoom-in') as web.HTMLButtonElement;
  final btnZoomOut =
      web.document.querySelector('#btn-zoom-out') as web.HTMLButtonElement;
  final btnZoomFit =
      web.document.querySelector('#btn-zoom-fit') as web.HTMLButtonElement;

  // Selection mode buttons and display toggles
  final btnModeVertex =
      web.document.querySelector('#btn-mode-vertex') as web.HTMLButtonElement;
  final btnModeEdge =
      web.document.querySelector('#btn-mode-edge') as web.HTMLButtonElement;
  final btnToggleStats =
      web.document.querySelector('#btn-toggle-stats') as web.HTMLButtonElement?;
  final btnToggleLabels = web.document.querySelector(
    '#btn-toggle-labels',
  ) as web.HTMLButtonElement?;
  final btnToggleWeights = web.document.querySelector(
    '#btn-toggle-weights',
  ) as web.HTMLButtonElement?;
  final canvasStatsOverlay =
      web.document.querySelector('#canvas-stats-overlay') as web.HTMLElement?;
  final introOverlay =
      web.document.querySelector('#intro-overlay') as web.HTMLElement?;
  final btnIntroEmpty =
      web.document.querySelector('#btn-intro-empty') as web.HTMLButtonElement?;
  final inputOpenFile =
      web.document.querySelector('#input-open-file') as web.HTMLInputElement?;

  // Graph section elements
  final selectDirectedness = web.document.querySelector(
    '#select-directedness',
  ) as web.HTMLSelectElement;

  // Modifier Stack elements
  final selectAddModifier = web.document.querySelector(
    '#select-add-modifier',
  ) as web.HTMLSelectElement;
  final modifiersStackList =
      web.document.querySelector('#modifiers-stack-list') as web.HTMLElement;

  // Import / Export modal elements
  final modalIo = web.document.querySelector('#modal-io') as web.HTMLElement;
  final modalIoTitle =
      web.document.querySelector('#modal-io-title') as web.HTMLElement;
  final btnCloseModal =
      web.document.querySelector('#btn-close-modal') as web.HTMLButtonElement;
  final selectIoFormat =
      web.document.querySelector('#select-io-format') as web.HTMLSelectElement;
  final textareaIo =
      web.document.querySelector('#textarea-io') as web.HTMLTextAreaElement;
  final importActions =
      web.document.querySelector('#import-actions') as web.HTMLElement;
  final exportActions =
      web.document.querySelector('#export-actions') as web.HTMLElement;
  final btnIoImport =
      web.document.querySelector('#btn-io-import') as web.HTMLButtonElement;
  final btnExportCopy =
      web.document.querySelector('#btn-export-copy') as web.HTMLButtonElement;
  final btnExportDownload = web.document.querySelector(
    '#btn-export-download',
  ) as web.HTMLButtonElement;
  final btnExportShare =
      web.document.querySelector('#btn-export-share') as web.HTMLButtonElement;
  final ioStatus = web.document.querySelector('#io-status') as web.HTMLElement;

  late final GraphRenderer renderer;

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

  late void Function() updateUI;

  var ioMode = 'import';

  void syncModalContent() {
    ioStatus.textContent = '';
    if (ioMode == 'export') {
      switch (selectIoFormat.value) {
        case 'mermaid':
          textareaIo.value = GraphIO.exportToMermaid(state);
        case 'dot':
          textareaIo.value = GraphIO.exportToDot(state);
        case 'json':
          textareaIo.value = GraphIO.exportToJson(state);
      }
    }
  }

  void openImportModal() {
    ioMode = 'import';
    modalIoTitle.textContent = 'Import Graph';
    selectIoFormat.textContent = '';
    selectIoFormat.appendChild(
      web.HTMLOptionElement()
        ..value = 'mermaid'
        ..text = 'Mermaid'
        ..selected = true,
    );
    selectIoFormat.appendChild(
      web.HTMLOptionElement()
        ..value = 'json'
        ..text = 'JSON',
    );
    textareaIo.value = '';
    textareaIo.placeholder = 'Paste Mermaid diagram or JSON graph here...';
    importActions.style.display = 'flex';
    exportActions.style.display = 'none';
    ioStatus.textContent = '';
    modalIo.style.display = 'flex';
  }

  void openExportModal() {
    ioMode = 'export';
    modalIoTitle.textContent = 'Export Graph';
    selectIoFormat.textContent = '';
    selectIoFormat.appendChild(
      web.HTMLOptionElement()
        ..value = 'mermaid'
        ..text = 'Mermaid'
        ..selected = true,
    );
    selectIoFormat.appendChild(
      web.HTMLOptionElement()
        ..value = 'dot'
        ..text = 'Graphviz DOT',
    );
    selectIoFormat.appendChild(
      web.HTMLOptionElement()
        ..value = 'json'
        ..text = 'JSON',
    );
    importActions.style.display = 'none';
    exportActions.style.display = 'flex';
    syncModalContent();
    modalIo.style.display = 'flex';
  }

  void handleVertexDblClick(String vertex) {
    renderer.showInlineNodeEditor(
      state,
      vertex,
      onCommit: (newLabel) {
        state.saveSnapshot();
        state.getOrCreateNode(vertex).label = newLabel;
        updateUI();
      },
    );
  }

  final modifierCardUpdaters = <void Function()>[];

  void updateModifierCards() {
    for (final updater in modifierCardUpdaters) {
      updater();
    }
  }

  void renderModifierStack() {
    modifierCardUpdaters.clear();
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
      web.HTMLButtonElement? btnApply;
      if (mod.canApply) {
        btnApply = button('Apply', 'modifier-btn-apply')
          ..title = 'Apply modifier permanently into base graph'
          ..onClick.listen((_) {
            mod.applyPermanent(state);
            state.evaluateModifiers();
            updateUI();
            renderModifierStack();
          });
        if (hasError) {
          btnApply.style.display = 'none';
        }
        actions.appendChild(btnApply);
      }
      if (!mod.isPinned) {
        if (idx > 0) {
          final btnUp = button('', 'modifier-btn-icon')
            ..title = 'Move Up'
            ..innerHTML = GraphIcons.chevronUp.toJS
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
            ..innerHTML = GraphIcons.chevronDown.toJS
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
          ..innerHTML = GraphIcons.close.toJS
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
      void Function()? updateCardBody;
      if (!mod.collapsed) {
        final body = div('modifier-body');
        final statusContainer = div('modifier-status-container');
        final tableContainer = div('modifier-table-container');

        void updateStatusAndTable() {
          statusContainer.textContent = '';
          tableContainer.textContent = '';

          final currentOut = state.lastModifierOutputs[mod.id];
          final currentErr = currentOut?.hasError ?? false;
          final currentSummary = currentOut?.statusSummary;
          final currentTable = currentOut?.tableData;

          if (currentErr) {
            final errBox = div('modifier-error-alert')
              ..textContent =
                  currentOut?.errorMessage ??
                  'An error occurred in this modifier.';
            statusContainer.appendChild(errBox);
          } else if (currentTable != null && currentTable.rows.isNotEmpty) {
            final tableWrapper = div('modifier-table-wrapper');
            final tbl = tableElement('table');
            final thead = web.document.createElement('thead');
            final headerRow = web.document.createElement('tr');
            for (final h in currentTable.headers) {
              final th =
                  web.document.createElement('th') as web.HTMLTableCellElement;
              th.textContent = h;
              headerRow.appendChild(th);
            }
            thead.appendChild(headerRow);
            tbl.appendChild(thead);

            final tbody = web.document.createElement('tbody');
            for (final r in currentTable.rows) {
              final row = web.document.createElement('tr');
              for (final cell in r) {
                final td = web.document.createElement(
                  'td',
                ) as web.HTMLTableCellElement;
                td.textContent = cell;
                row.appendChild(td);
              }
              tbody.appendChild(row);
            }
            tbl.appendChild(tbody);
            tableWrapper.appendChild(tbl);
            tableContainer.appendChild(tableWrapper);
          } else if (currentSummary != null && currentSummary.isNotEmpty) {
            statusContainer.appendChild(
              div('modifier-status')..textContent = currentSummary,
            );
          }
        }

        final configUI = mod.buildConfigUI(state, () {
          state.evaluateModifiers();
          updateUI();
        });
        body.appendChild(configUI);
        body.appendChild(statusContainer);
        body.appendChild(tableContainer);
        updateStatusAndTable();

        updateCardBody = updateStatusAndTable;
        card.appendChild(body);
      }

      void updateCard() {
        final currentOut = state.lastModifierOutputs[mod.id];
        final currentErr = currentOut?.hasError ?? false;
        card.classList.toggle('error', currentErr);
        card.classList.toggle('disabled', !mod.enabled);
        titleSpan.className = currentErr
            ? 'modifier-title error'
            : 'modifier-title';
        if (btnApply != null) {
          btnApply.style.display = (mod.canApply && !currentErr) ? '' : 'none';
        }
        updateCardBody?.call();
      }

      modifierCardUpdaters.add(updateCard);
      modifiersStackList.appendChild(card);
    }
  }

  var dismissedEmpty = false;

  void updateCanvasStats() {
    if (canvasStatsOverlay == null) return;
    if (!state.showStats) {
      canvasStatsOverlay.style.display = 'none';
      return;
    }
    final graph = state.renderGraph;
    final vCount = graph.vertices.length;
    final eCount = graph.edges.length;
    var pCount = 0;
    if (state.activeOverlay is PathOverlay) {
      final po = state.activeOverlay as PathOverlay;
      pCount = po.edges.isNotEmpty
          ? po.edges.length
          : (po.vertices.length > 1 ? po.vertices.length - 1 : 0);
    }

    final parts = <String>[];
    if (vCount > 0) parts.add('Vertices: <strong>$vCount</strong>');
    if (eCount > 0) parts.add('Edges: <strong>$eCount</strong>');
    if (pCount > 0) parts.add('Path Segments: <strong>$pCount</strong>');

    if (parts.isEmpty) {
      canvasStatsOverlay.style.display = 'none';
    } else {
      canvasStatsOverlay.innerHTML = parts
          .map((p) => '<span>$p</span>')
          .join('')
          .toJS;
      canvasStatsOverlay.style.display = 'block';
    }
  }

  void updateIntroOverlay() {
    if (introOverlay == null) return;
    final isEmpty = state.primaryGraph.vertices.isEmpty;
    if (isEmpty && !dismissedEmpty) {
      introOverlay.style.display = 'flex';
    } else {
      introOverlay.style.display = 'none';
    }
  }

  Graph<String, num> buildKoenigsberg() {
    final g = Graph<String, num>(isDirected: false);
    const edges = [
      ('Altstadt (North)', 'Krämerbrücke'),
      ('Krämerbrücke', 'Kneiphof (Island)'),
      ('Altstadt (North)', 'Schmiedebrücke'),
      ('Schmiedebrücke', 'Kneiphof (Island)'),
      ('Altstadt (North)', 'Holzbrücke'),
      ('Holzbrücke', 'Lomse (East)'),
      ('Kneiphof (Island)', 'Honigbrücke'),
      ('Honigbrücke', 'Lomse (East)'),
      ('Kneiphof (Island)', 'Grüne Brücke'),
      ('Grüne Brücke', 'Vorstadt (South)'),
      ('Kneiphof (Island)', 'Köttelbrücke'),
      ('Köttelbrücke', 'Vorstadt (South)'),
      ('Vorstadt (South)', 'Hohe Brücke'),
      ('Hohe Brücke', 'Lomse (East)'),
    ];
    for (final (u, v) in edges) {
      g.addEdge(u, v, value: 1);
    }
    return g;
  }

  void layoutKoenigsberg() {
    final coords = <String, (double, double)>{
      'Altstadt (North)': (320, 80),
      'Kneiphof (Island)': (320, 240),
      'Vorstadt (South)': (320, 400),
      'Lomse (East)': (540, 240),
      'Krämerbrücke': (240, 160),
      'Schmiedebrücke': (400, 160),
      'Grüne Brücke': (240, 320),
      'Köttelbrücke': (400, 320),
      'Holzbrücke': (470, 140),
      'Honigbrücke': (430, 240),
      'Hohe Brücke': (470, 340),
    };
    for (final entry in coords.entries) {
      final node = state.nodes[entry.key];
      if (node != null) {
        node.x = entry.value.$1;
        node.y = entry.value.$2;
      }
    }
  }

  Graph<String, num> buildSwissRailways() {
    final g = Graph<String, num>(isDirected: false);
    const connections = [
      ('Zurich', 'Winterthur', 25),
      ('Zurich', 'Basel', 85),
      ('Zurich', 'Lucerne', 52),
      ('Zurich', 'Bern', 125),
      ('Zurich', 'St. Gallen', 85),
      ('Zurich', 'Chur', 120),
      ('Winterthur', 'St. Gallen', 60),
      ('Basel', 'Bern', 95),
      ('Basel', 'Biel', 75),
      ('Bern', 'Biel', 35),
      ('Bern', 'Lucerne', 90),
      ('Bern', 'Lausanne', 105),
      ('Bern', 'Sion', 155),
      ('Lausanne', 'Geneva', 65),
      ('Lausanne', 'Sion', 95),
      ('Lucerne', 'Bellinzona', 125),
      ('Bellinzona', 'Lugano', 30),
      ('Bellinzona', 'Chur', 110),
      ('St. Gallen', 'Chur', 95),
    ];
    for (final (u, v, dist) in connections) {
      g.addEdge(u, v, value: dist);
    }
    return g;
  }

  void layoutSwissRailways() {
    final coords = <String, (double, double)>{
      'Geneva': (130, 460),
      'Lausanne': (230, 390),
      'Sion': (350, 470),
      'Biel': (330, 230),
      'Bern': (370, 300),
      'Basel': (390, 120),
      'Lucerne': (500, 260),
      'Zurich': (560, 180),
      'Winterthur': (650, 140),
      'St. Gallen': (750, 150),
      'Chur': (740, 290),
      'Bellinzona': (620, 430),
      'Lugano': (630, 520),
    };
    for (final entry in coords.entries) {
      final node = state.nodes[entry.key];
      if (node != null) {
        node.x = entry.value.$1;
        node.y = entry.value.$2;
      }
    }
  }

  Graph<String, num> buildCoursePrerequisites() {
    final g = Graph<String, num>(isDirected: true);
    const edges = [
      ('CS 101', 'CS 102'),
      ('Math 101', 'CS 102'),
      ('Math 101', 'Math 201'),
      ('CS 102', 'CS 201'),
      ('CS 102', 'CS 202'),
      ('Math 201', 'CS 301'),
      ('CS 201', 'CS 301'),
      ('CS 201', 'CS 302'),
      ('CS 202', 'CS 302'),
      ('CS 301', 'CS 401'),
      ('CS 302', 'CS 401'),
    ];
    for (final (u, v) in edges) {
      g.addEdge(u, v, value: 1);
    }
    return g;
  }

  void layoutCoursePrerequisites() {
    const coords = <String, (double, double)>{
      'CS 101': (150, 200),
      'Math 101': (150, 360),
      'CS 102': (310, 200),
      'Math 201': (310, 360),
      'CS 202': (470, 140),
      'CS 201': (470, 280),
      'CS 302': (630, 180),
      'CS 301': (630, 360),
      'CS 401': (770, 270),
    };
    for (final entry in coords.entries) {
      final node = state.nodes[entry.key];
      if (node != null) {
        node.x = entry.value.$1;
        node.y = entry.value.$2;
      }
    }
  }

  Graph<String, num> buildNetworkFlow() {
    final g = Graph<String, num>(isDirected: true);
    const edges = [
      ('Source', 'A', 16),
      ('Source', 'B', 13),
      ('A', 'B', 10),
      ('B', 'A', 4),
      ('A', 'C', 12),
      ('B', 'D', 14),
      ('C', 'B', 9),
      ('D', 'C', 7),
      ('C', 'Sink', 20),
      ('D', 'Sink', 4),
    ];
    for (final (u, v, cap) in edges) {
      g.addEdge(u, v, value: cap);
    }
    return g;
  }

  void layoutNetworkFlow() {
    const coords = <String, (double, double)>{
      'Source': (150, 280),
      'A': (330, 170),
      'B': (330, 390),
      'C': (530, 170),
      'D': (530, 390),
      'Sink': (710, 280),
    };
    for (final entry in coords.entries) {
      final node = state.nodes[entry.key];
      if (node != null) {
        node.x = entry.value.$1;
        node.y = entry.value.$2;
      }
    }
  }

  Graph<String, num> buildWebHyperlinks() {
    final g = Graph<String, num>(isDirected: true);
    const edges = [
      ('Home', 'About'),
      ('Home', 'Products'),
      ('Home', 'Blog'),
      ('About', 'Home'),
      ('Products', 'Details'),
      ('Products', 'Cart'),
      ('Details', 'Products'),
      ('Details', 'Reviews'),
      ('Reviews', 'Details'),
      ('Reviews', 'Home'),
      ('Cart', 'Checkout'),
      ('Checkout', 'Home'),
      ('Blog', 'Home'),
      ('Blog', 'Reviews'),
    ];
    for (final (u, v) in edges) {
      g.addEdge(u, v, value: 1);
    }
    return g;
  }

  void layoutWebHyperlinks() {
    const coords = <String, (double, double)>{
      'Home': (440, 280),
      'About': (260, 200),
      'Blog': (300, 120),
      'Reviews': (580, 120),
      'Details': (620, 220),
      'Products': (600, 340),
      'Cart': (440, 440),
      'Checkout': (260, 380),
    };
    for (final entry in coords.entries) {
      final node = state.nodes[entry.key];
      if (node != null) {
        node.x = entry.value.$1;
        node.y = entry.value.$2;
      }
    }
  }

  Graph<String, num> buildPetersen() {
    final g = Graph<String, num>(isDirected: false);
    for (var i = 0; i < 5; i++) {
      g.addEdge('v$i', 'v${(i + 1) % 5}', value: 1);
      g.addEdge('v$i', 'v${i + 5}', value: 1);
      g.addEdge('v${i + 5}', 'v${(i + 2) % 5 + 5}', value: 1);
    }
    return g;
  }

  void layoutPetersen() {
    const cx = 320.0, cy = 260.0;
    const rOuter = 160.0, rInner = 80.0;
    for (var i = 0; i < 5; i++) {
      final angle = -math.pi / 2 + i * 2 * math.pi / 5;
      final nodeOuter = state.nodes['v$i'];
      if (nodeOuter != null) {
        nodeOuter.x = cx + rOuter * math.cos(angle);
        nodeOuter.y = cy + rOuter * math.sin(angle);
      }
      final nodeInner = state.nodes['v${i + 5}'];
      if (nodeInner != null) {
        nodeInner.x = cx + rInner * math.cos(angle);
        nodeInner.y = cy + rInner * math.sin(angle);
      }
    }
  }

  Graph<String, num> buildFlorentine() {
    final g = Graph<String, num>(isDirected: false);
    const marriages = [
      ('Medici', 'Acciaiuoli'),
      ('Medici', 'Albizzi'),
      ('Medici', 'Barbadori'),
      ('Medici', 'Ridolfi'),
      ('Medici', 'Tornabuoni'),
      ('Medici', 'Salviati'),
      ('Castellani', 'Barbadori'),
      ('Castellani', 'Peruzzi'),
      ('Castellani', 'Strozzi'),
      ('Peruzzi', 'Strozzi'),
      ('Peruzzi', 'Bischeri'),
      ('Strozzi', 'Bischeri'),
      ('Strozzi', 'Ridolfi'),
      ('Albizzi', 'Ginori'),
      ('Albizzi', 'Guadagni'),
      ('Salviati', 'Pazzi'),
      ('Bischeri', 'Guadagni'),
      ('Guadagni', 'Lamberteschi'),
      ('Guadagni', 'Tornabuoni'),
      ('Ridolfi', 'Tornabuoni'),
    ];
    for (final (u, v) in marriages) {
      g.addEdge(u, v, value: 1);
    }
    return g;
  }

  Graph<String, num> buildArpanet() {
    final g = Graph<String, num>(isDirected: false);
    const links = [
      ('SRI', 'UCLA'),
      ('SRI', 'UCSB'),
      ('SRI', 'UTAH'),
      ('UCLA', 'UCSB'),
      ('UCLA', 'RAND'),
      ('UCSB', 'SDC'),
      ('RAND', 'SDC'),
      ('RAND', 'BBN'),
      ('UTAH', 'MIT'),
      ('SDC', 'UTAH'),
      ('BBN', 'MIT'),
      ('BBN', 'HARVARD'),
      ('BBN', 'BURROUGHS'),
      ('MIT', 'LINCOLN'),
      ('HARVARD', 'CARNEGIE'),
      ('CARNEGIE', 'CASE'),
      ('CASE', 'LINCOLN'),
      ('BURROUGHS', 'RAND'),
    ];
    for (final (u, v) in links) {
      g.addEdge(u, v, value: 1);
    }
    return g;
  }

  Graph<String, num> buildDodecahedron() {
    final g = Graph<String, num>(isDirected: false);
    const edges = [
      ('1', '2'),
      ('2', '3'),
      ('3', '4'),
      ('4', '5'),
      ('5', '1'),
      ('1', '6'),
      ('2', '7'),
      ('3', '8'),
      ('4', '9'),
      ('5', '10'),
      ('6', '11'),
      ('7', '12'),
      ('8', '13'),
      ('9', '14'),
      ('10', '15'),
      ('11', '12'),
      ('12', '13'),
      ('13', '14'),
      ('14', '15'),
      ('15', '11'),
      ('11', '16'),
      ('12', '17'),
      ('13', '18'),
      ('14', '19'),
      ('15', '20'),
      ('16', '17'),
      ('17', '18'),
      ('18', '19'),
      ('19', '20'),
      ('20', '16'),
    ];
    for (final (u, v) in edges) {
      g.addEdge('v$u', 'v$v', value: 1);
    }
    return g;
  }

  void loadPreset(String preset) {
    state.saveSnapshot();
    Graph<String, num> g;
    var customLayout = false;
    switch (preset) {
      case 'koenigsberg':
        state.isWeighted = false;
        g = buildKoenigsberg();
        state.primaryGraph = g;
        state.syncNodes();
        layoutKoenigsberg();
        customLayout = true;
      case 'swiss':
        state.isWeighted = true;
        g = buildSwissRailways();
        state.primaryGraph = g;
        state.syncNodes();
        layoutSwissRailways();
        customLayout = true;
      case 'petersen':
        state.isWeighted = false;
        g = buildPetersen();
        state.primaryGraph = g;
        state.syncNodes();
        layoutPetersen();
        customLayout = true;
      case 'florentine':
        state.isWeighted = false;
        g = buildFlorentine();
        state.primaryGraph = g;
        state.syncNodes();
      case 'arpanet':
        state.isWeighted = false;
        g = buildArpanet();
        state.primaryGraph = g;
        state.syncNodes();
      case 'dodecahedron':
        state.isWeighted = false;
        g = buildDodecahedron();
        state.primaryGraph = g;
        state.syncNodes();
      case 'dag':
        state.isWeighted = false;
        g = buildCoursePrerequisites();
        state.primaryGraph = g;
        state.syncNodes();
        layoutCoursePrerequisites();
        customLayout = true;
      case 'flow':
        state.isWeighted = true;
        g = buildNetworkFlow();
        state.primaryGraph = g;
        state.syncNodes();
        layoutNetworkFlow();
        customLayout = true;
      case 'web':
        state.isWeighted = false;
        g = buildWebHyperlinks();
        state.primaryGraph = g;
        state.syncNodes();
        layoutWebHyperlinks();
        customLayout = true;
      default:
        state.isWeighted = false;
        g = buildPetersen();
        state.primaryGraph = g;
        state.syncNodes();
        layoutPetersen();
        customLayout = true;
    }
    state.clearSelection();
    if (!customLayout) {
      renderer.autoLayout(state);
    }
    state.evaluateModifiers();
    renderer.resetView();
    updateUI();
  }

  void executeCommand(String cmdId) {
    final cmd = CommandRegistry.findById(cmdId);
    if (cmd == null) return;
    if (!cmd.canExecute(state)) return;
    cmd.execute(state);
    updateUI();
  }

  void updateModifierVertexDropdowns(AppState state) {
    final dropdowns = web.document.querySelectorAll('.vertex-select');
    final vertices = state.renderGraph.vertices.toList();

    for (var i = 0; i < dropdowns.length; i++) {
      final select = dropdowns.item(i) as web.HTMLSelectElement?;
      if (select == null) continue;

      final currentVal = select.value;
      final defaultLabel = select.getAttribute('data-default');

      select.textContent = '';
      if (defaultLabel != null) {
        select.appendChild(optionElement('', defaultLabel));
      }
      for (final v in vertices) {
        select.appendChild(optionElement(v, v));
      }

      if (vertices.contains(currentVal)) {
        select.value = currentVal;
      } else if (defaultLabel != null) {
        select.value = '';
      } else if (vertices.isNotEmpty) {
        select.value = vertices.first;
      }
    }
  }

  void syncMenuChecks() {
    web.document
        .querySelector('[data-cmd="select.mode_vertex"]')
        ?.classList
        .toggle('checked', state.selectVerticesMode);
    web.document
        .querySelector('[data-cmd="select.mode_edge"]')
        ?.classList
        .toggle('checked', state.selectEdgesMode);
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

    btnToggleStats?.classList.toggle('active', state.showStats);
    btnToggleLabels?.classList.toggle('active', state.showLabels);
    btnToggleWeights?.classList.toggle('active', state.isWeighted);

    btnModeVertex.classList.toggle('active', state.selectVerticesMode);
    btnModeEdge.classList.toggle('active', state.selectEdgesMode);

    selectDirectedness.value = state.primaryGraph.isDirected
        ? 'directed'
        : 'undirected';

    updateModifierVertexDropdowns(state);
    updateModifierCards();
    updateCanvasStats();
    updateIntroOverlay();
    syncMenuChecks();

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
        if (!isShift) {
          state.clearSelection();
          state.selectedEdge = (u, v);
          state.selectedEdges = {(u, v)};
        } else {
          state.selectedEdges.add((u, v));
          state.selectedEdge = (u, v);
        }
        updateUI();
      },
    );

    renderer.render(state);
  };

  btnModeVertex.onClick.listen((_) {
    executeCommand('select.mode_vertex');
  });

  btnModeEdge.onClick.listen((_) {
    executeCommand('select.mode_edge');
  });

  btnToggleStats?.onClick.listen((_) {
    state.showStats = !state.showStats;
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

  btnIntroEmpty?.onClick.listen((_) {
    dismissedEmpty = true;
    updateIntroOverlay();
  });

  final presetButtons = web.document.querySelectorAll('.intro-example-btn');
  for (var i = 0; i < presetButtons.length; i++) {
    final btn = presetButtons.item(i) as web.HTMLButtonElement?;
    final preset = btn?.getAttribute('data-preset');
    if (btn != null && preset != null) {
      btn.onClick.listen((_) {
        dismissedEmpty = true;
        loadPreset(preset);
      });
    }
  }

  if (inputOpenFile != null) {
    inputOpenFile.onChange.listen((_) {
      final files = inputOpenFile.files;
      if (files != null && files.length > 0) {
        final file = files.item(0);
        if (file != null) {
          final reader = web.FileReader();
          reader.onload = ((web.Event _) {
            final result = reader.result;
            if (result != null && result.isA<JSString>()) {
              final jsonStr = (result as JSString).toDart;
              try {
                final (g, weighted, nodes) = GraphIO.importFromJson(jsonStr);
                state.saveSnapshot();
                state.primaryGraph = g;
                state.isWeighted = weighted;
                state.nodes
                  ..clear()
                  ..addAll(nodes);
                dismissedEmpty = true;
                state.evaluateModifiers();
                renderer.autoLayout(state);
                renderer.resetView();
                updateUI();
              } catch (_) {}
            }
          }).toJS;
          reader.readAsText(file);
        }
        inputOpenFile.value = '';
      }
    });
  }

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
      state.isWeighted = true;
      state.primaryGraph.addEdge(u, v, value: newWeight);
      if (!state.primaryGraph.isDirected) {
        state.primaryGraph.addEdge(v, u, value: newWeight);
      }
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

  state.onOpenFile = () => inputOpenFile?.click();
  state.onOpenImport = openImportModal;
  state.onOpenExport = openExportModal;
  state.onShowInlineEditor = (v) {
    renderer.showInlineNodeEditor(
      state,
      v,
      onCommit: (newLabel) {
        state.saveSnapshot();
        state.getOrCreateNode(v).label = newLabel;
        updateUI();
      },
    );
  };
  state.onReset = () {
    dismissedEmpty = false;
    renderer.resetView();
    renderModifierStack();
    updateUI();
  };

  renderer.autoLayout(state);

  // Zoom listeners
  btnZoomIn.onClick.listen((_) => renderer.zoomIn());
  btnZoomOut.onClick.listen((_) => renderer.zoomOut());
  btnZoomFit.onClick.listen((_) => renderer.resetView());

  var isAnyMenuOpen = false;

  void closeAllMenus() {
    final openMenus = web.document.querySelectorAll('.menu-item.open');
    for (var i = 0; i < openMenus.length; i++) {
      (openMenus.item(i) as web.HTMLElement?)?.classList.remove('open');
    }
    isAnyMenuOpen = false;
  }

  void openMenu(web.HTMLElement parent) {
    syncMenuChecks();
    final openMenus = web.document.querySelectorAll('.menu-item.open');
    for (var i = 0; i < openMenus.length; i++) {
      (openMenus.item(i) as web.HTMLElement?)?.classList.remove('open');
    }
    parent.classList.add('open');
    isAnyMenuOpen = true;
  }

  // Keyboard shortcuts handler iterating over CommandRegistry.all
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
      var handled = false;
      if (modalIo.style.display != 'none') {
        modalIo.style.display = 'none';
        handled = true;
      }
      final openMenus = web.document.querySelectorAll('.menu-item.open');
      if (openMenus.length > 0) {
        closeAllMenus();
        handled = true;
      }
      if (introOverlay?.style.display != 'none') {
        dismissedEmpty = true;
        updateIntroOverlay();
        handled = true;
      }
      renderer.cancelInlineEditor();
      if (state.pendingPlacementVertex != null) {
        final pv = state.pendingPlacementVertex!;
        state.primaryGraph.removeVertex(pv);
        state.nodes.remove(pv);
        state.pendingPlacementVertex = null;
        handled = true;
        updateUI();
      }
      if (!handled &&
          (state.selectedVertices.isNotEmpty ||
              state.selectedEdges.isNotEmpty ||
              state.selectedEdge != null)) {
        state.clearSelection();
        updateUI();
      }
      event.preventDefault();
      return;
    }

    for (final cmd in CommandRegistry.all) {
      if (cmd.matchesKey(
        key,
        ctrl: isModifier,
        shift: event.shiftKey,
        alt: event.altKey,
      )) {
        if (cmd.canExecute(state)) {
          executeCommand(cmd.id);
          event.preventDefault();
          return;
        }
      }
    }
  }).toJS;

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
      selectAddModifier.selectedIndex = 0;
      state.evaluateModifiers();
      updateUI();
      renderModifierStack();
    }
  });

  selectDirectedness.onChange.listen((_) {
    final wantDirected = selectDirectedness.value == 'directed';
    if (wantDirected != state.primaryGraph.isDirected) {
      state.setDirected(wantDirected);
      updateUI();
    }
  });

  // Initialize modifier stack UI
  renderModifierStack();

  btnCloseModal.onClick.listen((_) {
    modalIo.style.display = 'none';
  });

  selectIoFormat.onChange.listen((_) => syncModalContent());

  btnIoImport.onClick.listen((_) {
    try {
      final text = textareaIo.value.trim();
      if (text.isEmpty) return;
      state.saveSnapshot();
      final (g, weighted, nodes) = switch (selectIoFormat.value) {
        'json' => GraphIO.importFromJson(text),
        _ => GraphIO.importFromMermaid(
          text,
          isDirected: state.primaryGraph.isDirected,
        ),
      };
      state.primaryGraph = g;
      state.isWeighted = weighted;
      state.nodes
        ..clear()
        ..addAll(nodes);
      ioStatus.textContent = 'Import successful!';
      updateUI();
      modalIo.style.display = 'none';
    } catch (e) {
      ioStatus.textContent = 'Import error: $e';
    }
  });

  btnExportCopy.onClick.listen((_) {
    web.window.navigator.clipboard.writeText(textareaIo.value);
    ioStatus.textContent = 'Copied to clipboard!';
  });

  btnExportDownload.onClick.listen((_) {
    switch (selectIoFormat.value) {
      case 'mermaid':
        GraphIO.downloadTextFile('graph.mmd', textareaIo.value, 'text/plain');
      case 'dot':
        GraphIO.downloadTextFile(
          'graph.dot',
          textareaIo.value,
          'text/vnd.graphviz',
        );
      case 'json':
        GraphIO.downloadTextFile(
          'graph.json',
          textareaIo.value,
          'application/json',
        );
    }
  });

  btnExportShare.onClick.listen((_) {
    final hash = GraphIO.exportToUrlHash(state);
    final fullUrl =
        '${web.window.location.origin}${web.window.location.pathname}#$hash';
    web.window.navigator.clipboard.writeText(fullUrl);
    ioStatus.textContent = 'Shareable URL copied to clipboard!';
  });

  // Resizable sidebar
  final sidebarResizer =
      web.document.querySelector('#sidebar-resizer') as web.HTMLElement?;
  final rightSidebar =
      web.document.querySelector('#right-sidebar') as web.HTMLElement?;
  if (sidebarResizer != null && rightSidebar != null) {
    var isResizing = false;
    var startX = 0.0;
    var startWidth = 320.0;

    sidebarResizer.onmousedown = ((web.MouseEvent e) {
      isResizing = true;
      startX = e.clientX.toDouble();
      startWidth = rightSidebar.getBoundingClientRect().width;
      sidebarResizer.classList.add('resizing');
      web.document.body?.style.cursor = 'col-resize';
      web.document.body?.style.userSelect = 'none';
      e.preventDefault();
    }).toJS;

    web.window.addEventListener(
      'mousemove',
      ((web.MouseEvent e) {
        if (!isResizing) return;
        final dx = startX - e.clientX.toDouble();
        final newWidth = (startWidth + dx).clamp(200.0, 700.0);
        rightSidebar.style.width = '${newWidth}px';
      }).toJS,
    );

    web.window.addEventListener(
      'mouseup',
      ((web.MouseEvent _) {
        if (!isResizing) return;
        isResizing = false;
        sidebarResizer.classList.remove('resizing');
        web.document.body?.style.cursor = '';
        web.document.body?.style.userSelect = '';
      }).toJS,
    );
  }

  updateUI();
}
