import 'dart:math';

import 'package:meta/meta.dart';
import 'package:more/collection.dart';
import 'package:more/functional.dart';
import 'package:more/graph.dart';
import 'package:more/math.dart';
import 'package:test/test.dart';

@optionalTypeArgs
Matcher isEdge<E, V>(
  dynamic source,
  dynamic target, {
  dynamic value = anything,
  dynamic isDirected = anything,
}) =>
    isA<Edge<E, V>>()
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
}) =>
    isA<Path<V, E>>()
        .having((path) => path.source, 'source', source)
        .having((path) => path.target, 'target', target)
        .having((path) => path.vertices, 'vertices', vertices)
        .having((path) => path.vertices.length == path.vertices.toSet().length,
            'vertices (unique)', isTrue)
        .having((path) => path.values, 'values', values)
        .having((path) => path.values.length == path.vertices.length - 1,
            'values (for each edge)', isTrue)
        .having((path) => path.edges, 'edges', edges)
        .having(
            (path) => cost != anything ? (path as Path<void, num>).cost : num,
            'cost',
            cost)
        .having((path) => path.toString(), 'toString', contains('Path'));

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
      expect(graph.edges,
          contains(isEdge(outgoingEdge.source, outgoingEdge.target)));
    }
    for (final incomingEdge in graph.incomingEdgesOf(vertex)) {
      expect(incomingEdge.target, vertex);
      expect(graph.predecessorsOf(vertex), contains(incomingEdge.source));
      expect(graph.successorsOf(incomingEdge.source), contains(vertex));
      expect(graph.edges,
          contains(isEdge(incomingEdge.source, incomingEdge.target)));
    }
  }
  for (final edge in graph.edges) {
    expect(graph.vertices, contains(edge.source));
    expect(graph.vertices, contains(edge.target));
  }
  expect(graph.vertexStrategy, isNotNull);
  expect(
      graph.toString(),
      allOf(
        contains('Graph'),
        contains('vertices: '),
        contains('edges: '),
      ));
}

