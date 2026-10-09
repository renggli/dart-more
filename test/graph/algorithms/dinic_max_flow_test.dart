import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

void main() {
  group('dinicMaxFlow', () {
    test('line with default edge capacity', () {
      final graph = GraphFactory<String, void>().fromPath(['A', 'B', 'C', 'D']);
      final flow = graph.maxFlow();
      check(flow('A', 'D')).equals(1);
    });
    test('line with custom edge capacity', () {
      final graph = GraphFactory<String, void>().fromPath(['A', 'B', 'C', 'D']);
      final flow = graph.maxFlow(edgeCapacity: constantFunction2(2));
      check(flow('A', 'D')).equals(2);
    });
    test('line with standard edge capacity', () {
      final graph = GraphFactory<String, num>(edgeProvider: (a, b) => 3)
          .fromPath(['A', 'B', 'C', 'D']);
      final flow = graph.maxFlow();
      check(flow('A', 'D')).equals(3);
    });
    test('undirected graph', () {
      final graph = GraphFactory<int, void>(isDirected: false)
          .ring(vertexCount: 10);
      final flow = graph.maxFlow();
      check(flow(0, 4)).equals(2);
    });
    test('error', () {
      final graph = GraphFactory<int, void>().path(vertexCount: 3);
      final flow = graph.maxFlow();
      check(() => flow(0, 4)).throws<ArgumentError>();
      check(() => flow(4, 0)).throws<ArgumentError>();
    });
    test('example 1', () {
      final graph = Graph<String, int>(isDirected: true)
        ..addEdge('S', '1', value: 2)
        ..addEdge('S', '2', value: 2)
        ..addEdge('1', 'E', value: 2)
        ..addEdge('2', 'E', value: 2)
        ..addEdge('1', '2', value: 1);
      final flow = graph.maxFlow();
      check(flow('S', 'E')).equals(4);
      check(flow('E', 'S')).equals(0);
    });
    test('example 2', () {
      final graph = Graph<int, int>(isDirected: true)
        ..addEdge(0, 1, value: 16)
        ..addEdge(0, 2, value: 13)
        ..addEdge(1, 2, value: 10)
        ..addEdge(1, 3, value: 12)
        ..addEdge(2, 1, value: 4)
        ..addEdge(2, 4, value: 14)
        ..addEdge(3, 2, value: 9)
        ..addEdge(3, 5, value: 20)
        ..addEdge(4, 3, value: 7)
        ..addEdge(4, 5, value: 4);
      final flow = graph.maxFlow();
      check(flow(0, 5)).equals(23);
      check(flow(5, 0)).equals(0);
    });
    test('example 3', () {
      final graph = Graph<String, int>(isDirected: true)
        ..addEdge('A', 'B', value: 3)
        ..addEdge('A', 'D', value: 3)
        ..addEdge('B', 'C', value: 4)
        ..addEdge('C', 'A', value: 3)
        ..addEdge('C', 'D', value: 1)
        ..addEdge('C', 'E', value: 2)
        ..addEdge('D', 'E', value: 2)
        ..addEdge('D', 'F', value: 6)
        ..addEdge('E', 'B', value: 1)
        ..addEdge('E', 'G', value: 1)
        ..addEdge('F', 'G', value: 9);
      final flow = graph.maxFlow();
      check(flow('A', 'G')).equals(5);
      check(flow('G', 'A')).equals(0);
    });
    test('example 4', () {
      final graph = Graph<String, int>(isDirected: true)
        ..addEdge('s', 'a', value: 15)
        ..addEdge('s', 'c', value: 4)
        ..addEdge('a', 'b', value: 12)
        ..addEdge('b', 'c', value: 3)
        ..addEdge('b', 't', value: 7)
        ..addEdge('c', 'd', value: 10)
        ..addEdge('d', 'a', value: 5)
        ..addEdge('d', 't', value: 10);
      final flow = graph.maxFlow();
      check(flow('s', 't')).equals(14);
      check(flow('t', 's')).equals(0);
    });
  });
}
