import 'package:checks/checks.dart';
import 'package:more/diff.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('closeMatches', () {
    test('basic', () {
      check(['ape', 'apple', 'peach', 'puppy'].closeMatches('appel'))
          .deepEquals(['apple', 'ape']);
    });

    test('keywords', () {
      final keywords =
          'abstract as assert async await base break case catch '
                  'class const continue covariant default deferred do dynamic else '
                  'enum export extends extension external factory false final '
                  'finally for function get hide if implements import in interface '
                  'is late library mixin new null on operator part required '
                  'rethrow return sealed set show static super switch sync this '
                  'throw true try typedef var void when while with yield'
              .split(' ');
      check(keywords.closeMatches('is')).deepEquals(['is', 'this']);
      check(keywords.closeMatches('wheel')).deepEquals(['when', 'while']);
      check(keywords.closeMatches('valiant')).deepEquals(['covariant']);
    });

    test('custom count and cutoff', () {
      final words = ['apple', 'application', 'apply', 'banana'];
      check(words.closeMatches('appl', count: 2, cutoff: 0.5))
          .deepEquals(['apple', 'apply']);
    });

    test('iterable of iterables', () {
      final sequences = [
        [1, 2, 3, 4],
        [1, 2, 3, 5],
        [9, 8, 7],
      ];
      check(sequences.closeMatches([1, 2, 3, 4])).deepEquals([
        [1, 2, 3, 4],
        [1, 2, 3, 5],
      ]);
    });

    test('invalid count', () {
      check(() => ['apple'].closeMatches('appel', count: 0))
          .throws<ArgumentError>();
      check(() => ['apple'].closeMatches('appel', count: -1))
          .throws<ArgumentError>();
    });

    test('invalid cutoff', () {
      check(() => ['apple'].closeMatches('appel', cutoff: -0.1))
          .throws<ArgumentError>();
      check(() => ['apple'].closeMatches('appel', cutoff: 1.1))
          .throws<ArgumentError>();
    });
  });
}
