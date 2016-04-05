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

- `char_matcher.dart` is a model for character classes, their composition and operations on strings.
- `collection.dart` is a collection of collection types (bi map, bit list, multi set, range, string).
- `fraction.dart` provides exact rational number arithmetic.
- `int_math.dart` is a collection of common mathematical functions on integers.
- `iterable.dart` is a collection of iterables and iterators.
- `ordering.dart` a fluent interface for building comparator functions.

And there are more to come ...

This library is open source, stable and well tested. Development happens on [GitHub](https://github.com/renggli/dart-more). Feel free to report issues or create a pull-request there. General questions are best asked on [StackOverflow](http://stackoverflow.com/questions/tagged/more+dart).

Up-to-date [class documentation](http://www.dartdocs.org/documentation/more/latest/index.html) is created with every release.


Misc
----

### Installation

Follow the _Installing_ instructions on https://pub.dartlang.org/packages/more.

Import one or more of the packages into your Dart code using:

```dart
import 'package:more/char_matcher.dart';
import 'package:more/collection.dart';
import 'package:more/fraction.dart';
import 'package:more/int_math.dart';
import 'package:more/iterable.dart';
import 'package:more/ordering.dart';
```

### History

This library started in April 2013 as I was working through the puzzles of [Project Euler](https://projecteuler.net/) and encountered some missing features in Dart. Over time the library grew and became _more_ useful in many other places, so I created this reusable library.

### License

The MIT License, see [LICENSE](https://github.com/renggli/dart-more/raw/master/LICENSE).
