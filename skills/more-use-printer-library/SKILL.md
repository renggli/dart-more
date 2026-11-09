---
name: more-dart-use-printer-library
description: "Composable value formatting and string printing in package:more/printer.dart: Printer<T>, number/scientific/human/ordinal printers, DateTime/Duration printers, ObjectPrinter, and padding/truncation modifiers."
---

# MoreDart Printer Library (`package:more/printer.dart`)

`Printer<T>` is a composable, callable formatting object (`String call(T object)` and `void printOn(T object, StringBuffer buffer)`) that formats values into strings without imperative string manipulation.

---

## Core Concepts & Basic Printers

```dart
import 'package:more/printer.dart';

// Standard, literal, pluggable, and sequence printers
const std = Printer<int>.standard();
final hex = Printer<int>.pluggable((v) => '0x${v.toRadixString(16)}');
final wrapped = hex.around('[', ']');
final formatted = wrapped(255); // '[0xff]'

// Conditional switcher printer
final statusPrinter = Printer<int>.switcher({
  (n) => n < 0: const Printer.literal('negative'),
  (n) => n == 0: const Printer.literal('zero'),
}, otherwise: const Printer.literal('positive'));
```

---

## Number Printers

```dart
// Fixed-point numbers with padding, precision, thousands separators, and base
final fixed = FixedNumberPrinter<num>(
  precision: 2,
  separator: '_',
  sign: const SignNumberPrinter.spacePositiveSign(),
);
final fixedOut = fixed(12345.6); // ' 12_345.60'

// Scientific notation
final sci = ScientificNumberPrinter<num>(precision: 2);
final sciOut = sci(12345.0); // '1.23e4'

// Human-readable SI (decimal: k, M, G) and IEC (binary: Ki, Mi, Gi) units
final humanDec = HumanNumberPrinter.decimal(precision: 1);
final humanBin = HumanNumberPrinter.binary(precision: 1);
final decOut = humanDec(1500000); // '1.5 M'
final binOut = humanBin(1536); // '1.5 Ki'

// Ordinal numbers
final ordinal = OrdinalNumberPrinter();
final ordOut = ordinal(23); // '23rd'
```

---

## Temporal Printers (`DateTime` & `Duration`)

```dart
// Preconfigured DateTime printers: .date(), .time(), .dateTime(), .iso8601()
final isoDate = DateTimePrinter.date();
final dateStr = isoDate(DateTime.utc(2025, 7, 4)); // '2025-07-04'

// Custom builder-based DateTimePrinter
final customDate = DateTimePrinter(
  (b) => b
    ..year()
    ..literal('/')
    ..month(width: 2)
    ..literal('/')
    ..day(width: 2),
);

// Preconfigured Duration printers (.dart(), .iso8601()) or custom builder
final timerPrinter = DurationPrinter(
  (b) => b
    ..part(TimeUnit.minute, printer: FixedNumberPrinter(padding: 2))
    ..literal(':')
    ..part(TimeUnit.second, printer: FixedNumberPrinter(padding: 2)),
);
final durationStr = timerPrinter(const Duration(minutes: 3, seconds: 7)); // '03:07'
```

---

## `ObjectPrinter` & `ToStringPrinter` Mixin

Use `ToStringPrinter` for declarative `toString()` implementations that automatically omit null/default fields when configured:

```dart
class User with ToStringPrinter {
  new(this.name, {this.age});
  final String name;
  final int? age;

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(name, name: 'name')
    ..addValue(age, name: 'age', omitNull: true);
}

final userStr = User('Alice').toString(); // 'User(name: Alice)'
```

---

## Modifiers, Truncation & Iterable Formatting

Every `Printer<T>` supports chainable transformation extensions:

- **Padding & Trimming**: `.padLeft(width, [pad])`, `.padRight(width, [pad])`, `.padBoth(width, [pad])`, `.trim()`, `.trimLeft()`, `.trimRight()`
- **Truncation & Slicing**: `.truncateRight(width, method: TruncateMethod.characters/words/sentences, ellipsis: '…')`, `.truncateLeft(width)`, `.truncateCenter(width)`, `.take(n)`, `.skip(n)`, `.separateLeft(width, offset, sep)`
- **Affixes & Mapping**: `.before(prefix)`, `.after(suffix)`, `.around(left, [right])`, `.onResultOf<S>((S x) => ...)`, `.where(predicate)`, `.ifNull([label])`, `.ifEmpty([label])`
- **Iterables**: `.iterable(separator: ', ', lastSeparator: ' and ', leadingItems: 3, trailingItems: 1)`

```dart
final listPrinter = const Printer<int>.standard().iterable(
  separator: ', ',
  lastSeparator: ' and ',
  leadingItems: 2,
  trailingItems: 1,
);
final summary = listPrinter([1, 2, 3, 4, 5]); // '1, 2, … and 5'
```
