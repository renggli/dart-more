import '../../more.dart';

/// Abstract definition of a path.
abstract class Path<V> with ToStringPrinter {
  /// The start vertex of this path.
  V get source => vertices.first;

  /// The end vertex of this path.
  V get target => vertices.last;

  /// The vertices in this path.
  Iterable<V> get vertices;

  /// The cost of the path (if available).
  num get cost;

  /// The depth of the search path.
  int get depth => vertices.length - 1;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(vertices,
        printer: Printer<V>.standard()
            .iterable(separator: ' → ', leadingItems: 3, trailingItems: 3)
            .after(' ($depth edges)'))
    ..addValue(cost, name: 'cost');
}
