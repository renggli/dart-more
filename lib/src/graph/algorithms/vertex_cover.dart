import '../strategy.dart';
import 'bipartite_check.dart' as bipartite_check;
import 'bipartite_matching.dart' as bipartite_matching;

/// Computes a minimum vertex cover of an undirected graph.
///
/// If [approximate] is `true`, uses a 2-approximation algorithm running in
/// `O(|V| + |E|)` time.
/// Otherwise, uses an exact algorithm: König's theorem
/// (`O(|E| * sqrt(|V|))`) if the graph is bipartite, or branch-and-bound search
/// if non-bipartite.
Set<V> minimumVertexCover<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  bool approximate = false,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  if (approximate) {
    return approximateMinimumVertexCover<V>(
      vertices: vertices,
      neighboursOf: neighboursOf,
      vertexStrategy: vertexStrategy,
    );
  }

  final isBip = bipartite_check.isBipartite<V>(
    vertices: vertices,
    neighboursOf: neighboursOf,
    vertexStrategy: vertexStrategy,
  );
  if (isBip) {
    return bipartite_matching.minimumVertexCover<V>(
      vertices: vertices,
      neighboursOf: neighboursOf,
      vertexStrategy: vertexStrategy,
    );
  }

  final vertexList = vertices.toList(growable: false);
  final n = vertexList.length;
  if (n <= 1) {
    final cover = vertexStrategy.createSet();
    if (n == 1 && neighboursOf(vertexList.first).contains(vertexList.first)) {
      cover.add(vertexList.first);
    }
    return cover;
  }

  final vertexIndex = vertexStrategy.createMap<int>();
  for (var i = 0; i < n; i++) {
    vertexIndex[vertexList[i]] = i;
  }

  final edges = <(int, int)>[];
  final selfLoops = <int>{};
  for (var i = 0; i < n; i++) {
    for (final neighbor in neighboursOf(vertexList[i])) {
      final j = vertexIndex[neighbor];
      if (j != null) {
        if (i == j) {
          selfLoops.add(i);
        } else if (i < j) {
          edges.add((i, j));
        }
      }
    }
  }

  var bestCoverIndices = List<int>.generate(n, (i) => i);
  final currentCover = <int>{...selfLoops};

  void search(int edgeIdx) {
    if (currentCover.length >= bestCoverIndices.length) {
      return;
    }

    while (edgeIdx < edges.length) {
      final (u, v) = edges[edgeIdx];
      if (!currentCover.contains(u) && !currentCover.contains(v)) {
        break;
      }
      edgeIdx++;
    }

    if (edgeIdx == edges.length) {
      bestCoverIndices = currentCover.toList();
      return;
    }

    final (u, v) = edges[edgeIdx];

    currentCover.add(u);
    search(edgeIdx + 1);
    currentCover.remove(u);

    currentCover.add(v);
    search(edgeIdx + 1);
    currentCover.remove(v);
  }

  search(0);

  final result = vertexStrategy.createSet();
  for (final idx in bestCoverIndices) {
    result.add(vertexList[idx]);
  }
  return result;
}

/// Computes a maximum independent set of an undirected graph.
///
/// If [approximate] is `true`, uses a greedy minimum-degree heuristic.
/// Otherwise, uses an exact algorithm: the complement of the exact minimum
/// vertex cover.
Set<V> maximumIndependentSet<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  bool approximate = false,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  if (approximate) {
    return approximateMaximumIndependentSet<V>(
      vertices: vertices,
      neighboursOf: neighboursOf,
      vertexStrategy: vertexStrategy,
    );
  }

  final cover = minimumVertexCover<V>(
    vertices: vertices,
    neighboursOf: neighboursOf,
    approximate: false,
    vertexStrategy: vertexStrategy,
  );
  final independentSet = vertexStrategy.createSet();
  for (final v in vertices) {
    if (!cover.contains(v)) {
      independentSet.add(v);
    }
  }
  return independentSet;
}

/// Computes a 2-approximate minimum vertex cover of an undirected graph in
/// `O(|V| + |E|)` time.
Set<V> approximateMinimumVertexCover<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final cover = vertexStrategy.createSet();
  for (final u in vertices) {
    for (final v in neighboursOf(u)) {
      if (u == v) {
        cover.add(u);
      } else if (!cover.contains(u) && !cover.contains(v)) {
        cover.add(u);
        cover.add(v);
      }
    }
  }
  return cover;
}

/// Computes an approximate maximum independent set using a greedy
/// minimum-degree heuristic.
Set<V> approximateMaximumIndependentSet<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final remaining = vertexStrategy.createSet();
  for (final v in vertices) {
    if (!neighboursOf(v).contains(v)) {
      remaining.add(v);
    }
  }
  final independentSet = vertexStrategy.createSet();

  while (remaining.isNotEmpty) {
    V? minVertex;
    var minDeg = 1 << 30;
    for (final v in remaining) {
      var deg = 0;
      for (final neighbor in neighboursOf(v)) {
        if (remaining.contains(neighbor) && neighbor != v) deg++;
      }
      if (deg < minDeg) {
        minDeg = deg;
        minVertex = v;
      }
    }

    if (minVertex == null) break;
    independentSet.add(minVertex);
    remaining.remove(minVertex);
    for (final neighbor in neighboursOf(minVertex)) {
      remaining.remove(neighbor);
    }
  }

  return independentSet;
}
