import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('atlas', () {
    final random = Random(1252);
    final factory = GraphFactory<int, void>(isDirected: false);
    test('numbered', () {
      for (var i = 0; i <= 1252; i += random.nextInt(100)) {
        final graph = factory.atlas(i);
        expectInvariants(graph);
      }
    });
    test('vertex match', () {
      final graphs = factory.atlasMatching(vertexCount: 3);
      check(graphs.map((each) => each.vertices.length))
          .every((it) => it.equals(3));
    });
    test('edge match', () {
      final graphs = factory.atlasMatching(edgeCount: 3);
      check(graphs.map((each) => each.edges.length))
          .every((it) => it.equals(6));
    });
  });
}
