import 'package:more/feature.dart';
import 'package:test/test.dart';

void main() {
  group('isJavaScript', () {
    test('isTrue', () {
      expect(isJavaScript, isTrue);
    }, testOn: 'js');
    test('isFalse', () {
      expect(isJavaScript, isFalse);
    }, testOn: '!js');
  });
}
