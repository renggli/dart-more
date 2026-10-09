import 'package:checks/checks.dart';
import 'package:more/more.dart';
import 'package:test/test.dart' show group, test;

void main() {
  group('neverInline', () {
    test('js', () {
      check(neverInline.name).equals('dart2js:never-inline');
    }, testOn: 'js');
    test('vm', () {
      check(neverInline.name).equals('vm:never-inline');
    }, testOn: 'vm');
    test('wasm', () {
      check(neverInline.name).equals('wasm:never-inline');
    }, testOn: 'wasm');
    test('constants', () {
      check(neverInlineJs.name).equals('dart2js:never-inline');
      check(neverInlineVm.name).equals('vm:never-inline');
      check(neverInlineWasm.name).equals('wasm:never-inline');
    });
  });
  group('preferInline', () {
    test('js', () {
      check(preferInline.name).equals('dart2js:prefer-inline');
    }, testOn: 'js');
    test('vm', () {
      check(preferInline.name).equals('vm:prefer-inline');
    }, testOn: 'vm');
    test('wasm', () {
      check(preferInline.name).equals('wasm:prefer-inline');
    }, testOn: 'wasm');
    test('constants', () {
      check(preferInlineJs.name).equals('dart2js:prefer-inline');
      check(preferInlineVm.name).equals('vm:prefer-inline');
      check(preferInlineWasm.name).equals('wasm:prefer-inline');
    });
  });
  group('noBoundsChecks', () {
    test('js', () {
      check(noBoundsChecks.name).equals('dart2js:index-bounds:trust');
    }, testOn: 'js');
    test('vm', () {
      check(noBoundsChecks.name).equals('vm:unsafe:no-bounds-checks');
    }, testOn: 'vm');
    test('constants', () {
      check(noBoundsChecksJs.name).equals('dart2js:index-bounds:trust');
      check(noBoundsChecksVm.name).equals('vm:unsafe:no-bounds-checks');
    });
  });
}
