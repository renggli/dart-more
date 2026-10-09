import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('separatedBy', () {
    group('without before or after', () {
      test('empty', () {
        var s = 0;
        check(<int>[].separatedBy(() => s++)).isEmpty();
        check(s).equals(0);
      });
      test('single', () {
        var s = 0;
        check([10].separatedBy(() => s++)).deepEquals([10]);
        check(s).equals(0);
      });
      test('double', () {
        var s = 0;
        check([10, 20].separatedBy(() => s++)).deepEquals([10, 0, 20]);
        check(s).equals(1);
      });
      test('triple', () {
        var s = 0;
        check([10, 20, 30].separatedBy(() => s++))
            .deepEquals([10, 0, 20, 1, 30]);
        check(s).equals(2);
      });
      test('iterator', () {
        final iterator = [42].separatedBy(() => 0).iterator;
        check(iterator.moveNext()).isTrue();
        for (var i = 0; i <= 3; i++) {
          check(iterator.current).equals(42);
        }
        for (var i = 0; i <= 3; i++) {
          check(iterator.moveNext()).isFalse();
        }
      });
    });

    group('with before', () {
      test('empty', () {
        var s = 0, b = 0;
        check(<int>[].separatedBy(() => s++, before: () => b++ + 5)).isEmpty();
        check(s).equals(0);
        check(b).equals(0);
      });
      test('single', () {
        var s = 0, b = 0;
        check([10].separatedBy(() => s++, before: () => b++ + 5))
            .deepEquals([5, 10]);
        check(s).equals(0);
        check(b).equals(1);
      });
      test('double', () {
        var s = 0, b = 0;
        check([10, 20].separatedBy(() => s++, before: () => b++ + 5))
            .deepEquals([5, 10, 0, 20]);
        check(s).equals(1);
        check(b).equals(1);
      });
      test('triple', () {
        var s = 0, b = 0;
        check([10, 20, 30].separatedBy(() => s++, before: () => b++ + 5))
            .deepEquals([5, 10, 0, 20, 1, 30]);
        check(s).equals(2);
        check(b).equals(1);
      });
    });

    group('with after', () {
      test('empty', () {
        var s = 0, a = 0;
        check(<int>[].separatedBy(() => s++, after: () => a++ + 15)).isEmpty();
        check(s).equals(0);
        check(a).equals(0);
      });
      test('single', () {
        var s = 0, a = 0;
        check([10].separatedBy(() => s++, after: () => a++ + 15))
            .deepEquals([10, 15]);
        check(s).equals(0);
        check(a).equals(1);
      });
      test('double', () {
        var s = 0, a = 0;
        check([10, 20].separatedBy(() => s++, after: () => a++ + 15))
            .deepEquals([10, 0, 20, 15]);
        check(s).equals(1);
        check(a).equals(1);
      });
      test('triple', () {
        var s = 0, a = 0;
        check([10, 20, 30].separatedBy(() => s++, after: () => a++ + 15))
            .deepEquals([10, 0, 20, 1, 30, 15]);
        check(s).equals(2);
        check(a).equals(1);
      });
    });

    group('with before and after', () {
      test('empty', () {
        var s = 0, b = 0, a = 0;
        check(
          <int>[].separatedBy(
            () => s++,
            before: () => b++ + 5,
            after: () => a++ + 15,
          ),
        ).isEmpty();
        check(s).equals(0);
        check(b).equals(0);
        check(a).equals(0);
      });
      test('single', () {
        var s = 0, b = 0, a = 0;
        check(
          [10].separatedBy(
            () => s++,
            before: () => b++ + 5,
            after: () => a++ + 15,
          ),
        ).deepEquals([5, 10, 15]);
        check(s).equals(0);
        check(b).equals(1);
        check(a).equals(1);
      });
      test('double', () {
        var s = 0, b = 0, a = 0;
        check(
          [10, 20].separatedBy(
            () => s++,
            before: () => b++ + 5,
            after: () => a++ + 15,
          ),
        ).deepEquals([5, 10, 0, 20, 15]);
        check(s).equals(1);
        check(b).equals(1);
        check(a).equals(1);
      });
      test('triple', () {
        var s = 0, b = 0, a = 0;
        check(
          [10, 20, 30].separatedBy(
            () => s++,
            before: () => b++ + 5,
            after: () => a++ + 15,
          ),
        ).deepEquals([5, 10, 0, 20, 1, 30, 15]);
        check(s).equals(2);
        check(b).equals(1);
        check(a).equals(1);
      });
    });
  });
}
