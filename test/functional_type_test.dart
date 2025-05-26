// AUTO-GENERATED CODE: DO NOT EDIT

// ignore_for_file: unnecessary_lambdas

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
      final function = constantFunction5<int, int, int, int, int, String>(
        'default',
      );
      expect(function(0, 1, 2, 3, 4), 'default');
    });
    test('constantFunction6', () {
      final function = constantFunction6<int, int, int, int, int, int, String>(
        'default',
      );
      expect(function(0, 1, 2, 3, 4, 5), 'default');
    });
    test('constantFunction7', () {
      final function =
          constantFunction7<int, int, int, int, int, int, int, String>(
            'default',
          );
      expect(function(0, 1, 2, 3, 4, 5, 6), 'default');
    });
    test('constantFunction8', () {
      final function =
          constantFunction8<int, int, int, int, int, int, int, int, String>(
            'default',
          );
      expect(function(0, 1, 2, 3, 4, 5, 6, 7), 'default');
    });
    test('constantFunction9', () {
      final function =
          constantFunction9<
            int,
            int,
            int,
            int,
            int,
            int,
            int,
            int,
            int,
            String
          >('default');
      expect(function(0, 1, 2, 3, 4, 5, 6, 7, 8), 'default');
    });
    test('constantFunction10', () {
      final function =
          constantFunction10<
            int,
            int,
            int,
            int,
            int,
            int,
            int,
            int,
            int,
            int,
            String
          >('default');
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
        () => emptyFunction8(0, 1, 2, 3, 4, 5, 6, 7),
        isNot(throwsException),
      );
    });
    test('emptyFunction9', () {
      expect(
        () => emptyFunction9(0, 1, 2, 3, 4, 5, 6, 7, 8),
        isNot(throwsException),
      );
    });
    test('emptyFunction10', () {
      expect(
        () => emptyFunction10(0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
        isNot(throwsException),
      );
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
      final function = throwFunction7<int, int, int, int, int, int, int>(
        throwable,
      );
      expect(() => function(0, 1, 2, 3, 4, 5, 6), throwsUnimplementedError);
    });
    test('throwFunction8', () {
      final function = throwFunction8<int, int, int, int, int, int, int, int>(
        throwable,
      );
      expect(() => function(0, 1, 2, 3, 4, 5, 6, 7), throwsUnimplementedError);
    });
    test('throwFunction9', () {
      final function =
          throwFunction9<int, int, int, int, int, int, int, int, int>(
            throwable,
          );
      expect(
        () => function(0, 1, 2, 3, 4, 5, 6, 7, 8),
        throwsUnimplementedError,
      );
    });
    test('throwFunction10', () {
      final function =
          throwFunction10<int, int, int, int, int, int, int, int, int, int>(
            throwable,
          );
      expect(
        () => function(0, 1, 2, 3, 4, 5, 6, 7, 8, 9),
        throwsUnimplementedError,
      );
    });
  });
  group('partial', () {
    group('1-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1) => [arg1];
        final bound = function.bind0(-1);
        expect(bound(), [-1]);
      });
    });
    group('2-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1, int arg2) => [arg1, arg2];
        final bound = function.bind0(-1);
        expect(bound(0), [-1, 0]);
      });
      test('bind 1st argument', () {
        List<int> function(int arg1, int arg2) => [arg1, arg2];
        final bound = function.bind1(-1);
        expect(bound(0), [0, -1]);
      });
    });
    group('3-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1, int arg2, int arg3) => [arg1, arg2, arg3];
        final bound = function.bind0(-1);
        expect(bound(0, 1), [-1, 0, 1]);
      });
      test('bind 1st argument', () {
        List<int> function(int arg1, int arg2, int arg3) => [arg1, arg2, arg3];
        final bound = function.bind1(-1);
        expect(bound(0, 1), [0, -1, 1]);
      });
      test('bind 2nd argument', () {
        List<int> function(int arg1, int arg2, int arg3) => [arg1, arg2, arg3];
        final bound = function.bind2(-1);
        expect(bound(0, 1), [0, 1, -1]);
      });
    });
    group('4-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4) => [
          arg1,
          arg2,
          arg3,
          arg4,
        ];
        final bound = function.bind0(-1);
        expect(bound(0, 1, 2), [-1, 0, 1, 2]);
      });
      test('bind 1st argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4) => [
          arg1,
          arg2,
          arg3,
          arg4,
        ];
        final bound = function.bind1(-1);
        expect(bound(0, 1, 2), [0, -1, 1, 2]);
      });
      test('bind 2nd argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4) => [
          arg1,
          arg2,
          arg3,
          arg4,
        ];
        final bound = function.bind2(-1);
        expect(bound(0, 1, 2), [0, 1, -1, 2]);
      });
      test('bind 3rd argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4) => [
          arg1,
          arg2,
          arg3,
          arg4,
        ];
        final bound = function.bind3(-1);
        expect(bound(0, 1, 2), [0, 1, 2, -1]);
      });
    });
    group('5-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind0(-1);
        expect(bound(0, 1, 2, 3), [-1, 0, 1, 2, 3]);
      });
      test('bind 1st argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind1(-1);
        expect(bound(0, 1, 2, 3), [0, -1, 1, 2, 3]);
      });
      test('bind 2nd argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind2(-1);
        expect(bound(0, 1, 2, 3), [0, 1, -1, 2, 3]);
      });
      test('bind 3rd argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind3(-1);
        expect(bound(0, 1, 2, 3), [0, 1, 2, -1, 3]);
      });
      test('bind 4th argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind4(-1);
        expect(bound(0, 1, 2, 3), [0, 1, 2, 3, -1]);
      });
    });
    group('6-ary function', () {
      test('bind 0th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6];
        final bound = function.bind0(-1);
        expect(bound(0, 1, 2, 3, 4), [-1, 0, 1, 2, 3, 4]);
      });
      test('bind 1st argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6];
        final bound = function.bind1(-1);
        expect(bound(0, 1, 2, 3, 4), [0, -1, 1, 2, 3, 4]);
      });
      test('bind 2nd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6];
        final bound = function.bind2(-1);
        expect(bound(0, 1, 2, 3, 4), [0, 1, -1, 2, 3, 4]);
      });
      test('bind 3rd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6];
        final bound = function.bind3(-1);
        expect(bound(0, 1, 2, 3, 4), [0, 1, 2, -1, 3, 4]);
      });
      test('bind 4th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6];
        final bound = function.bind4(-1);
        expect(bound(0, 1, 2, 3, 4), [0, 1, 2, 3, -1, 4]);
      });
      test('bind 5th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6];
        final bound = function.bind5(-1);
        expect(bound(0, 1, 2, 3, 4), [0, 1, 2, 3, 4, -1]);
      });
    });
    group('7-ary function', () {
      test('bind 0th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7];
        final bound = function.bind0(-1);
        expect(bound(0, 1, 2, 3, 4, 5), [-1, 0, 1, 2, 3, 4, 5]);
      });
      test('bind 1st argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7];
        final bound = function.bind1(-1);
        expect(bound(0, 1, 2, 3, 4, 5), [0, -1, 1, 2, 3, 4, 5]);
      });
      test('bind 2nd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7];
        final bound = function.bind2(-1);
        expect(bound(0, 1, 2, 3, 4, 5), [0, 1, -1, 2, 3, 4, 5]);
      });
      test('bind 3rd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7];
        final bound = function.bind3(-1);
        expect(bound(0, 1, 2, 3, 4, 5), [0, 1, 2, -1, 3, 4, 5]);
      });
      test('bind 4th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7];
        final bound = function.bind4(-1);
        expect(bound(0, 1, 2, 3, 4, 5), [0, 1, 2, 3, -1, 4, 5]);
      });
      test('bind 5th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7];
        final bound = function.bind5(-1);
        expect(bound(0, 1, 2, 3, 4, 5), [0, 1, 2, 3, 4, -1, 5]);
      });
      test('bind 6th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7];
        final bound = function.bind6(-1);
        expect(bound(0, 1, 2, 3, 4, 5), [0, 1, 2, 3, 4, 5, -1]);
      });
    });
    group('8-ary function', () {
      test('bind 0th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
        final bound = function.bind0(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6), [-1, 0, 1, 2, 3, 4, 5, 6]);
      });
      test('bind 1st argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
        final bound = function.bind1(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6), [0, -1, 1, 2, 3, 4, 5, 6]);
      });
      test('bind 2nd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
        final bound = function.bind2(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6), [0, 1, -1, 2, 3, 4, 5, 6]);
      });
      test('bind 3rd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
        final bound = function.bind3(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6), [0, 1, 2, -1, 3, 4, 5, 6]);
      });
      test('bind 4th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
        final bound = function.bind4(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6), [0, 1, 2, 3, -1, 4, 5, 6]);
      });
      test('bind 5th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
        final bound = function.bind5(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6), [0, 1, 2, 3, 4, -1, 5, 6]);
      });
      test('bind 6th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
        final bound = function.bind6(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6), [0, 1, 2, 3, 4, 5, -1, 6]);
      });
      test('bind 7th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
        final bound = function.bind7(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6), [0, 1, 2, 3, 4, 5, 6, -1]);
      });
    });
    group('9-ary function', () {
      test('bind 0th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind0(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [-1, 0, 1, 2, 3, 4, 5, 6, 7]);
      });
      test('bind 1st argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind1(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [0, -1, 1, 2, 3, 4, 5, 6, 7]);
      });
      test('bind 2nd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind2(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [0, 1, -1, 2, 3, 4, 5, 6, 7]);
      });
      test('bind 3rd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind3(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [0, 1, 2, -1, 3, 4, 5, 6, 7]);
      });
      test('bind 4th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind4(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [0, 1, 2, 3, -1, 4, 5, 6, 7]);
      });
      test('bind 5th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind5(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [0, 1, 2, 3, 4, -1, 5, 6, 7]);
      });
      test('bind 6th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind6(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [0, 1, 2, 3, 4, 5, -1, 6, 7]);
      });
      test('bind 7th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind7(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [0, 1, 2, 3, 4, 5, 6, -1, 7]);
      });
      test('bind 8th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
        final bound = function.bind8(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7), [0, 1, 2, 3, 4, 5, 6, 7, -1]);
      });
    });
    group('10-ary function', () {
      test('bind 0th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind0(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          -1,
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ]);
      });
      test('bind 1st argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind1(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          -1,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ]);
      });
      test('bind 2nd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind2(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          1,
          -1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
        ]);
      });
      test('bind 3rd argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind3(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          1,
          2,
          -1,
          3,
          4,
          5,
          6,
          7,
          8,
        ]);
      });
      test('bind 4th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind4(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          1,
          2,
          3,
          -1,
          4,
          5,
          6,
          7,
          8,
        ]);
      });
      test('bind 5th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind5(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          1,
          2,
          3,
          4,
          -1,
          5,
          6,
          7,
          8,
        ]);
      });
      test('bind 6th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind6(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          1,
          2,
          3,
          4,
          5,
          -1,
          6,
          7,
          8,
        ]);
      });
      test('bind 7th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind7(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          -1,
          7,
          8,
        ]);
      });
      test('bind 8th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind8(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          -1,
          8,
        ]);
      });
      test('bind 9th argument', () {
        List<int> function(
          int arg1,
          int arg2,
          int arg3,
          int arg4,
          int arg5,
          int arg6,
          int arg7,
          int arg8,
          int arg9,
          int arg10,
        ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
        final bound = function.bind9(-1);
        expect(bound(0, 1, 2, 3, 4, 5, 6, 7, 8), [
          0,
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          -1,
        ]);
      });
    });
  });
  group('curry', () {
    test('1-ary function', () {
      List<int> function(int arg1) => [arg1];
      expect(function.curry(0), [0]);
    });
    test('2-ary function', () {
      List<int> function(int arg1, int arg2) => [arg1, arg2];
      expect(function.curry(0)(1), [0, 1]);
    });
    test('3-ary function', () {
      List<int> function(int arg1, int arg2, int arg3) => [arg1, arg2, arg3];
      expect(function.curry(0)(1)(2), [0, 1, 2]);
    });
    test('4-ary function', () {
      List<int> function(int arg1, int arg2, int arg3, int arg4) => [
        arg1,
        arg2,
        arg3,
        arg4,
      ];
      expect(function.curry(0)(1)(2)(3), [0, 1, 2, 3]);
    });
    test('5-ary function', () {
      List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) => [
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
      ];
      expect(function.curry(0)(1)(2)(3)(4), [0, 1, 2, 3, 4]);
    });
    test('6-ary function', () {
      List<int> function(
        int arg1,
        int arg2,
        int arg3,
        int arg4,
        int arg5,
        int arg6,
      ) => [arg1, arg2, arg3, arg4, arg5, arg6];
      expect(function.curry(0)(1)(2)(3)(4)(5), [0, 1, 2, 3, 4, 5]);
    });
    test('7-ary function', () {
      List<int> function(
        int arg1,
        int arg2,
        int arg3,
        int arg4,
        int arg5,
        int arg6,
        int arg7,
      ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7];
      expect(function.curry(0)(1)(2)(3)(4)(5)(6), [0, 1, 2, 3, 4, 5, 6]);
    });
    test('8-ary function', () {
      List<int> function(
        int arg1,
        int arg2,
        int arg3,
        int arg4,
        int arg5,
        int arg6,
        int arg7,
        int arg8,
      ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8];
      expect(function.curry(0)(1)(2)(3)(4)(5)(6)(7), [0, 1, 2, 3, 4, 5, 6, 7]);
    });
    test('9-ary function', () {
      List<int> function(
        int arg1,
        int arg2,
        int arg3,
        int arg4,
        int arg5,
        int arg6,
        int arg7,
        int arg8,
        int arg9,
      ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9];
      expect(function.curry(0)(1)(2)(3)(4)(5)(6)(7)(8), [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
      ]);
    });
    test('10-ary function', () {
      List<int> function(
        int arg1,
        int arg2,
        int arg3,
        int arg4,
        int arg5,
        int arg6,
        int arg7,
        int arg8,
        int arg9,
        int arg10,
      ) => [arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10];
      expect(function.curry(0)(1)(2)(3)(4)(5)(6)(7)(8)(9), [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
      ]);
    });
  });
}
