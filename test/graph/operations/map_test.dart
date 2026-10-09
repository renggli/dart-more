import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('map', () {
    final graph = GraphFactory<int, Point<int>>(edgeProvider: Point.new)
        .ring(vertexCount: 3);
    test('none', () {
      final result = graph.map<int, Point<int>>();
      check(result.vertices).unorderedEquals([0, 1, 2]);
      check(result.edges).unorderedMatches([
        isEdge(0, 1, value: const Point(0, 1)),
        isEdge(1, 2, value: const Point(1, 2)),
        isEdge(2, 0, value: const Point(2, 0)),
      ]);
      expectInvariants(result);
    });
    test('vertex only', () {
      final result = graph.map<String, Point<int>>(
        vertex: (vertex) => vertex.toString(),
      );
      check(result.vertices).unorderedEquals(['0', '1', '2']);
      check(result.edges).unorderedMatches([
        isEdge('0', '1', value: const Point(0, 1)),
        isEdge('1', '2', value: const Point(1, 2)),
        isEdge('2', '0', value: const Point(2, 0)),
      ]);
      expectInvariants(result);
    });
    test('edge only', () {
      final result = graph.map<int, String>(
        edge: (edge) => '${edge.value.x} -> ${edge.value.y}',
      );
      check(result.vertices).unorderedEquals([0, 1, 2]);
      check(result.edges).unorderedMatches([
        isEdge(0, 1, value: '0 -> 1'),
        isEdge(1, 2, value: '1 -> 2'),
        isEdge(2, 0, value: '2 -> 0'),
      ]);
      expectInvariants(result);
    });
    test('vertex and edge', () {
      final result = graph.map<String, String>(
        vertex: (vertex) => vertex.toString(),
        edge: (edge) => '${edge.value.x} -> ${edge.value.y}',
      );
      check(result.vertices).unorderedEquals(['0', '1', '2']);
      check(result.edges).unorderedMatches([
        isEdge('0', '1', value: '0 -> 1'),
        isEdge('1', '2', value: '1 -> 2'),
        isEdge('2', '0', value: '2 -> 0'),
      ]);
      expectInvariants(result);
    });
    test('vertex and edge undirected', () {
      final graph = GraphFactory<int, Point<int>>(
        edgeProvider: Point.new,
        isDirected: false,
      ).ring(vertexCount: 3);
      final result = graph.map<String, String>(
        vertex: (vertex) => vertex.toString(),
        edge: (edge) => '${edge.value.x} <-> ${edge.value.y}',
      );
      check(result.vertices).unorderedEquals(['0', '1', '2']);
      check(result.edges).unorderedMatches([
        isEdge('0', '1', value: '0 <-> 1'),
        isEdge('0', '2', value: '2 <-> 0'),
        isEdge('1', '0', value: '0 <-> 1'),
        isEdge('1', '2', value: '1 <-> 2'),
        isEdge('2', '0', value: '2 <-> 0'),
        isEdge('2', '1', value: '1 <-> 2'),
      ]);
      expectInvariants(result);
    });
  });
}
