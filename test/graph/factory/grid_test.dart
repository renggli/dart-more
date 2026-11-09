import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('grid', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().grid(rows: 0, columns: 0);
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
      expectInvariants(graph);
    });

    test('single', () {
      final graph = GraphFactory<int, void>().grid(rows: 1, columns: 1);
      check(graph.vertices).deepEquals([0]);
      check(graph.edges).isEmpty();
      expectInvariants(graph);
    });

    test('2x3 grid', () {
      final graph = GraphFactory<int, void>().grid(rows: 2, columns: 3);
      check(graph.vertices).unorderedEquals([0, 1, 2, 3, 4, 5]);
      check(graph.edges).unorderedMatches([
        isEdge(0, 1),
        isEdge(1, 2),
        isEdge(3, 4),
        isEdge(4, 5),
        isEdge(0, 3),
        isEdge(1, 4),
        isEdge(2, 5),
      ]);
      expectInvariants(graph);
    });

    test('invalid', () {
      check(() => GraphFactory<int, void>().grid(rows: -1, columns: 2))
          .throws<RangeError>();
      check(() => GraphFactory<int, void>().grid(rows: 2, columns: -1))
          .throws<RangeError>();
    });
  });
}