void main() {
  group('strategy', () {
    group('object', () {
      final strategy = StorageStrategy<String>.object();
      test('set', () {
        final set = strategy.createSet();
        set.addAll(['foo', 'bar', 'foo']);
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['foo', 'bar']));
      });
      test('map', () {
        final map = strategy.createMap<int>();
        map['foo'] = 42;
        map['bar'] = 43;
        expect(map, hasLength(2));
        expect(map, {'foo': 42, 'bar': 43});
      });
    });
    group('identity', () {
      final strategy = StorageStrategy<Point<int>>.identity();
      final first = const Point(1, 2),
          second = const Point(2, 3) - const Point(1, 1);
      test('set', () {
        final set = strategy.createSet();
        set.addAll([first, second]);
        expect(set, unorderedEquals([first, second]));
      });
      test('map', () {
        final map = strategy.createMap<int>();
        map[first] = 42;
        map[second] = 43;
        expect(map.keys, unorderedEquals([first, second]));
        expect(map.values, unorderedEquals([42, 43]));
      });
    });
    group('integer', () {
      final strategy = StorageStrategy.integer();
      test('set', () {
        final set = strategy.createSet();
        expect(set.add(42), isTrue);
        expect(set.add(-43), isTrue);
        expect(set.add(42), isFalse);
        expect(set.contains(42), isTrue);
        expect(set.contains(41), isFalse);
        expect(set.contains('foo' as dynamic), isFalse);
        expect(set, unorderedEquals([42, -43]));
        expect(set.length, 2);
        expect(() => set.lookup(42), throwsUnimplementedError);
        expect(set.remove(42), isTrue);
        expect(set.remove(42), isFalse);
        expect(set.remove('foo' as dynamic), isFalse);
        expect(set.toSet(), {-43});
        set.clear();
        expect(set, isEmpty);
      });
      test('map', () {
        final map = strategy.createMap<String>();
        map[-42] = 'foo';
        map[43] = 'bar';
        map[43] = 'baz';
        expect(map[-42], 'foo');
        expect(map[43], 'baz');
        expect(map[44], isNull);
        expect(map['foo' as dynamic], isNull);
        expect(map.containsKey(-42), isTrue);
        expect(map.containsKey(43), isTrue);
        expect(map.containsKey(44), isFalse);
        expect(map.keys, unorderedEquals([-42, 43]));
        expect(map.values, unorderedEquals(['foo', 'baz']));
        expect(map.remove(-42), 'foo');
        expect(map.remove(-42), isNull);
        expect(map.remove('foo' as dynamic), isNull);
        map.clear();
        expect(map, isEmpty);
      });
      test('map (nullable)', () {
        final map = strategy.createMap<String?>();
        map[-3] = 'foo';
        map[2] = 'bar';
        map[2] = null;
        expect(map[-3], 'foo');
        expect(map[2], isNull);
        expect(map[3], isNull);
        expect(map['foo' as dynamic], isNull);
        expect(map.containsKey(-3), isTrue);
        expect(map.containsKey(2), isTrue);
        expect(map.containsKey(3), isFalse);
        expect(map.keys, unorderedEquals([2, -3]));
        expect(map.values, unorderedEquals([null, 'foo']));
        expect(map.remove(2), isNull);
        expect(map.remove('foo' as dynamic), isNull);
        map.clear();
        expect(map, isEmpty);
      });
    });
    group('positive integer', () {
      final strategy = StorageStrategy.positiveInteger();
      test('set', () {
        final set = strategy.createSet();
        expect(set.add(42), isTrue);
        expect(set.add(43), isTrue);
        expect(set.add(42), isFalse);
        expect(set.contains(42), isTrue);
        expect(set.contains(41), isFalse);
        expect(set.contains('foo' as dynamic), isFalse);
        expect(set, unorderedEquals([42, 43]));
        expect(set.length, 2);
        expect(() => set.lookup(42), throwsUnimplementedError);
        expect(set.remove(42), isTrue);
        expect(set.remove(42), isFalse);
        expect(set.remove('foo' as dynamic), isFalse);
        expect(set.toSet(), {43});
        set.clear();
        expect(set, isEmpty);
      });
      test('map', () {
        final map = strategy.createMap<String>();
        map[42] = 'foo';
        map[43] = 'bar';
        map[43] = 'baz';
        expect(map[42], 'foo');
        expect(map[43], 'baz');
        expect(map[44], isNull);
        expect(map['foo' as dynamic], isNull);
        expect(map.containsKey(42), isTrue);
        expect(map.containsKey(43), isTrue);
        expect(map.containsKey(44), isFalse);
        expect(map.keys, unorderedEquals([42, 43]));
        expect(map.values, unorderedEquals(['foo', 'baz']));
        expect(map.remove(42), 'foo');
        expect(map.remove(42), isNull);
        expect(map.remove('foo' as dynamic), isNull);
        map.clear();
        expect(map, isEmpty);
      });
      test('map (nullable)', () {
        final map = strategy.createMap<String?>();
        map[3] = 'foo';
        map[2] = 'bar';
        map[2] = null;
        expect(map[3], 'foo');
        expect(map[2], isNull);
        expect(map[1], isNull);
        expect(map['foo' as dynamic], isNull);
        expect(map.containsKey(3), isTrue);
        expect(map.containsKey(2), isTrue);
        expect(map.containsKey(1), isFalse);
        expect(map.keys, unorderedEquals([2, 3]));
        expect(map.values, unorderedEquals([null, 'foo']));
        expect(map.remove(2), isNull);
        expect(map.remove('foo' as dynamic), isNull);
        map.clear();
        expect(map, isEmpty);
      });
    });
  });
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
          graph.addEdge('Hello', 'World', value: 42);
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, [
            isEdge('Hello', 'World', value: 42, isDirected: true),
          ]);
          expect(graph.edges.single.value, 42);
          expectInvariants(graph);
        });
        test('add self-edge', () {
          final graph = Graph<String, int>.directed();
          graph.addEdge('Myself', 'Myself', value: 42);
          expect(graph.vertices, unorderedEquals(['Myself']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('Myself', 'Myself', value: 42, isDirected: true),
              ]));
          expectInvariants(graph);
        });
        test('put edge', () {
          final graph = Graph<String, List<int>>.directed();
          graph.putEdge('a', 'b', () => []).add(1);
          graph.putEdge('b', 'a', () => []).add(2);
          expect(graph.vertices, unorderedEquals(['a', 'b']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('a', 'b', value: [1], isDirected: true),
                isEdge('b', 'a', value: [2], isDirected: true),
              ]));
          expectInvariants(graph);
        });
        test('remove edge', () {
          final graph = Graph<String, void>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, void>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, void>.directed();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
      });
      group('querying', () {
        final graph = Graph<int, String>.directed()
          ..addEdge(0, 1, value: 'a')
          ..addEdge(1, 2, value: 'b');
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
                isEdge(0, 1, value: 'a', isDirected: true),
                isEdge(1, 2, value: 'b', isDirected: true),
              ]));
        });
        test('edgesOf', () {
          expect(graph.edgesOf(0), [
            isEdge(0, 1, value: 'a', isDirected: true),
          ]);
          expect(
              graph.edgesOf(1),
              unorderedEquals([
                isEdge(0, 1, value: 'a', isDirected: true),
                isEdge(1, 2, value: 'b', isDirected: true),
              ]));
          expect(graph.edgesOf(2), [
            isEdge(1, 2, value: 'b', isDirected: true),
          ]);
        });
        test('incomingEdgesOf', () {
          expect(graph.incomingEdgesOf(0), isEmpty);
          expect(graph.incomingEdgesOf(1), [
            isEdge(0, 1, value: 'a', isDirected: true),
          ]);
          expect(graph.incomingEdgesOf(2), [
            isEdge(1, 2, value: 'b', isDirected: true),
          ]);
        });
        test('outgoingEdgesOf', () {
          expect(graph.outgoingEdgesOf(0), [
            isEdge(0, 1, value: 'a', isDirected: true),
          ]);
          expect(graph.outgoingEdgesOf(1), [
            isEdge(1, 2, value: 'b', isDirected: true),
          ]);
          expect(graph.outgoingEdgesOf(2), isEmpty);
        });
        test('getEdge', () {
          expect(
              graph.getEdge(0, 1), isEdge(0, 1, value: 'a', isDirected: true));
          expect(graph.getEdge(1, 0), isNull);
          expect(
              graph.getEdge(1, 2), isEdge(1, 2, value: 'b', isDirected: true));
          expect(graph.getEdge(2, 1), isNull);
          expect(graph.getEdge(0, 2), isNull);
          expect(graph.getEdge(2, 0), isNull);
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
      test('reversing directed', () {
        final graph = Graph<String, void>.directed();
        graph.addEdge('a', 'b');
        final reversedGraph = graph.reversed;
        expect(reversedGraph.reversed, same(graph));
      });
      test('reversing undirected', () {
        final graph = Graph<String, void>.undirected();
        graph.addEdge('a', 'b');
        final reversedGraph = graph.reversed;
        expect(reversedGraph, same(graph));
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
          graph.addEdge('Hello', 'World', value: 42);
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, [
            isEdge('Hello', 'World', value: 42, isDirected: true),
          ]);
          expect(graph.edges.single.value, 42);
          expectInvariants(graph);
        });
        test('add self-edge', () {
          final graph = Graph<String, int>.directed().reversed;
          graph.addEdge('Myself', 'Myself', value: 42);
          expect(graph.vertices, unorderedEquals(['Myself']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('Myself', 'Myself', value: 42, isDirected: true),
              ]));
          expectInvariants(graph);
        });
        test('put edge', () {
          final graph = Graph<String, List<int>>.directed().reversed;
          graph.putEdge('a', 'b', () => []).add(1);
          graph.putEdge('b', 'a', () => []).add(2);
          expect(graph.vertices, unorderedEquals(['a', 'b']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('a', 'b', value: [1], isDirected: true),
                isEdge('b', 'a', value: [2], isDirected: true),
              ]));
          expectInvariants(graph);
        });
        test('remove edge', () {
          final graph = Graph<String, void>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, void>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, void>.directed().reversed;
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
      });
      group('querying', () {
        final directed = Graph<int, String>.directed()
          ..addEdge(0, 1, value: 'a')
          ..addEdge(1, 2, value: 'b');
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
                isEdge(1, 0, value: 'a', isDirected: true),
                isEdge(2, 1, value: 'b', isDirected: true),
              ]));
        });
        test('edgesOf', () {
          expect(graph.edgesOf(0), [
            isEdge(1, 0, value: 'a', isDirected: true),
          ]);
          expect(
              graph.edgesOf(1),
              unorderedEquals([
                isEdge(1, 0, value: 'a', isDirected: true),
                isEdge(2, 1, value: 'b', isDirected: true),
              ]));
          expect(graph.edgesOf(2), [
            isEdge(2, 1, value: 'b', isDirected: true),
          ]);
        });
        test('incomingEdgesOf', () {
          expect(graph.incomingEdgesOf(0), [
            isEdge(1, 0, value: 'a', isDirected: true),
          ]);
          expect(graph.incomingEdgesOf(1), [
            isEdge(2, 1, value: 'b', isDirected: true),
          ]);
          expect(graph.incomingEdgesOf(2), isEmpty);
        });
        test('outgoingEdgesOf', () {
          expect(graph.outgoingEdgesOf(0), isEmpty);
          expect(graph.outgoingEdgesOf(1), [
            isEdge(1, 0, value: 'a', isDirected: true),
          ]);
          expect(graph.outgoingEdgesOf(2), [
            isEdge(2, 1, value: 'b', isDirected: true),
          ]);
        });
        test('getEdge', () {
          expect(graph.getEdge(0, 1), isNull);
          expect(
              graph.getEdge(1, 0), isEdge(1, 0, value: 'a', isDirected: true));
          expect(graph.getEdge(1, 2), isNull);
          expect(
              graph.getEdge(2, 1), isEdge(2, 1, value: 'b', isDirected: true));
          expect(graph.getEdge(0, 2), isNull);
          expect(graph.getEdge(2, 0), isNull);
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
          graph.addEdge('Hello', 'World', value: 42);
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('Hello', 'World', value: 42, isDirected: false),
                isEdge('World', 'Hello', value: 42, isDirected: false),
              ]));
          expectInvariants(graph);
        });
        test('add self-edge', () {
          final graph = Graph<String, int>.undirected();
          graph.addEdge('Myself', 'Myself', value: 42);
          expect(graph.vertices, unorderedEquals(['Myself']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('Myself', 'Myself', value: 42, isDirected: false),
              ]));
          expectInvariants(graph);
        });
        test('put edge', () {
          final graph = Graph<String, List<int>>.undirected();
          graph.putEdge('a', 'b', () => []).add(1);
          graph.putEdge('b', 'a', () => []).add(2);
          expect(graph.vertices, unorderedEquals(['a', 'b']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('a', 'b', value: [1, 2], isDirected: false),
                isEdge('b', 'a', value: [1, 2], isDirected: false),
              ]));
          expectInvariants(graph);
        });
        test('remove edge', () {
          final graph = Graph<String, void>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeEdge('Hello', 'World');
          expect(graph.vertices, unorderedEquals(['Hello', 'World']));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove first vertex', () {
          final graph = Graph<String, void>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('Hello');
          expect(graph.vertices, ['World']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('add edge, remove second vertex', () {
          final graph = Graph<String, void>.undirected();
          graph.addEdge('Hello', 'World');
          graph.removeVertex('World');
          expect(graph.vertices, ['Hello']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
      });
      group('querying', () {
        final graph = Graph<int, String>.undirected()
          ..addEdge(0, 1, value: 'a')
          ..addEdge(1, 2, value: 'b');
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
                isEdge(0, 1, value: 'a', isDirected: false),
                isEdge(1, 0, value: 'a', isDirected: false),
                isEdge(1, 2, value: 'b', isDirected: false),
                isEdge(2, 1, value: 'b', isDirected: false),
              ]));
        });
        test('edgesOf', () {
          expect(graph.edgesOf(0), [
            isEdge(0, 1, value: 'a', isDirected: false),
          ]);
          expect(
              graph.edgesOf(1),
              unorderedEquals([
                isEdge(1, 0, value: 'a', isDirected: false),
                isEdge(1, 2, value: 'b', isDirected: false),
              ]));
          expect(graph.edgesOf(2), [
            isEdge(2, 1, value: 'b', isDirected: false),
          ]);
        });
        test('incomingEdgesOf', () {
          expect(graph.incomingEdgesOf(0), [
            isEdge(1, 0, value: 'a', isDirected: false),
          ]);
          expect(
              graph.incomingEdgesOf(1),
              unorderedEquals([
                isEdge(0, 1, value: 'a', isDirected: false),
                isEdge(2, 1, value: 'b', isDirected: false),
              ]));
          expect(graph.incomingEdgesOf(2), [
            isEdge(1, 2, value: 'b'),
          ]);
        });
        test('outgoingEdgesOf', () {
          expect(graph.outgoingEdgesOf(0), [
            isEdge(0, 1, value: 'a', isDirected: false),
          ]);
          expect(
              graph.outgoingEdgesOf(1),
              unorderedEquals([
                isEdge(1, 0, value: 'a', isDirected: false),
                isEdge(1, 2, value: 'b', isDirected: false),
              ]));
          expect(graph.outgoingEdgesOf(2), [
            isEdge(2, 1, value: 'b', isDirected: false),
          ]);
        });
        test('getEdge', () {
          expect(
              graph.getEdge(0, 1), isEdge(0, 1, value: 'a', isDirected: false));
          expect(
              graph.getEdge(1, 0), isEdge(1, 0, value: 'a', isDirected: false));
          expect(
              graph.getEdge(1, 2), isEdge(1, 2, value: 'b', isDirected: false));
          expect(
              graph.getEdge(2, 1), isEdge(2, 1, value: 'b', isDirected: false));
          expect(graph.getEdge(0, 2), isNull);
          expect(graph.getEdge(2, 0), isNull);
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
    group('forwarding', () {
      test('directed', () {
        final base = Graph<String, int>.directed();
        final graph = ForwardingGraph<String, int>(base);
        expect(graph.isDirected, isTrue);
        expect(graph.isUnmodifiable, isFalse);
        expect(graph.vertexStrategy, isNotNull);
        graph.addVertex('a');
        graph.addEdge('b', 'c', value: 42);
        expectInvariants(graph);
        expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
        expect(graph.edges, [isEdge('b', 'c', value: 42, isDirected: true)]);
        expect(graph.edgesOf('b'),
            [isEdge('b', 'c', value: 42, isDirected: true)]);
        expect(graph.incomingEdgesOf('c'),
            [isEdge('b', 'c', value: 42, isDirected: true)]);
        expect(graph.outgoingEdgesOf('b'),
            [isEdge('b', 'c', value: 42, isDirected: true)]);
        expect(graph.getEdge('b', 'c'),
            isEdge('b', 'c', value: 42, isDirected: true));
        expect(graph.neighboursOf('b'), ['c']);
        expect(graph.predecessorsOf('c'), ['b']);
        expect(graph.successorsOf('b'), ['c']);
        graph.removeEdge('b', 'c');
        graph.removeVertex('a');
      });
      test('undirected', () {
        final base = Graph<String, int>.undirected();
        final graph = ForwardingGraph<String, int>(base);
        expect(graph.isDirected, isFalse);
        expect(graph.isUnmodifiable, isFalse);
        expect(graph.vertexStrategy, isNotNull);
        graph.addVertex('a');
        graph.addEdge('b', 'c', value: 42);
        expectInvariants(graph);
        expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge('b', 'c', value: 42, isDirected: false),
              isEdge('c', 'b', value: 42, isDirected: false),
            ]));
        expect(graph.edgesOf('b'),
            [isEdge('b', 'c', value: 42, isDirected: false)]);
        expect(graph.incomingEdgesOf('c'),
            [isEdge('b', 'c', value: 42, isDirected: false)]);
        expect(graph.outgoingEdgesOf('b'),
            [isEdge('b', 'c', value: 42, isDirected: false)]);
        expect(graph.getEdge('b', 'c'),
            isEdge('b', 'c', value: 42, isDirected: false));
        expect(graph.neighboursOf('b'), ['c']);
        expect(graph.predecessorsOf('c'), ['b']);
        expect(graph.successorsOf('b'), ['c']);
        graph.removeEdge('b', 'c');
        graph.removeVertex('a');
      });
    });
    group('unmodifiable', () {
      test('empty', () {
        final graph = Graph<String, int>.directed();
        expect(graph.isUnmodifiable, isFalse);
        final unmodifiable = graph.unmodifiable;
        expect(unmodifiable.isUnmodifiable, isTrue);
        expect(unmodifiable.unmodifiable, same(unmodifiable));
        expectInvariants(unmodifiable);
      });
      test('delegates', () {
        final graph = Graph<String, int>.directed();
        graph.addEdge('a', 'b', value: 42);
        final unmodifiable = graph.unmodifiable;
        expect(unmodifiable.neighboursOf('a'), ['b']);
        expect(unmodifiable.predecessorsOf('b'), ['a']);
        expect(unmodifiable.successorsOf('a'), ['b']);
        expect(unmodifiable.edgesOf('a'), [isEdge('a', 'b', value: 42)]);
        expect(
            unmodifiable.incomingEdgesOf('b'), [isEdge('a', 'b', value: 42)]);
        expect(
            unmodifiable.outgoingEdgesOf('a'), [isEdge('a', 'b', value: 42)]);
        expect(unmodifiable.getEdge('a', 'b'), isEdge('a', 'b', value: 42));
      });
      test('errors', () {
        final graph = Graph<String, void>.directed().unmodifiable;
        expect(() => graph.addVertex('a'), throwsUnsupportedError);
        expect(() => graph.addEdge('a', 'b'), throwsUnsupportedError);
        expect(() => graph.removeVertex('a'), throwsUnsupportedError);
        expect(() => graph.removeEdge('a', 'b'), throwsUnsupportedError);
        expectInvariants(graph);
      });
    });
    group('where', () {
      test('directed', () {
        final base = Graph<String, void>.directed();
        base
          ..addEdge('a', 'b')
          ..addEdge('b', 'c')
          ..addEdge('c', 'a');
        final graph = base.where(vertexPredicate: (vertex) => vertex != 'b');
        expect(graph.isDirected, isTrue);
        expect(graph.vertexStrategy, isNotNull);
        expectInvariants(graph);
        expect(graph.vertices, unorderedEquals(['a', 'c']));
        expect(graph.edges, unorderedEquals([isEdge('c', 'a')]));
        expect(graph.edgesOf('a'), [isEdge('c', 'a')]);
        expect(graph.edgesOf('b'), isEmpty);
        expect(graph.edgesOf('c'), [isEdge('c', 'a')]);
        expect(graph.incomingEdgesOf('a'), [isEdge('c', 'a')]);
        expect(graph.incomingEdgesOf('b'), isEmpty);
        expect(graph.incomingEdgesOf('c'), isEmpty);
        expect(graph.outgoingEdgesOf('a'), isEmpty);
        expect(graph.outgoingEdgesOf('b'), isEmpty);
        expect(graph.outgoingEdgesOf('c'), [isEdge('c', 'a')]);
        expect(graph.getEdge('a', 'b'), isNull);
        expect(graph.getEdge('b', 'c'), isNull);
        expect(graph.getEdge('c', 'a'), isEdge('c', 'a'));
        expect(graph.neighboursOf('a'), ['c']);
        expect(graph.neighboursOf('b'), isEmpty);
        expect(graph.neighboursOf('c'), ['a']);
        expect(graph.predecessorsOf('a'), ['c']);
        expect(graph.predecessorsOf('b'), isEmpty);
        expect(graph.predecessorsOf('c'), isEmpty);
        expect(graph.successorsOf('a'), isEmpty);
        expect(graph.successorsOf('b'), isEmpty);
        expect(graph.successorsOf('c'), ['a']);
      });
      test('undirected', () {
        final base = Graph<String, void>.undirected();
        base
          ..addEdge('a', 'b')
          ..addEdge('b', 'c')
          ..addEdge('c', 'a');
        final graph = base.where(vertexPredicate: (vertex) => vertex != 'b');
        expect(graph.isDirected, isFalse);
        expect(graph.vertexStrategy, isNotNull);
        expectInvariants(graph);
        expect(graph.vertices, unorderedEquals(['a', 'c']));
        expect(
            graph.edges, unorderedEquals([isEdge('a', 'c'), isEdge('c', 'a')]));
        expect(graph.edgesOf('a'), [isEdge('a', 'c')]);
        expect(graph.edgesOf('b'), isEmpty);
        expect(graph.edgesOf('c'), [isEdge('c', 'a')]);
        expect(graph.incomingEdgesOf('a'), [isEdge('c', 'a')]);
        expect(graph.incomingEdgesOf('b'), isEmpty);
        expect(graph.incomingEdgesOf('c'), [isEdge('a', 'c')]);
        expect(graph.outgoingEdgesOf('a'), [isEdge('a', 'c')]);
        expect(graph.outgoingEdgesOf('b'), isEmpty);
        expect(graph.outgoingEdgesOf('c'), [isEdge('c', 'a')]);
        expect(graph.getEdge('a', 'b'), isNull);
        expect(graph.getEdge('a', 'c'), isEdge('a', 'c'));
        expect(graph.getEdge('b', 'c'), isNull);
        expect(graph.getEdge('b', 'a'), isNull);
        expect(graph.getEdge('c', 'a'), isEdge('c', 'a'));
        expect(graph.getEdge('c', 'b'), isNull);
        expect(graph.neighboursOf('a'), ['c']);
        expect(graph.neighboursOf('b'), isEmpty);
        expect(graph.neighboursOf('c'), ['a']);
        expect(graph.predecessorsOf('a'), ['c']);
        expect(graph.predecessorsOf('b'), isEmpty);
        expect(graph.predecessorsOf('c'), ['a']);
        expect(graph.successorsOf('a'), ['c']);
        expect(graph.successorsOf('b'), isEmpty);
        expect(graph.successorsOf('c'), ['a']);
      });
      test('filter everything', () {
        final base = Graph<String, void>.directed();
        base
          ..addEdge('a', 'b')
          ..addEdge('b', 'c')
          ..addEdge('c', 'a');
        final graph = base.where(vertexPredicate: (vertex) => true);
        expectInvariants(graph);
        expect(graph.vertices, unorderedEquals(base.vertices));
        expect(graph.edges, unorderedEquals(base.edges));
      });
      test('filter nothing', () {
        final base = Graph<String, void>.directed();
        base
          ..addEdge('a', 'b')
          ..addEdge('b', 'c')
          ..addEdge('c', 'a');
        final graph = base.where(vertexPredicate: (vertex) => false);
        expectInvariants(graph);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
      });
    });
    group('edge', () {
      group('directed', () {
        const a = Edge<int, void>.directed(1, 2);
        const b = Edge<int, String>.directed(2, 1, value: 'b');
        const c = Edge<int, String>.directed(2, 1, value: 'c');
        test('create (without data)', () {
          expect(a.source, 1);
          expect(a.target, 2);
        });
        test('create (with data)', () {
          expect(c.source, 2);
          expect(c.target, 1);
          expect(c.value, 'c');
        });
        test('equals', () {
          expect(a == a, isTrue);
          expect(a == b, isFalse);
          expect(a == c, isFalse);
          expect(b == a, isFalse);
          expect(b == b, isTrue);
          expect(b == c, isTrue);
          expect(c == a, isFalse);
          expect(c == b, isTrue);
          expect(c == c, isTrue);
        });
        test('hashCode', () {
          expect(a.hashCode == b.hashCode, isFalse);
          expect(b.hashCode == c.hashCode, isTrue);
        });
        test('toString', () {
          expect(a.toString(), endsWith('(1 → 2)'));
          expect(b.toString(), endsWith('(2 → 1, value: b)'));
          expect(c.toString(), endsWith('(2 → 1, value: c)'));
        });
      });
      group('undirected', () {
        const a = Edge<int, void>.undirected(1, 2);
        const b = Edge<int, String>.undirected(2, 1, value: 'b');
        const c = Edge<int, String>.undirected(2, 3, value: 'c');
        test('create (without data)', () {
          expect(a.source, 1);
          expect(a.target, 2);
        });
        test('create (with data)', () {
          expect(c.source, 2);
          expect(c.target, 3);
          expect(c.value, 'c');
        });
        test('equals', () {
          expect(a == a, isTrue);
          expect(a == b, isTrue);
          expect(a == c, isFalse);
          expect(b == a, isTrue);
          expect(b == b, isTrue);
          expect(b == c, isFalse);
          expect(c == a, isFalse);
          expect(c == b, isFalse);
          expect(c == c, isTrue);
        });
        test('hashCode', () {
          expect(a.hashCode == b.hashCode, isTrue);
          expect(a.hashCode == c.hashCode, isFalse);
        });
        test('toString', () {
          expect(a.toString(), endsWith('(1 — 2)'));
          expect(b.toString(), endsWith('(2 — 1, value: b)'));
          expect(c.toString(), endsWith('(2 — 3, value: c)'));
        });
      });
    });
    group('path', () {
      test('fromVertices (without data)', () {
        final path = Path<int, void>.fromVertices([1, 2, 3]);
        expect(path.vertices, [1, 2, 3]);
        expect(path.values, [null, null]);
        expect(path.source, 1);
        expect(path.target, 3);
        expect(path.edges, [isEdge(1, 2), isEdge(2, 3)]);
        expect(path.toString(), endsWith('(1 → 2 → 3)'));
      });
      test('fromVertices (with data)', () {
        final path =
            Path<String, int>.fromVertices(['a', 'b', 'c'], values: [2, 3]);
        expect(path.vertices, ['a', 'b', 'c']);
        expect(path.values, [2, 3]);
        expect(path.source, 'a');
        expect(path.target, 'c');
        expect(path.edges, [isEdge('a', 'b'), isEdge('b', 'c')]);
        expect(path.cost, 5);
        expect(path.toString(), endsWith('(a → b → c, values: 2, 3, cost: 5)'));
      });
      test('fromEdges (without data)', () {
        final path = Path<int, void>.fromEdges(const [
          Edge.directed(4, 5),
          Edge.undirected(5, 6),
        ]);
        expect(path.vertices, [4, 5, 6]);
        expect(path.values, [null, null]);
        expect(path.source, 4);
        expect(path.target, 6);
        expect(path.edges, [isEdge(4, 5), isEdge(5, 6)]);
        expect(path.toString(), endsWith('(4 → 5 → 6)'));
      });
      test('fromEdges (with data)', () {
        final path = Path<String, int>.fromEdges(const [
          Edge.undirected('x', 'y', value: 4),
          Edge.directed('y', 'z', value: 5),
        ]);
        expect(path.vertices, ['x', 'y', 'z']);
        expect(path.values, [4, 5]);
        expect(path.source, 'x');
        expect(path.target, 'z');
        expect(path.edges, [isEdge('x', 'y'), isEdge('y', 'z')]);
        expect(path.cost, 9);
        expect(path.toString(), endsWith('(x → y → z, values: 4, 5, cost: 9)'));
      });
      test('long path', () {
        final vertices = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
        final values = [1, 2, 3, 4, 5, 6, 7];
        final path = Path<String, int>.fromVertices(vertices, values: values);
        expect(path.vertices, vertices);
        expect(path.values, values);
        expect(path.source, 'a');
        expect(path.target, 'h');
        expect(path.edges, [
          isEdge('a', 'b', value: 1),
          isEdge('b', 'c', value: 2),
          isEdge('c', 'd', value: 3),
          isEdge('d', 'e', value: 4),
          isEdge('e', 'f', value: 5),
          isEdge('f', 'g', value: 6),
          isEdge('g', 'h', value: 7),
        ]);
        expect(
            path.toString(),
            endsWith('(a → b → c → … → f → g → h (8 total), '
                'values: 1, 2, 3, …, 5, 6, 7, '
                'cost: 28)'));
      });
      final a = Path<String, int>.fromVertices(['a', 'b', 'c'], values: [1, 2]);
      final b = Path<String, int>.fromVertices(['a', 'b', 'd'], values: [2, 1]);
      final c = Path<String, int>.fromEdges(const [
        Edge.undirected('a', 'b', value: 1),
        Edge.undirected('b', 'c', value: 2),
      ]);
      test('equals', () {
        expect(a == a, isTrue);
        expect(a == b, isFalse);
        expect(a == c, isTrue);
        expect(b == a, isFalse);
        expect(b == b, isTrue);
        expect(b == c, isFalse);
        expect(c == a, isTrue);
        expect(c == b, isFalse);
        expect(c == c, isTrue);
      });
      test('hashCode', () {
        expect(a.hashCode == b.hashCode, isFalse);
        expect(a.hashCode == c.hashCode, isTrue);
      });
    });
  });
  group('operation', () {
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
            unorderedEquals([
              isEdge(42, 43, value: 'Hello World'),
            ]));
      });
      test('two graphs', () {
        final graph = Graph<int, String>.directed();
        graph.addEdge(1, 2, value: 'Foo');
        graph.addEdge(3, 4, value: 'Bar');
        final connected = graph.connected().toList();
        expect(connected, hasLength(2));
        expect(connected[0].vertices, unorderedEquals([1, 2]));
        expect(
            connected[0].edges,
            unorderedEquals([
              isEdge(1, 2, value: 'Foo'),
            ]));
        expect(connected[1].vertices, unorderedEquals([3, 4]));
        expect(
            connected[1].edges,
            unorderedEquals([
              isEdge(3, 4, value: 'Bar'),
            ]));
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
            ]));
      });
    });
    group('copy', () {
      test('directed', () {
        final graph = GraphFactory<int, void>(isDirected: true)
            .fromSuccessors(cyclicGraphData);
        final copy = graph.copy();
        expect(copy.isDirected, true);
        expect(copy.vertexStrategy, graph.vertexStrategy);
        expect(copy.vertices, unorderedEquals(graph.vertices));
        expect(copy.edges, unorderedEquals(graph.edges));
      });
      test('undirected', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .fromSuccessors(cyclicGraphData);
        final copy = graph.copy();
        expect(copy.isDirected, false);
        expect(copy.vertexStrategy, graph.vertexStrategy);
        expect(copy.vertices, unorderedEquals(graph.vertices));
        expect(copy.edges, unorderedEquals(graph.edges));
      });
      test('directed empty', () {
        final graph = GraphFactory<int, void>(isDirected: true)
            .fromSuccessors(cyclicGraphData);
        final copy = graph.copy(empty: true);
        expect(copy.isDirected, true);
        expect(copy.vertexStrategy, graph.vertexStrategy);
        expect(copy.vertices, isEmpty);
        expect(copy.edges, isEmpty);
      });
      test('undirected empty', () {
        final graph = GraphFactory<int, void>(isDirected: false)
            .fromSuccessors(cyclicGraphData);
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
          final graph = GraphFactory<int, void>(isDirected: true)
              .fromSuccessors(cyclicGraphData);
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
          final graph = GraphFactory<int, void>(isDirected: false)
              .fromSuccessors(cyclicGraphData);
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
          final graph =
              GraphFactory<String, String>(edgeProvider: (a, b) => '$a to $b')
                  .fromPath(['a', 'b']);
          expect(graph.toDot().split('\n'), [
            'digraph {',
            '  0 [label=a];',
            '  1 [label=b];',
            '  0 -> 1 [label="a to b"];',
            '}',
          ]);
        });
        test('custom attributes', () {
          final graph =
              GraphFactory<String, String>(edgeProvider: (a, b) => '$a to $b')
                  .fromPath(['a', 'b']);
          expect(
              graph.toDot(
                graphAttributes: {'bgcolor': 'lightblue'},
                vertexLabel: (vertex) => 'Vertex $vertex',
                vertexAttributes: (vertex) => {'bgcolor': 'lightgreen'},
                edgeLabel: (edge) => 'Edge ${edge.value}',
                edgeAttributes: (edge) => {'color': 'turquoise'},
              ).split('\n'),
              [
                'digraph {',
                '  bgcolor=lightblue;',
                '  0 [label="Vertex a", bgcolor=lightgreen];',
                '  1 [label="Vertex b", bgcolor=lightgreen];',
                '  0 -> 1 [label="Edge a to b", color=turquoise];',
                '}',
              ]);
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
              unorderedEquals([
                isEdge('a', 'b'),
                isEdge('c', 'd'),
              ]));
        });
        test('shared vertex', () {
          final a = GraphFactory<String, void>().fromPath(['a', 'b']);
          final b = GraphFactory<String, void>().fromPath(['b', 'c']);
          final result = a.union(b);
          expect(result.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(
              result.edges,
              unorderedEquals([
                isEdge('a', 'b'),
                isEdge('b', 'c'),
              ]));
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
              ]));
        });
        test('shared edge (custom merger)', () {
          final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
          final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
          final result =
              a.union(b, edgeMerge: (source, target, a, b) => '$a, $b');
          expect(result.vertices, unorderedEquals([1, 2, 3, 4]));
          expect(
              result.edges,
              unorderedEquals([
                isEdge(1, 2, value: 'a'),
                isEdge(2, 3, value: 'a, b'),
                isEdge(3, 4, value: 'b'),
              ]));
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
          final result =
              a.intersection(b, edgeCompare: (source, target, a, b) => a == b);
          expect(result.vertices, unorderedEquals([2, 3]));
          expect(result.edges, isEmpty);
        });
        test('shared edge (custom merge)', () {
          final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
          final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
          final result =
              a.intersection(b, edgeMerge: (source, target, a, b) => '$a, $b');
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
              ]));
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
      final graph = GraphFactory<int, Point<int>>(edgeProvider: Point.new)
          .ring(vertexCount: 3);
      test('none', () {
        final result = graph.map<int, Point<int>>();
        expect(result.vertices, unorderedEquals([0, 1, 2]));
        expect(
            result.edges,
            unorderedEquals([
              isEdge(0, 1, value: const Point(0, 1)),
              isEdge(1, 2, value: const Point(1, 2)),
              isEdge(2, 0, value: const Point(2, 0)),
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
              isEdge('0', '1', value: const Point(0, 1)),
              isEdge('1', '2', value: const Point(1, 2)),
              isEdge('2', '0', value: const Point(2, 0)),
            ]));
        expectInvariants(result);
      });
      test('edge only', () {
        final result = graph.map<int, String>(
            edge: (edge) => '${edge.value.x} -> ${edge.value.y}');
        expect(result.vertices, unorderedEquals([0, 1, 2]));
        expect(
            result.edges,
            unorderedEquals([
              isEdge(0, 1, value: '0 -> 1'),
              isEdge(1, 2, value: '1 -> 2'),
              isEdge(2, 0, value: '2 -> 0'),
            ]));
        expectInvariants(result);
      });
      test('vertex and edge', () {
        final result = graph.map<String, String>(
            vertex: (vertex) => vertex.toString(),
            edge: (edge) => '${edge.value.x} -> ${edge.value.y}');
        expect(result.vertices, unorderedEquals(['0', '1', '2']));
        expect(
            result.edges,
            unorderedEquals([
              isEdge('0', '1', value: '0 -> 1'),
              isEdge('1', '2', value: '1 -> 2'),
              isEdge('2', '0', value: '2 -> 0'),
            ]));
        expectInvariants(result);
      });
      test('vertex and edge', () {
        final graph = GraphFactory<int, Point<int>>(
                edgeProvider: Point.new, isDirected: false)
            .ring(vertexCount: 3);
        final result = graph.map<String, String>(
            vertex: (vertex) => vertex.toString(),
            edge: (edge) => '${edge.value.x} <-> ${edge.value.y}');
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
            ]));
        expectInvariants(result);
      });
    });
  });
  group('factory', () {
    group('atlas', () {
      final random = Random(1252);
      final factory = GraphFactory<int, void>(isDirected: false);
      test('numbered', () {
        for (var i = 0; i <= 1252; i += random.nextInt(100)) {
          final graph = factory.atlas(i);
          expectInvariants(graph);
        }
      });
      test('vertex match', () {
        final graphs = factory.atlasMatching(vertexCount: 3);
        expect(graphs.map((each) => each.vertices.length), everyElement(3));
      });
      test('edge match', () {
        final graphs = factory.atlasMatching(edgeCount: 3);
        expect(graphs.map((each) => each.edges.length), everyElement(6));
      });
    });
    group('collection', () {
      group('path', () {
        test('empty', () {
          final graph = GraphFactory<String, void>().fromPath([]);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('single', () {
          final graph = GraphFactory<String, void>().fromPath(['a']);
          expect(graph.vertices, ['a']);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('multiple', () {
          final graph = GraphFactory<String, void>().fromPath(['a', 'b', 'c']);
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(graph.edges, [
            isEdge('a', 'b'),
            isEdge('b', 'c'),
          ]);
          expectInvariants(graph);
        });
      });
      group('paths', () {
        test('empty', () {
          final graph = GraphFactory<String, void>().fromPaths([]);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('simple', () {
          final graph = GraphFactory<String, void>().fromPaths([
            ['a'],
            ['b', 'c'],
          ]);
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(graph.edges, [
            isEdge('b', 'c'),
          ]);
          expectInvariants(graph);
        });
        test('multiple', () {
          final graph = GraphFactory<String, void>().fromPaths([
            ['a', 'b', 'c'],
            ['d', 'b', 'e'],
          ]);
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c', 'd', 'e']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('a', 'b'),
                isEdge('b', 'c'),
                isEdge('d', 'b'),
                isEdge('b', 'e'),
              ]));
          expectInvariants(graph);
        });
      });
      group('predecessors', () {
        test('empty', () {
          final graph = GraphFactory<String, void>().fromPredecessors({});
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('single', () {
          final graph = GraphFactory<String, void>().fromPredecessors({
            'a': null,
            'b': [],
          });
          expect(graph.vertices, unorderedEquals(['a', 'b']));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('basic', () {
          final graph = GraphFactory<String, void>().fromPredecessors({
            'a': ['b', 'c'],
          });
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('b', 'a'),
                isEdge('c', 'a'),
              ]));
          expectInvariants(graph);
        });
      });
      group('predecessor function', () {
        test('empty', () {
          final graph = GraphFactory<int, void>()
              .fromPredecessorFunction([], finiteCollatzGraph);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('basic', () {
          final graph = GraphFactory<int, void>()
              .fromPredecessorFunction([5], finiteCollatzGraph);
          expect(graph.vertices, unorderedEquals([1, 2, 4, 5, 8, 16]));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(1, 2),
                isEdge(2, 4),
                isEdge(4, 8),
                isEdge(8, 16),
                isEdge(16, 5),
              ]));
          expectInvariants(graph);
        });
      });
      group('successors', () {
        test('empty', () {
          final graph = GraphFactory<String, void>().fromSuccessors({});
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('single', () {
          final graph = GraphFactory<String, void>().fromSuccessors({
            'a': null,
            'b': [],
          });
          expect(graph.vertices, unorderedEquals(['a', 'b']));
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('basic', () {
          final graph = GraphFactory<String, void>().fromSuccessors({
            'a': ['b', 'c'],
          });
          expect(graph.vertices, unorderedEquals(['a', 'b', 'c']));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge('a', 'b'),
                isEdge('a', 'c'),
              ]));
          expectInvariants(graph);
        });
      });
      group('successor function', () {
        test('empty', () {
          final graph = GraphFactory<int, void>()
              .fromSuccessorFunction([], finiteCollatzGraph);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('basic', () {
          final graph = GraphFactory<int, void>()
              .fromSuccessorFunction([5], finiteCollatzGraph);
          expect(graph.vertices, unorderedEquals([1, 2, 4, 5, 8, 16]));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(2, 1),
                isEdge(4, 2),
                isEdge(5, 16),
                isEdge(8, 4),
                isEdge(16, 8),
              ]));
          expectInvariants(graph);
        });
      });
    });
    group('complete', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().complete(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<int, void>().complete(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('full', () {
        final graph = GraphFactory<int, void>().complete(vertexCount: 3);
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(0, 1),
              isEdge(0, 2),
              isEdge(1, 0),
              isEdge(1, 2),
              isEdge(2, 0),
              isEdge(2, 1),
            ]));
        expectInvariants(graph);
      });
    });
    group('empty', () {
      test('basic', () {
        final graph = GraphFactory<int, String>().empty();
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expect(graph.isDirected, isTrue);
        expect(graph.isUnmodifiable, isFalse);
      });
      test('unmodifiable', () {
        final graph = GraphFactory<int, String>(isDirected: false).empty();
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expect(graph.isDirected, isFalse);
        expect(graph.isUnmodifiable, isFalse);
      });
      test('unmodifiable', () {
        final graph = GraphFactory<int, String>(isUnmodifiable: true).empty();
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expect(graph.isDirected, isTrue);
        expect(graph.isUnmodifiable, isTrue);
      });
    });
    group('partite', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().partite(vertexCounts: []);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('path graph (p: 1, q: 1)', () {
        final graph = GraphFactory<int, void>().partite(vertexCounts: [1, 1]);
        expect(graph.vertices, unorderedEquals([0, 1]));
        expect(graph.edges, [
          isEdge(0, 1),
        ]);
        expectInvariants(graph);
      });
      test('claw graph (p: 1, q: 3)', () {
        final graph = GraphFactory<int, void>().partite(vertexCounts: [1, 3]);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(0, 1),
              isEdge(0, 2),
              isEdge(0, 3),
            ]));
        expectInvariants(graph);
      });
      test('square graph (p: 2, q: 2)', () {
        final graph = GraphFactory<int, void>().partite(vertexCounts: [2, 2]);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(0, 2),
              isEdge(0, 3),
              isEdge(1, 2),
              isEdge(1, 3),
            ]));
        expectInvariants(graph);
      });
      test('utility graph (p: 3, q: 3)', () {
        final graph = GraphFactory<int, void>().partite(vertexCounts: [3, 3]);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(0, 3),
              isEdge(0, 4),
              isEdge(0, 5),
              isEdge(1, 3),
              isEdge(1, 4),
              isEdge(1, 5),
              isEdge(2, 3),
              isEdge(2, 4),
              isEdge(2, 5),
            ]));
        expectInvariants(graph);
      });
    });
    group('path', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().path(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<int, void>().path(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('full', () {
        final graph = GraphFactory<int, void>().path(vertexCount: 3);
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(0, 1),
              isEdge(1, 2),
            ]));
        expectInvariants(graph);
      });
    });
    group('ring', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('full', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 3);
        expect(graph.vertices, unorderedEquals([0, 1, 2]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(0, 1),
              isEdge(1, 2),
              isEdge(2, 0),
            ]));
        expectInvariants(graph);
      });
    });
    group('star', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().star(vertexCount: 0);
        expect(graph.vertices, isEmpty);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('single', () {
        final graph = GraphFactory<int, void>().star(vertexCount: 1);
        expect(graph.vertices, [0]);
        expect(graph.edges, isEmpty);
        expectInvariants(graph);
      });
      test('full', () {
        final graph = GraphFactory<int, void>().star(vertexCount: 4);
        expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
        expect(
            graph.edges,
            unorderedEquals([
              isEdge(0, 1),
              isEdge(0, 2),
              isEdge(0, 3),
            ]));
        expectInvariants(graph);
      });
    });
    group('tree', () {
      group('complete', () {
        test('empty', () {
          final graph = GraphFactory<int, void>().completeTree(vertexCount: 0);
          expect(graph.vertices, isEmpty);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('unary', () {
          final graph =
              GraphFactory<int, void>().completeTree(vertexCount: 3, arity: 1);
          expect(graph.vertices, unorderedEquals([0, 1, 2]));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(0, 1),
                isEdge(1, 2),
              ]));
          expectInvariants(graph);
        });
        test('binary', () {
          final graph = GraphFactory<int, void>().completeTree(vertexCount: 6);
          expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5]));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(0, 1),
                isEdge(0, 2),
                isEdge(1, 3),
                isEdge(1, 4),
                isEdge(2, 5),
              ]));
          expectInvariants(graph);
        });
        test('ternary', () {
          final graph =
              GraphFactory<int, void>().completeTree(vertexCount: 7, arity: 3);
          expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5, 6]));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(0, 1),
                isEdge(0, 2),
                isEdge(0, 3),
                isEdge(1, 4),
                isEdge(1, 5),
                isEdge(1, 6),
              ]));
          expectInvariants(graph);
        });
      });
      group('perfect', () {
        test('empty', () {
          final graph = GraphFactory<int, void>().prefectTree(height: 0);
          expect(graph.vertices, [0]);
          expect(graph.edges, isEmpty);
          expectInvariants(graph);
        });
        test('unary', () {
          final graph =
              GraphFactory<int, void>().prefectTree(height: 2, arity: 1);
          expect(graph.vertices, unorderedEquals([0, 1, 2]));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(0, 1),
                isEdge(1, 2),
              ]));
          expectInvariants(graph);
        });
        test('binary', () {
          final graph = GraphFactory<int, void>().prefectTree(height: 2);
          expect(graph.vertices, unorderedEquals([0, 1, 2, 3, 4, 5, 6]));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(0, 1),
                isEdge(0, 2),
                isEdge(1, 3),
                isEdge(1, 4),
                isEdge(2, 5),
                isEdge(2, 6),
              ]));
          expectInvariants(graph);
        });
        test('ternary', () {
          final graph =
              GraphFactory<int, void>().prefectTree(height: 1, arity: 3);
          expect(graph.vertices, unorderedEquals([0, 1, 2, 3]));
          expect(
              graph.edges,
              unorderedEquals([
                isEdge(0, 1),
                isEdge(0, 2),
                isEdge(0, 3),
              ]));
          expectInvariants(graph);
        });
      });
      group('random', () {
        group('Erdős–Rényi', () {
          test('empty', () {
            final graph = GraphFactory<int, void>()
                .randomErdosRenyi(vertexCount: 3, probability: 0.0);
            expect(graph.vertices, hasLength(3));
            expect(graph.edges, isEmpty);
            expectInvariants(graph);
          });
          test('complete', () {
            final graph = GraphFactory<int, void>()
                .randomErdosRenyi(vertexCount: 3, probability: 1.0);
            expect(graph.vertices, hasLength(3));
            expect(graph.edges, hasLength(6));
            expectInvariants(graph);
          });
          test('directed', () {
            final graph = GraphFactory<int, void>(
                    isDirected: true, random: Random(235711))
                .randomErdosRenyi(vertexCount: 10, probability: 0.5);
            expect(graph.isDirected, isTrue);
            expect(graph.vertices, hasLength(10));
            expect(graph.edges.length, allOf(greaterThan(40), lessThan(60)));
            expectInvariants(graph);
          });
          test('undirected', () {
            final graph = GraphFactory<int, void>(
                    isDirected: false, random: Random(131719))
                .randomErdosRenyi(vertexCount: 10, probability: 0.5);
            expect(graph.isDirected, isFalse);
            expect(graph.vertices, hasLength(10));
            expect(graph.edges.length, allOf(greaterThan(40), lessThan(60)));
            expectInvariants(graph);
          });
        });
      });
    });
  });
  group('algorithms', () {
    group('search', () {
      test('directed path', () {
        final graph = GraphFactory<int, void>().path(vertexCount: 10);
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
        final graph = GraphFactory<int, void>().path(vertexCount: 10);
        for (var i = 0; i < 10; i++) {
          expect(
            graph.shortestPath(0, i, edgeCost: (source, target) => target),
            isPath(source: 0, target: i, cost: i * (i + 1) ~/ 2),
          );
          if (i != 0) {
            expect(
              graph.shortestPath(i, 0, edgeCost: (source, target) => target),
              isNull,
            );
          }
        }
      });
      test('directed path with cost on edge', () {
        final graph =
            GraphFactory<int, int>(edgeProvider: (source, target) => target)
                .path(vertexCount: 10);
        for (var i = 0; i < 10; i++) {
          expect(
            graph.shortestPath(0, i,
                edgeCost: (source, target) =>
                    graph.getEdge(source, target)!.value),
            isPath(source: 0, target: i, cost: i * (i + 1) ~/ 2),
          );
          if (i != 0) {
            expect(
              graph.shortestPath(i, 0,
                  edgeCost: (source, target) =>
                      graph.getEdge(source, target)!.value),
              isNull,
            );
          }
        }
      });
      test('undirected path', () {
        final graph =
            GraphFactory<int, void>(isDirected: false).path(vertexCount: 10);
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
            dijkstraGraph.shortestPath(1, 5,
                edgeCost: (source, target) =>
                    dijkstraGraph.getEdge(source, target)!.value),
            isPath(source: 1, target: 5, vertices: [1, 3, 6, 5], cost: 20));
        expect(
            dijkstraGraph.shortestPathAll(1, constantFunction1(true),
                edgeCost: (source, target) =>
                    dijkstraGraph.getEdge(source, target)!.value),
            unorderedEquals([
              isPath(vertices: [1], cost: 0),
              isPath(vertices: [1, 2], cost: 7),
              isPath(vertices: [1, 3], cost: 9),
              isPath(vertices: [1, 3, 6], cost: 11),
              isPath(vertices: [1, 3, 6, 5], cost: 20),
              isPath(vertices: [1, 3, 4], cost: 20),
            ]));
      });
      test('undirected graph with edge cost', () {
        expect(dijkstraGraph.shortestPath(1, 5),
            isPath(source: 1, target: 5, vertices: [1, 3, 6, 5], cost: 20));
        expect(
            dijkstraGraph.shortestPathAll(1, constantFunction1(true)),
            unorderedEquals([
              isPath(vertices: [1], cost: 0),
              isPath(vertices: [1, 2], cost: 7),
              isPath(vertices: [1, 3], cost: 9),
              isPath(vertices: [1, 3, 4], cost: 20),
              isPath(vertices: [1, 3, 6, 5], cost: 20),
              isPath(vertices: [1, 3, 6], cost: 11),
            ]));
      });
      test('undirected graph with constant cost', () {
        expect(dijkstraGraph.shortestPath(1, 5, edgeCost: constantFunction2(1)),
            isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2));
        expect(
            dijkstraGraph.shortestPathAll(1, constantFunction1(true),
                edgeCost: constantFunction2(1)),
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
                edgeCost: constantFunction2(1),
                costEstimate: (vertex) => 6 - vertex),
            isPath(source: 1, target: 5, vertices: [1, 6, 5], cost: 2));
        expect(
            dijkstraGraph.shortestPathAll(1, constantFunction1(true),
                edgeCost: constantFunction2(1),
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
      group('hills', () {
        final hills = [
          '00000002345677899876543355557775557777',
          '00110023456678899876543555677777777777',
          '00011234566778998776654555667777777877',
          '00000234566788998776654355666888778777',
          '11000234567778999876554244666888888777',
          '11000034566677899876543244666888888777',
          '21111023456677898776542244466888887777',
          '22221002335667787765432444666888999777',
          '22221001123566777654322444668888777777',
          '22221111112356666543224446668877777777',
          '33222111111135555332224466688888877788',
          '44322211111113331112244466688888877788',
          '54332221111111111112244466666886887777',
        ].map((line) => line.split('').map(int.parse).toList()).toList();
        const source = Point(0, 0), target = Point(12, 37);
        bool targetPredicate(Point<int> vertex) => target == vertex;
        Iterable<Point<int>> successorsOf(Point<int> vertex) => const [
              Point(-1, -1), Point(-1, 0), Point(-1, 1), Point(0, -1), //
              Point(0, 1), Point(1, -1), Point(1, 0), Point(1, 1),
            ].map((offset) => vertex + offset).where((point) =>
                point.x.between(source.x, target.x) &&
                point.y.between(source.y, target.y) &&
                hills[point.x][point.y] < 8);
        num edgeCost(Point<int> source, Point<int> target) =>
            ((source.x - target.x).pow(2) +
                    (source.y - target.y).pow(2) +
                    (2 * hills[source.x][source.y] -
                            2 * hills[target.x][target.y])
                        .pow(2))
                .sqrt();
        num costEstimate(Point<int> vertex) => ((vertex.x - target.x).pow(2) +
                (vertex.y - target.y).pow(2) +
                (2 * hills[vertex.x][vertex.y] - 2 * hills[target.x][target.y])
                    .pow(2))
            .sqrt();
        test('dijkstra', () {
          final search = DijkstraSearchIterable<Point<int>>(
              startVertices: [source],
              successorsOf: successorsOf,
              targetPredicate: targetPredicate);
          expect(
              search.single,
              isPath(
                  source: source,
                  target: target,
                  vertices: hasLength(46),
                  cost: 45));
        });
        test('dijkstra (custom cost)', () {
          final search = DijkstraSearchIterable<Point<int>>(
              startVertices: [source],
              successorsOf: successorsOf,
              targetPredicate: targetPredicate,
              edgeCost: edgeCost);
          expect(
              search.single,
              isPath(
                  source: source,
                  target: target,
                  vertices: hasLength(47),
                  cost: closeTo(63.79, 0.1)));
        });
        test('a-star', () {
          final search = AStarSearchIterable<Point<int>>(
              startVertices: [source],
              successorsOf: successorsOf,
              targetPredicate: targetPredicate,
              costEstimate: costEstimate);
          expect(
              search.single,
              isPath(
                  source: source,
                  target: target,
                  vertices: hasLength(46),
                  cost: 45));
        });
        test('a-star (custom cost)', () {
          final search = AStarSearchIterable<Point<int>>(
              startVertices: [source],
              successorsOf: successorsOf,
              targetPredicate: targetPredicate,
              edgeCost: edgeCost,
              costEstimate: costEstimate);
          expect(
              search.single,
              isPath(
                  source: source,
                  target: target,
                  vertices: hasLength(47),
                  cost: closeTo(63.79, 0.1)));
        });
      });
      group('maze', () {
        final maze = [
          '#########################',
          '        #     #         #',
          '# ### ### # ### ##### # #',
          '# #   #   #     #     # #',
          '# # ### ######### # #####',
          '# #   # #   # #   #     #',
          '# ### # # # # # # # #####',
          '# #   #   #   # # # #   #',
          '# # # ####### # ### # # #',
          '# # #   #     #   # # # #',
          '# # ##### ####### ##### #',
          '# #             #        ',
          '#########################',
        ].map((line) => line.split('').toList()).toList();
        const source = Point(1, 0), target = Point(11, 24);
        bool targetPredicate(Point<int> vertex) => target == vertex;
        Iterable<Point<int>> successorsOf(Point<int> vertex) => const [
              Point(-1, 0), Point(0, -1), Point(0, 1), Point(1, 0), //
            ].map((offset) => vertex + offset).where((point) =>
                point.x.between(source.x, target.x) &&
                point.y.between(source.y, target.y) &&
                maze[point.x][point.y] != '#');
        num costEstimate(Point<int> vertex) =>
            ((vertex.x - target.x).pow(2) + (vertex.y - target.y).pow(2))
                .sqrt();
        const solution = <Point<int>>[
          Point(1, 0), Point(1, 1), Point(1, 2), Point(1, 3), Point(1, 4), //
          Point(1, 5), Point(2, 5), Point(3, 5), Point(3, 4), Point(3, 3),
          Point(4, 3), Point(5, 3), Point(5, 4), Point(5, 5), Point(6, 5),
          Point(7, 5), Point(7, 4), Point(7, 3), Point(8, 3), Point(9, 3),
          Point(10, 3), Point(11, 3), Point(11, 4), Point(11, 5), Point(11, 6),
          Point(11, 7), Point(11, 8), Point(11, 9), Point(10, 9), Point(9, 9),
          Point(9, 10), Point(9, 11), Point(9, 12), Point(9, 13), Point(8, 13),
          Point(7, 13), Point(7, 12), Point(7, 11), Point(6, 11), Point(5, 11),
          Point(5, 10), Point(5, 9), Point(6, 9), Point(7, 9), Point(7, 8),
          Point(7, 7), Point(6, 7), Point(5, 7), Point(4, 7), Point(3, 7),
          Point(3, 8), Point(3, 9), Point(2, 9), Point(1, 9), Point(1, 10),
          Point(1, 11), Point(2, 11), Point(3, 11), Point(3, 12), Point(3, 13),
          Point(3, 14), Point(3, 15), Point(2, 15), Point(1, 15), Point(1, 16),
          Point(1, 17), Point(1, 18), Point(1, 19), Point(1, 20), Point(1, 21),
          Point(2, 21), Point(3, 21), Point(3, 20), Point(3, 19), Point(3, 18),
          Point(3, 17), Point(4, 17), Point(5, 17), Point(5, 16), Point(5, 15),
          Point(6, 15), Point(7, 15), Point(8, 15), Point(9, 15), Point(9, 16),
          Point(9, 17), Point(10, 17), Point(11, 17), Point(11, 18),
          Point(11, 19), Point(11, 20), Point(11, 21), Point(11, 22),
          Point(11, 23), Point(11, 24),
        ];
        test('dijkstra', () {
          expect(
              DijkstraSearchIterable<Point<int>>(
                      startVertices: [source],
                      successorsOf: successorsOf,
                      targetPredicate: targetPredicate)
                  .single,
              isPath(
                  source: source,
                  target: target,
                  vertices: solution,
                  cost: solution.length - 1));
        });
        test('a-star', () {
          expect(
              AStarSearchIterable<Point<int>>(
                      startVertices: [source],
                      successorsOf: successorsOf,
                      targetPredicate: targetPredicate,
                      costEstimate: costEstimate)
                  .single,
              isPath(
                  source: source,
                  target: target,
                  vertices: solution,
                  cost: solution.length - 1));
        });
        test('a-star (bad estimate)', () {
          final generator = Random(85642);
          expect(
              AStarSearchIterable<Point<int>>(
                  startVertices: [source],
                  successorsOf: successorsOf,
                  targetPredicate: targetPredicate,
                  costEstimate: (vertex) => generator.nextDouble()).single,
              isPath(
                  source: source,
                  target: target,
                  vertices: solution,
                  cost: solution.length - 1));
        });
      });
    });
    group('max flow', () {
      test('line with default edge capacity', () {
        final graph =
            GraphFactory<String, void>().fromPath(['A', 'B', 'C', 'D']);
        final flow = graph.maxFlow();
        expect(flow('A', 'D'), 1);
      });
      test('line with custom edge capacity', () {
        final graph =
            GraphFactory<String, void>().fromPath(['A', 'B', 'C', 'D']);
        final flow = graph.maxFlow(edgeCapacity: constantFunction2(2));
        expect(flow('A', 'D'), 2);
      });
      test('line with standard edge capacity', () {
        final graph = GraphFactory<String, num>(edgeProvider: (a, b) => 3)
            .fromPath(['A', 'B', 'C', 'D']);
        final flow = graph.maxFlow();
        expect(flow('A', 'D'), 3);
      });
      test('undirected graph', () {
        final graph =
            GraphFactory<int, void>(isDirected: false).ring(vertexCount: 10);
        final flow = graph.maxFlow();
        expect(flow(0, 4), 2);
      });
      test('error', () {
        final graph = GraphFactory<int, void>().path(vertexCount: 3);
        final flow = graph.maxFlow();
        expect(() => flow(0, 4), throwsArgumentError);
        expect(() => flow(4, 0), throwsArgumentError);
      });
      test('example 1', () {
        final graph = Graph<String, int>.directed();
        graph.addEdge('S', '1', value: 2);
        graph.addEdge('S', '2', value: 2);
        graph.addEdge('1', 'E', value: 2);
        graph.addEdge('2', 'E', value: 2);
        graph.addEdge('1', '2', value: 1);
        final flow = graph.maxFlow();
        expect(flow('S', 'E'), 4);
        expect(flow('E', 'S'), 0);
      });
      test('example 2', () {
        final graph = Graph<int, int>.directed();
        graph.addEdge(0, 1, value: 16);
        graph.addEdge(0, 2, value: 13);
        graph.addEdge(1, 2, value: 10);
        graph.addEdge(1, 3, value: 12);
        graph.addEdge(2, 1, value: 4);
        graph.addEdge(2, 4, value: 14);
        graph.addEdge(3, 2, value: 9);
        graph.addEdge(3, 5, value: 20);
        graph.addEdge(4, 3, value: 7);
        graph.addEdge(4, 5, value: 4);
        final flow = graph.maxFlow();
        expect(flow(0, 5), 23);
        expect(flow(5, 0), 0);
      });
      test('example 3', () {
        final graph = Graph<String, int>.directed();
        graph.addEdge('A', 'B', value: 3);
        graph.addEdge('A', 'D', value: 3);
        graph.addEdge('B', 'C', value: 4);
        graph.addEdge('C', 'A', value: 3);
        graph.addEdge('C', 'D', value: 1);
        graph.addEdge('C', 'E', value: 2);
        graph.addEdge('D', 'E', value: 2);
        graph.addEdge('D', 'F', value: 6);
        graph.addEdge('E', 'B', value: 1);
        graph.addEdge('E', 'G', value: 1);
        graph.addEdge('F', 'G', value: 9);
        final flow = graph.maxFlow();
        expect(flow('A', 'G'), 5);
        expect(flow('G', 'A'), 0);
      });
      test('example 4', () {
        final graph = Graph<String, int>.directed();
        graph.addEdge('s', 'a', value: 15);
        graph.addEdge('s', 'c', value: 4);
        graph.addEdge('a', 'b', value: 12);
        graph.addEdge('b', 'c', value: 3);
        graph.addEdge('b', 't', value: 7);
        graph.addEdge('c', 'd', value: 10);
        graph.addEdge('d', 'a', value: 5);
        graph.addEdge('d', 't', value: 10);
        final flow = graph.maxFlow();
        expect(flow('s', 't'), 14);
        expect(flow('t', 's'), 0);
      });
    });
  });
  group('traverse', () {
    group('breadth-first', () {
      test('path', () {
        final graph = GraphFactory<int, void>().path(vertexCount: 10);
        expect(graph.breadthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 10);
        expect(graph.breadthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('basic', () {
        final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
        expect(graph.breadthFirst(0), [0, 3, 2, 1, 5, 4]);
      });
      test('cyclic', () {
        final graph = GraphFactory<int, void>().fromSuccessors(cyclicGraphData);
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
        final graph = GraphFactory<int, void>().path(vertexCount: 10);
        expect(graph.depthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 10);
        expect(graph.depthFirst(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('basic', () {
        final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
        expect(graph.depthFirst(0), [0, 3, 2, 5, 1, 4]);
      });
      test('cyclic', () {
        final graph = GraphFactory<int, void>().fromSuccessors(cyclicGraphData);
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
        final graph = GraphFactory<int, void>().path(vertexCount: 10);
        expect(graph.depthFirstPostOrder(graph.vertices.first),
            [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
      });
      test('ring', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 10);
        expect(graph.depthFirstPostOrder(graph.vertices.first),
            [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]);
      });
      test('basic', () {
        final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
        expect(graph.depthFirstPostOrder(0), [3, 5, 2, 4, 1, 0]);
      });
      test('cyclic', () {
        final graph = GraphFactory<int, void>().fromSuccessors(cyclicGraphData);
        expect(graph.depthFirstPostOrder(0), [2, 1, 4, 3, 0]);
      });
      test('custom', () {
        final iterable =
            DepthFirstPostOrderIterable<int>([27], successorsOf: collatzGraph);
        expect(iterable, allOf(hasLength(112), contains(9232), contains(1)));
      });
    });
    group('topological', () {
      test('path', () {
        final graph = GraphFactory<int, void>().path(vertexCount: 10);
        expect(graph.topological(graph.vertices.first),
            [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('ring', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 10);
        expect(graph.topological(graph.vertices.first), isEmpty);
      });
      test('basic', () {
        final graph = GraphFactory<int, void>().fromSuccessors(basicGraphData);
        expect(graph.topological(0), [0, 1, 4, 2, 5, 3]);
      });
      test('custom', () {
        final iterable = TopologicalIterable<int>([1],
            successorsOf: (vertex) => [
                  2 * vertex,
                  3 * vertex,
                ].where((each) => each < 50),
            predecessorsOf: (vertex) => [
                  if (vertex > 0 && vertex % 2 == 0) vertex ~/ 2,
                  if (vertex > 0 && vertex % 3 == 0) vertex ~/ 3,
                ]);
        expect(iterable, [1, 3, 9, 27, 2, 6, 18, 4, 12, 36, 8, 24, 16, 48, 32]);
      });
    });
    group('random walk', () {
      test('path', () {
        final graph = GraphFactory<int, void>().path(vertexCount: 10);
        expect(graph.randomWalk(5), [5, 6, 7, 8, 9]);
      });
      test('ring (infinite)', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 4);
        expect(graph.randomWalk(0).take(10), [0, 1, 2, 3, 0, 1, 2, 3, 0, 1]);
      });
      test('ring (avoid duplicates)', () {
        final graph = GraphFactory<int, void>().ring(vertexCount: 4);
        expect(graph.randomWalk(0, selfAvoiding: true), [0, 1, 2, 3]);
      });
      test('star (default probabilities)', () {
        final random = Random(3527);
        final graph =
            GraphFactory<int, void>(isDirected: false).star(vertexCount: 4);
        final observations =
            graph.randomWalk(0, random: random).take(100).toMultiset();
        expect(observations.distinct, {0, 1, 2, 3},
            reason: 'All vertices should be visited.');
      });
      test('star (tweaked probabilities)', () {
        final random = Random(3527);
        final graph =
            GraphFactory<int, void>(isDirected: false).star(vertexCount: 4);
        final observations = graph
            .randomWalk(0,
                random: random,
                edgeProbability: (source, target) => source == 0 ? target : 1)
            .take(1000)
            .toMultiset();
        expect(
            observations
                .asMap()
                .entries
                .toSortedList(comparator: (a, b) => b.value.compareTo(a.value))
                .map((entry) => entry.key),
            [0, 3, 2, 1],
            reason: 'The vertices should be in descending priority.');
      });
      test('custom', () {
        const offsets = [Point(-1, 0), Point(0, -1), Point(0, 1), Point(1, 0)];
        final walk = RandomWalkIterable<Point<int>>(const Point(0, 0),
                successorsOf: (point) => offsets.map((each) => point + each))
            .take(100)
            .toList();
        expect(walk, hasLength(100));
      });
    });
  });
}
