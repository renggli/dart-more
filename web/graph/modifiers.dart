import 'dart:math' as math;

import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import 'dom_utils.dart';
import 'layout.dart';
import 'state.dart';

/// Tabular data emitted by a modifier to be presented in the bottom drawer.
class ModifierTableData {
  const new({required this.title, required this.headers, required this.rows});

  final String title;
  final List<String> headers;
  final List<List<String>> rows;
}

/// Output computed by applying a modifier to the pipeline graph.
class ModifierOutput {
  const new({
    this.transformedGraph,
    this.overlay,
    this.tableData,
    this.statusSummary,
    this.errorMessage,
    this.hasError = false,
  });

  /// If non-null, this transformed graph replaces the pipeline graph for subsequent modifiers and rendering.
  final Graph<String, num>? transformedGraph;

  /// Extra visualization overlay (path, heatmap, or partition coloring) on the canvas.
  final VisualOverlay? overlay;

  /// Live tabular data to expose in the bottom drawer.
  final ModifierTableData? tableData;

  /// Brief status description for display in the modifier card and badge.
  final String? statusSummary;

  /// Human-readable error description when this modifier failed.
  final String? errorMessage;

  /// Whether this modifier failed during execution.
  final bool hasError;
}

/// Base contract for all graph modifiers in the non-destructive modifier stack.
abstract class GraphModifier {
  new({bool? enabled}) : enabled = enabled ?? true;

  String get id;
  String get name;
  String get category;
  bool enabled;
  bool collapsed = false;

  /// Whether this modifier is permanently pinned at index 0 (e.g. BaseGraphModifier).
  bool get isPinned => false;

  /// Whether this modifier can be baked permanently into the base graph.
  bool get canApply => false;

  /// Bakes changes permanently into the base graph and removes itself from the stack.
  void applyPermanent(AppState state) {}

  /// Hook called whenever the active graph or pipeline state updates.
  void updateConfig(AppState state) {}

  /// Builds configuration UI controls inside the modifier card (accessible, stacked vertically).
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified);

  /// Executes this modifier in the pipeline over [graph].
  ModifierOutput apply(Graph<String, num> graph, AppState state);
}

// ---------------------------------------------------------------------------
// Helpers for Accessible Vertically-Stacked Form Rows
// ---------------------------------------------------------------------------

web.HTMLElement _field(String labelText, web.HTMLElement control) {
  final group = div('form-field-stacked');
  group.appendChild(label(labelText)..style.fontWeight = '500');
  group.appendChild(control);
  return group;
}

web.HTMLSelectElement _colorSelect(
  String initial,
  void Function(String) onChange,
) {
  final s = selectElement();
  final colors = [
    ('#ef4444', 'Red (#ef4444)'),
    ('#f97316', 'Orange (#f97316)'),
    ('#f59e0b', 'Amber (#f59e0b)'),
    ('#10b981', 'Emerald (#10b981)'),
    ('#06b6d4', 'Cyan (#06b6d4)'),
    ('#38bdf8', 'Sky Blue (#38bdf8)'),
    ('#3b82f6', 'Blue (#3b82f6)'),
    ('#ec4899', 'Pink (#ec4899)'),
    ('#94a3b8', 'Slate Gray (#94a3b8)'),
  ];
  for (final (val, name) in colors) {
    s.appendChild(optionElement(val, name));
  }
  s.value = initial;
  s.onChange.listen((_) => onChange(s.value));
  return s;
}

web.HTMLSelectElement _patternSelect(
  String initial,
  void Function(String) onChange,
) {
  final s = selectElement();
  final patterns = [
    ('6,4', 'Dashed (6, 4)'),
    ('2,3', 'Dotted (2, 3)'),
    ('10,4', 'Long Dash (10, 4)'),
    ('8,3,2,3', 'Dash-Dot (8, 3, 2, 3)'),
    ('none', 'Solid Line'),
  ];
  for (final (val, name) in patterns) {
    s.appendChild(optionElement(val, name));
  }
  s.value = initial;
  s.onChange.listen((_) => onChange(s.value));
  return s;
}

web.HTMLSelectElement _vertexSelect(
  AppState state,
  String? currentVal,
  String defaultLabel,
  void Function(String?) onChange,
) {
  final s = selectElement();
  s.className = 'vertex-select';
  s.setAttribute('data-default', defaultLabel);
  s.appendChild(optionElement('', defaultLabel));
  for (final v in state.renderGraph.vertices) {
    s.appendChild(optionElement(v, v));
  }
  s.value = currentVal ?? '';
  s.onChange.listen((_) {
    onChange(s.value.isEmpty ? null : s.value);
  });
  return s;
}

// ---------------------------------------------------------------------------
// 0. Base Graph Modifier (Pinned at Index 0)
// ---------------------------------------------------------------------------

class BaseGraphModifier extends GraphModifier {
  new() : super(enabled: true);

  @override
  String get id => 'base_graph';

  @override
  String get name => 'Base Graph';

  @override
  String get category => 'Sources';

  @override
  bool get isPinned => true;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final container = div('form-column');

    final dirSelect = selectElement();
    dirSelect.appendChild(optionElement('directed', 'Directed Graph'));
    dirSelect.appendChild(optionElement('undirected', 'Undirected Graph'));
    dirSelect.value = state.primaryGraph.isDirected ? 'directed' : 'undirected';
    dirSelect.onChange.listen((_) {
      final wantDirected = dirSelect.value == 'directed';
      if (wantDirected != state.primaryGraph.isDirected) {
        state.saveSnapshot();
        final newG = Graph<String, num>(isDirected: wantDirected);
        for (final v in state.primaryGraph.vertices) {
          newG.addVertex(v);
        }
        for (final e in state.primaryGraph.edges) {
          newG.addEdge(e.source, e.target, value: e.value);
        }
        state.primaryGraph = newG;
        onModified();
      }
    });
    container.appendChild(_field('Graph Directness:', dirSelect));

    final statsInfo = div()
      ..style.fontSize = '11px'
      ..style.color = 'var(--text-muted)'
      ..style.marginTop = '2px'
      ..textContent =
          'Editable in canvas: ${state.primaryGraph.vertices.length} vertices, ${state.primaryGraph.edges.length} edges';
    container.appendChild(statsInfo);

    final actionRow = div('form-row')
      ..style.marginTop = '8px'
      ..style.alignItems = 'center'
      ..style.justifyContent = 'space-between';

    final btnImport = button('Import...', 'button-small button-outline')
      ..title = 'Import graph from JSON, DSL, DOT, or Dart'
      ..onClick.listen((_) {
        final modalBtn = web.document.querySelector(
          '#btn-io-modal',
        ) as web.HTMLButtonElement?;
        modalBtn?.click();
      });
    actionRow.appendChild(btnImport);

    final btnClear = button('Clear Graph', 'btn-clear-subtle')
      ..title = 'Clear all vertices and edges'
      ..onClick.listen((_) {
        state.saveSnapshot();
        state.primaryGraph = Graph<String, num>(
          isDirected: state.primaryGraph.isDirected,
        );
        state.selectedVertices.clear();
        state.selectedEdges.clear();
        state.activeVertex = null;
        state.selectedSource = null;
        state.selectedTarget = null;
        state.activeOverlay = null;
        onModified();
      });
    actionRow.appendChild(btnClear);
    container.appendChild(actionRow);

    return container;
  }

  @override
  ModifierOutput apply(
    Graph<String, num> graph,
    AppState state,
  ) => ModifierOutput(
    transformedGraph: state.primaryGraph,
    statusSummary:
        '${state.primaryGraph.vertices.length} vertices, ${state.primaryGraph.edges.length} edges',
  );
}

// ---------------------------------------------------------------------------
// 1. Generator Modifier (Adds or replaces graphs, can be applied)
// ---------------------------------------------------------------------------

class GeneratorModifier extends GraphModifier {
  new({super.enabled, String? type})
    : type = type ?? 'complete',
      count = 5,
      combineMode = 'union';

  String type; // complete, cycle, star, tree, bipartite, random
  int count;
  int arity = 2;
  double prob = 0.35;
  String combineMode; // 'union' or 'replace'

  @override
  String get id => 'generator';

  @override
  String get name => 'Graph Generator';

  @override
  String get category => 'Generators';

  @override
  bool get canApply => true;

