import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('forwarding', () {
    test('directed', () {
      final base = Graph<String, int>(isDirected: true);
      final graph = ForwardingGraph<String, int>(base);
      check(graph.isDirected).isTrue();
      check(graph.isUnmodifiable).isFalse();
      check(graph.vertexStrategy).isNotNull();
      graph.addVertex('a');
      graph.addEdge('b', 'c', value: 42);
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(['a', 'b', 'c']);
      check(graph.edges)
          .unorderedMatches([isEdge('b', 'c', value: 42, isDirected: true)]);
      check(graph.edgesOf('b'))
          .unorderedMatches([isEdge('b', 'c', value: 42, isDirected: true)]);
      check(graph.incomingEdgesOf('c'))
          .unorderedMatches([isEdge('b', 'c', value: 42, isDirected: true)]);
      check(graph.outgoingEdgesOf('b'))
          .unorderedMatches([isEdge('b', 'c', value: 42, isDirected: true)]);
      check(graph.getEdge('b', 'c'))
          .isNotNull()
          .which(isEdge('b', 'c', value: 42, isDirected: true));
      check(graph.neighboursOf('b')).deepEquals(['c']);
      check(graph.predecessorsOf('c')).deepEquals(['b']);
      check(graph.successorsOf('b')).deepEquals(['c']);
      graph.removeEdge('b', 'c');
      graph.removeVertex('a');
    });
    test('undirected', () {
      final base = Graph<String, int>(isDirected: false);
      final graph = ForwardingGraph<String, int>(base);
      check(graph.isDirected).isFalse();
      check(graph.isUnmodifiable).isFalse();
      check(graph.vertexStrategy).isNotNull();
      graph.addVertex('a');
      graph.addEdge('b', 'c', value: 42);
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(['a', 'b', 'c']);
      check(graph.edges).unorderedMatches([
        isEdge('b', 'c', value: 42, isDirected: false),
        isEdge('c', 'b', value: 42, isDirected: false),
      ]);
      check(graph.edgesOf('b'))
          .unorderedMatches([isEdge('b', 'c', value: 42, isDirected: false)]);
      check(graph.incomingEdgesOf('c'))
          .unorderedMatches([isEdge('b', 'c', value: 42, isDirected: false)]);
      check(graph.outgoingEdgesOf('b'))
          .unorderedMatches([isEdge('b', 'c', value: 42, isDirected: false)]);
      check(graph.getEdge('b', 'c'))
          .isNotNull()
          .which(isEdge('b', 'c', value: 42, isDirected: false));
      check(graph.neighboursOf('b')).deepEquals(['c']);
      check(graph.predecessorsOf('c')).deepEquals(['b']);
      check(graph.successorsOf('b')).deepEquals(['c']);
      graph.removeEdge('b', 'c');
      graph.removeVertex('a');
    });
  });
}
