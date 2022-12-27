import 'package:more/functional.dart';
import 'package:test/test.dart';

void main() {
  group('constant', () {
    test('constantFunction0', () {
      final function = constantFunction0<String>('default');
      expect(function(), 'default');
    });
    test('constantFunction1', () {
      final function = constantFunction1<int, String>('default');
      expect(function(0), 'default');
    });
    test('constantFunction2', () {
      final function = constantFunction2<int, int, String>('default');
      expect(function(0, 1), 'default');
    });
    test('constantFunction3', () {
      final function = constantFunction3<int, int, int, String>('default');
      expect(function(0, 1, 2), 'default');
    });
    test('constantFunction4', () {
      final function = constantFunction4<int, int, int, int, String>('default');
      expect(function(0, 1, 2, 3), 'default');
    });
    test('constantFunction5', () {
      final function =
          constantFunction5<int, int, int, int, int, String>('default');
      expect(function(0, 1, 2, 3, 4), 'default');
    });
    test('constantFunction6', () {
      final function =
          constantFunction6<int, int, int, int, int, int, String>('default');
      expect(function(0, 1, 2, 3, 4, 5), 'default');
    });
    test('constantFunction7', () {
      final function =
          constantFunction7<int, int, int, int, int, int, int, String>(
              'default');
      expect(function(0, 1, 2, 3, 4, 5, 6), 'default');
    });
    test('constantFunction8', () {
      final function =
          constantFunction8<int, int, int, int, int, int, int, int, String>(
              'default');
      expect(function(0, 1, 2, 3, 4, 5, 6, 7), 'default');
    });
    test('constantFunction9', () {
      final function = constantFunction9<int, int, int, int, int, int, int, int,
          int, String>('default');
      expect(function(0, 1, 2, 3, 4, 5, 6, 7, 8), 'default');
    });
    test('constantFunction10', () {
      final function = constantFunction10<int, int, int, int, int, int, int,
          int, int, int, String>('default');
      expect(function(0, 1, 2, 3, 4, 5, 6, 7, 8, 9), 'default');
    });
  });
  group('empty', () {
    test('emptyFunction0', () {
      expect(() => emptyFunction0(), isNot(throwsException));
    });
    test('emptyFunction1', () {
      expect(() => emptyFunction1(0), isNot(throwsException));
    });
    test('emptyFunction2', () {
      expect(() => emptyFunction2(0, 1), isNot(throwsException));
    });
    test('emptyFunction3', () {
      expect(() => emptyFunction3(0, 1, 2), isNot(throwsException));
    });
    test('emptyFunction4', () {
      expect(() => emptyFunction4(0, 1, 2, 3), isNot(throwsException));
    });
    test('emptyFunction5', () {
      expect(() => emptyFunction5(0, 1, 2, 3, 4), isNot(throwsException));
    });
    test('emptyFunction6', () {
      expect(() => emptyFunction6(0, 1, 2, 3, 4, 5), isNot(throwsException));
    });
    test('emptyFunction7', () {
      expect(() => emptyFunction7(0, 1, 2, 3, 4, 5, 6), isNot(throwsException));
    });
    test('emptyFunction8', () {
      expect(
          () => emptyFunction8(0, 1, 2, 3, 4, 5, 6, 7), isNot(throwsException));
    });
    test('emptyFunction9', () {
      expect(() => emptyFunction9(0, 1, 2, 3, 4, 5, 6, 7, 8),
          isNot(throwsException));
    });
    test('emptyFunction10', () {
      expect(() => emptyFunction10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
          isNot(throwsException));
    });
  });
  test('identity', () {
    expect(identityFunction(42), 42);
    expect(identityFunction('foo'), 'foo');
  });
  group('throwing', () {
    final throwable = UnimplementedError();
    test('throwFunction0', () {
      final function = throwFunction0(throwable);
      expect(() => function(), throwsUnimplementedError);
    });
    test('throwFunction1', () {
      final function = throwFunction1<int>(throwable);
      expect(() => function(0), throwsUnimplementedError);
    });
    test('throwFunction2', () {
      final function = throwFunction2<int, int>(throwable);
      expect(() => function(0, 1), throwsUnimplementedError);
    });
    test('throwFunction3', () {
      final function = throwFunction3<int, int, int>(throwable);
      expect(() => function(0, 1, 2), throwsUnimplementedError);
    });
    test('throwFunction4', () {
      final function = throwFunction4<int, int, int, int>(throwable);
      expect(() => function(0, 1, 2, 3), throwsUnimplementedError);
    });
    test('throwFunction5', () {
      final function = throwFunction5<int, int, int, int, int>(throwable);
      expect(() => function(0, 1, 2, 3, 4), throwsUnimplementedError);
    });
    test('throwFunction6', () {
      final function = throwFunction6<int, int, int, int, int, int>(throwable);
      expect(() => function(0, 1, 2, 3, 4, 5), throwsUnimplementedError);
    });
    test('throwFunction7', () {
      final function =
          throwFunction7<int, int, int, int, int, int, int>(throwable);
      expect(() => function(0, 1, 2, 3, 4, 5, 6), throwsUnimplementedError);
    });
    test('throwFunction8', () {
      final function =
          throwFunction8<int, int, int, int, int, int, int, int>(throwable);
      expect(() => function(0, 1, 2, 3, 4, 5, 6, 7), throwsUnimplementedError);
    });
    test('throwFunction9', () {
      final function =
          throwFunction9<int, int, int, int, int, int, int, int, int>(
              throwable);
      expect(
          () => function(0, 1, 2, 3, 4, 5, 6, 7, 8), throwsUnimplementedError);
    });
    test('throwFunction10', () {
      final function =
          throwFunction10<int, int, int, int, int, int, int, int, int, int>(
              throwable);
      expect(() => function(0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
          throwsUnimplementedError);
    });
  });
}
