import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('empty', () {
    test('basic', () {
      final graph = GraphFactory<int, String>().empty();
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
      check(graph.isDirected).isTrue();
      check(graph.isUnmodifiable).isFalse();
    });
    test('undirected', () {
      final graph = GraphFactory<int, String>(isDirected: false).empty();
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
      check(graph.isDirected).isFalse();
      check(graph.isUnmodifiable).isFalse();
    });
    test('unmodifiable', () {
      final graph = GraphFactory<int, String>(isUnmodifiable: true).empty();
      check(graph.vertices).isEmpty();
      check(graph.edges).isEmpty();
      check(graph.isDirected).isTrue();
      check(graph.isUnmodifiable).isTrue();
    });
  });
}
