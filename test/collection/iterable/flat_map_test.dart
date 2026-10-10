import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('flatMap', () {
    test('empty', () {
      check(
        <int>[].flatMap<String>(
          (each) => throw StateError('Never to be called'),
        ),
      ).isEmpty();
    });
    test('expand', () {
      check(['a'].flatMap((each) => [1, 2])).deepEquals([1, 2]);
    });
    test('collapse', () {
      check(['a', 'b'].flatMap((each) => [])).isEmpty();
    });
  });
}
