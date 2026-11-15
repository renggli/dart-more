import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../enums.dart';
import '../state.dart';
import 'base.dart';
import 'ui_helpers.dart';

abstract class _TourModifier extends GraphModifier {
  new({
    super.enabled,
    required String defaultColor,
    required this.pathColorLabel,
    required this.pathLineStyleLabel,
  }) : outputStyle = OutputStyleOptions(
         color: defaultColor,
         pattern: 'none',
         hasRemovedMode: true,
       );

  final OutputStyleOptions outputStyle;
  final String pathColorLabel;
  final String pathLineStyleLabel;
  bool requireCircuit = false;

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
      colorLabel: pathColorLabel,
      patternLabel: pathLineStyleLabel,
    );
    return root;
  }

  ModifierOutput renderTour({
    required Graph<String, num> graph,
    required AppState state,
    required Path<String, num> tour,
    required String overlayTitle,
    required String statusSummary,
    required String tableTitle,
    String stepHeader = 'Step',
    bool showCost = false,
  }) {
    final dash = outputStyle.dashPattern;
    final color = outputStyle.highlightColor;
    final tourVertices = tour.vertices.toList();
    final tourEdges = <(String, String)>[];
    final tourEdgeSet = <(String, String)>{};
    final cumulativeCosts = <num>[0];
    num totalCost = 0;

    for (var i = 0; i < tourVertices.length - 1; i++) {
      final key = (tourVertices[i], tourVertices[i + 1]);
      tourEdges.add(key);
      tourEdgeSet.add(key);
      if (!graph.isDirected) {
        tourEdgeSet.add((key.$2, key.$1));
      }
      if (showCost) {
        final e =
            graph.getEdge(key.$1, key.$2) ??
            (!graph.isDirected ? graph.getEdge(key.$2, key.$1) : null);
        totalCost += state.isWeighted ? (e?.value ?? 1) : 1;
        cumulativeCosts.add(totalCost);
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
        title: overlayTitle,
      ),
      statusSummary: statusSummary,
      tableData: ModifierTableData(
        title: tableTitle,
        headers: [stepHeader, 'Vertex', if (showCost) 'Cumulative Cost'],
        rows: [
          for (var i = 0; i < tourVertices.length; i++)
            [
              '#${i + 1}',
              tourVertices[i],
              if (showCost) '${cumulativeCosts[i]}',
            ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Eulerian Circuit & Trail
// ---------------------------------------------------------------------------

class EulerianModifier extends _TourModifier {
  new({super.enabled})
    : super(
        defaultColor: '#10b981',
        pathColorLabel: 'Trail Color:',
        pathLineStyleLabel: 'Trail Line Style:',
      );

  @override
  String get id => 'eulerian';

  @override
  String get name => 'Eulerian Tour';

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

      void markViolations() {
        for (final v in oddVertices) {
          final node = state.nodes[v];
          if (node != null) {
            node.style.borderColor = '#ef4444';
            node.style.borderWidth = 3.0;
          }
        }
      }

      if (requireCircuit && !hasCircuit) {
        markViolations();
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
        markViolations();
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

      return renderTour(
        graph: graph,
        state: state,
        tour: tour,
        overlayTitle: hasCircuit ? 'Eulerian Circuit' : 'Eulerian Trail',
        statusSummary: hasCircuit
            ? 'Eulerian Circuit found'
            : 'Eulerian Trail found',
        tableTitle: 'Eulerian Steps',
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

class HamiltonianModifier extends _TourModifier {
  new({super.enabled, this.algorithm = TourAlgorithm.auto})
    : super(
        defaultColor: '#a855f7',
        pathColorLabel: 'Path Color:',
        pathLineStyleLabel: 'Path Line Style:',
      );

  TourAlgorithm algorithm;
  String? startVertex;

  @override
  String get id => 'hamiltonian';

  @override
  String get name => 'Hamiltonian & TSP';

  @override
  Map<String, dynamic> exportConfig() => {
    ...super.exportConfig(),
    'algorithm': algorithm.id,
    if (startVertex != null) 'startVertex': startVertex,
  };

  @override
  void applyConfig(Map<String, dynamic> config) {
    super.applyConfig(config);
    if (config['algorithm'] case final String a) {
      algorithm = TourAlgorithm.fromId(a);
    }
    if (config.containsKey('startVertex')) {
      startVertex = config['startVertex']?.toString();
    }
  }

  @override
  void resetDefaults() {
    super.resetDefaults();
    algorithm = TourAlgorithm.auto;
    startVertex = null;
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      enumDropdownSetting(
        label: 'Algorithm:',
        current: algorithm,
        values: TourAlgorithm.values,
        id: (a) => a.id,
        display: (a) => a.label,
        onChanged: (val) {
          algorithm = val;
          onModified();
        },
      ),
    );

    root.appendChild(
      vertexField(
        'Start Vertex (TSP):',
        state,
        startVertex,
        '(Selected / First)',
        (v) {
          startVertex = v;
          onModified();
        },
      ),
    );

    root.appendChild(super.buildConfigUI(state, onModified));
    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    if (graph.vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }
    Path<String, num>? tour;
    var isTsp = false;
    final start =
        startVertex ??
        state.selectedSource ??
        state.selectedVertices.firstOrNull;
    final num Function(String, String)? edgeCost = state.isWeighted
        ? null
        : (_, _) => 1;

    try {
      switch (algorithm) {
        case TourAlgorithm.exact:
          tour = graph.findHamiltonianPath(circuit: requireCircuit);
        case TourAlgorithm.tsp:
          tour = graph.tspHeuristic(edgeCost: edgeCost, startVertex: start);
          isTsp = true;
        case TourAlgorithm.auto:
          if (graph.vertices.length > 32) {
            tour = graph.tspHeuristic(edgeCost: edgeCost, startVertex: start);
            isTsp = true;
          } else {
            tour = graph.findHamiltonianPath(circuit: requireCircuit);
            if (tour == null && !requireCircuit) {
              tour = graph.tspHeuristic(edgeCost: edgeCost, startVertex: start);
              isTsp = true;
            }
          }
      }
      if (tour == null) {
        return ModifierOutput(
          statusSummary: isTsp
              ? 'No TSP tour found'
              : (requireCircuit
                    ? 'No Hamiltonian Cycle exists'
                    : 'No Hamiltonian Path exists'),
          tableData: ModifierTableData(
            title: 'Hamiltonian Properties',
            headers: ['Property', 'Result'],
            rows: [
              [
                if (isTsp)
                  'TSP Tour'
                else
                  'Hamiltonian ${requireCircuit ? "Cycle" : "Path"}',
                'Not Found',
              ],
            ],
          ),
        );
      }

      num totalCost = 0;
      if (isTsp) {
        for (final e in tour.edges) {
          final ge =
              graph.getEdge(e.source, e.target) ??
              (!graph.isDirected ? graph.getEdge(e.target, e.source) : null);
          totalCost += state.isWeighted ? (ge?.value ?? 1) : 1;
        }
      }

      return renderTour(
        graph: graph,
        state: state,
        tour: tour,
        overlayTitle: isTsp
            ? 'TSP Tour (2-Opt Heuristic)'
            : (requireCircuit ? 'Hamiltonian Cycle' : 'Hamiltonian Path'),
        statusSummary: isTsp
            ? 'TSP Tour (cost: $totalCost)'
            : (requireCircuit
                  ? 'Hamiltonian Cycle found'
                  : 'Hamiltonian Path found'),
        tableTitle: isTsp ? 'TSP Tour Sequence' : 'Hamiltonian Sequence',
        stepHeader: 'Index',
        showCost: isTsp,
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
