import 'dart:math';

import 'package:more/functional.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

Matcher isEdge({
  dynamic source = anything,
  dynamic target = anything,
  dynamic data = anything,
}) =>
    isA<Edge<void, void>>()
        .having((edge) => edge.source, 'source', source)
        .having((edge) => edge.target, 'target', target)
        .having((edge) => edge.dataOrNull, 'data', data);

Matcher isPath({
  dynamic source = anything,
  dynamic target = anything,
  dynamic vertices = anything,
  dynamic cost = anything,
}) =>
    isA<Path<void>>()
        .having((path) => path.source, 'source', source)
        .having((path) => path.target, 'target', target)
        .having((path) => path.vertices, 'vertices', vertices)
        .having((path) => path.cost, 'cost', cost);

// A basic graph:
//   +-------------+-> 3
//  /             /    ^
// 0 ---> 2 ---> 5    /
//  \                /
//   +--> 1 ---> 4 -+
const basicGraphData = {
  0: [3, 2, 1],
  1: [4],
  2: [5],
  3: <int>[],
  4: [3],
  5: [3],
};

Iterable<int> basicGraph(int vertex) => basicGraphData[vertex]!;

// A cyclic graph:
//
//        1 --> 2
//       | ^   /
//       | |  /
//       v | v
// 0 ----> 3 ----> 4 ---\
//                 ^    |
//                 \----/
//
const cyclicGraphData = {
  0: [3],
  1: [2, 3],
  2: [3],
  3: [1, 4],
  4: [4],
};

Iterable<int> cyclicGraph(int vertex) => cyclicGraphData[vertex]!;

// The reverse collatz graph:
// https://en.wikipedia.org/wiki/Collatz_conjecture#In_reverse
Iterable<int> reverseCollatzGraph(int vertex) =>
    vertex > 1 && (vertex - 1) % 3 == 0
        ? [(vertex - 1) ~/ 3, 2 * vertex]
        : [2 * vertex];

// Undirected graph for weighted searches:
// https://en.wikipedia.org/wiki/File:Dijkstra_Animation.gif
final dijkstraGraph = Graph<int, int>.undirected()
  ..addEdge(1, 2, data: 7)
  ..addEdge(1, 3, data: 9)
  ..addEdge(1, 6, data: 14)
  ..addEdge(2, 3, data: 10)
  ..addEdge(2, 4, data: 15)
  ..addEdge(3, 4, data: 11)
  ..addEdge(3, 6, data: 2)
  ..addEdge(4, 5, data: 6)
  ..addEdge(5, 6, data: 9);

void expectInvariants<V, E>(Graph<V, E> graph) {
  for (final vertex in graph.vertices) {
    for (final edge in graph.edgesOf(vertex)) {
      expect(graph.edges,
          contains(isEdge(source: edge.source, target: edge.target)));
      expect([edge.source, edge.target], contains(vertex));
    }
    for (final outgoingEdge in graph.outgoingEdgesOf(vertex)) {
      expect(outgoingEdge.source, vertex);
      expect(graph.predecessorsOf(outgoingEdge.target), contains(vertex));
      expect(graph.successorsOf(vertex), contains(outgoingEdge.target));
      expect(
          graph.edges,
          contains(isEdge(
              source: outgoingEdge.source, target: outgoingEdge.target)));
    }
    for (final incomingEdge in graph.incomingEdgesOf(vertex)) {
      expect(incomingEdge.target, vertex);
      expect(graph.predecessorsOf(vertex), contains(incomingEdge.source));
      expect(graph.successorsOf(incomingEdge.source), contains(vertex));
      expect(
          graph.edges,
          contains(isEdge(
              source: incomingEdge.source, target: incomingEdge.target)));
    }
  }
  for (final edge in graph.edges) {
    expect(graph.vertices, contains(edge.source));
    expect(graph.vertices, contains(edge.target));
  }
}

