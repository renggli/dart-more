import 'package:more/graph.dart' hide GraphLayout;
import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../enums.dart';
import '../state.dart';
import 'base.dart';
import 'ui_helpers.dart';

// ---------------------------------------------------------------------------
// Shortest Path Modifier
// ---------------------------------------------------------------------------

class ShortestPathModifier extends GraphModifier {
  new({super.enabled, this.algorithm = ShortestPathAlgorithm.dijkstra});

  ShortestPathAlgorithm algorithm;
  String? sourceVertex;
  String? targetVertex;
  String pathColor = '#38bdf8';
  String pathPattern = 'none';

  @override
  String get id => 'shortest_path';

  @override
  String get name => 'Shortest Path';

  @override
  ModifierCategory get category => ModifierCategory.paths;

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      dropdownSetting(
        'Algorithm:',
        algorithm.id,
        [for (final a in ShortestPathAlgorithm.values) (a.id, a.label)],
        onChanged: (val) {
          algorithm = ShortestPathAlgorithm.fromId(val);
          onModified();
        },
      ),
    );

    root.appendChild(
      vertexField('Source Vertex:', state, sourceVertex, '(Selected / First)', (
        v,
      ) {
        sourceVertex = v;
        onModified();
      }),
    );

    root.appendChild(
      vertexField(
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
        case ShortestPathAlgorithm.bellmanFord:
          path = graph.shortestPath(
            src,
            tgt,
            hasNegativeEdges: true,
            edgeCost: (String u, String v) => graph.getEdge(u, v)?.value ?? 1,
          );
        case ShortestPathAlgorithm.aStar:
          path = graph.shortestPath(
            src,
            tgt,
            costEstimate: (String v) => 0,
            edgeCost: (String u, String v) => graph.getEdge(u, v)?.value ?? 1,
          );
        case ShortestPathAlgorithm.bfs:
          path = graph.shortestPath(
            src,
            tgt,
            edgeCost: (String u, String v) => 1,
          );
        case ShortestPathAlgorithm.dfs:
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
        case ShortestPathAlgorithm.dijkstra:
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
        cumulativeWeight += algorithm == ShortestPathAlgorithm.bfs
            ? 1
            : (e?.value ?? 1);
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
// All-Pairs Shortest Paths Modifier
// ---------------------------------------------------------------------------

class AllPairsShortestPathModifier extends GraphModifier {
  new({super.enabled});

  @override
  String get id => 'all_pairs_path';

  @override
  String get name => 'All-Pairs Paths';

  @override
  ModifierCategory get category => ModifierCategory.paths;

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
