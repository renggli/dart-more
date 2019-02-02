# Changelog

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
  * Replace callers of `range()` with either `new IntegerRange()` or 
    `new DoubleRange()`.
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
* Move to latest Dart provided mixins.

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