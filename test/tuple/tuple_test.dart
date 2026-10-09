// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Tuple', () {
    test('fromList', () {
      check(Tuple.fromList([])).equals(());
      check(Tuple.fromList([1])).equals((1,));
      check(Tuple.fromList([1, 2])).equals((1, 2));
      check(Tuple.fromList([1, 2, 3])).equals((1, 2, 3));
      check(Tuple.fromList([1, 2, 3, 4])).equals((1, 2, 3, 4));
      check(Tuple.fromList([1, 2, 3, 4, 5])).equals((1, 2, 3, 4, 5));
      check(Tuple.fromList([1, 2, 3, 4, 5, 6])).equals((1, 2, 3, 4, 5, 6));
      check(Tuple.fromList([1, 2, 3, 4, 5, 6, 7]))
          .equals((1, 2, 3, 4, 5, 6, 7));
      check(Tuple.fromList([1, 2, 3, 4, 5, 6, 7, 8]))
          .equals((1, 2, 3, 4, 5, 6, 7, 8));
      check(Tuple.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9]))
          .equals((1, 2, 3, 4, 5, 6, 7, 8, 9));
      check(() => Tuple.fromList([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]))
          .throws<ArgumentError>();
    });
  });
}
