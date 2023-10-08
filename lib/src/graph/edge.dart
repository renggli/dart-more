import '../../printer.dart';

/// Abstract definition of an edge.
class Edge<V, E> with ToStringPrinter {
  /// Constructs
  Edge(this.source, this.target, this.data);

  /// Origin vertex of this edge.
  final V source;

  /// Destination vertex of this edge.
  final V target;

  /// Edge specific data
  final E data;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue([source, target],
        printer: Printer<V>.standard().iterable(separator: ' → '))
    ..addValue(data, name: 'data', omitNull: true);
}
