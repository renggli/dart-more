import 'dart:math' as math;

import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../enums.dart';
import '../state.dart';
import 'base.dart';

// ---------------------------------------------------------------------------
// Base Graph Modifier (Pinned at Index 0)
// ---------------------------------------------------------------------------

class BaseGraphModifier extends GraphModifier {
  new() : super(enabled: true);

  @override
  String get id => 'base_graph';

  @override
  String get name => 'Base Graph';

  @override
  ModifierCategory get category => ModifierCategory.generate;

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
// Generator Modifier (Adds or replaces graphs, can be applied)
// ---------------------------------------------------------------------------

class GeneratorModifier extends GraphModifier {
  new({
    super.enabled,
    this.type = GeneratorShape.atlas,
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
    this.combineMode = GeneratorCombineMode.replace,
  });

  GeneratorShape type;
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
  GeneratorCombineMode combineMode;

  @override
  String get id => 'generator';

  @override
  String get name => 'Graph Generator';

  @override
  ModifierCategory get category => ModifierCategory.generate;

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
        case GeneratorShape.atlas:
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
        case GeneratorShape.tree:
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
        case GeneratorShape.bipartite:
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
        case GeneratorShape.grid:
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
        case GeneratorShape.random:
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
        case GeneratorShape.complete ||
            GeneratorShape.cycle ||
            GeneratorShape.star ||
            GeneratorShape.path:
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
        type.id,
        [for (final s in GeneratorShape.values) (s.id, s.label)],
        onChanged: (val) {
          type = GeneratorShape.fromId(val);
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
        combineMode.id,
        [for (final m in GeneratorCombineMode.values) (m.id, m.label)],
        onChanged: (val) {
          combineMode = GeneratorCombineMode.fromId(val);
          onModified();
        },
      ),
    );

    return container;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final prefix = combineMode == GeneratorCombineMode.union
        ? 'G${count}_'
        : '';
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
      case GeneratorShape.atlas:
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
      case GeneratorShape.complete:
        generated = factory.complete(vertexCount: count);
        statusInfo = 'Complete Graph ($count vertices)';
      case GeneratorShape.cycle:
        generated = factory.ring(vertexCount: count);
        statusInfo = 'Cycle Graph ($count vertices)';
      case GeneratorShape.star:
        generated = factory.star(vertexCount: count);
        statusInfo = 'Star Graph ($count vertices)';
      case GeneratorShape.path:
        generated = factory.path(vertexCount: count);
        statusInfo = 'Path Graph ($count vertices)';
      case GeneratorShape.tree:
        generated = factory.completeTree(vertexCount: count, arity: arity);
        statusInfo = 'Complete $arity-ary Tree ($count vertices)';
      case GeneratorShape.bipartite:
        generated = factory.partite(vertexCounts: [partACount, partBCount]);
        statusInfo = 'Bipartite Graph ($partACount + $partBCount vertices)';
      case GeneratorShape.grid:
        generated = factory.grid(rows: gridRows, columns: gridColumns);
        statusInfo = 'Grid Graph ($gridRows×$gridColumns)';
      case GeneratorShape.random:
        generated = factory.randomErdosRenyi(
          vertexCount: count,
          probability: prob,
        );
        statusInfo =
            'Random G(n,p) ($count vertices, p=${prob.toStringAsFixed(2)})';
    }

    // Assign layout coordinates for generated vertices
    const cx = 450.0;
    const cy = 300.0;
    final generatedVertices = generated.vertices.toList();
    final radius = math.max(120.0, generatedVertices.length * 22.0);

    for (var i = 0; i < generatedVertices.length; i++) {
      final v = generatedVertices[i];
      final node = state.getOrCreateNode(v);
      if (node.x == null ||
          node.y == null ||
          combineMode == GeneratorCombineMode.replace) {
        final angle =
            (2 * math.pi * i / math.max(1, generatedVertices.length)) -
            (math.pi / 2);
        node.x = cx + radius * math.cos(angle);
        node.y = cy + radius * math.sin(angle);
      }
    }

    if (combineMode == GeneratorCombineMode.replace) {
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
