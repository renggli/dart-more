import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('random', () {
    group('Erdős–Rényi', () {
      test('empty', () {
        final graph = GraphFactory<int, void>().randomErdosRenyi(
          vertexCount: 3,
          probability: 0,
        );
        check(graph.vertices).length.equals(3);
        check(graph.edges).isEmpty();
        expectInvariants(graph);
      });
      test('complete', () {
        final graph = GraphFactory<int, void>().randomErdosRenyi(
          vertexCount: 3,
          probability: 1,
        );
        check(graph.vertices).length.equals(3);
        check(graph.edges).length.equals(6);
        expectInvariants(graph);
      });
      test('directed', () {
        final graph = GraphFactory<int, void>(
          isDirected: true,
          random: Random(235711),
        ).randomErdosRenyi(vertexCount: 10, probability: 0.5);
        check(graph.isDirected).isTrue();
        check(graph.vertices).length.equals(10);
        check(graph.edges.length)
          ..isGreaterThan(40)
          ..isLessThan(60);
        expectInvariants(graph);
      });
      test('undirected', () {
        final graph = GraphFactory<int, void>(
          isDirected: false,
          random: Random(131719),
        ).randomErdosRenyi(vertexCount: 10, probability: 0.5);
        check(graph.isDirected).isFalse();
        check(graph.vertices).length.equals(10);
        check(graph.edges.length)
          ..isGreaterThan(40)
          ..isLessThan(60);
        expectInvariants(graph);
      });
    });
  });
}
