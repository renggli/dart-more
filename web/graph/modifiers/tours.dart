import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../state.dart';
import 'base.dart';
import 'ui_helpers.dart';

// ---------------------------------------------------------------------------
// Eulerian Circuit & Trail
// ---------------------------------------------------------------------------

class EulerianModifier extends GraphModifier {
  new({super.enabled});

  final outputStyle = OutputStyleOptions(
    color: '#10b981',
    pattern: 'none',
    hasRemovedMode: true,
  );
  bool requireCircuit = false;

  @override
  String get id => 'eulerian';

  @override
  String get name => 'Eulerian Trail & Circuit';

  @override
  ModifierCategory get category => ModifierCategory.tours;

  @override
  Map<String, dynamic> exportConfig() => {
    'requireCircuit': requireCircuit,
    'outputStyle': outputStyle.toJson(),
  };

  @override
  void applyConfig(Map<String, dynamic> config) {
    if (config['requireCircuit'] case final bool rc) requireCircuit = rc;
    if (config['outputStyle'] case final Map<dynamic, dynamic> os) {
      outputStyle.applyJson(os.cast<String, dynamic>());
    }
  }

  @override
  void resetDefaults() {
    requireCircuit = false;
    outputStyle.resetDefaults();
  }

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

    outputStyle.buildUI(
      root,
      onModified,
      colorLabel: 'Trail Color:',
      patternLabel: 'Trail Line Style:',
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

      final oddVertices = graph.isDirected
          ? [
              for (final v in graph.vertices)
                if (graph.inDegreeOf(v) != graph.outDegreeOf(v)) v,
            ]
          : [
              for (final v in graph.vertices)
                if (graph.degreeOf(v).isOdd) v,
            ];

      if (requireCircuit && !hasCircuit) {
        for (final v in oddVertices) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = '#ef4444';
            node.style.borderWidth = 3.0;
          }
        }
        return ModifierOutput(
          statusSummary:
              'No Eulerian Circuit (${oddVertices.length} odd-degree vertices)',
          tableData: ModifierTableData(
            title: 'Eulerian Analysis',
            headers: ['Property', 'Value'],
            rows: [
              ['Eulerian Circuit', 'No (all vertices must have even degree)'],
              [
                'Violating Vertices (${oddVertices.length})',
                oddVertices.join(', '),
              ],
            ],
          ),
        );
      }

      if (!hasPath) {
        for (final v in oddVertices) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = '#ef4444';
            node.style.borderWidth = 3.0;
          }
        }
        return ModifierOutput(
          statusSummary:
              'Graph is not Eulerian (${oddVertices.length} odd-degree vertices)',
          tableData: ModifierTableData(
            title: 'Eulerian Analysis',
            headers: ['Property', 'Value'],
            rows: [
              ['Eulerian Circuit', 'No'],
              ['Eulerian Trail', 'No (requires ≤ 2 odd-degree vertices)'],
              [
                'Violating Vertices (${oddVertices.length})',
                oddVertices.join(', '),
              ],
            ],
          ),
        );
      }

      final tour = graph.findEulerianPath(circuit: requireCircuit);
      if (tour == null) {
        return const ModifierOutput(statusSummary: 'No Eulerian tour found');
      }

      final dash = outputStyle.dashPattern;
      final color = outputStyle.highlightColor;
      final tourVertices = tour.vertices.toList();
      final tourEdges = <(String, String)>[];
      final tourEdgeSet = <(String, String)>{};
      for (var i = 0; i < tourVertices.length - 1; i++) {
        final key = (tourVertices[i], tourVertices[i + 1]);
        tourEdges.add(key);
        tourEdgeSet.add(key);
        if (!graph.isDirected) {
          tourEdgeSet.add((key.$2, key.$1));
        }
        if (color != null || dash != null) {
          final es = state.getEdgeStyle(key.$1, key.$2);
          if (color != null) {
            es.color = color;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        }
      }

      // Handle non-tour edges
      for (final e in graph.edges.toSet()) {
        if (!tourEdgeSet.contains((e.source, e.target))) {
          final es = state.getEdgeStyle(e.source, e.target);
          es.opacity = outputStyle.removedMode == RemovedMode.hide ? 0.0 : 0.25;
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
// Hamiltonian Cycle & Path
// ---------------------------------------------------------------------------

class HamiltonianModifier extends GraphModifier {
  new({super.enabled});

  final outputStyle = OutputStyleOptions(
    color: '#a855f7',
    pattern: 'none',
    hasRemovedMode: true,
  );
  bool requireCircuit = false;

  @override
  String get id => 'hamiltonian';

  @override
  String get name => 'Hamiltonian Path & Cycle';

  @override
  ModifierCategory get category => ModifierCategory.tours;

  @override
  Map<String, dynamic> exportConfig() => {
    'requireCircuit': requireCircuit,
    'outputStyle': outputStyle.toJson(),
  };

  @override
  void applyConfig(Map<String, dynamic> config) {
    if (config['requireCircuit'] case final bool rc) requireCircuit = rc;
    if (config['outputStyle'] case final Map<dynamic, dynamic> os) {
      outputStyle.applyJson(os.cast<String, dynamic>());
    }
  }

  @override
  void resetDefaults() {
    requireCircuit = false;
    outputStyle.resetDefaults();
  }

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

    outputStyle.buildUI(
      root,
      onModified,
      colorLabel: 'Path Color:',
      patternLabel: 'Path Line Style:',
    );

    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }
    Path<String, num>? tour;
    var isTsp = false;
    try {
      if (graph.vertices.length > 32) {
        tour = graph.tspHeuristic();
        isTsp = true;
      } else {
        tour = graph.findHamiltonianPath(circuit: requireCircuit);
        if (tour == null && !requireCircuit) {
          tour = graph.tspHeuristic();
          isTsp = true;
        }
      }
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

      final dash = outputStyle.dashPattern;
      final color = outputStyle.highlightColor;
      final tourVertices = tour.vertices.toList();
      final tourEdges = <(String, String)>[];
      final tourEdgeSet = <(String, String)>{};
      for (var i = 0; i < tourVertices.length - 1; i++) {
        final key = (tourVertices[i], tourVertices[i + 1]);
        tourEdges.add(key);
        tourEdgeSet.add(key);
        if (!graph.isDirected) {
          tourEdgeSet.add((key.$2, key.$1));
        }
        if (color != null || dash != null) {
          final es = state.getEdgeStyle(key.$1, key.$2);
          if (color != null) {
            es.color = color;
            es.strokeWidth = 3.5;
          }
          es.dashPattern = dash;
        }
      }

      // Handle non-tour edges
      for (final e in graph.edges.toSet()) {
        if (!tourEdgeSet.contains((e.source, e.target))) {
          final es = state.getEdgeStyle(e.source, e.target);
          es.opacity = outputStyle.removedMode == RemovedMode.hide ? 0.0 : 0.25;
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
          title: isTsp
              ? 'TSP Tour (2-Opt Heuristic)'
              : (requireCircuit ? 'Hamiltonian Cycle' : 'Hamiltonian Path'),
        ),
        statusSummary: isTsp
            ? 'TSP Tour (2-opt heuristic)'
            : (requireCircuit
                  ? 'Hamiltonian Cycle found'
                  : 'Hamiltonian Path found'),
        tableData: ModifierTableData(
          title: isTsp ? 'TSP Tour Sequence' : 'Hamiltonian Sequence',
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
