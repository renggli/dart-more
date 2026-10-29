import '../strategy.dart';

/// Computes the density of a graph.
///
/// For a directed graph with $|V|$ vertices and $|E|$ non-self edges, density is
/// $\frac{|E|}{|V|(|V|-1)}$.
/// For an undirected graph with $|E_u|$ non-self edges, density is
/// $\frac{2|E_u|}{|V|(|V|-1)}$.
///
/// Returns `0.0` if $|V| < 2$.
double graphDensity<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
}) {
  final n = vertices.length;
  if (n < 2) return 0.0;
  final maxEdges = n * (n - 1);
  var count = 0;
  for (final v in vertices) {
    for (final w in successorsOf(v)) {
      if (w != v) count++;
    }
  }
  return count / maxEdges;
}

/// Returns the local clustering coefficient of [vertex].
///
/// For undirected graphs, this is $\frac{2 e}{k(k - 1)}$ where $k$ is the number of
/// distinct neighbours and $e$ is the number of undirected edges between them.
/// For directed graphs, this is $\frac{e}{k(k - 1)}$ where $e$ is the number of
/// directed edges between distinct neighbours.
///
/// Returns `0.0` if [vertex] has fewer than 2 neighbours.
double localClusteringCoefficient<V>(
  V vertex, {
  required Iterable<V> Function(V vertex) neighboursOf,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  final neighbours = vertexStrategy.createSet()..addAll(neighboursOf(vertex));
  neighbours.remove(vertex);
  final k = neighbours.length;
  if (k < 2) return 0.0;

  var links = 0;
  if (isDirected) {
    for (final u in neighbours) {
      for (final w in successorsOf(u)) {
        if (u != w && neighbours.contains(w)) {
          links++;
        }
      }
    }
  } else {
    for (final u in neighbours) {
      for (final w in neighboursOf(u)) {
        if (u != w && neighbours.contains(w)) {
          links++;
        }
      }
    }
  }
  return links / (k * (k - 1));
}

/// Returns the average clustering coefficient across all [vertices] in the graph.
///
/// Returns `0.0` if [vertices] is empty.
double averageClusteringCoefficient<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  required Iterable<V> Function(V vertex) successorsOf,
  required bool isDirected,
  StorageStrategy<V>? vertexStrategy,
}) {
  if (vertices.isEmpty) return 0.0;
  var sum = 0.0;
  var count = 0;
  for (final v in vertices) {
    sum += localClusteringCoefficient(
      v,
      neighboursOf: neighboursOf,
      successorsOf: successorsOf,
      isDirected: isDirected,
      vertexStrategy: vertexStrategy,
    );
    count++;
  }
  return count == 0 ? 0.0 : sum / count;
}

/// Returns the transitivity (global clustering coefficient) of an undirected graph.
///
/// Transitivity is defined as $3 \times \frac{\text{number of triangles}}{\text{number of connected triplets}}$.
/// Returns `0.0` if there are no connected triplets.
double graphTransitivity<V>({
  required Iterable<V> vertices,
  required Iterable<V> Function(V vertex) neighboursOf,
  StorageStrategy<V>? vertexStrategy,
}) {
  vertexStrategy ??= StorageStrategy.defaultStrategy();
  var triangles = 0;
  var triplets = 0;
  for (final v in vertices) {
    final neighbours = vertexStrategy.createSet()..addAll(neighboursOf(v));
    neighbours.remove(v);
    final k = neighbours.length;
    if (k < 2) continue;
    triplets += k * (k - 1);
    for (final u in neighbours) {
      for (final w in neighboursOf(u)) {
        if (u != w && neighbours.contains(w)) {
          triangles++;
        }
      }
    }
  }
  return triplets == 0 ? 0.0 : triangles / triplets;
}
