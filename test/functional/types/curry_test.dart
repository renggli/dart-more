// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('curry', () {
    test('1-ary function', () {
      List<int> function(int arg1) => [arg1];
      check(function.curry(0)).deepEquals([0]);
    });
    test('2-ary function', () {
      List<int> function(int arg1, int arg2) => [arg1, arg2];
      check(function.curry(0)(1)).deepEquals([0, 1]);
    });
    test('3-ary function', () {
      List<int> function(int arg1, int arg2, int arg3) => [arg1, arg2, arg3];
      check(function.curry(0)(1)(2)).deepEquals([0, 1, 2]);
    });
    test('4-ary function', () {
      List<int> function(int arg1, int arg2, int arg3, int arg4) => [
        arg1,
        arg2,
        arg3,
        arg4,
      ];
      check(function.curry(0)(1)(2)(3)).deepEquals([0, 1, 2, 3]);
    });
    test('5-ary function', () {
      List<int> function(int arg1, int arg2, int arg3, int arg4, int arg5) => [
        arg1,
        arg2,
        arg3,
        arg4,
        arg5,
      ];
      check(function.curry(0)(1)(2)(3)(4)).deepEquals([0, 1, 2, 3, 4]);
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
      check(function.curry(0)(1)(2)(3)(4)(5)).deepEquals([0, 1, 2, 3, 4, 5]);
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
      check(function.curry(0)(1)(2)(3)(4)(5)(6))
          .deepEquals([0, 1, 2, 3, 4, 5, 6]);
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
      check(function.curry(0)(1)(2)(3)(4)(5)(6)(7))
          .deepEquals([0, 1, 2, 3, 4, 5, 6, 7]);
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
      check(function.curry(0)(1)(2)(3)(4)(5)(6)(7)(8))
          .deepEquals([0, 1, 2, 3, 4, 5, 6, 7, 8]);
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
      check(function.curry(0)(1)(2)(3)(4)(5)(6)(7)(8)(9))
          .deepEquals([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
    });
  });
}
