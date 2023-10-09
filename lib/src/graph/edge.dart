import '../../printer.dart';

/// An [edge](https://en.wikipedia.org/wiki/Glossary_of_graph_theory#edge)
/// withing a graph connects a [source] and a [target] vertex.
///
/// Edges are typically ephemeral objects and only created on demand.
///
/// Two edges are considered equal if they have matching [source] and [target]
/// vertices; the [value] is not used for comparison.
class Edge<V, E> with ToStringPrinter {
  /// Constructs
  Edge(this.source, this.target, {E? value}) : value = value as E;

  /// Origin vertex of this edge.
  final V source;

  /// Destination vertex of this edge.
  final V target;

  /// Edge specific data.
  final E value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Edge && source == other.source && target == other.target);

  @override
  int get hashCode => source.hashCode ^ target.hashCode;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue([source, target],
        printer: Printer<V>.standard().iterable(separator: ' → '))
    ..addValue(value, name: 'data', omitNull: true);
}
