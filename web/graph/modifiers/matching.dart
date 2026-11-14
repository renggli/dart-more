import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../enums.dart';
import '../state.dart';
import 'base.dart';
import 'ui_helpers.dart';

// ---------------------------------------------------------------------------
// Maximum Matching (Blossom)
// ---------------------------------------------------------------------------

class MatchingModifier extends GraphModifier {
  new({super.enabled});

  final outputStyle = OutputStyleOptions(
    color: '#10b981',
    pattern: 'none',
    hasRemovedMode: true,
  );

  @override
  String get id => 'matching';

  @override
  String get name => 'Maximum Matching';

  @override
  ModifierCategory get category => ModifierCategory.matching;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');
    outputStyle.buildUI(
      root,
      onModified,
      colorLabel: 'Matching Color:',
      patternLabel: 'Matching Line Style:',
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

      final dash = outputStyle.dashPattern;
      final color = outputStyle.highlightColor;
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

      // Handle non-matched edges
      for (final edge in graph.edges.toSet()) {
        final pair = edge.source.compareTo(edge.target) < 0
            ? (edge.source, edge.target)
            : (edge.target, edge.source);
        if (!matchedEdges.contains(pair)) {
          final es = state.getEdgeStyle(edge.source, edge.target);
          es.opacity = outputStyle.removedMode == RemovedMode.hide ? 0.0 : 0.25;
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
// Maximal Cliques & Independent Set
// ---------------------------------------------------------------------------

class CliquesModifier extends GraphModifier {
  new({super.enabled, this.mode = CliquesMode.cliques});

  CliquesMode mode;
  String highlightColor = '#f59e0b';

  @override
  String get id => 'cliques';

  @override
  String get name => 'Cliques & Independent Set';

  @override
  ModifierCategory get category => ModifierCategory.matching;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      dropdownSetting(
        'Mode:',
        mode.id,
        [for (final m in CliquesMode.values) (m.id, m.label)],
        onChanged: (val) {
          mode = CliquesMode.fromId(val);
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
      if (mode == CliquesMode.independentSet) {
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
// Minimum Vertex Cover
// ---------------------------------------------------------------------------

class VertexCoverModifier extends GraphModifier {
  new({super.enabled});

  String coverColor = '#ec4899';
  bool approximate = false;

  @override
  String get id => 'vertex_cover';

  @override
  String get name => 'Vertex Cover';

  @override
  ModifierCategory get category => ModifierCategory.matching;

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
// Vertex Coloring Modifier
// ---------------------------------------------------------------------------

class VertexColoringModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'vertex_coloring';

  @override
  String get name => 'Vertex Coloring';

  @override
  ModifierCategory get category => ModifierCategory.matching;

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
      return ModifierOutput(
        hasError: true,
        errorMessage: e.toString(),
        statusSummary: 'Error computing vertex coloring',
      );
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
