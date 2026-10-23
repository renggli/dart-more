# More Dart — Literally

[![Pub Package](https://img.shields.io/pub/v/more.svg)](https://pub.dev/packages/more)
[![Build Status](https://github.com/renggli/dart-more/actions/workflows/dart.yml/badge.svg?branch=main)](https://github.com/renggli/dart-more/actions/workflows/dart.yml)
[![Code Coverage](https://codecov.io/gh/renggli/dart-more/branch/main/graph/badge.svg?token=b0fvRMeMBR)](https://codecov.io/gh/renggli/dart-more)
[![GitHub Issues](https://img.shields.io/github/issues/renggli/dart-more.svg)](https://github.com/renggli/dart-more/issues)
[![GitHub Forks](https://img.shields.io/github/forks/renggli/dart-more.svg)](https://github.com/renggli/dart-more/network)
[![GitHub Stars](https://img.shields.io/github/stars/renggli/dart-more.svg)](https://github.com/renggli/dart-more/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/renggli/dart-more/main/LICENSE)

A collection of extensively tested extensions that make Dart a better place:

| Library                                                                                          | Description                                                        |
| ------------------------------------------------------------------------------------------------ | :----------------------------------------------------------------- |
| [async](https://pub.dev/documentation/more/latest/async/async-library.html)                      | Extensions to `Stream`.                                            |
| [cache](https://pub.dev/documentation/more/latest/cache/cache-library.html)                      | Caching strategies and their expiry policy.                        |
| [char_matcher](https://pub.dev/documentation/more/latest/char_matcher/char_matcher-library.html) | Character classes, their composition, and operations on strings.   |
| [collection](https://pub.dev/documentation/more/latest/collection/collection-library.html)       | Extensions to `Iterable` and new collection types.                 |
| [comparator](https://pub.dev/documentation/more/latest/comparator/comparator-library.html)       | Common comparators, and extensions to perform advanced operations. |
| [diff](https://pub.dev/documentation/more/latest/diff/diff-library.html)                         | Tools for comparing lists.                                         |
| [feature](https://pub.dev/documentation/more/latest/feature/feature-library.html)                | Information about the runtime environment.                         |
| [functional](https://pub.dev/documentation/more/latest/functional/functional-library.html)       | Types and features known from functional programming.              |
| [graph](https://pub.dev/documentation/more/latest/graph/graph-library.html)                      | Graph-theory objects and algorithms.                               |
| [interval](https://pub.dev/documentation/more/latest/interval/interval-library.html)             | Continuous interval data type over a practical range.              |
| [math](https://pub.dev/documentation/more/latest/math/math-library.html)                         | Common mathematical functions.                                     |
| [number](https://pub.dev/documentation/more/latest/number/number-library.html)                   | Number types: fraction, complex, quaternion.                       |
| [printer](https://pub.dev/documentation/more/latest/printer/printer-library.html)                | Fluent interface to configure sophisticated formatters.            |
| [temporal](https://pub.dev/documentation/more/latest/temporal/temporal-library.html)             | Extensions to `DateTime` and `Duration` types.                     |
| [tuple](https://pub.dev/documentation/more/latest/tuple/tuple-library.html)                      | Tuple extension methods on generic records.                        |

And there are more to come ...

## Highlights

### Collections & Iterables

Powerful extensions and specialized data structures that complement `dart:collection`:

```dart
import 'package:more/collection.dart';

// Integer ranges with custom stepping
0.to(10, step: 2); // [0, 2, 4, 6, 8]

// Sliding windows and fixed chunks
[1, 2, 3, 4, 5].window(3); // [[1, 2, 3], [2, 3, 4], [3, 4, 5]]
[1, 2, 3, 4, 5].chunked(2); // [[1, 2], [3, 4], [5]]

// Combinatorics: combinations, permutations, and power sets
['a', 'b', 'c'].combinations(2); // [['a', 'b'], ['a', 'c'], ['b', 'c']]

// Rich collections: Multimaps, BiMaps, BitLists, and Sorted/Ordered lists
final multimap = ListMultimap<String, int>()
  ..add('even', 2)
  ..add('even', 4)
  ..add('odd', 1);
print(multimap['even']); // [2, 4]
```

### Graph Theory & Algorithms

Flexible graph data structures with built-in pathfinding, search, and topological analysis:

```dart
import 'package:more/graph.dart';

// Create a directed weighted graph
final graph = Graph<String, num>.directed()
  ..addEdge('A', 'B', value: 4)
  ..addEdge('A', 'C', value: 2)
  ..addEdge('C', 'B', value: 1);

// Find shortest path using Dijkstra's algorithm
final path = graph.shortestPath('A', 'B');
print(path?.vertices); // ['A', 'C', 'B']
print(path?.cost); // 3

// Topological sort and cycle detection
final sorted = graph.topological('A');
final hasCycle = graph.hasCycle();
```

### Numbers & Mathematics

Exact rational arithmetic, complex numbers, and extended math functions on integers:

```dart
import 'package:more/math.dart';
import 'package:more/number.dart';

// Exact rational arithmetic
final a = Fraction(1, 3);
final b = Fraction(1, 6);
print(a + b); // Fraction(1, 2)
print(Fraction.tryParse('3/4')); // Fraction(3, 4)

// Complex numbers & quaternions
final c = Complex(3, 4);
print(c.abs()); // 5.0

// Math extensions on int and BigInt
12.gcd(8); // 4
5.factorial(); // 120
17.isProbablyPrime; // true
123.digits(); // [3, 2, 1]
```

### Composable Printers

A fluent, composable model to format strings, numbers, and dates without complex templates:

```dart
import 'package:more/printer.dart';

// Formatted numbers with padding, prefix, and precision
final currency = FixedNumberPrinter(precision: 2).before(r'$').padLeft(8);
print(currency(12.5)); // '  $12.50'

// Human-readable binary/decimal quantities
final human = HumanNumberPrinter.binary();
print(human(1024 * 1024 * 3)); // '3 Mi'

// Configurable date and time formatting
final date = DateTimePrinter.date();
print(date(DateTime(2025, 1, 15))); // '2025-01-15'
```

### Temporal & Intervals

Fluent manipulation of dates, durations, and continuous intervals:

```dart
import 'package:more/interval.dart';
import 'package:more/temporal.dart';

// Truncate dates to specific units
final now = DateTime(2025, 5, 12, 14, 23, 45);
print(now.truncateTo(TimeUnit.hour)); // 2025-05-12 14:00:00.000

// Continuous interval operations
final intA = Interval(1, 5); // [1..5]
final intB = Interval(3, 7); // [3..7]
print(intA.intersection(intB)); // [3..5]
```

### Caching & CharMatcher

Self-loading caches with LRU/FIFO/expiry policies, and composable character matchers:

```dart
import 'package:more/cache.dart';
import 'package:more/char_matcher.dart';

// Self-loading LRU cache
final cache = Cache<String, int>.lru(
  loader: (key) => key.length,
  maximumSize: 100,
);
final value = await cache.get('hello'); // 5

// Fast string operations via character sets
final letters = CharMatcher.letter();
print(letters.retainFrom('Hello 123!')); // 'Hello'
print(letters.replaceFrom('Hello 123!', '*')); // '***** 123!'
```

## Misc

This library is open source, stable and well tested. Development happens on [GitHub](https://github.com/renggli/dart-more). Feel free to report issues or create a pull-request there. General questions are best asked on [StackOverflow](https://stackoverflow.com/questions/tagged/more+dart).

The package is hosted on [dart packages](https://pub.dev/packages/more). Up-to-date [class documentation](https://pub.dev/documentation/more/) is created with every release.

### Contributing

The goal of the library is to provide a loose collection of carefully curated utilities that are not provided by the Dart standard library. All features must be well tested. New features must have significant advantages over alternatives, such as code reduction, readability improvement, speed increase, memory reduction, or improved accuracy. In case of doubt, consider filing a feature request before filing a pull request.

### History

This library started in April 2013 as I was working through the puzzles of [Project Euler](https://projecteuler.net/) and encountered some missing features in Dart. Over time the code grew and became _more_ useful in many other places, so I created this reusable library.

Some parts of this library are inspired by similar APIs in [Google Guava](https://github.com/google/guava) (Google core libraries for Java) and [Apache Commons](https://commons.apache.org/) (a repository of reusable Java components).

### License

The MIT License, see [LICENSE](https://github.com/renggli/dart-more/raw/main/LICENSE).
