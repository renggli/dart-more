import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

final _factory = GraphFactory<int, void>(isDirected: false);
final _atlas = [
  for (var i = 0; i < _factory.atlasLength; i++) _factory.atlas(i),
];
final _atlasSample = [
  for (var i = 0; i < _factory.atlasLength; i += 5) _atlas[i],
];

Graph<int, num> _randomGraph(
  Random random, {
  required bool isDirected,
  int maxVertices = 6,
  bool allowLoops = false,
}) {
  final vertexCount = random.nextInt(maxVertices) + 1;
  final probability = random.nextDouble();
  final graph = GraphFactory<int, num>(
    isDirected: isDirected,
    edgeProvider: (_, _) => random.nextInt(5) + 1,
    random: random,
  ).randomErdosRenyi(vertexCount: vertexCount, probability: probability);
  if (allowLoops) {
    for (final v in graph.vertices) {
      if (random.nextDouble() < probability) {
        graph.addEdge(v, v, value: random.nextInt(5) + 1);
      }
    }
  }
  return graph;
}

List<Set<int>> _subsets(List<int> vertices) => [
  for (var mask = 0; mask < 1 << vertices.length; mask++)
    {
      for (var i = 0; i < vertices.length; i++)
        if (mask & (1 << i) != 0) vertices[i],
    },
];

bool _isIndependent(Graph<int, dynamic> graph, Set<int> subset) => subset.every(
  (a) => subset.every((b) => a == b || !graph.containsEdge(a, b)),
);

int _matchingSize(Graph<int, dynamic> graph) {
  final edges = graph.edges.where((e) => e.source < e.target).toList();
  var best = 0;
  void search(int index, Set<int> used, int size) {
    best = max(best, size);
    for (var j = index; j < edges.length; j++) {
      final edge = edges[j];
      if (!used.contains(edge.source) && !used.contains(edge.target)) {
        search(j + 1, {...used, edge.source, edge.target}, size + 1);
      }
    }
  }

  search(0, {}, 0);
  return best;
}

int _components(Graph<int, dynamic> graph, Set<int> removed) {
  final seen = <int>{...removed};
  var count = 0;
  for (final v in graph.vertices) {
    if (seen.add(v)) {
      count++;
      final stack = [v];
      while (stack.isNotEmpty) {
        for (final w in graph.neighboursOf(stack.removeLast())) {
          if (seen.add(w)) stack.add(w);
        }
      }
    }
  }
  return count;
}

bool _isStronglyConnected(Graph<int, dynamic> graph, Set<int> removed) {
  final remaining = graph.vertices.where((v) => !removed.contains(v)).toList();
  if (remaining.length <= 1) return true;
  final start = remaining.first;
  final forward = <int>{...removed, start};
  final stack = [start];
  while (stack.isNotEmpty) {
    for (final w in graph.successorsOf(stack.removeLast())) {
      if (forward.add(w)) stack.add(w);
    }
  }
  if (forward.length - removed.length != remaining.length) return false;
  final backward = <int>{...removed, start};
  stack.add(start);
  while (stack.isNotEmpty) {
    for (final w in graph.predecessorsOf(stack.removeLast())) {
      if (backward.add(w)) stack.add(w);
    }
  }
  return backward.length - removed.length == remaining.length;
}

