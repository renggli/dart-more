import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('connected', () {
    test('empty', () {
      final graph = Graph<int, String>(isDirected: true);
      final connected = graph.connected().toList();
      check(connected).isEmpty();
    });
    test('single graph', () {
      final graph = Graph<int, String>(isDirected: true);
      graph.addEdge(42, 43, value: 'Hello World');
      final connected = graph.connected().toList();
      check(connected).length.equals(1);
      check(connected[0].vertices).unorderedEquals([42, 43]);
      check(connected[0].edges)
          .unorderedMatches([isEdge(42, 43, value: 'Hello World')]);
    });
    test('two graphs', () {
      final graph = Graph<int, String>(isDirected: true);
      graph.addEdge(1, 2, value: 'Foo');
      graph.addEdge(3, 4, value: 'Bar');
      final connected = graph.connected().toList();
      check(connected).length.equals(2);
      check(connected[0].vertices).unorderedEquals([1, 2]);
      check(connected[0].edges).unorderedMatches([isEdge(1, 2, value: 'Foo')]);
      check(connected[1].vertices).unorderedEquals([3, 4]);
      check(connected[1].edges).unorderedMatches([isEdge(3, 4, value: 'Bar')]);
    });
    test('incoming/outgoing edges', () {
      final graph = Graph<int, String>(isDirected: true);
      graph.addVertex(1);
      graph.addVertex(2);
      graph.addVertex(3);
      graph.addEdge(2, 1, value: 'Incoming');
      graph.addEdge(1, 3, value: 'Outgoing');
      final connected = graph.connected().toList();
      check(connected).length.equals(1);
      check(connected[0].vertices).unorderedEquals([1, 2, 3]);
      check(connected[0].edges).unorderedMatches([
        isEdge(2, 1, value: 'Incoming'),
        isEdge(1, 3, value: 'Outgoing'),
      ]);
    });
    test('isolated vertex', () {
      final graph = Graph<int, String>(isDirected: true);
      graph.addVertex(1);
      final connected = graph.connected().toList();
      check(connected).length.equals(1);
      check(connected[0].vertices).unorderedEquals([1]);
      check(connected[0].edges).isEmpty();
    });
    test('isolated vertices and component', () {
      final graph = Graph<int, String>(isDirected: true);
      graph.addVertex(1);
      graph.addEdge(2, 3, value: 'Edge');
      graph.addVertex(4);
      final connected = graph.connected().toList();
      check(connected).length.equals(3);
      final components = connected.map((g) => g.vertices.toSet()).toList();
      check(components).unorderedMatches([
        (it) => it.deepEquals({1}),
        (it) => it.deepEquals({2, 3}),
        (it) => it.deepEquals({4}),
      ]);
    });
  });
}
