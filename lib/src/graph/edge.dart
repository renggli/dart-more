import '../../printer.dart';

/// Abstract definition of an edge.
abstract class Edge<V, E> with ToStringPrinter {
  const Edge();

  /// Origin vertex of this edge.
  V get source;

  /// Destination vertex of this edge.
  V get target;

  /// Edge specific data
  E get data;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue([source, target],
        printer: Printer<V>.standard().iterable(separator: ' → '))
    ..addValue(data, name: 'data', omitNull: true);
}
