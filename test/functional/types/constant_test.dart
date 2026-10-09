// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('constant', () {
    test('constantFunction0', () {
      final function = constantFunction0<String>('default');
      check(function()).equals('default');
    });
    test('constantFunction1', () {
      final function = constantFunction1<int, String>('default');
      check(function(0)).equals('default');
    });
    test('constantFunction2', () {
      final function = constantFunction2<int, int, String>('default');
      check(function(0, 1)).equals('default');
    });
    test('constantFunction3', () {
      final function = constantFunction3<int, int, int, String>('default');
      check(function(0, 1, 2)).equals('default');
    });
    test('constantFunction4', () {
      final function = constantFunction4<int, int, int, int, String>('default');
      check(function(0, 1, 2, 3)).equals('default');
    });
    test('constantFunction5', () {
      final function = constantFunction5<int, int, int, int, int, String>(
        'default',
      );
      check(function(0, 1, 2, 3, 4)).equals('default');
    });
    test('constantFunction6', () {
      final function = constantFunction6<int, int, int, int, int, int, String>(
        'default',
      );
      check(function(0, 1, 2, 3, 4, 5)).equals('default');
    });
    test('constantFunction7', () {
      final function =
          constantFunction7<int, int, int, int, int, int, int, String>(
            'default',
          );
      check(function(0, 1, 2, 3, 4, 5, 6)).equals('default');
    });
    test('constantFunction8', () {
      final function =
          constantFunction8<int, int, int, int, int, int, int, int, String>(
            'default',
          );
      check(function(0, 1, 2, 3, 4, 5, 6, 7)).equals('default');
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
      check(function(0, 1, 2, 3, 4, 5, 6, 7, 8)).equals('default');
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
      check(function(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)).equals('default');
    });
  });
}
