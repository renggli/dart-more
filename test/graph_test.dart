import 'dart:math';

import 'package:more/graph.dart';
import 'package:more/src/graph/generator/collection.dart';
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

void main() {
  group('graph', () {
    group('directed', () {
      test('empty', () {
        final graph = Graph<String, int>.directed();
        expect(graph.isDirected, isTrue);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
      group('modifying', () {
        test('add vertex', () {
          final graph = Graph<String, int>.directed();
          graph.addVertex('Hello');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
        });
        test('remove vertex', () {
          final graph = Graph<String, int>.directed();
          graph.addVertex('Hello');
          graph.removeVertex('Hello');
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
        });
        test('add edge', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Hello', 'World', data: 42);
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, [
            isEdge(source: 'Hello', target: 'World', data: 42),
          ]);
        });
        test('remove edge', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
        });
      });
      group('querying', () {
        final graph = Graph<int, String>.directed()
          ..addEdge(0, 1, data: 'a')
          ..addEdge(1, 2, data: 'b');
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
      });
      group('modifying', () {
        test('add vertex', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addVertex('Hello');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
        });
        test('remove vertex', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addVertex('Hello');
          graph.removeVertex('Hello');
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
        });
        test('add edge', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Hello', 'World', data: 42);
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, [
            isEdge(source: 'Hello', target: 'World', data: 42),
          ]);
        });
        test('remove edge', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
        });
      });
      group('querying', () {
        final directed = Graph<int, String>.directed()
          ..addEdge(0, 1, data: 'a')
          ..addEdge(1, 2, data: 'b');
        final graph = directed.reversed;
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
      });
      group('modifying', () {
        test('add vertex', () {
          final graph = Graph<String, int>.undirected();
          graph.addVertex('Hello');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
        });
        test('remove vertex', () {
          final graph = Graph<String, int>.undirected();
          graph.addVertex('Hello');
          graph.removeVertex('Hello');
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
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
        });
        test('remove edge', () {
          final graph = Graph<String, int>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, int>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, int>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
        });
      });
      group('querying', () {
        final graph = Graph<int, String>.undirected()
          ..addEdge(0, 1, data: 'a')
          ..addEdge(1, 2, data: 'b');
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
      });
    });
  });
  group('generate', () {
    group('collection', () {
      group('path', () {
        test('empty', () {
          final graph = GraphBuilder<String, Never>().fromPath([]);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
        });
        test('single', () {
          final graph = GraphBuilder<String, Never>().fromPath(['a']);
          expect(graph.vertices, ['a']);
          expect(graph.edges, isEmpty);
        });
        test('multiple', () {
          final graph = GraphBuilder<String, Never>().fromPath(['a', 'b', 'c']);
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(graph.edges, [
            isEdge(source: 'a', target: 'b'),
            isEdge(source: 'b', target: 'c'),
          ]);
        });
      });
      group('paths', () {
        test('empty', () {
          final graph = GraphBuilder<String, Never>().fromPaths([]);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
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
        });
      });
      group('predecessors', () {
        test('empty', () {
          final graph = GraphBuilder<String, Never>().fromPredecessors({});
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
        });
        test('single', () {
          final graph = GraphBuilder<String, Never>().fromPredecessors({
            'a': null,
          });
          expect(graph.vertices, ['a']);
          expect(graph.edges, isEmpty);
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
        });
      });
      group('successors', () {
        test('empty', () {
          final graph = GraphBuilder<String, Never>().fromSuccessors({});
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
        });
        test('single', () {
          final graph = GraphBuilder<String, Never>().fromSuccessors({
            'a': null,
          });
          expect(graph.vertices, ['a']);
          expect(graph.edges, isEmpty);
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
        });
      });
    });
    group('bipartite', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: []);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
      test('path graph (p: 1, q: 1)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [1, 1]);
        expect(graph.vertices, unorderedEquals([0, 1]));
        expect(graph.edges, [
          isEdge(source: 0, target: 1),
        ]);
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
      });
    });
    group('complete', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().complete(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
      test('single', () {
        final graph = GraphBuilder<int, Never>().complete(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
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
      });
    });
    group('path', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
      test('single', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
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
      });
    });
    group('ring', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
      test('single', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
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
      });
    });
    group('star', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().star(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
      test('single', () {
        final graph = GraphBuilder<int, Never>().star(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
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
      });
    });
  });
  group('traverser', () {
    group('breadth-first', () {
      test('path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        final traverser = graph.traverse;
        expect(traverser.breadthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 10);
        final traverser = graph.traverse;
        expect(traverser.breadthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('basic', () {
        final traverser = Traverser.fromFunction(basicGraph);
        expect(traverser.breadthFirst(0), [0, 3, 2, 1, 5, 4]);
      });
      test('cyclic', () {
        final traverser = Traverser.fromFunction(cyclicGraph);
        expect(traverser.breadthFirst(0), [0, 3, 1, 4, 2]);
      });
      test('infinite', () {
        final traverser = Traverser.fromFunction(reverseCollatzGraph);
        expect(traverser.breadthFirst(1).take(10),
            [1, 2, 4, 8, 16, 5, 32, 10, 64, 3]);
      });
    });
    group('depth-first', () {
      test('path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        final traverser = graph.traverse;
        expect(traverser.depthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 10);
        final traverser = graph.traverse;
        expect(traverser.depthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('basic', () {
        final traverser = Traverser.fromFunction(basicGraph);
        expect(traverser.depthFirst(0), [0, 3, 2, 5, 1, 4]);
      });
      test('cyclic', () {
        final traverser = Traverser.fromFunction(cyclicGraph);
        expect(traverser.depthFirst(0), [0, 3, 1, 2, 4]);
      });
      test('infinite', () {
        final traverser = Traverser.fromFunction(reverseCollatzGraph);
        expect(traverser.depthFirst(1).take(10),
            [1, 2, 4, 8, 16, 5, 10, 3, 6, 12]);
      });
    });
    group('depth-first (post-order)', () {
      test('path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        final traverser = graph.traverse;
        expect(traverser.depthFirstPostOrder(graph.vertices.first),
            [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
      });
      test('ring', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 10);
        final traverser = graph.traverse;
        expect(traverser.depthFirstPostOrder(graph.vertices.first),
            [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
      });
      test('basic', () {
        final traverser = Traverser.fromFunction(basicGraph);
        expect(traverser.depthFirstPostOrder(0), [3, 5, 2, 4, 1, 0]);
      });
      test('cyclic', () {
        final traverser = Traverser.fromFunction(cyclicGraph);
        expect(traverser.depthFirstPostOrder(0), [2, 1, 4, 3, 0]);
      });
    });
    group('topological', () {
      test('path', () {
        final graph = GraphBuilder<int, Never>().path(vertexCount: 10);
        final traverser = graph.traverse;
        expect(traverser.topological(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphBuilder<int, Never>().ring(vertexCount: 10);
        final traverser = graph.traverse;
        expect(traverser.topological(graph.vertices.first), isEmpty);
      });
      test('basic', () {
        final traverser =
            GraphBuilder<int, Never>().fromSuccessors(basicGraphData).traverse;
        expect(traverser.topological(0), [0, 1, 4, 2, 5, 3]);
      });
    });
  });
}
