import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:test/test.dart';

void main() {
  group('bronKerboschCliques', () {
    test('empty graph', () {
      final graph = Graph<int, void>(isDirected: false);
      check(graph.findCliques()).isEmpty();
    });
    test('single vertex', () {
      final graph = Graph<int, void>(isDirected: false)..addVertex(1);
      check(graph.findCliques().toSet()).deepEquals({
        {1},
      });
    });
    test('disconnected pair', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addVertex(1)
        ..addVertex(2);
      check(graph.findCliques().toSet()).deepEquals({
        {1},
        {2},
      });
    });
    test('connected pair', () {
      final graph = Graph<int, void>(isDirected: false)..addEdge(2, 1);
      check(graph.findCliques().toSet()).deepEquals({
        {1, 2},
      });
    });
    test('wikipedia', () {
      final graph = Graph<int, void>(isDirected: false)
        ..addEdge(1, 2)
        ..addEdge(1, 5)
        ..addEdge(2, 5)
        ..addEdge(2, 3)
        ..addEdge(3, 4)
        ..addEdge(4, 6)
        ..addEdge(4, 5)
        ..addEdge(4, 6);
      check(graph.findCliques().toSet()).deepEquals({
        {1, 2, 5},
        {2, 3},
        {3, 4},
        {4, 5},
        {4, 6},
      });
    });
    test('aoc', () {
      final graph = Graph<String, void>(isDirected: false);
      for (final (source, target) in [
        ('kh', 'tc'),
        ('qp', 'kh'),
        ('de', 'cg'),
        ('ka', 'co'),
        ('yn', 'aq'),
        ('qp', 'ub'),
        ('cg', 'tb'),
        ('vc', 'aq'),
        ('tb', 'ka'),
        ('wh', 'tc'),
        ('yn', 'cg'),
        ('kh', 'ub'),
        ('ta', 'co'),
        ('de', 'co'),
        ('tc', 'td'),
        ('tb', 'wq'),
        ('wh', 'td'),
        ('ta', 'ka'),
        ('td', 'qp'),
        ('aq', 'cg'),
        ('wq', 'ub'),
        ('ub', 'vc'),
        ('de', 'ta'),
        ('wq', 'aq'),
        ('wq', 'vc'),
        ('wh', 'yn'),
        ('ka', 'de'),
        ('kh', 'ta'),
        ('co', 'tc'),
        ('wh', 'qp'),
        ('tb', 'vc'),
        ('td', 'yn'),
      ]) {
        graph.addEdge(source, target);
      }
      check(graph.findCliques().toSet()).deepEquals({
        {'cg', 'de'},
        {'cg', 'tb'},
        {'co', 'tc'},
        {'ka', 'tb'},
        {'kh', 'ta'},
        {'kh', 'tc'},
        {'aq', 'cg', 'yn'},
        {'aq', 'vc', 'wq'},
        {'kh', 'qp', 'ub'},
        {'qp', 'td', 'wh'},
        {'tb', 'vc', 'wq'},
        {'tc', 'td', 'wh'},
        {'td', 'wh', 'yn'},
        {'ub', 'vc', 'wq'},
        {'co', 'de', 'ka', 'ta'},
      });
    });
    test('complete graph', () {
      for (var i = 1; i < 25; i++) {
        final graph = GraphFactory<int, void>(isDirected: false)
            .complete(vertexCount: i);
        check(graph.findCliques().single).deepEquals(0.to(i).toSet());
      }
    });
    test('complete graph with missing edge', () {
      const count = 10;
      for (var x = 0; x < count; x++) {
        for (var y = 0; y < count; y++) {
          if (x == y) continue;
          final graph = GraphFactory<int, void>(isDirected: false)
              .complete(vertexCount: count);
          graph.removeEdge(x, y);
          check(graph.findCliques()).unorderedMatches([
            (it) => it.deepEquals(0.to(count).toSet()..remove(x)),
            (it) => it.deepEquals(0.to(count).toSet()..remove(y)),
          ]);
        }
      }
    });
    test('directed graph error', () {
      final graph = Graph<int, void>(isDirected: true);
      check(graph.findCliques).throws<GraphError>();
    });
  });
}
