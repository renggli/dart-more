import '../../more.dart';

/// A [path](https://en.wikipedia.org/wiki/Glossary_of_graph_theory#path)
/// withing a graph connects a series of [vertices] through their respective
/// [edges] and [values].
class Path<V, E> with ToStringPrinter {
  Path.fromVertices(Iterable<V> vertices, Iterable<E> values)
      : vertices = vertices.toList(growable: false),
        values = values.toList(growable: false) {
    assert(vertices.isNotEmpty);
    assert(vertices.length - 1 == values.length);
  }

  /// The vertices on this path.
  final List<V> vertices;

  /// The values on this path.
  final List<E> values;

  /// The start vertex of this path.
  V get source => vertices.first;

  /// The end vertex of this path.
  V get target => vertices.last;

  /// The edges on this path.
  Iterable<Edge<V, E>> get edges sync* {
    for (var i = 0; i < values.length; i++) {
      yield Edge<V, E>(vertices[i], vertices[i + 1], value: values[i]);
    }
  }

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(vertices,
        printer: Printer<V>.standard().iterable(
            separator: ' → ',
            leadingItems: 3,
            trailingItems: 3,
            afterPrinter: Printer.literal(' (${vertices.length - 1} edges)')));
}

extension NumericPathExtension<V> on Path<V, num> {
  /// Computes the sum of all values along the edges of this path.
  num get cost => values.fold(0, (a, b) => a + b);
}
