More Dart — Literally
=====================

[![Pub Package](https://img.shields.io/pub/v/more.svg)](https://pub.dartlang.org/packages/more)
[![Build Status](https://travis-ci.org/renggli/dart-more.svg)](https://travis-ci.org/renggli/dart-more)
[![Coverage Status](https://coveralls.io/repos/renggli/dart-more/badge.svg)](https://coveralls.io/r/renggli/dart-more)
[![GitHub Issues](https://img.shields.io/github/issues/renggli/dart-more.svg)](https://github.com/renggli/dart-more/issues)
[![GitHub Forks](https://img.shields.io/github/forks/renggli/dart-more.svg)](https://github.com/renggli/dart-more/network)
[![GitHub Stars](https://img.shields.io/github/stars/renggli/dart-more.svg)](https://github.com/renggli/dart-more/stargazers)
[![GitHub License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/renggli/dart-more/master/LICENSE)

Various extensions that make Dart a better place:

- `cache.dart` is a collection of different caching strategies and their expiry policy.
- `char_matcher.dart` is a model for character classes, their composition and operations on strings.
- `collection.dart` is a collection of collection types (bi map, bit list, multi set, range, and string).
- `iterable.dart` is a collection of iterables and iterators.
- `math.dart` is a collection of common mathematical functions.
- `number.dart` provides fractional, complex and quaternion arithmetic.
- `ordering.dart` a fluent interface for building comparator functions.
- `printer.dart` a fluent interface for configuring sophisticated formatter.

And there are more to come ...

This library is open source, stable and well tested. Development happens on [GitHub](https://github.com/renggli/dart-more). Feel free to report issues or create a pull-request there. General questions are best asked on [StackOverflow](http://stackoverflow.com/questions/tagged/more+dart).

The package is hosted on [dart packages](https://pub.dartlang.org/packages/more). Up-to-date [class documentation](https://pub.dartlang.org/documentation/more/) is created with every release.


Misc
----

### Installation

Follow the installation instructions on [dart packages](https://pub.dartlang.org/packages/more#-installing-tab-).

Import one or more of the packages into your Dart code using:

```dart
import 'package:more/cache.dart';
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:more/iterable.dart';
import 'package:more/math.dart';
import 'package:more/number.dart';
import 'package:more/ordering.dart';
import 'package:more/printer.dart';
```

### History

This library started in April 2013 as I was working through the puzzles of [Project Euler](https://projecteuler.net/) and encountered some missing features in Dart. Over time the library grew and became _more_ useful in many other places, so I created this reusable library.

### License

The MIT License, see [LICENSE](https://github.com/renggli/dart-more/raw/master/LICENSE).
