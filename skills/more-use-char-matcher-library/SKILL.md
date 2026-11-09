---
name: more-dart-use-char-matcher-library
description: "Character class predicates, composition, and bulk string processing in package:more/char_matcher.dart: ASCII/Unicode matchers, set algebra (~, |, &), filtering, trimming, splitting, and replacing."
---

# MoreDart CharMatcher Library (`package:more/char_matcher.dart`)

`CharMatcher` is an immutable character predicate (`bool match(int codePoint)`) that also implements Dart's `Pattern` interface and provides fast bulk string operations (filtering, trimming, collapsing, replacing, and counting).

---

## Constructing Matchers

```dart
import 'package:more/char_matcher.dart';

// Single characters, ranges, sets, and RegExp-like character class patterns
final isA = CharMatcher.isChar('a');
final lowerHex = CharMatcher.inRange('a', 'f');
final vowels = CharMatcher.charSet('aeiou');
final consonants = CharMatcher.pattern('a-z-[aeiou]');

// Built-in ASCII / common matchers
const ascii = CharMatcher.ascii();
const digit = CharMatcher.digit();
const letter = CharMatcher.letter();
const alnum = CharMatcher.letterOrDigit();
const upper = CharMatcher.upperCaseLetter();
const lower = CharMatcher.lowerCaseLetter();
const punct = CharMatcher.punctuation();
const space = CharMatcher.whitespace();

// Full Unicode categories, scripts, properties, and blocks
final unicodeLetter = UnicodeCharMatcher.letter();
final greekScript = UnicodeCharMatcher.scriptGreek();
const emoticons = UnicodeBlockCharMatcher.emoticons;
const basicLatin = UnicodeBlockCharMatcher.basicLatin;
```

---

## Composing Matchers (`~`, `|`, `&`)

Combine matchers using set-theoretic operators:

- `~matcher`: Negation (complement)
- `a | b`: Disjunction (union)
- `a & b`: Conjunction (intersection)

```dart
final identifierStart = const CharMatcher.letter() | CharMatcher.isChar('_');
final identifierPart = identifierStart | const CharMatcher.digit();
final nonAsciiWhitespace =
    UnicodeCharMatcher.whiteSpace() & ~const CharMatcher.ascii();
```

---

## Bulk String Operations

```dart
const input = '  Hello,   World! 123  ';

// Filtering & replacing
final digitsOnly = const CharMatcher.digit().retainFrom(input); // '123'
final noDigits = const CharMatcher.digit().removeFrom(input); // '  Hello,   World!   '
final redacted = const CharMatcher.digit().replaceFrom(input, '#'); // '  Hello,   World! ###  '

// Collapsing consecutive matching runs into a single replacement
final collapsed = const CharMatcher.whitespace()
    .collapseFrom(input.trim(), ' '); // 'Hello, World! 123'

// Trimming leading, trailing, or both ends
final trimmed = const CharMatcher.whitespace().trimFrom(input); // 'Hello,   World! 123'
final trimLead = const CharMatcher.whitespace().trimLeadingFrom(input);
final trimTrail = const CharMatcher.whitespace().trimTrailingFrom(input);

// Testing, counting, and indexing
final allAscii = const CharMatcher.ascii().everyOf(input); // true
final hasDigit = const CharMatcher.digit().anyOf(input); // true
final noControl = CharMatcher.isChar('\x00').noneOf(input); // true
final digitCount = const CharMatcher.digit().countIn(input); // 3
final firstDigitIdx = const CharMatcher.digit().firstIndexIn(input); // 18

// Usable anywhere Dart expects a Pattern (e.g., String.split)
final words = 'one, two; three'.split(CharMatcher.charSet(',; '));
```
