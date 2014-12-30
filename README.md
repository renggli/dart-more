More Dart - Literally
=====================

Various extensions that make Dart a better place:

- `bit_list.dart` is a space efficient list storing boolean values.
- `char_matcher.dart` is a model for character classes, their composition and operations on strings.
- `fraction.dart` provides exact rational number arithmetic.
- `int_math.dart` is a collection of common mathematical functions on integers.
- `iterable.dart` is a collection of iterables and iterators.
- `multiset.data` a data structure where elements might appear more than once.
- `ordering.dart` a fluent interface for building comparator functions.
- `range.dart` is a function to create lists of arithmetic progressions.

And there is more to come ...

This library is open source, stable and well tested. Development happens on [GitHub](http://github.com/renggli/dart-more). Feel free to report issues or create a pull-request there. General questions are best asked on [StackOverflow](http://stackoverflow.com/questions/tagged/dart+more).

Continuous build results are available from [Jenkins](http://jenkins.lukas-renggli.ch/job/dart-more).  Up-to-date [documentation](http://jenkins.lukas-renggli.ch/job/dart-more/javadoc) is created automatically with every new push.


Basic Usage
-----------

### Installation

Add the dependency to your package's pubspec.yaml file:

    dependencies:
      more: ">=1.0.0 <2.0.0"

Then on the command line run:

    $ pub get

To use one or more of the packages in your Dart code write:

    import 'package:more/bit_list.dart';
    import 'package:more/char_matcher.dart';
    import 'package:more/fraction.dart';
    import 'package:more/int_math.dart';
    import 'package:more/iterable.dart';
    import 'package:more/multiset.dart';
    import 'package:more/ordering.dart';
    import 'package:more/range.dart';


Misc
----

### History

This library started in April 2013 as I was working through the puzzles of [Project Euler](https://projecteuler.net/) and encountered some missing features in Dart. Over time the library grew and became _more_ useful in many other places, so I created this reusable library.

### License

The MIT License, see [LICENSE](https://github.com/renggli/dart-more/raw/master/LICENSE).