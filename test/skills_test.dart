import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/async.dart';
import 'package:more/cache.dart';
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:more/diff.dart';
import 'package:more/functional.dart';
import 'package:more/graph.dart';
import 'package:more/interval.dart';
import 'package:more/math.dart';
import 'package:more/number.dart';
import 'package:more/printer.dart';
import 'package:more/temporal.dart';
import 'package:more/tuple.dart';
import 'package:test/scaffolding.dart';

class Node {
  new(this.id, [this.children = const []]);
  final String id;
  final List<Node> children;
}

class User with ToStringPrinter {
  new(this.name, {this.age});
  final String name;
  final int? age;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(name, name: 'name')
    ..addValue(age, name: 'age', omitNull: true);
}

class Version with CompareOperators<Version> implements Comparable<Version> {
  const new(this.major, this.minor);
  final int major;
  final int minor;

  static final _comparator = keyOf<Version, num>((v) => v.major)
      .thenCompare(keyOf<Version, num>((v) => v.minor));

  @override
  int compareTo(Version other) => _comparator(this, other);
}

typedef Task = ({String name, Interval<num> slot});

void main() {
  group('more-dart-use-graph-library', () {
    test('closure-based API', () {
      final root = Node('1', [
        Node('2'),
        Node('3', [Node('4')]),
      ]);
      final bfs = BreadthFirstIterable<Node>([
        root,
      ], successorsOf: (n) => n.children);
      final dfs = DepthFirstIterable<Node>([
        root,
      ], successorsOf: (n) => n.children);
      check(bfs.length).equals(4);
      check(dfs.length).equals(4);

      final path = dijkstraSearch<Node>(
        startVertices: [root],
        targetPredicate: (n) => n.id == '4',
        successorsOf: (n) => n.children,
      ).firstOrNull;
      check(path).isNotNull();

      final cyclic = hasCycle<Node>(
        vertices: [root],
        successorsOf: (n) => n.children,
      );
      check(cyclic).isFalse();

      final layoutResult = const TreeLayout<Node>().layout(
        LayoutInput<Node>(
          vertices: bfs.toList(),
          successorsOf: (n) => n.children,
          vertexSize: (n) => const (width: 40.0, height: 40.0),
        ),
      );
      final rootPosition = layoutResult.positions[root];
      check(rootPosition).isNotNull();
    });

    test('Graph data structure, factories, and layouts', () {
      final directed = Graph<String, void>(isDirected: true);
      final undirected = Graph<String, void>(isDirected: false);
      final graph = Graph<String, num>(isDirected: true);
      final intGraph = Graph<int, void>(
        isDirected: false,
        vertexStrategy: StorageStrategy.positiveInteger(),
      );
      check(directed.isDirected).isTrue();
      check(undirected.isDirected).isFalse();
      check(intGraph.vertices).isEmpty();

      graph.addVertex('A');
      graph.addEdge('A', 'B', value: 3.5);
      graph.removeEdge('A', 'B');
      graph.addEdge('A', 'B', value: 3.5);
      check(graph.successorsOf('A')).deepEquals(['B']);
      check(graph.predecessorsOf('B')).deepEquals(['A']);
      check(graph.degreeOf('A')).equals(1);

      final factory = GraphFactory<int, void>(
        isDirected: true,
        random: Random(42),
      );
      final kn = factory.complete(vertexCount: 5);
      final ring = factory.ring(vertexCount: 6);
      final star = factory.star(vertexCount: 7);
      final tree = factory.completeTree(vertexCount: 15, arity: 2);
      final random = factory.randomErdosRenyi(
        vertexCount: 10,
        probability: 0.35,
      );
      final atlasGraph = GraphFactory<int, void>(isDirected: false).atlas(7);
      final fromMermaid = GraphFactory<String, String?>().fromMermaid('''
graph TD
  A --> B
  A --> C
''');
      check(kn.vertices.length).equals(5);
      check(ring.vertices.length).equals(6);
      check(star.vertices.length).equals(7);
      check(tree.vertices.length).equals(15);
      check(random.vertices.length).equals(10);
      check(atlasGraph.vertices).isNotEmpty();
      check(fromMermaid.vertices.length).equals(3);

      final result = graph.layout(
        const StressLayout(),
        vertexSize: (v) => const (width: 40.0, height: 40.0),
        normalize: true,
        removeOverlaps: true,
      );
      check(result.positions.length).equals(2);

      final input = LayoutInput<String>(
        vertices: ['A', 'B', 'C'],
        successorsOf: (v) => v == 'A' ? ['B', 'C'] : const [],
        vertexSize: (v) => const (width: 40.0, height: 40.0),
      );
      final treeResult = const TreeLayout<String>().layout(input);
      check(treeResult.positions.length).equals(3);
    });
  });

  group('more-dart-use-collection-library', () {
    test('specialized data structures', () {
      final bimap = BiMap.of({1: 'a', 2: 'b'});
      final key = bimap.inverse['a'];
      check(key).equals(1);

      final multimap = ListMultimap<String, int>()
        ..add('odd', 1)
        ..addAll('odd', [3, 5]);
      final odds = multimap['odd'];
      check(odds).deepEquals([1, 3, 5]);

      final bag = Multiset.of(['a', 'b', 'a']);
      bag.add('a', 2);
      final countA = bag['a'];
      final unique = bag.distinct;
      check(countA).equals(4);
      check(unique).deepEquals(['a', 'b']);

      final typeMap = TypeMap<Object>()..setInstance<String>('hello');
      final str = typeMap.getInstance<String>();
      check(str).equals('hello');

      final bits = BitList(8)
        ..[1] = true
        ..[3] = true;
      bits.flip(0);
      final setCount = bits.count();
      final combined =
          bits &
          BitList.of([true, true, false, false, false, false, false, false]);
      check(setCount).equals(3);
      check(combined.count()).equals(2);

      final deque = OrderedList.of([2, 3])
        ..addFirst(1)
        ..addLast(4);
      check(deque).deepEquals([1, 2, 3, 4]);

      final sorted = SortedList<int>()..addAll([5, 1, 3]);
      final minVal = sorted.removeFirst();
      check(minVal).equals(1);

      final evens = 0.to(10, step: 2);
      final floats = 0.0.to(1.0, step: 0.25);
      final reversed = 10.to(0, step: -2);
      check(evens).deepEquals([0, 2, 4, 6, 8]);
      check(floats).deepEquals([0.0, 0.25, 0.5, 0.75]);
      check(reversed).deepEquals([10, 8, 6, 4, 2]);

      final ds = DisjointSet(['a', 'b', 'c', 'd']);
      ds.union('a', 'b');
      final sameComponent = ds.find('a') == ds.find('b');
      check(sameComponent).isTrue();

      final fenwick = FenwickTree.of([1, 2, 3, 4, 5]);
      fenwick.update(2, 10);
      final rangeSum = fenwick.range(1, 4);
      check(rangeSum).equals(19);

      final trie = Trie<String, num, int>(parts: (s) => s.codeUnits);
      trie['app'] = 1;
      trie['apple'] = 2;
      final matches = trie.keysWithPrefix('app');
      check(matches).deepEquals(['app', 'apple']);

      final rtree = RTree<String>.guttman()
        ..insert(Bounds.fromPoint([10, 20]), 'Target');
      final hits = rtree.queryEntries(Bounds.fromLists([0, 0], [15, 25]));
      check(hits.length).equals(1);
    });

    test('iterable and list extensions', () {
      final items = [1, 2, 3];
      final combs = items.combinations(2);
      final perms = items.permutations(2);
      final pset = items.powerSet();
      final cart = ([1, 2], ['a', 'b']).product();
      check(combs.length).equals(3);
      check(perms.length).equals(6);
      check(pset.length).equals(8);
      check(cart.length).equals(4);

      final perm = [1, 2, 3];
      check(perm.nextPermutation()).isTrue();
      check(perm).deepEquals([1, 3, 2]);

      final nums = [1, 2, 3, 4, 5];
      final chunks = nums.chunked(2);
      final padded = nums.chunkedWithPadding(2, 0);
      final windows = nums.window(3, step: 2);
      final pairs = nums.pairwise();
      final zipped = ([1, 2], ['a', 'b']).zip();
      final parted = nums.partition((n) => n.isEven);
      final grouped = [1, 1, 2, 2, 1].groupBy<int>();
      check(chunks.length).equals(3);
      check(padded.last).deepEquals([5, 0]);
      check(windows.length).equals(2);
      check(pairs.length).equals(4);
      check(zipped).deepEquals([(1, 'a'), (2, 'b')]);
      check(parted.truthy).deepEquals([2, 4]);
      check(grouped.length).equals(3);
    });

    test('string extensions', () {
      const path = '/usr/local/bin/dart';
      final dir = path.skipLastTo('/');
      final bin = path.takeLastTo('/');
      final first4 = path.take(4);
      final withoutRoot = path.skip(1).takeTo('/');
      check(dir).equals('/usr/local/bin');
      check(bin).equals('dart');
      check(first4).equals('/usr');
      check(withoutRoot).equals('usr');

      final bare = 'https://dart.dev/'
          .removePrefix('https://')
          .removeSuffix('/');
      final [head, sep, tail] = 'key=value=1'.partition('=');
      check(bare).equals('dart.dev');
      check([head, sep, tail]).deepEquals(['key', '=', 'value=1']);

      final wrapped = 'The quick brown fox jumps'.wrap(10);
      final unwrapped = wrapped.unwrap();
      final indented = 'a\nb'.indent('  ', firstPrefix: '- ');
      final dedented = '  line 1\n    line 2'.dedent();
      check(wrapped).equals('The quick\nbrown fox\njumps');
      check(unwrapped).equals('The quick brown fox jumps');
      check(indented).equals('- a\n  b');
      check(dedented).equals('line 1\n  line 2');

      final title = 'hello'.toUpperCaseFirstCharacter();
      final chunks = 'abcde'.chunked(2).toList();
      final normalized = 'e\u0301'.normalize(form: NormalizationForm.nfc);
      final chars = 'hello'.toList(mutable: true)..rotate(2);
      check(title).equals('Hello');
      check(chunks).deepEquals(['ab', 'cd', 'e']);
      check(normalized).equals('é');
      check(chars).deepEquals(['l', 'o', 'h', 'e', 'l']);
    });
  });

  group('more-dart-use-printer-library', () {
    test('printers and modifiers', () {
      const std = Printer<int>.standard();
      final hex = Printer<int>.pluggable((v) => '0x${v.toRadixString(16)}');
      final wrapped = hex.around('[', ']');
      final formatted = wrapped(255);
      check(std(10)).equals('10');
      check(formatted).equals('[0xff]');

      final statusPrinter = Printer<int>.switcher({
        (n) => n < 0: const Printer.literal('negative'),
        (n) => n == 0: const Printer.literal('zero'),
      }, otherwise: const Printer.literal('positive'));
      check(statusPrinter(-1)).equals('negative');

      final fixed = FixedNumberPrinter<num>(
        precision: 2,
        separator: '_',
        sign: const SignNumberPrinter.spacePositiveSign(),
      );
      final fixedOut = fixed(12345.6);
      check(fixedOut).equals(' 12_345.60');

      final sci = ScientificNumberPrinter<num>(precision: 2);
      final sciOut = sci(12345.0);
      check(sciOut).equals('1.23e4');

      final humanDec = HumanNumberPrinter.decimal(precision: 1);
      final humanBin = HumanNumberPrinter.binary(precision: 1);
      final decOut = humanDec(1500000);
      final binOut = humanBin(1536);
      check(decOut).equals('1.5 M');
      check(binOut).equals('1.5 Ki');

      final ordinal = OrdinalNumberPrinter();
      final ordOut = ordinal(23);
      check(ordOut).equals('23rd');

      final isoDate = DateTimePrinter.date();
      final dateStr = isoDate(DateTime.utc(2025, 7, 4));
      check(dateStr).equals('2025-07-04');

      final customDate = DateTimePrinter(
        (b) => b
          ..year()
          ..literal('/')
          ..month(width: 2)
          ..literal('/')
          ..day(width: 2),
      );
      check(customDate(DateTime.utc(2025, 7, 4))).equals('2025/07/04');

      final timerPrinter = DurationPrinter(
        (b) => b
          ..part(TimeUnit.minute, printer: FixedNumberPrinter(padding: 2))
          ..literal(':')
          ..part(TimeUnit.second, printer: FixedNumberPrinter(padding: 2)),
      );
      final durationStr = timerPrinter(const Duration(minutes: 3, seconds: 7));
      check(durationStr).equals('03:07');

      final userStr = User('Alice').toString();
      check(userStr).equals('User(name: Alice)');

      final listPrinter = const Printer<int>.standard().iterable(
        separator: ', ',
        lastSeparator: ' and ',
        leadingItems: 2,
        trailingItems: 1,
      );
      final summary = listPrinter([1, 2, 3, 4, 5]);
      check(summary).equals('1, 2, … and 5');
    });
  });

  group('more-dart-use-char-matcher-library', () {
    test('matchers, composition, and string operations', () {
      final isA = CharMatcher.isChar('a');
      final lowerHex = CharMatcher.inRange('a', 'f');
      final vowels = CharMatcher.charSet('aeiou');
      final consonants = CharMatcher.pattern('a-z-[aeiou]');
      const ascii = CharMatcher.ascii();
      const digit = CharMatcher.digit();
      const letter = CharMatcher.letter();
      const alnum = CharMatcher.letterOrDigit();
      const upper = CharMatcher.upperCaseLetter();
      const lower = CharMatcher.lowerCaseLetter();
      const punct = CharMatcher.punctuation();
      const space = CharMatcher.whitespace();
      final unicodeLetter = UnicodeCharMatcher.letter();
      final greekScript = UnicodeCharMatcher.scriptGreek();
      const emoticons = UnicodeBlockCharMatcher.emoticons;
      const basicLatin = UnicodeBlockCharMatcher.basicLatin;

      check(isA.anyOf('abc')).isTrue();
      check(lowerHex.anyOf('abc')).isTrue();
      check(vowels.anyOf('abc')).isTrue();
      check(consonants.anyOf('abc')).isTrue();
      check(ascii.anyOf('abc')).isTrue();
      check(digit.anyOf('123')).isTrue();
      check(letter.anyOf('abc')).isTrue();
      check(alnum.anyOf('a1')).isTrue();
      check(upper.anyOf('A')).isTrue();
      check(lower.anyOf('a')).isTrue();
      check(punct.anyOf('!')).isTrue();
      check(space.anyOf(' ')).isTrue();
      check(unicodeLetter.anyOf('ä')).isTrue();
      check(greekScript.anyOf('α')).isTrue();
      check(emoticons.anyOf('😀')).isTrue();
      check(basicLatin.anyOf('a')).isTrue();

      final identifierStart =
          const CharMatcher.letter() | CharMatcher.isChar('_');
      final identifierPart = identifierStart | const CharMatcher.digit();
      final nonAsciiWhitespace =
          UnicodeCharMatcher.whiteSpace() & ~const CharMatcher.ascii();
      check(identifierPart.everyOf('foo_1')).isTrue();
      check(nonAsciiWhitespace.anyOf(' ')).isFalse();

      const input = '  Hello,   World! 123  ';
      final digitsOnly = const CharMatcher.digit().retainFrom(input);
      final noDigits = const CharMatcher.digit().removeFrom(input);
      final redacted = const CharMatcher.digit().replaceFrom(input, '#');
      final collapsed = const CharMatcher.whitespace().collapseFrom(
        input.trim(),
        ' ',
      );
      final trimmed = const CharMatcher.whitespace().trimFrom(input);
      final trimLead = const CharMatcher.whitespace().trimLeadingFrom(input);
      final trimTrail = const CharMatcher.whitespace().trimTrailingFrom(input);
      final allAscii = const CharMatcher.ascii().everyOf(input);
      final hasDigit = const CharMatcher.digit().anyOf(input);
      final noControl = CharMatcher.isChar('\x00').noneOf(input);
      final digitCount = const CharMatcher.digit().countIn(input);
      final firstDigitIdx = const CharMatcher.digit().firstIndexIn(input);
      final words = 'one, two; three'.split(CharMatcher.charSet(',; '));

      check(digitsOnly).equals('123');
      check(noDigits).equals('  Hello,   World!   ');
      check(redacted).equals('  Hello,   World! ###  ');
      check(collapsed).equals('Hello, World! 123');
      check(trimmed).equals('Hello,   World! 123');
      check(trimLead).isNotEmpty();
      check(trimTrail).isNotEmpty();
      check(allAscii).isTrue();
      check(hasDigit).isTrue();
      check(noControl).isTrue();
      check(digitCount).equals(3);
      check(firstDigitIdx).equals(18);
      check(words).isNotEmpty();
    });
  });

  group('more-dart-use-comparator-library', () {
    test('comparators, sorting, binary search, and operators', () {
      const nat = naturalComparable<num>;
      const rev = reverseComparable<num>;
      final byLength = keyOf<String, num>((s) => s.length);
      final priority = explicitComparator(['high', 'medium', 'low']);
      final lengthThenAlpha = byLength.thenCompare(naturalComparable<String>);
      final nullableOrder = lengthThenAlpha.reversed.nullsLast;
      final listOrder = naturalComparable<num>.lexicographical;

      check(nat(1, 2)).isLessThan(0);
      check(rev(1, 2)).isGreaterThan(0);
      check(priority('high', 'low')).isLessThan(0);
      check(nullableOrder('a', null)).isLessThan(0);
      check(listOrder([1, 2], [1, 3])).isLessThan(0);

      const words = ['pear', 'fig', 'apple', 'banana', 'kiwi'];
      final sortedWords = lengthThenAlpha.sorted(words, stable: true);
      check(sortedWords).deepEquals(['fig', 'kiwi', 'pear', 'apple', 'banana']);

      final ordered = lengthThenAlpha.isOrdered(sortedWords);
      final strictlyOrdered = byLength.isStrictlyOrdered(sortedWords);
      final shortest = byLength.minOf(words);
      final longest = byLength.maxOf(words);
      final (:min, :max) = byLength.minMaxOf(words);
      final twoShortest = lengthThenAlpha.smallest(words, 2);
      final twoLongest = lengthThenAlpha.largest(words, 2);
      final isShorter = byLength.lessThan('fig', 'apple');

      check(ordered).isTrue();
      check(strictlyOrdered).isFalse();
      check(shortest).equals('fig');
      check(longest).equals('banana');
      check(min).equals('fig');
      check(max).equals('banana');
      check(twoShortest).deepEquals(['fig', 'kiwi']);
      check(twoLongest).deepEquals(['banana', 'apple']);
      check(isShorter).isTrue();

      final list = [10, 20, 20, 20, 30];
      const comp = naturalComparable<num>;
      final exactIndex = comp.binarySearch(list, 20);
      final lowerBound = comp.binarySearchLower(list, 20);
      final upperBound = comp.binarySearchUpper(list, 20);
      check(exactIndex).isGreaterOrEqual(1);
      check(lowerBound).equals(1);
      check(upperBound).equals(4);

      const v1 = Version(1, 2);
      const v2 = Version(2, 0);
      final isOlder = v1 < v2;
      final inRange = v1.between(const Version(1, 0), const Version(1, 5));
      final clamped = v2.clip(const Version(1, 0), const Version(1, 5));
      check(isOlder).isTrue();
      check(inRange).isTrue();
      check(clamped.compareTo(const Version(1, 5))).equals(0);
    });
  });

  group('more-dart-use-math-library', () {
    test('number theory, polynomials, hyperbolic, and bits', () {
      final lcmVal = 12.lcm(18);
      final gcdAll = [24, 36, 60].gcd();
      final lcmAll = [3, 4, 6].lcm();
      final fact = 5.factorial();
      final bigComb = BigInt.from(50).binomial(BigInt.from(6));
      final base10Digits = 1234.digits(10);
      final primeCheck = 999983.isProbablyPrime;
      final sieve = EulerPrimeSieve(30);
      final primesUpTo30 = sieve.primes;

      check(lcmVal).equals(36);
      check(gcdAll).equals(12);
      check(lcmAll).equals(12);
      check(fact).equals(120);
      check(bigComb).equals(BigInt.from(15890700));
      check(base10Digits).deepEquals([4, 3, 2, 1]);
      check(primeCheck).isTrue();
      check(primesUpTo30).deepEquals([2, 3, 5, 7, 11, 13, 17, 19, 23, 29]);

      final polyVal = [1, 2, 3].polynomial(5);
      final hyp = 0.5.sinh();
      final invHyp = hyp.asinh();
      final deg = 3.141592653589793.toDegrees();
      final clamped = 15.clip(0, 10);
      final inBounds = 5.between(1, 10);
      check(polyVal).equals(86);
      check(invHyp).isCloseTo(0.5, 1e-9);
      check(deg).isCloseTo(180.0, 1e-9);
      check(clamped).equals(10);
      check(inBounds).isTrue();

      final popCount = 0x2d.bitCount;
      final isPow2 = 64.hasSingleBit;
      final floorPow2 = 50.bitFloor;
      final ceilPow2 = 50.bitCeil;
      final toggled = 0x04.setBit(0).clearBit(2).toggleBit(1);
      final next = 1.0.nextUp;
      final prev = 1.0.nextDown;
      final ulp = 1.0.ulp;

      check(popCount).equals(4);
      check(isPow2).isTrue();
      check(floorPow2).equals(32);
      check(ceilPow2).equals(64);
      check(toggled).equals(3);
      check(next).isGreaterThan(1.0);
      check(prev).isLessThan(1.0);
      check(ulp).equals(2.220446049250313e-16);
    });
  });

  group('more-dart-use-number-library', () {
    test('Fraction, Complex, and Quaternion', () {
      final a = Fraction(1, 3);
      final b = Fraction.fromDouble(0.75);
      final c = Fraction.parse('2/6');
      final sum = a + b;
      final product = a * b;
      final inv = a.reciprocal();
      final farey3 = Fraction.farey(3);
      final firstFivePositive = Fraction.positive.take(5).toList();

      check(a).equals(c);
      check(sum).equals(Fraction(13, 12));
      check(product).equals(Fraction(1, 4));
      check(inv).equals(Fraction(3, 1));
      check(farey3.length).equals(5);
      check(firstFivePositive.length).equals(5);

      const z1 = Complex(3, 4);
      final z2 = Complex.fromPolar(2, 0.5);
      final parsed = Complex.parse('1-2i');
      final magnitude = z1.abs();
      final phase = z1.arg();
      final conj = z1.conjugate();
      final quot = z1 / const Complex(1, 1);
      final rootsOfUnity = Complex.one.roots(4);
      final euler = (Complex.i * 3.141592653589793).exp();
      final isNearMinusOne = euler.closeTo(const Complex(-1, 0), 1e-12);

      check(z2.abs()).isCloseTo(2.0, 1e-9);
      check(parsed).equals(const Complex(1, -2));
      check(magnitude).equals(5.0);
      check(phase).isGreaterThan(0.0);
      check(conj).equals(const Complex(3, -4));
      check(quot.real).isCloseTo(3.5, 1e-9);
      check(rootsOfUnity.length).equals(4);
      check(isNearMinusOne).isTrue();

      const q1 = Quaternion(1, 2, 3, 4);
      final rotZ = Quaternion.fromAxis(const [0, 0, 1], 1.5707963267948966);
      final fromVecs = Quaternion.fromVectors(const [1, 0, 0], const [0, 1, 0]);
      final qParsed = Quaternion.parse('1+2i-3j+4k');
      final unit = q1.normalize();
      final inverse = q1.reciprocal();
      final identityCheck = (q1 * inverse).closeTo(Quaternion.one, 1e-9);

      check(rotZ.abs()).isCloseTo(1.0, 1e-9);
      check(fromVecs.abs()).isCloseTo(1.0, 1e-9);
      check(qParsed).equals(const Quaternion(1, 2, -3, 4));
      check(unit.abs()).isCloseTo(1.0, 1e-9);
      check(identityCheck).isTrue();
    });
  });

  group('more-dart-use-temporal-library', () {
    test('DateTime properties, truncation, periodical, and Duration', () {
      final dt = DateTime.utc(2024, 2, 29, 14, 35, 20);
      final leap = dt.isLeapYear;
      final daysInMonth = dt.daysInMonth;
      final daysInYear = dt.daysInYear;
      final quarter = dt.quarter;
      final dayOfYear = dt.dayOfYear;
      final weekNum = dt.weekNumber;
      final weekYr = dt.weekYear;
      final startOfDay = dt.truncateTo(TimeUnit.day);
      final startOfWeek = dt.truncateTo(
        TimeUnit.week,
        startWeekday: DateTime.monday,
      );
      final startOfMonth = dt.truncateTo(TimeUnit.month);

      check(leap).isTrue();
      check(daysInMonth).equals(29);
      check(daysInYear).equals(366);
      check(quarter).equals(1);
      check(dayOfYear).equals(60);
      check(weekNum).equals(9);
      check(weekYr).equals(2024);
      check(startOfDay).equals(DateTime.utc(2024, 2, 29));
      check(startOfWeek).equals(DateTime.utc(2024, 2, 26));
      check(startOfMonth).equals(DateTime.utc(2024, 2, 1));

      final start = DateTime.utc(2025, 1, 1);
      final quarters = start.periodical(TimeUnit.quarter).take(4).toList();
      final biweekly = start
          .periodical(TimeUnit.week, step: 2)
          .take(3)
          .toList();
      check(quarters.length).equals(4);
      check(biweekly.length).equals(3);

      const dur = Duration(days: 3, hours: 5, minutes: 45);
      final inHours = dur.convertTo(TimeUnit.hour);
      final parts = dur.convertToAll({
        TimeUnit.day,
        TimeUnit.hour,
        TimeUnit.minute,
      });
      final days = parts[TimeUnit.day];
      final hours = parts[TimeUnit.hour];
      final span = Interval(
        DateTime.utc(2025, 1, 1),
        DateTime.utc(2025, 1, 3),
      ).toDuration();

      check(inHours).equals(77.75);
      check(days).equals(3);
      check(hours).equals(5);
      check(span).equals(const Duration(days: 2));
    });
  });

  group('more-dart-use-interval-library', () {
    test('Interval and IntervalTree', () {
      final a = Interval<num>(1, 5);
      final b = Interval<num>(4, 8);
      final point = Interval<num>(3);
      check(point.isSingle).isTrue();

      final has3 = a.contains(3);
      final enclosesSub = a.encloses(Interval<num>(2, 4));
      final overlaps = a.intersects(b);
      final common = a.intersection(b);
      final spanned = a.union(b);
      final remaining = a.difference(b);

      check(has3).isTrue();
      check(enclosesSub).isTrue();
      check(overlaps).isTrue();
      check(common).equals(Interval<num>(4, 5));
      check(spanned).equals(Interval<num>(1, 8));
      check(remaining).deepEquals([Interval<num>(1, 4)]);

      final tree = IntervalTree.fromIntervals<num>([
        Interval(1, 5),
        Interval(3, 9),
        Interval(10, 15),
      ]);
      final at4 = tree.queryPoint(4);
      final inRange = tree.queryInterval(Interval(8, 12));
      check(at4).deepEquals([Interval<num>(3, 9), Interval<num>(1, 5)]);
      check(inRange).deepEquals([Interval<num>(3, 9), Interval<num>(10, 15)]);

      final tasks = IntervalTree.fromValues<num, Task>([
        (name: 'Build', slot: Interval(0, 10)),
        (name: 'Test', slot: Interval(8, 20)),
      ], (task) => task.slot);
      final activeAt9 = tasks.queryPoint(9).map((t) => t.name).toSet();
      check(activeAt9).deepEquals({'Build', 'Test'});
    });
  });

  group('more-dart-use-cache-library', () {
    test('Cache strategies and operations', () async {
      final lruCache = Cache<String, int>.lru(
        loader: (key) => key.length,
        maximumSize: 100,
      );
      final fifoCache = Cache<String, int>.fifo(
        loader: (key) async => key.hashCode,
        maximumSize: 100,
      );
      final expiryCache = Cache<String, String>.expiry(
        loader: (key) => key.toUpperCase(),
        updateExpiry: const Duration(minutes: 10),
        accessExpiry: const Duration(minutes: 2),
      );
      final noOpCache = Cache<String, int>.empty(loader: (key) => key.length);

      check(await lruCache.get('abc')).equals(3);
      check(await fifoCache.get('abc')).equals('abc'.hashCode);
      check(await expiryCache.get('abc')).equals('ABC');
      check(await noOpCache.get('abc')).equals(3);

      final cache = Cache<String, int>.lru(
        loader: (key) => key.length,
        maximumSize: 10,
      );
      final len = await cache.get('hello');
      final present = await cache.getIfPresent('unknown');
      final many = await cache.getAll(['a', 'bb']);
      await cache.set('custom', 42);
      await cache.setAll({'x': 10, 'y': 20});
      await cache.invalidate('custom');
      await cache.invalidateAll();
      await cache.reap();
      final currentSize = await cache.size();

      check(len).equals(5);
      check(present).isNull();
      check(many).deepEquals({'a': 1, 'bb': 2});
      check(currentSize).equals(0);
    });
  });

  group('more-dart-use-functional-library', () {
    test('Optional, Either, also, and function combinators', () {
      const present = Optional.of('hello');
      const absent = Optional<String>.absent();
      const String? nullStr = null;
      final fromNullable = Optional.ofNullable(nullStr);
      final viaExt = 'world'.toOptional();

      final lengthOpt = present.where((s) => s.isNotEmpty).map((s) => s.length);
      final val = lengthOpt.orElse(0);
      final lazyVal = absent.orElseGet(() => 'fallback');
      final nullableVal = absent.valueOrNull;

      check(fromNullable.isAbsent).isTrue();
      check(viaExt.value).equals('world');
      check(val).equals(5);
      check(lazyVal).equals('fallback');
      check(nullableVal).isNull();

      const right = Either<String, int>.right(42);
      const left = Either<String, int>.left('Invalid input');
      final condEither = Either.iff(true, () => 'err', () => 100);
      final message = right.fold(
        (err) => 'Error: $err',
        (val) => 'Success: ${val * 2}',
      );
      final mapped = right.mapRight((n) => n + 1);
      final swapped = right.swap();

      check(left.isLeft).isTrue();
      check(condEither.isLeft).isTrue();
      check(message).equals('Success: 84');
      check(mapped.rightValue).equals(43);
      check(swapped.leftValue).equals(42);

      final result = '  42  '.also((s) => s.trim()).also(int.parse);
      int add3(int a, int b, int c) => a + b + c;
      final curriedSum = add3.curry(1)(2)(3);
      final add10AndBAndC = add3.bind0(10);
      final boundSum = add10AndBAndC(20, 30);
      final id = identityFunction<int>(7);
      final alwaysTrue = constantFunction1<String, bool>(true)('any');

      check(result).equals(42);
      check(curriedSum).equals(6);
      check(boundSum).equals(60);
      check(id).equals(7);
      check(alwaysTrue).isTrue();
    });
  });

  group('more-dart-use-diff-library', () {
    test('SequenceMatcher, differs, and closeMatches', () {
      final matcher = SequenceMatcher<String>(
        source: ['a', 'b', 'c', 'd'],
        target: ['a', 'x', 'c', 'd', 'e'],
      );
      final similarity = matcher.ratio;
      final blocks = matcher.matches;
      for (final op in matcher.operations) {
        final kind = op.type;
        check(kind).isNotNull();
      }
      final hunks = matcher.groupedOperations(context: 2);
      check(similarity).isGreaterThan(0.5);
      check(blocks).isNotEmpty();
      check(hunks).isNotEmpty();

      const sourceText = 'apple\nbanana\ncherry';
      const targetText = 'apple\nblueberry\ncherry';
      final unified = const UnifiedDiffer(context: 3).compareStrings(
        sourceText,
        targetText,
        sourceLabel: 'a/fruits.txt',
        targetLabel: 'b/fruits.txt',
      );
      final readable = ReadableDiffer().compareStrings(sourceText, targetText);
      final contextDiff = const ContextDiffer(context: 3)
          .compareStrings(sourceText, targetText);
      final normalDiff = const NormalDiffer().compareStrings(
        sourceText,
        targetText,
      );

      check(unified).isNotEmpty();
      check(readable).isNotEmpty();
      check(contextDiff).isNotEmpty();
      check(normalDiff).isNotEmpty();

      const candidates = ['apple', 'ape', 'peach', 'puppy'];
      final best = candidates.closeMatches('appel', count: 2, cutoff: 0.6);
      check(best).deepEquals(['apple', 'ape']);
    });
  });

  group('more-dart-use-async-library', () {
    test('Stream transformations', () async {
      final source = Stream.fromIterable([1, 2, 3, 4, 5]);
      final batches = await source.buffer(maxLength: 2).toList();
      final windows = await source.window(3, step: 2).toList();
      check(batches).deepEquals([
        [1, 2],
        [3, 4],
        [5],
      ]);
      check(windows).deepEquals([
        [1, 2, 3],
        [3, 4, 5],
      ]);

      final expanded = await Stream.fromIterable([1, 2])
          .flatMap((x) => [x, x * 10])
          .toList();
      final asyncExpanded = await Stream.fromIterable([1, 2])
          .asyncFlatMap((x) => Stream.fromIterable([x, -x]))
          .toList();
      final flat = await Stream.fromIterable([
        [1, 2],
        [3],
      ]).flatten().toList();
      final stringsOnly = await Stream<Object>.fromIterable([1, 'a', 2, 'b'])
          .whereType<String>()
          .toList();
      final observed = <int>[];
      await Stream.fromIterable([10, 20])
          .tap(onData: observed.add)
          .drain<void>();

      check(expanded).deepEquals([1, 10, 2, 20]);
      check(asyncExpanded).deepEquals([1, -1, 2, -2]);
      check(flat).deepEquals([1, 2, 3]);
      check(stringsOnly).deepEquals(['a', 'b']);
      check(observed).deepEquals([10, 20]);
    });
  });

  group('more-dart-use-tuple-library', () {
    test('Tuple extensions', () {
      const record = ('Alice', 30, true);
      final len = record.length;
      final name = record.first;
      final age = record.second;
      final active = record.last;
      final updated = record.withSecond(31).withLast(false);

      check(len).equals(3);
      check(name).equals('Alice');
      check(age).equals(30);
      check(active).isTrue();
      check(updated).equals(('Alice', 31, false));

      const pair = (10, 20);
      final triple = pair.addLast(30);
      final prepended = pair.addFirst(0);
      final inserted = pair.addSecond(15);
      final shrunk = triple.removeSecond();
      final withoutLast = triple.removeLast();

      check(triple).equals((10, 20, 30));
      check(prepended).equals((0, 10, 20));
      check(inserted).equals((10, 15, 20));
      check(shrunk).equals((10, 30));
      check(withoutLast).equals((10, 20));

      const point = (3, 4);
      final distSquared = point.map((x, y) => x * x + y * y);
      final asList = point.toList();
      final asSet = point.toSet();
      final fromList = Tuple3.fromList(['a', 'b', 'c']);

      check(distSquared).equals(25);
      check(asList).deepEquals([3, 4]);
      check(asSet).deepEquals({3, 4});
      check(fromList).equals(('a', 'b', 'c'));
    });
  });
}
