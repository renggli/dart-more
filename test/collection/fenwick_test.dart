// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

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
        expect(tree.isEmpty, list.isEmpty);
        expect(tree.isNotEmpty, list.isNotEmpty);
        expect(tree.length, list.length);
      });
      test('iterator', () {
        expect(List.of(tree), list);
      });
      test('toList', () {
        expect(tree.toList(), list);
      });
      test('read', () {
        for (var i = 0; i < list.length; i++) {
          expect(tree[i], list[i]);
        }
        expect(() => tree[-1], throwsRangeError);
        expect(() => tree[list.length], throwsRangeError);
      });
      test('write', () {
        final copy = FenwickTree.of(tree);
        for (var i = 0; i < list.length; i++) {
          copy[i] = i;
        }
        expect(tree, list);
        expect(copy, 0.to(list.length));
        expect(() => tree[-1] = 0, throwsRangeError);
        expect(() => tree[list.length] = 0, throwsRangeError);
      });
      if (list.isNotEmpty) {
        test('prefix', () {
          for (var i = 0; i <= list.length; i++) {
            expect(
              tree.prefix(i),
              list.getRange(0, i).fold(0, (a, b) => a + b),
              reason: '$i',
            );
          }
        });
        test('range', () {
          for (var i = 0; i <= list.length; i++) {
            for (var j = i; j <= list.length; j++) {
              expect(
                tree.range(i, j),
                list.getRange(i, j).fold(0, (a, b) => a + b),
                reason: '$i..$j',
              );
            }
          }
        });
        test('update', () {
          final copy = FenwickTree.of(tree);
          for (var i = 0; i < list.length; i++) {
            copy.update(i, 1);
          }
          expect(copy, list.map((each) => each + 1));
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
      expect(tree.toList(), list);
      expect(List.of(tree), list);
      for (var i = 0; i < list.length; i++) {
        expect(tree[i], list[i]);
      }
    }
  });
}
