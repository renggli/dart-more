import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('count', () {
    test('true', () {
      check(<int>[].count((each) => true)).equals(0);
      check(<int>[1].count((each) => true)).equals(1);
      check(<int>[1, 2, 3].count((each) => true)).equals(3);
      check(<int>[1, 2, 3, 4, 5].count((each) => true)).equals(5);
    });
    test('false', () {
      check(<int>[].count((each) => false)).equals(0);
      check(<int>[1].count((each) => false)).equals(0);
      check(<int>[1, 2, 3].count((each) => false)).equals(0);
      check(<int>[1, 2, 3, 4, 5].count((each) => false)).equals(0);
    });
    test('isOdd', () {
      check(<int>[].count((each) => each.isOdd)).equals(0);
      check(<int>[1].count((each) => each.isOdd)).equals(1);
      check(<int>[1, 2, 3].count((each) => each.isOdd)).equals(2);
      check(<int>[1, 2, 3, 4, 5].count((each) => each.isOdd)).equals(3);
    });
    test('occurrences', () {
      check(<int>[].occurrences(5)).equals(0);
      check(<int>[5].occurrences(5)).equals(1);
      check(<int>[1].occurrences(5)).equals(0);
      check(<int>[1, 5, 4, 5, 2].occurrences(5)).equals(2);
    });
  });
}
