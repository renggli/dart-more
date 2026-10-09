import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('scope', () {
    group('also', () {
      test('cascade', () {
        final results = <String>[];
        [1, 2, 3]
          ..also((list) => results.add('Before: $list'))
          ..add(4)
          ..also((list) => results.add('After: $list'));
        check(results).deepEquals(['Before: [1, 2, 3]', 'After: [1, 2, 3, 4]']);
      });
      test('nullable', () {
        final input = [null, 'abc', '42'];
        final output = [null, null, 42];
        for (var i = 0; i < input.length; i++) {
          check(
            input[i]?.also(int.tryParse),
            because: 'Input $i with "${input[i]}"',
          ).equals(output[i]);
        }
      });
    });
  });
}
