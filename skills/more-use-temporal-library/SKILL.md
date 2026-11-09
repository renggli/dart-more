---
name: more-dart-use-temporal-library
description: "Calendar properties, truncation, periodic date sequences, and multi-unit duration conversions in package:more/temporal.dart."
---

# MoreDart Temporal Library (`package:more/temporal.dart`)

Extends Dart's `DateTime`, `Duration`, and `Interval<DateTime>` with calendar accessors, `TimeUnit`-based truncation, lazy periodic date iterables, and multi-unit duration decomposition.

---

## `DateTime` Calendar Properties & Truncation

```dart
import 'package:more/interval.dart';
import 'package:more/temporal.dart';

final dt = DateTime.utc(2024, 2, 29, 14, 35, 20);

// Calendar properties (including ISO 8601 week numbering)
final leap = dt.isLeapYear; // true
final daysInMonth = dt.daysInMonth; // 29
final daysInYear = dt.daysInYear; // 366
final quarter = dt.quarter; // 1
final dayOfYear = dt.dayOfYear; // 60
final weekNum = dt.weekNumber; // 9
final weekYr = dt.weekYear; // 2024

// Truncate down to any TimeUnit (microsecond .. millennium)
final startOfDay = dt.truncateTo(TimeUnit.day); // 2024-02-29 00:00:00.000Z
final startOfWeek = dt.truncateTo(TimeUnit.week, startWeekday: DateTime.monday);
final startOfMonth = dt.truncateTo(TimeUnit.month); // 2024-02-01 00:00:00.000Z
```

---

## Periodic `DateTime` Generation

Generate lazy, infinite sequences of `DateTime` values stepped by any `TimeUnit` (combining with `.take(n)` or `.takeWhile(...)`):

```dart
final start = DateTime.utc(2025, 1, 1);

// First 4 quarterly dates starting 2025-01-01
final quarters = start.periodical(TimeUnit.quarter).take(4).toList();

// Every 2 weeks
final biweekly = start.periodical(TimeUnit.week, step: 2).take(3).toList();
```

---

## `Duration` & `Interval<DateTime>` Conversions

Convert a `Duration` into a single fractional `TimeUnit` or decompose it across multiple units using `casualConversion` (30-day months, 365-day years) or `accurateConversion` (Gregorian average):

```dart
const dur = Duration(days: 3, hours: 5, minutes: 45);

// Single unit conversion (returns double)
final inHours = dur.convertTo(TimeUnit.hour); // 77.75

// Multi-unit decomposition (returns Map<TimeUnit, int> including microsecond remainder)
final parts = dur.convertToAll({TimeUnit.day, TimeUnit.hour, TimeUnit.minute});
final days = parts[TimeUnit.day]; // 3
final hours = parts[TimeUnit.hour]; // 5

// Convert an Interval<DateTime> to a Duration
final span = Interval(DateTime.utc(2025, 1, 1), DateTime.utc(2025, 1, 3)).toDuration();
```
