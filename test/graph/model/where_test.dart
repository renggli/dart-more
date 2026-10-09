import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('where', () {
    test('vertex predicate on directed graph', () {
      final base = Graph<String, void>(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(vertexPredicate: (vertex) => vertex != 'b');
      check(graph.isDirected).isTrue();
      check(graph.vertexStrategy).isNotNull();
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(['a', 'c']);
      check(graph.edges).unorderedMatches([isEdge('c', 'a')]);
      check(graph.edgesOf('a')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.edgesOf('b')).isEmpty();
      check(graph.edgesOf('c')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.incomingEdgesOf('a')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.incomingEdgesOf('b')).isEmpty();
      check(graph.incomingEdgesOf('c')).isEmpty();
      check(graph.outgoingEdgesOf('a')).isEmpty();
      check(graph.outgoingEdgesOf('b')).isEmpty();
      check(graph.outgoingEdgesOf('c')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.getEdge('a', 'b')).isNull();
      check(graph.getEdge('b', 'c')).isNull();
      check(graph.getEdge('c', 'a')).isNotNull().which(isEdge('c', 'a'));
      check(graph.neighboursOf('a')).deepEquals(['c']);
      check(graph.neighboursOf('b')).isEmpty();
      check(graph.neighboursOf('c')).deepEquals(['a']);
      check(graph.predecessorsOf('a')).deepEquals(['c']);
      check(graph.predecessorsOf('b')).isEmpty();
      check(graph.predecessorsOf('c')).isEmpty();
      check(graph.successorsOf('a')).isEmpty();
      check(graph.successorsOf('b')).isEmpty();
      check(graph.successorsOf('c')).deepEquals(['a']);
    });
    test('vertex predicate on undirected graph', () {
      final base = Graph<String, void>(isDirected: false);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(vertexPredicate: (vertex) => vertex != 'b');
      check(graph.isDirected).isFalse();
      check(graph.vertexStrategy).isNotNull();
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(['a', 'c']);
      check(graph.edges).unorderedMatches([isEdge('a', 'c'), isEdge('c', 'a')]);
      check(graph.edgesOf('a')).unorderedMatches([isEdge('a', 'c')]);
      check(graph.edgesOf('b')).isEmpty();
      check(graph.edgesOf('c')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.incomingEdgesOf('a')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.incomingEdgesOf('b')).isEmpty();
      check(graph.incomingEdgesOf('c')).unorderedMatches([isEdge('a', 'c')]);
      check(graph.outgoingEdgesOf('a')).unorderedMatches([isEdge('a', 'c')]);
      check(graph.outgoingEdgesOf('b')).isEmpty();
      check(graph.outgoingEdgesOf('c')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.getEdge('a', 'b')).isNull();
      check(graph.getEdge('a', 'c')).isNotNull().which(isEdge('a', 'c'));
      check(graph.getEdge('b', 'c')).isNull();
      check(graph.getEdge('b', 'a')).isNull();
      check(graph.getEdge('c', 'a')).isNotNull().which(isEdge('c', 'a'));
      check(graph.getEdge('c', 'b')).isNull();
      check(graph.neighboursOf('a')).deepEquals(['c']);
      check(graph.neighboursOf('b')).isEmpty();
      check(graph.neighboursOf('c')).deepEquals(['a']);
      check(graph.predecessorsOf('a')).deepEquals(['c']);
      check(graph.predecessorsOf('b')).isEmpty();
      check(graph.predecessorsOf('c')).deepEquals(['a']);
      check(graph.successorsOf('a')).deepEquals(['c']);
      check(graph.successorsOf('b')).isEmpty();
      check(graph.successorsOf('c')).deepEquals(['a']);
    });
    test('vertex predicate filtering nothing', () {
      final base = Graph<String, void>(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(vertexPredicate: (vertex) => true);
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(base.vertices);
      check(graph.edges).unorderedEquals(base.edges);
    });
    test('vertex predicate filtering everything', () {
      final base = Graph<String, void>(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(vertexPredicate: (vertex) => false);
      expectInvariants(graph);
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
    });
    test('edge predicate on directed graph', () {
      final base = Graph<String, void>(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(
        edgePredicate: (edge) => edge.source != 'b' && edge.target != 'b',
      );
      check(graph.isDirected).isTrue();
      check(graph.vertexStrategy).isNotNull();
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(base.vertices);
      check(graph.edges).unorderedMatches([isEdge('c', 'a')]);
      check(graph.edgesOf('a')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.edgesOf('b')).isEmpty();
      check(graph.edgesOf('c')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.incomingEdgesOf('a')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.incomingEdgesOf('b')).isEmpty();
      check(graph.incomingEdgesOf('c')).isEmpty();
      check(graph.outgoingEdgesOf('a')).isEmpty();
      check(graph.outgoingEdgesOf('b')).isEmpty();
      check(graph.outgoingEdgesOf('c')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.getEdge('a', 'b')).isNull();
      check(graph.getEdge('b', 'c')).isNull();
      check(graph.getEdge('c', 'a')).isNotNull().which(isEdge('c', 'a'));
      check(graph.neighboursOf('a')).deepEquals(['c']);
      check(graph.neighboursOf('b')).isEmpty();
      check(graph.neighboursOf('c')).deepEquals(['a']);
      check(graph.predecessorsOf('a')).deepEquals(['c']);
      check(graph.predecessorsOf('b')).isEmpty();
      check(graph.predecessorsOf('c')).isEmpty();
      check(graph.successorsOf('a')).isEmpty();
      check(graph.successorsOf('b')).isEmpty();
      check(graph.successorsOf('c')).deepEquals(['a']);
    });
    test('edge predicate on undirected graph', () {
      final base = Graph<String, void>(isDirected: false);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(
        edgePredicate: (edge) => edge.source != 'b' && edge.target != 'b',
      );
      check(graph.isDirected).isFalse();
      check(graph.vertexStrategy).isNotNull();
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(base.vertices);
      check(graph.edges).unorderedMatches([isEdge('a', 'c'), isEdge('c', 'a')]);
      check(graph.edgesOf('a')).unorderedMatches([isEdge('a', 'c')]);
      check(graph.edgesOf('b')).isEmpty();
      check(graph.edgesOf('c')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.incomingEdgesOf('a')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.incomingEdgesOf('b')).isEmpty();
      check(graph.incomingEdgesOf('c')).unorderedMatches([isEdge('a', 'c')]);
      check(graph.outgoingEdgesOf('a')).unorderedMatches([isEdge('a', 'c')]);
      check(graph.outgoingEdgesOf('b')).isEmpty();
      check(graph.outgoingEdgesOf('c')).unorderedMatches([isEdge('c', 'a')]);
      check(graph.getEdge('a', 'b')).isNull();
      check(graph.getEdge('a', 'c')).isNotNull().which(isEdge('a', 'c'));
      check(graph.getEdge('b', 'c')).isNull();
      check(graph.getEdge('b', 'a')).isNull();
      check(graph.getEdge('c', 'a')).isNotNull().which(isEdge('c', 'a'));
      check(graph.getEdge('c', 'b')).isNull();
      check(graph.neighboursOf('a')).deepEquals(['c']);
      check(graph.neighboursOf('b')).isEmpty();
      check(graph.neighboursOf('c')).deepEquals(['a']);
      check(graph.predecessorsOf('a')).deepEquals(['c']);
      check(graph.predecessorsOf('b')).isEmpty();
      check(graph.predecessorsOf('c')).deepEquals(['a']);
      check(graph.successorsOf('a')).deepEquals(['c']);
      check(graph.successorsOf('b')).isEmpty();
      check(graph.successorsOf('c')).deepEquals(['a']);
    });
    test('edge predicate filtering nothing', () {
      final base = Graph<String, void>(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(edgePredicate: (vertex) => true);
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(base.vertices);
      check(graph.edges).unorderedEquals(base.edges);
    });
    test('edge predicate filtering everything', () {
      final base = Graph<String, void>(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(edgePredicate: (vertex) => false);
      expectInvariants(graph);
      check(graph.vertices).unorderedEquals(base.vertices);
      check(graph.edges).isEmpty();
    });
    test('no predicates', () {
      final base = Graph<int, int>(isDirected: true);
      final graph = base.where();
      check(graph).identicalTo(base);
    });
  });
}
