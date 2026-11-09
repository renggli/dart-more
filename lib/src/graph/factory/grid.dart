import '../factory.dart';
import '../graph.dart';

/// Extension on [GraphFactory] to create grid graphs.
extension GridGraphFactoryExtension<V, E> on GraphFactory<V, E> {
  /// Creates a [Graph] of [rows] by [columns] in a rectangular 2D grid.
  ///
  /// ```dart
  /// final graph = GraphFactory<int, void>().grid(rows: 2, columns: 3);
  /// print(graph.vertices.length); // 6
  /// ```
  Graph<V, E> grid({required int rows, required int columns}) {
    if (rows < 0) {
      throw RangeError.value(rows, 'rows', 'Rows must not be negative');
    }
    if (columns < 0) {
      throw RangeError.value(
        columns,
        'columns',
        'Columns must not be negative',
      );
    }
    final builder = newBuilder();
    final count = rows * columns;
    for (var i = 0; i < count; i++) {
      builder.addVertexIndex(i);
    }
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < columns; c++) {
        final current = r * columns + c;
        if (c + 1 < columns) {
          builder.addEdgeIndex(current, current + 1);
        }
        if (r + 1 < rows) {
          builder.addEdgeIndex(current, (r + 1) * columns + c);
        }
      }
    }
    return builder.build();
  }
}
