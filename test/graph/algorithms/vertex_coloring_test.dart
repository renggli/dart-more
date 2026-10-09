import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

void main() {
  group('vertexColoring', () {
    test('empty', () {
      final graph = GraphFactory<int, int>().empty();
      check(graph.vertexColoring()).isEmpty();
    });
    test('separate vertices', () {
      final graph = Graph<int, void>(isDirected: false);
      for (var i = 1; i <= 10; i++) {
        graph.addVertex(i);
        final coloring = graph.vertexColoring();
        check(coloring).length.equals(i);
        check(coloring.values.toSet()).length.equals(1);
      }
    });
    test('bipartite graphs', () {
      for (var i = 1; i <= 10; i++) {
        final graph = GraphFactory<int, void>(isDirected: false)
            .partite(vertexCounts: [i, i]);
        final coloring = graph.vertexColoring();
        check(coloring.values.toSet()).length.equals(2);
      }
    });
    test('complete graphs', () {
      for (var i = 3; i <= 10; i++) {
        final graph = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: i);
        final coloring = graph.vertexColoring();
        check(coloring.values.toSet()).length.equals(i);
      }
    });
    test('star graphs', () {
      for (var i = 2; i <= 10; i++) {
        final graph = GraphFactory<int, void>(isDirected: false)
            .star(vertexCount: i);
        final coloring = graph.vertexColoring();
        check(coloring.values.toSet()).length.equals(2);
      }
    });
  });
}
