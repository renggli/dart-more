import 'package:more/more.dart';
import 'package:test/test.dart';

void main() {
  group('neverInline', () {
    test('js', () {
      expect(neverInline.name, 'dart2js:never-inline');
    }, testOn: 'js');
    test('vm', () {
      expect(neverInline.name, 'vm:never-inline');
    }, testOn: 'vm');
    test('wasm', () {
      expect(neverInline.name, 'wasm:never-inline');
    }, testOn: 'wasm');
  });
  group('preferInline', () {
    test('js', () {
      expect(preferInline.name, 'dart2js:prefer-inline');
    }, testOn: 'js');
    test('vm', () {
      expect(preferInline.name, 'vm:prefer-inline');
    }, testOn: 'vm');
    test('wasm', () {
      expect(preferInline.name, 'wasm:prefer-inline');
    }, testOn: 'wasm');
  });
  group('noBoundsChecks', () {
    test('js', () {
      expect(noBoundsChecks.name, 'dart2js:index-bounds:trust');
    }, testOn: 'js');
    test('vm', () {
      expect(noBoundsChecks.name, 'vm:unsafe:no-bounds-checks');
    }, testOn: 'vm');
  });
}
