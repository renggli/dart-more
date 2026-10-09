import 'package:checks/checks.dart';
import 'package:more/graph.dart';

const _unspecified = Object();

Condition<Edge<V, E>> isEdge<V, E>(
  Object? source,
  Object? target, {
  Object? value = _unspecified,
  bool? isDirected,
}) => (edge) {
  edge
    ..has((e) => e.source, 'source').equals(source as V)
    ..has((e) => e.target, 'target').equals(target as V)
    ..has((e) => e.toString(), 'toString').contains('Edge');
  if (value != _unspecified) {
    if (value is Iterable<Object?>) {
      edge
          .has((e) => e.value, 'value')
          .isA<Iterable<Object?>>()
          .deepEquals(value);
    } else if (value is Map) {
      edge
          .has((e) => e.value, 'value')
          .isA<Map<Object?, Object?>>()
          .deepEquals(value);
    } else {
      edge.has((e) => e.value, 'value').equals(value as E);
    }
  }
  if (isDirected != null) {
    edge.has((e) => e.isDirected, 'isDirected').equals(isDirected);
  }
};

Condition<Path<V, E>> isPath<V, E>({
  Object? source = _unspecified,
  Object? target = _unspecified,
  Object? vertices = _unspecified,
  Object? values = _unspecified,
  Object? edges = _unspecified,
  Object? cost = _unspecified,
}) => (path) {
  path.has((p) => p.toString(), 'toString').contains('Path');
  if (source != _unspecified) {
    path.has((p) => p.source, 'source').equals(source as V);
  }
  if (target != _unspecified) {
    path.has((p) => p.target, 'target').equals(target as V);
  }
  if (vertices != _unspecified) {
    final v = vertices as Iterable<Object?>;
    path.has((p) => p.vertices, 'vertices').which((it) {
      it.deepEquals(v);
      it.length.equals(v.toSet().length);
    });
  }
  if (values != _unspecified) {
    final val = values as Iterable<Object?>;
    path.has((p) => p.values, 'values').which((it) {
      it.deepEquals(val);
      if (vertices case final Iterable<Object?> v) {
        it.length.equals(v.length - 1);
      }
    });
  }
  if (edges != _unspecified) {
    path.has((p) => p.edges, 'edges').deepEquals(edges as Iterable<Object?>);
  }
  if (cost != _unspecified) {
    path.isA<Path<V, num>>().has((p) => p.cost, 'cost').equals(cost as num);
  }
};

extension EdgeChecks<V, E> on Subject<Edge<V, E>> {
  Subject<V> get source => has((e) => e.source, 'source');
  Subject<V> get target => has((e) => e.target, 'target');
  Subject<E> get value => has((e) => e.value, 'value');
  Subject<bool> get isDirected => has((e) => e.isDirected, 'isDirected');
}

extension PathChecks<V, E> on Subject<Path<V, E>> {
  Subject<V> get source => has((p) => p.source, 'source');
  Subject<V> get target => has((p) => p.target, 'target');
  Subject<List<V>> get vertices => has((p) => p.vertices, 'vertices');
  Subject<List<E>> get values => has((p) => p.values, 'values');
  Subject<Iterable<Edge<V, E>>> get edges => has((p) => p.edges, 'edges');
}

extension NumericPathChecks<V> on Subject<Path<V, num>> {
  Subject<num> get cost => has((p) => p.cost, 'cost');
}

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
Graph<int, int> get dijkstraGraph => Graph<int, int>(isDirected: false)
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
Graph<String, int> get bellmanFordGraph => Graph<String, int>(isDirected: true)
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
      check(graph.edges).any(isEdge(edge.source, edge.target));
      check([edge.source, edge.target]).contains(vertex);
    }
    for (final outgoingEdge in graph.outgoingEdgesOf(vertex)) {
      check(outgoingEdge.source).equals(vertex);
      check(graph.predecessorsOf(outgoingEdge.target)).contains(vertex);
      check(graph.successorsOf(vertex)).contains(outgoingEdge.target);
      check(graph.edges).any(isEdge(outgoingEdge.source, outgoingEdge.target));
    }
    for (final incomingEdge in graph.incomingEdgesOf(vertex)) {
      check(incomingEdge.target).equals(vertex);
      check(graph.predecessorsOf(vertex)).contains(incomingEdge.source);
      check(graph.successorsOf(incomingEdge.source)).contains(vertex);
      check(graph.edges).any(isEdge(incomingEdge.source, incomingEdge.target));
    }
  }
  for (final edge in graph.edges) {
    check(graph.vertices).contains(edge.source);
    check(graph.vertices).contains(edge.target);
  }
  check(graph.vertexStrategy).isNotNull();
  check(graph.toString())
    ..contains('Graph')
    ..contains('vertices: ')
    ..contains('edges: ');
}
