import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('path', () {
    test('fromVertices (without data)', () {
      final path = Path<int, void>.fromVertices([1, 2, 3]);
      check(path.vertices).deepEquals([1, 2, 3]);
      check(path.values).deepEquals([null, null]);
      check(path.source).equals(1);
      check(path.target).equals(3);
      check(path.edges).unorderedMatches([isEdge(1, 2), isEdge(2, 3)]);
      check(path.toString()).endsWith('(1 → 2 → 3)');
    });
    test('fromVertices (with data)', () {
      final path = Path<String, int>.fromVertices(
        ['a', 'b', 'c'],
        values: [2, 3],
      );
      check(path.vertices).deepEquals(['a', 'b', 'c']);
      check(path.values).deepEquals([2, 3]);
      check(path.source).equals('a');
      check(path.target).equals('c');
      check(path.edges).unorderedMatches([isEdge('a', 'b'), isEdge('b', 'c')]);
      check(path.cost).equals(5);
      check(path.toString()).endsWith('(a → b → c, values: [2, 3], cost: 5)');
    });
    test('fromEdges (without data)', () {
      final path = Path<int, void>.fromEdges(const [
        Edge.directed(4, 5),
        Edge.undirected(5, 6),
      ]);
      check(path.vertices).deepEquals([4, 5, 6]);
      check(path.values).deepEquals([null, null]);
      check(path.source).equals(4);
      check(path.target).equals(6);
      check(path.edges).unorderedMatches([isEdge(4, 5), isEdge(5, 6)]);
      check(path.toString()).endsWith('(4 → 5 → 6)');
    });
    test('fromEdges (with data)', () {
      final path = Path<String, int>.fromEdges(const [
        Edge.undirected('x', 'y', value: 4),
        Edge.directed('y', 'z', value: 5),
      ]);
      check(path.vertices).deepEquals(['x', 'y', 'z']);
      check(path.values).deepEquals([4, 5]);
      check(path.source).equals('x');
      check(path.target).equals('z');
      check(path.edges).unorderedMatches([isEdge('x', 'y'), isEdge('y', 'z')]);
      check(path.cost).equals(9);
      check(path.toString()).endsWith('(x → y → z, values: [4, 5], cost: 9)');
    });
    test('long path', () {
      final vertices = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
      final values = [1, 2, 3, 4, 5, 6, 7];
      final path = Path<String, int>.fromVertices(vertices, values: values);
      check(path.vertices).deepEquals(vertices);
      check(path.values).deepEquals(values);
      check(path.source).equals('a');
      check(path.target).equals('h');
      check(path.edges).unorderedMatches([
        isEdge('a', 'b', value: 1),
        isEdge('b', 'c', value: 2),
        isEdge('c', 'd', value: 3),
        isEdge('d', 'e', value: 4),
        isEdge('e', 'f', value: 5),
        isEdge('f', 'g', value: 6),
        isEdge('g', 'h', value: 7),
      ]);
      check(path.toString()).endsWith(
        '(a → b → c → … → f → g → h (8 total), '
        'values: [1, 2, 3, …, 5, 6, 7], '
        'cost: 28)',
      );
    });
    final a = Path<String, int>.fromVertices(['a', 'b', 'c'], values: [1, 2]);
    final b = Path<String, int>.fromVertices(['a', 'b', 'd'], values: [2, 1]);
    final c = Path<String, int>.fromEdges(const [
      Edge.undirected('a', 'b', value: 1),
      Edge.undirected('b', 'c', value: 2),
    ]);
    test('equals', () {
      check(a == a).isTrue();
      check(a == b).isFalse();
      check(a == c).isTrue();
      check(b == a).isFalse();
      check(b == b).isTrue();
      check(b == c).isFalse();
      check(c == a).isTrue();
      check(c == b).isFalse();
      check(c == c).isTrue();
    });
    test('hashCode', () {
      check(a.hashCode == b.hashCode).isFalse();
      check(a.hashCode == c.hashCode).isTrue();
    });
  });
}
