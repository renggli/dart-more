import '../../more.dart';

/// Abstract definition of a path.
class Path<V> with ToStringPrinter {
  /// Constructs a path of vertices.
  Path(this.vertices, this.cost);

  /// The start vertex of this path.
  V get source => vertices.first;

  /// The end vertex of this path.
  V get target => vertices.last;

  /// The vertices in this path.
  final Iterable<V> vertices;

  /// The cost of the path (if available).
  final num cost;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(vertices,
        printer: Printer<V>.standard().iterable(
            separator: ' → ',
            leadingItems: 3,
            trailingItems: 3,
            afterPrinter: Printer.literal(' (${vertices.length - 1} edges)')))
    ..addValue(cost, name: 'cost');
}
