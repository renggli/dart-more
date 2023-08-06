# Changelog

## 4.0.0
* Dart 3.0 requirement.
* Removed deprecated code.
* Reimplement `Tuple` on top of records:
  * Replace types like `Tuple2<String, int>` with `(String, int)`.
  * Replace constructors like `Tuple2('hello', 42)` with `('hello', 42)`.
* Add `Iterable.pairwise` over the successive overlapping pairs.
* Add `Iterable.deepFlatten` over arbitrarily nested iterables.
* Add `product` and `zip` extensions on tuples of iterables.
* Add partial function evaluation, and currying extensions.

## 3.10.0
* Add a growable `BitList`, make it behave more like `List<bool>`.
* Optimize  `BitList` operations: `fill`, `count`, and `indices`.
* Change return type of generic `throwFunction` to `Never`.
* Add graph algorithms and data structures.
* Add `Map.withDefault` providing a default value for non-existing keys.
* Add support to generate permutations with a specified length, as well as extensions to generate the previous and next permutation.

## 3.9.0
* Various extension to work with bits.
* Add iterator over `BitList.indices` that are true or false.
* Add experimental `RTree` implementation.
* Various optimizations and improvements to mathematical functions.
* Generalize the prime sieve implementation and add support for more efficient primality check and factorization.
* More efficient implementation of `repeat` for a single element.
* Make `Iterable.groupBy` and `Iterable.indexed` return instances of `MapEntry` for easier interoperability with `Map`.
* Fix various edge cases with `Range` iterables.
* Fix `Iterable.combinations` for empty iterables.
* Add `List` extensions `takeTo`, `skipTo`, `takeLast`, `takeLastTo`, `skipLast`, and `skipLastTo`.
* Add `Iterable` extension `count` and `powerSet`.
* Deprecate `Iterable.cycle` in favor of `Iterable.repeat`.
* Deprecated `naturalComparator` in favor of `naturalCompare` and `naturalComparable<T>`.
* Deprecate the iterable package, and integrate the extensions into the collection package.

## 3.8.0
* Add `String` extensions `take`, `takeTo`, `skip`, `skipTo`, `takeLast`, `takeLastTo`, `skipLast`, and `skipLastTo`.
* Create a new `temporal` package unifying all `DateTime` and `Duration` related extensions:
  * Moved `DateTime.periodical` and `DateTime.truncate` to the new page, deprecated the old code.
  * Add various convenience accessors to `DateTime`: `isLeapYear`, `daysInYear`, `daysInMonth`, `weeksInYear`, `quarter`, `weekYear`, `weekNumber`, `dayOfYear`, and `hour12`.
  * Add ability to convert `Duration` objects to one or more (fractional) `TimeUnit`s.
* Countless improvements and extensions to the `printer` package:
  * Add `DateTimePrinter` to print date and time objects.
  * Add `OrdinalNumberPrinter` to print ordinal numbers: 1st, 2nd, 3rd, 4th, ...
  * Add `Printer.switcher` to use different printers based on conditions.
  * Add `Printer.where` to condition the printing on the printed object.
  * Add `Printer` support for `take`, `skip`, `takeLast` and `skipLast`.
  * Add `Printer` support for `truncateRight`, `truncateLeft`, and `truncateCenter` to also operate on word and sentence boundaries. Include the ellipsis in the width constraint.
  * Deprecated `Printer.map`, and replace with more common and intention revealing `Printer.onResultOf`.
* Implement the functionality of `Ordering` as static extensions methods on `Comparator` functions:
  * Add `Comparator.binarySearchLower` and `Comparator.binarySearchUpper` to return a lower/upper insertion index.
  * Add `Comparator.largest` and `Comparator.smallest` to return the top/bottom-k elements.
  * Deprecate the `Ordering` class and package.
* Create `Interval` to encapsulate bounded/unbounded and open/closed intervals across arbitrary `Comparable` objects.
  * Add the ability to measure the length of `Interval<int>.toIntLength()` and `Interval<num>.toDoubleLength()`.
  * Add ability to convert `Interval<DateTime>` to a `Duration`.
