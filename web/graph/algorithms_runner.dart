import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:web/web.dart' as web;

import 'dom_utils.dart';
import 'presets.dart';
import 'state.dart';

/// The result returned by running a graph algorithm.
final class AlgorithmResult {
  new({
    required this.title,
    required this.summaryHtml,
    this.overlay,
    this.distanceMatrix,
    this.metricsTable,
    this.pathVertices = const [],
    this.pathEdges = const [],
    this.isPathSequence = false,
  });

  final String title;
  final String summaryHtml;
  final VisualOverlay? overlay;
  final FloydWarshall<String>? distanceMatrix;
  final Map<String, Map<String, num>>? metricsTable;
  final List<String> pathVertices;
  final List<(String, String)> pathEdges;
  final bool isPathSequence;
}

/// Metadata and runner for all graph algorithms in package:more/graph.dart.
final class AlgorithmsRunner {
  /// Category options for the UI select dropdown.
  static const List<(String, String)> categories = [
    ('shortest_path', '1. Shortest Paths & Search'),
    ('flow_cuts', '2. Flow, Cuts & Connectivity'),
    ('spanning_tree', '3. Spanning Trees'),
    ('centrality', '4. Centrality & Scoring'),
    ('coloring_cliques', '5. Coloring & Cliques'),
    ('matching', '6. Matching'),
    ('community', '7. Community Detection'),
    ('tours', '8. Eulerian & Hamiltonian Tours'),
    ('planarity_iso', '9. Planarity & Isomorphism'),
    ('traversal', '10. Traversals & Random Walk'),
  ];

  /// Returns algorithm options for a given category.
  static List<(String, String)> getAlgorithmsForCategory(
    String category,
  ) => switch (category) {
    'shortest_path' => const [
      ('dijkstra', 'Shortest Path (Dijkstra / A*)'),
      ('bellman_ford', 'Shortest Path (Bellman–Ford)'),
      ('shortest_all', 'Shortest Paths to All Reachable'),
      ('floyd_warshall', 'All-Pairs Shortest Paths (Floyd–Warshall)'),
    ],
    'flow_cuts' => const [
      ('max_flow', 'Maximum Flow (Dinic)'),
      ('min_cut', 'Minimum Cut (Stoer–Wagner)'),
      ('articulation_bridges', 'Articulation Points & Bridges'),
      ('biconnected', 'Biconnected Components'),
      ('strongly_connected', 'Strongly Connected Components (Tarjan)'),
      ('connected_components', 'Connected Components'),
      ('connectivity_values', 'Vertex & Edge Connectivity'),
    ],
    'spanning_tree' => const [
      ('kruskal_min', 'Minimum Spanning Tree (Kruskal)'),
      ('kruskal_max', 'Maximum Spanning Tree (Kruskal)'),
      ('prim_min', 'Prim Spanning Tree (from Source)'),
    ],
    'centrality' => const [
      ('all_centralities', 'Compute All Centrality Metrics Table'),
      ('page_rank', 'PageRank'),
      ('betweenness', 'Betweenness Centrality'),
      ('closeness', 'Closeness Centrality'),
      ('eigenvector', 'Eigenvector Centrality'),
      ('degree_centrality', 'Degree Centrality'),
      ('core_numbers', 'k-Core Numbers'),
      ('local_clustering', 'Local Clustering Coefficient'),
    ],
    'coloring_cliques' => const [
      ('vertex_coloring', 'Greedy Vertex Coloring'),
      ('cliques', 'Maximal Cliques (Bron–Kerbosch)'),
      ('vertex_cover_min', 'Minimum Vertex Cover (Exact)'),
      ('vertex_cover_approx', 'Minimum Vertex Cover (2-Approx)'),
      ('indep_set_max', 'Maximum Independent Set (Exact)'),
      ('indep_set_approx', 'Maximum Independent Set (Approx)'),
    ],
    'matching' => const [
      ('blossom_matching', 'Maximum Matching (Edmonds Blossom)'),
      ('bipartite_matching', 'Bipartite Matching'),
      ('weighted_bipartite_max', 'Weighted Bipartite Matching (Max Weight)'),
      ('weighted_bipartite_min', 'Weighted Bipartite Matching (Min Weight)'),
    ],
    'community' => const [
      ('louvain', 'Louvain Community Detection (Modularity)'),
      ('label_propagation', 'Label Propagation Communities (LPA)'),
    ],
    'tours' => const [
      ('eulerian_path', 'Eulerian Path (Hierholzer)'),
      ('eulerian_circuit', 'Eulerian Circuit (Hierholzer)'),
      ('hamiltonian_path', 'Hamiltonian Path'),
      ('hamiltonian_circuit', 'Hamiltonian Circuit'),
    ],
    'planarity_iso' => const [
      ('planarity_check', 'Left–Right Planarity Test'),
      ('subgraph_isomorphism', 'Find Subgraph Isomorphisms (VF2)'),
    ],
    'traversal' => const [
      ('bfs', 'Breadth-First Search (BFS)'),
      ('dfs_pre', 'Depth-First Search (Pre-Order)'),
      ('dfs_post', 'Depth-First Search (Post-Order)'),
      ('topological', 'Topological Sort'),
      ('random_walk', 'Random Walk (Self-Avoiding)'),
    ],
    _ => const [],
  };

