import 'dart:math';

import 'package:more/graph.dart';
import 'package:test/test.dart';

import '../utils/graph.dart';

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
      expect(graphs.map((each) => each.vertices.length), everyElement(3));
    });
    test('edge match', () {
      final graphs = factory.atlasMatching(edgeCount: 3);
      expect(graphs.map((each) => each.edges.length), everyElement(6));
    });
  });
  group('collection', () {
    group('path', () {
      test('empty', () {
        final graph = GraphFactory<String, void>().fromPath([]);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<String, void>().fromPath(['a']);
        expect(graph.vertices, ['a']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('multiple', () {
        final graph = GraphFactory<String, void>().fromPath(['a', 'b', 'c']);
        expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
        expect(graph.edges, [isEdge('a', 'b'), isEdge('b', 'c')]);
        expectInvariants(graph);
      });
    });
    group('paths', () {
      test('empty', () {
        final graph = GraphFactory<String, void>().fromPaths([]);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('simple', () {
        final graph = GraphFactory<String, void>().fromPaths([
          ['a'],
          ['b', 'c'],
        ]);
        expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
        expect(graph.edges, [isEdge('b', 'c')]);
        expectInvariants(graph);
      });
      test('multiple', () {
        final graph = GraphFactory<String, void>().fromPaths([
          ['a', 'b', 'c'],
          ['d', 'b', 'e'],
        ]);
        expect(graph.vertices, unorderedEquals(['a', 'b', 'c', 'd', 'e']));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge('a', 'b'),
            isEdge('b', 'c'),
            isEdge('d', 'b'),
            isEdge('b', 'e'),
          ]),
        );
        expectInvariants(graph);
      });
    });
    group('predecessors', () {
      test('empty', () {
        final graph = GraphFactory<String, void>().fromPredecessors({});
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<String, void>().fromPredecessors({
          'a': null,
          'b': [],
        });
        expect(graph.vertices, unorderedEquals(['a', 'b']));
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('basic', () {
        final graph = GraphFactory<String, void>().fromPredecessors({
          'a': ['b', 'c'],
        });
        expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
        expect(
          graph.edges,
          unorderedEquals([isEdge('b', 'a'), isEdge('c', 'a')]),
        );
        expectInvariants(graph);
      });
    });
    group('predecessor function', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().fromPredecessorFunction(
          [],
          finiteCollatzGraph,
        );
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('basic', () {
        final graph = GraphFactory<int, void>().fromPredecessorFunction([
          5,
        ], finiteCollatzGraph);
        expect(graph.vertices, unorderedEquals([1, 2, 4, 5, 8, 16]));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge(1, 2),
            isEdge(2, 4),
            isEdge(4, 8),
            isEdge(8, 16),
            isEdge(16, 5),
          ]),
        );
        expectInvariants(graph);
      });
    });
    group('successors', () {
      test('empty', () {
        final graph = GraphFactory<String, void>().fromSuccessors({});
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<String, void>().fromSuccessors({
          'a': null,
          'b': [],
        });
        expect(graph.vertices, unorderedEquals(['a', 'b']));
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('basic', () {
        final graph = GraphFactory<String, void>().fromSuccessors({
          'a': ['b', 'c'],
        });
        expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
        expect(
          graph.edges,
          unorderedEquals([isEdge('a', 'b'), isEdge('a', 'c')]),
        );
        expectInvariants(graph);
      });
    });
    group('successor function', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().fromSuccessorFunction(
          [],
          finiteCollatzGraph,
        );
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('basic', () {
        final graph = GraphFactory<int, void>().fromSuccessorFunction([
          5,
        ], finiteCollatzGraph);
        expect(graph.vertices, unorderedEquals([1, 2, 4, 5, 8, 16]));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge(2, 1),
            isEdge(4, 2),
            isEdge(5, 16),
            isEdge(8, 4),
            isEdge(16, 8),
          ]),
        );
        expectInvariants(graph);
      });
    });
  });
  group('complete', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().complete(vertexCount: 0);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('single', () {
      final graph = GraphFactory<int, void>().complete(vertexCount: 1);
      expect(graph.vertices, [0]);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('full', () {
      final graph = GraphFactory<int, void>().complete(vertexCount: 3);
      expect(graph.vertices, unorderedEquals([0, 1, 2]));
      expect(
        graph.edges,
        unorderedEquals([
          isEdge(0, 1),
          isEdge(0, 2),
          isEdge(1, 0),
          isEdge(1, 2),
          isEdge(2, 0),
          isEdge(2, 1),
        ]),
      );
      expectInvariants(graph);
    });
  });
  group('empty', () {
    test('basic', () {
      final graph = GraphFactory<int, String>().empty();
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expect(graph.isDirected, isTrue);
      expect(graph.isUnmodifiable, isFalse);
    });
    test('unmodifiable', () {
      final graph = GraphFactory<int, String>(isDirected: false).empty();
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expect(graph.isDirected, isFalse);
      expect(graph.isUnmodifiable, isFalse);
    });
    test('unmodifiable', () {
      final graph = GraphFactory<int, String>(isUnmodifiable: true).empty();
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expect(graph.isDirected, isTrue);
      expect(graph.isUnmodifiable, isTrue);
    });
  });
  group('partite', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: []);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('path graph (p: 1, q: 1)', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [1, 1]);
      expect(graph.vertices, unorderedEquals([0, 1]));
      expect(graph.edges, [isEdge(0, 1)]);
      expectInvariants(graph);
    });
    test('claw graph (p: 1, q: 3)', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [1, 3]);
      expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
      expect(
        graph.edges,
        unorderedEquals([isEdge(0, 1), isEdge(0, 2), isEdge(0, 3)]),
      );
      expectInvariants(graph);
    });
    test('square graph (p: 2, q: 2)', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [2, 2]);
      expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
      expect(
        graph.edges,
        unorderedEquals([
          isEdge(0, 2),
          isEdge(0, 3),
          isEdge(1, 2),
          isEdge(1, 3),
        ]),
      );
      expectInvariants(graph);
    });
    test('utility graph (p: 3, q: 3)', () {
      final graph = GraphFactory<int, void>().partite(vertexCounts: [3, 3]);
      expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5]));
      expect(
        graph.edges,
        unorderedEquals([
          isEdge(0, 3),
          isEdge(0, 4),
          isEdge(0, 5),
          isEdge(1, 3),
          isEdge(1, 4),
          isEdge(1, 5),
          isEdge(2, 3),
          isEdge(2, 4),
          isEdge(2, 5),
        ]),
      );
      expectInvariants(graph);
    });
  });
  group('path', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 0);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('single', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 1);
      expect(graph.vertices, [0]);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('full', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 3);
      expect(graph.vertices, unorderedEquals([0, 1, 2]));
      expect(graph.edges, unorderedEquals([isEdge(0, 1), isEdge(1, 2)]));
      expectInvariants(graph);
    });
  });
  group('ring', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 0);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('single', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 1);
      expect(graph.vertices, [0]);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('full', () {
      final graph = GraphFactory<int, void>().ring(vertexCount: 3);
      expect(graph.vertices, unorderedEquals([0, 1, 2]));
      expect(
        graph.edges,
        unorderedEquals([isEdge(0, 1), isEdge(1, 2), isEdge(2, 0)]),
      );
      expectInvariants(graph);
    });
  });
  group('star', () {
    test('empty', () {
      final graph = GraphFactory<int, void>().star(vertexCount: 0);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('single', () {
      final graph = GraphFactory<int, void>().star(vertexCount: 1);
      expect(graph.vertices, [0]);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('full', () {
      final graph = GraphFactory<int, void>().star(vertexCount: 4);
      expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
      expect(
        graph.edges,
        unorderedEquals([isEdge(0, 1), isEdge(0, 2), isEdge(0, 3)]),
      );
      expectInvariants(graph);
    });
  });
  group('tree', () {
    group('complete', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().completeTree(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('unary', () {
        final graph = GraphFactory<int, void>().completeTree(
          vertexCount: 3,
          arity: 1,
        );
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
        expect(graph.edges, unorderedEquals([isEdge(0, 1), isEdge(1, 2)]));
        expectInvariants(graph);
      });
      test('binary', () {
        final graph = GraphFactory<int, void>().completeTree(vertexCount: 6);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5]));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge(0, 1),
            isEdge(0, 2),
            isEdge(1, 3),
            isEdge(1, 4),
            isEdge(2, 5),
          ]),
        );
        expectInvariants(graph);
      });
      test('ternary', () {
        final graph = GraphFactory<int, void>().completeTree(
          vertexCount: 7,
          arity: 3,
        );
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5, 6]));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge(0, 1),
            isEdge(0, 2),
            isEdge(0, 3),
            isEdge(1, 4),
            isEdge(1, 5),
            isEdge(1, 6),
          ]),
        );
        expectInvariants(graph);
      });
    });
    group('perfect', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().prefectTree(height: 0);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('unary', () {
        final graph = GraphFactory<int, void>().prefectTree(
          height: 2,
          arity: 1,
        );
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
        expect(graph.edges, unorderedEquals([isEdge(0, 1), isEdge(1, 2)]));
        expectInvariants(graph);
      });
      test('binary', () {
        final graph = GraphFactory<int, void>().prefectTree(height: 2);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5, 6]));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge(0, 1),
            isEdge(0, 2),
            isEdge(1, 3),
            isEdge(1, 4),
            isEdge(2, 5),
            isEdge(2, 6),
          ]),
        );
        expectInvariants(graph);
      });
      test('ternary', () {
        final graph = GraphFactory<int, void>().prefectTree(
          height: 1,
          arity: 3,
        );
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
        expect(
          graph.edges,
          unorderedEquals([isEdge(0, 1), isEdge(0, 2), isEdge(0, 3)]),
        );
        expectInvariants(graph);
      });
    });
    group('random', () {
      group('Erdős–Rényi', () {
        test('empty', () {
          final graph = GraphFactory<int, void>().randomErdosRenyi(
            vertexCount: 3,
            probability: 0.0,
          );
          expect(graph.vertices, hasLength(3));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('complete', () {
          final graph = GraphFactory<int, void>().randomErdosRenyi(
            vertexCount: 3,
            probability: 1.0,
          );
          expect(graph.vertices, hasLength(3));
          expect(graph.edges, hasLength(6));
          expectInvariants(graph);
        });
        test('directed', () {
          final graph = GraphFactory<int, void>(
            isDirected: true,
            random: Random(235711),
          ).randomErdosRenyi(vertexCount: 10, probability: 0.5);
          expect(graph.isDirected, isTrue);
          expect(graph.vertices, hasLength(10));
          expect(graph.edges.length, allOf(greaterThan(40), lessThan(60)));
          expectInvariants(graph);
        });
        test('undirected', () {
          final graph = GraphFactory<int, void>(
            isDirected: false,
            random: Random(131719),
          ).randomErdosRenyi(vertexCount: 10, probability: 0.5);
          expect(graph.isDirected, isFalse);
          expect(graph.vertices, hasLength(10));
          expect(graph.edges.length, allOf(greaterThan(40), lessThan(60)));
          expectInvariants(graph);
        });
      });
    });
  });
}
