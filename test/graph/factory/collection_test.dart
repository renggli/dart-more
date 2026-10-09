import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('collection', () {
    group('path', () {
      test('empty', () {
        final graph = GraphFactory<String, void>().fromPath([]);
        check(graph.vertices).isEmpty();
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<String, void>().fromPath(['a']);
        check(graph.vertices).deepEquals(['a']);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('multiple', () {
        final graph = GraphFactory<String, void>().fromPath(['a', 'b', 'c']);
        check(graph.vertices).unorderedEquals(['a', 'b', 'c']);
        check(graph.edges)
            .unorderedMatches([isEdge('a', 'b'), isEdge('b', 'c')]);
        expectInvariants(graph);
      });
    });
    group('paths', () {
      test('empty', () {
        final graph = GraphFactory<String, void>().fromPaths([]);
        check(graph.vertices).isEmpty();
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('simple', () {
        final graph = GraphFactory<String, void>().fromPaths([
          ['a'],
          ['b', 'c'],
        ]);
        check(graph.vertices).unorderedEquals(['a', 'b', 'c']);
        check(graph.edges).unorderedMatches([isEdge('b', 'c')]);
        expectInvariants(graph);
      });
      test('multiple', () {
        final graph = GraphFactory<String, void>().fromPaths([
          ['a', 'b', 'c'],
          ['d', 'b', 'e'],
        ]);
        check(graph.vertices).unorderedEquals(['a', 'b', 'c', 'd', 'e']);
        check(graph.edges).unorderedMatches([
          isEdge('a', 'b'),
          isEdge('b', 'c'),
          isEdge('d', 'b'),
          isEdge('b', 'e'),
        ]);
        expectInvariants(graph);
      });
    });
    group('predecessors', () {
      test('empty', () {
        final graph = GraphFactory<String, void>().fromPredecessors({});
        check(graph.vertices).isEmpty();
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<String, void>().fromPredecessors({
          'a': null,
          'b': [],
        });
        check(graph.vertices).unorderedEquals(['a', 'b']);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('basic', () {
        final graph = GraphFactory<String, void>().fromPredecessors({
          'a': ['b', 'c'],
        });
        check(graph.vertices).unorderedEquals(['a', 'b', 'c']);
        check(graph.edges)
            .unorderedMatches([isEdge('b', 'a'), isEdge('c', 'a')]);
        expectInvariants(graph);
      });
    });
    group('predecessor function', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().fromPredecessorFunction(
          [],
          finiteCollatzGraph,
        );
        check(graph.vertices).isEmpty();
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('basic', () {
        final graph = GraphFactory<int, void>().fromPredecessorFunction([
          5,
        ], finiteCollatzGraph);
        check(graph.vertices).unorderedEquals([1, 2, 4, 5, 8, 16]);
        check(graph.edges).unorderedMatches([
          isEdge(1, 2),
          isEdge(2, 4),
          isEdge(4, 8),
          isEdge(8, 16),
          isEdge(16, 5),
        ]);
        expectInvariants(graph);
      });
    });
    group('successors', () {
      test('empty', () {
        final graph = GraphFactory<String, void>().fromSuccessors({});
        check(graph.vertices).isEmpty();
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<String, void>().fromSuccessors({
          'a': null,
          'b': [],
        });
        check(graph.vertices).unorderedEquals(['a', 'b']);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('basic', () {
        final graph = GraphFactory<String, void>().fromSuccessors({
          'a': ['b', 'c'],
        });
        check(graph.vertices).unorderedEquals(['a', 'b', 'c']);
        check(graph.edges)
            .unorderedMatches([isEdge('a', 'b'), isEdge('a', 'c')]);
        expectInvariants(graph);
      });
    });
    group('successor function', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().fromSuccessorFunction(
          [],
          finiteCollatzGraph,
        );
        check(graph.vertices).isEmpty();
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('basic', () {
        final graph = GraphFactory<int, void>().fromSuccessorFunction([
          5,
        ], finiteCollatzGraph);
        check(graph.vertices).unorderedEquals([1, 2, 4, 5, 8, 16]);
        check(graph.edges).unorderedMatches([
          isEdge(2, 1),
          isEdge(4, 2),
          isEdge(5, 16),
          isEdge(8, 4),
          isEdge(16, 8),
        ]);
        expectInvariants(graph);
      });
    });
  });
}