  /// Builds UI controls for algorithm parameters.
  static void renderParams(
    String algo,
    AppState state,
    web.HTMLElement container,
  ) {
    container.textContent = '';
    final graph = state.primaryGraph;
    final vertices = graph.vertices.toList();

    web.HTMLSelectElement createVertexSelect(
      String id,
      String? defaultVal, [
      String placeholder = 'Select node',
    ]) {
      final select = selectElement(id);
      select.appendChild(optionElement('', placeholder));
      for (final v in vertices) {
        final opt = optionElement(v, v);
        if (v == defaultVal) opt.selected = true;
        select.appendChild(opt);
      }
      return select;
    }

    switch (algo) {
      case 'dijkstra':
      case 'bellman_ford':
      case 'max_flow':
        final row = div('form-row');
        row.appendChild(label('From:'));
        row.appendChild(
          createVertexSelect(
            'algo-param-source',
            state.selectedSource ??
                (vertices.isNotEmpty ? vertices.first : null),
          ),
        );
        row.appendChild(label('To:'));
        row.appendChild(
          createVertexSelect(
            'algo-param-target',
            state.selectedTarget ??
                (vertices.length > 1 ? vertices.last : null),
          ),
        );
        container.appendChild(row);

      case 'shortest_all':
      case 'prim_min':
      case 'bfs':
      case 'dfs_pre':
      case 'dfs_post':
      case 'topological':
      case 'random_walk':
        final row = div('form-row');
        row.appendChild(label('Start Node:'));
        row.appendChild(
          createVertexSelect(
            'algo-param-source',
            state.selectedSource ??
                (vertices.isNotEmpty ? vertices.first : null),
          ),
        );
        container.appendChild(row);

      case 'louvain':
        final row = div('form-row');
        row.appendChild(label('Resolution:'));
        final resInput = numberInput(1.0)
          ..id = 'algo-param-resolution'
          ..step = '0.1'
          ..style.maxWidth = '70px';
        row.appendChild(resInput);
        container.appendChild(row);

      case 'subgraph_isomorphism':
        final row = div('form-row');
        row.appendChild(label('Pattern:'));
        final select = selectElement('algo-param-pattern');
        select.appendChild(optionElement('triangle', 'Triangle (K3)'));
        select.appendChild(optionElement('square', '4-Cycle (C4)'));
        select.appendChild(optionElement('k4', 'Complete K4'));
        select.appendChild(optionElement('star3', 'Star (1 center, 3 leaves)'));
        row.appendChild(select);
        container.appendChild(row);
    }
  }

