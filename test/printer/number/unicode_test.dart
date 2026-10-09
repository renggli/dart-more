import 'package:checks/checks.dart';
import 'package:more/printer.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('unicode', () {
    test('basic', () {
      check(unicodeCodePointPrinter(76)).equals('U+004C "L"');
      check(unicodeCodePointPrinter(82)).equals('U+0052 "R"');
    });
    test('emoji', () {
      check(unicodeCodePointPrinter(128579)).equals('U+1F643 "🙃"');
      check(unicodeCodePointPrinter(128572)).equals('U+1F63C "😼"');
    });
    test('unprintable', () {
      check(unicodeCodePointPrinter(0)).equals('U+0000');
      check(unicodeCodePointPrinter(133)).equals('U+0085');
      check(unicodeCodePointPrinter(55624)).equals('U+D948');
    });
    test('invalid', () {
      check(unicodeCodePointPrinter(-1)).equals('U-0001 (invalid)');
      check(unicodeCodePointPrinter(1114112)).equals('U+110000 (invalid)');
    });
  });
}
