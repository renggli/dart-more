import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  for (final (:name, :list) in [
    (name: 'empty', list: <int>[]),
    (name: 'single', list: [42]),
    (name: 'full', list: [-6, 11, 3, -20, 16, -5, -10, -19, -7, 8, 7, 4]),
  ]) {
    group(name, () {
      final tree = FenwickTree.of(list);
      test('length', () {
        check(tree.isEmpty).equals(list.isEmpty);
        check(tree.isNotEmpty).equals(list.isNotEmpty);
        check(tree.length).equals(list.length);
      });
      test('iterator', () {
        check(List.of(tree)).deepEquals(list);
      });
      test('toList', () {
        check(tree.toList()).deepEquals(list);
      });
      test('read', () {
        for (var i = 0; i < list.length; i++) {
          check(tree[i]).equals(list[i]);
        }
        check(() => tree[-1]).throws<RangeError>();
        check(() => tree[list.length]).throws<RangeError>();
      });
      test('write', () {
        final copy = FenwickTree.of(tree);
        for (var i = 0; i < list.length; i++) {
          copy[i] = i;
        }
        check(tree).deepEquals(list);
        check(copy).deepEquals(0.to(list.length));
        check(() => tree[-1] = 0).throws<RangeError>();
        check(() => tree[list.length] = 0).throws<RangeError>();
      });
      if (list.isNotEmpty) {
        test('prefix', () {
          for (var i = 0; i <= list.length; i++) {
            check(
              tree.prefix(i),
              because: '$i',
            ).equals(list.getRange(0, i).fold(0, (a, b) => a + b));
          }
        });
        test('range', () {
          for (var i = 0; i <= list.length; i++) {
            for (var j = i; j <= list.length; j++) {
              check(
                tree.range(i, j),
                because: '$i..$j',
              ).equals(list.getRange(i, j).fold(0, (a, b) => a + b));
            }
          }
        });
        test('update', () {
          final copy = FenwickTree.of(tree);
          for (var i = 0; i < list.length; i++) {
            copy.update(i, 1);
          }
          check(copy).deepEquals(list.map((each) => each + 1));
        });
      }
    });
  }
  test('stress', () {
    final random = Random(572315);
    for (var i = 0; i < 10; i++) {
      final list = List.generate(
        random.nextInt(10000),
        (index) => random.nextInt(1000),
      );
      final tree = FenwickTree.of(list);
      check(tree.toList()).deepEquals(list);
      check(List.of(tree)).deepEquals(list);
      for (var i = 0; i < list.length; i++) {
        check(tree[i]).equals(list[i]);
      }
    }
  });
}
