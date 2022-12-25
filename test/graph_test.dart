import 'package:more/graph.dart';
import 'package:more/src/graph/strategy/default.dart';
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

Matcher isPath<E>({
  dynamic head = anything,
  dynamic tail = anything,
  dynamic cost = anything,
  dynamic depth = anything,
  dynamic length = anything,
}) =>
    isA<Path<E>>()
        .having((path) => path.tail, 'tail', tail)
        .having((path) => path.weight, 'cost', cost)
        .having((path) => path.depth, 'depth', depth)
        .having((path) => path.length, 'length', length)
        .having(
            (path) => path.elements,
            'elements',
            isA<List<E>>()
                .having((elements) => elements.length, 'length', length)
                .having((elements) => elements.first, 'first', head)
                .having((elements) => elements.last, 'last', tail));

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

// A weighted graph:
//
// 0 ---> 1 ---> 2 ---> 3
// |                    ^
//  \-------- 4--------/
//
Iterable<NextEdge<int>> weightedGraph(int vertex) => const {
      0: [NextEdge(1, weight: 1), NextEdge(4, weight: 4)],
      1: [NextEdge(2, weight: 2)],
      2: [NextEdge(3, weight: 3)],
      3: <NextEdge<int>>[],
      4: [NextEdge(3, weight: 5)],
    }[vertex]!;

// Infinite numeric graph.
Iterable<int> infiniteGraph(int i) => [i + 3, i - 1];

// Towers of Hanoi.
Iterable<List<List<int>>> hanoiGraph(List<List<int>> towers) sync* {
  for (var source = 0; source < towers.length; source++) {
    for (var target = 0; target < towers.length; target++) {
      if (source != target &&
          towers[source].isNotEmpty &&
          (towers[target].isEmpty ||
              towers[source].last < towers[target].last)) {
        final result = [...towers];
        result[source] = [...towers[source]]..removeLast();
        result[target] = [...towers[target], towers[source].last];
        yield result;
      }
    }
  }
}

