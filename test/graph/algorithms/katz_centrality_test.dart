import 'dart:math' as math;

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('graph extension', () {
    test('star graph katz centrality ranks center highest', () {
      final star = GraphFactory<int, void>(isDirected: false)
          .star(vertexCount: 5);
      final scores = star.katzCentrality(alpha: 0.1);
      final centerScore = scores[0]!;
      for (var i = 1; i < 5; i++) {
        check(centerScore > scores[i]!).isTrue;
      }
    });

    test('empty graph returns empty map', () {
      final empty = Graph<int, void>(isDirected: true);
      check(empty.katzCentrality()).isEmpty;
    });

    test('directed chain matches exact unnormalized ratio', () {
      // 0 -> 1 -> 2, alpha = 0.5, beta = 1.0:
      // raw scores: x0 = 1.0, x1 = 1.5, x2 = 1.75.
      // Normalized by L2 norm sqrt(1 + 2.25 + 3.0625) = sqrt(6.3125).
      final graph = Graph<int, void>(isDirected: true)
        ..addEdge(0, 1)
        ..addEdge(1, 2);
      final scores = graph.katzCentrality(alpha: 0.5, beta: 1.0);
      final norm = math.sqrt(1.0 + 1.5 * 1.5 + 1.75 * 1.75);
      check(scores[0]!).isCloseTo(1.0 / norm, 1e-6);
      check(scores[1]!).isCloseTo(1.5 / norm, 1e-6);
      check(scores[2]!).isCloseTo(1.75 / norm, 1e-6);
    });
  });

  group('standalone', () {
    test('standalone katzCentrality', () {
      final scores = katzCentrality<int>(
        vertices: [0, 1],
        predecessorsOf: (v) => v == 1 ? [0] : const [],
        alpha: 0.2,
        beta: 1.0,
      );
      final norm = math.sqrt(1.0 + 1.2 * 1.2);
      check(scores[0]!).isCloseTo(1.0 / norm, 1e-6);
      check(scores[1]!).isCloseTo(1.2 / norm, 1e-6);
    });
  });
}
