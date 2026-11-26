import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('graph extension', () {
    test('star graph dominating set is center', () {
      // S5 has center 0 connected to 1, 2, 3, 4
      final star = GraphFactory<int, void>(isDirected: false)
          .star(vertexCount: 5);
      final dom = star.dominatingSet();
      check(dom).contains(0);
      check(dom.length).equals(1);
    });

    test('path graph dominating set covers all vertices', () {
      final path = GraphFactory<int, void>(isDirected: false)
          .path(vertexCount: 4);
      final dom = path.dominatingSet();
      // Dominating set must cover 0, 1, 2, 3
      final covered = <int>{};
      for (final v in dom) {
        covered.add(v);
        covered.addAll(path.neighboursOf(v));
      }
      check(covered).deepEquals({0, 1, 2, 3});
    });
  });

  group('standalone', () {
    test('single-pass iterable vertices', () {
      Iterable<int> verticesOnce() sync* {
        yield 0;
        yield 1;
        yield 2;
      }

      var calls = 0;
      final dom = dominatingSet<int>(
        vertices: verticesOnce().map((v) {
          calls++;
          return v;
        }),
        neighboursOf: (v) => switch (v) {
          0 => [1],
          1 => [0, 2],
          2 => [1],
          _ => const [],
        },
      );
      check(dom).deepEquals({1});
      check(calls).equals(3);
    });
  });
}
