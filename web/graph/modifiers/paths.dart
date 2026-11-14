import 'dart:math' as math;

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
  new({
    super.enabled,
    this.algorithm = ShortestPathAlgorithm.dijkstra,
    this.findAll = false,
  });

  ShortestPathAlgorithm algorithm;
  String? sourceVertex;
  String? targetVertex;
  bool findAll;
  final outputStyle = OutputStyleOptions(
    color: '#38bdf8',
    pattern: 'none',
    hasRemovedMode: true,
  );

  @override
  String get id => 'shortest_path';

  @override
  String get name => 'Shortest Path';

  @override
  ModifierCategory get category => ModifierCategory.paths;

  @override
  Map<String, dynamic> exportConfig() => {
    'algorithm': algorithm.id,
    if (sourceVertex != null) 'sourceVertex': sourceVertex,
    if (targetVertex != null) 'targetVertex': targetVertex,
    'findAll': findAll,
    'outputStyle': outputStyle.toJson(),
  };

  @override
  void applyConfig(Map<String, dynamic> config) {
    if (config['algorithm'] case final String a) {
      algorithm = ShortestPathAlgorithm.fromId(a);
    }
    if (config.containsKey('sourceVertex')) {
      sourceVertex = config['sourceVertex']?.toString();
    }
    if (config.containsKey('targetVertex')) {
      targetVertex = config['targetVertex']?.toString();
    }
    if (config['findAll'] case final bool f) findAll = f;
    if (config['outputStyle'] case final Map<dynamic, dynamic> os) {
      outputStyle.applyJson(os.cast<String, dynamic>());
    }
  }

  @override
  void resetDefaults() {
    algorithm = ShortestPathAlgorithm.dijkstra;
    sourceVertex = null;
    targetVertex = null;
    findAll = false;
    outputStyle.resetDefaults();
  }

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
      checkboxSetting(
        'Find all equal-cost paths',
        findAll,
        onChanged: (val) {
          findAll = val;
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

    outputStyle.buildUI(
      root,
      onModified,
      colorLabel: 'Path Color:',
      patternLabel: 'Line Style:',
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
            costEstimate: (String v) {
              final vn = state.nodes[v];
              final tn = state.nodes[tgt];
              if (vn?.x != null &&
                  vn?.y != null &&
                  tn?.x != null &&
                  tn?.y != null) {
                final dx = vn!.x! - tn!.x!;
                final dy = vn.y! - tn.y!;
                return math.sqrt(dx * dx + dy * dy) * 0.01;
              }
              return 0;
            },
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
      final msg = e.toString();
      final isNegCycle = msg.toLowerCase().contains('negative');
      return ModifierOutput(
        hasError: true,
        errorMessage: isNegCycle
            ? 'Bellman–Ford detected a negative weight cycle reachable from $src.'
            : msg,
        statusSummary: isNegCycle
            ? 'Negative cycle detected'
            : 'Error computing shortest path',
      );
    }

    if (path == null) {
      return ModifierOutput(statusSummary: 'No path found ($src → $tgt)');
    }

    var allPaths = <Path<String, num>>[];
    if (findAll) {
      try {
        allPaths = graph
            .shortestPathAll(
              src,
              targetPredicate: (v) => v == tgt,
              includeAlternativePaths: true,
              edgeCost: (String u, String v) =>
                  algorithm == ShortestPathAlgorithm.bfs
                  ? 1
                  : (graph.getEdge(u, v)?.value ?? 1),
            )
            .toList();
      } catch (_) {}
    }

    final dash = outputStyle.dashPattern;
    final color = outputStyle.highlightColor;
    final pathVertices = path.vertices.toList();
    final pathEdges = <(String, String)>[];
    final pathEdgeSet = <(String, String)>{};
    for (var i = 0; i < pathVertices.length - 1; i++) {
      final edgeKey = (pathVertices[i], pathVertices[i + 1]);
      pathEdges.add(edgeKey);
      pathEdgeSet.add(edgeKey);
      if (!graph.isDirected) {
        pathEdgeSet.add((edgeKey.$2, edgeKey.$1));
      }
      if (color != null || dash != null) {
        final edgeStyle = state.getEdgeStyle(edgeKey.$1, edgeKey.$2);
        if (color != null) {
          edgeStyle.color = color;
          edgeStyle.strokeWidth = 3.0;
        }
        edgeStyle.dashPattern = dash;
      }
    }

    // Handle removed/non-path elements
    for (final e in graph.edges.toSet()) {
      if (!pathEdgeSet.contains((e.source, e.target))) {
        final edgeStyle = state.getEdgeStyle(e.source, e.target);
        edgeStyle.opacity = outputStyle.removedMode == RemovedMode.hide
            ? 0.0
            : 0.25;
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

    final summary = allPaths.length > 1
        ? 'Found ${allPaths.length} shortest paths (${pathVertices.join(" → ")})'
        : 'Path found: ${pathVertices.join(" → ")}';

    if (allPaths.length > 1) {
      for (var pIdx = 0; pIdx < allPaths.length; pIdx++) {
        rows.add([
          'Path #${pIdx + 1}',
          allPaths[pIdx].vertices.join(' → '),
          '${allPaths[pIdx].edges.length} edges',
        ]);
      }
    }

    return ModifierOutput(
      overlay: overlay,
      statusSummary: summary,
      tableData: ModifierTableData(
        title: 'Shortest Path ($src → $tgt)',
        headers: ['Step', 'Vertex', 'Cumulative Weight / Detail'],
        rows: rows,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Traversal Modifier (Topological, BFS, DFS, Random Walk)
// ---------------------------------------------------------------------------

class TraversalModifier extends GraphModifier {
  new({
    super.enabled,
    this.type = TraversalType.bfs,
    this.startVertex,
    this.randomWalkSteps = 10,
    this.seed = 42,
  });

  TraversalType type;
  String? startVertex;
  int randomWalkSteps;
  int seed;
  final outputStyle = OutputStyleOptions(
    color: '#06b6d4',
    pattern: 'none',
    hasRemovedMode: false,
  );

  @override
  String get id => 'traversal';

  @override
  String get name => 'Traversal';

  @override
  ModifierCategory get category => ModifierCategory.paths;

  @override
  Map<String, dynamic> exportConfig() => {
    'type': type.id,
    if (startVertex != null) 'startVertex': startVertex,
    'randomWalkSteps': randomWalkSteps,
    'seed': seed,
    'outputStyle': outputStyle.toJson(),
  };

  @override
  void applyConfig(Map<String, dynamic> config) {
    if (config['type'] case final String t) {
      type = TraversalType.fromId(t);
    }
    if (config.containsKey('startVertex')) {
      startVertex = config['startVertex']?.toString();
    }
    if (config['randomWalkSteps'] case final int st) randomWalkSteps = st;
    if (config['seed'] case final int s) seed = s;
    if (config['outputStyle'] case final Map<dynamic, dynamic> os) {
      outputStyle.applyJson(os.cast<String, dynamic>());
    }
  }

  @override
  void resetDefaults() {
    type = TraversalType.bfs;
    startVertex = null;
    randomWalkSteps = 10;
    seed = 42;
    outputStyle.resetDefaults();
  }

  @override
  web.HTMLElement buildConfigUI(AppState state, void Function() onModified) {
    final root = div('form-column');

    root.appendChild(
      dropdownSetting(
        'Traversal Type:',
        type.id,
        [for (final t in TraversalType.values) (t.id, t.label)],
        onChanged: (val) {
          type = TraversalType.fromId(val);
          onModified();
        },
      ),
    );

    root.appendChild(
      vertexField('Start Vertex:', state, startVertex, '(Selected / First)', (
        v,
      ) {
        startVertex = v;
        onModified();
      }),
    );

    if (type == TraversalType.randomWalk) {
      root.appendChild(
        rangeSetting(
          'Walk Steps:',
          randomWalkSteps,
          min: 2,
          max: 50,
          onChanged: (val) {
            randomWalkSteps = val.toInt();
            onModified();
          },
        ),
      );
      root.appendChild(
        seedSetting(
          'Random Seed:',
          seed,
          onChanged: (val) {
            seed = val;
            onModified();
          },
        ),
      );
    }

    outputStyle.buildUI(
      root,
      onModified,
      colorLabel: 'Traversal Color:',
      patternLabel: 'Traversal Line Style:',
    );
    return root;
  }

  @override
  ModifierOutput apply(Graph<String, num> graph, AppState state) {
    final vertices = graph.vertices.toList();
    if (vertices.isEmpty) {
      return const ModifierOutput(statusSummary: 'Graph is empty');
    }

    final start =
        startVertex ??
        state.selectedSource ??
        (state.selectedVertices.isNotEmpty
            ? state.selectedVertices.first
            : vertices.first);

    if (type == TraversalType.topological) {
      if (!graph.isDirected) {
        return const ModifierOutput(
          hasError: true,
          errorMessage:
              'Topological sort requires a directed acyclic graph (DAG).',
          statusSummary: 'Requires directed graph',
        );
      }
      if (graph.hasCycle()) {
        return const ModifierOutput(
          hasError: true,
          errorMessage: 'Graph contains a cycle. Topological sort requires an acyclic graph (DAG).',
          statusSummary: 'Requires acyclic graph (DAG)',
        );
      }
    }

    final visitedSequence = <String>[];
    final treeEdges = <(String, String)>[];
    try {
      switch (type) {
        case TraversalType.topological:
          visitedSequence.addAll(graph.topologicalAll(vertices));
        case TraversalType.bfs:
          final visited = <String>{start};
          final queue = <String>[start];
          while (queue.isNotEmpty) {
            final curr = queue.removeAt(0);
            visitedSequence.add(curr);
            for (final next in graph.successorsOf(curr)) {
              if (visited.add(next)) {
                queue.add(next);
                treeEdges.add((curr, next));
              }
            }
          }
        case TraversalType.dfs:
          final visited = <String>{start};
          final stack = <(String, String?)>[(start, null)];
          while (stack.isNotEmpty) {
            final (curr, parent) = stack.removeLast();
            visitedSequence.add(curr);
            if (parent != null) {
              treeEdges.add((parent, curr));
            }
            for (final next in graph.successorsOf(curr)) {
              if (visited.add(next)) {
                stack.add((next, curr));
              }
            }
          }
        case TraversalType.randomWalk:
          final walk = graph
              .randomWalk(start, random: math.Random(seed))
              .take(randomWalkSteps)
              .toList();
          visitedSequence.addAll(walk);
          for (var i = 0; i < walk.length - 1; i++) {
            treeEdges.add((walk[i], walk[i + 1]));
          }
      }
    } catch (e) {
      return ModifierOutput(
        hasError: true,
        errorMessage: 'Traversal error: $e',
        statusSummary: 'Error computing traversal',
      );
    }

    final dash = outputStyle.dashPattern;
    final color = outputStyle.highlightColor;
    final pathEdges = <(String, String)>[];

    for (final (u, v) in treeEdges) {
      if (graph.containsEdge(u, v) ||
          (!graph.isDirected && graph.containsEdge(v, u))) {
        pathEdges.add((u, v));
        if (color != null || dash != null) {
          final es = state.getEdgeStyle(u, v, isDirected: graph.isDirected);
          if (color != null) {
            es.color = color;
            es.strokeWidth = 3.0;
          }
          es.dashPattern = dash;
        }
      }
    }

    for (final v in visitedSequence) {
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
    for (var i = 0; i < visitedSequence.length; i++) {
      rows.add(['#${i + 1}', visitedSequence[i]]);
    }

    final overlay = PathOverlay(
      vertices: visitedSequence,
      edges: pathEdges,
      title: 'Traversal (${type.label})',
      color: color,
    );

    return ModifierOutput(
      overlay: overlay,
      statusSummary:
          'Visited ${visitedSequence.length} vertices (${type.label})',
      tableData: ModifierTableData(
        title: 'Traversal Order (${type.label})',
        headers: ['Step', 'Vertex'],
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
