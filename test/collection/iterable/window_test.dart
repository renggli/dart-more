import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('window', () {
    test('error', () {
      check(() => [1, 2, 3].window(0)).throws<RangeError>();
      check(() => [1, 2, 3].window(1, step: 0)).throws<RangeError>();
    });
    test('size = 1', () {
      check(<int>[].window(1)).isEmpty();
      check([1].window(1)).deepEquals([
        [1],
      ]);
      check([1, 2].window(1)).deepEquals([
        [1],
        [2],
      ]);
      check([1, 2, 3].window(1)).deepEquals([
        [1],
        [2],
        [3],
      ]);
      check([1, 2, 3, 4].window(1)).deepEquals([
        [1],
        [2],
        [3],
        [4],
      ]);
      check([1, 2, 3, 4, 5].window(1)).deepEquals([
        [1],
        [2],
        [3],
        [4],
        [5],
      ]);
    });
    test('size = 2', () {
      check(<int>[].window(2)).isEmpty();
      check([1].window(2)).isEmpty();
      check([1, 2].window(2)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3].window(2)).deepEquals([
        [1, 2],
        [2, 3],
      ]);
      check([1, 2, 3, 4].window(2)).deepEquals([
        [1, 2],
        [2, 3],
        [3, 4],
      ]);
      check([1, 2, 3, 4, 5].window(2)).deepEquals([
        [1, 2],
        [2, 3],
        [3, 4],
        [4, 5],
      ]);
    });
    test('size = 2, step = 2', () {
      check(<int>[].window(2, step: 2)).isEmpty();
      check([1].window(2, step: 2)).isEmpty();
      check([1, 2].window(2, step: 2)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3].window(2, step: 2)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3, 4].window(2, step: 2)).deepEquals([
        [1, 2],
        [3, 4],
      ]);
      check([1, 2, 3, 4, 5].window(2, step: 2)).deepEquals([
        [1, 2],
        [3, 4],
      ]);
    });
    test('size = 2, step = 3', () {
      check(<int>[].window(2, step: 3)).isEmpty();
      check([1].window(2, step: 3)).isEmpty();
      check([1, 2].window(2, step: 3)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3].window(2, step: 3)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3, 4].window(2, step: 3)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3, 4, 5].window(2, step: 3)).deepEquals([
        [1, 2],
        [4, 5],
      ]);
    });
    test('size = 2, includePartial', () {
      check(<int>[].window(2, includePartial: true)).isEmpty();
      check([1].window(2, includePartial: true)).deepEquals([
        [1],
      ]);
      check([1, 2].window(2, includePartial: true)).deepEquals([
        [1, 2],
        [2],
      ]);
      check([1, 2, 3].window(2, includePartial: true)).deepEquals([
        [1, 2],
        [2, 3],
        [3],
      ]);
      check([1, 2, 3, 4].window(2, includePartial: true)).deepEquals([
        [1, 2],
        [2, 3],
        [3, 4],
        [4],
      ]);
      check([1, 2, 3, 4, 5].window(2, includePartial: true)).deepEquals([
        [1, 2],
        [2, 3],
        [3, 4],
        [4, 5],
        [5],
      ]);
    });
    test('size = 2, step = 2, includePartial', () {
      check(<int>[].window(2, step: 2, includePartial: true)).isEmpty();
      check([1].window(2, step: 2, includePartial: true)).deepEquals([
        [1],
      ]);
      check([1, 2].window(2, step: 2, includePartial: true)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3].window(2, step: 2, includePartial: true)).deepEquals([
        [1, 2],
        [3],
      ]);
      check([1, 2, 3, 4].window(2, step: 2, includePartial: true)).deepEquals([
        [1, 2],
        [3, 4],
      ]);
      check([1, 2, 3, 4, 5].window(2, step: 2, includePartial: true))
          .deepEquals([
            [1, 2],
            [3, 4],
            [5],
          ]);
    });
    test('size = 2, step = 3, includePartial', () {
      check(<int>[].window(2, step: 3, includePartial: true)).isEmpty();
      check([1].window(2, step: 3, includePartial: true)).deepEquals([
        [1],
      ]);
      check([1, 2].window(2, step: 3, includePartial: true)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3].window(2, step: 3, includePartial: true)).deepEquals([
        [1, 2],
      ]);
      check([1, 2, 3, 4].window(2, step: 3, includePartial: true)).deepEquals([
        [1, 2],
        [4],
      ]);
      check([1, 2, 3, 4, 5].window(2, step: 3, includePartial: true))
          .deepEquals([
            [1, 2],
            [4, 5],
          ]);
    });
  });
}
