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
    test('empty and single vertex graph', () {
      final g0 = Graph<int, void>(isDirected: false);
      check(g0.eigenvectorCentrality()).isEmpty;

      final g1 = Graph<int, void>(isDirected: false)..addVertex(1);
      check(g1.eigenvectorCentrality()[1]).equals(0.0);

      final g1Loop = Graph<int, void>(isDirected: false)..addEdge(1, 1);
      check(g1Loop.eigenvectorCentrality()[1]).equals(1.0);
    });

    test('disconnected vertices (zero norm)', () {
      final g = Graph<int, void>(isDirected: false)
        ..addVertex(1)
        ..addVertex(2);
      final ec = g.eigenvectorCentrality();
      check(ec[1]).equals(0.0);
      check(ec[2]).equals(0.0);
    });

    test('undirected ring R3', () {
      final ring = GraphFactory<int, void>(isDirected: false)
          .ring(vertexCount: 3);
      final ec = ring.eigenvectorCentrality();
      const expected = 1 / 1.7320508; // 1 / sqrt(3)
      check(ec[0]!).isCloseTo(expected, 1e-4);
      check(ec[1]!).isCloseTo(expected, 1e-4);
      check(ec[2]!).isCloseTo(expected, 1e-4);
    });

    test('star graph S3 (center has higher score)', () {
      final star = GraphFactory<int, void>(isDirected: false)
          .star(vertexCount: 3);
      // Center is 0, leaves are 1 and 2.
      final ec = star.eigenvectorCentrality();
      // x_0 = sqrt(0.5) ~ 0.7071, x_1 = x_2 = 0.5.
      check(ec[0]!).isCloseTo(0.707106, 1e-4);
      check(ec[1]!).isCloseTo(0.5, 1e-4);
      check(ec[2]!).isCloseTo(0.5, 1e-4);
    });

    test('weighted edges', () {
      final g = Graph<int, int>(isDirected: false)
        ..addEdge(0, 1, value: 2)
        ..addEdge(0, 2, value: 1);
      final ec = g.eigenvectorCentrality(
        edgeWeight: (u, v) => g.getEdge(u, v)!.value,
      );
      check(ec[1]! > ec[2]!).isTrue;
    });
  });

  group('standalone', () {
    test('without predecessorsOf', () {
      final ec = eigenvectorCentrality<int>(
        vertices: [1, 2, 3],
        successorsOf: (v) => v == 1 ? [2, 3] : [1],
      );
      check(ec[1]!).isCloseTo(0.707106, 1e-4);
      check(ec[2]!).isCloseTo(0.5, 1e-4);
      check(ec[3]!).isCloseTo(0.5, 1e-4);
    });

    test('single vertex self-loop with identity strategy', () {
      final v = _Box(1);
      final ec = eigenvectorCentrality<_Box>(
        vertices: [v],
        successorsOf: (_) => [_Box(1)],
        vertexStrategy: StorageStrategy.identity(),
      );
      check(ec[v]).equals(0.0);
    });
  });
}
