import 'dart:math';

import 'package:more/graph.dart';
import 'package:test/test.dart';

import 'utils/graph.dart';

void main() {
  group('connected', () {
    test('empty', () {
      final graph = Graph<int, String>.directed();
      final connected = graph.connected().toList();
      expect(connected, isEmpty);
    });
    test('single graph', () {
      final graph = Graph<int, String>.directed();
      graph.addEdge(42, 43, value: 'Hello World');
      final connected = graph.connected().toList();
      expect(connected, hasLength(1));
      expect(connected[0].vertices, unorderedEquals([42, 43]));
      expect(
        connected[0].edges,
        unorderedEquals([isEdge(42, 43, value: 'Hello World')]),
      );
    });
    test('two graphs', () {
      final graph = Graph<int, String>.directed();
      graph.addEdge(1, 2, value: 'Foo');
      graph.addEdge(3, 4, value: 'Bar');
      final connected = graph.connected().toList();
      expect(connected, hasLength(2));
      expect(connected[0].vertices, unorderedEquals([1, 2]));
      expect(connected[0].edges, unorderedEquals([isEdge(1, 2, value: 'Foo')]));
      expect(connected[1].vertices, unorderedEquals([3, 4]));
      expect(connected[1].edges, unorderedEquals([isEdge(3, 4, value: 'Bar')]));
    });
    test('incoming/outgoing edges', () {
      final graph = Graph<int, String>.directed();
      graph.addVertex(1);
      graph.addVertex(2);
      graph.addVertex(3);
      graph.addEdge(2, 1, value: 'Incoming');
      graph.addEdge(1, 3, value: 'Outgoing');
      final connected = graph.connected().toList();
      expect(connected, hasLength(1));
      expect(connected[0].vertices, unorderedEquals([1, 2, 3]));
      expect(
        connected[0].edges,
        unorderedEquals([
          isEdge(2, 1, value: 'Incoming'),
          isEdge(1, 3, value: 'Outgoing'),
        ]),
      );
    });
  });
  group('copy', () {
    test('directed', () {
      final graph = GraphFactory<int, void>(
        isDirected: true,
      ).fromSuccessors(cyclicGraphData);
      final copy = graph.copy();
      expect(copy.isDirected, true);
      expect(copy.vertexStrategy, graph.vertexStrategy);
      expect(copy.vertices, unorderedEquals(graph.vertices));
      expect(copy.edges, unorderedEquals(graph.edges));
    });
    test('undirected', () {
      final graph = GraphFactory<int, void>(
        isDirected: false,
      ).fromSuccessors(cyclicGraphData);
      final copy = graph.copy();
      expect(copy.isDirected, false);
      expect(copy.vertexStrategy, graph.vertexStrategy);
      expect(copy.vertices, unorderedEquals(graph.vertices));
      expect(copy.edges, unorderedEquals(graph.edges));
    });
    test('directed empty', () {
      final graph = GraphFactory<int, void>(
        isDirected: true,
      ).fromSuccessors(cyclicGraphData);
      final copy = graph.copy(empty: true);
      expect(copy.isDirected, true);
      expect(copy.vertexStrategy, graph.vertexStrategy);
      expect(copy.vertices, isEmpty);
      expect(copy.edges, isEmpty);
    });
    test('undirected empty', () {
      final graph = GraphFactory<int, void>(
        isDirected: false,
      ).fromSuccessors(cyclicGraphData);
      final copy = graph.copy(empty: true);
      expect(copy.isDirected, false);
      expect(copy.vertexStrategy, graph.vertexStrategy);
      expect(copy.vertices, isEmpty);
      expect(copy.edges, isEmpty);
    });
  });
  group('export', () {
    group('toDot', () {
      test('directed', () {
        final graph = GraphFactory<int, void>(
          isDirected: true,
        ).fromSuccessors(cyclicGraphData);
        expect(graph.toDot().split('\n'), [
          'digraph {',
          '  0 [label="0"];',
          '  1 [label="3"];',
          '  2 [label="1"];',
          '  3 [label="2"];',
          '  4 [label="4"];',
          '  0 -> 1;',
          '  1 -> 2;',
          '  1 -> 4;',
          '  2 -> 3;',
          '  2 -> 1;',
          '  3 -> 1;',
          '  4 -> 4;',
          '}',
        ]);
      });
      test('undirected', () {
        final graph = GraphFactory<int, void>(
          isDirected: false,
        ).fromSuccessors(cyclicGraphData);
        expect(graph.toDot().split('\n'), [
          'graph {',
          '  0 [label="0"];',
          '  1 [label="3"];',
          '  2 [label="1"];',
          '  3 [label="2"];',
          '  4 [label="4"];',
          '  0 -- 1;',
          '  1 -- 2;',
          '  1 -- 3;',
          '  1 -- 4;',
          '  2 -- 3;',
          '  4 -- 4;',
          '}',
        ]);
      });
      test('default attributes', () {
        final graph = GraphFactory<String, String>(
          edgeProvider: (a, b) => '$a to $b',
        ).fromPath(['a', 'b']);
        expect(graph.toDot().split('\n'), [
          'digraph {',
          '  0 [label=a];',
          '  1 [label=b];',
          '  0 -> 1 [label="a to b"];',
          '}',
        ]);
      });
      test('custom attributes', () {
        final graph = GraphFactory<String, String>(
          edgeProvider: (a, b) => '$a to $b',
        ).fromPath(['a', 'b']);
        expect(
          graph
              .toDot(
                graphAttributes: {'bgcolor': 'lightblue'},
                vertexLabel: (vertex) => 'Vertex $vertex',
                vertexAttributes: (vertex) => {'bgcolor': 'lightgreen'},
                edgeLabel: (edge) => 'Edge ${edge.value}',
                edgeAttributes: (edge) => {'color': 'turquoise'},
              )
              .split('\n'),
          [
            'digraph {',
            '  bgcolor=lightblue;',
            '  0 [label="Vertex a", bgcolor=lightgreen];',
            '  1 [label="Vertex b", bgcolor=lightgreen];',
            '  0 -> 1 [label="Edge a to b", color=turquoise];',
            '}',
          ],
        );
      });
    });
  });
  group('logical', () {
    group('union', () {
      test('disjoint', () {
        final a = GraphFactory<String, void>().fromPath(['a', 'b']);
        final b = GraphFactory<String, void>().fromPath(['c', 'd']);
        final result = a.union(b);
        expect(result.vertices, unorderedEquals(['a', 'b', 'c', 'd']));
        expect(
          result.edges,
          unorderedEquals([isEdge('a', 'b'), isEdge('c', 'd')]),
        );
      });
      test('shared vertex', () {
        final a = GraphFactory<String, void>().fromPath(['a', 'b']);
        final b = GraphFactory<String, void>().fromPath(['b', 'c']);
        final result = a.union(b);
        expect(result.vertices, unorderedEquals(['a', 'b', 'c']));
        expect(
          result.edges,
          unorderedEquals([isEdge('a', 'b'), isEdge('b', 'c')]),
        );
      });
      test('shared edge', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.union(b);
        expect(result.vertices, unorderedEquals([1, 2, 3, 4]));
        expect(
          result.edges,
          unorderedEquals([
            isEdge(1, 2, value: 'a'),
            isEdge(2, 3, value: 'b'),
            isEdge(3, 4, value: 'b'),
          ]),
        );
      });
      test('shared edge (custom merger)', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.union(
          b,
          edgeMerge: (source, target, a, b) => '$a, $b',
        );
        expect(result.vertices, unorderedEquals([1, 2, 3, 4]));
        expect(
          result.edges,
          unorderedEquals([
            isEdge(1, 2, value: 'a'),
            isEdge(2, 3, value: 'a, b'),
            isEdge(3, 4, value: 'b'),
          ]),
        );
      });
    });
    group('intersection', () {
      test('disjoint', () {
        final a = GraphFactory<String, void>().fromPath(['a', 'b']);
        final b = GraphFactory<String, void>().fromPath(['c', 'd']);
        final result = a.intersection(b);
        expect(result.vertices, isEmpty);
        expect(result.edges, isEmpty);
      });
      test('shared vertex', () {
        final a = GraphFactory<String, void>().fromPath(['a', 'b']);
        final b = GraphFactory<String, void>().fromPath(['b', 'c']);
        final result = a.intersection(b);
        expect(result.vertices, unorderedEquals(['b']));
        expect(result.edges, isEmpty);
      });
      test('shared edge', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.intersection(b);
        expect(result.vertices, unorderedEquals([2, 3]));
        expect(result.edges, [isEdge(2, 3, value: 'b')]);
      });
      test('shared edge (custom compare)', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.intersection(
          b,
          edgeCompare: (source, target, a, b) => a == b,
        );
        expect(result.vertices, unorderedEquals([2, 3]));
        expect(result.edges, isEmpty);
      });
      test('shared edge (custom merge)', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.intersection(
          b,
          edgeMerge: (source, target, a, b) => '$a, $b',
        );
        expect(result.vertices, unorderedEquals([2, 3]));
        expect(result.edges, [isEdge(2, 3, value: 'a, b')]);
      });
    });
    group('complement', () {
      test('simple undirected', () {
        final input = Graph<String, void>.undirected();
        input.addEdge('a', 'b');
        final result = input.complement();
        expect(result.vertices, unorderedEquals(['a', 'b']));
        expect(result.edges, isEmpty);
      });
      test('simple directed', () {
        final input = Graph<String, void>.directed();
        input.addEdge('a', 'b');
        final result = input.complement();
        expect(result.vertices, unorderedEquals(['a', 'b']));
        expect(result.edges, [isEdge('b', 'a')]);
      });
      test('simple directed (with self-loops)', () {
        final input = Graph<String, void>.directed();
        input.addEdge('a', 'b');
        final result = input.complement(allowSelfLoops: true);
        expect(result.vertices, unorderedEquals(['a', 'b']));
        expect(
          result.edges,
          unorderedEquals([
            isEdge('a', 'a'),
            isEdge('b', 'a'),
            isEdge('b', 'b'),
          ]),
        );
      });
      test('simple directed (with edge data)', () {
        final input = Graph<int, String>.directed();
        input.addEdge(1, 2, value: 'next');
        final result = input.complement(edge: (source, target) => 'prev');
        expect(result.vertices, unorderedEquals([1, 2]));
        expect(result.edges, [isEdge(2, 1, value: 'prev')]);
      });
    });
  });
  group('map', () {
    final graph = GraphFactory<int, Point<int>>(
      edgeProvider: Point.new,
    ).ring(vertexCount: 3);
    test('none', () {
      final result = graph.map<int, Point<int>>();
      expect(result.vertices, unorderedEquals([0, 1, 2]));
      expect(
        result.edges,
        unorderedEquals([
          isEdge(0, 1, value: const Point(0, 1)),
          isEdge(1, 2, value: const Point(1, 2)),
          isEdge(2, 0, value: const Point(2, 0)),
        ]),
      );
      expectInvariants(result);
    });
    test('vertex only', () {
      final result = graph.map<String, Point<int>>(
        vertex: (vertex) => vertex.toString(),
      );
      expect(result.vertices, unorderedEquals(['0', '1', '2']));
      expect(
        result.edges,
        unorderedEquals([
          isEdge('0', '1', value: const Point(0, 1)),
          isEdge('1', '2', value: const Point(1, 2)),
          isEdge('2', '0', value: const Point(2, 0)),
        ]),
      );
      expectInvariants(result);
    });
    test('edge only', () {
      final result = graph.map<int, String>(
        edge: (edge) => '${edge.value.x} -> ${edge.value.y}',
      );
      expect(result.vertices, unorderedEquals([0, 1, 2]));
      expect(
        result.edges,
        unorderedEquals([
          isEdge(0, 1, value: '0 -> 1'),
          isEdge(1, 2, value: '1 -> 2'),
          isEdge(2, 0, value: '2 -> 0'),
        ]),
      );
      expectInvariants(result);
    });
    test('vertex and edge', () {
      final result = graph.map<String, String>(
        vertex: (vertex) => vertex.toString(),
        edge: (edge) => '${edge.value.x} -> ${edge.value.y}',
      );
      expect(result.vertices, unorderedEquals(['0', '1', '2']));
      expect(
        result.edges,
        unorderedEquals([
          isEdge('0', '1', value: '0 -> 1'),
          isEdge('1', '2', value: '1 -> 2'),
          isEdge('2', '0', value: '2 -> 0'),
        ]),
      );
      expectInvariants(result);
    });
    test('vertex and edge', () {
      final graph = GraphFactory<int, Point<int>>(
        edgeProvider: Point.new,
        isDirected: false,
      ).ring(vertexCount: 3);
      final result = graph.map<String, String>(
        vertex: (vertex) => vertex.toString(),
        edge: (edge) => '${edge.value.x} <-> ${edge.value.y}',
      );
      expect(result.vertices, unorderedEquals(['0', '1', '2']));
      expect(
        result.edges,
        unorderedEquals([
          isEdge('0', '1', value: '0 <-> 1'),
          isEdge('0', '2', value: '2 <-> 0'),
          isEdge('1', '0', value: '0 <-> 1'),
          isEdge('1', '2', value: '1 <-> 2'),
          isEdge('2', '0', value: '2 <-> 0'),
          isEdge('2', '1', value: '1 <-> 2'),
        ]),
      );
      expectInvariants(result);
    });
  });
}