void main() {
  group('atlas properties', () {
    test('planarity count', () {
      // Of the 1,253 graphs in the Atlas of Graphs (all undirected graphs up to
      // 7 vertices), exactly 1,016 are planar.
      check(_atlas.where((g) => g.isPlanar()).length).equals(1016);
    });

    test('maximum and bipartite matching', () {
      for (final g in _atlasSample) {
        final expected = _matchingSize(g);
        final matching = g.maximumMatching();
        // Every matched pair must correspond to an existing edge and be
        // symmetric in the returned map (match[u] == v <=> match[v] == u).
        for (final entry in matching.entries) {
          check(g.containsEdge(entry.key, entry.value)).isTrue();
          check(matching[entry.value]).equals(entry.key);
        }
        // Edmonds' Blossom cardinality must match brute-force maximum matching,
        // and Hopcroft–Karp must agree on bipartite graphs.
        check(matching.length ~/ 2).equals(expected);
        if (g.isBipartite()) {
          check(g.bipartiteMatching().length ~/ 2).equals(expected);
        }
      }
    });

    test('minimum vertex cover and maximum independent set', () {
      for (final g in _atlasSample) {
        final bestInd = _subsets(g.vertices.toList())
            .where((s) => _isIndependent(g, s))
            .map((s) => s.length)
            .fold(0, max);
        // No two vertices in the maximum independent set may share an edge, and
        // its cardinality must equal the brute-force optimum alpha(G).
        final mis = g.maximumIndependentSet();
        check(_isIndependent(g, mis)).isTrue();
        check(mis.length).equals(bestInd);

        // Gallai's identity: |minimumVertexCover| + |maximumIndependentSet| = |V|,
        // and every edge in G must have at least one endpoint in the cover.
        final vc = g.minimumVertexCover();
        check(vc.length).equals(g.vertices.length - bestInd);
        for (final e in g.edges) {
          check(vc.contains(e.source) || vc.contains(e.target)).isTrue();
        }
      }
    });

    test('articulation points, bridges, and biconnected components', () {
      for (final g in _atlasSample) {
        // A vertex is an articulation point iff removing it strictly increases
        // the number of connected components.
        final baseComponents = _components(g, const {});
        final expectedAp = {
          for (final v in g.vertices)
            if (_components(g, {v}) > baseComponents) v,
        };
        check(g.articulationPoints()).unorderedEquals(expectedAp);

        // An edge is a bridge iff removing it strictly increases the number of
        // connected components.
        final expectedBridges = <(int, int)>{};
        for (final e in g.edges.where((e) => e.source < e.target).toList()) {
          g.removeEdge(e.source, e.target);
          if (_components(g, const {}) > baseComponents) {
            expectedBridges.add((e.source, e.target));
          }
          g.addEdge(e.source, e.target);
        }
        final actualBridges = g
            .bridges()
            .map((e) => (min(e.source, e.target), max(e.source, e.target)))
            .toSet();
        check(actualBridges).unorderedEquals(expectedBridges);

        // Biconnected components partition the edge set of G.
        final bccs = g.biconnectedComponents().toList();
        final bccEdges = bccs
            .expand((c) => c.edges)
            .where((e) => e.source < e.target)
            .length;
        check(bccEdges).equals(g.edges.length ~/ 2);
      }
    });

    test('connectivity and min-cut', () {
      for (final g in _atlasSample.where((g) => g.vertices.length >= 2)) {
        final vs = g.vertices.toList();
        // Vertex connectivity kappa(G): smallest vertex subset whose removal
        // disconnects G (or |V| - 1 for complete graphs K_n).
        var kv = vs.length - 1;
        for (final s in _subsets(vs)) {
          if (s.length < kv &&
              vs.length - s.length >= 2 &&
              _components(g, s) > 1) {
            kv = s.length;
          }
        }
        check(g.vertexConnectivity()).equals(kv);

        // Edge connectivity lambda(G) and Stoer–Wagner global min-cut must both
        // equal the minimum number of edges crossing any non-trivial cut (S, V\S).
        var ke = 1 << 30;
        for (final s in _subsets(vs)) {
          if (s.isEmpty || s.length == vs.length) continue;
          final cut = g.edges.where(
            (e) => s.contains(e.source) && !s.contains(e.target),
          );
          ke = min(ke, cut.length);
        }
        check(g.edgeConnectivity()).equals(ke);
        check(g.minCut().weight).equals(ke);
      }
    });

    test('maximal cliques and core numbers', () {
      for (final g in _atlasSample) {
        final vs = g.vertices.toList();
        // Bron–Kerbosch must yield every clique that is not a strict subset of
        // a larger clique.
        final cliques = _subsets(vs)
            .where(
              (s) =>
                  s.isNotEmpty &&
                  s.every(
                    (a) => s.every((b) => a == b || g.containsEdge(a, b)),
                  ),
            )
            .toList();
        final maximal = cliques
            .where(
              (s) =>
                  !cliques.any((t) => t.length > s.length && t.containsAll(s)),
            )
            .map((s) => (s.toList()..sort()).join(','))
            .toSet();
        final actualCliques = g
            .findCliques()
            .map((s) => (s.toList()..sort()).join(','))
            .toSet();
        check(actualCliques).unorderedEquals(maximal);

        // Every vertex in the k-core subgraph must have induced degree >= k
        // and core number >= k.
        final cores = g.coreNumbers();
        for (final k in [1, 2, 3]) {
          final kCore = g.kCore(k);
          for (final v in kCore.vertices) {
            check(kCore.degreeOf(v)).isGreaterOrEqual(k);
            check(cores[v]!).isGreaterOrEqual(k);
          }
        }
      }
    });

    test('coloring and bipartiteness', () {
      for (final g in _atlasSample) {
        // Proper vertex coloring: adjacent vertices never receive the same color.
        final colors = g.vertexColoring();
        for (final e in g.edges) {
          check(colors[e.source]).not((it) => it.equals(colors[e.target]));
        }
        // A graph is bipartite iff there exists a 2-partition of V with no
        // monochromatic edges.
        final vs = g.vertices.toList();
        final expectedBip = _subsets(vs).any(
          (s) => g.edges.every(
            (e) => s.contains(e.source) != s.contains(e.target),
          ),
        );
        check(g.isBipartite()).equals(expectedBip);
      }
    });
  });

  group('randomized invariants', () {
    test('shortest paths and max flow', () {
      final random = Random(42);
      for (var t = 0; t < 50; t++) {
        final g = _randomGraph(random, isDirected: random.nextBool());
        // Dijkstra, Bellman–Ford, and Floyd–Warshall must agree on all-pairs
        // shortest path distances.
        final fw = g.allShortestPaths();
        for (final s in g.vertices) {
          for (final d in g.vertices) {
            final dj = g.shortestPath(s, d);
            final bf = g.shortestPath(s, d, hasNegativeEdges: true);
            final ex = fw.distance(s, d);
            check(dj?.cost ?? double.infinity).equals(ex);
            check(bf?.cost ?? double.infinity).equals(ex);
          }
        }
        // Max-flow min-cut theorem: Dinic's s-d max flow must equal the minimum
        // capacity of an s-d cut.
        if (g.isDirected && g.vertices.length >= 2) {
          final vs = g.vertices.toList();
          final flow = g.maxFlow();
          final s = vs.first, d = vs.last;
          num minCutCap = double.infinity;
          for (final cut in _subsets(vs)) {
            if (!cut.contains(s) || cut.contains(d)) continue;
            final cap = g.edges
                .where((e) => cut.contains(e.source) && !cut.contains(e.target))
                .fold<num>(0, (a, e) => a + e.value);
            minCutCap = min(minCutCap, cap);
          }
          check(flow(s, d)).equals(minCutCap);
        }
      }
    });

    test(
      'directed connectivity, SCC, cycles, and isomorphism with self-loops',
      () {
        final random = Random(1337);
        for (var t = 0; t < 60; t++) {
          final g = _randomGraph(
            random,
            isDirected: true,
            maxVertices: 5,
            allowLoops: true,
          );
          final vs = g.vertices.toList();

          // Tarjan's SCCs must partition V, and vertices within each SCC must
          // be mutually reachable.
          final reach = {
            for (final v in vs)
              v: DepthFirstIterable([v], successorsOf: g.successorsOf).toSet(),
          };
          final sccs = g.stronglyConnected().toList();
          check(sccs.expand((c) => c).length).equals(vs.length);
          for (final c in sccs) {
            for (final a in c) {
              check(reach[a]!.containsAll(c)).isTrue();
            }
          }
          // A directed graph has a cycle iff some vertex v has a successor w
          // that can reach v (including self-loops v -> v).
          final hasCyc = vs.any(
            (v) => g.successorsOf(v).any((w) => reach[w]!.contains(v)),
          );
          check(g.hasCycle()).equals(hasCyc);

          // Directed vertex connectivity: smallest vertex cut whose removal
          // destroys strong connectivity.
          if (vs.length >= 2) {
            var kv = vs.length - 1;
            for (final s in _subsets(vs)) {
              if (s.length < kv &&
                  vs.length - s.length >= 2 &&
                  !_isStronglyConnected(g, s)) {
                kv = s.length;
              }
            }
            check(g.vertexConnectivity()).equals(kv);
          }

          // Any graph must be isomorphic to a vertex-permuted copy of itself
          // preserving edge weights and self-loops.
          final perm = vs.toList()..shuffle(random);
          final h = Graph<int, num>(isDirected: true);
          for (final v in vs) {
            h.addVertex(perm[v]);
          }
          for (final e in g.edges) {
            h.addEdge(perm[e.source], perm[e.target], value: e.value);
          }
          check(g.isIsomorphicTo(h, edgeComparator: (a, b) => a == b)).isTrue();
        }
      },
    );

    test('hamiltonian and eulerian paths', () {
      final random = Random(99);
      for (var t = 0; t < 60; t++) {
        final isDirected = random.nextBool();
        final g = _randomGraph(
          random,
          isDirected: isDirected,
          maxVertices: 5,
          allowLoops: true,
        );
        final vs = g.vertices.toList();
        // Compare Hamiltonian path and circuit detection against exhaustive
        // permutation search.
        var hasPath = false, hasCircuit = false;
        for (final p in vs.permutations()) {
          var ok = true;
          for (var i = 0; i + 1 < p.length; i++) {
            if (!g.containsEdge(p[i], p[i + 1])) ok = false;
          }
          if (ok) {
            hasPath = true;
            final minCycleLen = isDirected ? 2 : 3;
            if (p.length >= minCycleLen && g.containsEdge(p.last, p.first)) {
              hasCircuit = true;
            }
          }
        }
        check(g.hasHamiltonianPath()).equals(hasPath);
        check(g.findHamiltonianPath() != null).equals(hasPath);
        if (vs.length >= 3) {
          check(g.hasHamiltonianCircuit()).equals(hasCircuit);
        }

        // Any Eulerian path found must consist exclusively of valid graph edges.
        final ep = g.findEulerianPath();
        if (ep != null && g.edges.isNotEmpty) {
          for (final e in ep.edges) {
            check(g.containsEdge(e.source, e.target)).isTrue();
          }
        }
      }
    });
  });

  group('deep graph recursion safety', () {
    // Verify that all traversal and DFS-based algorithms execute iteratively
    // without overflowing the call stack on a 5,000-vertex path graph.
    const depth = 5000;

    test('directed chain does not overflow stack', () {
      final g = GraphFactory<int, num>(
        isDirected: true,
        edgeProvider: (_, _) => 1,
      ).path(vertexCount: depth);

      check(g.hasCycle()).isFalse();
      check(g.stronglyConnected().length).equals(depth);
      check(g.maxFlow()(0, depth - 1)).equals(1);
      check(g.shortestPath(0, depth - 1)?.cost).equals(depth - 1);
      check(g.depthFirst(0).length).equals(depth);
      check(g.depthFirstPostOrder(0).length).equals(depth);
      check(g.breadthFirst(0).length).equals(depth);
      check(g.topological(0).length).equals(depth);
      check(g.isIsomorphicTo(g)).isTrue();
    });

    test('undirected chain does not overflow stack', () {
      final g = GraphFactory<int, num>(
        isDirected: false,
        edgeProvider: (_, _) => 1,
      ).path(vertexCount: depth);

      check(g.articulationPoints().length).equals(depth - 2);
      check(g.bridges().length).equals(depth - 1);
      check(g.biconnectedComponents().length).equals(depth - 1);
      check(g.isPlanar()).isTrue();
      check(g.isBipartite()).isTrue();
      check(g.bipartiteMatching().length ~/ 2).equals(depth ~/ 2);
      check(g.maximumMatching().length ~/ 2).equals(depth ~/ 2);
      check(g.coreNumbers().values.every((c) => c == 1)).isTrue();
      check(g.isIsomorphicTo(g)).isTrue();
    });
  });
}