  @override
  void applyPermanent(AppState state) {
    final out = apply(state.primaryGraph, state);
    if (out.transformedGraph != null) {
      state.saveSnapshot();
      state.primaryGraph = out.transformedGraph!;
      state.syncNodes();
      state.modifiers.remove(this);
    }
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final container = div('form-column');

    final typeSelect = selectElement();
    typeSelect.appendChild(optionElement('complete', 'Complete Graph (Kn)'));
    typeSelect.appendChild(optionElement('cycle', 'Cycle Graph (Cn)'));
    typeSelect.appendChild(optionElement('star', 'Star Graph (Sn)'));
    typeSelect.appendChild(optionElement('path', 'Path Graph (Pn)'));
    typeSelect.appendChild(optionElement('tree', 'm-ary Tree'));
    typeSelect.appendChild(
      optionElement('bipartite', 'Bipartite Graph (Km,n)'),
    );
    typeSelect.appendChild(optionElement('grid', '2D Grid Graph'));
    typeSelect.appendChild(optionElement('random', 'Erdős–Rényi Random'));
    typeSelect.value = type;
    typeSelect.onChange.listen((_) {
      type = typeSelect.value;
      onModified();
    });
    container.appendChild(_field('Preset Shape:', typeSelect));

    final countInput = numberInput(count, 3, 50);
    countInput.onInput.listen((_) {
      final val = int.tryParse(countInput.value);
      if (val != null && val >= 3) {
        count = val;
        onModified();
      }
    });
    container.appendChild(_field('Vertex Count (n):', countInput));

    if (type == 'tree') {
      final arityInput = numberInput(arity, 2, 5);
      arityInput.onInput.listen((_) {
        final val = int.tryParse(arityInput.value);
        if (val != null && val >= 2) {
          arity = val;
          onModified();
        }
      });
      container.appendChild(_field('Branching (m):', arityInput));
    } else if (type == 'random') {
      final probInput = numberInput(prob, 0.05, 1.0)
        ..step = '0.05'
        ..value = prob.toString();
      probInput.onInput.listen((_) {
        final val = double.tryParse(probInput.value);
        if (val != null && val > 0 && val <= 1.0) {
          prob = val;
          onModified();
        }
      });
      container.appendChild(_field('Edge Probability (p):', probInput));
    }

    final modeSelect = selectElement();
    modeSelect.appendChild(optionElement('union', 'Union (Add to existing)'));
    modeSelect.appendChild(optionElement('replace', 'Replace existing graph'));
    modeSelect.value = combineMode;
    modeSelect.onChange.listen((_) {
      combineMode = modeSelect.value;
      onModified();
    });
    container.appendChild(_field('Combine Mode:', modeSelect));

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final generated = Graph<String, num>(isDirected: graph.isDirected);
    final prefix = combineMode == 'union' ? 'G${count}_' : '';

    if (type == 'complete') {
      final vList = [for (var i = 0; i < count; i++) '$prefix${i + 1}'];
      for (final v in vList) {
        generated.addVertex(v);
      }
      for (var i = 0; i < vList.length; i++) {
        for (var j = i + 1; j < vList.length; j++) {
          generated.addEdge(vList[i], vList[j], value: 1);
          if (graph.isDirected) {
            generated.addEdge(vList[j], vList[i], value: 1);
          }
        }
      }
    } else if (type == 'cycle') {
      final vList = [for (var i = 0; i < count; i++) '$prefix${i + 1}'];
      for (final v in vList) {
        generated.addVertex(v);
      }
      for (var i = 0; i < vList.length; i++) {
        final next = (i + 1) % vList.length;
        generated.addEdge(vList[i], vList[next], value: 1);
      }
    } else if (type == 'star') {
      final center = '${prefix}Center';
      generated.addVertex(center);
      for (var i = 1; i < count; i++) {
        final leaf = '$prefix$i';
        generated.addVertex(leaf);
        generated.addEdge(center, leaf, value: 1);
      }
    } else if (type == 'tree') {
      final vList = [for (var i = 0; i < count; i++) '$prefix${i + 1}'];
      for (final v in vList) {
        generated.addVertex(v);
      }
      for (var i = 1; i < vList.length; i++) {
        final parentIdx = (i - 1) ~/ arity;
        generated.addEdge(vList[parentIdx], vList[i], value: 1);
      }
    } else if (type == 'bipartite') {
      final half = count ~/ 2;
      final partA = [for (var i = 0; i < half; i++) '${prefix}A${i + 1}'];
      final partB = [
        for (var j = 0; j < count - half; j++) '${prefix}B${j + 1}',
      ];
      for (final a in partA) {
        generated.addVertex(a);
      }
      for (final b in partB) {
        generated.addVertex(b);
      }
      for (final a in partA) {
        for (final b in partB) {
          generated.addEdge(a, b, value: 1);
        }
      }
    } else if (type == 'path') {
      final vList = [for (var i = 0; i < count; i++) '$prefix${i + 1}'];
      for (final v in vList) {
        generated.addVertex(v);
      }
      for (var i = 0; i < vList.length - 1; i++) {
        generated.addEdge(vList[i], vList[i + 1], value: 1);
        if (graph.isDirected) {
          generated.addEdge(vList[i + 1], vList[i], value: 1);
        }
      }
    } else if (type == 'grid') {
      final cols = math.max(1, math.sqrt(count).ceil());
      final vList = [for (var i = 0; i < count; i++) '$prefix${i + 1}'];
      for (final v in vList) {
        generated.addVertex(v);
      }
      for (var i = 0; i < count; i++) {
        final c = i % cols;
        if (c + 1 < cols && i + 1 < count) {
          generated.addEdge(vList[i], vList[i + 1], value: 1);
          if (graph.isDirected) {
            generated.addEdge(vList[i + 1], vList[i], value: 1);
          }
        }
        if (i + cols < count) {
          generated.addEdge(vList[i], vList[i + cols], value: 1);
          if (graph.isDirected) {
            generated.addEdge(vList[i + cols], vList[i], value: 1);
          }
        }
      }
    } else if (type == 'random') {
      final rnd = math.Random(count + 42);
      final vList = [for (var i = 0; i < count; i++) '$prefix${i + 1}'];
      for (final v in vList) {
        generated.addVertex(v);
      }
      for (var i = 0; i < vList.length; i++) {
        for (var j = i + 1; j < vList.length; j++) {
          if (rnd.nextDouble() <= prob) {
            generated.addEdge(vList[i], vList[j], value: 1);
            if (graph.isDirected && rnd.nextBool()) {
              generated.addEdge(vList[j], vList[i], value: 1);
            }
          }
        }
      }
    }

    // Calculate layout coordinates for all generated vertices for live preview
    const cx = 420.0;
    const cy = 280.0;
    final radius = math.max(120.0, count * 22.0);
    final generatedVertices = generated.vertices.toList();

    for (var i = 0; i < generatedVertices.length; i++) {
      final v = generatedVertices[i];
      final node = state.getOrCreateNode(v);
      if (node.x == null || node.y == null || combineMode == 'replace') {
        if (type == 'star') {
          if (i == 0) {
            node.x = cx;
            node.y = cy;
          } else {
            final angle = (2 * math.pi * (i - 1) / (count - 1)) - (math.pi / 2);
            node.x = cx + radius * math.cos(angle);
            node.y = cy + radius * math.sin(angle);
          }
        } else if (type == 'bipartite') {
          final half = count ~/ 2;
          if (i < half) {
            node.x = cx - 140.0;
            node.y = cy - (half * 25.0) + (i * 50.0);
          } else {
            final j = i - half;
            node.x = cx + 140.0;
            node.y = cy - ((count - half) * 25.0) + (j * 50.0);
          }
        } else if (type == 'grid') {
          final cols = math.max(1, math.sqrt(count).ceil());
          final r = i ~/ cols;
          final c = i % cols;
          node.x = cx - (cols * 40.0) + (c * 80.0);
          node.y = cy - 100.0 + (r * 70.0);
        } else if (type == 'path') {
          node.x = cx - (count * 35.0) + (i * 70.0);
          node.y = cy;
        } else {
          final angle =
              (2 * math.pi * i / math.max(1, generatedVertices.length)) -
              (math.pi / 2);
          node.x = cx + radius * math.cos(angle);
          node.y = cy + radius * math.sin(angle);
        }
      }
    }

    if (combineMode == 'replace') {
      return ModifierOutput(
        transformedGraph: generated,
        statusSummary: 'Generated $type ($count vertices) [Replace]',
      );
    }

    // Union with current pipeline graph
    final combined = Graph<String, num>(isDirected: graph.isDirected);
    for (final v in graph.vertices) {
      combined.addVertex(v);
    }
    for (final e in graph.edges) {
      combined.addEdge(e.source, e.target, value: e.value);
    }
    for (final v in generated.vertices) {
      combined.addVertex(v);
    }
    for (final e in generated.edges) {
      combined.addEdge(e.source, e.target, value: e.value);
    }

    return ModifierOutput(
      transformedGraph: combined,
      statusSummary: 'Union +$type ($count vertices)',
    );
  }
}

// ---------------------------------------------------------------------------
// 2. Layout Modifier (Rearranges vertices non-destructively, can be applied)
// ---------------------------------------------------------------------------

class LayoutModifier extends GraphModifier {
  new({
    super.enabled,
    String? algorithm,
    String? rankDir,
    this.vertexDistance = 40.0,
    this.layerDistance = 80.0,
    this.iterations = 100,
    this.columns = 0,
    this.seed = 42,
  }) : algorithm = algorithm ?? 'stress',
       rankDir = rankDir ?? 'TB';

  String algorithm;
  String rankDir;
  double vertexDistance;
  double layerDistance;
  int iterations;
  int columns;
  int seed;

  @override
  String get id => 'layout';

  @override
  String get name => 'Layout';

  @override
  String get category => 'Layout';

  @override
  bool get canApply => true;

  @override
  void applyPermanent(AppState state) {
    apply(state.renderGraph, state);
    state.saveSnapshot();
    state.modifiers.remove(this);
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final container = div('form-column');

    final selectAlgo = selectElement();
    for (final engine in LayoutEngine.values) {
      selectAlgo.appendChild(optionElement(engine.id, engine.label));
    }

    selectAlgo.value = algorithm;
    selectAlgo.onChange.listen((_) {
      algorithm = selectAlgo.value;
      onModified();
    });
    container.appendChild(_field('Layout Algorithm:', selectAlgo));

    // Spacing / Vertex Distance control (applicable to all layouts)
    final spacingInput = numberInput(vertexDistance, 10, 200);
    spacingInput.onChange.listen((_) {
      vertexDistance = double.tryParse(spacingInput.value) ?? 40.0;
      onModified();
    });
    container.appendChild(_field('Node Spacing (px):', spacingInput));

    // Directional layout controls
    if (algorithm == 'layered' ||
        algorithm == 'tree' ||
        algorithm == 'bipartite') {
      final selectRank = selectElement();
      for (final dir in RankDir.values) {
        selectRank.appendChild(
          optionElement(dir.id, '${dir.label} (${dir.id})'),
        );
      }
      selectRank.value = rankDir;
      selectRank.onChange.listen((_) {
        rankDir = selectRank.value;
        onModified();
      });
      container.appendChild(_field('Flow Direction:', selectRank));

      final layerInput = numberInput(layerDistance, 20, 300);
      layerInput.onChange.listen((_) {
        layerDistance = double.tryParse(layerInput.value) ?? 80.0;
        onModified();
      });
      container.appendChild(_field('Layer Distance (px):', layerInput));
    }

    // Iterative simulation controls
    if (algorithm == 'stress' ||
        algorithm == 'force' ||
        algorithm == 'spectral') {
      final iterInput = numberInput(iterations, 10, 500);
      iterInput.onChange.listen((_) {
        iterations = int.tryParse(iterInput.value) ?? 100;
        onModified();
      });
      container.appendChild(_field('Iterations:', iterInput));
    }

    // Grid columns control
    if (algorithm == 'grid') {
      final colInput = numberInput(columns, 0, 20);
      colInput.onChange.listen((_) {
        columns = int.tryParse(colInput.value) ?? 0;
        onModified();
      });
      container.appendChild(_field('Columns (0 for auto):', colInput));
    }

    // Seed control
    if (algorithm == 'random' ||
        algorithm == 'stress' ||
        algorithm == 'force') {
      final seedInput = numberInput(seed, 0, 999999);
      seedInput.onChange.listen((_) {
        seed = int.tryParse(seedInput.value) ?? 42;
        onModified();
      });
      container.appendChild(_field('Random Seed:', seedInput));
    }

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    GraphLayout.applyLayout(
      state,
      engine: algorithm,
      rankdir: rankDir,
      vertexDistance: vertexDistance,
      layerDistance: layerDistance,
      iterations: iterations,
      columns: columns > 0 ? columns : null,
      seed: seed,
    );

    return ModifierOutput(statusSummary: 'Layout applied: $algorithm');
  }
}

