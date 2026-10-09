import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('edge', () {
    group('directed', () {
      const a = Edge<int, void>.directed(1, 2);
      const b = Edge<int, String>.directed(1, 2, value: 'a');
      const c = Edge<int, String>.directed(2, 1, value: 'a');
      const d = Edge<int, String>.directed(1, 2, value: 'b');
      test('create (without data)', () {
        check(a.source).equals(1);
        check(a.target).equals(2);
        check(a.isDirected).isTrue();
      });
      test('create (with data)', () {
        check(b.source).equals(1);
        check(b.target).equals(2);
        check(b.value).equals('a');
        check(b.isDirected).isTrue();
      });
      test('equals', () {
        check(a == a).isTrue();
        check(a == b).isFalse();
        check(a == c).isFalse();
        check(a == d).isFalse();
        check(b == a).isFalse();
        check(b == b).isTrue();
        check(b == c).isFalse();
        check(b == d).isFalse();
        check(c == a).isFalse();
        check(c == b).isFalse();
        check(c == c).isTrue();
        check(c == d).isFalse();
        check(d == a).isFalse();
        check(d == b).isFalse();
        check(d == c).isFalse();
        check(d == d).isTrue();
      });
      test('hashCode', () {
        check(a.hashCode).not((it) => it.equals(b.hashCode));
        check(a.hashCode).not((it) => it.equals(c.hashCode));
        check(a.hashCode).not((it) => it.equals(d.hashCode));
        check(b.hashCode).not((it) => it.equals(c.hashCode));
        check(b.hashCode).not((it) => it.equals(d.hashCode));
        check(c.hashCode).not((it) => it.equals(d.hashCode));
      });
      test('toString', () {
        check(a.toString()).endsWith('(1 → 2)');
        check(b.toString()).endsWith('(1 → 2, value: a)');
        check(c.toString()).endsWith('(2 → 1, value: a)');
        check(d.toString()).endsWith('(1 → 2, value: b)');
      });
      test('directed equality', () {
        const e1 = Edge.directed('a', 'b', value: 1);
        const e2 = Edge.directed('a', 'b', value: 1);
        const e3 = Edge.directed('b', 'a', value: 1);
        const e4 = Edge.directed('a', 'b', value: 2);
        check(e1 == e2).isTrue();
        check(e1.hashCode).equals(e2.hashCode);
        check(e1 == e3).isFalse();
        check(e1 == e4).isFalse();
      });
    });
    group('undirected', () {
      const a = Edge<int, void>.undirected(1, 2);
      const b = Edge<int, String>.undirected(1, 2, value: 'a');
      const c = Edge<int, String>.undirected(2, 1, value: 'a');
      const d = Edge<int, String>.undirected(1, 2, value: 'b');
      test('create (without data)', () {
        check(a.source).equals(1);
        check(a.target).equals(2);
        check(a.isDirected).isFalse();
      });
      test('create (with data)', () {
        check(b.source).equals(1);
        check(b.target).equals(2);
        check(b.value).equals('a');
        check(b.isDirected).isFalse();
      });
      test('equals', () {
        check(a == a).isTrue();
        check(a == b).isFalse();
        check(a == c).isFalse();
        check(a == d).isFalse();
        check(b == a).isFalse();
        check(b == b).isTrue();
        check(b == c).isTrue();
        check(b == d).isFalse();
        check(c == a).isFalse();
        check(c == b).isTrue();
        check(c == c).isTrue();
        check(c == d).isFalse();
        check(d == a).isFalse();
        check(d == b).isFalse();
        check(d == c).isFalse();
        check(d == d).isTrue();
      });
      test('hashCode', () {
        check(a.hashCode).not((it) => it.equals(b.hashCode));
        check(a.hashCode).not((it) => it.equals(c.hashCode));
        check(a.hashCode).not((it) => it.equals(d.hashCode));
        check(b.hashCode).equals(c.hashCode);
        check(b.hashCode).not((it) => it.equals(d.hashCode));
        check(c.hashCode).not((it) => it.equals(d.hashCode));
      });
      test('toString', () {
        check(a.toString()).endsWith('(1 — 2)');
        check(b.toString()).endsWith('(1 — 2, value: a)');
        check(c.toString()).endsWith('(2 — 1, value: a)');
        check(d.toString()).endsWith('(1 — 2, value: b)');
      });
      test('undirected equality', () {
        const e1 = Edge.undirected('a', 'b', value: 1);
        const e2 = Edge.undirected('b', 'a', value: 1);
        const e3 = Edge.undirected('a', 'b', value: 2);
        check(e1 == e2).isTrue();
        check(e1.hashCode).equals(e2.hashCode);
        check(e1 == e3).isFalse();
      });
    });
  });
}
