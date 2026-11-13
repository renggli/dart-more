import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../state.dart';
import 'base.dart';

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

  String removedColor = '#ef4444';
  String removedPattern = '6,4';
  bool keepRemovedDashedInView = true;

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
