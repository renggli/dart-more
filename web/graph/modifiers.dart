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

  /// Builds configuration UI controls inside the modifier card (accessible, stacked vertically).
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified);

  /// Executes this modifier in the pipeline over [graph].
  ModifierOutput apply(Graph<String, num> graph, AppState state);
}

// ---------------------------------------------------------------------------
// Helpers for Accessible Vertically-Stacked Form Rows
// ---------------------------------------------------------------------------

web.HTMLElement _vertexField(
  String labelText,
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
  return stackedField(labelText, s);
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

    container.appendChild(
      dropdownSetting(
        'Graph Directness:',
        state.primaryGraph.isDirected ? 'directed' : 'undirected',
        const [
          ('directed', 'Directed Graph'),
          ('undirected', 'Undirected Graph'),
        ],
        onChanged: (val) {
          final wantDirected = val == 'directed';
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
        },
      ),
    );

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
  new({
    super.enabled,
    String? type,
    this.count = 6,
    this.atlasIndex = 7,
    this.atlasVertices,
    this.atlasEdges,
    this.arity = 2,
    this.partACount = 3,
    this.partBCount = 3,
    this.gridRows = 3,
    this.gridColumns = 3,
    this.prob = 0.35,
    this.seed = 42,
    String? combineMode,
  }) : type = type ?? 'atlas',
       combineMode = combineMode ?? 'replace';

  String
  type; // atlas, complete, cycle, star, tree, bipartite, path, grid, random
  int count;
  int atlasIndex;
  int? atlasVertices;
  int? atlasEdges;
  int arity;
  int partACount;
  int partBCount;
  int gridRows;
  int gridColumns;
  double prob;
  int seed;
  String combineMode; // 'replace' or 'union'

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
    final dynamicSection = div('form-column');

    void rebuildDynamicFields() {
      dynamicSection.textContent = '';

      switch (type) {
        case 'atlas':
          dynamicSection.appendChild(
            rangeSetting(
              'Atlas Graph #:',
              atlasIndex,
              min: 0,
              max: 1252,
              onChanged: (v) {
                atlasIndex = v.toInt();
                onModified();
              },
            ),
          );
          dynamicSection.appendChild(
            optionalIntSetting(
              'Filter Vertex Count (V):',
              atlasVertices,
              min: 0,
              max: 7,
              onChanged: (v) {
                atlasVertices = v;
                onModified();
              },
            ),
          );
          dynamicSection.appendChild(
            optionalIntSetting(
              'Filter Edge Count (E):',
              atlasEdges,
              min: 0,
              max: 21,
              onChanged: (v) {
                atlasEdges = v;
                onModified();
              },
            ),
          );
        case 'tree':
          dynamicSection.appendChild(
            rangeSetting(
              'Vertex Count (n):',
              count,
              min: 1,
              max: 100,
              onChanged: (v) {
                count = v.toInt();
                onModified();
              },
            ),
          );
          dynamicSection.appendChild(
            intSetting(
              'Branching Factor (m):',
              arity,
              min: 2,
              max: 10,
              onChanged: (v) {
                arity = v;
                onModified();
              },
            ),
          );
        case 'bipartite':
          dynamicSection.appendChild(
            intSetting(
              'Part A Vertices (m):',
              partACount,
              min: 1,
              max: 50,
              onChanged: (v) {
                partACount = v;
                onModified();
              },
            ),
          );
          dynamicSection.appendChild(
            intSetting(
              'Part B Vertices (n):',
              partBCount,
              min: 1,
              max: 50,
              onChanged: (v) {
                partBCount = v;
                onModified();
              },
            ),
          );
        case 'grid':
          dynamicSection.appendChild(
            intSetting(
              'Rows:',
              gridRows,
              min: 1,
              max: 20,
              onChanged: (v) {
                gridRows = v;
                onModified();
              },
            ),
          );
          dynamicSection.appendChild(
            intSetting(
              'Columns:',
              gridColumns,
              min: 1,
              max: 20,
              onChanged: (v) {
                gridColumns = v;
                onModified();
              },
            ),
          );
        case 'random':
          dynamicSection.appendChild(
            rangeSetting(
              'Vertex Count (n):',
              count,
              min: 1,
              max: 100,
              onChanged: (v) {
                count = v.toInt();
                onModified();
              },
            ),
          );
          dynamicSection.appendChild(
            rangeSetting(
              'Edge Probability (p):',
              prob,
              min: 0.0,
              max: 1.0,
              step: 0.05,
              onChanged: (v) {
                prob = v.toDouble();
                onModified();
              },
            ),
          );
          dynamicSection.appendChild(
            seedSetting(
              'Random Seed:',
              seed,
              onChanged: (v) {
                seed = v;
                onModified();
              },
            ),
          );
        default:
          dynamicSection.appendChild(
            rangeSetting(
              'Vertex Count (n):',
              count,
              min: 1,
              max: 100,
              onChanged: (v) {
                count = v.toInt();
                onModified();
              },
            ),
          );
      }
    }

    container.appendChild(
      dropdownSetting(
        'Preset Shape:',
        type,
        const [
          ('atlas', 'Atlas Graph (Read & Wilson)'),
          ('complete', 'Complete Graph'),
          ('cycle', 'Cycle Graph'),
          ('star', 'Star Graph'),
          ('path', 'Path Graph'),
          ('tree', 'Complete m-ary Tree'),
          ('bipartite', 'Bipartite Graph'),
          ('grid', 'Grid Graph'),
          ('random', 'Random (Erdős–Rényi G(n,p))'),
        ],
        onChanged: (val) {
          type = val;
          rebuildDynamicFields();
          onModified();
        },
      ),
    );

    rebuildDynamicFields();
    container.appendChild(dynamicSection);

    container.appendChild(
      dropdownSetting(
        'Combine Mode:',
        combineMode,
        const [
          ('replace', 'Replace existing graph'),
          ('union', 'Merge into existing graph'),
        ],
        onChanged: (val) {
          combineMode = val;
          onModified();
        },
      ),
    );

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final prefix = combineMode == 'union' ? 'G${count}_' : '';
    final factory = GraphFactory<String, num>(
      isDirected: graph.isDirected,
      vertexProvider: (i) =>
          '$prefix${i < 26 ? String.fromCharCode(65 + i) : (i + 1)}',
      edgeProvider: (u, v) => 1,
      random: math.Random(seed),
    );

    Graph<String, num> generated;
    String statusInfo;

    switch (type) {
      case 'atlas':
        final int actualIndex;
        if (atlasVertices != null || atlasEdges != null) {
          final matches = factory
              .atlasMatching(vertexCount: atlasVertices, edgeCount: atlasEdges)
              .toList();
          if (matches.isEmpty) {
            return const ModifierOutput(
              hasError: true,
              errorMessage: 'No atlas graph matches the vertex/edge filter.',
              statusSummary: 'Atlas: no matching graphs',
            );
          }
          actualIndex = atlasIndex.clamp(0, matches.length - 1);
          generated = matches[actualIndex];
        } else {
          actualIndex = atlasIndex.clamp(0, factory.atlasLength - 1);
          generated = factory.atlas(actualIndex);
        }
        if (graph.isDirected) {
          final bidi = Graph<String, num>(isDirected: true);
          for (final v in generated.vertices) {
            bidi.addVertex(v);
          }
          for (final e in generated.edges) {
            bidi.addEdge(e.source, e.target, value: e.value);
            bidi.addEdge(e.target, e.source, value: e.value);
          }
          generated = bidi;
        }
        statusInfo =
            'Atlas G$actualIndex (${generated.vertices.length} vertices, ${generated.edges.length} edges)';
      case 'complete':
        generated = factory.complete(vertexCount: count);
        statusInfo = 'Complete Graph ($count vertices)';
      case 'cycle':
        generated = factory.ring(vertexCount: count);
        statusInfo = 'Cycle Graph ($count vertices)';
      case 'star':
        generated = factory.star(vertexCount: count);
        statusInfo = 'Star Graph ($count vertices)';
      case 'path':
        generated = factory.path(vertexCount: count);
        statusInfo = 'Path Graph ($count vertices)';
      case 'tree':
        generated = factory.completeTree(vertexCount: count, arity: arity);
        statusInfo = 'Complete $arity-ary Tree ($count vertices)';
      case 'bipartite':
        generated = factory.partite(vertexCounts: [partACount, partBCount]);
        statusInfo = 'Bipartite Graph ($partACount + $partBCount vertices)';
      case 'grid':
        generated = factory.grid(rows: gridRows, columns: gridColumns);
        statusInfo = 'Grid Graph ($gridRows×$gridColumns)';
      case 'random':
        generated = factory.randomErdosRenyi(
          vertexCount: count,
          probability: prob,
        );
        statusInfo =
            'Random G(n,p) ($count vertices, p=${prob.toStringAsFixed(2)})';
      default:
        generated = factory.complete(vertexCount: count);
        statusInfo = 'Generated Graph ($count vertices)';
    }

    // Assign layout coordinates for generated vertices
    const cx = 450.0;
    const cy = 300.0;
    final generatedVertices = generated.vertices.toList();
    final radius = math.max(120.0, generatedVertices.length * 22.0);

    for (var i = 0; i < generatedVertices.length; i++) {
      final v = generatedVertices[i];
      final node = state.getOrCreateNode(v);
      if (node.x == null || node.y == null || combineMode == 'replace') {
        final angle =
            (2 * math.pi * i / math.max(1, generatedVertices.length)) -
            (math.pi / 2);
        node.x = cx + radius * math.cos(angle);
        node.y = cy + radius * math.sin(angle);
      }
    }

    if (combineMode == 'replace') {
      return ModifierOutput(
        transformedGraph: generated,
        statusSummary: statusInfo,
      );
    }

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
      statusSummary: 'Merge +$statusInfo',
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
    this.vertexDistance = 60.0,
    this.layerDistance = 80.0,
    this.iterations = 100,
    this.columns = 0,
    this.seed = 42,
    this.removeOverlaps = true,
    this.packComponents = true,
  }) : algorithm = algorithm ?? 'stress',
       rankDir = rankDir ?? 'TB';

  String algorithm;
  String rankDir;
  double vertexDistance;
  double layerDistance;
  int iterations;
  int columns;
  int seed;
  bool removeOverlaps;
  bool packComponents;

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
    final dynamicSection = div('form-column');

    void rebuildDynamicFields() {
      dynamicSection.textContent = '';

      // Spacing / Vertex Distance control (applicable to all layouts except random)
      if (algorithm != 'random') {
        dynamicSection.appendChild(
          rangeSetting(
            'Node Spacing (px):',
            vertexDistance,
            min: 10,
            max: 250,
            step: 5,
            onChanged: (v) {
              vertexDistance = v.toDouble();
              onModified();
            },
          ),
        );
      }

      // Directional layout controls
      if (algorithm == 'layered' ||
          algorithm == 'tree' ||
          algorithm == 'bipartite') {
        dynamicSection.appendChild(
          dropdownSetting(
            'Flow Direction:',
            rankDir,
            [
              for (final dir in RankDir.values)
                (dir.id, '${dir.label} (${dir.id})'),
            ],
            onChanged: (val) {
              rankDir = val;
              onModified();
            },
          ),
        );
      }

      if (algorithm == 'layered' ||
          algorithm == 'tree' ||
          algorithm == 'bipartite' ||
          algorithm == 'radial' ||
          algorithm == 'shell') {
        dynamicSection.appendChild(
          rangeSetting(
            'Layer Distance (px):',
            layerDistance,
            min: 20,
            max: 300,
            step: 5,
            onChanged: (v) {
              layerDistance = v.toDouble();
              onModified();
            },
          ),
        );
      }

      // Iterative simulation controls
      if (algorithm == 'stress' ||
          algorithm == 'force' ||
          algorithm == 'spectral') {
        dynamicSection.appendChild(
          rangeSetting(
            'Iterations:',
            iterations,
            min: 10,
            max: 500,
            step: 10,
            onChanged: (v) {
              iterations = v.toInt();
              onModified();
            },
          ),
        );
      }

      // Grid columns control
      if (algorithm == 'grid') {
        dynamicSection.appendChild(
          intSetting(
            'Columns (0 for auto):',
            columns,
            min: 0,
            max: 50,
            onChanged: (v) {
              columns = v;
              onModified();
            },
          ),
        );
      }

      // Seed control
      if (algorithm == 'random' ||
          algorithm == 'stress' ||
          algorithm == 'force' ||
          algorithm == 'spectral') {
        dynamicSection.appendChild(
          seedSetting(
            'Random Seed:',
            seed,
            onChanged: (v) {
              seed = v;
              onModified();
            },
          ),
        );
      }

      dynamicSection.appendChild(
        checkboxSetting(
          'Remove overlaps',
          removeOverlaps,
          onChanged: (v) {
            removeOverlaps = v;
            onModified();
          },
        ),
      );
      dynamicSection.appendChild(
        checkboxSetting(
          'Pack components',
          packComponents,
          onChanged: (v) {
            packComponents = v;
            onModified();
          },
        ),
      );
    }

    container.appendChild(
      dropdownSetting(
        'Layout Algorithm:',
        algorithm,
        [for (final engine in LayoutEngine.values) (engine.id, engine.label)],
        onChanged: (val) {
          algorithm = val;
          rebuildDynamicFields();
          onModified();
        },
      ),
    );

    rebuildDynamicFields();
    container.appendChild(dynamicSection);

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
      graph: graph,
      engine: algorithm,
      rankdir: rankDir,
      vertexDistance: vertexDistance,
      layerDistance: layerDistance,
      iterations: iterations,
      columns: columns > 0 ? columns : null,
      seed: seed,
      removeOverlaps: removeOverlaps,
      packComponents: packComponents,
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

    root.appendChild(
      dropdownSetting(
        'Algorithm:',
        algorithm,
        const [
          ('dijkstra', 'Dijkstra'),
          ('a_star', 'A* Search'),
          ('bellman_ford', 'Bellman-Ford'),
          ('bfs', 'Breadth-First'),
          ('dfs', 'Depth-First'),
        ],
        onChanged: (val) {
          algorithm = val;
          onModified();
        },
      ),
    );

    root.appendChild(
      _vertexField(
        'Source Vertex:',
        state,
        sourceVertex,
        '(Selected / First)',
        (v) {
          sourceVertex = v;
          onModified();
        },
      ),
    );

    root.appendChild(
      _vertexField(
        'Target Vertex:',
        state,
        targetVertex,
        '(Selected Target / Last)',
        (v) {
          targetVertex = v;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Path Color:',
        pathColor,
        onChanged: (c) {
          pathColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      lineStyleSetting(
        'Line Style:',
        pathPattern,
        onChanged: (p) {
          pathPattern = p;
          onModified();
        },
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

    final dash = pathPattern != 'none' ? pathPattern : null;
    final color = pathColor != 'none' ? pathColor : null;
    final pathVertices = path.vertices.toList();
    final pathEdges = <(String, String)>[];
    for (var i = 0; i < pathVertices.length - 1; i++) {
      final edgeKey = (pathVertices[i], pathVertices[i + 1]);
      pathEdges.add(edgeKey);
      if (color != null || dash != null) {
        final edgeStyle = state.getEdgeStyle(edgeKey.$1, edgeKey.$2);
        if (color != null) {
          edgeStyle.color = color;
          edgeStyle.strokeWidth = 3.0;
        }
        edgeStyle.dashPattern = dash;
      }
    }

    for (final v in pathVertices) {
      final node = state.nodes[v];
      if (node != null && (color != null || dash != null)) {
        if (color != null) {
          node.style.borderColor = color;
          node.style.borderWidth = 2.5;
        }
        node.style.dashPattern = dash;
      }
    }

    final rows = <List<String>>[];
    num cumulativeWeight = 0;
    for (var i = 0; i < pathVertices.length; i++) {
      if (i > 0) {
        final u = pathVertices[i - 1];
        final v = pathVertices[i];
        final e =
            graph.getEdge(u, v) ??
            (!graph.isDirected ? graph.getEdge(v, u) : null);
        cumulativeWeight += algorithm == 'bfs' ? 1 : (e?.value ?? 1);
      }
      rows.add(['#$i', pathVertices[i], '$cumulativeWeight']);
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
        rows: rows,
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

    root.appendChild(
      dropdownSetting(
        'Centrality Metric:',
        metric,
        const [
          ('betweenness', 'Betweenness Centrality'),
          ('pagerank', 'PageRank'),
          ('degree', 'Degree Centrality'),
          ('eigenvector', 'Eigenvector Centrality'),
        ],
        onChanged: (val) {
          metric = val;
          onModified();
        },
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

    root.appendChild(
      dropdownSetting(
        'Component Mode:',
        mode,
        const [
          ('weakly', 'Connected Components'),
          ('strongly', 'Strongly Connected (Tarjan)'),
          ('biconnected', 'Biconnected Components'),
        ],
        onChanged: (val) {
          mode = val;
          onModified();
        },
      ),
    );

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

    root.appendChild(
      dropdownSetting(
        'Algorithm:',
        algorithm,
        const [
          ('kruskal', "Kruskal's Algorithm"),
          ('prim', "Prim's Algorithm"),
        ],
        onChanged: (val) {
          algorithm = val;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Tree Color:',
        treeColor,
        onChanged: (c) {
          treeColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      lineStyleSetting(
        'Tree Line Style:',
        treePattern,
        onChanged: (p) {
          treePattern = p;
          onModified();
        },
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

    final dash = treePattern != 'none' ? treePattern : null;
    final color = treeColor != 'none' ? treeColor : null;
    final treeEdges = tree.edges.toSet();
    num totalWeight = 0;
    final rows = <List<String>>[];

    for (final e in treeEdges) {
      totalWeight += e.value;
      rows.add(['${e.source} — ${e.target}', '${e.value}', '$totalWeight']);

      if (color != null || dash != null) {
        final edgeStyle = state.getEdgeStyle(e.source, e.target);
        if (color != null) {
          edgeStyle.color = color;
          edgeStyle.strokeWidth = 2.5;
        }
        edgeStyle.dashPattern = dash;
      }
    }

    // Dim non-tree edges
    for (final e in graph.edges.toSet()) {
      if (!tree.containsEdge(e.source, e.target) &&
          !tree.containsEdge(e.target, e.source)) {
        final edgeStyle = state.getEdgeStyle(e.source, e.target);
        edgeStyle.opacity = 0.25;
      }
    }

    return ModifierOutput(
      statusSummary: 'MST Weight: $totalWeight (${treeEdges.length} edges)',
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
  void Function(List<List<String>> cycles)? _onCyclesChanged;

  @override
  String get id => 'cycle_detection';

  @override
  String get name => 'Cycle Detection';

  @override
  String get category => 'Structure';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');
    final dropdownContainer = div();

    void updateDropdown(List<List<String>> currentCycles) {
      dropdownContainer.textContent = '';
      if (currentCycles.isNotEmpty) {
        if (selectedCycleIndex >= currentCycles.length) {
          selectedCycleIndex = -1;
        }
        final options = <(String, String)>[
          ('-1', 'All Discovered Cycles (${currentCycles.length})'),
          for (var i = 0; i < currentCycles.length; i++)
            (
              '$i',
              'Cycle #${i + 1} (${currentCycles[i].length - 1} edges: ${currentCycles[i].take(4).join(' → ')}${currentCycles[i].length > 5 ? ' …' : ''})',
            ),
        ];
        dropdownContainer.appendChild(
          dropdownSetting(
            'Display Cycle:',
            '$selectedCycleIndex',
            options,
            onChanged: (val) {
              selectedCycleIndex = int.tryParse(val) ?? -1;
              onModified();
            },
          ),
        );
      }
    }

    final cycles = _findCycles(state.renderGraph);
    updateDropdown(cycles);
    _onCyclesChanged = updateDropdown;
    root.appendChild(dropdownContainer);

    root.appendChild(
      colorSetting(
        'Cycle Color:',
        cycleColor,
        onChanged: (c) {
          cycleColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      lineStyleSetting(
        'Cycle Line Style:',
        cyclePattern,
        onChanged: (p) {
          cyclePattern = p;
          onModified();
        },
      ),
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      _onCyclesChanged?.call(const []);
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    final cycles = _findCycles(graph);
    _onCyclesChanged?.call(cycles);
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

    final dash = cyclePattern != 'none' ? cyclePattern : null;
    final color = cycleColor != 'none' ? cycleColor : null;
    final cycleEdges = <(String, String)>[];
    for (final cycle in cyclesToHighlight) {
      for (var i = 0; i < cycle.length - 1; i++) {
        final u = cycle[i];
        final v = cycle[i + 1];
        cycleEdges.add((u, v));
        if (!graph.isDirected) {
          cycleEdges.add((v, u));
        }
        if (color != null || dash != null) {
          final edgeStyle = state.getEdgeStyle(
            u,
            v,
            isDirected: graph.isDirected,
          );
          if (color != null) {
            edgeStyle.color = color;
            edgeStyle.strokeWidth = 3.0;
          }
          edgeStyle.dashPattern = dash;
        }
      }
      for (final v in cycle) {
        final node = state.nodes[v];
        if (node != null && (color != null || dash != null)) {
          if (color != null) {
            node.style.borderColor = color;
            node.style.borderWidth = 2.5;
          }
          node.style.dashPattern = dash;
        }
      }
    }

    final primaryVertices = {for (final cycle in cyclesToHighlight) ...cycle}
        .toList();
    final overlay = PathOverlay(
      vertices: primaryVertices,
      edges: cycleEdges,
      title: 'Discovered ${cycles.length} Cycles',
      color: color,
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
    final dashControls = div('form-column');

    void rebuildDashControls() {
      dashControls.textContent = '';
      if (removedStyle == 'dash') {
        dashControls.appendChild(
          colorSetting(
            'Removed Border Color:',
            dashColor,
            onChanged: (c) {
              dashColor = c;
              onModified();
            },
          ),
        );
        dashControls.appendChild(
          lineStyleSetting(
            'Removed Line Style:',
            dashPattern,
            onChanged: (p) {
              dashPattern = p;
              onModified();
            },
          ),
        );
      }
    }

    container.appendChild(
      rangeSetting(
        'Degree Threshold (k):',
        k,
        min: 1,
        max: 20,
        onChanged: (v) {
          k = v.toInt();
          onModified();
        },
      ),
    );

    container.appendChild(
      dropdownSetting(
        'Removed Vertices Style:',
        removedStyle,
        const [
          ('dash', 'Dash & Dim Removed Vertices'),
          ('filter', 'Filter / Remove From View'),
        ],
        onChanged: (val) {
          removedStyle = val;
          rebuildDashControls();
          onModified();
        },
      ),
    );

    rebuildDashControls();
    container.appendChild(dashControls);

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
      final dash = dashPattern != 'none' ? dashPattern : null;
      final color = dashColor != 'none' ? dashColor : null;
      for (final v in graph.vertices) {
        if (!coreVerts.contains(v)) {
          final node = state.nodes[v];
          if (node != null) {
            if (color != null) {
              node.style.borderColor = color;
              node.style.borderWidth = 2.0;
            }
            node.style.dashPattern = dash;
            node.style.opacity = 0.45;
          }
          for (final e in graph.edgesOf(v)) {
            final es = state.getEdgeStyle(e.source, e.target);
            if (color != null) {
              es.color = color;
            }
            es.dashPattern = dash;
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
      colorSetting(
        'Added Edge / Vertex Color:',
        addedColor,
        onChanged: (c) {
          addedColor = c;
          onModified();
        },
      ),
    );

    container.appendChild(
      lineStyleSetting(
        'Added Line Style:',
        addedPattern,
        onChanged: (p) {
          addedPattern = p;
          onModified();
        },
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

    final dash = addedPattern != 'none' ? addedPattern : null;
    final color = addedColor != 'none' ? addedColor : null;
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
        if (color != null) {
          es.color = color;
          es.strokeWidth = 2.2;
        }
        es.dashPattern = dash;

        final srcNode = state.nodes[edge.source];
        if (srcNode != null && srcNode.style.borderColor == null) {
          if (color != null) srcNode.style.borderColor = color;
          srcNode.style.dashPattern = dash;
        }
        final tgtNode = state.nodes[edge.target];
        if (tgtNode != null && tgtNode.style.borderColor == null) {
          if (color != null) tgtNode.style.borderColor = color;
          tgtNode.style.dashPattern = dash;
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
    final dashControls = div('form-column');

    void rebuildDashControls() {
      dashControls.textContent = '';
      if (keepRemovedDashedInView) {
        dashControls.appendChild(
          colorSetting(
            'Removed Border & Stroke Color:',
            removedColor,
            onChanged: (c) {
              removedColor = c;
              onModified();
            },
          ),
        );
        dashControls.appendChild(
          lineStyleSetting(
            'Removed Line Style:',
            removedPattern,
            onChanged: (p) {
              removedPattern = p;
              onModified();
            },
          ),
        );
      }
    }

    container.appendChild(
      checkboxSetting(
        'Keep removed edges dashed in view',
        keepRemovedDashedInView,
        onChanged: (val) {
          keepRemovedDashedInView = val;
          rebuildDashControls();
          onModified();
        },
      ),
    );

    rebuildDashControls();
    container.appendChild(dashControls);

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

    final dash = removedPattern != 'none' ? removedPattern : null;
    final color = removedColor != 'none' ? removedColor : null;
    var removedEdgesCount = 0;
    // Identify removed edges
    for (final edge in graph.edges) {
      if (!reduced.containsEdge(edge.source, edge.target)) {
        removedEdgesCount++;
        if (keepRemovedDashedInView) {
          // Keep edge in graph view but style as dashed and colored
          reducedGraph.addEdge(edge.source, edge.target, value: edge.value);
          final es = state.getEdgeStyle(edge.source, edge.target);
          if (color != null) es.color = color;
          es.dashPattern = dash;
          es.opacity = 0.45;
        }
      }
    }

    // Check vertices with 0 degree after reduction and style dashed if requested
    for (final v in reducedGraph.vertices) {
      if (reducedGraph.degreeOf(v) == 0 && graph.degreeOf(v) > 0) {
        final node = state.nodes[v];
        if (node != null) {
          if (color != null) node.style.borderColor = color;
          node.style.dashPattern = dash;
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
  String bridgePattern = '6,4';

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
      colorSetting(
        'Articulation Point Color:',
        pointColor,
        onChanged: (c) {
          pointColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      colorSetting(
        'Bridge Edge Color:',
        bridgeColor,
        onChanged: (c) {
          bridgeColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      lineStyleSetting(
        'Bridge Line Style:',
        bridgePattern,
        onChanged: (p) {
          bridgePattern = p;
          onModified();
        },
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
      final dash = bridgePattern != 'none' ? bridgePattern : null;
      final ptColor = pointColor != 'none' ? pointColor : null;
      final brColor = bridgeColor != 'none' ? bridgeColor : null;

      if (ptColor != null) {
        for (final v in cutVertices) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = ptColor;
            node.style.borderWidth = 3.5;
          }
        }
      }

      if (brColor != null || dash != null) {
        for (final b in bridgeEdges) {
          final es = state.getEdgeStyle(b.source, b.target);
          if (brColor != null) {
            es.color = brColor;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
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
  String cutPattern = '6,4';
  String sourcePartitionColor = '#06b6d4';
  String sinkPartitionColor = '#f59e0b';

  @override
  String get id => 'max_flow';

  @override
  String get name => 'Max Flow & Min s-t Cut';

  @override
  String get category => 'Flows & Cuts';

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      _vertexField(
        'Source Vertex (s):',
        state,
        sourceVertex,
        '(Selected / First)',
        (v) {
          sourceVertex = v;
          onModified();
        },
      ),
    );

    root.appendChild(
      _vertexField(
        'Sink Vertex (t):',
        state,
        targetVertex,
        '(Selected / Last)',
        (v) {
          targetVertex = v;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Flow Edge Color:',
        flowColor,
        onChanged: (c) {
          flowColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Cut Edge Color:',
        cutColor,
        onChanged: (c) {
          cutColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      lineStyleSetting(
        'Cut Line Style:',
        cutPattern,
        onChanged: (p) {
          cutPattern = p;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Source Partition Color:',
        sourcePartitionColor,
        onChanged: (c) {
          sourcePartitionColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Sink Partition Color:',
        sinkPartitionColor,
        onChanged: (c) {
          sinkPartitionColor = c;
          onModified();
        },
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
      num capacityOf(String u, String v) {
        final edge = graph.getEdge(u, v);
        final cap = edge?.value ?? 1;
        return cap > 0 ? cap : 1;
      }

      final dinic = graph.maxFlow(edgeCapacity: capacityOf);
      final maxFlowValue = dinic(s, t);

      // Identify source partition S via BFS reachability in residual graph
      final reachable = <String>{s};
      final queue = <String>[s];
      while (queue.isNotEmpty) {
        final curr = queue.removeAt(0);
        for (final next in graph.successorsOf(curr)) {
          if (!reachable.contains(next) &&
              dinic.flow(curr, next) < capacityOf(curr, next)) {
            reachable.add(next);
            queue.add(next);
          }
        }
        for (final prev in graph.predecessorsOf(curr)) {
          if (!reachable.contains(prev) && dinic.flow(prev, curr) > 0) {
            reachable.add(prev);
            queue.add(prev);
          }
        }
      }

      // Style source and target sets
      for (final v in vertices) {
        final node = state.nodes[v];
        final partColor = reachable.contains(v)
            ? sourcePartitionColor
            : sinkPartitionColor;
        if (node != null && partColor != 'none') {
          node.style.borderColor = partColor;
          node.style.borderWidth = (v == s || v == t) ? 3.5 : 2.0;
        }
      }

      final dash = cutPattern != 'none' ? cutPattern : null;
      final cColor = cutColor != 'none' ? cutColor : null;
      final fColor = flowColor != 'none' ? flowColor : null;

      // Highlight flow edges and cut edges
      for (final edge in graph.edges.toSet()) {
        final isCut =
            reachable.contains(edge.source) && !reachable.contains(edge.target);
        final f = dinic.flow(edge.source, edge.target);
        if (isCut && (cColor != null || dash != null)) {
          final es = state.getEdgeStyle(edge.source, edge.target);
          if (cColor != null) {
            es.color = cColor;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        } else if (f > 0 && fColor != null) {
          final es = state.getEdgeStyle(edge.source, edge.target);
          es.color = fColor;
          es.strokeWidth = 2.8;
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
  String cutPattern = '6,4';
  String partitionAColor = '#06b6d4';
  String partitionBColor = '#f59e0b';

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
      colorSetting(
        'Cut Edges Color:',
        cutColor,
        onChanged: (c) {
          cutColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      lineStyleSetting(
        'Cut Line Style:',
        cutPattern,
        onChanged: (p) {
          cutPattern = p;
          onModified();
        },
      ),
    );
    root.appendChild(
      colorSetting(
        'Partition A Color:',
        partitionAColor,
        onChanged: (c) {
          partitionAColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      colorSetting(
        'Partition B Color:',
        partitionBColor,
        onChanged: (c) {
          partitionBColor = c;
          onModified();
        },
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
      final dash = cutPattern != 'none' ? cutPattern : null;
      final cColor = cutColor != 'none' ? cutColor : null;

      for (final v in vertices) {
        final node = state.nodes[v];
        final partColor = partition.contains(v)
            ? partitionAColor
            : partitionBColor;
        if (node != null && partColor != 'none') {
          node.style.borderColor = partColor;
          node.style.borderWidth = 2.5;
        }
      }

      // Color internal partition edges subtly and cut edges prominently
      for (final edge in graph.edges.toSet()) {
        final inA1 = partition.contains(edge.source);
        final inA2 = partition.contains(edge.target);
        if (inA1 == inA2) {
          final partColor = inA1 ? partitionAColor : partitionBColor;
          if (partColor != 'none') {
            final es = state.getEdgeStyle(edge.source, edge.target);
            es.color = partColor;
          }
        }
      }

      if (cColor != null || dash != null) {
        for (final edge in minCutObj.edges) {
          final es = state.getEdgeStyle(edge.source, edge.target);
          if (cColor != null) {
            es.color = cColor;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        }
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
  String matchingPattern = 'none';

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
      colorSetting(
        'Matching Color:',
        matchingColor,
        onChanged: (c) {
          matchingColor = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      lineStyleSetting(
        'Matching Line Style:',
        matchingPattern,
        onChanged: (p) {
          matchingPattern = p;
          onModified();
        },
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

      final dash = matchingPattern != 'none' ? matchingPattern : null;
      final color = matchingColor != 'none' ? matchingColor : null;
      for (final edge in matchedEdges) {
        if (color != null || dash != null) {
          final es = state.getEdgeStyle(edge.$1, edge.$2);
          if (color != null) {
            es.color = color;
            es.strokeWidth = 4.0;
          }
          es.dashPattern = dash;
        }
        if (color != null) {
          state.nodes[edge.$1]?.style.borderColor = color;
          state.nodes[edge.$2]?.style.borderColor = color;
        }
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

    root.appendChild(
      dropdownSetting(
        'Mode:',
        mode,
        const [
          ('cliques', 'Maximal Cliques (Bron-Kerbosch)'),
          ('independent_set', 'Maximum Independent Set'),
        ],
        onChanged: (val) {
          mode = val;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Highlight Color:',
        highlightColor,
        onChanged: (c) {
          highlightColor = c;
          onModified();
        },
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
      final color = highlightColor != 'none' ? highlightColor : null;
      if (mode == 'independent_set') {
        final indSet = graph.maximumIndependentSet();
        if (color != null) {
          for (final v in indSet) {
            final node = state.nodes[v];
            if (node != null) {
              node.style.borderColor = color;
              node.style.borderWidth = 3.5;
            }
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
        if (color != null) {
          for (final v in activeClique) {
            final node = state.nodes[v];
            if (node != null) {
              node.style.borderColor = color;
              node.style.borderWidth = 3.5;
            }
          }
          for (final u in activeClique) {
            for (final v in activeClique) {
              if (u != v && graph.containsEdge(u, v)) {
                final es = state.getEdgeStyle(u, v);
                es.color = color;
                es.strokeWidth = 3.0;
              }
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

    root.appendChild(
      checkboxSetting(
        '2-Approximation (fast)',
        approximate,
        onChanged: (val) {
          approximate = val;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Cover Color:',
        coverColor,
        onChanged: (c) {
          coverColor = c;
          onModified();
        },
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
      if (coverColor != 'none') {
        for (final v in cover) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = coverColor;
            node.style.borderWidth = 3.5;
          }
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
      final eCount = graph.edges.toSet().length;
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
  String tourPattern = 'none';
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

    root.appendChild(
      checkboxSetting(
        'Only circuit (closed)',
        requireCircuit,
        onChanged: (val) {
          requireCircuit = val;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Trail Color:',
        tourColor,
        onChanged: (c) {
          tourColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      lineStyleSetting(
        'Trail Line Style:',
        tourPattern,
        onChanged: (p) {
          tourPattern = p;
          onModified();
        },
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

      final dash = tourPattern != 'none' ? tourPattern : null;
      final color = tourColor != 'none' ? tourColor : null;
      final tourVertices = tour.vertices.toList();
      final tourEdges = <(String, String)>[];
      for (var i = 0; i < tourVertices.length - 1; i++) {
        final key = (tourVertices[i], tourVertices[i + 1]);
        tourEdges.add(key);
        if (color != null || dash != null) {
          final es = state.getEdgeStyle(key.$1, key.$2);
          if (color != null) {
            es.color = color;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        }
      }

      for (final v in tourVertices) {
        final node = state.nodes[v];
        if (node != null && (color != null || dash != null)) {
          if (color != null) node.style.borderColor = color;
          node.style.dashPattern = dash;
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
  String tourPattern = 'none';
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

    root.appendChild(
      checkboxSetting(
        'Only circuit (closed)',
        requireCircuit,
        onChanged: (val) {
          requireCircuit = val;
          onModified();
        },
      ),
    );

    root.appendChild(
      colorSetting(
        'Path Color:',
        tourColor,
        onChanged: (c) {
          tourColor = c;
          onModified();
        },
      ),
    );

    root.appendChild(
      lineStyleSetting(
        'Path Line Style:',
        tourPattern,
        onChanged: (p) {
          tourPattern = p;
          onModified();
        },
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

      final dash = tourPattern != 'none' ? tourPattern : null;
      final color = tourColor != 'none' ? tourColor : null;
      final tourVertices = tour.vertices.toList();
      final tourEdges = <(String, String)>[];
      for (var i = 0; i < tourVertices.length - 1; i++) {
        final key = (tourVertices[i], tourVertices[i + 1]);
        tourEdges.add(key);
        if (color != null || dash != null) {
          final es = state.getEdgeStyle(key.$1, key.$2);
          if (color != null) {
            es.color = color;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        }
      }

      for (final v in tourVertices) {
        final node = state.nodes[v];
        if (node != null && (color != null || dash != null)) {
          if (color != null) node.style.borderColor = color;
          node.style.dashPattern = dash;
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
