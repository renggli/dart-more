import 'dart:js_interop';

import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import 'app_ui.dart';
import 'io.dart';
import 'renderer.dart';
import 'state.dart';

/// Manages application toolbars, overlays, preset loading, modals, and window resize bars.
class ToolbarController {
  new({
    required this.state,
    required this.ui,
    required this.renderer,
    required this.onExecuteCommand,
    required this.onUpdateUI,
    required this.onRenderModifierStack,
  });

  final AppState state;
  final AppUi ui;
  final GraphRenderer renderer;
  final void Function(String cmdId) onExecuteCommand;
  final void Function() onUpdateUI;
  final void Function() onRenderModifierStack;

  // Zoom buttons
  final btnZoomIn =
      web.document.querySelector('#btn-zoom-in') as web.HTMLButtonElement;
  final btnZoomOut =
      web.document.querySelector('#btn-zoom-out') as web.HTMLButtonElement;
  final btnZoomFit =
      web.document.querySelector('#btn-zoom-fit') as web.HTMLButtonElement;

  // Mode and display buttons
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

  // Directedness select
  final selectDirectedness = web.document.querySelector(
    '#select-directedness',
  ) as web.HTMLSelectElement;

  // Modal elements
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

  bool dismissedEmpty = false;
  String ioMode = 'import';

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

  void closeModal() {
    modalIo.style.display = 'none';
  }

  void triggerOpenFile() {
    inputOpenFile?.click();
  }

