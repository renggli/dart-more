import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('reversed', () {
    test('empty', () {
      final graph = Graph<String, int>(isDirected: true).reversed;
      check(graph.isDirected).isTrue();
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
      expectInvariants(graph);
    });
    test('reversing directed', () {
      final graph = Graph<String, void>(isDirected: true);
      graph.addEdge('a', 'b');
      final reversedGraph = graph.reversed;
      check(reversedGraph.reversed).identicalTo(graph);
    });
    test('reversing undirected', () {
      final graph = Graph<String, void>(isDirected: false);
      graph.addEdge('a', 'b');
      final reversedGraph = graph.reversed;
      check(reversedGraph).identicalTo(graph);
    });
    group('modifying', () {
      test('add vertex', () {
        final graph = Graph<String, int>(isDirected: true).reversed;
        graph.addVertex('Hello');
        check(graph.vertices).deepEquals(['Hello']);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('add vertices', () {
        final graph = Graph<String, int>(isDirected: true).reversed;
        graph.addVertices(['Hello', 'World']);
        check(graph.vertices).deepEquals(['Hello', 'World']);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('remove vertex', () {
        final graph = Graph<String, int>(isDirected: true).reversed;
        graph.addVertex('Hello');
        graph.removeVertex('Hello');
        check(graph.vertices).isEmpty();
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('add edge', () {
        final graph = Graph<String, int>(isDirected: true).reversed;
        graph.addEdge('Hello', 'World', value: 42);
        check(graph.vertices).unorderedEquals(['Hello', 'World']);
        check(graph.edges).unorderedMatches([
          isEdge('Hello', 'World', value: 42, isDirected: true),
        ]);
        check(graph.edges.single.value).equals(42);
        expectInvariants(graph);
      });
      test('add self-edge', () {
        final graph = Graph<String, int>(isDirected: true).reversed;
        graph.addEdge('Myself', 'Myself', value: 42);
        check(graph.vertices).unorderedEquals(['Myself']);
        check(graph.edges).unorderedMatches([
          isEdge('Myself', 'Myself', value: 42, isDirected: true),
        ]);
        expectInvariants(graph);
      });
      test('put edge', () {
        final graph = Graph<String, List<int>>(isDirected: true).reversed;
        graph.putEdge('a', 'b', () => []).add(1);
        graph.putEdge('b', 'a', () => []).add(2);
        check(graph.vertices).unorderedEquals(['a', 'b']);
        check(graph.edges).unorderedMatches([
          isEdge('a', 'b', value: [1], isDirected: true),
          isEdge('b', 'a', value: [2], isDirected: true),
        ]);
        expectInvariants(graph);
      });
      test('remove edge', () {
        final graph = Graph<String, void>(isDirected: true).reversed;
        graph.addEdge('Hello', 'World');
        graph.removeEdge('Hello', 'World');
        check(graph.vertices).unorderedEquals(['Hello', 'World']);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('add edge, remove first vertex', () {
        final graph = Graph<String, void>(isDirected: true).reversed;
        graph.addEdge('Hello', 'World');
        graph.removeVertex('Hello');
        check(graph.vertices).deepEquals(['World']);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('add edge, remove second vertex', () {
        final graph = Graph<String, void>(isDirected: true).reversed;
        graph.addEdge('Hello', 'World');
        graph.removeVertex('World');
        check(graph.vertices).deepEquals(['Hello']);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
    });
    group('querying', () {
      final directed = Graph<int, String>(isDirected: true)
        ..addEdge(0, 1, value: 'a')
        ..addEdge(1, 2, value: 'b');
      final graph = directed.reversed;
      test('invariants', () {
        expectInvariants(graph);
      });
      test('vertices', () {
        check(graph.vertices).unorderedEquals([0, 1, 2]);
      });
      test('edges', () {
        check(graph.edges).unorderedMatches([
          isEdge(1, 0, value: 'a', isDirected: true),
          isEdge(2, 1, value: 'b', isDirected: true),
        ]);
      });
      test('edgesOf', () {
        check(graph.edgesOf(0))
            .unorderedMatches([isEdge(1, 0, value: 'a', isDirected: true)]);
        check(graph.edgesOf(1)).unorderedMatches([
          isEdge(1, 0, value: 'a', isDirected: true),
          isEdge(2, 1, value: 'b', isDirected: true),
        ]);
        check(graph.edgesOf(2))
            .unorderedMatches([isEdge(2, 1, value: 'b', isDirected: true)]);
      });
      test('incomingEdgesOf', () {
        check(graph.incomingEdgesOf(0))
            .unorderedMatches([isEdge(1, 0, value: 'a', isDirected: true)]);
        check(graph.incomingEdgesOf(1))
            .unorderedMatches([isEdge(2, 1, value: 'b', isDirected: true)]);
        check(graph.incomingEdgesOf(2)).isEmpty();
      });
      test('outgoingEdgesOf', () {
        check(graph.outgoingEdgesOf(0)).isEmpty();
        check(graph.outgoingEdgesOf(1))
            .unorderedMatches([isEdge(1, 0, value: 'a', isDirected: true)]);
        check(graph.outgoingEdgesOf(2))
            .unorderedMatches([isEdge(2, 1, value: 'b', isDirected: true)]);
      });
      test('getEdge', () {
        check(graph.getEdge(0, 1)).isNull();
        check(graph.getEdge(1, 0))
            .isNotNull()
            .which(isEdge(1, 0, value: 'a', isDirected: true));
        check(graph.getEdge(1, 2)).isNull();
        check(graph.getEdge(2, 1))
            .isNotNull()
            .which(isEdge(2, 1, value: 'b', isDirected: true));
        check(graph.getEdge(0, 2)).isNull();
        check(graph.getEdge(2, 0)).isNull();
      });
      test('neighboursOf', () {
        check(graph.neighboursOf(0)).deepEquals([1]);
        check(graph.neighboursOf(1)).unorderedEquals([0, 2]);
        check(graph.neighboursOf(2)).deepEquals([1]);
      });
      test('predecessorsOf', () {
        check(graph.predecessorsOf(0)).deepEquals([1]);
        check(graph.predecessorsOf(1)).deepEquals([2]);
        check(graph.predecessorsOf(2)).isEmpty();
      });
      test('successorsOf', () {
        check(graph.successorsOf(0)).isEmpty();
        check(graph.successorsOf(1)).deepEquals([0]);
        check(graph.successorsOf(2)).deepEquals([1]);
      });
    });
  });
}
