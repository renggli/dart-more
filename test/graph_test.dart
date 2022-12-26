import 'dart:math';

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

// A basic graph:
//   +-------------+-> 3
//  /             /    ^
// 0 ---> 2 ---> 5    /
//  \                /
//   +--> 1 ---> 4 -+
Iterable<int> basicGraph(int vertex) => const {
      0: [3, 2, 1],
      1: [4],
      2: [5],
      3: <int>[],
      4: [3],
      5: [3],
    }[vertex]!;

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
Iterable<int> cyclicGraph(int vertex) => const {
      0: [3],
      1: [2, 3],
      2: [3],
      3: [1, 4],
      4: [4],
    }[vertex]!;

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
        graph.addEdge('Hello', 'World');
        expect(graph.vertices, ['Hello', 'World']);
        expect(graph.edges, [
          isEdge(source: 'Hello', target: 'World'),
        ]);
      });
      test('remove edge', () {
        final graph = Graph<String, int>.directed();
        graph.addEdge('Hello', 'World');
        graph.removeEdge('Hello', 'World');
        expect(graph.vertices, ['Hello', 'World']);
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
    group('undirected', () {
      test('empty', () {
        final graph = Graph<String, int>.undirected();
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
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
        graph.addEdge('Hello', 'World');
        expect(graph.vertices, ['Hello', 'World']);
        expect(graph.edges, [
          isEdge(source: 'Hello', target: 'World'),
          isEdge(source: 'World', target: 'Hello'),
        ]);
      });
      test('remove edge', () {
        final graph = Graph<String, int>.undirected();
        graph.addEdge('Hello', 'World');
        graph.removeEdge('Hello', 'World');
        expect(graph.vertices, ['Hello', 'World']);
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
      test('reversed', () {
        final graph = Graph<String, int>.undirected();
        expect(graph.reversed, same(graph));
      });
    });
    group('reversed', () {
      test('empty', () {
        final graph = Graph<String, int>.directed();
        final reversed = graph.reversed;
        expect(reversed.isDirected, isTrue);
        expect(reversed.vertices, isEmpty);
        expect(reversed.edges, isEmpty);
      });
      test('add vertex', () {
        final graph = Graph<String, int>.directed();
        final reversed = graph.reversed;
        reversed.addVertex('Hello');
        expect(reversed.vertices, ['Hello']);
        expect(reversed.edges, isEmpty);
      });
      test('remove vertex', () {
        final graph = Graph<String, int>.directed();
        final reversed = graph.reversed;
        reversed.addVertex('Hello');
        reversed.removeVertex('Hello');
        expect(reversed.vertices, isEmpty);
        expect(reversed.edges, isEmpty);
      });
      test('add edge', () {
        final graph = Graph<String, int>.directed();
        final reversed = graph.reversed;
        reversed.addEdge('Hello', 'World');
        expect(reversed.vertices, ['World', 'Hello']);
        expect(reversed.edges, [
          isEdge(source: 'Hello', target: 'World'),
        ]);
      });
      test('remove edge', () {
        final graph = Graph<String, int>.directed();
        final reversed = graph.reversed;
        reversed.addEdge('Hello', 'World');
        reversed.removeEdge('Hello', 'World');
        expect(reversed.vertices, ['World', 'Hello']);
        expect(reversed.edges, isEmpty);
      });
      test('add edge, remove first vertex', () {
        final graph = Graph<String, int>.directed();
        final reversed = graph.reversed;
        reversed.addEdge('Hello', 'World');
        reversed.removeVertex('Hello');
        expect(reversed.vertices, ['World']);
        expect(reversed.edges, isEmpty);
      });
      test('add edge, remove second vertex', () {
        final graph = Graph<String, int>.directed();
        final reversed = graph.reversed;
        reversed.addEdge('Hello', 'World');
        reversed.removeVertex('World');
        expect(reversed.vertices, ['Hello']);
        expect(reversed.edges, isEmpty);
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
        expect(result.vertices, [0, 1, 2]);
        expect(result.edges, [
          isEdge(source: 0, target: 1, data: const Point(0, 1)),
          isEdge(source: 1, target: 2, data: const Point(1, 2)),
          isEdge(source: 2, target: 0, data: const Point(2, 0)),
        ]);
      });
      test('vertex only', () {
        final result = graph.map<String, Point<int>>(
            vertex: (vertex) => vertex.toString());
        expect(result.vertices, ['0', '1', '2']);
        expect(result.edges, [
          isEdge(source: '0', target: '1', data: const Point(0, 1)),
          isEdge(source: '1', target: '2', data: const Point(1, 2)),
          isEdge(source: '2', target: '0', data: const Point(2, 0)),
        ]);
      });
      test('edge only', () {
        final result = graph.map<int, String>(
            edge: (edge) => '${edge.data.x} -> ${edge.data.y}');
        expect(result.vertices, [0, 1, 2]);
        expect(result.edges, [
          isEdge(source: 0, target: 1, data: '0 -> 1'),
          isEdge(source: 1, target: 2, data: '1 -> 2'),
          isEdge(source: 2, target: 0, data: '2 -> 0'),
        ]);
      });
      test('vertex and edge', () {
        final result = graph.map<String, String>(
            vertex: (vertex) => vertex.toString(),
            edge: (edge) => '${edge.data.x} -> ${edge.data.y}');
        expect(result.vertices, ['0', '1', '2']);
        expect(result.edges, [
          isEdge(source: '0', target: '1', data: '0 -> 1'),
          isEdge(source: '1', target: '2', data: '1 -> 2'),
          isEdge(source: '2', target: '0', data: '2 -> 0'),
        ]);
      });
    });
  });
  group('generate', () {
    group('bipartite', () {
      test('empty', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: []);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
      test('path graph (p: 1, q: 1)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [1, 1]);
        expect(graph.vertices, [0, 1]);
        expect(graph.edges, [
          isEdge(source: 0, target: 1),
        ]);
      });
      test('claw graph (p: 1, q: 3)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [1, 3]);
        expect(graph.vertices, [0, 1, 2, 3]);
        expect(graph.edges, [
          isEdge(source: 0, target: 1),
          isEdge(source: 0, target: 2),
          isEdge(source: 0, target: 3),
        ]);
      });
      test('square graph (p: 2, q: 2)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [2, 2]);
        expect(graph.vertices, [0, 1, 2, 3]);
        expect(graph.edges, [
          isEdge(source: 0, target: 2),
          isEdge(source: 0, target: 3),
          isEdge(source: 1, target: 2),
          isEdge(source: 1, target: 3),
        ]);
      });
      test('utility graph (p: 3, q: 3)', () {
        final graph = GraphBuilder<int, Never>().partite(vertexCounts: [3, 3]);
        expect(graph.vertices, [0, 1, 2, 3, 4, 5]);
        expect(graph.edges, [
          isEdge(source: 0, target: 3),
          isEdge(source: 0, target: 4),
          isEdge(source: 0, target: 5),
          isEdge(source: 1, target: 3),
          isEdge(source: 1, target: 4),
          isEdge(source: 1, target: 5),
          isEdge(source: 2, target: 3),
          isEdge(source: 2, target: 4),
          isEdge(source: 2, target: 5),
        ]);
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
        expect(graph.vertices, [0, 1, 2]);
        expect(graph.edges, [
          isEdge(source: 0, target: 1),
          isEdge(source: 0, target: 2),
          isEdge(source: 1, target: 0),
          isEdge(source: 1, target: 2),
          isEdge(source: 2, target: 0),
          isEdge(source: 2, target: 1),
        ]);
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
        expect(graph.vertices, [0, 1, 2]);
        expect(graph.edges, [
          isEdge(source: 0, target: 1),
          isEdge(source: 1, target: 2),
        ]);
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
        expect(graph.vertices, [0, 1, 2]);
        expect(graph.edges, [
          isEdge(source: 0, target: 1),
          isEdge(source: 1, target: 2),
          isEdge(source: 2, target: 0),
        ]);
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
        expect(graph.vertices, [0, 1, 2, 3]);
        expect(graph.edges, [
          isEdge(source: 0, target: 1),
          isEdge(source: 0, target: 2),
          isEdge(source: 0, target: 3),
        ]);
      });
    });
  });
  group('traverser', () {
    group('breadth-first', () {
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
    group('depth-first (pre-order)', () {
      test('basic', () {
        final traverser = Traverser.fromFunction(basicGraph);
        expect(traverser.depthFirstPreOrder(0), [0, 3, 2, 5, 1, 4]);
      });
      test('cyclic', () {
        final traverser = Traverser.fromFunction(cyclicGraph);
        expect(traverser.depthFirstPreOrder(0), [0, 3, 1, 2, 4]);
      });
      test('infinite', () {
        final traverser = Traverser.fromFunction(reverseCollatzGraph);
        expect(traverser.depthFirstPreOrder(1).take(10),
            [1, 2, 4, 8, 16, 5, 10, 3, 6, 12]);
      });
    });
    group('depth-first (post-order)', () {
      test('basic', () {
        final traverser = Traverser.fromFunction(basicGraph);
        expect(traverser.depthFirstPostOrder(0), [3, 5, 2, 4, 1, 0]);
      });
      test('cyclic', () {
        final traverser = Traverser.fromFunction(cyclicGraph);
        expect(traverser.depthFirstPostOrder(0), [2, 1, 4, 3, 0]);
      });
    });
  });
}
