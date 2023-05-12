More Dart — Literally
=====================

[![Pub Package](https://img.shields.io/pub/v/more.svg)](https://pub.dev/packages/more)
[![Build Status](https://github.com/renggli/dart-more/actions/workflows/dart.yml/badge.svg?branch=main)](https://github.com/renggli/dart-more/actions/workflows/dart.yml)
[![Code Coverage](https://codecov.io/gh/renggli/dart-more/branch/main/graph/badge.svg?token=b0fvRMeMBR)](https://codecov.io/gh/renggli/dart-more)
[![GitHub Issues](https://img.shields.io/github/issues/renggli/dart-more.svg)](https://github.com/renggli/dart-more/issues)
[![GitHub Forks](https://img.shields.io/github/forks/renggli/dart-more.svg)](https://github.com/renggli/dart-more/network)
[![GitHub Stars](https://img.shields.io/github/stars/renggli/dart-more.svg)](https://github.com/renggli/dart-more/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/renggli/dart-more/main/LICENSE)

A collection of extensively tested extensions that make Dart a better place:

| Library                                                                                          | Description                                                        |
|:-------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------|
| [async](https://pub.dev/documentation/more/latest/async/async-library.html)                      | Extensions to `Stream`.                                            | 
| [cache](https://pub.dev/documentation/more/latest/cache/cache-library.html)                      | Caching strategies and their expiry policy.                        |
| [char_matcher](https://pub.dev/documentation/more/latest/char_matcher/char_matcher-library.html) | Character classes, their composition, and operations on strings.   |
| [collection](https://pub.dev/documentation/more/latest/collection/collection-library.html)       | Extensions to `Iterable` and new collection types.                 |
| [comparator](https://pub.dev/documentation/more/latest/comparator/comparator-library.html)       | Common comparators, and extensions to perform advanced operations. | 
| [feature](https://pub.dev/documentation/more/latest/feature/feature-library.html)                | Information about the runtime environment.                         |
| [functional](https://pub.dev/documentation/more/latest/functional/functional-library.html)       | Types and features known from functional programming.              |
| [graph](https://pub.dev/documentation/more/latest/graph/graph-library.html)                      | Graph-theory objects and algorithms.                               |
| [interval](https://pub.dev/documentation/more/latest/interval/interval-library.html)             | Continuous interval data type over a comparable type.              |
| [math](https://pub.dev/documentation/more/latest/math/math-library.html)                         | Common mathematical functions.                                     |
| [number](https://pub.dev/documentation/more/latest/number/number-library.html)                   | Number types: fraction, complex, quaternion.                       |
| [printer](https://pub.dev/documentation/more/latest/printer/printer-library.html)                | Fluent interface to configure sophisticated formatter.             |
| [temporal](https://pub.dev/documentation/more/latest/temporal/temporal-library.html)             | Extensions to `DateTime` and `Duration` types.                     | 
| [tuple](https://pub.dev/documentation/more/latest/tuple/tuple-library.html)                      | Tuple extension methods on generic records.                        |

And there are more to come ...

This library is open source, stable and well tested. Development happens on [GitHub](https://github.com/renggli/dart-more). Feel free to report issues or create a pull-request there. General questions are best asked on [StackOverflow](https://stackoverflow.com/questions/tagged/more+dart).

The package is hosted on [dart packages](https://pub.dev/packages/more). Up-to-date [class documentation](https://pub.dev/documentation/more/) is created with every release.


Misc
----

### Installation

Follow the installation instructions on [dart packages](https://pub.dev/packages/more/install).

Import the all-including parent package:

```dart
import 'package:more/more.dart';
```

Or one or more of the specific packages into your Dart code:

```dart
import 'package:more/async.dart';
import 'package:more/cache.dart';
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:more/feature.dart';
import 'package:more/functional.dart';
import 'package:more/graph.dart';
import 'package:more/interval.dart';
import 'package:more/math.dart';
import 'package:more/number.dart';
import 'package:more/printer.dart';
import 'package:more/temporal.dart';
import 'package:more/tuple.dart';
```

### Contributing

The goal of the library is to provide a loose collection of carefully curated utilities that are not provided by the Dart standard library. All features must be well tested. New features must have significant advantages over alternatives, such as code reduction, readability improvement, speed increase, memory reduction, or improved accuracy. In case of doubt, consider filing a feature request before filing a pull request.

### History

This library started in April 2013 as I was working through the puzzles of [Project Euler](https://projecteuler.net/) and encountered some missing features in Dart. Over time the code grew and became _more_ useful in many other places, so I created this reusable library.

Some parts of this library are inspired by similar APIs in [Google Guava](https://github.com/google/guava) (Google core libraries for Java) and [Apache Commons](https://commons.apache.org/) (a repository of reusable Java components).

### License

The MIT License, see [LICENSE](https://github.com/renggli/dart-more/raw/main/LICENSE).
