import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../enums.dart';
import '../state.dart';
import 'base.dart';
import 'ui_helpers.dart';

// ---------------------------------------------------------------------------
// Graph Complement Modifier
// ---------------------------------------------------------------------------

class GraphComplementModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'complement';

  @override
  String get name => 'Complement';

  @override
  ModifierCategory get category => ModifierCategory.transform;

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
      final complement = graph.complement(
        allowSelfLoops: false,
        edge: (u, v) => 1,
      );
      final addedEdges = complement.edges.length;

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
// Transitive Closure Modifier
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
  ModifierCategory get category => ModifierCategory.transform;

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
// Transitive Reduction Modifier
// ---------------------------------------------------------------------------

class TransitiveReductionModifier extends GraphModifier {
  new({super.enabled});

  final outputStyle = OutputStyleOptions(
    color: '#ef4444',
    pattern: '6,4',
    hasRemovedMode: true,
  );

  @override
  String get id => 'transitive_reduction';

  @override
  String get name => 'Transitive Reduction';

  @override
  ModifierCategory get category => ModifierCategory.transform;

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

    outputStyle.buildUI(
      container,
      onModified,
      colorLabel: 'Removed Edge Color:',
      patternLabel: 'Removed Line Style:',
      removedLabel: 'Show Removed as:',
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
        statusSummary: 'Requires acyclic graph (DAG)',
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

    final dash = outputStyle.dashPattern;
    final color = outputStyle.highlightColor;
    var removedEdgesCount = 0;
    // Identify removed edges
    for (final edge in graph.edges) {
      if (!reduced.containsEdge(edge.source, edge.target)) {
        removedEdgesCount++;
        if (outputStyle.removedMode == RemovedMode.dim) {
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
// Combine Modifier (Union & Intersection)
// ---------------------------------------------------------------------------

class CombineModifier extends GraphModifier {
  new({
    super.enabled,
    this.operation = CombineOperation.union,
    this.shape = GeneratorShape.cycle,
    this.count = 5,
    this.atlasIndex = 7,
  });

  CombineOperation operation;
  GeneratorShape shape;
  int count;
  int atlasIndex;

  @override
  String get id => 'combine';

  @override
  String get name => 'Combine';

  @override
  ModifierCategory get category => ModifierCategory.transform;

  @override
  Map<String, dynamic> exportConfig() => {
    'operation': operation.id,
    'shape': shape.id,
    'count': count,
    'atlasIndex': atlasIndex,
  };

  @override
  void applyConfig(Map<String, dynamic> config) {
    if (config['operation'] case final String op) {
      operation = CombineOperation.fromId(op);
    }
    if (config['shape'] case final String sh) {
      shape = GeneratorShape.fromId(sh);
    }
    if (config['count'] case final int c) count = c;
    if (config['atlasIndex'] case final int ai) atlasIndex = ai;
  }

  @override
  void resetDefaults() {
    operation = CombineOperation.union;
    shape = GeneratorShape.cycle;
    count = 5;
    atlasIndex = 7;
  }

  @override
  bool get canApply => true;

  @override
  void applyPermanent(AppState state) {
    state.saveSnapshot();
    final out = apply(state.renderGraph, state);
    if (out.transformedGraph != null) {
      state.primaryGraph = out.transformedGraph!;
      state.syncNodes();
    }
  }

  Graph<String, num> _buildSecondGraph(bool isDirected) {
    final factory = GraphFactory<String, num>(
      isDirected: isDirected,
      vertexProvider: (int i) => 'H$i',
      edgeProvider: (source, target) => 1,
    );
    final countClamped = count.clamp(1, 100);
    switch (shape) {
      case GeneratorShape.atlas:
        final atlasIdx = atlasIndex.clamp(0, factory.atlasLength - 1);
        final atlas = factory.atlas(atlasIdx);
        if (isDirected) {
          final bidi = Graph<String, num>(isDirected: true);
          for (final v in atlas.vertices) {
            bidi.addVertex(v);
          }
          for (final e in atlas.edges) {
            bidi.addEdge(e.source, e.target, value: e.value);
            bidi.addEdge(e.target, e.source, value: e.value);
          }
          return bidi;
        }
        return atlas;
      case GeneratorShape.complete:
        return factory.complete(vertexCount: countClamped);
      case GeneratorShape.cycle:
        return factory.ring(vertexCount: countClamped);
      case GeneratorShape.star:
        return factory.star(vertexCount: countClamped);
      case GeneratorShape.path:
        return factory.path(vertexCount: countClamped);
      case GeneratorShape.tree:
        return factory.completeTree(vertexCount: countClamped, arity: 2);
      case GeneratorShape.bipartite:
        return factory.partite(
          vertexCounts: [countClamped ~/ 2 + 1, countClamped ~/ 2 + 1],
        );
      case GeneratorShape.grid:
        final rows = countClamped > 4 ? 3 : 2;
        final cols = countClamped ~/ rows + 1;
        return factory.grid(rows: rows, columns: cols);
      case GeneratorShape.random:
        return factory.randomErdosRenyi(
          vertexCount: countClamped,
          probability: 0.3,
        );
    }
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      dropdownSetting(
        'Operation:',
        operation.id,
        [for (final op in CombineOperation.values) (op.id, op.label)],
        onChanged: (val) {
          operation = CombineOperation.fromId(val);
          onModified();
        },
      ),
    );

    root.appendChild(
      dropdownSetting(
        'Second Graph (H):',
        shape.id,
        [for (final s in GeneratorShape.values) (s.id, s.label)],
        onChanged: (val) {
          shape = GeneratorShape.fromId(val);
          onModified();
        },
      ),
    );

    if (shape == GeneratorShape.atlas) {
      root.appendChild(
        rangeSetting(
          'Atlas Index (0..1252):',
          atlasIndex,
          min: 0,
          max: 1252,
          onChanged: (v) {
            atlasIndex = v.toInt();
            onModified();
          },
        ),
      );
    } else {
      root.appendChild(
        rangeSetting(
          'Vertices in H:',
          count,
          min: 2,
          max: 30,
          onChanged: (v) {
            count = v.toInt();
            onModified();
          },
        ),
      );
    }

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    final second = _buildSecondGraph(graph.isDirected);
    Graph<String, num> result;
    try {
      result = operation == CombineOperation.union
          ? graph.union(second)
          : graph.intersection(second);
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Combine error: $e',
        statusSummary: 'Error combining graphs',
      );
    }

    return ModifierOutput(
      transformedGraph: result,
      statusSummary:
          '${operation.label} (${result.vertices.length} vertices, ${result.edges.length} edges)',
      tableData: ModifierTableData(
        title: 'Combine (${operation.label})',
        headers: ['Metric', 'G', 'H', 'Result'],
        rows: [
          [
            'Vertices',
            '${graph.vertices.length}',
            '${second.vertices.length}',
            '${result.vertices.length}',
          ],
          [
            'Edges',
            '${graph.edges.length}',
            '${second.edges.length}',
            '${result.edges.length}',
          ],
        ],
      ),
    );
  }
}
