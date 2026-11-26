import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

class _Box {
  new(this.value);
  final int value;

  @override
  bool operator ==(Object other) => other is _Box && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

void main() {
  group('graph extension', () {
    test('empty and small graphs', () {
      final g0 = Graph<int, void>(isDirected: false);
      check(g0.betweennessCentrality()).isEmpty;

      final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
      check(g1.betweennessCentrality()[1]).equals(0.0);

      final g2 = Graph<int, void>(isDirected: false)..addEdge(1, 2);
      final bc2 = g2.betweennessCentrality();
      check(bc2[1]).equals(0.0);
      check(bc2[2]).equals(0.0);
    });

    test('line graph P3: 0 - 1 - 2', () {
      final p3 = Graph<int, void>(isDirected: false)
        ..addEdge(0, 1)
        ..addEdge(1, 2);

      // Vertex 1 lies on the only shortest path between 0 and 2.
      // For unnormalized: 1.0 for vertex 1, 0.0 for endpoints 0 and 2.
      final unnorm = p3.betweennessCentrality(normalized: false);
      check(unnorm[0]).equals(0.0);
      check(unnorm[1]).equals(1.0);
      check(unnorm[2]).equals(0.0);

      // Normalized: scale factor is 2 / ((3-1)(3-2)) = 1.0.
      final norm = p3.betweennessCentrality(normalized: true);
      check(norm[1]).equals(1.0);
    });

    test('star graph S5 (central hub)', () {
      final star = GraphFactory<int, void>(isDirected: false)
          .star(vertexCount: 5);
      // Star has center 0 and leaves 1, 2, 3, 4.
      // All paths between any pair of leaves pass through 0.
      // Number of pairs of leaves = 4 * 3 / 2 = 6.
      final unnorm = star.betweennessCentrality(normalized: false);
      check(unnorm[0]).equals(6.0);
      check(unnorm[1]).equals(0.0);
      check(unnorm[2]).equals(0.0);
      check(unnorm[3]).equals(0.0);
      check(unnorm[4]).equals(0.0);

      // Normalized: scale factor 2 / (4 * 3) = 1/6.
      // So center has normalized score 6 * (1/6) = 1.0.
      final norm = star.betweennessCentrality(normalized: true);
      check(norm[0]).equals(1.0);
    });

    test('directed line: 0 -> 1 -> 2', () {
      final p3Dir = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2);

      final bc = p3Dir.betweennessCentrality(normalized: false);
      check(bc[0]).equals(0.0);
      check(bc[1]).equals(1.0);
      check(bc[2]).equals(0.0);
    });
  });

  group('standalone', () {
    test('default strategy', () {
      final bc = betweennessCentrality<int>(
        vertices: [0, 1, 2],
        successorsOf: (v) => v == 0 ? [1] : (v == 1 ? [2] : []),
        isDirected: true,
        normalized: false,
      );
      check(bc[1]).equals(1.0);
    });

    test('identity storage strategy', () {
      final a = _Box(1);
      final b = _Box(1);
      final c = _Box(2);
      final graph =
          Graph<_Box, void>(
              isDirected: true,
              vertexStrategy: StorageStrategy.identity(),
            )
            ..addEdge(a, b)
            ..addEdge(b, c);
      final bc = graph.betweennessCentrality(normalized: false);
      check(bc[a]).equals(0.0);
      check(bc[b]).equals(1.0);
      check(bc[c]).equals(0.0);
    });
  });
}
