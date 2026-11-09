---
name: more-dart-use-functional-library
description: "Functional programming types and combinators in package:more/functional.dart: Optional<T>, Either<L, R>, also scope extension, currying, partial application, and function helpers."
---

# MoreDart Functional Library (`package:more/functional.dart`)

Provides algebraic data types (`Optional<T>` and `Either<L, R>`), the `.also(...)` scope extension, and higher-order function combinators (currying, partial argument binding, and constant/identity/throwing functions).

---

## `Optional<T>`

A sealed container (`PresentOptional<T>` | `AbsentOptional<T>`) representing an optional value, distinct from `null` (allows `T` itself to be nullable if needed):

```dart
import 'package:more/functional.dart';

// Creation
const present = Optional.of('hello');
const absent = Optional<String>.absent();
final fromNullable = Optional.ofNullable(null as String?); // AbsentOptional
final viaExt = 'world'.toOptional(); // PresentOptional('world')

// Transformation & filtering
final lengthOpt = present
    .where((s) => s.isNotEmpty)
    .map((s) => s.length); // Optional.of(5)

// Unwrapping & fallbacks
final val = lengthOpt.orElse(0); // 5
final lazyVal = absent.orElseGet(() => 'fallback'); // 'fallback'
final nullableVal = absent.valueOrNull; // null
```

---

## `Either<L, R>`

A sealed disjoint union (`LeftEither<L, R>` | `RightEither<L, R>`) representing one of two possible types:

```dart
// Creation
const right = Either<String, int>.right(42);
const left = Either<String, int>.left('Invalid input');
final condEither = Either.iff(true, () => 'err', () => 100);

// Folding, mapping, and swapping
final message = right.fold(
  (err) => 'Error: $err',
  (val) => 'Success: ${val * 2}',
); // 'Success: 84'

final mapped = right.mapRight((n) => n + 1); // Either.right(43)
final swapped = right.swap(); // Either<int, String>.left(42)
```

---

## Scope Extension & Function Combinators

```dart
// .also(fn): inline transformation / side-effect pipeline
final result = '  42  '.also((s) => s.trim()).also(int.parse); // 42

// Currying and partial argument binding (bind0 .. bind9)
int add3(int a, int b, int c) => a + b + c;
final curriedSum = add3.curry(1)(2)(3); // 6
final add10AndBAndC = add3.bind0(10); // int Function(int, int)
final boundSum = add10AndBAndC(20, 30); // 60

// Standard function utilities
final id = identityFunction<int>(7); // 7
final alwaysTrue = constantFunction1<String, bool>(true)('any'); // true
```
