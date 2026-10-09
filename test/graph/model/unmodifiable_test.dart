import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('unmodifiable', () {
    test('empty', () {
      final graph = Graph<String, int>(isDirected: true);
      check(graph.isUnmodifiable).isFalse();
      final unmodifiable = graph.unmodifiable;
      check(unmodifiable.isUnmodifiable).isTrue();
      check(unmodifiable.unmodifiable).identicalTo(unmodifiable);
      expectInvariants(unmodifiable);
    });
    test('delegates', () {
      final graph = Graph<String, int>(isDirected: true);
      graph.addEdge('a', 'b', value: 42);
      final unmodifiable = graph.unmodifiable;
      check(unmodifiable.neighboursOf('a')).deepEquals(['b']);
      check(unmodifiable.predecessorsOf('b')).deepEquals(['a']);
      check(unmodifiable.successorsOf('a')).deepEquals(['b']);
      check(unmodifiable.edgesOf('a'))
          .unorderedMatches([isEdge('a', 'b', value: 42)]);
      check(unmodifiable.incomingEdgesOf('b'))
          .unorderedMatches([isEdge('a', 'b', value: 42)]);
      check(unmodifiable.outgoingEdgesOf('a'))
          .unorderedMatches([isEdge('a', 'b', value: 42)]);
      check(unmodifiable.getEdge('a', 'b'))
          .isNotNull()
          .which(isEdge('a', 'b', value: 42));
    });
    test('errors', () {
      final graph = Graph<String, void>(isDirected: true).unmodifiable;
      check(() => graph.addVertex('a')).throws<UnsupportedError>();
      check(() => graph.addEdge('a', 'b')).throws<UnsupportedError>();
      check(() => graph.removeVertex('a')).throws<UnsupportedError>();
      check(() => graph.removeEdge('a', 'b')).throws<UnsupportedError>();
      expectInvariants(graph);
    });
  });
}
