---
name: more-dart-use-diff-library
description: "Sequence diffing and fuzzy matching in package:more/diff.dart: SequenceMatcher, UnifiedDiffer, ReadableDiffer, ContextDiffer, NormalDiffer, and closeMatches."
---

# MoreDart Diff Library (`package:more/diff.dart`)

Provides Gestalt pattern matching (`SequenceMatcher<T>`) for comparing arbitrary `Iterable<T>` sequences, line-based text diff formatters (`UnifiedDiffer`, `ReadableDiffer`, `ContextDiffer`, `NormalDiffer`), and fuzzy string/sequence matching (`closeMatches`).

---

## `SequenceMatcher<T>` (Arbitrary Sequences)

Computes matching blocks, edit operations (`equal`, `insert`, `delete`, `replace`), context-grouped hunks, and similarity ratios in `[0.0, 1.0]`:

```dart
import 'package:more/diff.dart';

final matcher = SequenceMatcher<String>(
  source: ['a', 'b', 'c', 'd'],
  target: ['a', 'x', 'c', 'd', 'e'],
);

// Similarity score in [0.0, 1.0] (also quickRatio and realQuickRatio upper bounds)
final similarity = matcher.ratio;

// Matching blocks: Match(sourceStart, targetStart, length)
final blocks = matcher.matches;

// Edit script: Operation(type, sourceStart, sourceEnd, targetStart, targetEnd)
for (final op in matcher.operations) {
  final kind = op.type; // OperationType.equal, .replace, .insert, or .delete
}

// Grouped operations with surrounding context (for patch generation)
final hunks = matcher.groupedOperations(context: 2);
```

---

## Line & Text Diff Formatters

All `Differ` classes accept either multiline strings (`.compareStrings(...)`) or line lists (`.compareLines(...)`):

```dart
const sourceText = 'apple\nbanana\ncherry';
const targetText = 'apple\nblueberry\ncherry';

// Unified diff (git/patch style with @@ headers)
final unified = const UnifiedDiffer(context: 3).compareStrings(
  sourceText,
  targetText,
  sourceLabel: 'a/fruits.txt',
  targetLabel: 'b/fruits.txt',
);

// Human-readable diff with intraline '?' change indicators
final readable = ReadableDiffer().compareStrings(sourceText, targetText);

// Context diff and classic Unix normal diff
final contextDiff = const ContextDiffer(context: 3).compareStrings(sourceText, targetText);
final normalDiff = const NormalDiffer().compareStrings(sourceText, targetText);
```

---

## Fuzzy Matching (`closeMatches`)

Find the best matching candidates above a similarity `cutoff`:

```dart
const candidates = ['apple', 'ape', 'peach', 'puppy'];
final best = candidates.closeMatches('appel', count: 2, cutoff: 0.6); // ['apple', 'ape']
```