// ---------------------------------------------------------------------------
// 3. Shortest Path & Traversal Modifier
// ---------------------------------------------------------------------------

class ShortestPathModifier extends GraphModifier {
  new({super.enabled});

  String algorithm = 'dijkstra';
  String? sourceVertex;
  String? targetVertex;
  String pathColor = '#38bdf8';
  String pathPattern = 'none';

  @override
  String get id => 'shortest_path';

  @override
  String get name => 'Shortest Path / Traversal';

  @override
  String get category => 'Path & Search';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final algoSelect = selectElement();
    algoSelect.appendChild(optionElement('dijkstra', 'Dijkstra'));
    algoSelect.appendChild(optionElement('a_star', 'A* Search'));
    algoSelect.appendChild(optionElement('bellman_ford', 'Bellman-Ford'));
    algoSelect.appendChild(optionElement('bfs', 'Breadth-First'));
    algoSelect.appendChild(optionElement('dfs', 'Depth-First'));
    algoSelect.value = algorithm;
    algoSelect.onChange.listen((_) {
      algorithm = algoSelect.value;
      onModified();
    });
    root.appendChild(_field('Algorithm:', algoSelect));

    final srcSelect = _vertexSelect(state, sourceVertex, '(Selected / First)', (
      v,
    ) {
      sourceVertex = v;
      onModified();
    });
    root.appendChild(_field('Source Vertex:', srcSelect));

    final tgtSelect = _vertexSelect(
      state,
      targetVertex,
      '(Selected Target / Last)',
      (v) {
        targetVertex = v;
        onModified();
      },
    );
    root.appendChild(_field('Target Vertex:', tgtSelect));

    root.appendChild(
      _field(
        'Path Color:',
        _colorSelect(pathColor, (c) {
          pathColor = c;
          onModified();
        }),
      ),
    );

