# Changelog

## 2.8.0

* Remove `Iterable.concat()` in favor of `Iterable.flatten()`.
* Split `Iterable.zip()` into `Interable.zip()`, `Iterable.zipPartial()` and `Iterable.zipPartialWith()`.
* Fix a bug in `Ordering.nullsFirst` and `Ordering.nullsLast`.
* Fix a race condition in cache value resolution.

## 2.7.0

* Add `separatedBy`, `flatMap` and `flatten` function on `Iterable`.
* Cleanup `printer` package and improve documentation.

## 2.6.0

* Add `repeat` function on `Iterable`.
* Improved documentation.

## 2.5.0

* Printer package correctly trims, pads and separates unicode strings now.
* Updated class documentation regarding UTF-16 representation vs unicode strings. 

## 2.4.0

* Add in-place logical operators to `BitList`.
* Optimize `CharMatcher` with lookup tables.
* Improved documentation.

## 2.3.0

* Add `ListMultimap` and `SetMultimap`.
* Mark `CharMatcher`, `Cache` and `Ordering` as immutable.
* Improve documentation, which still included pre Dart 2.0 examples.
* Add extension methods to convert `Comparator` to `Ordering`.

## 2.2.0

* Made `truncateToPeriod` and `periodical` extension methods of `DateTime`.
* Add extension methods to convert 
  * a `Map<K, V>` to a `BiMap<K, V>`, 
  * an `Iterable<bool>` to a `BitList`, and
  * an `Iterable<T>` to a `Multiset<T>`.

## 2.1.0

* Cleanup `Tuple` class to be more readable and better typed.

## 2.0.0

* Dart 2.7 compatibility and requirement.
* Cleaned up deprecated code.
* Iterables
    * Converted most helpers to extension methods.
    * Removed `fold` and `fib`, as they are not generally useful.
    * Moved `digits` to `package:more/math`.
* Collections
    * Add extension method to `int` and `double` to create ranges, i.e. `0.to(20)`.
    * Move the string lists to `String.toList()` extension method.
* Math
    * Move all numerical operators to `num`, `ìnt` and/or `BigInt` (new).

## 1.18.0

* Dart 2.4 compatibility and requirement.
* Add a tuple data type.

## 1.17.0

* Dart 2.3 compatibility and requirement.
* Various code improvements and optimizations.

## 1.16.0

* Dart 2.2 compatibility and requirement.

## 1.15.0

* Deprecated `package:more/int_math` package, and moved all not-deprecated code to `package:more/math.dart`.
* Add 'polyfills' for hyperbolic functions to the math package.
* Add functionality for combining hash codes.

## 1.14.0

* Quaternion numbers.

## 1.13.0

* Rename `Range.stop` to `Range.end` to be consistent with Dart naming conventions.
* Rename `partition` to `chunked` to be more consistent with Dart nomenclature.
* Add the `zip` iterable.

## 1.12.0

* Add the number package.
  * Move `Fraction` class into this package.
  * Add support for `Complex` numbers. 
* Add the `groupBy` iterable.

## 1.11.0

* Add the printer package.

## 1.10.0

* Drop Dart 1.0 compatibility.

## 1.9.0

* Dart 2.0 strong-mode compatibility required the following breaking changes:
  * Replace callers of `range()` with either `IntegerRange()` or `DoubleRange()`.
  * Removed padding argument from `partition()`. To migrate replace broken
    calls-sites with `partitionWithPadding()`.

## 1.8.1

* Removed empty(), emptyIterator(), emptyIterable() since these are part of the core library now.
* Add periodic iterable tools (monthly, weekly, daily, hourly, ...).

## 1.8.0

* Ordering.reversed, Ordering.nullsFirst, Ordering.nullsLast, and Ordering.lexicographical
  are now properties for consistency with the Iterable protocol.
* Various optimization and improvements on the Range class.

## 1.7.2

* Cleanup after micro library migration.
* Move to the latest Dart provided mixins.

## 1.7.1

* Cleanup after micro library migration.
* Address linter warnings.
* Better test coverage.

## 1.7.0

* Migrate to micro libraries.
* Add caching library.

## 1.6.0

* Use generic method syntax.

## 1.5.3

* Fix pubspec SDK constraints.

## 1.5.2

* Fix linter warnings.
* Improve documentation.

## 1.5.1

* Strong compiler compliant.

## 1.5.0

* Fix various typos and linter issues.
* Reformat documentation.

## 1.4.0

* Migrate to Travis.