void main() {
  group('graph', () {
    group('directed', () {
      test('empty', () {
        final graph = Graph<String, int>.directed();
        expect(graph.isDirected, isTrue);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      group('modifying', () {
        test('add vertex', () {
          final graph = Graph<String, int>.directed();
          graph.addVertex('Hello');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('remove vertex', () {
          final graph = Graph<String, int>.directed();
          graph.addVertex('Hello');
          graph.removeVertex('Hello');
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Hello', 'World', data: 42);
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, [
            isEdge(source: 'Hello', target: 'World', data: 42),
          ]);
          expectInvariants(graph);
        });
        test('remove edge', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
      });
      group('querying', () {
        final graph = Graph<int, String>.directed()
          ..addEdge(0, 1, data: 'a')
          ..addEdge(1, 2, data: 'b');
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
                isEdge(source: 0, target: 1, data: 'a'),
                isEdge(source: 1, target: 2, data: 'b'),
              ]));
        });
        test('edgesOf', () {
          expect(graph.edgesOf(0), [
            isEdge(source: 0, target: 1, data: 'a'),
          ]);
          expect(
              graph.edgesOf(1),
              unorderedEquals([
                isEdge(source: 0, target: 1, data: 'a'),
                isEdge(source: 1, target: 2, data: 'b'),
              ]));
          expect(graph.edgesOf(2), [
            isEdge(source: 1, target: 2, data: 'b'),
          ]);
        });
        test('incomingEdgesOf', () {
          expect(graph.incomingEdgesOf(0), isEmpty);
          expect(graph.incomingEdgesOf(1), [
            isEdge(source: 0, target: 1, data: 'a'),
          ]);
          expect(graph.incomingEdgesOf(2), [
            isEdge(source: 1, target: 2, data: 'b'),
          ]);
        });
        test('outgoingEdgesOf', () {
          expect(graph.outgoingEdgesOf(0), [
            isEdge(source: 0, target: 1, data: 'a'),
          ]);
          expect(graph.outgoingEdgesOf(1), [
            isEdge(source: 1, target: 2, data: 'b'),
          ]);
          expect(graph.outgoingEdgesOf(2), isEmpty);
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
        final graph = Graph<String, int>.directed().reversed;
        expect(graph.isDirected, isTrue);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      group('modifying', () {
        test('add vertex', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addVertex('Hello');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('remove vertex', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addVertex('Hello');
          graph.removeVertex('Hello');
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Hello', 'World', data: 42);
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, [
            isEdge(source: 'Hello', target: 'World', data: 42),
          ]);
          expectInvariants(graph);
        });
        test('remove edge', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
      });
      group('querying', () {
        final directed = Graph<int, String>.directed()
          ..addEdge(0, 1, data: 'a')
          ..addEdge(1, 2, data: 'b');
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
                isEdge(source: 1, target: 0, data: 'a'),
                isEdge(source: 2, target: 1, data: 'b'),
              ]));
        });
        test('edgesOf', () {
          expect(graph.edgesOf(0), [
            isEdge(source: 1, target: 0, data: 'a'),
          ]);
          expect(
              graph.edgesOf(1),
              unorderedEquals([
                isEdge(source: 1, target: 0, data: 'a'),
                isEdge(source: 2, target: 1, data: 'b'),
              ]));
          expect(graph.edgesOf(2), [
            isEdge(source: 2, target: 1, data: 'b'),
          ]);
        });
        test('incomingEdgesOf', () {
          expect(graph.incomingEdgesOf(0), [
            isEdge(source: 1, target: 0, data: 'a'),
          ]);
          expect(graph.incomingEdgesOf(1), [
            isEdge(source: 2, target: 1, data: 'b'),
          ]);
          expect(graph.incomingEdgesOf(2), isEmpty);
        });
        test('outgoingEdgesOf', () {
          expect(graph.outgoingEdgesOf(0), isEmpty);
          expect(graph.outgoingEdgesOf(1), [
            isEdge(source: 1, target: 0, data: 'a'),
          ]);
          expect(graph.outgoingEdgesOf(2), [
            isEdge(source: 2, target: 1, data: 'b'),
          ]);
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
        final graph = Graph<String, int>.undirected();
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      group('modifying', () {
        test('add vertex', () {
          final graph = Graph<String, int>.undirected();
          graph.addVertex('Hello');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('remove vertex', () {
          final graph = Graph<String, int>.undirected();
          graph.addVertex('Hello');
          graph.removeVertex('Hello');
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge', () {
          final graph = Graph<String, int>.undirected();
          graph.addEdge('Hello', 'World', data: 42);
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(source: 'Hello', target: 'World', data: 42),
                isEdge(source: 'World', target: 'Hello', data: 42),
              ]));
          expectInvariants(graph);
        });
        test('remove edge', () {
          final graph = Graph<String, int>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, int>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, int>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
      });
      group('querying', () {
        final graph = Graph<int, String>.undirected()
          ..addEdge(0, 1, data: 'a')
          ..addEdge(1, 2, data: 'b');
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
                isEdge(source: 0, target: 1, data: 'a'),
                isEdge(source: 1, target: 0, data: 'a'),
                isEdge(source: 1, target: 2, data: 'b'),
                isEdge(source: 2, target: 1, data: 'b'),
              ]));
        });
        test('edgesOf', () {
          expect(graph.edgesOf(0), [
            isEdge(source: 0, target: 1, data: 'a'),
          ]);
          expect(
              graph.edgesOf(1),
              unorderedEquals([
                isEdge(source: 1, target: 0, data: 'a'),
                isEdge(source: 1, target: 2, data: 'b'),
              ]));
          expect(graph.edgesOf(2), [
            isEdge(source: 2, target: 1, data: 'b'),
          ]);
        });
        test('incomingEdgesOf', () {
          expect(graph.incomingEdgesOf(0), [
            isEdge(source: 1, target: 0, data: 'a'),
          ]);
          expect(
              graph.incomingEdgesOf(1),
              unorderedEquals([
                isEdge(source: 0, target: 1, data: 'a'),
                isEdge(source: 2, target: 1, data: 'b'),
              ]));
          expect(graph.incomingEdgesOf(2), [
            isEdge(source: 1, target: 2, data: 'b'),
          ]);
        });
        test('outgoingEdgesOf', () {
          expect(graph.outgoingEdgesOf(0), [
            isEdge(source: 0, target: 1, data: 'a'),
          ]);
          expect(
              graph.outgoingEdgesOf(1),
              unorderedEquals([
                isEdge(source: 1, target: 0, data: 'a'),
                isEdge(source: 1, target: 2, data: 'b'),
              ]));
          expect(graph.outgoingEdgesOf(2), [
            isEdge(source: 2, target: 1, data: 'b'),
          ]);
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
        final graph = Graph<String, int>.undirected();
        expect(graph.reversed, same(graph));
      });
    });
  });
  group('operation', () {
    group('map', () {
      final graph = GraphBuilder<int, Point<int>>(
              edgeProvider: (source, target) => Point(source, target))
          .ring(vertexCount: 3);
      test('none', () {
        final result = graph.map<int, Point<int>>();
        expect(result.vertices, unorderedEquals([0, 1, 2]));
        expect(
            result.edges,
            unorderedEquals([
              isEdge(source: 0, target: 1, data: const Point(0, 1)),
              isEdge(source: 1, target: 2, data: const Point(1, 2)),
              isEdge(source: 2, target: 0, data: const Point(2, 0)),
            ]));
        expectInvariants(result);
      });
      test('vertex only', () {
        final result = graph.map<String, Point<int>>(
            vertex: (vertex) => vertex.toString());
        expect(result.vertices, unorderedEquals(['0', '1', '2']));
        expect(
            result.edges,
            unorderedEquals([
              isEdge(source: '0', target: '1', data: const Point(0, 1)),
              isEdge(source: '1', target: '2', data: const Point(1, 2)),
              isEdge(source: '2', target: '0', data: const Point(2, 0)),
            ]));
        expectInvariants(result);
      });
      test('edge only', () {
        final result = graph.map<int, String>(
            edge: (edge) => '${edge.data.x} -> ${edge.data.y}');
        expect(result.vertices, unorderedEquals([0, 1, 2]));
        expect(
            result.edges,
            unorderedEquals([
              isEdge(source: 0, target: 1, data: '0 -> 1'),
              isEdge(source: 1, target: 2, data: '1 -> 2'),
              isEdge(source: 2, target: 0, data: '2 -> 0'),
            ]));
        expectInvariants(result);
      });
      test('vertex and edge', () {
        final result = graph.map<String, String>(
            vertex: (vertex) => vertex.toString(),
            edge: (edge) => '${edge.data.x} -> ${edge.data.y}');
        expect(result.vertices, unorderedEquals(['0', '1', '2']));
        expect(
            result.edges,
            unorderedEquals([
              isEdge(source: '0', target: '1', data: '0 -> 1'),
              isEdge(source: '1', target: '2', data: '1 -> 2'),
              isEdge(source: '2', target: '0', data: '2 -> 0'),
            ]));
        expectInvariants(result);
      });
    });
  });
  group('builder', () {
    group('collection', () {
      group('path', () {
        test('empty', () {
          final graph = GraphBuilder<String, Never>().fromPath([]);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('single', () {
          final graph = GraphBuilder<String, Never>().fromPath(['a']);
          expect(graph.vertices, ['a']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('multiple', () {
          final graph = GraphBuilder<String, Never>().fromPath(['a', 'b', 'c']);
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(graph.edges, [
            isEdge(source: 'a', target: 'b'),
            isEdge(source: 'b', target: 'c'),
          ]);
          expectInvariants(graph);
        });
      });
      group('paths', () {
        test('empty', () {
          final graph = GraphBuilder<String, Never>().fromPaths([]);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('simple', () {
          final graph = GraphBuilder<String, Never>().fromPaths([
            ['a'],
            ['b', 'c'],
          ]);
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(graph.edges, [
            isEdge(source: 'b', target: 'c'),
          ]);
          expectInvariants(graph);
        });
        test('multiple', () {
          final graph = GraphBuilder<String, Never>().fromPaths([
            ['a', 'b', 'c'],
            ['d', 'b', 'e'],
          ]);
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c', 'd', 'e']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(source: 'a', target: 'b'),
                isEdge(source: 'b', target: 'c'),
                isEdge(source: 'd', target: 'b'),
                isEdge(source: 'b', target: 'e'),
              ]));
          expectInvariants(graph);
        });
      });
      group('predecessors', () {
        test('empty', () {
          final graph = GraphBuilder<String, Never>().fromPredecessors({});
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('single', () {
          final graph = GraphBuilder<String, Never>().fromPredecessors({
            'a': null,
          });
          expect(graph.vertices, ['a']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('basic', () {
          final graph = GraphBuilder<String, Never>().fromPredecessors({
            'a': ['b', 'c'],
          });
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(source: 'b', target: 'a'),
                isEdge(source: 'c', target: 'a'),
              ]));
          expectInvariants(graph);
        });
      });
      group('successors', () {
        test('empty', () {
          final graph = GraphBuilder<String, Never>().fromSuccessors({});
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('single', () {
          final graph = GraphBuilder<String, Never>().fromSuccessors({
            'a': null,
          });
          expect(graph.vertices, ['a']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('basic', () {
          final graph = GraphBuilder<String, Never>().fromSuccessors({
            'a': ['b', 'c'],
          });
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(source: 'a', target: 'b'),
                isEdge(source: 'a', target: 'c'),
              ]));
          expectInvariants(graph);
        });
      });
    });
    group('bipartite', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: []);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('path graph (p: 1, q: 1)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [1, 1]);
        expect(graph.vertices, unorderedEquals([0, 1]));
        expect(graph.edges, [
          isEdge(source: 0, target: 1),
        ]);
        expectInvariants(graph);
      });
      test('claw graph (p: 1, q: 3)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [1, 3]);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(source: 0, target: 1),
              isEdge(source: 0, target: 2),
              isEdge(source: 0, target: 3),
            ]));
        expectInvariants(graph);
      });
      test('square graph (p: 2, q: 2)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [2, 2]);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(source: 0, target: 2),
              isEdge(source: 0, target: 3),
              isEdge(source: 1, target: 2),
              isEdge(source: 1, target: 3),
            ]));
        expectInvariants(graph);
      });
      test('utility graph (p: 3, q: 3)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [3, 3]);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(source: 0, target: 3),
              isEdge(source: 0, target: 4),
              isEdge(source: 0, target: 5),
              isEdge(source: 1, target: 3),
              isEdge(source: 1, target: 4),
              isEdge(source: 1, target: 5),
              isEdge(source: 2, target: 3),
              isEdge(source: 2, target: 4),
              isEdge(source: 2, target: 5),
            ]));
        expectInvariants(graph);
      });
    });
    group('complete', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().complete(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphBuilder<int, Never>().complete(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('full', () {
        final graph = GraphBuilder<int, Never>().complete(vertexCount: 3);
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(source: 0, target: 1),
              isEdge(source: 0, target: 2),
              isEdge(source: 1, target: 0),
              isEdge(source: 1, target: 2),
              isEdge(source: 2, target: 0),
              isEdge(source: 2, target: 1),
            ]));
        expectInvariants(graph);
      });
    });
    group('path', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('full', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 3);
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(source: 0, target: 1),
              isEdge(source: 1, target: 2),
            ]));
        expectInvariants(graph);
      });
    });
    group('ring', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('full', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 3);
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(source: 0, target: 1),
              isEdge(source: 1, target: 2),
              isEdge(source: 2, target: 0),
            ]));
        expectInvariants(graph);
      });
    });
    group('star', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().star(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphBuilder<int, Never>().star(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('full', () {
        final graph = GraphBuilder<int, Never>().star(vertexCount: 4);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(source: 0, target: 1),
              isEdge(source: 0, target: 2),
              isEdge(source: 0, target: 3),
            ]));
        expectInvariants(graph);
      });
    });
  });
  group('search', () {
    group('dijkstra', () {
      test('directed path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        for (var i = 0; i < 10; i++) {
          expect(
            graph.shortestPath(0, i),
            isPath(source: 0, target: i, cost: i),
          );
          if (i != 0) {
            expect(
              graph.shortestPath(i, 0),
              isNull,
            );
          }
        }
      });
      test('directed path with cost', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        for (var i = 0; i < 10; i++) {
          expect(
            graph.shortestPath(0, i, edgeCost: (edge) => edge.target),
            isPath(source: 0, target: i, cost: i * (i + 1) ~/ 2),
          );
          if (i != 0) {
            expect(
              graph.shortestPath(i, 0, edgeCost: (edge) => edge.target),
              isNull,
            );
          }
        }
      });
      test('directed path with cost on edge', () {
        final graph =
            GraphBuilder<int, int>(edgeProvider: (source, target) => target)
                .path(vertexCount: 10);
        for (var i = 0; i < 10; i++) {
          expect(
            graph.shortestPath(0, i, edgeCost: (edge) => edge.data),
            isPath(source: 0, target: i, cost: i * (i + 1) ~/ 2),
          );
          if (i != 0) {
            expect(
              graph.shortestPath(i, 0, edgeCost: (edge) => edge.data),
              isNull,
            );
          }
        }
      });
      test('undirected path', () {
        final graph =
            GraphBuilder<int, Never>(isDirected: false).path(vertexCount: 10);
        for (var i = 0; i < 10; i++) {
          expect(
            graph.shortestPath(0, i),
            isPath(source: 0, target: i, cost: i),
          );
          expect(
            graph.shortestPath(i, 0),
            isPath(source: i, target: 0, cost: i),
          );
        }
      });
      test('undirected graph', () {
        expect(
          dijkstraGraph.shortestPath(1, 5, edgeCost: (edge) => edge.data),
          isPath(source: 1, target: 5, vertices: [1, 3, 6, 5], cost: 20),
        );
        expect(
            dijkstraGraph.shortestPathAll(1, constantFunction1(true),
                edgeCost: (edge) => edge.data),
            unorderedEquals([
              isPath(vertices: [1], cost: 0),
              isPath(vertices: [1, 2], cost: 7),
              isPath(vertices: [1, 3], cost: 9),
              isPath(vertices: [1, 3, 6], cost: 11),
              isPath(vertices: [1, 3, 6, 5], cost: 20),
              isPath(vertices: [1, 3, 4], cost: 20),
            ]));
      });
      test('undirected graph with default cost', () {
        expect(
          dijkstraGraph.shortestPath(1, 5),
          isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2),
        );
        expect(
            dijkstraGraph.shortestPathAll(1, constantFunction1(true)),
            unorderedEquals([
              isPath(vertices: [1], cost: 0),
              isPath(vertices: [1, 6], cost: 1),
              isPath(vertices: [1, 3], cost: 1),
              isPath(vertices: [1, 2], cost: 1),
              isPath(vertices: [1, 3, 4], cost: 2),
              isPath(vertices: [1, 6, 5], cost: 2),
            ]));
      });
      test('undirected graph with cost estimate', () {
        expect(
          dijkstraGraph.shortestPath(1, 5,
              costEstimate: (vertex) => 6 - vertex),
          isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2),
        );
        expect(
            dijkstraGraph.shortestPathAll(1, constantFunction1(true),
                costEstimate: (vertex) => 6 - vertex),
            unorderedEquals([
              isPath(vertices: [1], cost: 0),
              isPath(vertices: [1, 6], cost: 1),
              isPath(vertices: [1, 3], cost: 1),
              isPath(vertices: [1, 2], cost: 1),
              isPath(vertices: [1, 3, 4], cost: 2),
              isPath(vertices: [1, 6, 5], cost: 2),
            ]));
      });
    });
  });
  group('traverse', () {
    group('breadth-first', () {
      test('path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        expect(graph.breadthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 10);
        expect(graph.breadthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('basic', () {
        final graph = GraphBuilder<int, Never>().fromSuccessors(basicGraphData);
        expect(graph.breadthFirst(0), [0, 3, 2, 1, 5, 4]);
      });
      test('cyclic', () {
        final graph =
            GraphBuilder<int, Never>().fromSuccessors(cyclicGraphData);
        expect(graph.breadthFirst(0), [0, 3, 1, 4, 2]);
      });
      test('infinite', () {
        final iterable =
            BreadthFirstIterable([1], successorsOf: reverseCollatzGraph);
        expect(iterable.take(10), [1, 2, 4, 8, 16, 5, 32, 10, 64, 3]);
      });
    });
    group('depth-first', () {
      test('path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        expect(graph.depthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 10);
        expect(graph.depthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('basic', () {
        final graph = GraphBuilder<int, Never>().fromSuccessors(basicGraphData);
        expect(graph.depthFirst(0), [0, 3, 2, 5, 1, 4]);
      });
      test('cyclic', () {
        final graph =
            GraphBuilder<int, Never>().fromSuccessors(cyclicGraphData);
        expect(graph.depthFirst(0), [0, 3, 1, 2, 4]);
      });
      test('infinite', () {
        final iterable =
            DepthFirstIterable([1], successorsOf: reverseCollatzGraph);
        expect(iterable.take(10), [1, 2, 4, 8, 16, 5, 10, 3, 6, 12]);
      });
    });
    group('depth-first (post-order)', () {
      test('path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        expect(graph.depthFirstPostOrder(graph.vertices.first),
            [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
      });
      test('ring', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 10);
        expect(graph.depthFirstPostOrder(graph.vertices.first),
            [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
      });
      test('basic', () {
        final graph = GraphBuilder<int, Never>().fromSuccessors(basicGraphData);
        expect(graph.depthFirstPostOrder(0), [3, 5, 2, 4, 1, 0]);
      });
      test('cyclic', () {
        final graph =
            GraphBuilder<int, Never>().fromSuccessors(cyclicGraphData);
        expect(graph.depthFirstPostOrder(0), [2, 1, 4, 3, 0]);
      });
    });
    group('topological', () {
      test('path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        expect(graph.topological(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 10);
        expect(graph.topological(graph.vertices.first), isEmpty);
      });
      test('basic', () {
        final graph = GraphBuilder<int, Never>().fromSuccessors(basicGraphData);
        expect(graph.topological(0), [0, 1, 4, 2, 5, 3]);
      });
    });
  });
}
