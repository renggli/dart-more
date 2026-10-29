# Project Review Tasks

## 1. Bugs and Edge Cases

- [x] **`RandomWalkIterable` (`_RandomWalkIterator`) corrupts `seen` when `selfAvoiding: true` and can infinite-loop on float rounding**
  - **Severity**: Critical
  - **Location**: [`lib/src/graph/traverse/random.dart`](lib/src/graph/traverse/random.dart#L82-L120)
  - **Problem**: In `_candidatesAndProbabilities` (line 105), `if (iterable.selfAvoiding && seen.add(target) == false) continue;` marks every candidate neighbor of `source` as visited while enumerating candidates rather than marking only the selected `next` vertex. All unchosen neighbors of `source` are permanently blocked from ever being visited later in the walk, and parallel edges to the same target are dropped prematurely. Additionally, in `moveNext()` (lines 88–96), if floating-point division `tuple.second / probabilitySum` causes the cumulative sum to be slightly `< 1.0` (e.g. `0.9999999999999999`) while `random.nextDouble()` returns `0.99999999999999995`, no branch satisfies `sum >= value` and `next` remains equal to `current`, causing an infinite self-loop.
  - **Fix**: Check `if (iterable.selfAvoiding && seen.contains(target)) continue;` in `_candidatesAndProbabilities`, and call `seen.add(next)` in `moveNext()` only after `next` is chosen. Initialize `next = candidates.last.first` before the cumulative probability loop so floating-point rounding never leaves `next == current`.

- [x] **`MutableStringList` and `MutableUnicodeStringList` crash with `TypeError` on `insert`, `insertAll`, and growing `length`**
  - **Severity**: Critical
  - **Location**: [`lib/src/collection/string/string_list.dart`](lib/src/collection/string/string_list.dart#L79-L173)
  - **Problem**: Both classes extend `ListBase<String>`, store non-nullable `final List<int> codeUnits` / `final List<int> runes`, and implement `set length(int newLength) => codeUnits.length = newLength;`. Increasing `.length` on a non-nullable `List<int>` throws `TypeError: null: type 'Null' is not a subtype of type 'int'`. Because `ListBase.insert` and `ListBase.insertAll` grow the list via `length++` / `length += ...`, calling `result.insertAll(6, 'brave '.toList())` (the example in the doc comment at line 94) or `result.insert(0, 'a')` crashes at runtime with `TypeError`. Additionally, `MutableStringList.add` (`codeUnits.addAll(element.codeUnits)`) silently accepts multi-character or empty strings while `operator []=` throws `ArgumentError` unless `character.length == 1`.
  - **Fix**: Validate `element.length == 1` in `MutableStringList.add`, override `insert`, `insertAll`, `removeAt`, `removeRange`, and `clear` to delegate directly to `codeUnits` / `runes`, and pad with `0` when growing `length`.

- [x] **`PresentOptional` and `AbsentOptional` violate `==` symmetry and `hashCode` contract under generic covariance**
  - **Severity**: Critical
  - **Location**: [`lib/src/functional/optional.dart`](lib/src/functional/optional.dart#L134-L139), [`lib/src/functional/optional.dart`](lib/src/functional/optional.dart#L190-L195)
  - **Problem**: `PresentOptional<T>.operator ==` checks `other is PresentOptional<T> && value == other.value`, and `AbsentOptional<T>.operator ==` checks `other is AbsentOptional<T>` with `int get hashCode => T.hashCode;`. Because Dart generics are covariant, `const Optional<num>.of(1) == const Optional<int>.of(1)` is `true`, whereas `const Optional<int>.of(1) == const Optional<num>.of(1)` is `false` (violating symmetry). Similarly, `const Optional<num>.absent() == const Optional<int>.absent()` is `true`, while `const Optional<int>.absent() == const Optional<num>.absent()` is `false`, and their `hashCode` values differ (`num.hashCode != int.hashCode`).
  - **Fix**: Check `other is PresentOptional && value == other.value` (with `Object.hash(PresentOptional, value)`) and `other is AbsentOptional` (with a constant `hashCode`, matching `LeftEither` and `RightEither` in [`lib/src/functional/either.dart`](lib/src/functional/either.dart#L173-L178)).

- [x] **`Fraction.fromDouble` ignores `maxDenominator` for values in `(-1, 1)` and crashes on subnormal doubles**
  - **Severity**: Critical
  - **Location**: [`lib/src/number/fraction.dart`](lib/src/number/fraction.dart#L36-L73)
  - **Problem**: Line 67 checks `if (maxDenominator < denominator1) { return numerator2 == 0 ? Fraction(sign * numerator1, denominator1) : Fraction(sign * numerator2, denominator2); }`. For any `value` with `0 < |value| < 1`, the initial convergent is `0/1` (`numerator1 = 0, denominator1 = 1`). On the first iteration, `numerator2` becomes `0` and `denominator2` becomes `1`. Because line 67 checks `numerator2 == 0` instead of `denominator2 == 0`, it returns `Fraction(sign * numerator1, denominator1)` whose `denominator1` exceeds `maxDenominator` (e.g. `Fraction.fromDouble(0.001, maxDenominator: 100)` returns `Fraction(1, 1000)` with denominator `1000 > 100`). Additionally, for subnormal values such as `double.minPositive` (`5e-324`), `1.0 / fractionPart` overflows to `double.infinity`, and `newValue.floor()` throws `UnsupportedError: Infinity or NaN toInt`.
  - **Fix**: Check `denominator2 == 0` on line 68 (and validate `maxDenominator >= 1` upfront), and break out of the loop when `!newValue.isFinite`.

- [x] **`DoubleRange` miscalculates `length` for small ranges (`< 1e-16`) and reversed bounds in release mode**
  - **Severity**: Critical
  - **Location**: [`lib/src/collection/range/double.dart`](lib/src/collection/range/double.dart#L39-L77)
  - **Problem**: `_of1` does not check that `end - start` and `step` have the same sign (relying only on `assert` in `DoubleRange._`), so in release builds `DoubleRange(5, 2, 1)` produces `length == 3` (`[5.0, 6.0, 7.0]`) instead of an empty range `[]` like `IntegerRange` and `BigIntRange`. Furthermore, `_of3` uses an unscaled absolute `_epsilon = 1e-16` in `mod < _epsilon || stepAbs - mod < _epsilon`: for `DoubleRange(0.0, 1e-17, 1.0)`, `div = 0` and `mod = 1e-17 < 1e-16`, so `length` is computed as `0` (empty) instead of `1` (`[0.0]`).
  - **Fix**: Return `length = 0` when `(start < end && step < 0) || (start > end && step > 0) || start == end`, scale `_epsilon` relative to `stepAbs`, and only round `div` up when `stepAbs - mod < eps` (not when `mod < eps` and `div == 0`).

- [x] **`Fraction.pow` returns `Fraction.infinity` for `Fraction.nan.pow(-1)`**
  - **Severity**: Warning
  - **Location**: [`lib/src/number/fraction.dart`](lib/src/number/fraction.dart#L204-L216)
  - **Problem**: For `Fraction.nan` (`a == 0 && b == 0`), `if (a == 0) return n < 0 ? infinity : this;` returns `Fraction.infinity` when `n < 0` instead of `Fraction.nan`.
  - **Fix**: Check `if (isNaN) return nan;` before `if (a == 0)`.

- [x] **`Quaternion.fromVectors` returns `Quaternion.nan` for anti-parallel (opposite) vectors**
  - **Severity**: Warning
  - **Location**: [`lib/src/number/quaternion.dart`](lib/src/number/quaternion.dart#L39-L51)
  - **Problem**: When `source` and `target` point in opposite directions ($180^\circ$ rotation, e.g. `[1, 0, 0]` and `[-1, 0, 0]`), the dot product `w` is `-||source|| * ||target||` and the cross product `(x, y, z)` is `(0, 0, 0)`. Then `w + sqrt(w * w + x * x + y * y + z * z)` is `0`, producing `Quaternion(0, 0, 0, 0).normalize()` which divides by `0` and returns `Quaternion.nan`.
  - **Fix**: Detect when `w + norm == 0` (anti-parallel vectors) and return a $180^\circ$ rotation (`w = 0`) around a unit vector orthogonal to `source`.

- [x] **`parseWithUnits` accepts bare `'*i'`, `'+*i'`, `'-*i'` and merges whitespace inside exponents**
  - **Severity**: Warning
  - **Location**: [`lib/src/number/utils.dart`](lib/src/number/utils.dart#L11-L51)
  - **Problem**: In `numberAndUnitExtractor = RegExp(r'([+-]?\d*(\.\d+)?(e[+-]?\d+)?)\*?(\w?)', caseSensitive: false)`, `\*?` matches even when `numberString` has no digits (`''`, `'+'`, `'-'`), so `Complex.tryParse('*i')` and `Complex.tryParse('1+*i')` parse as `i` and `1 + i`. Also, `RegExp(r'(\d|\.)\s+(\d|\.)')` does not reject whitespace adjacent to `e`/`E` or its sign (e.g. `'1 e 5'` or `'1e + 5'`), which `source.replaceAll(RegExp(r'\s+'), '')` silently merges into `'1e5'`.
  - **Fix**: Require digits before `*` and disallow whitespace inside scientific notation exponents (`RegExp(r'(\d|\.|e)\s+[+-]?(\d|\.|e)', caseSensitive: false)`).

- [x] **`PrefixSuffixStringExtension.removeSuffix` fails on greedy/multi-character `RegExp` patterns**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/string/prefix_suffix.dart`](lib/src/collection/string/prefix_suffix.dart#L17-L27)
  - **Problem**: `removeSuffix` uses `final end = lastIndexOf(pattern);`, which searches backward from the end of the string and stops at the shortest suffix match. For `'hello123'.removeSuffix(RegExp(r'\d+'))`, `lastIndexOf` matches `'3'` at index 7 instead of `'123'` at index 5, returning `'hello12'` instead of `'hello'`. Additionally, for patterns that can match empty strings (e.g. `RegExp(r'x*')`), `removePrefix` guards `match.end > 0` while `removeSuffix` lacks a guard.
  - **Fix**: Fast-path `pattern is String` with `endsWith(pattern)`, and for general `Pattern` find the first match in `pattern.allMatches(this)` where `match.end == length && match.start < length`.

- [x] **`WrapUnwrapStringExtension.wrap` prematurely flushes the trailing remainder of broken long words**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/string/wrap_unwrap.dart`](lib/src/collection/string/wrap_unwrap.dart#L27-L34)
  - **Problem**: When `breakLongWords: true` and `word.length > width`, the loop `for (var j = 0; j < word.length; j += width) { result.add(...); }` flushes all chunks—including a short trailing remainder `< width`—directly to `result` as a completed line instead of placing the last partial chunk into `buffer`. Consequently, `'abcdefg x'.wrap(5)` produces 3 lines (`'abcde\nfg\nx'`) instead of 2 (`'abcde\nfg x'`).
  - **Fix**: Push full `width` chunks to `result` and place the trailing remainder (when `< width`) into `buffer` so subsequent words on the same line can be appended.

- [x] **`OrdinalNumberPrinter` outputs wrong suffixes for negative numbers**
  - **Severity**: Warning
  - **Location**: [`lib/src/printer/number/ordinal.dart`](lib/src/printer/number/ordinal.dart#L53-L66)
  - **Problem**: `printOn` computes `if (!(object % 100).between(10, 20))` and `switch (object % 10)` on the signed `object`. Because Dart's `%` operator returns a non-negative remainder in `[0, divisor)`, for `object = -1`, `-1 % 10 == 9`, printing `'-1th'` instead of `'-1st'`; for `object = -89`, `-89 % 100 == 11`, printing `'-89th'` instead of `'-89th'` while `-91 % 10 == 9` prints `'-91th'` instead of `'-91st'`.
  - **Fix**: Compute `final absObject = object.abs();` and use `absObject % 100` and `absObject % 10`.

- [x] **`FixedNumberPrinter` loses precision on 64-bit integers and can overflow fractional digits on rounding**
  - **Severity**: Warning
  - **Location**: [`lib/src/printer/number/fixed.dart`](lib/src/printer/number/fixed.dart#L110-L132)
  - **Problem**: `_printNumOn` unconditionally converts `value` to `double` via `final rounded = (value / rounding).roundToDouble() * rounding;`, losing precision for 64-bit `int` values `> 2^53` even when `precision == 0 && accuracy == null`. In addition, `_printIntegerOn` prints `rounded.abs().truncate()` while `_printFractionOn` independently rounds `(fractional * multiplier).round()`; if floating-point representation or custom `accuracy` causes `(fractional * multiplier).round() == multiplier`, `_printFractionOn` prints an extra digit (e.g. `100` for `precision: 2`) without carrying into the integer part.
  - **Fix**: When `value is int && accuracy == null`, format the integer part directly using `int` arithmetic without converting to `double`; for floating-point values, carry into the integer part whenever the rounded fractional part equals `multiplier`.

- [x] **`HumanNumberPrinter` and `ScientificNumberPrinter` produce unscaled `1000` / `10.0` mantissas on rounding boundaries**
  - **Severity**: Warning
  - **Location**: [`lib/src/printer/number/human.dart`](lib/src/printer/number/human.dart#L207-L236), [`lib/src/printer/number/scientific.dart`](lib/src/printer/number/scientific.dart#L103-L122)
  - **Problem**: Both printers compute `exponent` from `value.abs().log() / base.log()` before rounding `mantissa` to `precision`. For `999.9` with `precision: 0`, `HumanNumberPrinter.decimal()` selects `exponent = 0` and prints `'1000'` instead of `'1 k'`; `ScientificNumberPrinter(precision: 1)` on `9.99` prints `'10.0e0'` instead of `'1.0e1'`. Furthermore, `1000.0.log() / 10.0.log()` evaluates to `2.9999999999999996` in IEEE 754 float arithmetic, so `.floor()` yields `2` instead of `3`.
  - **Fix**: Increment `exponent` and rescale `mantissa` if rounding causes the mantissa to reach the next power of `base` / `unitBase`.

- [x] **`SeparateRightPrinter` and `SeparateLeftPrinter` do not validate `width` and `offset`**
  - **Severity**: Warning
  - **Location**: [`lib/src/printer/string/separate.dart`](lib/src/printer/string/separate.dart#L7-L69)
  - **Problem**: Neither `separateLeft` nor `separateRight` validates `width > 0` or `0 <= offset < width`. If `width <= 0`, `% width` throws `IntegerDivisionByZeroException` or `RangeError`; if `offset >= width`, `i % width == offset` is never satisfied.
  - **Fix**: Validate `checkNonZeroPositive(width, 'width')` and `RangeError.checkValidIndex(offset, List.filled(width, null), 'offset')` (or `0 <= offset && offset < width`) in `SeparateLeftPrinter` and `SeparateRightPrinter`.

- [x] **`DateTimePrinterBuilder.year(width: 2)` strips the sign on negative years**
  - **Severity**: Warning
  - **Location**: [`lib/src/printer/temporal/date_time.dart`](lib/src/printer/temporal/date_time.dart#L128-L132)
  - **Problem**: `year({int width = 0})` configures `FixedNumberPrinter<int>(padding: width).mapIf(width == 2, (printer) => printer.takeLast(2))`. For `year = -5` and `width = 2`, `FixedNumberPrinter(padding: 2)` produces `'-05'` and `.takeLast(2)` strips the leading minus sign, outputting `'05'`.
  - **Fix**: Apply modulo `year.abs() % 100` (preserving sign if desired) or only truncate positive 4-digit years.

- [x] **`BitList.filled` and `OrderedList.filled` do not validate negative `length` before buffer allocation**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/bitlist.dart`](lib/src/collection/bitlist.dart#L23-L32), [`lib/src/collection/ordered_list.dart`](lib/src/collection/ordered_list.dart#L43-L48)
  - **Problem**: `BitList(-1)` computes `(-1 + 31) >>> 5 == 0` and constructs a corrupted `BitList` with `length == -1`; `BitList(-33)` computes `(-2) >>> 5 == 576460752303423487` and crashes attempting to allocate an exabyte `Uint32List`. `OrderedList.filled(-1, 0)` runs `_computeCapacity(length)` in the initializer list before `RangeError.checkNotNegative(length, 'length')` executes in the constructor body.
  - **Fix**: Call `RangeError.checkNotNegative(length, 'length')` before computing buffer sizes in `BitList.filled` and `OrderedList._computeCapacity`.

- [x] **`SortedList.contains` and `SortedList.remove` are inconsistent with `indexOf` for custom comparators**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/sorted_list.dart`](lib/src/collection/sorted_list.dart#L38-L51), [`lib/src/collection/sorted_list.dart`](lib/src/collection/sorted_list.dart#L96-L103)
  - **Problem**: `indexOf` and `lastIndexOf` use `binarySearchLower`/`Upper` and scan elements with `_comparator(this[i], element) == 0` to find one where `this[i] == element`. In contrast, `contains` and `remove` use `_comparator.binarySearch(this, element)`, which matches any element with `_comparator(x, element) == 0` even if `x != element`. Thus `remove(b)` can delete a distinct object `a` that happens to share the same sort key, and `contains(b)` can return `true` when `indexOf(b) == -1`.
  - **Fix**: Implement `contains(Object? element) => indexOf(element) >= 0;` and in `remove(Object? element)` look up the index via `indexOf(element)`.

- [x] **`Multimap` ignores initial entries in a user-supplied `map` and throws `ConcurrentModificationError` on self-aliasing `addAll`/`removeAll`**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/multimap.dart`](lib/src/collection/multimap.dart#L11-L18), [`lib/src/collection/multimap.dart`](lib/src/collection/multimap.dart#L75-L85)
  - **Problem**: `ListMultimap(map: ...)` and `SetMultimap(map: ...)` accept an existing `Map<K, C>`, but `Multimap._length` is initialized to `0` instead of summing existing collection lengths in `_map`. Additionally, `multimap.addAll(key, multimap[key])` and `multimap.removeAll(key, multimap[key])` iterate the live `MultimapValues` view while mutating `delegate`, throwing `ConcurrentModificationError`.
  - **Fix**: Initialize `_length = _map.values.fold(0, (sum, v) => sum + v.length)` in `Multimap`, and snapshot `values.toList(growable: false)` in `polymorphicAddAll` / `polymorphicRemoveAll` when `values` aliases the same underlying collection.

- [x] **`TypeMap.getInstance` overwrites stored `null` when `T` is nullable**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/typemap.dart`](lib/src/collection/typemap.dart#L20-L31)
  - **Problem**: `getInstance` checks `if (value == null)` instead of `if (!_map.containsKey(V))`, so if `T` is `Object?` and `null` was explicitly registered via `setInstance<int?>(null)`, calling `getInstance<int?>(ifAbsentPut: ...)` treats it as absent and overwrites it.
  - **Fix**: Check `if (!_map.containsKey(V))` before invoking `ifAbsent` / `ifAbsentPut`.

- [x] **`RTree` `entryWithLeastAreaEnlargement` tie-breaker is inverted and `Bounds.fromPoint` aliases `min` and `max` buffers**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/rtree/utils.dart`](lib/src/collection/rtree/utils.dart#L26-L31), [`lib/src/collection/rtree/bounds.dart`](lib/src/collection/rtree/bounds.dart#L15-L18)
  - **Problem**: In `entryWithLeastAreaEnlargement` ([`lib/src/collection/rtree/utils.dart`](lib/src/collection/rtree/utils.dart#L28)), the comment states "choose the entry having the smallest area as a tie-breaker", but the condition `enlargement == minEnlargement && minArea < beforeArea` selects the **largest** area instead of the smallest (`beforeArea < minArea`). In `Bounds.fromPoint` ([`lib/src/collection/rtree/bounds.dart`](lib/src/collection/rtree/bounds.dart#L15-L18)), `min` and `max` share the same `Float64List` instance (`shared`), and `Bounds` operations (`contains`, `union`, `intersects`, `intersection`) never check that both `Bounds` have matching dimensions (`length`), nor does `Bounds.fromLists` assert `min[i] <= max[i]`.
  - **Fix**: Change `minArea < beforeArea` to `beforeArea < minArea`, allocate separate buffers (or wrap in `UnmodifiableFloat64ListView`), and assert matching dimensions and `min[i] <= max[i]`.

- [x] **`RepeatIterableExtension.repeat` skips negative `count` validation when empty and eagerly evaluates `length`**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/iterable/repeat_iterable.dart`](lib/src/collection/iterable/repeat_iterable.dart#L12-L47)
  - **Problem**: `<int>[].repeat(count: -1)` returns `const []` without throwing `RangeError` because `if (count == 0 || isEmpty)` runs before `RangeError.checkNotNegative(count, 'count')`. Furthermore, `RepeatIterableIterable<E>(this).take(count * length)` eagerly evaluates `this.length` (iterating lazy iterables upfront) instead of passing `count` to `RepeatIterableIterable` and counting repetitions lazily.
  - **Fix**: Validate `if (count != null) RangeError.checkNotNegative(count, 'count');` first, and pass `count` into `RepeatIterableIterable` to bound cycle count lazily in `RepeatIterableIterator`.

- [x] **`TakeSkipStringExtension`, `TakeSkipListExtension`, and `TakeSkipPrinterExtension` do not validate negative `count`**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/string/take_skip.dart`](lib/src/collection/string/take_skip.dart#L7-L51), [`lib/src/collection/list/take_skip.dart`](lib/src/collection/list/take_skip.dart#L7-L28), [`lib/src/printer/string/take_skip.dart`](lib/src/printer/string/take_skip.dart#L7-L76)
  - **Problem**: `'abc'.takeLast(-1)`, `'abc'.skipLast(-1)`, `[1, 2, 3].takeLast(-1)`, and `[1, 2, 3].skipLast(-1)` compute `length - (-1) == length + 1` and throw an internal `RangeError` from `substring`/`getRange` with a confusing end index, while `TakePrinter(-1)` / `SkipPrinter(-1)` pass negative counts down to `take`/`skip`.
  - **Fix**: Call `RangeError.checkNotNegative(count, 'count')` in `take`, `takeLast`, `skip`, and `skipLast`.

- [x] **`Stream.buffer` breaks on broadcast stream re-listen and does not validate `maxLength` / `maxAge`**
  - **Severity**: Warning
  - **Location**: [`lib/src/async/buffer.dart`](lib/src/async/buffer.dart#L14-L127)
  - **Problem**: `controller.onCancel` cancels `maxAgeTimer` without setting `maxAgeTimer = null`, so if the source is a broadcast stream and is re-listened, `maxAgeTimer == null` is `false` and `maxAge` never triggers again. Additionally, `maxLength` and `maxAge` are not validated to be positive (unlike `Stream.window`, which calls `checkNonZeroPositive`).
  - **Fix**: Set `maxAgeTimer = null` in `onCancel` and validate `maxLength` and `maxAge` with `checkNonZeroPositive`.

- [x] **`ExpiryCache` and `LruCache` only validate parameters via `assert` and permanently cache failed `Future`s**
  - **Severity**: Warning
  - **Location**: [`lib/src/cache/expiry.dart`](lib/src/cache/expiry.dart#L16-L57), [`lib/src/cache/lru.dart`](lib/src/cache/lru.dart#L14-L37)
  - **Problem**: In release builds, `Cache.lru(loader: ..., maximumSize: 0)` and `Cache.expiry(loader: ...)` (with both durations `null` or negative) do not throw `ArgumentError`. Additionally, when `loader(key)` returns a `Future` that completes with an error, `ExpiryCache.get` and `LruCache.get` retain the failed `CacheItem` in `cached[key]`, causing subsequent `get(key)` calls to rethrow the cached failure instead of evicting the entry on error.
  - **Fix**: Replace constructor `assert`s with runtime `ArgumentError` / `RangeError` checks, and evict the `CacheItem` if its load future fails.

- [x] **`Interval` only validates `lower.compareTo(upper) <= 0` via `assert` and `isSingle` uses `==` instead of `compareTo`**
  - **Severity**: Warning
  - **Location**: [`lib/src/interval/interval.dart`](lib/src/interval/interval.dart#L9-L23)
  - **Problem**: In release builds, `Interval(10, 5)` succeeds without throwing `ArgumentError`. Also, `isSingle` checks `lower == upper` while all other methods use `compareTo`, so `Interval(-0.0, 0.0)` has `lower.compareTo(upper) == -1` yet `isSingle == true`.
  - **Fix**: Throw `ArgumentError.value(upper, 'upper', 'Must be >= $lower')` if `lower.compareTo(upper) > 0`, and implement `bool get isSingle => lower.compareTo(upper) == 0;`.

- [x] **`AccessorsDateTimeExtension.weeksInYear` uses truncating division `~/` on negative years**
  - **Severity**: Warning
  - **Location**: [`lib/src/temporal/date_time/accessors.dart`](lib/src/temporal/date_time/accessors.dart#L15-L18)
  - **Problem**: `int offset(int y) => (y + y ~/ 4 - y ~/ 100 + y ~/ 400) % 7;` is called with `year - 1`, which for `year <= 0` uses truncating division toward zero instead of floor division, yielding wrong ISO week counts for BCE years.
  - **Fix**: Use floor division (`(y / 4).floor()`, `(y / 100).floor()`, `(y / 400).floor()`).

- [x] **`DateTime.periodical` drifts on month-end and leap-day dates**
  - **Severity**: Warning
  - **Location**: [`lib/src/temporal/date_time/periodical.dart`](lib/src/temporal/date_time/periodical.dart#L86-L127)
  - **Problem**: `periodical(TimeUnit.month)` chains `iterate(this, (prev) => create(prev.year, prev.month + step, prev.day, ...))`. Starting at `DateTime(2024, 1, 31)`, step 1 overflows Feb 31 to `2024-03-02`, and all subsequent months stay on the 2nd (`2024-04-02`, `2024-05-02`, ...) instead of advancing by `i * step` from the initial date.
  - **Fix**: Compute the $n$-th element from the initial `DateTime` (`create(year, month + n * step, day, ...)`) or document/clamp month-end overflow.

- [x] **`Duration.convertToAll` converts `inMicroseconds` to `double`, losing precision for large durations**
  - **Severity**: Warning
  - **Location**: [`lib/src/temporal/duration/convert_all.dart`](lib/src/temporal/duration/convert_all.dart#L20-L34)
  - **Problem**: `var remainder = inMicroseconds.toDouble();` loses precision when `inMicroseconds.abs() > 2^53` (~285 years, e.g. `TimeUnit.millennium`), dropping low-order microseconds even when using integer `casualConversion`.
  - **Fix**: Keep `remainder` as `int` when `conversion` values are `int` (or use `~/ unit` and `% unit` before falling back to `double`).

- [x] **`IntegerSet.contains` and `IntegerSet.remove` do not guard against negative indices and `lookup` throws `UnimplementedError`**
  - **Severity**: Warning
  - **Location**: [`lib/src/graph/strategy/integer_set.dart`](lib/src/graph/strategy/integer_set.dart#L31-L60)
  - **Problem**: `IntegerMap` checks `0 <= index && index < _presence.length`, whereas `IntegerSet.contains` and `IntegerSet.remove` only check `index < _presence.length && _presence.getUnchecked(index)`. With `StorageStrategy.positiveInteger()`, calling `set.contains(-1)` in release mode passes `-1` to `_presence.getUnchecked(-1)`, which computes `-1 >>> 5 == 576460752303423487` and throws `RangeError` instead of returning `false`. Furthermore, `IntegerSet.lookup` (line 49) throws `UnimplementedError`.
  - **Fix**: Check `0 <= index && index < _presence.length` in `IntegerSet.contains` and `IntegerSet.remove`, and implement `lookup(Object? element) => contains(element) ? element as int : null;`.

- [x] **`primSpanningTree` throws `StateError` on empty graphs and ignores `vertexStrategy`**
  - **Severity**: Warning
  - **Location**: [`lib/src/graph/algorithms/prim_spanning_tree.dart`](lib/src/graph/algorithms/prim_spanning_tree.dart#L17-L43)
  - **Problem**: Line 35 calls `addOutgoingEdgesToQueue(startVertex ?? graph.vertices.first)`, which throws `StateError: No element` when `graph` is empty (whereas `kruskalSpanningTree` returns an empty graph). Furthermore, `vertexStrategy` is accepted as a parameter on line 17 but never used.
  - **Fix**: Return `result` immediately when `startVertex == null && graph.vertices.isEmpty` (or when `startVertex != null && !graph.vertices.contains(startVertex)`), and pass `vertexStrategy` to `Graph.from` or use `vertexStrategy.createSet()` to track visited vertices.

- [x] **`LogicalGraphExtension.intersection` processes undirected edges twice**
  - **Severity**: Warning
  - **Location**: [`lib/src/graph/operations/logical.dart`](lib/src/graph/operations/logical.dart#L67-L82)
  - **Problem**: Unlike `unionAll` (which tracks `seen` for undirected graphs so `edgeMerge` is only called once per undirected edge), `intersection` iterates over `edges` (which yields both `(u, v)` and `(v, u)` in `UndirectedGraph`), invoking `edgeCompare` and `edgeMerge` twice for every undirected edge and overwriting `(u, v)` with the reverse call `(v, u)`.
  - **Fix**: Deduplicate undirected edges in `intersection` using a `seen` set of `Edge<V, void>.undirected`, matching `unionAll` (lines 29–39).

- [x] **Assert-only parameter validation across public APIs fails silently or loops infinitely in release mode**
  - **Severity**: Warning
  - **Location**: [`lib/src/graph/path.dart`](lib/src/graph/path.dart#L25-L34), [`lib/src/graph/factory/tree.dart`](lib/src/graph/factory/tree.dart#L17-L37), [`lib/src/collection/range/integer.dart`](lib/src/collection/range/integer.dart#L55-L139), [`lib/src/collection/range/bigint.dart`](lib/src/collection/range/bigint.dart#L56-L78), [`lib/src/collection/range/double.dart`](lib/src/collection/range/double.dart#L64-L85), [`lib/src/char_matcher/basic/range.dart`](lib/src/char_matcher/basic/range.dart#L7)
  - **Problem**: Several constructors rely exclusively on `assert(...)` for public argument validation:
    - `Path.fromVertices([])` in release mode creates a `Path` with `values` of length `-1`.
    - `completeTree(vertexCount: 5, arity: 0)` in release mode enters an infinite loop (`for (var child = 1; child < vertexCount;)` never increments `child`), and `perfectTree(height: 2, arity: 1)` divides by zero (`(pow(1, 3) - 1) ~/ (1 - 1)`).
    - `IntegerRange.length(-1)`, `BigIntRange.length(-1)`, `DoubleRange.length(-1)`, and `Iterable.indices(step: 0)` do not throw `RangeError` / `ArgumentError` in release builds.
    - `CharMatcher.inRange('z', 'a')` does not throw `ArgumentError` in release builds.
  - **Fix**: Replace public constructor/factory `assert`s with `RangeError` / `ArgumentError` checks (keeping `const` constructor `assert`s where `const` is required, and validating in factory constructors).

---

## 2. Performance Issues

- [x] **`ReadableDiffer._replace` sets `matcher.target = targetStr.runes` inside the inner loop**
  - **Severity**: Warning
  - **Location**: [`lib/src/diff/differ/readable.dart`](lib/src/diff/differ/readable.dart#L109-L132)
  - **Problem**: `targetStr` depends only on the outer loop index `t`, but `matcher.target = targetStr.runes` is executed on line 120 inside the inner `for (var s = ...)` loop, recomputing `_target`, `_targetIndices`, `_targetJunk`, and `_targetPopular` $O(S \times T)$ times instead of $O(T)$ times.
  - **Fix**: Move `matcher.target = targetStr.runes;` out of the inner `s` loop to immediately after `final targetStr = target[t];`.

- [x] **`IntervalTree` evaluates `getter` $O(n \log^2 n)$ times during construction, copies node lists during iteration, and has $O(n)$ `length`**
  - **Severity**: Warning
  - **Location**: [`lib/src/interval/tree.dart`](lib/src/interval/tree.dart#L96-L163)
  - **Problem**: `_IntervalTreeNode.fromValues` calls `getter(value)` in the endpoint loop, again in the partition loop, and $O(k \log k)$ times inside `leftValues.sort` and `rightValues.sort` at every recursion level. Additionally, `_IntervalTreeIterator` copies `node._leftValues` via `_values.addAll(node._leftValues)` on every node visit, and `IntervalTree` inherits `IterableBase.length` ($O(n)$ full traversal) instead of tracking the element count.
  - **Fix**: Pair each element with its `Interval<K>` once before constructing the tree, store `int _length` on `IntervalTree`, and iterate `node._leftValues` by index in `_IntervalTreeIterator`.

- [x] **`BiMap.fromIterable`, `toBiMap`, `toListMultimap`, and `toSetMultimap` iterate the input `Iterable` twice**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/bimap.dart`](lib/src/collection/bimap.dart#L31-L39), [`lib/src/collection/bimap.dart`](lib/src/collection/bimap.dart#L160-L165), [`lib/src/collection/multimap/list.dart`](lib/src/collection/multimap/list.dart#L136-L150), [`lib/src/collection/multimap/set.dart`](lib/src/collection/multimap/set.dart#L130-L144)
  - **Problem**: All four methods call `fromIterables(map(keyProvider), map(valueProvider))`, iterating the source `Iterable` twice and failing or duplicating side effects on single-subscription/stateful iterables.
  - **Fix**: Populate the collection in a single loop over `iterable` in `BiMap.fromIterable`, and delegate `toBiMap`, `toListMultimap`, and `toSetMultimap` to `fromIterable`.

- [x] **`MinMaxComparator.minOf` and `maxOf` iterate twice when `orElse != null`**
  - **Severity**: Warning
  - **Location**: [`lib/src/comparator/operations/min_max.dart`](lib/src/comparator/operations/min_max.dart#L7-L16)
  - **Problem**: `orElse != null && iterable.isEmpty ? orElse() : iterable.reduce(min)` checks `iterable.isEmpty` and then calls `iterable.reduce(min)`, creating two iterators over `iterable`.
  - **Fix**: Use a single `iterator` pass (matching `minMaxOf` on lines 22–34).

- [x] **`LargestComparator.largest` does not short-circuit when `k <= 0`**
  - **Severity**: Warning
  - **Location**: [`lib/src/comparator/operations/largest.dart`](lib/src/comparator/operations/largest.dart#L9-L24)
  - **Problem**: When `k == 0`, `largest` still inserts and removes every element of `iterable` in a `PriorityQueue` before returning `[]`; when `k < 0`, it consumes the entire `iterable` before `List.generate` throws `RangeError`.
  - **Fix**: Call `RangeError.checkNotNegative(k, 'k')` and return `<T>[]` immediately when `k == 0`.

- [x] **`Multiset.containsAll` iterates `other` up to 3 times**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/multiset.dart`](lib/src/collection/multiset.dart#L132-L147)
  - **Problem**: Calls `other.isEmpty`, then `other.length == 1` (which is $O(n)$ on lazy iterables), and then `other.first` or `Multiset.of(other)`.
  - **Fix**: Check `if (other is Multiset<Object?>)` first; otherwise inspect `other.iterator` in a single pass.

- [x] **`OrderedList.insertAll` is $O(n \times m)$**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/ordered_list.dart`](lib/src/collection/ordered_list.dart#L175-L182)
  - **Problem**: Calls `insert(index++, element)` in a loop, shifting existing elements one by one for each inserted element instead of shifting once by the number of inserted elements.
  - **Fix**: Convert `iterable` to a list (or determine its length), grow capacity once, shift the affected segment once by `count`, and copy the new elements into place.

- [x] **`ProductIterableExtension.product` and `RandomIterableExtension.atRandom` iterate multiple times**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/iterable/product.dart`](lib/src/collection/iterable/product.dart#L21-L32), [`lib/src/collection/iterable/random.dart`](lib/src/collection/iterable/random.dart#L10-L19)
  - **Problem**: `product` calls `any((e) => e.isEmpty)` and then `map((e) => e.toList(growable: false)).toList(growable: false)`, iterating the outer and inner iterables twice. `atRandom` calls `isEmpty`, then `length`, then `elementAt`, iterating non-`List` iterables up to 3 times.
  - **Fix**: Materialize the inner lists first in `product` and check `isEmpty` on the materialized lists; in `atRandom`, fast-path `List<E>` and use single-pass reservoir sampling (or `toList(growable: false)`) for general `Iterable<E>`.

- [x] **`GroupIterableExtension.groupBy` evaluates `grouper(iterator.current)` twice at every group boundary**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/collection/iterable/group.dart`](lib/src/collection/iterable/group.dart#L31-L36)
  - **Problem**: When `key != nextKey`, `moveNext()` exits the `while` loop without storing `nextKey`, so the subsequent call to `moveNext()` calls `grouper(iterator.current)` a second time on the boundary element.
  - **Fix**: Cache `nextKey` on `_GroupByIterator` for the next group.

- [x] **`EulerPrimeSieve._factors` is statically typed as `List<int>` instead of `Uint32List`**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/math/primes/euler.dart`](lib/src/math/primes/euler.dart#L37)
  - **Problem**: `_factors` is initialized to `Uint32List(max + 1)` on line 18, but its field type on line 37 is `final List<int> _factors;`, preventing typed-data specialization in the inner sieve loop.
  - **Fix**: Change the field declaration to `final Uint32List _factors;`.

---

## 3. Code Style and Readability

- [x] **`Either.value` and `Tuple0`..`Tuple9` (`iterable`, `toList`, `toSet`) use `dynamic` instead of `Object?`**
  - **Severity**: Warning
  - **Location**: [`lib/src/functional/either.dart`](lib/src/functional/either.dart#L48), [`lib/src/tuple/tuple_0.dart`](lib/src/tuple/tuple_0.dart#L29-L35), [`bin/generate_tuple.dart`](lib/src/tuple/tuple.dart)
  - **Problem**: Violates `AGENTS.md` ("Embrace strict null safety. Avoid using the non-null assertion operator (`!`) or `dynamic` types, if possible"). `Either.value` returns `dynamic`, and `Tuple.iterable`, `Tuple.toList`, and `Tuple.toSet` return `Iterable<dynamic>`, `List<dynamic>`, and `Set<dynamic>`.
  - **Fix**: Change `dynamic` to `Object?` in [`lib/src/functional/either.dart`](lib/src/functional/either.dart#L48) and [`bin/generate_tuple.dart`](bin/generate_tuple.dart#L373-L379), and regenerate the tuple files.

- [x] **Unused generic type parameter `<T>` on `IndentDedentStringExtension<T>`**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/collection/string/indent_dedent.dart`](lib/src/collection/string/indent_dedent.dart#L2)
  - **Problem**: `extension IndentDedentStringExtension<T> on String` declares an unused type parameter `<T>`.
  - **Fix**: Remove `<T>` from `IndentDedentStringExtension`.

- [x] **Legacy Dart 1 `/*<E>*/` comments in `fromIterable` factory constructors**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/collection/bimap.dart`](lib/src/collection/bimap.dart#L31-L34), [`lib/src/collection/multiset.dart`](lib/src/collection/multiset.dart#L25-L28), [`lib/src/collection/trie.dart`](lib/src/collection/trie.dart#L22-L27), [`lib/src/collection/multimap/list.dart`](lib/src/collection/multimap/list.dart#L25-L28), [`lib/src/collection/multimap/set.dart`](lib/src/collection/multimap/set.dart#L25-L28)
  - **Problem**: Leftover pre-generic-method `/*<E>*/` comments clutter constructor signatures.
  - **Fix**: Remove the `/*<E>*/` comments.

---

## 4. Missing or Broken Documentation

- [x] **`README.md` Graph snippet uses deprecated `Graph.directed()` constructor**
  - **Severity**: Warning
  - **Location**: [`README.md`](README.md#L66)
  - **Problem**: `final graph = Graph<String, num>.directed()` in `README.md` calls `@Deprecated('Use Graph(isDirected: true) instead.')`.
  - **Fix**: Update [`README.md`](README.md#L66) to `final graph = Graph<String, num>(isDirected: true);`.

- [x] **`Cache.expiry` doc comment contradicts implementation**
  - **Severity**: Warning
  - **Location**: [`lib/src/cache/cache.dart`](lib/src/cache/cache.dart#L54-L55)
  - **Problem**: States "The expiration time is determined by whichever duration extends further into the future", whereas `ExpiryCacheItem.isExpired` ([`lib/src/cache/expiry.dart`](lib/src/cache/expiry.dart#L140-L153)) expires when *either* deadline passes (`||`, i.e., whichever deadline is *earlier*).
  - **Fix**: Update the doc comment in [`lib/src/cache/cache.dart`](lib/src/cache/cache.dart#L54-L55) to state that when both `expireAfterAccess` and `expireAfterWrite` are provided, an entry expires as soon as either duration elapses.

- [x] **Broken or inaccurate code examples in `collection` doc comments**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/iterable/separated.dart`](lib/src/collection/iterable/separated.dart#L11-L12), [`lib/src/collection/iterable/partition.dart`](lib/src/collection/iterable/partition.dart#L8), [`lib/src/collection/string/chunked.dart`](lib/src/collection/string/chunked.dart#L27-L29), [`lib/src/collection/string/string_list.dart`](lib/src/collection/string/string_list.dart#L80-L94), [`lib/src/collection/iterable/chunked.dart`](lib/src/collection/iterable/chunked.dart#L28)
  - **Problem**:
    - `separated.dart#L11-L12`: Calls `input.separateBy(...)` instead of `input.separatedBy(...)`.
    - `partition.dart#L8`: Calls `partition([1, 2, 3, 4], ...)` as a top-level function instead of `[1, 2, 3, 4].partition(...)`.
    - `string/chunked.dart#L27-L29`: `ChunkedCharactersExtension` doc example calls `'abcde'.chunked(2)` instead of `'abcde'.characters.chunked(2)`.
    - `string_list.dart#L80,L94`: Stray trailing backtick on line 80, and `result.insertAll(6, 'brave '.toList())` on line 94 throws `TypeError` at runtime.
    - `iterable/chunked.dart#L28`: Doc comment says `expanded with the provided [padding], or null`, but `padding` is a required positional `E` parameter.
  - **Fix**: Fix each doc comment example so it compiles and produces the advertised output.

- [x] **Off-by-one parameter references and missing extension docs in generated `partial.dart` and `curry.dart`**
  - **Severity**: Warning
  - **Location**: [`lib/src/functional/types/partial.dart`](lib/src/functional/types/partial.dart#L9-L459), [`lib/src/functional/types/curry.dart`](lib/src/functional/types/curry.dart#L9-L186), [`bin/generate_types.dart`](bin/generate_types.dart#L209-L265)
  - **Problem**: In `Partial1`..`Partial10`, `bind0(T1 arg1)` documents `bound to arg0` (parameter is `arg1`), `bind1(T2 arg2)` documents `bound to arg1` (parameter is `arg2`), etc. Neither `Partial1`..`Partial10` nor `Curry1`..`Curry10` have `///` doc comments on the `extension` declarations themselves, and `Curry1` says `1 positional arguments into a sequence of 1 functions`.
  - **Fix**: Update [`bin/generate_types.dart`](bin/generate_types.dart#L209-L265) to reference `[arg${j + 1}]`, emit `///` doc comments on the extensions, and handle singular/plural grammar for `Curry1`.

- [x] **Misleading doc comments in `DurationPrinter` and `TakeSkipPrinterExtension`**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/printer/temporal/duration.dart`](lib/src/printer/temporal/duration.dart#L17-L27), [`lib/src/printer/string/take_skip.dart`](lib/src/printer/string/take_skip.dart#L15-L68)
  - **Problem**: `DurationPrinter` class doc says "For example, to print dates in the format `YYYY-MM-DD`" while formatting a `Duration` with `':'` (`// 0003:04:19`). `TakeSkipPrinterExtension.skip(int count)` says "Skips all but the first [count] characters" (it skips the first `count` characters), and `skipLast(int count)` says "Skips all but the last [count] characters" (it skips the last `count` characters).
  - **Fix**: Correct the doc comments in `duration.dart` and `take_skip.dart`.

- [x] **Missing `///` doc comments on public classes and members exported by root libraries**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/collection/rtree/bounds.dart`](lib/src/collection/rtree/bounds.dart#L5-L95), [`lib/src/collection/rtree/entry.dart`](lib/src/collection/rtree/entry.dart#L3-L19), [`lib/src/collection/rtree/node.dart`](lib/src/collection/rtree/node.dart#L7-L63), [`lib/src/collection/map/computed.dart`](lib/src/collection/map/computed.dart#L17), [`lib/src/collection/map/default.dart`](lib/src/collection/map/default.dart#L17), [`lib/src/collection/trie.dart`](lib/src/collection/trie.dart#L315-L401), [`lib/src/char_matcher/unicode/unicode.dart`](lib/src/char_matcher/unicode/unicode.dart#L16-L600)
  - **Problem**: `Bounds`, `RTreeEntry`, `RTreeNode`, `MapWithComputed`, `MapWithDefault`, `TrieNodeEntry`, `TrieNodeMap`, `TrieNodeList`, and the factory constructors of `UnicodeCharMatcher` are publicly exported but lack `///` doc comments required by `AGENTS.md`.
  - **Fix**: Add `///` doc comments to all publicly exported classes, constructors, and members (or hide internal node/entry classes in `lib/collection.dart`).

---

## 5. Simplicity and Cleanness of Public APIs

- [x] **`lib/more.dart` omits `diff.dart` and uses `package:more/` exports instead of relative exports**
  - **Severity**: Warning
  - **Location**: [`lib/more.dart`](lib/more.dart#L1-L18)
  - **Problem**: The umbrella library `lib/more.dart` exports 15 of the 16 sub-libraries but omits `diff.dart`, and uses `export 'package:more/...';` instead of relative exports (`AGENTS.md`: "Within `lib/`, prefer relative imports ... over package imports").
  - **Fix**: Add `export 'diff.dart';` to `lib/more.dart` and convert all exports in `lib/more.dart` to relative exports.

- [x] **`LeftEither`, `RightEither`, `PresentOptional`, and `AbsentOptional` are hidden by `lib/functional.dart`**
  - **Severity**: Warning
  - **Location**: [`lib/functional.dart`](lib/functional.dart#L4-L5)
  - **Problem**: `Either` and `Optional` are `sealed` classes designed for exhaustive pattern matching, but `lib/functional.dart` uses `show Either` and `show Optional`, hiding `LeftEither`, `RightEither`, `PresentOptional`, and `AbsentOptional`. Users importing `package:more/functional.dart` cannot pattern-match on the sealed subtypes (`case PresentOptional(:final value):` or `case LeftEither(:final value):`).
  - **Fix**: Export `LeftEither`, `RightEither` from `src/functional/either.dart` and `PresentOptional`, `AbsentOptional` from `src/functional/optional.dart` in `lib/functional.dart`.

- [x] **`UnicodeBlockCharMatcher` is generated in `lib/src/char_matcher/unicode/blocks.dart` but not exported from `lib/char_matcher.dart`**
  - **Severity**: Warning
  - **Location**: [`lib/char_matcher.dart`](lib/char_matcher.dart#L1-L7), [`lib/src/char_matcher/unicode/blocks.dart`](lib/src/char_matcher/unicode/blocks.dart#L1-L475)
  - **Problem**: `UnicodeBlockCharMatcher` is a 475-line generated public class providing matchers for all Unicode blocks, but `lib/char_matcher.dart` only exports `CharMatcher` and `UnicodeCharMatcher`, making `UnicodeBlockCharMatcher` inaccessible without importing `lib/src/` directly.
  - **Fix**: Export `src/char_matcher/unicode/blocks.dart show UnicodeBlockCharMatcher;` in `lib/char_matcher.dart`.

- [ ] **`OrderedList` implements `PriorityQueue<E>` and `SortedList` extends `OrderedList` with 8 `UnsupportedError` stubs**
  - **Severity**: Warning
  - **Location**: [`lib/src/collection/ordered_list.dart`](lib/src/collection/ordered_list.dart#L21-L65), [`lib/src/collection/sorted_list.dart`](lib/src/collection/sorted_list.dart#L9-L113)
  - **Problem**: `OrderedList` is an insertion-order circular-buffer deque (`ListBase<E>`), not a priority queue (`PriorityQueue` contract orders elements by priority), and publicly exposes internal ring-buffer fields `startIndex` and `endIndex`. Meanwhile, `SortedList` extends `OrderedList` and overrides 8 mutating methods (`length=`, `[]=`, `addFirst`, `addLast`, `insert`, `insertAll`, `sort`, `shuffle`) to throw `UnsupportedError`, violating Liskov substitution.
  - **Fix**: Have `SortedList` wrap `OrderedList` by composition (implementing `PriorityQueue<E>` on `SortedList` and exposing a read-only `List<E>` view or `Queue<E>` interface), and make `startIndex` / `endIndex` private or `@internal` on `OrderedList`.

- [x] **Typos in `RTree.guttmann` and `CharMatcher.trimTailingFrom`**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/collection/rtree.dart`](lib/src/collection/rtree.dart#L20), [`lib/src/char_matcher/char_matcher.dart`](lib/src/char_matcher/char_matcher.dart#L248)
  - **Problem**: `RTree.guttmann` is spelled with two `n`s while the class is `GuttmanTree` (named after Antonin Guttman). `CharMatcher.trimTailingFrom` is spelled `Tailing` instead of `Trailing` (unlike `trimLeadingFrom`).
  - **Fix**: Add `RTree.guttman` and `CharMatcher.trimTrailingFrom`, and deprecate `RTree.guttmann` and `CharMatcher.trimTailingFrom`.

- [x] **Inconsistent return types on `int.to`, `double.to`, and `chunkedWithPadding`**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/collection/range/integer.dart`](lib/src/collection/range/integer.dart#L120), [`lib/src/collection/range/double.dart`](lib/src/collection/range/double.dart#L144), [`lib/src/collection/iterable/chunked.dart`](lib/src/collection/iterable/chunked.dart#L36)
  - **Problem**: `BigInt.to` returns `BigIntRange`, whereas `int.to` and `double.to` return `Range<int>` and `Range<double>` instead of `IntegerRange` and `DoubleRange` (hiding subtype members like `IntegerRange.toInt`). `chunked` returns `Iterable<List<E>>`, whereas `chunkedWithPadding` returns `Iterable<Iterable<E>>`.
  - **Fix**: Change return types to `IntegerRange`, `DoubleRange`, and `Iterable<List<E>>`.

---

## 6. Missing Features Expected by Users / Agents

- [x] **`Optional` and `Either` ergonomic helpers (`valueOrNull`, `toOptional()`, `ifLeft`, `ifRight`)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/functional/optional.dart`](lib/src/functional/optional.dart#L10-L115), [`lib/src/functional/either.dart`](lib/src/functional/either.dart#L10-L147)
  - **Problem**: `Optional<T>` lacks a `T? get valueOrNull` getter (standard Dart idiom alongside `orElse`) and an extension `OptionalExtension<T> on T?` providing `Optional<T> toOptional()`. `Either<L, R>` lacks `ifLeft(Callback1<L>)` and `ifRight(Callback1<R>)` side-effect helpers (analogous to `Optional.ifPresent` / `ifAbsent`) and `swap` (`Either<R, L> get swapped`).
  - **Fix**: Add `T? get valueOrNull` and `extension OptionalExtension<T extends Object> on T? { Optional<T> toOptional() => Optional.ofNullable(this); }`, plus `ifLeft`, `ifRight`, and `swapped` on `Either<L, R>`.

- [x] **`Graph` convenience queries (`containsVertex`, `containsEdge`, `inDegreeOf`, `outDegreeOf`, `degreeOf`)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/graph.dart`](lib/src/graph/graph.dart#L53-L79)
  - **Problem**: Checking whether a vertex or edge exists currently requires `graph.vertices.contains(v)` or `graph.getEdge(u, v) != null`, and computing vertex degrees requires `graph.incomingEdgesOf(v).length` / `graph.outgoingEdgesOf(v).length`, which allocates edge views and is less discoverable.
  - **Fix**: Add `bool containsVertex(V vertex)`, `bool containsEdge(V source, V target)`, `int inDegreeOf(V vertex)`, `int outDegreeOf(V vertex)`, and `int degreeOf(V vertex)` to `Graph<V, E>`.

- [x] **`BitList` bitwise XOR (`operator ^` and `xor(BitList other)`)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/collection/bitlist.dart`](lib/src/collection/bitlist.dart#L195-L240)
  - **Problem**: `BitList` supports `~` / `not`, `&` / `and`, `|` / `or`, and `-` / `difference`, but omits bitwise XOR (`^` / `xor`).
  - **Fix**: Add `BitList operator ^(BitList other) => BitList.of(this)..xor(other);` and `void xor(BitList other)` to `BitList`.

- [x] **`Interval.span` and `Interval.difference`**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/interval/interval.dart`](lib/src/interval/interval.dart#L42-L67)
  - **Problem**: `Interval` supports `union` (only when intersecting), `intersection`, `encloses`, and `intersects`, but lacks `span(Interval<T> other)` (convex hull `Interval(min(lower, other.lower), max(upper, other.upper))` even for disjoint intervals) and `difference(Interval<T> other)`.
  - **Fix**: Add `Interval<T> span(Interval<T> other)` and `List<Interval<T>> difference(Interval<T> other)` to `Interval<T>`.

- [x] **`Cache` bulk operations (`getAll`, `putAll`, `invalidateAll`)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/cache/cache.dart`](lib/src/cache/cache.dart#L70-L120)
  - **Problem**: `Cache<K, V>` only supports single-key operations (`get`, `getIfPresent`, `put`, `invalidate`) without batch helpers `getAll(Iterable<K> keys)`, `putAll(Map<K, V> map)`, or `invalidateAll([Iterable<K>? keys])`.
  - **Fix**: Provide default implementations of `getAll`, `putAll`, and `invalidateAll` on `Cache<K, V>`.

- [x] **Eulerian path and circuit detection and extraction (Hierholzer's algorithm)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart), [`lib/graph.dart`](lib/graph.dart)
  - **Problem**: `Graph` provides shortest-path, spanning-tree, max-flow, min-cut, clique, coloring, and SCC algorithms, but lacks Eulerian path and Eulerian cycle detection and construction (`hasEulerianPath`, `hasEulerianCircuit`, `eulerianPath`, `eulerianCircuit`).
  - **Fix**: Implement degree-precondition checks (in-degree vs. out-degree for directed graphs; even degrees for undirected graphs, plus connectivity of non-isolated vertices) and linear-time $O(V + E)$ Hierholzer's algorithm in `lib/src/graph/algorithms/eulerian.dart`, returning `Path<V, E>?` and exposing methods on `AlgorithmsGraphExtension`.

- [x] **Articulation points (cut vertices), bridges (cut edges), and biconnected components (Tarjan's low-link algorithm)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart), [`lib/src/graph/algorithms/tarjan_strongly_connected.dart`](lib/src/graph/algorithms/tarjan_strongly_connected.dart)
  - **Problem**: Directed graphs have `stronglyConnected()` via Tarjan's algorithm, and undirected graphs have global `minCut()` via Stoer-Wagner, but undirected graphs lack linear-time $O(V + E)$ structural resilience analysis for articulation points (cut vertices), bridges (cut edges), and biconnected components.
  - **Fix**: Implement Tarjan's DFS low-link algorithm in `lib/src/graph/algorithms/biconnected.dart` (using `StorageStrategy<V>`) to compute `articulationPoints()`, `bridges()`, and `biconnectedComponents()` on `AlgorithmsGraphExtension`.

- [x] **Graph eccentricity, diameter, radius, center, periphery, and average path length on `FloydWarshall`**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms/search/floyd_warshall.dart`](lib/src/graph/algorithms/search/floyd_warshall.dart#L82-L136)
  - **Problem**: `FloydWarshall<V>` already computes the complete all-pairs shortest-path distance matrix `_pairs`, but only exposes `distance(source, target)`, `path(source, target)`, and `allPaths()`. Users must manually iterate over all vertex pairs to compute eccentricity, graph diameter, radius, center/periphery vertices, or average shortest-path length.
  - **Fix**: Add `num eccentricity(V vertex)`, `num get diameter`, `num get radius`, `Set<V> get center`, `Set<V> get periphery`, and `double get averagePathLength` directly on `FloydWarshall<V>`.

- [ ] **Graph structural metrics (`density`, `clusteringCoefficient`, `transitivity`)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart), [`lib/src/graph/graph.dart`](lib/src/graph/graph.dart)
  - **Problem**: Common network analysis metrics—graph density ($\frac{|E|}{|V|(|V|-1)}$ for directed, $\frac{2|E|}{|V|(|V|-1)}$ for undirected) and local/average clustering coefficients (fraction of closed triangles around vertices)—are missing.
  - **Fix**: Add `double get density`, `double localClusteringCoefficient(V vertex)`, and `double averageClusteringCoefficient()` to `AlgorithmsGraphExtension`.

- [ ] **Centrality measures (`closenessCentrality`, `betweennessCentrality`, `pageRank`)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart), [`lib/graph.dart`](lib/graph.dart)
  - **Problem**: `Graph` lacks vertex importance and ranking algorithms used in network analysis and dependency ranking: closeness centrality, Brandes's $O(VE)$ unweighted / $O(VE + V^2 \log V)$ weighted betweenness centrality, and iterative PageRank / eigenvector centrality.
  - **Fix**: Add `closenessCentrality()` (on `FloydWarshall<V>` or `AlgorithmsGraphExtension`), `betweennessCentrality()` (Brandes's algorithm in `lib/src/graph/algorithms/betweenness_centrality.dart`), and `pageRank({double damping = 0.85, double tolerance = 1e-6, int maxIterations = 100})` (in `lib/src/graph/algorithms/page_rank.dart`) returning `Map<V, double>`.

- [ ] **Maximum bipartite matching (Hopcroft–Karp) and minimum vertex cover (König's theorem)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms/bipartite_check.dart`](lib/src/graph/algorithms/bipartite_check.dart), [`lib/src/graph/algorithms/dinic_max_flow.dart`](lib/src/graph/algorithms/dinic_max_flow.dart), [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart)
  - **Problem**: While `isBipartite` and `DinicMaxFlow` both exist in `lib/src/graph/algorithms/`, there is no dedicated bipartite matching or minimum vertex cover API (`bipartiteMatching`, `minimumVertexCover`).
  - **Fix**: Implement Hopcroft–Karp $O(E \sqrt{V})$ maximum bipartite matching (or build on `isBipartite` two-coloring + `DinicMaxFlow`) and derive the minimum vertex cover and maximum independent set in bipartite graphs via König's theorem in `lib/src/graph/algorithms/bipartite_matching.dart`.

- [ ] **$k$-Core decomposition (`kCore`, `coreNumbers`)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart), [`lib/graph.dart`](lib/graph.dart)
  - **Problem**: There is no algorithm to compute vertex core numbers or extract the maximal subgraph in which every vertex has degree $\ge k$ (whereas `bronKerboschCliques` requires exponential time).
  - **Fix**: Implement the Matula–Beck $O(V + E)$ bucket-queue peeling algorithm in `lib/src/graph/algorithms/k_core.dart`, exposing `Map<V, int> coreNumbers()` and `Graph<V, E> kCore(int k)` on `AlgorithmsGraphExtension`.

- [ ] **Transitive closure and transitive reduction for directed graphs**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/operations/`](lib/src/graph/operations/), [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart)
  - **Problem**: Directed dependency and reachability graphs lack `transitiveClosure()` (adding edges `(u, v)` whenever `v` is reachable from `u`) and `transitiveReduction()` (removing redundant edges while preserving reachability in DAGs).
  - **Fix**: Add `Graph<V, void> transitiveClosure()` and `Graph<V, E> transitiveReduction()` in `lib/src/graph/operations/transitive.dart` using reachability bitsets (`BitList`) / topological order.

- [ ] **Vertex and edge connectivity (`edgeConnectivity`, `vertexConnectivity`) via `DinicMaxFlow` / `StoerWagnerMinCut`**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms/dinic_max_flow.dart`](lib/src/graph/algorithms/dinic_max_flow.dart), [`lib/src/graph/algorithms/stoer_wagner_min_cut.dart`](lib/src/graph/algorithms/stoer_wagner_min_cut.dart), [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart)
  - **Problem**: Computing the minimum number of edges or vertices whose removal disconnects a graph (or separates `source` from `target`) requires manual unit-capacity network construction on top of `DinicMaxFlow` or `StoerWagnerMinCut`.
  - **Fix**: Add `int edgeConnectivity([V? source, V? target])` and `int vertexConnectivity([V? source, V? target])` (using unit edge capacities and vertex-splitting $v \to (v_{\text{in}}, v_{\text{out}})$ with `DinicMaxFlow`) on `AlgorithmsGraphExtension`.

- [ ] **Graph and subgraph isomorphism (VF2 algorithm)**
  - **Severity**: Suggestion
  - **Location**: [`lib/src/graph/algorithms.dart`](lib/src/graph/algorithms.dart), [`lib/graph.dart`](lib/graph.dart)
  - **Problem**: `Graph` has no structural equivalence check (`isIsomorphicTo`) or subgraph pattern matching (`findIsomorphisms`), which is particularly useful alongside `GraphFactory.atlas`.
  - **Fix**: Implement the VF2 state-space search algorithm in `lib/src/graph/algorithms/isomorphism.dart` supporting custom vertex/edge compatibility predicates, exposing `bool isIsomorphicTo<W, F>(Graph<W, F> other, ...)` and `Iterable<Map<V, W>> findSubgraphIsomorphisms<W, F>(Graph<W, F> pattern, ...)`.


