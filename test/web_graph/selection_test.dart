import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

import '../../web/graph/selection.dart';

void main() {
  group('Selection', () {
    test('starts empty', () {
      final s = Selection();
      check(s.isEmpty).isTrue();
      check(s.isNotEmpty).isFalse();
      check(s.vertices).isEmpty();
      check(s.edges).isEmpty();
      check(s.activeVertex).isNull();
      check(s.selectedEdge).isNull();
      check(s.source).isNull();
      check(s.target).isNull();
    });

    test('selectVertex single and toggle', () {
      final s = Selection();
      s.selectVertex('A');
      check(s.vertices).unorderedEquals(['A']);
      check(s.activeVertex).equals('A');
      check(s.source).equals('A');
      check(s.target).isNull();

      s.selectVertex('B', toggle: true, clearOthers: false);
      check(s.vertices).unorderedEquals(['A', 'B']);
      check(s.activeVertex).equals('B');
      check(s.source).equals('B');
      check(s.target).equals('A');

      s.toggleVertex('B');
      check(s.vertices).unorderedEquals(['A']);
      check(s.activeVertex).equals('A');
      check(s.source).equals('A');
      check(s.target).isNull();
    });

    test('selectEdge and toggle', () {
      final s = Selection();
      s.selectEdge(('A', 'B'));
      check(s.edges).unorderedEquals([('A', 'B')]);
      check(s.selectedEdge).equals(('A', 'B'));

      s.selectEdge(('C', 'D'), toggle: true, clearOthers: false);
      check(s.edges).unorderedEquals([('A', 'B'), ('C', 'D')]);
      check(s.selectedEdge).equals(('C', 'D'));

      s.toggleEdge(('C', 'D'));
      check(s.edges).unorderedEquals([('A', 'B')]);
      check(s.selectedEdge).equals(('A', 'B'));
    });

    test('removeVertex removes incident edges', () {
      final s = Selection();
      s.selectVertex('A', clearOthers: false);
      s.selectVertex('B', clearOthers: false);
      s.selectEdge(('A', 'B'), clearOthers: false);
      s.selectEdge(('B', 'C'), clearOthers: false);

      s.removeVertex('A');
      check(s.vertices).unorderedEquals(['B']);
      check(s.edges).unorderedEquals([('B', 'C')]);
      check(s.selectedEdge).equals(('B', 'C'));
    });

    test('clear', () {
      final s = Selection();
      s.selectVertex('A');
      s.selectEdge(('A', 'B'), clearOthers: false);
      s.clear();
      check(s.isEmpty).isTrue();
    });

    test('filterVertices', () {
      final s = Selection();
      s.setVertices(['A', 'B', 'C']);
      s.setEdges([('A', 'B'), ('B', 'C')]);
      s.filterVertices((v) => v != 'B');
      check(s.vertices).unorderedEquals(['A', 'C']);
      check(s.edges).isEmpty();
    });
  });
}
