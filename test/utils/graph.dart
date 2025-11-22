import 'package:meta/meta.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

@optionalTypeArgs
// ignore: unreachable_from_main
Matcher isGraph<E, V>({
  dynamic vertices = anything,
  dynamic edges = anything,
  dynamic isDirected = anything,
}) => isA<Graph<E, V>>()
    .having((graph) => graph.vertices, 'vertices', vertices)
    .having((graph) => graph.edges, 'edges', edges)
    .having((graph) => graph.isDirected, 'isDirected', isDirected)
    .having((graph) => graph.toString(), 'toString', contains('Graph'));

@optionalTypeArgs
Matcher isEdge<E, V>(
  dynamic source,
  dynamic target, {
  dynamic value = anything,
  dynamic isDirected = anything,
}) => isA<Edge<E, V>>()
    .having((edge) => edge.source, 'source', source)
    .having((edge) => edge.target, 'target', target)
    .having((edge) => edge.value, 'value', value)
    .having((edge) => edge.isDirected, 'isDirected', isDirected)
    .having((edge) => edge.toString(), 'toString', contains('Edge'));

@optionalTypeArgs
Matcher isPath<V, E>({
  dynamic source = anything,
  dynamic target = anything,
  dynamic vertices = anything,
  dynamic values = anything,
  dynamic edges = anything,
  dynamic cost = anything,
  dynamic depth = anything,
}) => isA<Path<V, E>>()
    .having((path) => path.source, 'source', source)
    .having((path) => path.target, 'target', target)
    .having((path) => path.vertices, 'vertices', vertices)
    .having(
      (path) => path.vertices.length == path.vertices.toSet().length,
      'vertices (unique)',
      isTrue,
    )
    .having((path) => path.values, 'values', values)
    .having(
      (path) => path.values.length == path.vertices.length - 1,
      'values (for each edge)',
      isTrue,
    )
    .having((path) => path.edges, 'edges', edges)
    .having(
      (path) => cost != anything ? (path as Path<void, num>).cost : num,
      'cost',
      cost,
    )
    .having((path) => path.toString(), 'toString', contains('Path'));

final throwsGraphError = throwsA(isA<GraphError>());

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

// The collatz graph:
Iterable<int> collatzGraph(int vertex) =>
    vertex.isEven ? [vertex ~/ 2] : [3 * vertex + 1];

// The finite collatz graph:
Iterable<int> finiteCollatzGraph(int vertex) =>
    vertex == 1 ? [] : collatzGraph(vertex);

// The reverse collatz graph:
// https://en.wikipedia.org/wiki/Collatz_conjecture#In_reverse
Iterable<int> reverseCollatzGraph(int vertex) =>
    vertex > 1 && (vertex - 1) % 3 == 0
    ? [(vertex - 1) ~/ 3, 2 * vertex]
    : [2 * vertex];

// Undirected graph for weighted searches:
// https://en.wikipedia.org/wiki/File:Dijkstra_Animation.gif
final dijkstraGraph = Graph<int, int>.undirected()
  ..addEdge(1, 2, value: 7)
  ..addEdge(1, 3, value: 9)
  ..addEdge(1, 6, value: 14)
  ..addEdge(2, 3, value: 10)
  ..addEdge(2, 4, value: 15)
  ..addEdge(3, 4, value: 11)
  ..addEdge(3, 6, value: 2)
  ..addEdge(4, 5, value: 6)
  ..addEdge(5, 6, value: 9);

// Directed graph with negative edges.
// https://commons.wikimedia.org/wiki/File:Bellman%E2%80%93Ford_algorithm_example.gif
final bellmanFordGraph = Graph<String, int>.directed()
  ..addEdge('s', 't', value: 6)
  ..addEdge('s', 'y', value: 7)
  ..addEdge('t', 'x', value: 5)
  ..addEdge('t', 'y', value: 8)
  ..addEdge('t', 'z', value: -4)
  ..addEdge('y', 'x', value: -3)
  ..addEdge('y', 'z', value: 9)
  ..addEdge('x', 't', value: -2)
  ..addEdge('z', 'x', value: 7)
  ..addEdge('z', 's', value: 2);

void expectInvariants<V, E>(Graph<V, E> graph) {
  for (final vertex in graph.vertices) {
    for (final edge in graph.edgesOf(vertex)) {
      expect(graph.edges, contains(isEdge(edge.source, edge.target)));
      expect([edge.source, edge.target], contains(vertex));
    }
    for (final outgoingEdge in graph.outgoingEdgesOf(vertex)) {
      expect(outgoingEdge.source, vertex);
      expect(graph.predecessorsOf(outgoingEdge.target), contains(vertex));
      expect(graph.successorsOf(vertex), contains(outgoingEdge.target));
      expect(
        graph.edges,
        contains(isEdge(outgoingEdge.source, outgoingEdge.target)),
      );
    }
    for (final incomingEdge in graph.incomingEdgesOf(vertex)) {
      expect(incomingEdge.target, vertex);
      expect(graph.predecessorsOf(vertex), contains(incomingEdge.source));
      expect(graph.successorsOf(incomingEdge.source), contains(vertex));
      expect(
        graph.edges,
        contains(isEdge(incomingEdge.source, incomingEdge.target)),
      );
    }
  }
  for (final edge in graph.edges) {
    expect(graph.vertices, contains(edge.source));
    expect(graph.vertices, contains(edge.target));
  }
  expect(graph.vertexStrategy, isNotNull);
  expect(
    graph.toString(),
    allOf(contains('Graph'), contains('vertices: '), contains('edges: ')),
  );
}
