import '../../printer.dart';
import 'edge.dart';
import 'model/directed.dart';
import 'model/undirected.dart';
import 'strategy.dart';

/// Abstract base class of graphs.
///
/// [Graph] allows self-loops (edges from a vertex to itself). If you do not
/// want self-loops, do not create self-loops.
///
/// [Graph] does not support parallel edges. If you repeatedly add an edge with
/// the same source and target vertex the previous edge is replaced with the new
/// one. Use an [Iterable] as the edge-value, if you'd like to model a graph
/// with parallel edges.
abstract class Graph<V, E> with ToStringPrinter {
  /// Directed graph.
  factory Graph.directed({StorageStrategy<V>? vertexStrategy}) = DirectedGraph;

  /// Undirected graph.
  factory Graph.undirected({StorageStrategy<V>? vertexStrategy}) =
      UndirectedGraph;

  /// Generative constructor.
  Graph();

  /// Returns `true`, if the graph is directed.
  bool get isDirected;

  /// Returns `true`, if the graph is unmodifiable.
  bool get isUnmodifiable => false;

  /// Returns a strategy to store vertices.
  StorageStrategy<V> get vertexStrategy;

  /// Returns the vertices of this graph.
  Iterable<V> get vertices;

  /// Returns the edges of this graph.
  Iterable<Edge<V, E>> get edges;

  /// Returns the incoming and outgoing edges of [vertex].
  Iterable<Edge<V, E>> edgesOf(V vertex);

  /// Returns the incoming edges of [vertex].
  Iterable<Edge<V, E>> incomingEdgesOf(V vertex);

  /// Returns the outgoing edges of [vertex].
  Iterable<Edge<V, E>> outgoingEdgesOf(V vertex);

  /// Returns the edge between [source] and [target], or `null`.
  Edge<V, E>? getEdge(V source, V target);

  /// Returns the vertices that are adjacent to a `vertex`.
  Iterable<V> neighboursOf(V vertex);

  /// Returns the vertices that come before a [vertex].
  Iterable<V> predecessorsOf(V vertex);

  /// Returns the vertices that come after a [vertex].
  Iterable<V> successorsOf(V vertex);

  /// Adds a [vertex] to this graph.
  void addVertex(V vertex);

  /// Adds an edge between [source] and [target] vertex. Optionally
  /// associates the provided [data] with the edge.
  void addEdge(V source, V target, {E? data});

  /// Removes a [vertex] from this graph.
  void removeVertex(V vertex);

  /// Removes an edge between [source] and [target] from this graph.
  void removeEdge(V source, V target, {E? data});

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(vertices,
        name: 'vertices',
        printer: Printer<V>.standard().iterable(
            leadingItems: 3,
            trailingItems: 0,
            afterPrinter: Printer.literal(' (${vertices.length} total)')))
    ..addValue(edges,
        name: 'edges',
        printer: Printer<Edge<V, E>>.standard().iterable(
            leadingItems: 3,
            trailingItems: 0,
            afterPrinter: Printer.literal(' (${edges.length} total)')));
}
