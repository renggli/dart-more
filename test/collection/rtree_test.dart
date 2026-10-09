import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void allRTreeTests(
  RTree<T> Function<T>({int? minEntries, int? maxEntries}) createRTree,
) {
  void validate<T>(RTree<T> tree, [RTreeNode<T>? parent, RTreeNode<T>? node]) {
    node ??= tree.root;
    check(node.tree).identicalTo(tree);
    check(node.parent).identicalTo(parent);
    if (node.isRoot) check(node).identicalTo(tree.root);
    if (parent != null) {
      final parentEntry = node.parentEntry!;
      check(node).identicalTo(parentEntry.child!);
      for (final entry in node.entries) {
        check(parentEntry.bounds.contains(entry.bounds)).isTrue();
      }
    }
    for (final entry in node.entries) {
      if (entry.isLeaf) {
        check(entry.data).isNotNull();
        check(entry.child).isNull();
      } else {
        check(entry.data).isNull();
        check(entry.child).isNotNull();
        validate(tree, node, entry.child);
      }
    }
  }

  test('stress', () {
    final rtree = createRTree<int>();
    final random = Random(3212312);
    final bounds = <Bounds>[];
    for (var i = 0; i < 1000; i++) {
      final bound = Bounds.fromPoint(
        List.generate(3, (index) => 2000 * random.nextDouble() - 1000),
      );
      rtree.insert(bound, i);
      bounds.add(bound);
    }
    for (var i = 0; i < bounds.length; i++) {
      check(rtree.searchNodes()).isNotEmpty();
      check(rtree.searchEntries()).isNotEmpty();
      check(rtree.queryEntries(bounds[i])).isNotEmpty();
      check(rtree.queryNodes(bounds[i], leaves: true)).isNotEmpty();
      check(rtree.queryNodes(bounds[i], leaves: false)).isNotEmpty();
    }
    validate(rtree);
  });
  test('empty tree query', () {
    final rtree = createRTree<int>();
    final queryBound = Bounds.fromPoint([0, 0]);
    check(rtree.root.bounds).isNull();
    check(rtree.queryEntries(queryBound)).isEmpty();
    check(rtree.queryNodes(queryBound)).isEmpty();
  });
}

void main() {
  group('guttman', () {
    allRTreeTests(
      <T>({int? minEntries, int? maxEntries}) =>
          RTree<T>.guttmann(minEntries: minEntries, maxEntries: maxEntries),
    );
    test('split distribution', () {
      final rtree = RTree<int>.guttmann(minEntries: 2, maxEntries: 4);
      for (var i = 0; i < 5; i++) {
        rtree.insert(Bounds.fromPoint([i.toDouble()]), i);
      }
      check(rtree.root.entries).length.equals(2);
      for (final child in rtree.root.entries) {
        check(child.child!.entries.length).isGreaterOrEqual(2);
      }
    });
  });
}
