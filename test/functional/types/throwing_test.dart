// AUTO-GENERATED CODE: DO NOT EDIT

// ignore_for_file: unnecessary_lambdas

import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('throwing', () {
    final throwable = UnimplementedError();
    test('throwFunction0', () {
      final function = throwFunction0(throwable);
      check(() => function()).throws<UnimplementedError>();
    });
    test('throwFunction1', () {
      final function = throwFunction1<int>(throwable);
      check(() => function(0)).throws<UnimplementedError>();
    });
    test('throwFunction2', () {
      final function = throwFunction2<int, int>(throwable);
      check(() => function(0, 1)).throws<UnimplementedError>();
    });
    test('throwFunction3', () {
      final function = throwFunction3<int, int, int>(throwable);
      check(() => function(0, 1, 2)).throws<UnimplementedError>();
    });
    test('throwFunction4', () {
      final function = throwFunction4<int, int, int, int>(throwable);
      check(() => function(0, 1, 2, 3)).throws<UnimplementedError>();
    });
    test('throwFunction5', () {
      final function = throwFunction5<int, int, int, int, int>(throwable);
      check(() => function(0, 1, 2, 3, 4)).throws<UnimplementedError>();
    });
    test('throwFunction6', () {
      final function = throwFunction6<int, int, int, int, int, int>(throwable);
      check(() => function(0, 1, 2, 3, 4, 5)).throws<UnimplementedError>();
    });
    test('throwFunction7', () {
      final function = throwFunction7<int, int, int, int, int, int, int>(
        throwable,
      );
      check(() => function(0, 1, 2, 3, 4, 5, 6)).throws<UnimplementedError>();
    });
    test('throwFunction8', () {
      final function = throwFunction8<int, int, int, int, int, int, int, int>(
        throwable,
      );
      check(() => function(0, 1, 2, 3, 4, 5, 6, 7))
          .throws<UnimplementedError>();
    });
    test('throwFunction9', () {
      final function =
          throwFunction9<int, int, int, int, int, int, int, int, int>(
            throwable,
          );
      check(() => function(0, 1, 2, 3, 4, 5, 6, 7, 8))
          .throws<UnimplementedError>();
    });
    test('throwFunction10', () {
      final function =
          throwFunction10<int, int, int, int, int, int, int, int, int, int>(
            throwable,
          );
      check(() => function(0, 1, 2, 3, 4, 5, 6, 7, 8, 9))
          .throws<UnimplementedError>();
    });
  });
}