  /// Executes the selected algorithm and generates overlay and results.
  static AlgorithmResult run(String algo, AppState state) {
    final graph = state.primaryGraph;
    final vertices = graph.vertices.toList();

    String getParam(String id) {
      final el = web.document.querySelector('#$id') as web.HTMLInputElement?;
      if (el != null) return el.value.trim();
      final sel = web.document.querySelector('#$id') as web.HTMLSelectElement?;
      return sel?.value.trim() ?? '';
    }

    final sourceParam = getParam('algo-param-source');
    final targetParam = getParam('algo-param-target');

    final source = sourceParam.isNotEmpty
        ? sourceParam
        : (state.selectedSource ??
              (vertices.isNotEmpty ? vertices.first : 'A'));
    final target = targetParam.isNotEmpty
        ? targetParam
        : (state.selectedTarget ?? (vertices.isNotEmpty ? vertices.last : 'Z'));

    // Check preconditions
    if (algo == 'min_cut' && graph.isDirected) {
      return AlgorithmResult(
        title: 'Error',
        summaryHtml:
            'Stoer–Wagner min-cut requires an <b>undirected</b> graph.',
      );
    }
    if ((algo == 'articulation_bridges' ||
            algo == 'biconnected' ||
            algo == 'cliques' ||
            algo == 'vertex_cover_min' ||
            algo == 'vertex_cover_approx' ||
            algo == 'indep_set_max' ||
            algo == 'indep_set_approx' ||
            algo == 'blossom_matching' ||
            algo == 'bipartite_matching' ||
            algo == 'weighted_bipartite_max' ||
            algo == 'weighted_bipartite_min' ||
            algo == 'louvain' ||
            algo == 'label_propagation' ||
            algo == 'core_numbers') &&
        graph.isDirected) {
      return AlgorithmResult(
        title: 'Error',
        summaryHtml: 'This algorithm requires an <b>undirected</b> graph. Toggle "Directed" to Undirected in the header.',
      );
    }

    switch (algo) {
      // 1. Shortest Paths
      case 'dijkstra':
        final path = graph.shortestPath(source, target);
        if (path == null) {
          return AlgorithmResult(
            title: 'Shortest Path (Dijkstra)',
            summaryHtml:
                'No path found between <b>$source</b> and <b>$target</b>.',
          );
        }
        final pathEdges = <(String, String)>[];
        for (var i = 0; i < path.vertices.length - 1; i++) {
          pathEdges.add((path.vertices[i], path.vertices[i + 1]));
        }
        return AlgorithmResult(
          title: 'Shortest Path (Dijkstra)',
          summaryHtml:
              'Cost: <b>${path.cost}</b><br>Path: ${path.vertices.join(" &rarr; ")}',
          overlay: PathOverlay(
            title: 'Shortest Path: $source to $target',
            vertices: path.vertices,
            edges: pathEdges,
            summary: {'Cost': path.cost.toString()},
          ),
          pathVertices: path.vertices,
          pathEdges: pathEdges,
          isPathSequence: true,
        );

      case 'bellman_ford':
        final path = graph.shortestPath(source, target, hasNegativeEdges: true);
        if (path == null) {
          return AlgorithmResult(
            title: 'Shortest Path (Bellman–Ford)',
            summaryHtml:
                'No path found between <b>$source</b> and <b>$target</b>.',
          );
        }
        final pathEdges = <(String, String)>[];
        for (var i = 0; i < path.vertices.length - 1; i++) {
          pathEdges.add((path.vertices[i], path.vertices[i + 1]));
        }
        return AlgorithmResult(
          title: 'Shortest Path (Bellman–Ford)',
          summaryHtml:
              'Cost: <b>${path.cost}</b><br>Path: ${path.vertices.join(" &rarr; ")}',
          overlay: PathOverlay(
            title: 'Shortest Path: $source to $target',
            vertices: path.vertices,
            edges: pathEdges,
            summary: {'Cost': path.cost.toString()},
          ),
          pathVertices: path.vertices,
          pathEdges: pathEdges,
          isPathSequence: true,
        );

      case 'shortest_all':
        final paths = graph.shortestPathAll(source).toList();
        final visited = paths.map((p) => p.target).toList();
        final edges = <(String, String)>[];
        for (final p in paths) {
          for (var i = 0; i < p.vertices.length - 1; i++) {
            edges.add((p.vertices[i], p.vertices[i + 1]));
          }
        }
        return AlgorithmResult(
          title: 'All Reachable Shortest Paths',
          summaryHtml:
              'From <b>$source</b> reached <b>${paths.length}</b> nodes.<br>'
              'Max cost: <b>${paths.isEmpty ? 0 : paths.map((p) => p.cost).reduce(max)}</b>',
          overlay: HighlightOverlay(
            title: 'Shortest Paths from $source',
            highlightedVertices: visited.toSet(),
            highlightedEdges: edges.toSet(),
          ),
        );

      case 'floyd_warshall':
        final fw = graph.allShortestPaths();
        final diam = fw.diameter;
        final rad = fw.radius;
        final avgPath = fw.averagePathLength;
        final center = fw.center;
        final periphery = fw.periphery;
        return AlgorithmResult(
          title: 'All-Pairs Shortest Paths (Floyd–Warshall)',
          summaryHtml:
              'Diameter: <b>${diam.isInfinite ? "∞" : diam}</b> | Radius: <b>${rad.isInfinite ? "∞" : rad}</b><br>'
              'Average Path Length: <b>${avgPath.toStringAsFixed(3)}</b><br>'
              'Center: [${center.join(", ")}]<br>'
              'Periphery: [${periphery.join(", ")}]',
          distanceMatrix: fw,
          overlay: HighlightOverlay(
            title: 'Center & Periphery',
            highlightedVertices: center,
            secondaryVertices: periphery,
          ),
        );

      // 2. Flow, Cuts & Connectivity
      case 'max_flow':
        final dinic = graph.maxFlow();
        final flow = dinic(source, target);
        return AlgorithmResult(
          title: 'Maximum Flow (Dinic)',
          summaryHtml:
              'Max flow from <b>$source</b> &rarr; <b>$target</b>: <b>$flow</b>',
          overlay: HighlightOverlay(
            title: 'Max Flow ($flow)',
            highlightedVertices: {source, target},
          ),
        );

      case 'min_cut':
        final cut = graph.minCut();
        final cutEdges = cut.edges.map((e) => (e.source, e.target)).toSet();
        final g0 = cut.graphs[0].vertices.toSet();
        final g1 = cut.graphs[1].vertices.toSet();
        final partitionMap = <String, int>{};
        for (final v in g0) {
          partitionMap[v] = 0;
        }
        for (final v in g1) {
          partitionMap[v] = 1;
        }
        return AlgorithmResult(
          title: 'Minimum Cut (Stoer–Wagner)',
          summaryHtml:
              'Cut weight: <b>${cut.weight}</b><br>'
              'Partitions: [${g0.length} nodes] vs [${g1.length} nodes]<br>'
              'Cut edges: <b>${cutEdges.length}</b>',
          overlay: PartitionOverlay(
            title: 'Min Cut (Weight ${cut.weight})',
            vertexGroup: partitionMap,
            highlightedEdges: cutEdges,
          ),
        );

      case 'articulation_bridges':
        final points = graph.articulationPoints();
        final bridges = graph.bridges();
        final bridgePairs = bridges.map((e) => (e.source, e.target)).toSet();
        return AlgorithmResult(
          title: 'Articulation Points & Bridges',
          summaryHtml:
              'Articulation Points: <b>${points.length}</b> [${points.join(", ")}]<br>'
              'Bridges: <b>${bridges.length}</b>',
          overlay: HighlightOverlay(
            title: 'Cut Vertices & Bridges',
            highlightedVertices: points,
            highlightedEdges: bridgePairs,
          ),
        );

      case 'biconnected':
        final components = graph.biconnectedComponents().toList();
        final partitionMap = <String, int>{};
        for (var i = 0; i < components.length; i++) {
          for (final v in components[i].vertices) {
            partitionMap[v] = i;
          }
        }
        return AlgorithmResult(
          title: 'Biconnected Components',
          summaryHtml: 'Found <b>${components.length}</b> biconnected blocks.',
          overlay: PartitionOverlay(
            title: 'Biconnected Components',
            vertexGroup: partitionMap,
          ),
        );

      case 'strongly_connected':
        final sccs = graph.stronglyConnected().toList();
        final partitionMap = <String, int>{};
        for (var i = 0; i < sccs.length; i++) {
          for (final v in sccs[i]) {
            partitionMap[v] = i;
          }
        }
        return AlgorithmResult(
          title: 'Strongly Connected Components (Tarjan)',
          summaryHtml: 'Found <b>${sccs.length}</b> SCCs.',
          overlay: PartitionOverlay(
            title: 'Strongly Connected Components',
            vertexGroup: partitionMap,
            renderClusters: true,
          ),
        );

      case 'connected_components':
        final comps = graph.connected().toList();
        final partitionMap = <String, int>{};
        for (var i = 0; i < comps.length; i++) {
          for (final v in comps[i].vertices) {
            partitionMap[v] = i;
          }
        }
        return AlgorithmResult(
          title: 'Connected Components',
          summaryHtml: 'Found <b>${comps.length}</b> connected components.',
          overlay: PartitionOverlay(
            title: 'Connected Components',
            vertexGroup: partitionMap,
            renderClusters: true,
          ),
        );

      case 'connectivity_values':
        final vConn = graph.vertexConnectivity();
        final eConn = graph.edgeConnectivity();
        return AlgorithmResult(
          title: 'Graph Connectivity',
          summaryHtml:
              'Vertex Connectivity &kappa;(G): <b>$vConn</b><br>'
              'Edge Connectivity &lambda;(G): <b>$eConn</b>',
        );

      // 3. Spanning Trees
      case 'kruskal_min':
        final mst = graph.spanningTree();
        num totalWeight = 0;
        final treeEdges = <(String, String)>{};
        for (final edge in mst.edges.unique()) {
          totalWeight += edge.value;
          treeEdges.add((edge.source, edge.target));
        }
        return AlgorithmResult(
          title: 'Minimum Spanning Tree (Kruskal)',
          summaryHtml:
              'Edges: <b>${treeEdges.length}</b> | Total Weight: <b>$totalWeight</b>',
          overlay: HighlightOverlay(
            title: 'Minimum Spanning Tree ($totalWeight)',
            highlightedVertices: mst.vertices.toSet(),
            highlightedEdges: treeEdges,
          ),
        );

      case 'kruskal_max':
        final maxSt = graph.spanningTree(
          weightComparator: (a, b) => b.compareTo(a),
        );
        num totalWeight = 0;
        final treeEdges = <(String, String)>{};
        for (final edge in maxSt.edges.unique()) {
          totalWeight += edge.value;
          treeEdges.add((edge.source, edge.target));
        }
        return AlgorithmResult(
          title: 'Maximum Spanning Tree (Kruskal)',
          summaryHtml:
              'Edges: <b>${treeEdges.length}</b> | Total Weight: <b>$totalWeight</b>',
          overlay: HighlightOverlay(
            title: 'Maximum Spanning Tree ($totalWeight)',
            highlightedVertices: maxSt.vertices.toSet(),
            highlightedEdges: treeEdges,
          ),
        );

      case 'prim_min':
        final prim = graph.spanningTree(startVertex: source);
        num totalWeight = 0;
        final treeEdges = <(String, String)>{};
        for (final edge in prim.edges.unique()) {
          totalWeight += edge.value;
          treeEdges.add((edge.source, edge.target));
        }
        return AlgorithmResult(
          title: 'Prim Spanning Tree',
          summaryHtml:
              'Start: <b>$source</b> | Edges: <b>${treeEdges.length}</b> | Weight: <b>$totalWeight</b>',
          overlay: HighlightOverlay(
            title: 'Prim Spanning Tree (Root: $source)',
            highlightedVertices: prim.vertices.toSet(),
            highlightedEdges: treeEdges,
          ),
        );

      // 4. Centrality & Scoring
      case 'all_centralities':
      case 'page_rank':
      case 'betweenness':
      case 'closeness':
      case 'eigenvector':
      case 'degree_centrality':
      case 'core_numbers':
      case 'local_clustering':
        var pr = <String, double>{};
        try {
          pr = graph.pageRank();
        } catch (_) {}

        var bet = <String, double>{};
        try {
          bet = graph.betweennessCentrality();
        } catch (_) {}

        var degCent = <String, double>{};
        try {
          degCent = graph.degreeCentrality();
        } catch (_) {}

        var closeCent = <String, double>{};
        try {
          closeCent = graph.closenessCentrality();
        } catch (_) {}

        Map<String, double>? eigen;
        try {
          eigen = graph.eigenvectorCentrality();
        } catch (_) {}

        Map<String, int>? cores;
        if (!graph.isDirected) {
          try {
            cores = graph.coreNumbers();
          } catch (_) {}
        }

        final clusterings = <String, double>{};
        for (final v in vertices) {
          try {
            clusterings[v] = graph.localClusteringCoefficient(v);
          } catch (_) {
            clusterings[v] = 0.0;
          }
        }

        final metricsTable = <String, Map<String, num>>{};
        for (final v in vertices) {
          metricsTable[v] = {
            'Degree': graph.degreeOf(v),
            'PageRank': pr[v] ?? 0.0,
            'Betweenness': bet[v] ?? 0.0,
            'Closeness': closeCent[v] ?? 0.0,
            'Eigenvector': eigen?[v] ?? 0.0,
            'Clustering': clusterings[v] ?? 0.0,
            if (cores != null) 'Core': cores[v] ?? 0,
          };
        }

        Map<String, num> activeScores = pr;
        var activeTitle = 'PageRank';
        if (algo == 'betweenness') {
          activeScores = bet;
          activeTitle = 'Betweenness Centrality';
        } else if (algo == 'closeness') {
          activeScores = closeCent;
          activeTitle = 'Closeness Centrality';
        } else if (algo == 'eigenvector' && eigen != null) {
          activeScores = eigen;
          activeTitle = 'Eigenvector Centrality';
        } else if (algo == 'degree_centrality') {
          activeScores = degCent;
          activeTitle = 'Degree Centrality';
        } else if (algo == 'core_numbers' && cores != null) {
          activeScores = cores;
          activeTitle = 'k-Core Numbers';
        } else if (algo == 'local_clustering') {
          activeScores = clusterings;
          activeTitle = 'Local Clustering Coefficient';
        }

        final topEntry = activeScores.entries.isNotEmpty
            ? activeScores.entries.reduce((a, b) => a.value > b.value ? a : b)
            : null;
        final topSummary = topEntry != null
            ? '<br>Top node: <b>${topEntry.key}</b> (${topEntry.value is double ? (topEntry.value as double).toStringAsFixed(3) : topEntry.value})'
            : '';

        return AlgorithmResult(
          title: activeTitle,
          summaryHtml:
              'Computed full centrality matrix for <b>${vertices.length}</b> nodes.$topSummary',
          metricsTable: metricsTable,
          overlay: HeatmapOverlay(title: activeTitle, scores: activeScores),
        );

      // 5. Coloring & Cliques
      case 'vertex_coloring':
        final coloring = graph.vertexColoring();
        final colorsUsed = coloring.values.toSet().length;
        return AlgorithmResult(
          title: 'Greedy Vertex Coloring',
          summaryHtml:
              'Used <b>$colorsUsed</b> colors for ${vertices.length} vertices.',
          overlay: PartitionOverlay(
            title: 'Vertex Coloring ($colorsUsed Colors)',
            vertexGroup: coloring,
          ),
        );

      case 'cliques':
        final cliques = graph.findCliques().toList();
        cliques.sort((a, b) => b.length.compareTo(a.length));
        final maxClique = cliques.isNotEmpty ? cliques.first : <String>{};
        final cliqueEdges = <(String, String)>{};
        for (final u in maxClique) {
          for (final v in maxClique) {
            if (u != v && graph.containsEdge(u, v)) {
              cliqueEdges.add((u, v));
            }
          }
        }
        return AlgorithmResult(
          title: 'Maximal Cliques (Bron–Kerbosch)',
          summaryHtml:
              'Found <b>${cliques.length}</b> maximal cliques.<br>'
              'Clique number &omega;(G): <b>${maxClique.length}</b> [${maxClique.join(", ")}]',
          overlay: HighlightOverlay(
            title: 'Max Clique (Size ${maxClique.length})',
            highlightedVertices: maxClique,
            highlightedEdges: cliqueEdges,
          ),
        );

      case 'vertex_cover_min':
      case 'vertex_cover_approx':
        final approx = algo == 'vertex_cover_approx';
        final cover = graph.minimumVertexCover(approximate: approx);
        return AlgorithmResult(
          title: approx
              ? 'Minimum Vertex Cover (2-Approx)'
              : 'Minimum Vertex Cover (Exact)',
          summaryHtml:
              'Cover size: <b>${cover.length}</b> [${cover.join(", ")}]',
          overlay: HighlightOverlay(
            title: 'Vertex Cover (${cover.length})',
            highlightedVertices: cover,
          ),
        );

      case 'indep_set_max':
      case 'indep_set_approx':
        final approx = algo == 'indep_set_approx';
        final mis = graph.maximumIndependentSet(approximate: approx);
        return AlgorithmResult(
          title: approx
              ? 'Maximum Independent Set (Approx)'
              : 'Maximum Independent Set (Exact)',
          summaryHtml:
              'Independent set size: <b>${mis.length}</b> [${mis.join(", ")}]',
          overlay: HighlightOverlay(
            title: 'Independent Set (${mis.length})',
            highlightedVertices: mis,
          ),
        );

      // 6. Matching
      case 'blossom_matching':
        final match = graph.maximumMatching();
        final matchedEdges = <(String, String)>{};
        final matchedNodes = <String>{};
        for (final MapEntry(:key, :value) in match.entries) {
          matchedNodes.add(key);
          matchedNodes.add(value);
          if (key.compareTo(value) < 0) {
            matchedEdges.add((key, value));
          }
        }
        return AlgorithmResult(
          title: 'Maximum Matching (Blossom)',
          summaryHtml:
              'Cardinality |M|: <b>${matchedEdges.length}</b> matched pairs.<br>'
              'Matched nodes: <b>${matchedNodes.length} / ${vertices.length}</b>',
          overlay: HighlightOverlay(
            title: 'Maximum Matching (|M| = ${matchedEdges.length})',
            highlightedVertices: matchedNodes,
            highlightedEdges: matchedEdges,
          ),
        );

      case 'bipartite_matching':
        if (!graph.isBipartite()) {
          return AlgorithmResult(
            title: 'Error',
            summaryHtml:
                'Graph is not bipartite. Blossom matching can be used instead.',
          );
        }
        final match = graph.bipartiteMatching();
        final matchedEdges = <(String, String)>{};
        final matchedNodes = <String>{};
        for (final MapEntry(:key, :value) in match.entries) {
          matchedNodes.add(key);
          matchedNodes.add(value);
          if (key.compareTo(value) < 0) {
            matchedEdges.add((key, value));
          }
        }
        return AlgorithmResult(
          title: 'Bipartite Matching',
          summaryHtml:
              'Cardinality |M|: <b>${matchedEdges.length}</b> matched pairs.',
          overlay: HighlightOverlay(
            title: 'Bipartite Matching (${matchedEdges.length})',
            highlightedVertices: matchedNodes,
            highlightedEdges: matchedEdges,
          ),
        );

      case 'weighted_bipartite_max':
      case 'weighted_bipartite_min':
        if (!graph.isBipartite()) {
          return AlgorithmResult(
            title: 'Error',
            summaryHtml: 'Graph is not bipartite.',
          );
        }
        final isMax = algo == 'weighted_bipartite_max';
        final match = graph.weightedBipartiteMatching(maximumWeight: isMax);
        final matchedEdges = <(String, String)>{};
        num totalWeight = 0;
        for (final MapEntry(:key, :value) in match.entries) {
          if (key.compareTo(value) < 0) {
            matchedEdges.add((key, value));
            totalWeight += graph.getEdge(key, value)?.value ?? 1;
          }
        }
        return AlgorithmResult(
          title: isMax
              ? 'Max-Weight Bipartite Matching'
              : 'Min-Weight Bipartite Matching',
          summaryHtml:
              'Pairs: <b>${matchedEdges.length}</b> | Total Weight: <b>$totalWeight</b>',
          overlay: HighlightOverlay(
            title: 'Weighted Bipartite Matching (Weight $totalWeight)',
            highlightedEdges: matchedEdges,
          ),
        );

      // 7. Community Detection
      case 'louvain':
        final resStr = getParam('algo-param-resolution');
        final resolution = double.tryParse(resStr) ?? 1.0;
        final communities = graph
            .louvainCommunities(resolution: resolution)
            .toList();
        final modularity = graph.modularity(communities);
        final partitionMap = <String, int>{};
        for (var i = 0; i < communities.length; i++) {
          for (final v in communities[i]) {
            partitionMap[v] = i;
          }
        }
        return AlgorithmResult(
          title: 'Louvain Communities',
          summaryHtml:
              'Detected <b>${communities.length}</b> communities.<br>'
              'Modularity Q: <b>${modularity.toStringAsFixed(4)}</b>',
          overlay: PartitionOverlay(
            title: 'Louvain Communities (Q = ${modularity.toStringAsFixed(3)})',
            vertexGroup: partitionMap,
            renderClusters: true,
          ),
        );

      case 'label_propagation':
        final communities = graph.labelPropagationCommunities().toList();
        final modularity = graph.modularity(communities);
        final partitionMap = <String, int>{};
        for (var i = 0; i < communities.length; i++) {
          for (final v in communities[i]) {
            partitionMap[v] = i;
          }
        }
        return AlgorithmResult(
          title: 'Label Propagation Communities',
          summaryHtml:
              'Detected <b>${communities.length}</b> communities.<br>'
              'Modularity Q: <b>${modularity.toStringAsFixed(4)}</b>',
          overlay: PartitionOverlay(
            title: 'LPA Communities (Q = ${modularity.toStringAsFixed(3)})',
            vertexGroup: partitionMap,
            renderClusters: true,
          ),
        );

      // 8. Tours
      case 'eulerian_path':
      case 'eulerian_circuit':
        final isCircuit = algo == 'eulerian_circuit';
        final path = graph.findEulerianPath(circuit: isCircuit);
        if (path == null) {
          return AlgorithmResult(
            title: isCircuit ? 'Eulerian Circuit' : 'Eulerian Path',
            summaryHtml:
                'No Eulerian ${isCircuit ? "circuit" : "path"} exists in this graph.',
          );
        }
        final pathEdges = <(String, String)>[];
        for (var i = 0; i < path.vertices.length - 1; i++) {
          pathEdges.add((path.vertices[i], path.vertices[i + 1]));
        }
        return AlgorithmResult(
          title: isCircuit ? 'Eulerian Circuit' : 'Eulerian Path',
          summaryHtml:
              'Found tour traversing all <b>${pathEdges.length}</b> edges!<br>'
              'Path: ${path.vertices.join(" &rarr; ")}',
          overlay: PathOverlay(
            title: isCircuit ? 'Eulerian Circuit' : 'Eulerian Path',
            vertices: path.vertices,
            edges: pathEdges,
            stepNumbers: true,
          ),
          pathVertices: path.vertices,
          pathEdges: pathEdges,
          isPathSequence: true,
        );

      case 'hamiltonian_path':
      case 'hamiltonian_circuit':
        final isCircuit = algo == 'hamiltonian_circuit';
        final path = graph.findHamiltonianPath(circuit: isCircuit);
        if (path == null) {
          return AlgorithmResult(
            title: isCircuit ? 'Hamiltonian Circuit' : 'Hamiltonian Path',
            summaryHtml:
                'No Hamiltonian ${isCircuit ? "circuit" : "path"} exists in this graph.',
          );
        }
        final pathEdges = <(String, String)>[];
        for (var i = 0; i < path.vertices.length - 1; i++) {
          pathEdges.add((path.vertices[i], path.vertices[i + 1]));
        }
        return AlgorithmResult(
          title: isCircuit ? 'Hamiltonian Circuit' : 'Hamiltonian Path',
          summaryHtml:
              'Found cycle visiting all <b>${path.vertices.length}</b> vertices!<br>'
              'Path: ${path.vertices.join(" &rarr; ")}',
          overlay: PathOverlay(
            title: isCircuit ? 'Hamiltonian Circuit' : 'Hamiltonian Path',
            vertices: path.vertices,
            edges: pathEdges,
            stepNumbers: true,
          ),
          pathVertices: path.vertices,
          pathEdges: pathEdges,
          isPathSequence: true,
        );

      // 9. Planarity & Isomorphism
      case 'planarity_check':
        final planar = graph.isPlanar();
        return AlgorithmResult(
          title: 'Left–Right Planarity Test',
          summaryHtml: planar
              ? '<b>Graph is Planar!</b> Can be embedded in the plane with zero edge crossings.'
              : '<b>Graph is NOT planar.</b> Contains a subgraph homeomorphically equivalent to K5 or K3,3.',
        );

      case 'subgraph_isomorphism':
        final patKey = getParam('algo-param-pattern');
        final pattern = switch (patKey) {
          'triangle' => GraphPresets.complete(
            vertexCount: 3,
            isDirected: graph.isDirected,
          ),
          'square' => GraphPresets.ring(
            vertexCount: 4,
            isDirected: graph.isDirected,
          ),
          'k4' => GraphPresets.complete(
            vertexCount: 4,
            isDirected: graph.isDirected,
          ),
          _ => GraphPresets.star(vertexCount: 4, isDirected: graph.isDirected),
        };
        final mappings = graph.findSubgraphIsomorphisms(pattern).toList();
        if (mappings.isEmpty) {
          return AlgorithmResult(
            title: 'Subgraph Isomorphism',
            summaryHtml: 'No induced matches of pattern "$patKey" found.',
          );
        }
        final firstMatch = mappings.first;
        final matchedTargetNodes = firstMatch.values.toSet();
        return AlgorithmResult(
          title: 'Subgraph Isomorphism',
          summaryHtml:
              'Found <b>${mappings.length}</b> isomorphic occurrences of pattern "$patKey".<br>'
              'Example match: [${matchedTargetNodes.join(", ")}]',
          overlay: HighlightOverlay(
            title: 'Subgraph Match: $patKey',
            highlightedVertices: matchedTargetNodes,
          ),
        );

      // 10. Traversals
      case 'bfs':
      case 'dfs_pre':
      case 'dfs_post':
      case 'topological':
      case 'random_walk':
        var visited = <String>[];
        var title = '';
        switch (algo) {
          case 'bfs':
            title = 'Breadth-First Search (BFS)';
            visited = graph.breadthFirst(source).toList();
          case 'dfs_pre':
            title = 'Depth-First Search (Pre-Order)';
            visited = graph.depthFirst(source).toList();
          case 'dfs_post':
            title = 'Depth-First Search (Post-Order)';
            visited = graph.depthFirstPostOrder(source).toList();
          case 'topological':
            title = 'Topological Sort';
            visited = graph.topological(source).toList();
          case 'random_walk':
            title = 'Random Walk';
            visited = graph
                .randomWalk(source, selfAvoiding: true)
                .take(20)
                .toList();
        }
        final pathEdges = <(String, String)>[];
        for (var i = 0; i < visited.length - 1; i++) {
          final u = visited[i];
          final v = visited[i + 1];
          if (graph.containsEdge(u, v) ||
              (!graph.isDirected && graph.containsEdge(v, u))) {
            pathEdges.add((u, v));
          }
        }
        return AlgorithmResult(
          title: title,
          summaryHtml:
              'Start: <b>$source</b> | Visited: <b>${visited.length}</b> nodes<br>'
              'Sequence: ${visited.join(" &rarr; ")}',
          overlay: PathOverlay(
            title: title,
            vertices: visited,
            edges: pathEdges,
            stepNumbers: true,
          ),
          pathVertices: visited,
          pathEdges: pathEdges,
          isPathSequence: true,
        );

      default:
        return AlgorithmResult(
          title: 'Unknown Algorithm',
          summaryHtml: 'Unknown algorithm: $algo',
        );
    }
  }
}
