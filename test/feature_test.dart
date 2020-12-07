import 'package:more/feature.dart';
import 'package:test/test.dart';

import 'dart:math';

void main() {
  group('isJavaScript', () {
    test('isTrue', () {
      expect(isJavaScript, isTrue);
    }, testOn: 'js');
    test('isFalse', () {
      expect(isJavaScript, isFalse);
    }, testOn: '!js');
  });
  test('int', () {
    expect(minSafeInteger, -pow(2, safeIntegerBits - 1));
    expect(maxSafeInteger, pow(2, safeIntegerBits - 1) - 1);
  });
}
