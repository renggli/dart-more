import 'package:checks/checks.dart';
import 'package:more/cache.dart';
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:more/graph.dart';
import 'package:more/interval.dart';
import 'package:more/math.dart';
import 'package:more/number.dart';
import 'package:more/printer.dart';
import 'package:more/temporal.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('collections & iterables', () {
    test('ranges', () {
      check(0.to(10, step: 2)).deepEquals([0, 2, 4, 6, 8]);
    });

    test('window and chunked', () {
      check([1, 2, 3, 4, 5].window(3)).deepEquals([
        [1, 2, 3],
        [2, 3, 4],
        [3, 4, 5],
      ]);
      check([1, 2, 3, 4, 5].chunked(2)).deepEquals([
        [1, 2],
        [3, 4],
        [5],
      ]);
    });

    test('combinatorics', () {
      check(['a', 'b', 'c'].combinations(2)).deepEquals([
        ['a', 'b'],
        ['a', 'c'],
        ['b', 'c'],
      ]);
    });

    test('multimap', () {
      final multimap = ListMultimap<String, int>()
        ..add('even', 2)
        ..add('even', 4)
        ..add('odd', 1);
      check(multimap['even']).deepEquals([2, 4]);
      check(multimap['odd']).deepEquals([1]);
    });
  });

  group('graph theory & algorithms', () {
    test('shortest path and topology', () {
      final graph = Graph<String, num>.directed()
        ..addEdge('A', 'B', value: 4)
        ..addEdge('A', 'C', value: 2)
        ..addEdge('C', 'B', value: 1);

      final path = graph.shortestPath('A', 'B');
      check(path).isNotNull();
      check(path!.vertices).deepEquals(['A', 'C', 'B']);
      check(path.cost).equals(3);

      final sorted = graph.topological('A');
      check(sorted).deepEquals(['A', 'C', 'B']);
      check(graph.hasCycle()).isFalse();
    });
  });

  group('numbers & mathematics', () {
    test('fractions and complex numbers', () {
      final a = Fraction(1, 3);
      final b = Fraction(1, 6);
      check(a + b).equals(Fraction(1, 2));
      check(Fraction.tryParse('3/4')).equals(Fraction(3, 4));

      const c = Complex(3, 4);
      check(c.abs()).equals(5.0);
    });

    test('number extensions', () {
      check(12.gcd(8)).equals(4);
      check(5.factorial()).equals(120);
      check(17.isProbablyPrime).isTrue();
      check(123.digits()).deepEquals([3, 2, 1]);
    });
  });

  group('composable printers', () {
    test('number and date formatting', () {
      final currency = FixedNumberPrinter(precision: 2).before(r'$').padLeft(8);
      check(currency(12.5)).equals(r'  $12.50');

      final human = HumanNumberPrinter.binary();
      check(human(1024 * 1024 * 3)).equals('3 Mi');

      final date = DateTimePrinter.date();
      check(date(DateTime(2025, 1, 15))).equals('2025-01-15');
    });
  });

  group('temporal & intervals', () {
    test('date truncation', () {
      final now = DateTime(2025, 5, 12, 14, 23, 45);
      check(now.truncateTo(TimeUnit.hour)).equals(DateTime(2025, 5, 12, 14));
    });

    test('intervals', () {
      final intA = Interval(1, 5);
      final intB = Interval(3, 7);
      check(intA.intersection(intB)).equals(Interval(3, 5));
    });
  });

  group('unicode & char matcher', () {
    test('normalization', () {
      check('e\u0301le\u0300ve'.normalize()).equals('élève');
      check('①'.normalize(form: NormalizationForm.nfkc)).equals('1');
      check('ﬃ'.normalize(form: NormalizationForm.nfkc)).equals('ffi');
    });

    test('unicode classification and matching', () {
      final greek = UnicodeCharMatcher.scriptGreek();
      check(greek.retainFrom('Hello Ελληνικά!')).equals('Ελληνικά');

      final whitespace = UnicodeCharMatcher.whiteSpace();
      check(whitespace.collapseFrom('lots   of   spaces', ' '))
          .equals('lots of spaces');

      final latinOrDigits =
          UnicodeCharMatcher.scriptLatin() | const CharMatcher.digit();
      check(latinOrDigits.retainFrom('Hello 123! π')).equals('Hello123');

      const letters = CharMatcher.letter();
      check(letters.retainFrom('Hello 123!')).equals('Hello');
      check(letters.replaceFrom('Hello 123!', '*')).equals('***** 123!');
    });

    test('unicode string splitting', () {
      check('Dart 🎯'.toList(unicode: true))
          .deepEquals(['D', 'a', 'r', 't', ' ', '🎯']);
    });
  });

  group('caching', () {
    test('lru cache', () async {
      var calculations = 0;
      final cache = Cache<String, int>.lru(
        loader: (key) {
          calculations++;
          return key.length;
        },
        maximumSize: 100,
      );

      check(await cache.get('hello')).equals(5);
      check(await cache.get('hello')).equals(5);
      check(calculations).equals(1);
    });
  });
}
