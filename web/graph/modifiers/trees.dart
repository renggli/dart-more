import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../state.dart';
import 'base.dart';
import 'ui_helpers.dart';

// ---------------------------------------------------------------------------
// Spanning Tree Modifier
// ---------------------------------------------------------------------------

class SpanningTreeModifier extends GraphModifier {
  new({super.enabled});

  String algorithm = 'kruskal';
  final outputStyle = OutputStyleOptions(
    color: '#10b981',
    pattern: 'none',
    hasRemovedMode: true,
  );

  @override
  String get id => 'spanning_tree';

  @override
  String get name => 'Spanning Tree';

  @override
  ModifierCategory get category => ModifierCategory.trees;

  @override
  Map<String, dynamic> exportConfig() => {
    'algorithm': algorithm,
    'outputStyle': outputStyle.toJson(),
  };

  @override
  void applyConfig(Map<String, dynamic> config) {
    if (config['algorithm'] case final String a) algorithm = a;
    if (config['outputStyle'] case final Map<dynamic, dynamic> os) {
      outputStyle.applyJson(os.cast<String, dynamic>());
    }
  }

  @override
  void resetDefaults() {
    algorithm = 'kruskal';
    outputStyle.resetDefaults();
  }

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

    outputStyle.buildUI(
      root,
      onModified,
      colorLabel: 'Tree Color:',
      patternLabel: 'Tree Line Style:',
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
      return ModifierOutput(
        hasError: true,
        errorMessage: e.toString(),
        statusSummary: 'Error computing spanning tree',
      );
    }

    final dash = outputStyle.dashPattern;
    final color = outputStyle.highlightColor;
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

    if (outputStyle.removedMode == RemovedMode.hide) {
      return ModifierOutput(
        transformedGraph: tree,
        statusSummary: 'MST Weight: $totalWeight (${treeEdges.length} edges)',
        tableData: ModifierTableData(
          title: 'Spanning Tree Edges ($algorithm)',
          headers: ['Edge', 'Weight', 'Cumulative Weight'],
          rows: rows,
        ),
      );
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
