More Dart — Literally
=====================

[![Pub Package](https://img.shields.io/pub/v/more.svg)](https://pub.dev/packages/more)
[![Build Status](https://github.com/renggli/dart-more/actions/workflows/dart.yml/badge.svg?branch=main)](https://github.com/renggli/dart-more/actions/workflows/dart.yml)
[![GitHub Issues](https://img.shields.io/github/issues/renggli/dart-more.svg)](https://github.com/renggli/dart-more/issues)
[![GitHub Forks](https://img.shields.io/github/forks/renggli/dart-more.svg)](https://github.com/renggli/dart-more/network)
[![GitHub Stars](https://img.shields.io/github/stars/renggli/dart-more.svg)](https://github.com/renggli/dart-more/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/renggli/dart-more/main/LICENSE)

A collection of extensively tested extensions that make Dart a better place:

- `async.dart` provides numerous helpers to make async code better.
- `cache.dart` is a collection of different caching strategies and their expiry policy.
- `char_matcher.dart` is a model for character classes, their composition and operations on strings.
- `collection.dart` is a collection of collection types: bi-map, bit-list, multi-set, set and list multi-map, range, and string.
- `feature.dart` provides information about the runtime environment.
- `functional.dart` provides a collection of functional programming structures.
- `iterable.dart` is a collection of iterables and iterators.
- `math.dart` is a collection of common mathematical functions.
- `number.dart` provides fractional, complex and quaternion arithmetic.
- `ordering.dart` a fluent interface for building comparator functions.
- `printer.dart` a fluent interface for configuring sophisticated formatter.
- `tuple.dart` a generic sequence of typed values.

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
import 'package:more/feature.dart';
import 'package:more/iterable.dart';
import 'package:more/math.dart';
import 'package:more/functional.dart';
import 'package:more/utils.dart';
import 'package:more/ordering.dart';
import 'package:more/printer.dart';
import 'package:more/tuple.dart';
```

### Contributing

The goal of the library is to provide a loose collection of carefully curated utilities that are not provided by the Dart standard library. All features must be well tested. New features must have significant advantages over alternatives, such as code reduction, readability improvement, speed increase, memory reduction, or improved accuracy. In case of doubt, consider filing a feature request before filing a pull request.

### History

This library started in April 2013 as I was working through the puzzles of [Project Euler](https://projecteuler.net/) and encountered some missing features in Dart. Over time the library grew and became _more_ useful in many other places, so I created this reusable library.

Some parts of this library are inspired by similar APIs in [Google Guava](https://github.com/google/guava) (Google core libraries for Java) and [Apache Commons](https://commons.apache.org/) (a repository of reusable Java components).

### License

The MIT License, see [LICENSE](https://github.com/renggli/dart-more/raw/main/LICENSE).