// The reverse collatz graph:
// https://en.wikipedia.org/wiki/Collatz_conjecture#In_reverse
Iterable<int> collatz(int vertex) {
  if ((vertex - 1) % 3 == 0) {
    return [(vertex - 1) ~/ 3, 2 * vertex];
  } else {
    return [2 * vertex];
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
  group('traversal', () {
    group('breadth first', () {
      test('basic graph', () {
        final traversal = Traversal.breadthFirst(nextVertices: basicGraph);
        expect(traversal.start(0).map((path) => path.tail), [0, 3, 2, 1, 5, 4]);
      });
      test('cyclic graph', () {
        final traversal = Traversal.breadthFirst(nextVertices: cyclicGraph);
        expect(traversal.start(0), [
          isPath<int>(head: 0, tail: 0, cost: 0, depth: 0, length: 1),
          isPath<int>(head: 0, tail: 3, cost: 1, depth: 1, length: 2),
          isPath<int>(head: 0, tail: 1, cost: 2, depth: 2, length: 3),
          isPath<int>(head: 0, tail: 4, cost: 2, depth: 2, length: 3),
          isPath<int>(head: 0, tail: 2, cost: 3, depth: 3, length: 4),
        ]);
      });
      test('weighted graph', () {
        final traversal = Traversal.breadthFirst(nextEdges: weightedGraph);
        expect(traversal.start(0), [
          isPath<int>(head: 0, tail: 0, cost: 0, depth: 0, length: 1),
          isPath<int>(head: 0, tail: 1, cost: 1, depth: 1, length: 2),
          isPath<int>(head: 0, tail: 4, cost: 4, depth: 1, length: 2),
          isPath<int>(head: 0, tail: 2, cost: 3, depth: 2, length: 3),
          isPath<int>(head: 0, tail: 3, cost: 9, depth: 2, length: 3),
        ]);
      });
      test('infinite graph', () {
        final traversal = Traversal.breadthFirst(
            nextVertices: infiniteGraph,
            vertexStrategy: DefaultGraphStrategy<int>());
        expect(traversal.start(2).take(5), [
          isPath<int>(head: 2, tail: 2, cost: 0, depth: 0, length: 1),
          isPath<int>(head: 2, tail: 5, cost: 1, depth: 1, length: 2),
          isPath<int>(head: 2, tail: 1, cost: 1, depth: 1, length: 2),
          isPath<int>(head: 2, tail: 8, cost: 2, depth: 2, length: 3),
          isPath<int>(head: 2, tail: 4, cost: 2, depth: 2, length: 3),
        ]);
      });
      test('find nodes of a specific depth', () {
        final traversal = Traversal.breadthFirst(
            nextVertices: infiniteGraph,
            vertexStrategy: DefaultGraphStrategy<int>());
        print(traversal.start(2));
        expect(
            traversal
                .start(2)
                .skipWhile((path) => path.depth < 4)
                .takeWhile((path) => path.depth < 5)
                .map((path) => path.tail),
            [14, 10, 6, -2]);
      });
    });
    group('depth first', () {
      test('basic graph', () {
        final traversal = Traversal.depthFirst(nextVertices: basicGraph);
        expect(traversal.start(0).map((path) => path.tail), [0, 3, 2, 5, 1, 4]);
      });
      test('cyclic graph', () {
        final traversal = Traversal.depthFirst(nextVertices: cyclicGraph);
        expect(traversal.start(0), [
          isPath<int>(head: 0, tail: 0, cost: 0, depth: 0, length: 1),
          isPath<int>(head: 0, tail: 3, cost: 1, depth: 1, length: 2),
          isPath<int>(head: 0, tail: 1, cost: 2, depth: 2, length: 3),
          isPath<int>(head: 0, tail: 2, cost: 3, depth: 3, length: 4),
          isPath<int>(head: 0, tail: 4, cost: 2, depth: 2, length: 3),
        ]);
      });
      test('weighted graph', () {
        final traversal = Traversal.depthFirst(nextEdges: weightedGraph);
        expect(traversal.start(0), [
          isPath<int>(head: 0, tail: 0, cost: 0, depth: 0, length: 1),
          isPath<int>(head: 0, tail: 1, cost: 1, depth: 1, length: 2),
          isPath<int>(head: 0, tail: 2, cost: 3, depth: 2, length: 3),
          isPath<int>(head: 0, tail: 3, cost: 6, depth: 3, length: 4),
          isPath<int>(head: 0, tail: 4, cost: 4, depth: 1, length: 2),
        ]);
      });
    });
  });
  group('topological', () {
    test('basic graph', () {
      final traversal = Traversal.topological(nextVertices: basicGraph);
      expect(traversal.start(0).map((path) => path.tail), [0, 1, 2, 4, 5, 3]);
    });
    // test('cyclic graph', skip: true, () {
    //   final traversal = Traversal.topological(nextVertices: cyclicGraph);
    //   expect(traversal.start(0), [
    //     isPath<int>(head: 0, tail: 0, cost: 0, depth: 0, length: 1),
    //     isPath<int>(head: 0, tail: 3, cost: 1, depth: 1, length: 2),
    //     isPath<int>(head: 0, tail: 1, cost: 2, depth: 2, length: 3),
    //     isPath<int>(head: 0, tail: 2, cost: 3, depth: 3, length: 4),
    //     isPath<int>(head: 0, tail: 4, cost: 2, depth: 2, length: 3),
    //   ]);
    // });
    // test('weighted graph', () {
    //   final traversal = Traversal.topological(nextEdges: weightedGraph);
    //   expect(traversal.start(0), [
    //     isPath<int>(head: 0, tail: 0, cost: 0, depth: 0, length: 1),
    //     isPath<int>(head: 0, tail: 1, cost: 1, depth: 1, length: 2),
    //     isPath<int>(head: 0, tail: 2, cost: 3, depth: 2, length: 3),
    //     isPath<int>(head: 0, tail: 3, cost: 6, depth: 3, length: 4),
    //     isPath<int>(head: 0, tail: 4, cost: 4, depth: 1, length: 2),
    //   ]);
    // });
  });
}
