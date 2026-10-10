import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('partition', () {
    test('empty', () {
      final result = <int>[].partition((each) => each.isEven);
      check(result.truthy).isEmpty();
      check(result.falsey).isEmpty();
    });
    test('single true', () {
      final result = ['hello'].partition((each) => true);
      check(result.truthy).deepEquals(['hello']);
      check(result.falsey).isEmpty();
    });
    test('single false', () {
      final result = ['world'].partition((each) => false);
      check(result.truthy).isEmpty();
      check(result.falsey).deepEquals(['world']);
    });
    test('example', () {
      final result = [1, 2, 3, 4].partition((each) => each.isEven);
      check(result.truthy).deepEquals([2, 4]);
      check(result.falsey).deepEquals([1, 3]);
    });
  });
}