  void updateCanvasStats() {
    final overlay = canvasStatsOverlay;
    if (overlay == null) return;
    if (!state.showStats) {
      overlay.style.display = 'none';
      return;
    }
    final graph = state.renderGraph;
    final vCount = graph.vertices.length;
    final eCount = graph.edges.toSet().length;
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
      overlay.style.display = 'none';
    } else {
      overlay.innerHTML = parts.map((p) => '<span>$p</span>').join('').toJS;
      overlay.style.display = 'block';
    }
  }

  void updateIntroOverlay() {
    final overlay = introOverlay;
    if (overlay == null) return;
    final isEmpty = state.primaryGraph.vertices.isEmpty;
    if (isEmpty && !dismissedEmpty) {
      overlay.style.display = 'flex';
    } else {
      overlay.style.display = 'none';
    }
  }

  static Graph<String, num> _unweightedPreset(
    Map<String, Iterable<String>> successors, {
    bool isDirected = false,
  }) => GraphFactory<String, num>(
    isDirected: isDirected,
    edgeProvider: (_, _) => 1,
  ).fromSuccessors(successors);

  static Graph<String, num> _weightedPreset(
    List<(String, String, num)> edges, {
    bool isDirected = false,
  }) {
    final g = Graph<String, num>(isDirected: isDirected);
    for (final (u, v, w) in edges) {
      g.addEdge(u, v, value: w);
    }
    return g;
  }

  static final Map<String, (bool, Graph<String, num> Function())> presets = {
    'koenigsberg': (
      false,
      () => _unweightedPreset({
        'Altstadt (North)': ['Krämerbrücke', 'Schmiedebrücke', 'Holzbrücke'],
        'Kneiphof (Island)': [
          'Krämerbrücke',
          'Schmiedebrücke',
          'Honigbrücke',
          'Grüne Brücke',
          'Köttelbrücke',
        ],
        'Vorstadt (South)': ['Grüne Brücke', 'Köttelbrücke', 'Hohe Brücke'],
        'Lomse (East)': ['Holzbrücke', 'Honigbrücke', 'Hohe Brücke'],
      }),
    ),
    'swiss': (
      true,
      () => _weightedPreset([
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
      ]),
    ),
    'petersen': (
      false,
      () => _unweightedPreset({
        for (var i = 0; i < 5; i++) 'v$i': ['v${(i + 1) % 5}', 'v${i + 5}'],
        for (var i = 0; i < 5; i++) 'v${i + 5}': ['v${(i + 2) % 5 + 5}'],
      }),
    ),
    'florentine': (
      false,
      () => _unweightedPreset({
        'Medici': [
          'Acciaiuoli',
          'Albizzi',
          'Barbadori',
          'Ridolfi',
          'Tornabuoni',
          'Salviati',
        ],
        'Castellani': ['Barbadori', 'Peruzzi', 'Strozzi'],
        'Peruzzi': ['Strozzi', 'Bischeri'],
        'Strozzi': ['Bischeri', 'Ridolfi'],
        'Albizzi': ['Ginori', 'Guadagni'],
        'Salviati': ['Pazzi'],
        'Bischeri': ['Guadagni'],
        'Guadagni': ['Lamberteschi', 'Tornabuoni'],
        'Ridolfi': ['Tornabuoni'],
      }),
    ),
    'arpanet': (
      false,
      () => _unweightedPreset({
        'SRI': ['UCLA', 'UCSB', 'UTAH'],
        'UCLA': ['UCSB', 'RAND'],
        'UCSB': ['SDC'],
        'RAND': ['SDC', 'BBN', 'BURROUGHS'],
        'UTAH': ['MIT', 'SDC'],
        'BBN': ['MIT', 'HARVARD', 'BURROUGHS'],
        'MIT': ['LINCOLN'],
        'HARVARD': ['CARNEGIE'],
        'CARNEGIE': ['CASE'],
        'CASE': ['LINCOLN'],
      }),
    ),
    'dodecahedron': (
      false,
      () => _unweightedPreset({
        'v1': ['v2', 'v5', 'v6'],
        'v2': ['v3', 'v7'],
        'v3': ['v4', 'v8'],
        'v4': ['v5', 'v9'],
        'v5': ['v10'],
        'v6': ['v11'],
        'v7': ['v12'],
        'v8': ['v13'],
        'v9': ['v14'],
        'v10': ['v15'],
        'v11': ['v12', 'v15', 'v16'],
        'v12': ['v13', 'v17'],
        'v13': ['v14', 'v18'],
        'v14': ['v15', 'v19'],
        'v15': ['v20'],
        'v16': ['v17', 'v20'],
        'v17': ['v18'],
        'v18': ['v19'],
        'v19': ['v20'],
      }),
    ),
    'dag': (
      false,
      () => _unweightedPreset({
        'CS 101': ['CS 102'],
        'Math 101': ['CS 102', 'Math 201'],
        'CS 102': ['CS 201', 'CS 202'],
        'Math 201': ['CS 301'],
        'CS 201': ['CS 301', 'CS 302'],
        'CS 202': ['CS 302'],
        'CS 301': ['CS 401'],
        'CS 302': ['CS 401'],
      }, isDirected: true),
    ),
    'flow': (
      true,
      () => _weightedPreset([
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
      ], isDirected: true),
    ),
    'web': (
      false,
      () => _unweightedPreset({
        'Home': ['About', 'Products', 'Blog'],
        'About': ['Home'],
        'Products': ['Details', 'Cart'],
        'Details': ['Products', 'Reviews'],
        'Reviews': ['Details', 'Home'],
        'Cart': ['Checkout'],
        'Checkout': ['Home'],
        'Blog': ['Home', 'Reviews'],
      }, isDirected: true),
    ),
    'karate': (
      false,
      () => _unweightedPreset({
        'Mr. Hi (1)': [
          '2',
          '3',
          '4',
          '5',
          '6',
          '7',
          '8',
          '9',
          '11',
          '12',
          '13',
          '14',
          '18',
          '20',
          '22',
          '32',
        ],
        '2': ['3', '4', '8', '14', '18', '20', '22', '31'],
        '3': ['4', '8', '9', '10', '14', '28', '29', '33'],
        '4': ['8', '13', '14'],
        '5': ['7', '11'],
        '6': ['7', '11', '17'],
        '7': ['17'],
        '9': ['31', '33', '34 (John A)'],
        '10': ['34 (John A)'],
        '14': ['34 (John A)'],
        '15': ['33', '34 (John A)'],
        '16': ['33', '34 (John A)'],
        '19': ['33', '34 (John A)'],
        '20': ['34 (John A)'],
        '21': ['33', '34 (John A)'],
        '23': ['33', '34 (John A)'],
        '24': ['26', '28', '30', '33', '34 (John A)'],
        '25': ['26', '28', '32'],
        '26': ['32'],
        '27': ['30', '34 (John A)'],
        '28': ['34 (John A)'],
        '29': ['32', '34 (John A)'],
        '30': ['33', '34 (John A)'],
        '31': ['33', '34 (John A)'],
        '32': ['33', '34 (John A)'],
        '33': ['34 (John A)'],
      }),
    ),
    'les_miserables': (
      true,
      () => _weightedPreset([
        ('Valjean', 'Myriel', 5),
        ('Valjean', 'Fantine', 9),
        ('Valjean', 'Cosette', 31),
        ('Valjean', 'Javert', 17),
        ('Valjean', 'Thenardier', 12),
        ('Valjean', 'Mme Thenardier', 7),
        ('Valjean', 'Marius', 19),
        ('Valjean', 'Enjolras', 4),
        ('Valjean', 'Fauchelevent', 8),
        ('Valjean', 'Bamatabois', 2),
        ('Valjean', 'Gillenormand', 2),
        ('Valjean', 'Gavroche', 1),
        ('Myriel', 'Mlle Baptistine', 8),
        ('Myriel', 'Mme Magloire', 10),
        ('Mlle Baptistine', 'Mme Magloire', 6),
        ('Fantine', 'Tholomyes', 4),
        ('Fantine', 'Blacheville', 3),
        ('Fantine', 'Favourite', 4),
        ('Fantine', 'Dahlia', 4),
        ('Fantine', 'Zephine', 4),
        ('Fantine', 'Thenardier', 2),
        ('Fantine', 'Mme Thenardier', 2),
        ('Fantine', 'Javert', 5),
        ('Fantine', 'Bamatabois', 1),
        ('Tholomyes', 'Blacheville', 4),
        ('Tholomyes', 'Favourite', 4),
        ('Tholomyes', 'Dahlia', 4),
        ('Tholomyes', 'Zephine', 4),
        ('Blacheville', 'Favourite', 4),
        ('Blacheville', 'Dahlia', 4),
        ('Blacheville', 'Zephine', 4),
        ('Favourite', 'Dahlia', 5),
        ('Favourite', 'Zephine', 4),
        ('Dahlia', 'Zephine', 4),
        ('Cosette', 'Marius', 21),
        ('Cosette', 'Thenardier', 4),
        ('Cosette', 'Mme Thenardier', 4),
        ('Cosette', 'Javert', 1),
        ('Cosette', 'Gillenormand', 3),
        ('Cosette', 'Mlle Gillenormand', 2),
        ('Thenardier', 'Mme Thenardier', 13),
        ('Thenardier', 'Eponine', 5),
        ('Thenardier', 'Gavroche', 1),
        ('Thenardier', 'Javert', 5),
        ('Thenardier', 'Marius', 2),
        ('Thenardier', 'Babet', 6),
        ('Thenardier', 'Gueulemer', 6),
        ('Thenardier', 'Claquesous', 4),
        ('Thenardier', 'Montparnasse', 2),
        ('Mme Thenardier', 'Eponine', 2),
        ('Babet', 'Gueulemer', 6),
        ('Babet', 'Claquesous', 4),
        ('Babet', 'Montparnasse', 2),
        ('Gueulemer', 'Claquesous', 4),
        ('Gueulemer', 'Montparnasse', 2),
        ('Claquesous', 'Montparnasse', 2),
        ('Javert', 'Enjolras', 1),
        ('Javert', 'Gavroche', 1),
        ('Marius', 'Eponine', 5),
        ('Marius', 'Enjolras', 7),
        ('Marius', 'Courfeyrac', 9),
        ('Marius', 'Combeferre', 5),
        ('Marius', 'Bossuet', 5),
        ('Marius', 'Gavroche', 4),
        ('Marius', 'Gillenormand', 6),
        ('Marius', 'Mlle Gillenormand', 6),
        ('Gillenormand', 'Mlle Gillenormand', 9),
        ('Enjolras', 'Courfeyrac', 17),
        ('Enjolras', 'Combeferre', 15),
        ('Enjolras', 'Bossuet', 12),
        ('Enjolras', 'Gavroche', 7),
        ('Enjolras', 'Grantaire', 3),
        ('Courfeyrac', 'Combeferre', 13),
        ('Courfeyrac', 'Bossuet', 11),
        ('Courfeyrac', 'Gavroche', 7),
        ('Courfeyrac', 'Eponine', 2),
        ('Combeferre', 'Bossuet', 9),
        ('Combeferre', 'Gavroche', 6),
        ('Bossuet', 'Gavroche', 5),
        ('Bossuet', 'Grantaire', 3),
        ('Gavroche', 'Grantaire', 1),
      ]),
    ),
    'southern_women': (
      false,
      () => _unweightedPreset({
        'Evelyn': ['E1', 'E2', 'E3', 'E4', 'E5', 'E6', 'E8', 'E9'],
        'Laura': ['E1', 'E2', 'E3', 'E5', 'E6', 'E7', 'E8'],
        'Theresa': ['E2', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8', 'E9'],
        'Brenda': ['E1', 'E3', 'E4', 'E5', 'E6', 'E7', 'E8'],
        'Charlotte': ['E3', 'E4', 'E5', 'E7'],
        'Frances': ['E3', 'E5', 'E6', 'E8'],
        'Eleanor': ['E5', 'E6', 'E7', 'E8'],
        'Pearl': ['E6', 'E8', 'E9'],
        'Ruth': ['E5', 'E7', 'E8', 'E9'],
        'Verne': ['E7', 'E8', 'E9', 'E12'],
        'Myra': ['E8', 'E9', 'E10', 'E12'],
        'Katherine': ['E8', 'E9', 'E10', 'E12', 'E13', 'E14'],
        'Sylvia': ['E7', 'E8', 'E9', 'E10', 'E12', 'E13', 'E14'],
        'Nora': ['E6', 'E7', 'E9', 'E10', 'E11', 'E12', 'E13', 'E14'],
        'Helen': ['E7', 'E8', 'E10', 'E11', 'E12'],
        'Dorothy': ['E8', 'E9'],
        'Olivia': ['E9', 'E11'],
        'Flora': ['E9', 'E11'],
      }),
    ),
  };

  void loadPreset(String preset) {
    state.saveSnapshot();
    final (weighted, builder) = presets[preset] ?? presets['petersen']!;
    state.isWeighted = weighted;
    state.primaryGraph = builder();
    state.nodes.clear();
    state.syncNodes();
    state.clearSelection();
    renderer.autoLayout(state);
    state.addAllModifiersDisabled();
    state.evaluateModifiers();
    onUpdateUI();
    onRenderModifierStack();
    btnZoomFit.click();
  }

  void init() {
    btnZoomIn.onClick.listen((_) => renderer.zoomIn());
    btnZoomOut.onClick.listen((_) => renderer.zoomOut());
    btnZoomFit.onClick.listen((_) => renderer.resetView());

    btnModeVertex.onClick.listen((_) {
      onExecuteCommand('select.mode_vertex');
    });

    btnModeEdge.onClick.listen((_) {
      onExecuteCommand('select.mode_edge');
    });

    btnToggleStats?.onClick.listen((_) {
      state.showStats = !state.showStats;
      onUpdateUI();
    });

    btnToggleLabels?.onClick.listen((_) {
      state.showLabels = !state.showLabels;
      onUpdateUI();
    });

    btnToggleWeights?.onClick.listen((_) {
      state.isWeighted = !state.isWeighted;
      onUpdateUI();
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
      inputOpenFile!.onChange.listen((_) {
        final files = inputOpenFile!.files;
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
                  onUpdateUI();
                  onRenderModifierStack();
                } catch (_) {}
              }
            }).toJS;
            reader.readAsText(file);
          }
          inputOpenFile!.value = '';
        }
      });
    }

    selectDirectedness.onChange.listen((_) {
      final wantDirected = selectDirectedness.value == 'directed';
      if (wantDirected != state.primaryGraph.isDirected) {
        state.setDirected(wantDirected);
        onUpdateUI();
      }
    });

    btnCloseModal.onClick.listen((_) => closeModal());
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
        onUpdateUI();
        closeModal();
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
      var startWidth = 360.0;

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
  }
}
