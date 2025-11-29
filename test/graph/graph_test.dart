import 'package:more/graph.dart';
import 'package:test/test.dart';

import '../utils/graph.dart';

void main() {
  group('directed', () {
    test('empty', () {
      final graph = Graph<String, int>.create(isDirected: true);
      expect(graph.isDirected, isTrue);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    group('modifying', () {
      test('add vertex', () {
        final graph = Graph<String, int>.create(isDirected: true);
        graph.addVertex('Hello');
        expect(graph.vertices, ['Hello']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add vertices', () {
        final graph = Graph<String, int>.create(isDirected: true);
        graph.addVertices(['Hello', 'World']);
        expect(graph.vertices, ['Hello', 'World']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('remove vertex', () {
        final graph = Graph<String, int>.create(isDirected: true);
        graph.addVertex('Hello');
        graph.removeVertex('Hello');
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge', () {
        final graph = Graph<String, int>.create(isDirected: true);
        graph.addEdge('Hello', 'World', value: 42);
        expect(graph.vertices, unorderedEquals(['Hello', 'World']));
        expect(graph.edges, [
          isEdge('Hello', 'World', value: 42, isDirected: true),
        ]);
        expect(graph.edges.single.value, 42);
        expectInvariants(graph);
      });
      test('add self-edge', () {
        final graph = Graph<String, int>.create(isDirected: true);
        graph.addEdge('Myself', 'Myself', value: 42);
        expect(graph.vertices, unorderedEquals(['Myself']));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge('Myself', 'Myself', value: 42, isDirected: true),
          ]),
        );
        expectInvariants(graph);
      });
      test('put edge', () {
        final graph = Graph<String, List<int>>.create(isDirected: true);
        graph.putEdge('a', 'b', () => []).add(1);
        graph.putEdge('b', 'a', () => []).add(2);
        expect(graph.vertices, unorderedEquals(['a', 'b']));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge('a', 'b', value: [1], isDirected: true),
            isEdge('b', 'a', value: [2], isDirected: true),
          ]),
        );
        expectInvariants(graph);
      });
      test('remove edge', () {
        final graph = Graph<String, void>.create(isDirected: true);
        graph.addEdge('Hello', 'World');
        graph.removeEdge('Hello', 'World');
        expect(graph.vertices, unorderedEquals(['Hello', 'World']));
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge, remove first vertex', () {
        final graph = Graph<String, void>.create(isDirected: true);
        graph.addEdge('Hello', 'World');
        graph.removeVertex('Hello');
        expect(graph.vertices, ['World']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge, remove second vertex', () {
        final graph = Graph<String, void>.create(isDirected: true);
        graph.addEdge('Hello', 'World');
        graph.removeVertex('World');
        expect(graph.vertices, ['Hello']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
    });
    group('querying', () {
      final graph = Graph<int, String>.create(isDirected: true)
        ..addEdge(0, 1, value: 'a')
        ..addEdge(1, 2, value: 'b');
      test('invariants', () {
        expectInvariants(graph);
      });
      test('vertices', () {
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
      });
      test('edges', () {
        expect(
          graph.edges,
          unorderedEquals([
            isEdge(0, 1, value: 'a', isDirected: true),
            isEdge(1, 2, value: 'b', isDirected: true),
          ]),
        );
      });
      test('edgesOf', () {
        expect(graph.edgesOf(0), [isEdge(0, 1, value: 'a', isDirected: true)]);
        expect(
          graph.edgesOf(1),
          unorderedEquals([
            isEdge(0, 1, value: 'a', isDirected: true),
            isEdge(1, 2, value: 'b', isDirected: true),
          ]),
        );
        expect(graph.edgesOf(2), [isEdge(1, 2, value: 'b', isDirected: true)]);
      });
      test('incomingEdgesOf', () {
        expect(graph.incomingEdgesOf(0), isEmpty);
        expect(graph.incomingEdgesOf(1), [
          isEdge(0, 1, value: 'a', isDirected: true),
        ]);
        expect(graph.incomingEdgesOf(2), [
          isEdge(1, 2, value: 'b', isDirected: true),
        ]);
      });
      test('outgoingEdgesOf', () {
        expect(graph.outgoingEdgesOf(0), [
          isEdge(0, 1, value: 'a', isDirected: true),
        ]);
        expect(graph.outgoingEdgesOf(1), [
          isEdge(1, 2, value: 'b', isDirected: true),
        ]);
        expect(graph.outgoingEdgesOf(2), isEmpty);
      });
      test('getEdge', () {
        expect(graph.getEdge(0, 1), isEdge(0, 1, value: 'a', isDirected: true));
        expect(graph.getEdge(1, 0), isNull);
        expect(graph.getEdge(1, 2), isEdge(1, 2, value: 'b', isDirected: true));
        expect(graph.getEdge(2, 1), isNull);
        expect(graph.getEdge(0, 2), isNull);
        expect(graph.getEdge(2, 0), isNull);
      });
      test('neighboursOf', () {
        expect(graph.neighboursOf(0), [1]);
        expect(graph.neighboursOf(1), [0, 2]);
        expect(graph.neighboursOf(2), [1]);
      });
      test('predecessorsOf', () {
        expect(graph.predecessorsOf(0), isEmpty);
        expect(graph.predecessorsOf(1), [0]);
        expect(graph.predecessorsOf(2), [1]);
      });
      test('successorsOf', () {
        expect(graph.successorsOf(0), [1]);
        expect(graph.successorsOf(1), [2]);
        expect(graph.successorsOf(2), isEmpty);
      });
    });
  });
  group('reversed', () {
    test('empty', () {
      final graph = Graph<String, int>.create(isDirected: true).reversed;
      expect(graph.isDirected, isTrue);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    test('reversing directed', () {
      final graph = Graph<String, void>.create(isDirected: true);
      graph.addEdge('a', 'b');
      final reversedGraph = graph.reversed;
      expect(reversedGraph.reversed, same(graph));
    });
    test('reversing undirected', () {
      final graph = Graph<String, void>.create(isDirected: false);
      graph.addEdge('a', 'b');
      final reversedGraph = graph.reversed;
      expect(reversedGraph, same(graph));
    });
    group('modifying', () {
      test('add vertex', () {
        final graph = Graph<String, int>.create(isDirected: true).reversed;
        graph.addVertex('Hello');
        expect(graph.vertices, ['Hello']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add vertices', () {
        final graph = Graph<String, int>.create(isDirected: true).reversed;
        graph.addVertices(['Hello', 'World']);
        expect(graph.vertices, ['Hello', 'World']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('remove vertex', () {
        final graph = Graph<String, int>.create(isDirected: true).reversed;
        graph.addVertex('Hello');
        graph.removeVertex('Hello');
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge', () {
        final graph = Graph<String, int>.create(isDirected: true).reversed;
        graph.addEdge('Hello', 'World', value: 42);
        expect(graph.vertices, unorderedEquals(['Hello', 'World']));
        expect(graph.edges, [
          isEdge('Hello', 'World', value: 42, isDirected: true),
        ]);
        expect(graph.edges.single.value, 42);
        expectInvariants(graph);
      });
      test('add self-edge', () {
        final graph = Graph<String, int>.create(isDirected: true).reversed;
        graph.addEdge('Myself', 'Myself', value: 42);
        expect(graph.vertices, unorderedEquals(['Myself']));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge('Myself', 'Myself', value: 42, isDirected: true),
          ]),
        );
        expectInvariants(graph);
      });
      test('put edge', () {
        final graph = Graph<String, List<int>>.create(
          isDirected: true,
        ).reversed;
        graph.putEdge('a', 'b', () => []).add(1);
        graph.putEdge('b', 'a', () => []).add(2);
        expect(graph.vertices, unorderedEquals(['a', 'b']));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge('a', 'b', value: [1], isDirected: true),
            isEdge('b', 'a', value: [2], isDirected: true),
          ]),
        );
        expectInvariants(graph);
      });
      test('remove edge', () {
        final graph = Graph<String, void>.create(isDirected: true).reversed;
        graph.addEdge('Hello', 'World');
        graph.removeEdge('Hello', 'World');
        expect(graph.vertices, unorderedEquals(['Hello', 'World']));
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge, remove first vertex', () {
        final graph = Graph<String, void>.create(isDirected: true).reversed;
        graph.addEdge('Hello', 'World');
        graph.removeVertex('Hello');
        expect(graph.vertices, ['World']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge, remove second vertex', () {
        final graph = Graph<String, void>.create(isDirected: true).reversed;
        graph.addEdge('Hello', 'World');
        graph.removeVertex('World');
        expect(graph.vertices, ['Hello']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
    });
    group('querying', () {
      final directed = Graph<int, String>.create(isDirected: true)
        ..addEdge(0, 1, value: 'a')
        ..addEdge(1, 2, value: 'b');
      final graph = directed.reversed;
      test('invariants', () {
        expectInvariants(graph);
      });
      test('vertices', () {
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
      });
      test('edges', () {
        expect(
          graph.edges,
          unorderedEquals([
            isEdge(1, 0, value: 'a', isDirected: true),
            isEdge(2, 1, value: 'b', isDirected: true),
          ]),
        );
      });
      test('edgesOf', () {
        expect(graph.edgesOf(0), [isEdge(1, 0, value: 'a', isDirected: true)]);
        expect(
          graph.edgesOf(1),
          unorderedEquals([
            isEdge(1, 0, value: 'a', isDirected: true),
            isEdge(2, 1, value: 'b', isDirected: true),
          ]),
        );
        expect(graph.edgesOf(2), [isEdge(2, 1, value: 'b', isDirected: true)]);
      });
      test('incomingEdgesOf', () {
        expect(graph.incomingEdgesOf(0), [
          isEdge(1, 0, value: 'a', isDirected: true),
        ]);
        expect(graph.incomingEdgesOf(1), [
          isEdge(2, 1, value: 'b', isDirected: true),
        ]);
        expect(graph.incomingEdgesOf(2), isEmpty);
      });
      test('outgoingEdgesOf', () {
        expect(graph.outgoingEdgesOf(0), isEmpty);
        expect(graph.outgoingEdgesOf(1), [
          isEdge(1, 0, value: 'a', isDirected: true),
        ]);
        expect(graph.outgoingEdgesOf(2), [
          isEdge(2, 1, value: 'b', isDirected: true),
        ]);
      });
      test('getEdge', () {
        expect(graph.getEdge(0, 1), isNull);
        expect(graph.getEdge(1, 0), isEdge(1, 0, value: 'a', isDirected: true));
        expect(graph.getEdge(1, 2), isNull);
        expect(graph.getEdge(2, 1), isEdge(2, 1, value: 'b', isDirected: true));
        expect(graph.getEdge(0, 2), isNull);
        expect(graph.getEdge(2, 0), isNull);
      });
      test('neighboursOf', () {
        expect(graph.neighboursOf(0), [1]);
        expect(graph.neighboursOf(1), unorderedEquals([0, 2]));
        expect(graph.neighboursOf(2), [1]);
      });
      test('predecessorsOf', () {
        expect(graph.predecessorsOf(0), [1]);
        expect(graph.predecessorsOf(1), [2]);
        expect(graph.predecessorsOf(2), isEmpty);
      });
      test('successorsOf', () {
        expect(graph.successorsOf(0), isEmpty);
        expect(graph.successorsOf(1), [0]);
        expect(graph.successorsOf(2), [1]);
      });
    });
  });
  group('undirected', () {
    test('empty', () {
      final graph = Graph<String, int>.create(isDirected: false);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
      expectInvariants(graph);
    });
    group('modifying', () {
      test('add vertex', () {
        final graph = Graph<String, int>.create(isDirected: false);
        graph.addVertex('Hello');
        expect(graph.vertices, ['Hello']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add vertices', () {
        final graph = Graph<String, int>.create(isDirected: false);
        graph.addVertices(['Hello', 'World']);
        expect(graph.vertices, ['Hello', 'World']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('remove vertex', () {
        final graph = Graph<String, int>.create(isDirected: false);
        graph.addVertex('Hello');
        graph.removeVertex('Hello');
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge', () {
        final graph = Graph<String, int>.create(isDirected: false);
        graph.addEdge('Hello', 'World', value: 42);
        expect(graph.vertices, unorderedEquals(['Hello', 'World']));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge('Hello', 'World', value: 42, isDirected: false),
            isEdge('World', 'Hello', value: 42, isDirected: false),
          ]),
        );
        expectInvariants(graph);
      });
      test('add self-edge', () {
        final graph = Graph<String, int>.create(isDirected: false);
        graph.addEdge('Myself', 'Myself', value: 42);
        expect(graph.vertices, unorderedEquals(['Myself']));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge('Myself', 'Myself', value: 42, isDirected: false),
          ]),
        );
        expectInvariants(graph);
      });
      test('put edge', () {
        final graph = Graph<String, List<int>>.create(isDirected: false);
        graph.putEdge('a', 'b', () => []).add(1);
        graph.putEdge('b', 'a', () => []).add(2);
        expect(graph.vertices, unorderedEquals(['a', 'b']));
        expect(
          graph.edges,
          unorderedEquals([
            isEdge('a', 'b', value: [1, 2], isDirected: false),
            isEdge('b', 'a', value: [1, 2], isDirected: false),
          ]),
        );
        expectInvariants(graph);
      });
      test('remove edge', () {
        final graph = Graph<String, void>.create(isDirected: false);
        graph.addEdge('Hello', 'World');
        graph.removeEdge('Hello', 'World');
        expect(graph.vertices, unorderedEquals(['Hello', 'World']));
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge, remove first vertex', () {
        final graph = Graph<String, void>.create(isDirected: false);
        graph.addEdge('Hello', 'World');
        graph.removeVertex('Hello');
        expect(graph.vertices, ['World']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('add edge, remove second vertex', () {
        final graph = Graph<String, void>.create(isDirected: false);
        graph.addEdge('Hello', 'World');
        graph.removeVertex('World');
        expect(graph.vertices, ['Hello']);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
    });
    group('querying', () {
      final graph = Graph<int, String>.create(isDirected: false)
        ..addEdge(0, 1, value: 'a')
        ..addEdge(1, 2, value: 'b');
      test('invariants', () {
        expectInvariants(graph);
      });
      test('vertices', () {
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
      });
      test('edges', () {
        expect(
          graph.edges,
          unorderedEquals([
            isEdge(0, 1, value: 'a', isDirected: false),
            isEdge(1, 0, value: 'a', isDirected: false),
            isEdge(1, 2, value: 'b', isDirected: false),
            isEdge(2, 1, value: 'b', isDirected: false),
          ]),
        );
      });
      test('edgesOf', () {
        expect(graph.edgesOf(0), [isEdge(0, 1, value: 'a', isDirected: false)]);
        expect(
          graph.edgesOf(1),
          unorderedEquals([
            isEdge(1, 0, value: 'a', isDirected: false),
            isEdge(1, 2, value: 'b', isDirected: false),
          ]),
        );
        expect(graph.edgesOf(2), [isEdge(2, 1, value: 'b', isDirected: false)]);
      });
      test('incomingEdgesOf', () {
        expect(graph.incomingEdgesOf(0), [
          isEdge(1, 0, value: 'a', isDirected: false),
        ]);
        expect(
          graph.incomingEdgesOf(1),
          unorderedEquals([
            isEdge(0, 1, value: 'a', isDirected: false),
            isEdge(2, 1, value: 'b', isDirected: false),
          ]),
        );
        expect(graph.incomingEdgesOf(2), [isEdge(1, 2, value: 'b')]);
      });
      test('outgoingEdgesOf', () {
        expect(graph.outgoingEdgesOf(0), [
          isEdge(0, 1, value: 'a', isDirected: false),
        ]);
        expect(
          graph.outgoingEdgesOf(1),
          unorderedEquals([
            isEdge(1, 0, value: 'a', isDirected: false),
            isEdge(1, 2, value: 'b', isDirected: false),
          ]),
        );
        expect(graph.outgoingEdgesOf(2), [
          isEdge(2, 1, value: 'b', isDirected: false),
        ]);
      });
      test('getEdge', () {
        expect(
          graph.getEdge(0, 1),
          isEdge(0, 1, value: 'a', isDirected: false),
        );
        expect(
          graph.getEdge(1, 0),
          isEdge(1, 0, value: 'a', isDirected: false),
        );
        expect(
          graph.getEdge(1, 2),
          isEdge(1, 2, value: 'b', isDirected: false),
        );
        expect(
          graph.getEdge(2, 1),
          isEdge(2, 1, value: 'b', isDirected: false),
        );
        expect(graph.getEdge(0, 2), isNull);
        expect(graph.getEdge(2, 0), isNull);
      });
      test('neighboursOf', () {
        expect(graph.neighboursOf(0), [1]);
        expect(graph.neighboursOf(1), unorderedEquals([0, 2]));
        expect(graph.neighboursOf(2), [1]);
      });
      test('predecessorsOf', () {
        expect(graph.predecessorsOf(0), [1]);
        expect(graph.predecessorsOf(1), unorderedEquals([0, 2]));
        expect(graph.predecessorsOf(2), [1]);
      });
      test('successorsOf', () {
        expect(graph.successorsOf(0), [1]);
        expect(graph.successorsOf(1), unorderedEquals([0, 2]));
        expect(graph.successorsOf(2), [1]);
      });
    });
    test('reversed', () {
      final graph = Graph<String, int>.create(isDirected: false);
      expect(graph.reversed, same(graph));
    });
  });
  group('forwarding', () {
    test('directed', () {
      final base = Graph<String, int>.create(isDirected: true);
      final graph = ForwardingGraph<String, int>(base);
      expect(graph.isDirected, isTrue);
      expect(graph.isUnmodifiable, isFalse);
      expect(graph.vertexStrategy, isNotNull);
      graph.addVertex('a');
      graph.addEdge('b', 'c', value: 42);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
      expect(graph.edges, [isEdge('b', 'c', value: 42, isDirected: true)]);
      expect(graph.edgesOf('b'), [
        isEdge('b', 'c', value: 42, isDirected: true),
      ]);
      expect(graph.incomingEdgesOf('c'), [
        isEdge('b', 'c', value: 42, isDirected: true),
      ]);
      expect(graph.outgoingEdgesOf('b'), [
        isEdge('b', 'c', value: 42, isDirected: true),
      ]);
      expect(
        graph.getEdge('b', 'c'),
        isEdge('b', 'c', value: 42, isDirected: true),
      );
      expect(graph.neighboursOf('b'), ['c']);
      expect(graph.predecessorsOf('c'), ['b']);
      expect(graph.successorsOf('b'), ['c']);
      graph.removeEdge('b', 'c');
      graph.removeVertex('a');
    });
    test('undirected', () {
      final base = Graph<String, int>.create(isDirected: false);
      final graph = ForwardingGraph<String, int>(base);
      expect(graph.isDirected, isFalse);
      expect(graph.isUnmodifiable, isFalse);
      expect(graph.vertexStrategy, isNotNull);
      graph.addVertex('a');
      graph.addEdge('b', 'c', value: 42);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
      expect(
        graph.edges,
        unorderedEquals([
          isEdge('b', 'c', value: 42, isDirected: false),
          isEdge('c', 'b', value: 42, isDirected: false),
        ]),
      );
      expect(graph.edgesOf('b'), [
        isEdge('b', 'c', value: 42, isDirected: false),
      ]);
      expect(graph.incomingEdgesOf('c'), [
        isEdge('b', 'c', value: 42, isDirected: false),
      ]);
      expect(graph.outgoingEdgesOf('b'), [
        isEdge('b', 'c', value: 42, isDirected: false),
      ]);
      expect(
        graph.getEdge('b', 'c'),
        isEdge('b', 'c', value: 42, isDirected: false),
      );
      expect(graph.neighboursOf('b'), ['c']);
      expect(graph.predecessorsOf('c'), ['b']);
      expect(graph.successorsOf('b'), ['c']);
      graph.removeEdge('b', 'c');
      graph.removeVertex('a');
    });
  });
  group('unmodifiable', () {
    test('empty', () {
      final graph = Graph<String, int>.create(isDirected: true);
      expect(graph.isUnmodifiable, isFalse);
      final unmodifiable = graph.unmodifiable;
      expect(unmodifiable.isUnmodifiable, isTrue);
      expect(unmodifiable.unmodifiable, same(unmodifiable));
      expectInvariants(unmodifiable);
    });
    test('delegates', () {
      final graph = Graph<String, int>.create(isDirected: true);
      graph.addEdge('a', 'b', value: 42);
      final unmodifiable = graph.unmodifiable;
      expect(unmodifiable.neighboursOf('a'), ['b']);
      expect(unmodifiable.predecessorsOf('b'), ['a']);
      expect(unmodifiable.successorsOf('a'), ['b']);
      expect(unmodifiable.edgesOf('a'), [isEdge('a', 'b', value: 42)]);
      expect(unmodifiable.incomingEdgesOf('b'), [isEdge('a', 'b', value: 42)]);
      expect(unmodifiable.outgoingEdgesOf('a'), [isEdge('a', 'b', value: 42)]);
      expect(unmodifiable.getEdge('a', 'b'), isEdge('a', 'b', value: 42));
    });
    test('errors', () {
      final graph = Graph<String, void>.create(isDirected: true).unmodifiable;
      expect(() => graph.addVertex('a'), throwsUnsupportedError);
      expect(() => graph.addEdge('a', 'b'), throwsUnsupportedError);
      expect(() => graph.removeVertex('a'), throwsUnsupportedError);
      expect(() => graph.removeEdge('a', 'b'), throwsUnsupportedError);
      expectInvariants(graph);
    });
  });
  group('where', () {
    test('vertex predicate on directed graph', () {
      final base = Graph<String, void>.create(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(vertexPredicate: (vertex) => vertex != 'b');
      expect(graph.isDirected, isTrue);
      expect(graph.vertexStrategy, isNotNull);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(['a', 'c']));
      expect(graph.edges, unorderedEquals([isEdge('c', 'a')]));
      expect(graph.edgesOf('a'), [isEdge('c', 'a')]);
      expect(graph.edgesOf('b'), isEmpty);
      expect(graph.edgesOf('c'), [isEdge('c', 'a')]);
      expect(graph.incomingEdgesOf('a'), [isEdge('c', 'a')]);
      expect(graph.incomingEdgesOf('b'), isEmpty);
      expect(graph.incomingEdgesOf('c'), isEmpty);
      expect(graph.outgoingEdgesOf('a'), isEmpty);
      expect(graph.outgoingEdgesOf('b'), isEmpty);
      expect(graph.outgoingEdgesOf('c'), [isEdge('c', 'a')]);
      expect(graph.getEdge('a', 'b'), isNull);
      expect(graph.getEdge('b', 'c'), isNull);
      expect(graph.getEdge('c', 'a'), isEdge('c', 'a'));
      expect(graph.neighboursOf('a'), ['c']);
      expect(graph.neighboursOf('b'), isEmpty);
      expect(graph.neighboursOf('c'), ['a']);
      expect(graph.predecessorsOf('a'), ['c']);
      expect(graph.predecessorsOf('b'), isEmpty);
      expect(graph.predecessorsOf('c'), isEmpty);
      expect(graph.successorsOf('a'), isEmpty);
      expect(graph.successorsOf('b'), isEmpty);
      expect(graph.successorsOf('c'), ['a']);
    });
    test('vertex predicate on undirected graph', () {
      final base = Graph<String, void>.create(isDirected: false);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(vertexPredicate: (vertex) => vertex != 'b');
      expect(graph.isDirected, isFalse);
      expect(graph.vertexStrategy, isNotNull);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(['a', 'c']));
      expect(
        graph.edges,
        unorderedEquals([isEdge('a', 'c'), isEdge('c', 'a')]),
      );
      expect(graph.edgesOf('a'), [isEdge('a', 'c')]);
      expect(graph.edgesOf('b'), isEmpty);
      expect(graph.edgesOf('c'), [isEdge('c', 'a')]);
      expect(graph.incomingEdgesOf('a'), [isEdge('c', 'a')]);
      expect(graph.incomingEdgesOf('b'), isEmpty);
      expect(graph.incomingEdgesOf('c'), [isEdge('a', 'c')]);
      expect(graph.outgoingEdgesOf('a'), [isEdge('a', 'c')]);
      expect(graph.outgoingEdgesOf('b'), isEmpty);
      expect(graph.outgoingEdgesOf('c'), [isEdge('c', 'a')]);
      expect(graph.getEdge('a', 'b'), isNull);
      expect(graph.getEdge('a', 'c'), isEdge('a', 'c'));
      expect(graph.getEdge('b', 'c'), isNull);
      expect(graph.getEdge('b', 'a'), isNull);
      expect(graph.getEdge('c', 'a'), isEdge('c', 'a'));
      expect(graph.getEdge('c', 'b'), isNull);
      expect(graph.neighboursOf('a'), ['c']);
      expect(graph.neighboursOf('b'), isEmpty);
      expect(graph.neighboursOf('c'), ['a']);
      expect(graph.predecessorsOf('a'), ['c']);
      expect(graph.predecessorsOf('b'), isEmpty);
      expect(graph.predecessorsOf('c'), ['a']);
      expect(graph.successorsOf('a'), ['c']);
      expect(graph.successorsOf('b'), isEmpty);
      expect(graph.successorsOf('c'), ['a']);
    });
    test('vertex predicate filtering nothing', () {
      final base = Graph<String, void>.create(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(vertexPredicate: (vertex) => true);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(base.vertices));
      expect(graph.edges, unorderedEquals(base.edges));
    });
    test('vertex predicate filtering everything', () {
      final base = Graph<String, void>.create(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(vertexPredicate: (vertex) => false);
      expectInvariants(graph);
      expect(graph.vertices, isEmpty);
      expect(graph.edges, isEmpty);
    });
    test('edge predicate on directed graph', () {
      final base = Graph<String, void>.create(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(
        edgePredicate: (edge) => edge.source != 'b' && edge.target != 'b',
      );
      expect(graph.isDirected, isTrue);
      expect(graph.vertexStrategy, isNotNull);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(base.vertices));
      expect(graph.edges, [isEdge('c', 'a')]);
      expect(graph.edgesOf('a'), [isEdge('c', 'a')]);
      expect(graph.edgesOf('b'), isEmpty);
      expect(graph.edgesOf('c'), [isEdge('c', 'a')]);
      expect(graph.incomingEdgesOf('a'), [isEdge('c', 'a')]);
      expect(graph.incomingEdgesOf('b'), isEmpty);
      expect(graph.incomingEdgesOf('c'), isEmpty);
      expect(graph.outgoingEdgesOf('a'), isEmpty);
      expect(graph.outgoingEdgesOf('b'), isEmpty);
      expect(graph.outgoingEdgesOf('c'), [isEdge('c', 'a')]);
      expect(graph.getEdge('a', 'b'), isNull);
      expect(graph.getEdge('b', 'c'), isNull);
      expect(graph.getEdge('c', 'a'), isEdge('c', 'a'));
      expect(graph.neighboursOf('a'), ['c']);
      expect(graph.neighboursOf('b'), isEmpty);
      expect(graph.neighboursOf('c'), ['a']);
      expect(graph.predecessorsOf('a'), ['c']);
      expect(graph.predecessorsOf('b'), isEmpty);
      expect(graph.predecessorsOf('c'), isEmpty);
      expect(graph.successorsOf('a'), isEmpty);
      expect(graph.successorsOf('b'), isEmpty);
      expect(graph.successorsOf('c'), ['a']);
    });
    test('edge predicate on undirected graph', () {
      final base = Graph<String, void>.create(isDirected: false);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(
        edgePredicate: (edge) => edge.source != 'b' && edge.target != 'b',
      );
      expect(graph.isDirected, isFalse);
      expect(graph.vertexStrategy, isNotNull);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(base.vertices));
      expect(
        graph.edges,
        unorderedEquals([isEdge('a', 'c'), isEdge('c', 'a')]),
      );
      expect(graph.edgesOf('a'), [isEdge('a', 'c')]);
      expect(graph.edgesOf('b'), isEmpty);
      expect(graph.edgesOf('c'), [isEdge('c', 'a')]);
      expect(graph.incomingEdgesOf('a'), [isEdge('c', 'a')]);
      expect(graph.incomingEdgesOf('b'), isEmpty);
      expect(graph.incomingEdgesOf('c'), [isEdge('a', 'c')]);
      expect(graph.outgoingEdgesOf('a'), [isEdge('a', 'c')]);
      expect(graph.outgoingEdgesOf('b'), isEmpty);
      expect(graph.outgoingEdgesOf('c'), [isEdge('c', 'a')]);
      expect(graph.getEdge('a', 'b'), isNull);
      expect(graph.getEdge('a', 'c'), isEdge('a', 'c'));
      expect(graph.getEdge('b', 'c'), isNull);
      expect(graph.getEdge('b', 'a'), isNull);
      expect(graph.getEdge('c', 'a'), isEdge('c', 'a'));
      expect(graph.getEdge('c', 'b'), isNull);
      expect(graph.neighboursOf('a'), ['c']);
      expect(graph.neighboursOf('b'), isEmpty);
      expect(graph.neighboursOf('c'), ['a']);
      expect(graph.predecessorsOf('a'), ['c']);
      expect(graph.predecessorsOf('b'), isEmpty);
      expect(graph.predecessorsOf('c'), ['a']);
      expect(graph.successorsOf('a'), ['c']);
      expect(graph.successorsOf('b'), isEmpty);
      expect(graph.successorsOf('c'), ['a']);
    });
    test('edge predicate filtering nothing', () {
      final base = Graph<String, void>.create(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(edgePredicate: (vertex) => true);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(base.vertices));
      expect(graph.edges, unorderedEquals(base.edges));
    });
    test('edge predicate filtering everything', () {
      final base = Graph<String, void>.create(isDirected: true);
      base
        ..addEdge('a', 'b')
        ..addEdge('b', 'c')
        ..addEdge('c', 'a');
      final graph = base.where(edgePredicate: (vertex) => false);
      expectInvariants(graph);
      expect(graph.vertices, unorderedEquals(base.vertices));
      expect(graph.edges, isEmpty);
    });
    test('no predicates', () {
      final base = Graph<int, int>.create(isDirected: true);
      final graph = base.where();
      expect(graph, same(base));
    });
  });
  group('edge', () {
    group('directed', () {
      const a = Edge<int, void>.directed(1, 2);
      const b = Edge<int, String>.directed(2, 1, value: 'b');
      const c = Edge<int, String>.directed(2, 1, value: 'c');
      test('create (without data)', () {
        expect(a.source, 1);
        expect(a.target, 2);
      });
      test('create (with data)', () {
        expect(c.source, 2);
        expect(c.target, 1);
        expect(c.value, 'c');
      });
      test('equals', () {
        expect(a == a, isTrue);
        expect(a == b, isFalse);
        expect(a == c, isFalse);
        expect(b == a, isFalse);
        expect(b == b, isTrue);
        expect(b == c, isTrue);
        expect(c == a, isFalse);
        expect(c == b, isTrue);
        expect(c == c, isTrue);
      });
      test('hashCode', () {
        expect(a.hashCode == b.hashCode, isFalse);
        expect(b.hashCode == c.hashCode, isTrue);
      });
      test('toString', () {
        expect(a.toString(), endsWith('(1 → 2)'));
        expect(b.toString(), endsWith('(2 → 1, value: b)'));
        expect(c.toString(), endsWith('(2 → 1, value: c)'));
      });
    });
    group('undirected', () {
      const a = Edge<int, void>.undirected(1, 2);
      const b = Edge<int, String>.undirected(2, 1, value: 'b');
      const c = Edge<int, String>.undirected(2, 3, value: 'c');
      test('create (without data)', () {
        expect(a.source, 1);
        expect(a.target, 2);
      });
      test('create (with data)', () {
        expect(c.source, 2);
        expect(c.target, 3);
        expect(c.value, 'c');
      });
      test('equals', () {
        expect(a == a, isTrue);
        expect(a == b, isTrue);
        expect(a == c, isFalse);
        expect(b == a, isTrue);
        expect(b == b, isTrue);
        expect(b == c, isFalse);
        expect(c == a, isFalse);
        expect(c == b, isFalse);
        expect(c == c, isTrue);
      });
      test('hashCode', () {
        expect(a.hashCode == b.hashCode, isTrue);
        expect(a.hashCode == c.hashCode, isFalse);
      });
      test('toString', () {
        expect(a.toString(), endsWith('(1 — 2)'));
        expect(b.toString(), endsWith('(2 — 1, value: b)'));
        expect(c.toString(), endsWith('(2 — 3, value: c)'));
      });
    });
  });
  group('path', () {
    test('fromVertices (without data)', () {
      final path = Path<int, void>.fromVertices([1, 2, 3]);
      expect(path.vertices, [1, 2, 3]);
      expect(path.values, [null, null]);
      expect(path.source, 1);
      expect(path.target, 3);
      expect(path.edges, [isEdge(1, 2), isEdge(2, 3)]);
      expect(path.toString(), endsWith('(1 → 2 → 3)'));
    });
    test('fromVertices (with data)', () {
      final path = Path<String, int>.fromVertices(
        ['a', 'b', 'c'],
        values: [2, 3],
      );
      expect(path.vertices, ['a', 'b', 'c']);
      expect(path.values, [2, 3]);
      expect(path.source, 'a');
      expect(path.target, 'c');
      expect(path.edges, [isEdge('a', 'b'), isEdge('b', 'c')]);
      expect(path.cost, 5);
      expect(path.toString(), endsWith('(a → b → c, values: [2, 3], cost: 5)'));
    });
    test('fromEdges (without data)', () {
      final path = Path<int, void>.fromEdges(const [
        Edge.directed(4, 5),
        Edge.undirected(5, 6),
      ]);
      expect(path.vertices, [4, 5, 6]);
      expect(path.values, [null, null]);
      expect(path.source, 4);
      expect(path.target, 6);
      expect(path.edges, [isEdge(4, 5), isEdge(5, 6)]);
      expect(path.toString(), endsWith('(4 → 5 → 6)'));
    });
    test('fromEdges (with data)', () {
      final path = Path<String, int>.fromEdges(const [
        Edge.undirected('x', 'y', value: 4),
        Edge.directed('y', 'z', value: 5),
      ]);
      expect(path.vertices, ['x', 'y', 'z']);
      expect(path.values, [4, 5]);
      expect(path.source, 'x');
      expect(path.target, 'z');
      expect(path.edges, [isEdge('x', 'y'), isEdge('y', 'z')]);
      expect(path.cost, 9);
      expect(path.toString(), endsWith('(x → y → z, values: [4, 5], cost: 9)'));
    });
    test('long path', () {
      final vertices = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
      final values = [1, 2, 3, 4, 5, 6, 7];
      final path = Path<String, int>.fromVertices(vertices, values: values);
      expect(path.vertices, vertices);
      expect(path.values, values);
      expect(path.source, 'a');
      expect(path.target, 'h');
      expect(path.edges, [
        isEdge('a', 'b', value: 1),
        isEdge('b', 'c', value: 2),
        isEdge('c', 'd', value: 3),
        isEdge('d', 'e', value: 4),
        isEdge('e', 'f', value: 5),
        isEdge('f', 'g', value: 6),
        isEdge('g', 'h', value: 7),
      ]);
      expect(
        path.toString(),
        endsWith(
          '(a → b → c → … → f → g → h (8 total), '
          'values: [1, 2, 3, …, 5, 6, 7], '
          'cost: 28)',
        ),
      );
    });
    final a = Path<String, int>.fromVertices(['a', 'b', 'c'], values: [1, 2]);
    final b = Path<String, int>.fromVertices(['a', 'b', 'd'], values: [2, 1]);
    final c = Path<String, int>.fromEdges(const [
      Edge.undirected('a', 'b', value: 1),
      Edge.undirected('b', 'c', value: 2),
    ]);
    test('equals', () {
      expect(a == a, isTrue);
      expect(a == b, isFalse);
      expect(a == c, isTrue);
      expect(b == a, isFalse);
      expect(b == b, isTrue);
      expect(b == c, isFalse);
      expect(c == a, isTrue);
      expect(c == b, isFalse);
      expect(c == c, isTrue);
    });
    test('hashCode', () {
      expect(a.hashCode == b.hashCode, isFalse);
      expect(a.hashCode == c.hashCode, isTrue);
    });
  });
}
