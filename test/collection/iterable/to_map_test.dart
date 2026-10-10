import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('toMap', () {
    test('empty', () {
      check(<int>[].toMap<int, int>()).isEmpty();
    });
    test('default', () {
      const iterable = ['a', 'bb', 'ccc'];
      check(iterable.toMap<String, String>())
          .deepEquals({'a': 'a', 'bb': 'bb', 'ccc': 'ccc'});
    });
    test('custom', () {
      const iterable = ['a', 'bb', 'ccc'];
      check(
        iterable.toMap(key: (each) => each[0], value: (each) => each.length),
      ).deepEquals({'a': 1, 'b': 2, 'c': 3});
    });
  });
}
