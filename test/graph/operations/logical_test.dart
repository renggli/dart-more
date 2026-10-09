import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('logical', () {
    group('union', () {
      test('disjoint', () {
        final a = GraphFactory<String, void>().fromPath(['a', 'b']);
        final b = GraphFactory<String, void>().fromPath(['c', 'd']);
        final result = a.union(b);
        check(result.vertices).unorderedEquals(['a', 'b', 'c', 'd']);
        check(result.edges)
            .unorderedMatches([isEdge('a', 'b'), isEdge('c', 'd')]);
      });
      test('shared vertex', () {
        final a = GraphFactory<String, void>().fromPath(['a', 'b']);
        final b = GraphFactory<String, void>().fromPath(['b', 'c']);
        final result = a.union(b);
        check(result.vertices).unorderedEquals(['a', 'b', 'c']);
        check(result.edges)
            .unorderedMatches([isEdge('a', 'b'), isEdge('b', 'c')]);
      });
      test('shared edge', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.union(b);
        check(result.vertices).unorderedEquals([1, 2, 3, 4]);
        check(result.edges).unorderedMatches([
          isEdge(1, 2, value: 'a'),
          isEdge(2, 3, value: 'b'),
          isEdge(3, 4, value: 'b'),
        ]);
      });
      test('shared edge (custom merger)', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.union(
          b,
          edgeMerge: (source, target, a, b) => '$a, $b',
        );
        check(result.vertices).unorderedEquals([1, 2, 3, 4]);
        check(result.edges).unorderedMatches([
          isEdge(1, 2, value: 'a'),
          isEdge(2, 3, value: 'a, b'),
          isEdge(3, 4, value: 'b'),
        ]);
      });
      test('undirected shared edge (custom merger)', () {
        final factory = GraphFactory<int, int>(isDirected: false);
        final a = factory.fromPath([1, 2], value: 10);
        final b = factory.fromPath([1, 2], value: 20);
        final result = a.union(b, edgeMerge: (s, t, a, b) => a + b);
        check(result.getEdge(1, 2))
            .isNotNull()
            .has((e) => e.value, 'value')
            .equals(30);
      });
      test('undirected union with single graph (custom merger)', () {
        final factory = GraphFactory<int, int>(isDirected: false);
        final a = factory.fromPath([1, 2], value: 10);
        final empty = factory.empty();
        final result = a.union(empty, edgeMerge: (s, t, a, b) => a + b);
        check(result.getEdge(1, 2))
            .isNotNull()
            .has((e) => e.value, 'value')
            .equals(10);
      });
    });
    group('intersection', () {
      test('disjoint', () {
        final a = GraphFactory<String, void>().fromPath(['a', 'b']);
        final b = GraphFactory<String, void>().fromPath(['c', 'd']);
        final result = a.intersection(b);
        check(result.vertices).isEmpty();
        check(result.edges).isEmpty();
      });
      test('shared vertex', () {
        final a = GraphFactory<String, void>().fromPath(['a', 'b']);
        final b = GraphFactory<String, void>().fromPath(['b', 'c']);
        final result = a.intersection(b);
        check(result.vertices).unorderedEquals(['b']);
        check(result.edges).isEmpty();
      });
      test('shared edge', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.intersection(b);
        check(result.vertices).unorderedEquals([2, 3]);
        check(result.edges).unorderedMatches([isEdge(2, 3, value: 'b')]);
      });
      test('shared edge (custom compare)', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.intersection(
          b,
          edgeCompare: (source, target, a, b) => a == b,
        );
        check(result.vertices).unorderedEquals([2, 3]);
        check(result.edges).isEmpty();
      });
      test('shared edge (custom merge)', () {
        final a = GraphFactory<int, String>().fromPath([1, 2, 3], value: 'a');
        final b = GraphFactory<int, String>().fromPath([2, 3, 4], value: 'b');
        final result = a.intersection(
          b,
          edgeMerge: (source, target, a, b) => '$a, $b',
        );
        check(result.vertices).unorderedEquals([2, 3]);
        check(result.edges).unorderedMatches([isEdge(2, 3, value: 'a, b')]);
      });
    });
    group('complement', () {
      test('simple undirected', () {
        final input = Graph<String, void>(isDirected: false);
        input.addEdge('a', 'b');
        final result = input.complement();
        check(result.vertices).unorderedEquals(['a', 'b']);
        check(result.edges).isEmpty();
      });
      test('simple directed', () {
        final input = Graph<String, void>(isDirected: true);
        input.addEdge('a', 'b');
        final result = input.complement();
        check(result.vertices).unorderedEquals(['a', 'b']);
        check(result.edges).unorderedMatches([isEdge('b', 'a')]);
      });
      test('simple directed (with self-loops)', () {
        final input = Graph<String, void>(isDirected: true);
        input.addEdge('a', 'b');
        final result = input.complement(allowSelfLoops: true);
        check(result.vertices).unorderedEquals(['a', 'b']);
        check(result.edges).unorderedMatches([
          isEdge('a', 'a'),
          isEdge('b', 'a'),
          isEdge('b', 'b'),
        ]);
      });
      test('simple directed (with edge data)', () {
        final input = Graph<int, String>(isDirected: true);
        input.addEdge(1, 2, value: 'next');
        final result = input.complement(edge: (source, target) => 'prev');
        check(result.vertices).unorderedEquals([1, 2]);
        check(result.edges).unorderedMatches([isEdge(2, 1, value: 'prev')]);
      });
    });
  });
}
