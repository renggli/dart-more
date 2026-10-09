// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('partial', () {
    group('1-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1) => [arg1];
        final bound = function.bind0(-1);
        check(bound()).deepEquals([-1]);
      });
    });
    group('2-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1, int arg2) => [arg1, arg2];
        final bound = function.bind0(-1);
        check(bound(0)).deepEquals([-1, 0]);
      });
      test('bind 1st argument', () {
        List<int> function(int arg1, int arg2) => [arg1, arg2];
        final bound = function.bind1(-1);
        check(bound(0)).deepEquals([0, -1]);
      });
    });
    group('3-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1, int arg2, int arg3) => [arg1, arg2, arg3];
        final bound = function.bind0(-1);
        check(bound(0, 1)).deepEquals([-1, 0, 1]);
      });
      test('bind 1st argument', () {
        List<int> function(int arg1, int arg2, int arg3) => [arg1, arg2, arg3];
        final bound = function.bind1(-1);
        check(bound(0, 1)).deepEquals([0, -1, 1]);
      });
      test('bind 2nd argument', () {
        List<int> function(int arg1, int arg2, int arg3) => [arg1, arg2, arg3];
        final bound = function.bind2(-1);
        check(bound(0, 1)).deepEquals([0, 1, -1]);
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
        check(bound(0, 1, 2)).deepEquals([-1, 0, 1, 2]);
      });
      test('bind 1st argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4) => [
          arg1,
          arg2,
          arg3,
          arg4,
        ];
        final bound = function.bind1(-1);
        check(bound(0, 1, 2)).deepEquals([0, -1, 1, 2]);
      });
      test('bind 2nd argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4) => [
          arg1,
          arg2,
          arg3,
          arg4,
        ];
        final bound = function.bind2(-1);
        check(bound(0, 1, 2)).deepEquals([0, 1, -1, 2]);
      });
      test('bind 3rd argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4) => [
          arg1,
          arg2,
          arg3,
          arg4,
        ];
        final bound = function.bind3(-1);
        check(bound(0, 1, 2)).deepEquals([0, 1, 2, -1]);
      });
    });
    group('5-ary function', () {
      test('bind 0th argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind0(-1);
        check(bound(0, 1, 2, 3)).deepEquals([-1, 0, 1, 2, 3]);
      });
      test('bind 1st argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind1(-1);
        check(bound(0, 1, 2, 3)).deepEquals([0, -1, 1, 2, 3]);
      });
      test('bind 2nd argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind2(-1);
        check(bound(0, 1, 2, 3)).deepEquals([0, 1, -1, 2, 3]);
      });
      test('bind 3rd argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind3(-1);
        check(bound(0, 1, 2, 3)).deepEquals([0, 1, 2, -1, 3]);
      });
      test('bind 4th argument', () {
        List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) =>
            [arg1, arg2, arg3, arg4, arg5];
        final bound = function.bind4(-1);
        check(bound(0, 1, 2, 3)).deepEquals([0, 1, 2, 3, -1]);
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
        check(bound(0, 1, 2, 3, 4)).deepEquals([-1, 0, 1, 2, 3, 4]);
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
        check(bound(0, 1, 2, 3, 4)).deepEquals([0, -1, 1, 2, 3, 4]);
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
        check(bound(0, 1, 2, 3, 4)).deepEquals([0, 1, -1, 2, 3, 4]);
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
        check(bound(0, 1, 2, 3, 4)).deepEquals([0, 1, 2, -1, 3, 4]);
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
        check(bound(0, 1, 2, 3, 4)).deepEquals([0, 1, 2, 3, -1, 4]);
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
        check(bound(0, 1, 2, 3, 4)).deepEquals([0, 1, 2, 3, 4, -1]);
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
        check(bound(0, 1, 2, 3, 4, 5)).deepEquals([-1, 0, 1, 2, 3, 4, 5]);
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
        check(bound(0, 1, 2, 3, 4, 5)).deepEquals([0, -1, 1, 2, 3, 4, 5]);
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
        check(bound(0, 1, 2, 3, 4, 5)).deepEquals([0, 1, -1, 2, 3, 4, 5]);
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
        check(bound(0, 1, 2, 3, 4, 5)).deepEquals([0, 1, 2, -1, 3, 4, 5]);
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
        check(bound(0, 1, 2, 3, 4, 5)).deepEquals([0, 1, 2, 3, -1, 4, 5]);
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
        check(bound(0, 1, 2, 3, 4, 5)).deepEquals([0, 1, 2, 3, 4, -1, 5]);
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
        check(bound(0, 1, 2, 3, 4, 5)).deepEquals([0, 1, 2, 3, 4, 5, -1]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6)).deepEquals([-1, 0, 1, 2, 3, 4, 5, 6]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6)).deepEquals([0, -1, 1, 2, 3, 4, 5, 6]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6)).deepEquals([0, 1, -1, 2, 3, 4, 5, 6]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6)).deepEquals([0, 1, 2, -1, 3, 4, 5, 6]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6)).deepEquals([0, 1, 2, 3, -1, 4, 5, 6]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6)).deepEquals([0, 1, 2, 3, 4, -1, 5, 6]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6)).deepEquals([0, 1, 2, 3, 4, 5, -1, 6]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6)).deepEquals([0, 1, 2, 3, 4, 5, 6, -1]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([-1, 0, 1, 2, 3, 4, 5, 6, 7]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([0, -1, 1, 2, 3, 4, 5, 6, 7]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([0, 1, -1, 2, 3, 4, 5, 6, 7]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([0, 1, 2, -1, 3, 4, 5, 6, 7]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([0, 1, 2, 3, -1, 4, 5, 6, 7]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([0, 1, 2, 3, 4, -1, 5, 6, 7]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([0, 1, 2, 3, 4, 5, -1, 6, 7]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([0, 1, 2, 3, 4, 5, 6, -1, 7]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7))
            .deepEquals([0, 1, 2, 3, 4, 5, 6, 7, -1]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([-1, 0, 1, 2, 3, 4, 5, 6, 7, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, -1, 1, 2, 3, 4, 5, 6, 7, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, 1, -1, 2, 3, 4, 5, 6, 7, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, 1, 2, -1, 3, 4, 5, 6, 7, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, 1, 2, 3, -1, 4, 5, 6, 7, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, 1, 2, 3, 4, -1, 5, 6, 7, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, 1, 2, 3, 4, 5, -1, 6, 7, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, 1, 2, 3, 4, 5, 6, -1, 7, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, 1, 2, 3, 4, 5, 6, 7, -1, 8]);
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
        check(bound(0, 1, 2, 3, 4, 5, 6, 7, 8))
            .deepEquals([0, 1, 2, 3, 4, 5, 6, 7, 8, -1]);
      });
    });
  });
}