    root.appendChild(
      _field(
        'Line Pattern:',
        _patternSelect(pathPattern, (p) {
          pathPattern = p;
          onModified();
        }),
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    final src =
        sourceVertex ??
        state.selectedSource ??
        (state.selectedVertices.isNotEmpty
            ? state.selectedVertices.first
            : vertices.first);
    final tgt =
        targetVertex ??
        state.selectedTarget ??
        (state.selectedVertices.length > 1
            ? state.selectedVertices.last
            : vertices.last);

    if (!graph.containsVertex(src) || !graph.containsVertex(tgt)) {
      return ModifierOutput(
        statusSummary: 'Select valid endpoints ($src → $tgt)',
      );
    }

    Path<String, num>? path;
    try {
      switch (algorithm) {
        case 'bellman_ford':
          path = graph.shortestPath(
            src,
            tgt,
            hasNegativeEdges: true,
            edgeCost: (String u, String v) => graph.getEdge(u, v)?.value ?? 1,
          );
        case 'a_star':
          path = graph.shortestPath(
            src,
            tgt,
            costEstimate: (String v) => 0,
            edgeCost: (String u, String v) => graph.getEdge(u, v)?.value ?? 1,
          );
        case 'bfs':
          path = graph.shortestPath(
            src,
            tgt,
            edgeCost: (String u, String v) => 1,
          );
        case 'dfs':
          final visited = <String>{src};
          final parent = <String, String>{};
          final stack = <String>[src];
          var found = false;
          while (stack.isNotEmpty && !found) {
            final curr = stack.removeLast();
            if (curr == tgt) {
              found = true;
              break;
            }
            for (final next in graph.successorsOf(curr)) {
              if (visited.add(next)) {
                parent[next] = curr;
                stack.add(next);
                if (next == tgt) {
                  found = true;
                  break;
                }
              }
            }
          }
          if (found) {
            final rev = <String>[tgt];
            var c = tgt;
            while (c != src && parent.containsKey(c)) {
              c = parent[c]!;
              rev.add(c);
            }
            final verts = rev.reversed.toList();
            final edges = <Edge<String, num>>[];
            for (var i = 0; i < verts.length - 1; i++) {
              final u = verts[i];
              final v = verts[i + 1];
              final e =
                  graph.getEdge(u, v) ??
                  (!graph.isDirected ? graph.getEdge(v, u) : null);
              edges.add(
                e ??
                    (graph.isDirected
                        ? Edge.directed(u, v, value: 1)
                        : Edge.undirected(u, v, value: 1)),
              );
            }
            if (edges.isNotEmpty) {
              path = Path.fromEdges(edges);
            }
          }
        case 'dijkstra':
        default:
          path = graph.shortestPath(
            src,
            tgt,
            edgeCost: (String u, String v) => graph.getEdge(u, v)?.value ?? 1,
          );
      }
    } catch (e) {
      return ModifierOutput(hasError: true, errorMessage: e.toString());
    }

    if (path == null) {
      return ModifierOutput(statusSummary: 'No path found ($src → $tgt)');
    }

    final pathVertices = path.vertices.toList();
    final pathEdges = <(String, String)>[];
    for (var i = 0; i < pathVertices.length - 1; i++) {
      final edgeKey = (pathVertices[i], pathVertices[i + 1]);
      pathEdges.add(edgeKey);
      final edgeStyle = state.getEdgeStyle(edgeKey.$1, edgeKey.$2);
      edgeStyle.color = pathColor;
      edgeStyle.strokeWidth = 3.0;
    }

    for (final v in pathVertices) {
      final node = state.nodes[v];
      if (node != null) {
        node.style.borderColor = pathColor;
        node.style.borderWidth = 2.5;
      }
    }

    final overlay = PathOverlay(
      vertices: pathVertices,
      edges: pathEdges,
      title: 'Path: $src → $tgt',
    );

    return ModifierOutput(
      overlay: overlay,
      statusSummary: 'Path found: ${pathVertices.join(" → ")}',
      tableData: ModifierTableData(
        title: 'Shortest Path ($src → $tgt)',
        headers: ['Step', 'Vertex', 'Cumulative Weight'],
        rows: [
          for (var i = 0; i < pathVertices.length; i++)
            ['#$i', pathVertices[i], '${path.cost}'],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 4. Centrality Heatmap Modifier (Guarded Against NaN & Non-Convergence)
// ---------------------------------------------------------------------------

class CentralityModifier extends GraphModifier {
  new({super.enabled});

  String metric = 'betweenness';

  @override
  String get id => 'centrality';

  @override
  String get name => 'Centrality Heatmap';

  @override
  String get category => 'Metrics & Analysis';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final select = selectElement();
    select.appendChild(optionElement('betweenness', 'Betweenness Centrality'));
    select.appendChild(optionElement('pagerank', 'PageRank'));
    select.appendChild(optionElement('degree', 'Degree Centrality'));
    select.appendChild(optionElement('eigenvector', 'Eigenvector Centrality'));
    select.value = metric;
    select.onChange.listen((_) {
      metric = select.value;
      onModified();
    });
    root.appendChild(_field('Centrality Metric:', select));

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    Map<String, num> scores;
    try {
      switch (metric) {
        case 'betweenness':
          scores = graph.betweennessCentrality();
        case 'pagerank':
          scores = graph.pageRank();
        case 'eigenvector':
          scores = graph.eigenvectorCentrality();
        case 'degree':
        default:
          scores = graph.degreeCentrality();
      }
    } catch (_) {
      // Graceful fallback to degree centrality if power iteration or brandes fails
      scores = {for (final v in vertices) v: graph.degreeOf(v)};
    }

    // Sanitize any non-finite values (NaN / Infinity)
    final cleanScores = <String, num>{};
    for (final v in vertices) {
      final s = scores[v];
      cleanScores[v] = (s != null && s.isFinite) ? s : 0.0;
    }

    final sorted = cleanScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maxVal = sorted.isNotEmpty && sorted.first.value != 0
        ? sorted.first.value
        : 1.0;

    final rows = <List<String>>[];
    for (var i = 0; i < sorted.length; i++) {
      final entry = sorted[i];
      final norm = (entry.value / maxVal).clamp(0.0, 1.0);
      final pct = (norm * 100).toStringAsFixed(1);
      final rawStr = entry.value is double
          ? entry.value.toStringAsFixed(4)
          : entry.value.toString();
      rows.add(['#${i + 1}', entry.key, rawStr, '$pct%']);
    }

    final overlay = HeatmapOverlay(
      title: '$name ($metric)',
      scores: cleanScores,
    );
    final topStr = sorted.isNotEmpty
        ? 'Top: ${sorted.first.key} (${sorted.first.value is double ? sorted.first.value.toStringAsFixed(3) : sorted.first.value})'
        : '';

    return ModifierOutput(
      overlay: overlay,
      tableData: ModifierTableData(
        title: '$name ($metric)',
        headers: ['Rank', 'Vertex', 'Score', 'Relative %'],
        rows: rows,
      ),
      statusSummary: topStr,
    );
  }
}

// ---------------------------------------------------------------------------
// 5. Connected Components / Partitions Modifier
// ---------------------------------------------------------------------------

class ComponentsModifier extends GraphModifier {
  new({super.enabled});

  String mode = 'weakly';

  @override
  String get id => 'components';

  @override
  String get name => 'Components & Clusters';

  @override
  String get category => 'Structure';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final select = selectElement();
    select.appendChild(optionElement('weakly', 'Connected Components'));
    select.appendChild(
      optionElement('strongly', 'Strongly Connected (Tarjan)'),
    );
    select.appendChild(optionElement('biconnected', 'Biconnected Components'));
    select.value = mode;
    select.onChange.listen((_) {
      mode = select.value;
      onModified();
    });
    root.appendChild(_field('Component Mode:', select));

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    List<Iterable<String>> components;
    try {
      switch (mode) {
        case 'strongly':
          components = graph.isDirected
              ? graph.stronglyConnected().toList()
              : graph.connected().map((g) => g.vertices).toList();
        case 'biconnected':
          components = !graph.isDirected
              ? graph.biconnectedComponents().map((g) => g.vertices).toList()
              : graph.connected().map((g) => g.vertices).toList();
        case 'weakly':
        default:
          components = graph.connected().map((g) => g.vertices).toList();
      }
    } catch (e) {
      return ModifierOutput(hasError: true, errorMessage: e.toString());
    }

    final vertexGroup = <String, int>{};
    final rows = <List<String>>[];
    for (var i = 0; i < components.length; i++) {
      final comp = components[i].toList();
      for (final v in comp) {
        vertexGroup[v] = i;
      }
      rows.add(['Component #${i + 1}', '${comp.length}', comp.join(', ')]);
    }

    final overlay = PartitionOverlay(
      vertexGroup: vertexGroup,
      title: 'Components ($mode)',
    );
    return ModifierOutput(
      overlay: overlay,
      statusSummary: '${components.length} components found',
      tableData: ModifierTableData(
        title: 'Connected Components ($mode)',
        headers: ['Component', 'Size', 'Vertices'],
        rows: rows,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6. Minimum Spanning Tree Modifier
// ---------------------------------------------------------------------------

class SpanningTreeModifier extends GraphModifier {
  new({super.enabled});

  String algorithm = 'kruskal';
  String treeColor = '#10b981';
  String treePattern = 'none';

  @override
  String get id => 'spanning_tree';

  @override
  String get name => 'Spanning Tree';

  @override
  String get category => 'Structure';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final select = selectElement();
    select.appendChild(optionElement('kruskal', "Kruskal's Algorithm"));
    select.appendChild(optionElement('prim', "Prim's Algorithm"));
    select.value = algorithm;
    select.onChange.listen((_) {
      algorithm = select.value;
      onModified();
    });
    root.appendChild(_field('Algorithm:', select));

    root.appendChild(
      _field(
        'Tree Color:',
        _colorSelect(treeColor, (c) {
          treeColor = c;
          onModified();
        }),
      ),
    );

    root.appendChild(
      _field(
        'Tree Pattern:',
        _patternSelect(treePattern, (p) {
          treePattern = p;
          onModified();
        }),
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage: 'Spanning tree algorithms require an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    Graph<String, num> tree;
    try {
      tree = algorithm == 'prim'
          ? graph.spanningTree(
              startVertex:
                  state.selectedSource ??
                  (graph.vertices.isNotEmpty ? graph.vertices.first : null),
            )
          : graph.spanningTree();
    } catch (e) {
      return ModifierOutput(hasError: true, errorMessage: e.toString());
    }

    num totalWeight = 0;
    final rows = <List<String>>[];

    for (final e in tree.edges) {
      totalWeight += e.value;
      rows.add(['${e.source} → ${e.target}', '${e.value}', '$totalWeight']);

      final edgeStyle = state.getEdgeStyle(e.source, e.target);
      edgeStyle.color = treeColor;
      edgeStyle.strokeWidth = 2.5;
    }

    // Dim non-tree edges
    for (final e in graph.edges) {
      if (!tree.containsEdge(e.source, e.target) &&
          !tree.containsEdge(e.target, e.source)) {
        final edgeStyle = state.getEdgeStyle(e.source, e.target);
        edgeStyle.opacity = 0.25;
      }
    }

    return ModifierOutput(
      statusSummary: 'MST Weight: $totalWeight (${tree.edges.length} edges)',
      tableData: ModifierTableData(
        title: 'Spanning Tree Edges ($algorithm)',
        headers: ['Edge', 'Weight', 'Cumulative Weight'],
        rows: rows,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7. Cycle Detection Modifier
// ---------------------------------------------------------------------------

class CycleDetectionModifier extends GraphModifier {
  new({super.enabled});

  String cycleColor = '#ef4444';
  String cyclePattern = '6,4';
  int selectedCycleIndex = -1; // -1 means All Discovered Cycles

  @override
  String get id => 'cycle_detection';

  @override
  String get name => 'Cycle Detection';

  @override
  String get category => 'Structure';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final cycles = _findCycles(state.renderGraph);
    if (cycles.isNotEmpty) {
      final selectCycle = selectElement();
      selectCycle.appendChild(
        optionElement('-1', 'All Discovered Cycles (${cycles.length})'),
      );
      for (var i = 0; i < cycles.length; i++) {
        final c = cycles[i];
        selectCycle.appendChild(
          optionElement(
            '$i',
            'Cycle #${i + 1} (${c.length - 1} edges: ${c.first} … ${c.last})',
          ),
        );
      }
      selectCycle.value = '$selectedCycleIndex';
      selectCycle.onChange.listen((_) {
        selectedCycleIndex = int.tryParse(selectCycle.value) ?? -1;
        onModified();
      });
      root.appendChild(_field('Display Cycle:', selectCycle));
    }

    root.appendChild(
      _field(
        'Cycle Color:',
        _colorSelect(cycleColor, (c) {
          cycleColor = c;
          onModified();
        }),
      ),
    );

    root.appendChild(
      _field(
        'Cycle Pattern:',
        _patternSelect(cyclePattern, (p) {
          cyclePattern = p;
          onModified();
        }),
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    final cycles = _findCycles(graph);
    if (cycles.isEmpty) {
      return const ModifierOutput(
        statusSummary: 'Graph is Acyclic (DAG)',
        tableData: ModifierTableData(
          title: 'Cycle Detection',
          headers: ['Property', 'Result'],
          rows: [
            ['Is Cyclic', 'No'],
            ['Acyclic (DAG)', 'Yes'],
            ['Total Cycles Discovered', '0'],
          ],
        ),
      );
    }

    // Determine which cycles to highlight
    final cyclesToHighlight = <List<String>>[];
    if (selectedCycleIndex >= 0 && selectedCycleIndex < cycles.length) {
      cyclesToHighlight.add(cycles[selectedCycleIndex]);
    } else {
      cyclesToHighlight.addAll(cycles);
    }

    final cycleEdges = <(String, String)>[];
    for (final cycle in cyclesToHighlight) {
      for (var i = 0; i < cycle.length - 1; i++) {
        final key = (cycle[i], cycle[i + 1]);
        cycleEdges.add(key);
        final edgeStyle = state.getEdgeStyle(key.$1, key.$2);
        edgeStyle.color = cycleColor;
        edgeStyle.strokeWidth = 3.0;
      }
      for (final v in cycle) {
        final node = state.nodes[v];
        if (node != null) {
          node.style.borderColor = cycleColor;
          node.style.borderWidth = 2.5;
        }
      }
    }

    final primaryCycle = cyclesToHighlight.first;
    final overlay = PathOverlay(
      vertices: primaryCycle,
      edges: cycleEdges,
      title: 'Discovered ${cycles.length} Cycles',
    );

    return ModifierOutput(
      overlay: overlay,
      statusSummary:
          '${cycles.length} Cycle${cycles.length == 1 ? "" : "s"} found',
      tableData: ModifierTableData(
        title: 'Discovered Cycles',
        headers: ['#', 'Length', 'Sequence'],
        rows: [
          for (var i = 0; i < cycles.length; i++)
            [
              'Cycle #${i + 1}',
              '${cycles[i].length - 1}',
              cycles[i].join(' → '),
            ],
        ],
      ),
    );
  }

  static List<List<String>> _findCycles(
    Graph<String, num> graph, {
    int maxCycles = 30,
  }) {
    final results = <List<String>>[];
    final seenCanonical = <String>{};

    void recordCycle(List<String> rawCycle) {
      if (rawCycle.length < 2) return;
      final nodes = rawCycle.sublist(0, rawCycle.length - 1);
      if (nodes.length < 2) return;
      if (!graph.isDirected && nodes.length < 3) return;

      final sorted = List.of(nodes)..sort();
      final key = graph.isDirected ? nodes.join('->') : sorted.join('-');
      if (!seenCanonical.contains(key)) {
        seenCanonical.add(key);
        results.add(List.of(rawCycle));
      }
    }

    if (graph.isDirected) {
      final visited = <String>{};
      final onStack = <String>{};
      final path = <String>[];

      void dfs(String v) {
        if (results.length >= maxCycles) return;
        visited.add(v);
        onStack.add(v);
        path.add(v);

        for (final next in graph.successorsOf(v)) {
          if (results.length >= maxCycles) break;
          if (onStack.contains(next)) {
            final cycleStart = path.indexOf(next);
            if (cycleStart != -1) {
              final cycle = path.sublist(cycleStart)..add(next);
              recordCycle(cycle);
            }
          } else if (!visited.contains(next)) {
            dfs(next);
          }
        }

        path.removeLast();
        onStack.remove(v);
      }

      for (final v in graph.vertices) {
        if (results.length >= maxCycles) break;
        if (!visited.contains(v)) {
          dfs(v);
        }
      }
    } else {
      final visited = <String>{};
      final parentMap = <String, String?>{};
      final depth = <String, int>{};

      void dfs(String u, String? parent, int d) {
        if (results.length >= maxCycles) return;
        visited.add(u);
        parentMap[u] = parent;
        depth[u] = d;

        for (final v in graph.neighboursOf(u)) {
          if (results.length >= maxCycles) break;
          if (v == parent) continue;
          if (visited.contains(v)) {
            if (depth[v]! < depth[u]!) {
              final cycle = <String>[];
              var curr = u;
              while (curr != v) {
                cycle.add(curr);
                final p = parentMap[curr];
                if (p == null) break;
                curr = p;
              }
              cycle.add(v);
              cycle.add(u);
              if (cycle.length >= 4) {
                recordCycle(cycle);
              }
            }
          } else {
            dfs(v, u, d + 1);
          }
        }
      }

      for (final v in graph.vertices) {
        if (results.length >= maxCycles) break;
        if (!visited.contains(v)) {
          dfs(v, null, 0);
        }
      }
    }

    return results;
  }
}

// ---------------------------------------------------------------------------
// 8. Vertex Coloring Modifier
// ---------------------------------------------------------------------------

class VertexColoringModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'vertex_coloring';

  @override
  String get name => 'Vertex Coloring';

  @override
  String get category => 'Structure';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) =>
      div('form-column')..appendChild(
        p('Partitions vertices so no adjacent vertices share a color.')
          ..style.fontSize = '11px'
          ..style.color = 'var(--text-muted)',
      );

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    final Map<String, int> coloring;
    try {
      coloring = graph.vertexColoring();
    } catch (e) {
      return ModifierOutput(hasError: true, errorMessage: e.toString());
    }

    final groups = <int, List<String>>{};
    for (final MapEntry(:key, :value) in coloring.entries) {
      groups.putIfAbsent(value, () => []).add(key);
    }

    final rows = <List<String>>[];
    for (final MapEntry(:key, :value) in groups.entries) {
      rows.add(['Color #$key', '${value.length}', value.join(', ')]);
    }

    final overlay = PartitionOverlay(
      vertexGroup: coloring,
      title: 'Vertex Coloring',
    );
    return ModifierOutput(
      overlay: overlay,
      tableData: ModifierTableData(
        title: 'Vertex Coloring (Chromatic Number: ${groups.length})',
        headers: ['Color ID', 'Vertex Count', 'Assigned Vertices'],
        rows: rows,
      ),
      statusSummary: 'Chromatic number: ${groups.length} colors',
    );
  }
}

// ---------------------------------------------------------------------------
// 9. k-Core Modifier (Safe across directed & undirected graphs)
// ---------------------------------------------------------------------------

class KCoreModifier extends GraphModifier {
  new({super.enabled, int? k}) : k = k ?? 2;

  int k;
  String removedStyle = 'dash'; // 'dash' or 'filter'
  String dashColor = '#ef4444';
  String dashPattern = '6,4';

  @override
  String get id => 'k_core';

  @override
  String get name => 'k-Core Subgraph';

  @override
  String get category => 'Transformations';

  @override
  bool get canApply => true;

  @override
  void applyPermanent(AppState state) {
    final out = apply(state.primaryGraph, state);
    if (out.transformedGraph != null) {
      state.saveSnapshot();
      state.primaryGraph = out.transformedGraph!;
      state.syncNodes();
      state.modifiers.remove(this);
    }
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final container = div('form-column');

    final input = numberInput(k, 1, 20);
    input.onInput.listen((_) {
      final val = int.tryParse(input.value);
      if (val != null && val >= 1) {
        k = val;
        onModified();
      }
    });
    container.appendChild(_field('Degree Threshold (k):', input));

    final styleSelect = selectElement();
    styleSelect.appendChild(
      optionElement('dash', 'Dash & Dim Removed Vertices'),
    );
    styleSelect.appendChild(
      optionElement('filter', 'Filter / Remove From View'),
    );
    styleSelect.value = removedStyle;
    styleSelect.onChange.listen((_) {
      removedStyle = styleSelect.value;
      onModified();
    });
    container.appendChild(_field('Removed Vertices Style:', styleSelect));

    container.appendChild(
      _field(
        'Removed Border Color:',
        _colorSelect(dashColor, (c) {
          dashColor = c;
          onModified();
        }),
      ),
    );

    container.appendChild(
      _field(
        'Removed Dash Pattern:',
        _patternSelect(dashPattern, (p) {
          dashPattern = p;
          onModified();
        }),
      ),
    );

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    Set<String> coreVerts;
    try {
      if (!graph.isDirected) {
        coreVerts = graph.kCore(k).vertices.toSet();
      } else {
        // Directed graphs: compute k-core over composite total degree
        coreVerts = <String>{};
        final degrees = <String, int>{};
        for (final v in graph.vertices) {
          degrees[v] = graph.degreeOf(v);
        }
        var changed = true;
        while (changed) {
          changed = false;
          final toRemove = <String>[];
          for (final MapEntry(:key, :value) in degrees.entries) {
            if (value < k) {
              toRemove.add(key);
            }
          }
          if (toRemove.isNotEmpty) {
            changed = true;
            for (final v in toRemove) {
              degrees.remove(v);
              for (final succ in graph.successorsOf(v)) {
                if (degrees.containsKey(succ)) {
                  degrees[succ] = degrees[succ]! - 1;
                }
              }
              for (final pred in graph.predecessorsOf(v)) {
                if (degrees.containsKey(pred)) {
                  degrees[pred] = degrees[pred]! - 1;
                }
              }
            }
          }
        }
        coreVerts = degrees.keys.toSet();
      }
    } catch (e) {
      return ModifierOutput(hasError: true, errorMessage: e.toString());
    }

    // Apply dashed styling or filter
    if (removedStyle == 'dash') {
      for (final v in graph.vertices) {
        if (!coreVerts.contains(v)) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = dashColor;
            node.style.opacity = 0.45;
          }
          for (final e in graph.edgesOf(v)) {
            final es = state.getEdgeStyle(e.source, e.target);
            es.color = dashColor;
            es.opacity = 0.35;
          }
        }
      }

      return ModifierOutput(
        statusSummary: 'k-Core (k=$k, ${coreVerts.length} surviving vertices)',
        tableData: ModifierTableData(
          title: 'k-Core Subgraph (k=$k)',
          headers: ['Property', 'Value'],
          rows: [
            ['Threshold k', '$k'],
            ['Surviving Vertices', '${coreVerts.length}'],
            ['Dashed / Dimmed', '${graph.vertices.length - coreVerts.length}'],
          ],
        ),
      );
    }

    // Filter mode: extract subgraph
    final sub = Graph<String, num>(
      isDirected: graph.isDirected,
      vertexStrategy: graph.vertexStrategy,
    );
    for (final v in coreVerts) {
      sub.addVertex(v);
    }
    for (final e in graph.edges) {
      if (coreVerts.contains(e.source) && coreVerts.contains(e.target)) {
        sub.addEdge(e.source, e.target, value: e.value);
      }
    }

    return ModifierOutput(
      transformedGraph: sub,
      statusSummary: 'k-Core (k=$k, ${sub.vertices.length} vertices)',
      tableData: ModifierTableData(
        title: 'k-Core Subgraph (k=$k)',
        headers: ['Property', 'Value'],
        rows: [
          ['Threshold k', '$k'],
          ['Surviving Vertices', '${sub.vertices.length}'],
          ['Surviving Edges', '${sub.edges.length}'],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 10. Transitive Closure Modifier (Customizable Added Style, can be applied)
// ---------------------------------------------------------------------------

class TransitiveClosureModifier extends GraphModifier {
  new({super.enabled});

  String addedColor = '#10b981';
  String addedPattern = '6,4';

  @override
  String get id => 'transitive_closure';

  @override
  String get name => 'Transitive Closure';

  @override
  String get category => 'Transformations';

  @override
  bool get canApply => true;

  @override
  void applyPermanent(AppState state) {
    final out = apply(state.primaryGraph, state);
    if (out.transformedGraph != null) {
      state.saveSnapshot();
      state.primaryGraph = out.transformedGraph!;
      state.syncNodes();
      state.modifiers.remove(this);
    }
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final container = div('form-column');

    container.appendChild(
      _field(
        'Added Edge / Vertex Color:',
        _colorSelect(addedColor, (c) {
          addedColor = c;
          onModified();
        }),
      ),
    );

    container.appendChild(
      _field(
        'Added Line Pattern:',
        _patternSelect(addedPattern, (p) {
          addedPattern = p;
          onModified();
        }),
      ),
    );

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (!graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage: 'Transitive closure requires a directed graph.',
        statusSummary: 'Requires directed graph',
      );
    }

    Graph<String, void> closure;
    try {
      closure = graph.transitiveClosure();
    } catch (e) {
      return ModifierOutput(hasError: true, errorMessage: e.toString());
    }

    final closureGraph = Graph<String, num>(
      isDirected: true,
      vertexStrategy: graph.vertexStrategy,
    )..addVertices(closure.vertices);

    var addedEdgesCount = 0;
    for (final edge in closure.edges) {
      final origEdge = graph.getEdge(edge.source, edge.target);
      final isNew = origEdge == null;
      closureGraph.addEdge(
        edge.source,
        edge.target,
        value: origEdge?.value ?? 1,
      );

      if (isNew) {
        addedEdgesCount++;
        final es = state.getEdgeStyle(edge.source, edge.target);
        es.color = addedColor;
        es.strokeWidth = 2.2;

        final srcNode = state.nodes[edge.source];
        if (srcNode != null && srcNode.style.borderColor == null) {
          srcNode.style.borderColor = addedColor;
        }
        final tgtNode = state.nodes[edge.target];
        if (tgtNode != null && tgtNode.style.borderColor == null) {
          tgtNode.style.borderColor = addedColor;
        }
      }
    }

    return ModifierOutput(
      transformedGraph: closureGraph,
      statusSummary: 'Transitive Closure (+$addedEdgesCount added dashed)',
      tableData: ModifierTableData(
        title: 'Transitive Closure',
        headers: ['Metric', 'Count'],
        rows: [
          ['Original Edges', '${graph.edges.length}'],
          ['Closure Edges', '${closureGraph.edges.length}'],
          ['Added Reachable Edges', '+$addedEdgesCount'],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 11. Transitive Reduction Modifier (Customizable Removed Style, can be applied)
// ---------------------------------------------------------------------------

class TransitiveReductionModifier extends GraphModifier {
  new({super.enabled});

  String removedColor = '#ef4444';
  String removedPattern = '6,4';
  bool keepRemovedDashedInView = true;

  @override
  String get id => 'transitive_reduction';

  @override
  String get name => 'Transitive Reduction';

  @override
  String get category => 'Transformations';

  @override
  bool get canApply => true;

  @override
  void applyPermanent(AppState state) {
    final out = apply(state.primaryGraph, state);
    if (out.transformedGraph != null) {
      state.saveSnapshot();
      state.primaryGraph = out.transformedGraph!;
      state.syncNodes();
      state.modifiers.remove(this);
    }
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final container = div('form-column');

    final modeSelect = selectElement();
    modeSelect.appendChild(
      optionElement('dashed', 'Keep Removed Edges/Vertices Dashed in View'),
    );
    modeSelect.appendChild(
      optionElement('remove', 'Strip Removed Edges/Vertices Completely'),
    );
    modeSelect.value = keepRemovedDashedInView ? 'dashed' : 'remove';
    modeSelect.onChange.listen((_) {
      keepRemovedDashedInView = modeSelect.value == 'dashed';
      onModified();
    });
    container.appendChild(_field('Display Mode:', modeSelect));

    container.appendChild(
      _field(
        'Removed Border & Stroke Color:',
        _colorSelect(removedColor, (c) {
          removedColor = c;
          onModified();
        }),
      ),
    );

    container.appendChild(
      _field(
        'Removed Dash Pattern:',
        _patternSelect(removedPattern, (p) {
          removedPattern = p;
          onModified();
        }),
      ),
    );

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (!graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage:
            'Transitive reduction requires a directed acyclic graph (DAG).',
        statusSummary: 'Requires directed graph',
      );
    }

    Graph<String, void> reduced;
    try {
      reduced = graph.transitiveReduction();
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage:
            'Transitive reduction requires a directed acyclic graph (DAG). $e',
      );
    }

    final reducedGraph = Graph<String, num>(
      isDirected: true,
      vertexStrategy: graph.vertexStrategy,
    )..addVertices(reduced.vertices);

    for (final edge in reduced.edges) {
      final origEdge = graph.getEdge(edge.source, edge.target);
      reducedGraph.addEdge(
        edge.source,
        edge.target,
        value: origEdge?.value ?? 1,
      );
    }

    var removedEdgesCount = 0;
    // Identify removed edges
    for (final edge in graph.edges) {
      if (!reduced.containsEdge(edge.source, edge.target)) {
        removedEdgesCount++;
        if (keepRemovedDashedInView) {
          // Keep edge in graph view but style as dashed and colored
          reducedGraph.addEdge(edge.source, edge.target, value: edge.value);
          final es = state.getEdgeStyle(edge.source, edge.target);
          es.color = removedColor;
          es.opacity = 0.45;
        }
      }
    }

    // Check vertices with 0 degree after reduction and style dashed if requested
    for (final v in reducedGraph.vertices) {
      if (reducedGraph.degreeOf(v) == 0 && graph.degreeOf(v) > 0) {
        final node = state.nodes[v];
        if (node != null) {
          node.style.borderColor = removedColor;
          node.style.opacity = 0.5;
        }
      }
    }

    return ModifierOutput(
      transformedGraph: reducedGraph,
      statusSummary: 'Transitive Reduction (-$removedEdgesCount removed)',
      tableData: ModifierTableData(
        title: 'Transitive Reduction',
        headers: ['Metric', 'Count'],
        rows: [
          ['Original Edges', '${graph.edges.length}'],
          ['Reduced Core Edges', '${reduced.edges.length}'],
          ['Redundant Edges Removed', '-$removedEdgesCount'],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 12. All-Pairs Shortest Paths Modifier (Floyd-Warshall)
// ---------------------------------------------------------------------------

class AllPairsShortestPathModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'all_pairs_path';

  @override
  String get name => 'All-Pairs Shortest Paths';

  @override
  String get category => 'Path & Search';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) =>
      div('form-column')..appendChild(
        p(
          'Computes shortest paths between all pairs of vertices using Floyd-Warshall.',
        ),
      );

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    try {
      final fw = graph.allShortestPaths(
        edgeCost: (u, v) {
          final edge = graph.getEdge(u, v);
          return edge?.value ?? 1;
        },
      );

      final rows = <List<String>>[];
      for (final u in vertices) {
        final row = <String>[u];
        for (final v in vertices) {
          if (u == v) {
            row.add('0');
          } else {
            final dist = fw.distance(u, v);
            row.add(dist.isInfinite ? '∞' : '$dist');
          }
        }
        rows.add(row);
      }

      return ModifierOutput(
        statusSummary:
            'All-Pairs Distances (${vertices.length}×${vertices.length})',
        tableData: ModifierTableData(
          title: 'Distance Matrix (Floyd-Warshall)',
          headers: ['From \\ To', ...vertices],
          rows: rows,
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Floyd-Warshall error: $e',
        statusSummary: 'Error computing all-pairs paths',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 13. Biconnected Components, Articulation Points & Bridges
// ---------------------------------------------------------------------------

class BiconnectedComponentsModifier extends GraphModifier {
  new({super.enabled});

  String pointColor = '#f59e0b';
  String bridgeColor = '#ef4444';

  @override
  String get id => 'biconnected';

  @override
  String get name => 'Biconnected & Bridges';

  @override
  String get category => 'Connectivity';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');
    root.appendChild(
      _field(
        'Articulation Point Color:',
        _colorSelect(pointColor, (c) {
          pointColor = c;
          onModified();
        }),
      ),
    );
    root.appendChild(
      _field(
        'Bridge Edge Color:',
        _colorSelect(bridgeColor, (c) {
          bridgeColor = c;
          onModified();
        }),
      ),
    );
    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage:
            'Biconnected components and bridges require an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    try {
      final cutVertices = graph.articulationPoints();
      final bridgeEdges = graph.bridges();

      for (final v in cutVertices) {
        final node = state.nodes[v];
        if (node != null) {
          node.style.borderColor = pointColor;
          node.style.borderWidth = 3.5;
        }
      }

      for (final b in bridgeEdges) {
        final es = state.getEdgeStyle(b.source, b.target);
        es.color = bridgeColor;
        es.strokeWidth = 3.5;
        if (!graph.isDirected) {
          final esRev = state.getEdgeStyle(b.target, b.source);
          esRev.color = bridgeColor;
          esRev.strokeWidth = 3.5;
        }
      }

      return ModifierOutput(
        statusSummary:
            '${cutVertices.length} Articulation Points, ${bridgeEdges.length} Bridges',
        tableData: ModifierTableData(
          title: 'Articulation Points & Bridges',
          headers: ['Type', 'Element'],
          rows: [
            for (final v in cutVertices) ['Articulation Point', v],
            for (final b in bridgeEdges)
              ['Bridge Edge', '${b.source} ↔ ${b.target}'],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Biconnected error: $e',
        statusSummary: 'Error computing biconnected components',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 14. Max Flow & Min s-t Cut (Dinic)
// ---------------------------------------------------------------------------

class MaxFlowModifier extends GraphModifier {
  new({super.enabled});

  String? sourceVertex;
  String? targetVertex;
  String flowColor = '#10b981';
  String cutColor = '#ef4444';

  @override
  String get id => 'max_flow';

  @override
  String get name => 'Max Flow & Min s-t Cut';

  @override
  String get category => 'Flows & Cuts';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final srcSelect = _vertexSelect(state, sourceVertex, '(Selected / First)', (
      v,
    ) {
      sourceVertex = v;
      onModified();
    });
    root.appendChild(_field('Source Vertex (s):', srcSelect));

    final tgtSelect = _vertexSelect(state, targetVertex, '(Selected / Last)', (
      v,
    ) {
      targetVertex = v;
      onModified();
    });
    root.appendChild(_field('Sink Vertex (t):', tgtSelect));

    root.appendChild(
      _field(
        'Cut Color:',
        _colorSelect(cutColor, (c) {
          cutColor = c;
          onModified();
        }),
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.length < 2) {
      return const ModifierOutput(statusSummary: 'Need at least 2 vertices');
    }

    final s = sourceVertex ?? state.selectedSource ?? vertices.first;
    final t = targetVertex ?? state.selectedTarget ?? vertices.last;

    if (s == t) {
      return const ModifierOutput(
        hasError: true,
        errorMessage: 'Source and sink cannot be identical',
        statusSummary: 'Source == Sink',
      );
    }

    try {
      final dinic = graph.maxFlow(
        edgeCapacity: (u, v) {
          final edge = graph.getEdge(u, v);
          final cap = edge?.value ?? 1;
          return cap > 0 ? cap : 1;
        },
      );

      final maxFlowValue = dinic(s, t);

      // Identify source partition S via BFS reachability in residual graph
      final reachable = <String>{s};
      final queue = <String>[s];
      while (queue.isNotEmpty) {
        final curr = queue.removeAt(0);
        for (final next in graph.successorsOf(curr)) {
          if (!reachable.contains(next)) {
            reachable.add(next);
            queue.add(next);
          }
        }
      }

      // Style source and target sets
      for (final v in vertices) {
        final node = state.nodes[v];
        if (node != null) {
          node.style.borderColor = reachable.contains(v)
              ? '#06b6d4'
              : '#f59e0b';
          node.style.borderWidth = (v == s || v == t) ? 3.5 : 2.0;
        }
      }

      // Highlight cut edges
      for (final edge in graph.edges) {
        if (reachable.contains(edge.source) &&
            !reachable.contains(edge.target)) {
          final es = state.getEdgeStyle(edge.source, edge.target);
          es.color = cutColor;
          es.strokeWidth = 3.5;
        }
      }

      return ModifierOutput(
        statusSummary: 'Max Flow ($s → $t) = $maxFlowValue',
        tableData: ModifierTableData(
          title: 'Max Flow / Min Cut ($s → $t)',
          headers: ['Property', 'Value'],
          rows: [
            ['Maximum Flow', '$maxFlowValue'],
            ['Source Partition S', reachable.join(', ')],
            [
              'Sink Partition T',
              vertices.where((v) => !reachable.contains(v)).join(', '),
            ],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Max flow error: $e',
        statusSummary: 'Error computing max flow',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 15. Global Minimum Cut (Stoer-Wagner)
// ---------------------------------------------------------------------------

class MinCutModifier extends GraphModifier {
  new({super.enabled});

  String cutColor = '#ef4444';

  @override
  String get id => 'min_cut';

  @override
  String get name => 'Global Min Cut (Stoer-Wagner)';

  @override
  String get category => 'Flows & Cuts';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');
    root.appendChild(
      _field(
        'Cut Edges Color:',
        _colorSelect(cutColor, (c) {
          cutColor = c;
          onModified();
        }),
      ),
    );
    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage:
            'Stoer-Wagner global min-cut requires an undirected graph',
        statusSummary: 'Requires Undirected Graph',
      );
    }
    final vertices = graph.vertices.toList();
    if (vertices.length < 2) {
      return const ModifierOutput(statusSummary: 'Need at least 2 vertices');
    }

    try {
      final minCutObj = graph.minCut(
        edgeWeight: (u, v) {
          final edge = graph.getEdge(u, v);
          return edge?.value ?? 1;
        },
      );
      final weight = minCutObj.weight;
      final partition = minCutObj.graphs[0].vertices.toSet();

      for (final v in vertices) {
        final node = state.nodes[v];
        if (node != null) {
          node.style.borderColor = partition.contains(v)
              ? '#06b6d4'
              : '#f59e0b';
          node.style.borderWidth = 2.5;
        }
      }

      for (final edge in minCutObj.edges) {
        final es = state.getEdgeStyle(edge.source, edge.target);
        es.color = cutColor;
        es.strokeWidth = 3.5;
      }

      return ModifierOutput(
        statusSummary: 'Global Min Cut = $weight',
        tableData: ModifierTableData(
          title: 'Global Minimum Cut',
          headers: ['Metric', 'Value'],
          rows: [
            ['Min Cut Weight', '$weight'],
            ['Partition A (|A| = ${partition.length})', partition.join(', ')],
            [
              'Partition B (|B| = ${vertices.length - partition.length})',
              vertices.where((v) => !partition.contains(v)).join(', '),
            ],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Min cut error: $e',
        statusSummary: 'Error computing min cut',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 16. Maximum Matching (Blossom)
// ---------------------------------------------------------------------------

class MatchingModifier extends GraphModifier {
  new({super.enabled});

  String matchingColor = '#10b981';

  @override
  String get id => 'matching';

  @override
  String get name => 'Maximum Matching (Blossom)';

  @override
  String get category => 'Matching & Cliques';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');
    root.appendChild(
      _field(
        'Matching Color:',
        _colorSelect(matchingColor, (c) {
          matchingColor = c;
          onModified();
        }),
      ),
    );
    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage:
            'Maximum matching (Blossom) requires an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    try {
      final matching = graph.maximumMatching();
      final matchedEdges = <(String, String)>{};
      for (final entry in matching.entries) {
        final u = entry.key;
        final v = entry.value;
        if (u.compareTo(v) < 0) {
          matchedEdges.add((u, v));
        }
      }

      for (final edge in matchedEdges) {
        final es = state.getEdgeStyle(edge.$1, edge.$2);
        es.color = matchingColor;
        es.strokeWidth = 4.0;
        if (!graph.isDirected) {
          final esRev = state.getEdgeStyle(edge.$2, edge.$1);
          esRev.color = matchingColor;
          esRev.strokeWidth = 4.0;
        }
        state.nodes[edge.$1]?.style.borderColor = matchingColor;
        state.nodes[edge.$2]?.style.borderColor = matchingColor;
      }

      var idx = 1;
      return ModifierOutput(
        statusSummary: 'Matching Size: ${matchedEdges.length} edges',
        tableData: ModifierTableData(
          title: 'Maximum Matching',
          headers: ['Pair #', 'Vertex 1', 'Vertex 2'],
          rows: [
            for (final edge in matchedEdges) ['#${idx++}', edge.$1, edge.$2],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Matching error: $e',
        statusSummary: 'Error computing maximum matching',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 17. Maximal Cliques & Independent Set
// ---------------------------------------------------------------------------

class CliquesModifier extends GraphModifier {
  new({super.enabled});

  String mode = 'cliques'; // 'cliques' or 'independent_set'
  String highlightColor = '#f59e0b';

  @override
  String get id => 'cliques';

  @override
  String get name => 'Cliques & Independent Set';

  @override
  String get category => 'Matching & Cliques';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final modeSelect = selectElement();
    modeSelect.appendChild(
      optionElement('cliques', 'Maximal Cliques (Bron-Kerbosch)'),
    );
    modeSelect.appendChild(
      optionElement('independent_set', 'Maximum Independent Set'),
    );
    modeSelect.value = mode;
    modeSelect.onChange.listen((_) {
      mode = modeSelect.value;
      onModified();
    });
    root.appendChild(_field('Mode:', modeSelect));

    root.appendChild(
      _field(
        'Highlight Color:',
        _colorSelect(highlightColor, (c) {
          highlightColor = c;
          onModified();
        }),
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage:
            'Cliques and independent sets require an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    try {
      if (mode == 'independent_set') {
        final indSet = graph.maximumIndependentSet();
        for (final v in indSet) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = highlightColor;
            node.style.borderWidth = 3.5;
          }
        }
        return ModifierOutput(
          statusSummary: 'Max Independent Set: ${indSet.length} vertices',
          tableData: ModifierTableData(
            title: 'Maximum Independent Set',
            headers: ['Index', 'Vertex'],
            rows: [
              for (var i = 0; i < indSet.length; i++)
                ['#$i', indSet.elementAt(i)],
            ],
          ),
        );
      } else {
        final cliques = graph.findCliques().toList()
          ..sort((a, b) => b.length.compareTo(a.length));
        if (cliques.isEmpty) {
          return const ModifierOutput(statusSummary: 'No cliques found');
        }

        final activeClique = cliques.first;
        for (final v in activeClique) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = highlightColor;
            node.style.borderWidth = 3.5;
          }
        }
        for (final u in activeClique) {
          for (final v in activeClique) {
            if (u != v && graph.containsEdge(u, v)) {
              final es = state.getEdgeStyle(u, v);
              es.color = highlightColor;
              es.strokeWidth = 3.0;
            }
          }
        }

        return ModifierOutput(
          statusSummary:
              'Found ${cliques.length} Cliques (Max size: ${activeClique.length})',
          tableData: ModifierTableData(
            title: 'Maximal Cliques',
            headers: ['#', 'Size', 'Vertices'],
            rows: [
              for (var i = 0; i < cliques.length; i++)
                [
                  'Clique #${i + 1}',
                  '${cliques[i].length}',
                  cliques[i].join(', '),
                ],
            ],
          ),
        );
      }
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Cliques error: $e',
        statusSummary: 'Error computing cliques',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 18. Minimum Vertex Cover
// ---------------------------------------------------------------------------

class VertexCoverModifier extends GraphModifier {
  new({super.enabled});

  String coverColor = '#ec4899';
  bool approximate = false;

  @override
  String get id => 'vertex_cover';

  @override
  String get name => 'Minimum Vertex Cover';

  @override
  String get category => 'Matching & Cliques';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final approxSelect = selectElement();
    approxSelect.appendChild(optionElement('false', 'Exact Minimum Cover'));
    approxSelect.appendChild(optionElement('true', '2-Approximation (Fast)'));
    approxSelect.value = '$approximate';
    approxSelect.onChange.listen((_) {
      approximate = approxSelect.value == 'true';
      onModified();
    });
    root.appendChild(_field('Method:', approxSelect));

    root.appendChild(
      _field(
        'Cover Color:',
        _colorSelect(coverColor, (c) {
          coverColor = c;
          onModified();
        }),
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage: 'Vertex cover requires an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    try {
      final cover = graph.minimumVertexCover(approximate: approximate);
      for (final v in cover) {
        final node = state.nodes[v];
        if (node != null) {
          node.style.borderColor = coverColor;
          node.style.borderWidth = 3.5;
        }
      }

      return ModifierOutput(
        statusSummary: 'Vertex Cover: ${cover.length} vertices',
        tableData: ModifierTableData(
          title: 'Minimum Vertex Cover',
          headers: ['Index', 'Cover Vertex'],
          rows: [
            for (var i = 0; i < cover.length; i++) ['#$i', cover.elementAt(i)],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Vertex cover error: $e',
        statusSummary: 'Error computing vertex cover',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 19. Planarity Test & Kuratowski Subgraph
// ---------------------------------------------------------------------------

class PlanarityModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'planarity';

  @override
  String get name => 'Planarity & Kuratowski';

  @override
  String get category => 'Graph Theory';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) =>
      div('form-column')..appendChild(
        p(
          'Tests whether the graph can be embedded in a plane with no edge crossings (Left-Right planarity test).',
        ),
      );

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    if (graph.isDirected) {
      return const ModifierOutput(
        hasError: true,
        errorMessage: 'Planarity testing requires an undirected graph.',
        statusSummary: 'Requires undirected graph',
      );
    }

    try {
      final planar = graph.isPlanar();
      final vCount = graph.vertices.length;
      final eCount = graph.edges.length;
      final faces = (2 - vCount + eCount).clamp(1, 999999);

      return ModifierOutput(
        statusSummary: planar
            ? 'Planar (Embeddable)'
            : 'Non-Planar (Contains K5 or K3,3 minor)',
        tableData: ModifierTableData(
          title: 'Planarity Analysis',
          headers: ['Property', 'Value'],
          rows: [
            ['Is Planar', if (planar) 'Yes' else 'No'],
            ['Vertices (V)', '$vCount'],
            ['Edges (E)', '$eCount'],
            if (planar) ['Euler Faces (F = 2 - V + E)', '$faces'],
            ['Max Planar Edges (3V - 6)', '${math.max(0, 3 * vCount - 6)}'],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Planarity error: $e',
        statusSummary: 'Error checking planarity',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 20. Eulerian Circuit & Trail
// ---------------------------------------------------------------------------

class EulerianModifier extends GraphModifier {
  new({super.enabled});

  String tourColor = '#10b981';
  bool requireCircuit = false;

  @override
  String get id => 'eulerian';

  @override
  String get name => 'Eulerian Circuit / Trail';

  @override
  String get category => 'Graph Theory';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final typeSelect = selectElement();
    typeSelect.appendChild(optionElement('false', 'Eulerian Trail or Circuit'));
    typeSelect.appendChild(
      optionElement('true', 'Eulerian Circuit Only (Closed)'),
    );
    typeSelect.value = '$requireCircuit';
    typeSelect.onChange.listen((_) {
      requireCircuit = typeSelect.value == 'true';
      onModified();
    });
    root.appendChild(_field('Tour Type:', typeSelect));

    root.appendChild(
      _field(
        'Trail Color:',
        _colorSelect(tourColor, (c) {
          tourColor = c;
          onModified();
        }),
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    try {
      final hasCircuit = graph.hasEulerianCircuit();
      final hasPath = graph.hasEulerianPath();

      if (requireCircuit && !hasCircuit) {
        return const ModifierOutput(
          statusSummary: 'No Eulerian Circuit exists',
          tableData: ModifierTableData(
            title: 'Eulerian Properties',
            headers: ['Property', 'Value'],
            rows: [
              ['Eulerian Circuit', 'No (all vertices must have even degree)'],
            ],
          ),
        );
      }

      if (!hasPath) {
        return const ModifierOutput(
          statusSummary: 'Graph is not Eulerian',
          tableData: ModifierTableData(
            title: 'Eulerian Properties',
            headers: ['Property', 'Value'],
            rows: [
              ['Eulerian Circuit', 'No'],
              ['Eulerian Trail', 'No'],
            ],
          ),
        );
      }

      final tour = graph.findEulerianPath(circuit: requireCircuit);
      if (tour == null) {
        return const ModifierOutput(statusSummary: 'No Eulerian tour found');
      }

      final tourVertices = tour.vertices.toList();
      final tourEdges = <(String, String)>[];
      for (var i = 0; i < tourVertices.length - 1; i++) {
        final key = (tourVertices[i], tourVertices[i + 1]);
        tourEdges.add(key);
        final es = state.getEdgeStyle(key.$1, key.$2);
        es.color = tourColor;
        es.strokeWidth = 3.5;
      }

      for (final v in tourVertices) {
        final node = state.nodes[v];
        if (node != null) {
          node.style.borderColor = tourColor;
        }
      }

      return ModifierOutput(
        overlay: PathOverlay(
          vertices: tourVertices,
          edges: tourEdges,
          title: hasCircuit ? 'Eulerian Circuit' : 'Eulerian Trail',
        ),
        statusSummary: hasCircuit
            ? 'Eulerian Circuit found'
            : 'Eulerian Trail found',
        tableData: ModifierTableData(
          title: 'Eulerian Steps',
          headers: ['Step', 'Vertex'],
          rows: [
            for (var i = 0; i < tourVertices.length; i++)
              ['#${i + 1}', tourVertices[i]],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Eulerian error: $e',
        statusSummary: 'Error computing Eulerian path',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 21. Hamiltonian Cycle & Path
// ---------------------------------------------------------------------------

class HamiltonianModifier extends GraphModifier {
  new({super.enabled});

  String tourColor = '#a855f7';
  bool requireCircuit = false;

  @override
  String get id => 'hamiltonian';

  @override
  String get name => 'Hamiltonian Cycle / Path';

  @override
  String get category => 'Graph Theory';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    final typeSelect = selectElement();
    typeSelect.appendChild(optionElement('false', 'Hamiltonian Path or Cycle'));
    typeSelect.appendChild(
      optionElement('true', 'Hamiltonian Cycle Only (Closed)'),
    );
    typeSelect.value = '$requireCircuit';
    typeSelect.onChange.listen((_) {
      requireCircuit = typeSelect.value == 'true';
      onModified();
    });
    root.appendChild(_field('Type:', typeSelect));

    root.appendChild(
      _field(
        'Path Color:',
        _colorSelect(tourColor, (c) {
          tourColor = c;
          onModified();
        }),
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    try {
      final tour = graph.findHamiltonianPath(circuit: requireCircuit);
      if (tour == null) {
        return ModifierOutput(
          statusSummary: requireCircuit
              ? 'No Hamiltonian Cycle exists'
              : 'No Hamiltonian Path exists',
          tableData: ModifierTableData(
            title: 'Hamiltonian Properties',
            headers: ['Property', 'Result'],
            rows: [
              ['Hamiltonian ${requireCircuit ? "Cycle" : "Path"}', 'Not Found'],
            ],
          ),
        );
      }

      final tourVertices = tour.vertices.toList();
      final tourEdges = <(String, String)>[];
      for (var i = 0; i < tourVertices.length - 1; i++) {
        final key = (tourVertices[i], tourVertices[i + 1]);
        tourEdges.add(key);
        final es = state.getEdgeStyle(key.$1, key.$2);
        es.color = tourColor;
        es.strokeWidth = 3.5;
      }

      for (final v in tourVertices) {
        final node = state.nodes[v];
        if (node != null) {
          node.style.borderColor = tourColor;
        }
      }

      return ModifierOutput(
        overlay: PathOverlay(
          vertices: tourVertices,
          edges: tourEdges,
          title: requireCircuit ? 'Hamiltonian Cycle' : 'Hamiltonian Path',
        ),
        statusSummary: requireCircuit
            ? 'Hamiltonian Cycle found'
            : 'Hamiltonian Path found',
        tableData: ModifierTableData(
          title: 'Hamiltonian Sequence',
          headers: ['Index', 'Vertex'],
          rows: [
            for (var i = 0; i < tourVertices.length; i++)
              ['#${i + 1}', tourVertices[i]],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Hamiltonian error: $e',
        statusSummary: 'Error computing Hamiltonian tour',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// 22. Graph Complement Modifier
// ---------------------------------------------------------------------------

class GraphComplementModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'complement';

  @override
  String get name => 'Graph Complement';

  @override
  String get category => 'Transformations';

  @override
  bool get canApply => true;

  @override
  void applyPermanent(AppState state) {
    final out = apply(state.renderGraph, state);
    if (out.transformedGraph != null) {
      state.primaryGraph = out.transformedGraph!;
      state.saveSnapshot();
      state.modifiers.remove(this);
    }
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) =>
      div('form-column')..appendChild(
        p(
          'Constructs the complement graph G̅ where two distinct vertices are adjacent if and only if they are not adjacent in G.',
        ),
      );

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.length < 2) {
      return const ModifierOutput(statusSummary: 'Need at least 2 vertices');
    }

    try {
      final complement = Graph<String, num>(
        isDirected: graph.isDirected,
        vertexStrategy: graph.vertexStrategy,
      )..addVertices(vertices);

      var addedEdges = 0;
      for (var i = 0; i < vertices.length; i++) {
        final u = vertices[i];
        final startJ = graph.isDirected ? 0 : i + 1;
        for (var j = startJ; j < vertices.length; j++) {
          final v = vertices[j];
          if (u != v && !graph.containsEdge(u, v)) {
            complement.addEdge(u, v, value: 1);
            addedEdges++;
          }
        }
      }

      return ModifierOutput(
        transformedGraph: complement,
        statusSummary: 'Complement G̅ ($addedEdges edges)',
        tableData: ModifierTableData(
          title: 'Graph Complement',
          headers: ['Metric', 'Original G', 'Complement G̅'],
          rows: [
            ['Vertices', '${vertices.length}', '${vertices.length}'],
            ['Edges', '${graph.edges.length}', '$addedEdges'],
          ],
        ),
      );
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Complement error: $e',
        statusSummary: 'Error computing complement',
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Modifier Registry / Factory
// ---------------------------------------------------------------------------

class ModifierRegistry {
  static final List<String> availableTypes = [
    'generator',
    'layout',
    'shortest_path',
    'all_pairs_path',
    'centrality',
    'components',
    'biconnected',
    'spanning_tree',
    'cycle_detection',
    'max_flow',
    'min_cut',
    'matching',
    'cliques',
    'vertex_cover',
    'planarity',
    'eulerian',
    'hamiltonian',
    'vertex_coloring',
    'k_core',
    'transitive_closure',
    'transitive_reduction',
    'complement',
  ];

  static String getDisplayName(String type) => switch (type) {
    'generator' => 'Graph Generator',
    'layout' => 'Layout Algorithm',
    'shortest_path' => 'Shortest Path / Traversal',
    'all_pairs_path' => 'All-Pairs Paths (Floyd-Warshall)',
    'centrality' => 'Centrality Heatmap',
    'components' => 'Components & Communities',
    'biconnected' => 'Biconnected & Bridges',
    'spanning_tree' => 'Minimum Spanning Tree',
    'cycle_detection' => 'Cycle Detection',
    'max_flow' => 'Max Flow & Min s-t Cut',
    'min_cut' => 'Global Min Cut (Stoer-Wagner)',
    'matching' => 'Maximum Matching (Blossom)',
    'cliques' => 'Cliques & Independent Set',
    'vertex_cover' => 'Minimum Vertex Cover',
    'planarity' => 'Planarity & Kuratowski',
    'eulerian' => 'Eulerian Circuit / Trail',
    'hamiltonian' => 'Hamiltonian Cycle / Path',
    'vertex_coloring' => 'Vertex Coloring',
    'k_core' => 'k-Core Subgraph',
    'transitive_closure' => 'Transitive Closure',
    'transitive_reduction' => 'Transitive Reduction',
    'complement' => 'Graph Complement',
    _ => type,
  };

  static GraphModifier create(String type) => switch (type) {
    'generator' => GeneratorModifier(),
    'layout' => LayoutModifier(),
    'shortest_path' => ShortestPathModifier(),
    'all_pairs_path' => AllPairsShortestPathModifier(),
    'centrality' => CentralityModifier(),
    'components' => ComponentsModifier(),
    'biconnected' => BiconnectedComponentsModifier(),
    'spanning_tree' => SpanningTreeModifier(),
    'cycle_detection' => CycleDetectionModifier(),
    'max_flow' => MaxFlowModifier(),
    'min_cut' => MinCutModifier(),
    'matching' => MatchingModifier(),
    'cliques' => CliquesModifier(),
    'vertex_cover' => VertexCoverModifier(),
    'planarity' => PlanarityModifier(),
    'eulerian' => EulerianModifier(),
    'hamiltonian' => HamiltonianModifier(),
    'vertex_coloring' => VertexColoringModifier(),
    'k_core' => KCoreModifier(),
    'transitive_closure' => TransitiveClosureModifier(),
    'transitive_reduction' => TransitiveReductionModifier(),
    'complement' => GraphComplementModifier(),
    _ => ShortestPathModifier(),
  };
}
