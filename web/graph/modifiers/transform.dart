import 'dart:math' as math;

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
    if (validateGraph(
          graph,
          directed: true,
          requirementMessage: 'Transitive closure requires a directed graph.',
        )
        case final err?) {
      return err;
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
    if (validateGraph(
          graph,
          directed: true,
          requirementMessage:
              'Transitive reduction requires a directed acyclic graph (DAG).',
        )
        case final err?) {
      return err;
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
    this.operation = CombineOperation.replace,
    this.shape = GeneratorShape.atlas,
    this.count = 6,
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
    operation = CombineOperation.replace;
    shape = GeneratorShape.atlas;
    count = 6;
    atlasIndex = 7;
  }

  @override
  bool get canApply => true;

  Graph<String, num> _buildSecondGraph(bool isDirected) => buildShapedGraph(
    isDirected: isDirected,
    shape: shape,
    count: count,
    atlasIndex: atlasIndex,
    vertexProvider: (i) => operation == CombineOperation.replace
        ? (i < 26 ? String.fromCharCode(65 + i) : 'V$i')
        : 'H$i',
  );

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

    appendShapeControls(
      root,
      shapeLabel: 'Graph Shape (H):',
      shape: shape,
      count: count,
      atlasIndex: atlasIndex,
      countLabel: 'Vertices in H:',
      maxCount: 30,
      onChanged: (s, c, a) {
        shape = s;
        count = c;
        atlasIndex = a;
        onModified();
      },
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final second = _buildSecondGraph(graph.isDirected);

    // Ensure layout coordinates for vertices in second graph
    const cx = 450.0;
    const cy = 300.0;
    final secondVertices = second.vertices.toList();
    final radius = math.max(120.0, secondVertices.length * 22.0);
    for (var i = 0; i < secondVertices.length; i++) {
      final v = secondVertices[i];
      final node = state.getOrCreateNode(v);
      if (node.x == null ||
          node.y == null ||
          operation == CombineOperation.replace) {
        final angle =
            (2 * math.pi * i / math.max(1, secondVertices.length)) -
            (math.pi / 2);
        node.x = cx + radius * math.cos(angle);
        node.y = cy + radius * math.sin(angle);
      }
    }

    if (graph.vertices.isEmpty) {
      if (operation == CombineOperation.intersection) {
        return const ModifierOutput(statusSummary: 'Graph is empty');
      }
      return ModifierOutput(
        transformedGraph: second,
        statusSummary:
            '${operation.label} (${second.vertices.length} vertices, ${second.edges.length} edges)',
        tableData: ModifierTableData(
          title: 'Combine (${operation.label})',
          headers: ['Metric', 'G', 'H', 'Result'],
          rows: [
            [
              'Vertices',
              '0',
              '${second.vertices.length}',
              '${second.vertices.length}',
            ],
            ['Edges', '0', '${second.edges.length}', '${second.edges.length}'],
          ],
        ),
      );
    }

    Graph<String, num> result;
    try {
      result = switch (operation) {
        CombineOperation.replace => second,
        CombineOperation.union => graph.union(second),
        CombineOperation.intersection => graph.intersection(second),
      };
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