* Added `SortedList` collection type.
* Add `CompareOperators` mixin to provide operators given a `compareTo` method.

## 3.7.0
* Add `closeTo` extension to all numbers.
* Make `Fraction` support non-finite numbers.

## 3.6.0
* Dart 2.17 requirement.
* Add a max-heap collection type.
* Add predicates for the ordering type.
* Add interval data structure with open, closed, and infinite endpoints.

## 3.5.0
* Dart 2.16 requirement.
* Avoid dynamic calls.
* Better print strings across the library.

## 3.4.0
* Remove deprecated `hashAll` and `hash1`, `hash2`, `hash3`, ... methods.
* Add `ObjectPrinter.addValue` for more dynamic object printing.
* Add `ToStringPrinter` mixin for simpler use of `ObjectPrinter`.
* Add `Stream.window` along the existing `Iterable.window` extension (thanks to https://github.com/pihentagy).
* Various cleanups and better test coverage.

## 3.3.0
* Dart 2.14 requirement.
* Added `indent`/`dedent` and `wrap`/`unwrap` to `String`.
* Deprecated `hashAll` and `hash1`, `hash2`, `hash3`, ... methods, since this is now supported through the core library on `Object`.

## 3.2.0

* Make `Printer` significantly faster by reusing a single `StringBuffer` instance where possible.
* Make `Printer` strongly typed, which unfortunately comes with some required API changes:
  * Number printers do no longer support `BigInt`.
  * Number printers are directly instantiated, instead of using a factory on Printer.
* Improved the `Printer` library in various ways:
  * Renamed `undefined` to the more intention revealing `ifNull`.
  * Added `ifEmpty` to print something specific for empty `Iterables`.
  * Added `map` and `cast` printers for more flexible printing.
  * Add initial version of the `ObjectPrinter`.

## 3.1.0

* Dart 2.13 requirement.
* Add `Optional` and `Either` type.
* Add `TypeMap` that maps Dart types to an instance.
* Add various kinds of function types and function factories: 
    callback function types, 
    constant functions, 
    empty functions, 
    identity functions, 
    mapping function types, 
    predicate function types, and 
    throwing functions. 
* Add `String.convertFirstCharacters()` and `String.convertLastCharacters()`.
* Add `String.toUpperCaseFirstCharacter()` and `String.toLowerCaseFirstCharacter()`.

## 3.0.0

* Dart 2.12 requirement and null-safety.
* Use `package:clock` and `package:fake_async` across the board.
* Add `BigIntRange` and optimize iteration of `IntegerRange`.
* Optimize the implementation of `ExpiryCache`.
* Fix `maxAge` of the `Stream.buffer` operator.
* Add `Fraction.sign` and `Complex.sign`.
* Add `IterablePrinter` to print lists.
* Relax the type constraints on `Ordering.natural`.
* `CharMatcher` is now a `Pattern`.
* Introduce `package:more/feature.dart` to provide information about the runtime environment.
* Add `Trie` (prefix tree) collection type.
* Add `Ordering.percentile`. 
* Add `Iterable.toMap`, `Iterable.atRandom`, `Iterable.min`, `Iterable.max` and `Iterable.percentile`.
* Optimize `Range` object creation and error reporting, and add `Iterable.indices`.
* Add converters `toBiMap`, `toListMultimap`, and `toSetMultimap`.
* Add `String.removePrefix` and `String.removeSuffix`.
* Add `List.rotate` and `Queue.rotate`.

## 2.8.0

* Dart 2.9 compatibility and requirement (in preparation of null-safety).
* Remove `Iterable.concat()` in favor of `Iterable.flatten()`.
* Split `Iterable.zip()` into `Interable.zip()`, `Iterable.zipPartial()` and `Iterable.zipPartialWith()`.
* Fix a bug in `Ordering.nullsFirst` and `Ordering.nullsLast`.
* Fix a race condition in cache value resolution.
* Fix a rounding bug of numeric formats with precision 0.
* Add human number printer (1 kilo, 1 mega, ...).
* Add a map function to `Tuple` classes.

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