import '../../printer.dart';
import 'model/directed.dart';
import 'model/undirected.dart';

/// An [edge](https://en.wikipedia.org/wiki/Glossary_of_graph_theory#edge)
/// withing a graph connects a [source] and a [target] vertex.
///
/// Edges are typically ephemeral objects and are only created on demand.
///
/// There are two types of edges, [DirectedEdge] and [UndirectedEdge]. The
/// only difference is that undirected edges consider [source] and [target]
/// interchangeable for comparison operations. The [value] is never used
/// for comparison.
abstract class Edge<V, E> with ToStringPrinter {
  /// Constructs a directed edge.
  const factory Edge.directed(V source, V target, {E? value}) =
      DirectedEdge<V, E>;

  /// Constructs an undirected edge.
  const factory Edge.undirected(V source, V target, {E? value}) =
      UndirectedEdge<V, E>;

  /// Generative constructor.
  const Edge(this.source, this.target, {E? value}) : value = value as E;

  /// Returns `true`, if the edge is directed.
  bool get isDirected;

  /// Origin vertex of this edge.
  final V source;

  /// Destination vertex of this edge.
  final V target;

  /// Edge specific data.
  final E value;
}
