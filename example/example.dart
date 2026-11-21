// ignore_for_file: avoid_print

import 'package:more/cache.dart';
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:more/math.dart';
import 'package:more/number.dart';
import 'package:more/printer.dart';

Future<void> main() async {
  // Ordered B+Tree map with O(log n) rank, select, and range queries.
  final btree = BTreeMap<String, int>.of({'b': 2, 'a': 1, 'c': 3, 'd': 4});
  print('keyAt(1): ${btree.keyAt(1)}'); // b
  print('range [b, d]: ${btree.keysInRange(min: 'b', max: 'd').toList()}');

  // R*-Tree spatial index for 2D bounding boxes and nearest-neighbor search.
  final rtree = RTree<String>.rStar()
    ..insert(Bounds.from2D(0, 0, 10, 10), 'origin-box')
    ..insert(Bounds.from2D(20, 20, 30, 30), 'far-box');
  print('nearest: ${rtree.nearest(Bounds.from2D(5, 5), k: 1).toList()}');

  // Directed weighted graph with Dijkstra shortest path and cycle detection.
  final graph = Graph<String, num>(isDirected: true)
    ..addEdge('A', 'B', value: 4)
    ..addEdge('A', 'C', value: 2)
    ..addEdge('C', 'B', value: 1);
  final path = graph.shortestPath('A', 'B');
  print('shortestPath: ${path?.vertices} (cost ${path?.cost})');

  // Exact rational arithmetic, complex numbers, and math extensions.
  final sum = Fraction(1, 3) + Fraction(1, 6);
  print(
    '1/3 + 1/6 = $sum, |3+4i| = ${const Complex(3, 4).abs()}, 5! = ${5.factorial()}',
  );

  // Unicode normalization and composable character matchers.
  print('normalized: ${'e\u0301le\u0300ve'.normalize()}');
  print('digits: ${const CharMatcher.digit().retainFrom('Room 42B')}');

  // Composable printers.
  final currency = FixedNumberPrinter(precision: 2).before(r'$').padLeft(8);
  print('formatted: ${currency(12.5)}');

  // Self-loading async LRU cache.
  final cache = Cache<String, int>.lru(
    loader: (key) => key.length,
    maximumSize: 100,
  );
  print('cached: ${await cache.get('hello')}');
}
