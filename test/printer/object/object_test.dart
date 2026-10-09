import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('object', () {
    test('default', () {
      final printer = ObjectPrinter<int>(const Printer.literal('*'));
      check(printer(42)).equals('*');
    });
    test('static', () {
      final printer = ObjectPrinter<Point<num>>.static();
      check(printer(const Point<int>(1, 2))).equals('Point<num>');
    });
    test('dynamic', () {
      final printer = ObjectPrinter<Point<num>>.dynamic();
      check(printer(const Point<int>(1, 2))).equals('Point<int>');
    });
    group('addValue', () {
      test('default', () {
        final printer = ObjectPrinter<String>.static()..addValue(42);
        check(printer('hello')).equals('String(42)');
      });
      test('name', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue(42, name: 'size');
        check(printer('hello')).equals('String(size: 42)');
      });
      test('printer', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue(42, printer: const Printer<int>.standard().around('"'));
        check(printer('hello')).equals('String("42")');
      });
      test('omitNull', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue<int?>(null, omitNull: true)
          ..addValue<int?>(42, omitNull: true);
        check(printer('hello')).equals('String(42)');
      });
      test('omitPredicate', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue<int>(42, omitPredicate: (value) => value.isEven)
          ..addValue<int>(43, omitPredicate: (value) => value.isEven);
        check(printer('hello')).equals('String(43)');
      });
      test('omitNull and omitPredicate', () {
        final printer = ObjectPrinter<String>.static()
          ..addValue<int?>(
            null,
            omitNull: true,
            omitPredicate: (value) => value!.isEven,
          )
          ..addValue<int?>(
            42,
            omitNull: true,
            omitPredicate: (value) => value!.isEven,
          )
          ..addValue<int?>(
            43,
            omitNull: true,
            omitPredicate: (value) => value!.isEven,
          );
        check(printer('hello')).equals('String(43)');
      });
    });
    group('addCallback', () {
      test('default', () {
        final printer = ObjectPrinter<String>.static()
          ..addCallback((object) => object.length);
        check(printer('hello')).equals('String(5)');
      });
      test('name', () {
        final printer = ObjectPrinter<String>.static()
          ..addCallback((object) => object.length, name: 'size');
        check(printer('hello')).equals('String(size: 5)');
      });
      test('printer', () {
        final printer = ObjectPrinter<String>.static()
          ..addCallback(
            (object) => object.length,
            printer: const Printer<int>.standard().around('"'),
          );
        check(printer('hello')).equals('String("5")');
      });
      test('omitNull', () {
        final printer = ObjectPrinter<(String?, String?)>.static()
          ..addCallback((object) => object.first, omitNull: true, name: 'first')
          ..addCallback(
            (object) => object.second,
            omitNull: false,
            name: 'second',
          );
        check(printer(('hello', 'world')))
            .equals('(String?, String?)(first: hello, second: world)');
        check(printer((null, 'world')))
            .equals('(String?, String?)(second: world)');
        check(printer(('hello', null)))
            .equals('(String?, String?)(first: hello, second: null)');
        check(printer((null, null))).equals('(String?, String?)(second: null)');
      });
      test('omitPredicate', () {
        final printer = ObjectPrinter<(int, int)>.static()
          ..addCallback<int>((object) => object.first, name: 'first')
          ..addCallback<int>(
            (object) => object.second,
            omitPredicate: (object, value) => value.isEven,
            name: 'second',
          );
        check(printer((42, 43))).equals('(int, int)(first: 42, second: 43)');
        check(printer((42, 44))).equals('(int, int)(first: 42)');
      });
      test('omitNull and omitPredicate', () {
        final printer = ObjectPrinter<(int?,)>.static()
          ..addCallback<int?>(
            (object) => object.first,
            omitNull: true,
            omitPredicate: (object, value) => value!.isEven,
          );
        check(printer((1,))).equals('(int?)(1)');
        check(printer((2,))).equals('(int?)');
        check(printer((null,))).equals('(int?)');
      });
    });
    test('before and afterFields', () {
      final printer = ObjectPrinter<String>.static(
        beforeFields: '[',
        afterFields: ']',
      )..addCallback<int>((object) => object.length);
      check(printer('hello')).equals('String[5]');
    });
    test('fieldName', () {
      final printer = ObjectPrinter<String>.static(
        fieldName: const Printer<String>.standard().around('"'),
      )..addCallback<String>((object) => object[0], name: 'first');
      check(printer('hello')).equals('String("first": h)');
    });
    test('fieldNameSeparator', () {
      final printer = ObjectPrinter<String>.static(fieldNameSeparator: '=')
        ..addCallback<String>((object) => object[0], name: 'first');
      check(printer('hello')).equals('String(first=h)');
    });
    test('fieldValue', () {
      final printer = ObjectPrinter<String>.static(
        fieldValue: const Printer<String>.standard().around('"'),
      )..addCallback<String>((object) => object[0]);
      check(printer('hello')).equals('String("h")');
    });
    test('fieldSeparator', () {
      final printer = ObjectPrinter<(int, int)>.static(fieldSeparator: ';')
        ..addCallback<int>((object) => object.first, name: 'first')
        ..addCallback<int>((object) => object.second, name: 'second');
      check(printer((1, 2))).equals('(int, int)(first: 1;second: 2)');
    });
    test('toString', () {
      final printer = ObjectPrinter<(int, int)>.dynamic()
        ..addValue(true)
        ..addCallback((value) => value);
      check(printer.toString()).startsWith('ObjectPrinter<(int, int)>');
    });
  });
}
