// Based on the MIT Licensed code of Marc Lodewijck:
// https://github.com/mlodewijck/pyunormalize

import 'package:collection/collection.dart';

import 'normalization_data.dart';

// Performs a full in-place decomposition of the Unicode string based on the
// specified normalization form.
//
// The type of full decomposition chosen depends on which Unicode normalization
// form is involved. For NFC or NFD, it performs a full canonical decomposition.
// For NFKC or NFKD, it performs a full compatibility decomposition.
List<int> decompose(List<int> codePoints, {bool compatibility = false}) {
  final decomposition =
      compatibility ? compatibilityDecomposition : canonicalDecomposition;
  for (var i = 0; i < codePoints.length;) {
    final codePoint = codePoints[i];
    final replacement = decomposition[codePoint];
    if (replacement != null) {
      codePoints.replaceRange(i, i + 1, replacement);
      i += replacement.length;
    } else if (hangulSB <= codePoint && codePoint <= hangulSL) {
      final replacement = decomposeHangulSyllable(codePoint);
      codePoints.replaceRange(i, i + 1, replacement);
      i += replacement.length;
    } else {
      i++;
    }
  }
  return codePoints;
}

// Performs Hangul syllable decomposition algorithm to derive the full
// canonical decomposition of a pre-composed Hangul syllable into its
// constituent jamo characters.
List<int> decomposeHangulSyllable(int codePoint) {
  final s = codePoint - hangulSB;
  final t = s % hangulTCOUNT;
  final q = (s - t) ~/ hangulTCOUNT;
  final v = hangulVB + (q % hangulVCOUNT);
  final l = hangulLB + (q ~/ hangulVCOUNT);
  return t > 0 ? [l, v, hangulTB - 1 + t] : [l, v];
}

// Performs the canonical ordering algorithm in-place.
//
// Once a string has been fully decomposed, this algorithm ensures that any
// sequences of combining marks within it are arranged in a well-defined order.
// Only combining marks with non-zero Canonical_Combining_Class property values
// are subject to potential reordering. The canonical ordering imposed by both
// composed and decomposed normalization forms is crucial for ensuring the
// uniqueness of normal forms.
List<int> reorder(List<int> codePoints) {
  var n = codePoints.length;
  while (n > 1) {
    var i = 1;
    var j = 0;
    while (i < n) {
      final b = canonicalCombiningClasses[codePoints[i]];
      if (b == null) {
        i += 2;
        continue;
      }
      final a = canonicalCombiningClasses[codePoints[i - 1]];
      if (a == null || a <= b) {
        i++;
        continue;
      }
      codePoints.swap(i - 1, i);
      j = i;
      i++;
    }
    n = j;
  }
  return codePoints;
}

// Canonical composition algorithm to transform a fully decomposed
// and canonically ordered string into its most fully composed but still
// canonically equivalent sequence.
List<int> compose(List<int> codePoints) {
  for (var i = 0; i < codePoints.length; i++) {
    var x = codePoints[i];
    if (x == -1 || canonicalCombiningClasses.containsKey(x)) {
      continue;
    }
    var lastCc = false;
    var blocked = false;
    for (var j = i + 1; j < codePoints.length; j++) {
      final y = codePoints[j];
      if (canonicalCombiningClasses.containsKey(y)) {
        lastCc = true;
      } else {
        blocked = true;
      }
      if (lastCc && blocked) {
        continue;
      }
      final prev = codePoints[j - 1];
      if (prev == -1 ||
          !canonicalCombiningClasses.containsKey(prev) ||
          canonicalCombiningClasses[prev]! < canonicalCombiningClasses[y]!) {
        final preComp = composition[x]?[y] ?? composeHangulSyllable(x, y);
        if (preComp == null || compositionExclusion.contains(preComp)) {
          if (blocked) {
            break;
          }
        } else {
          codePoints[i] = x = preComp;
          codePoints[j] = -1;
          if (blocked) {
            blocked = false;
          } else {
            lastCc = false;
          }
        }
      }
    }
  }
  return codePoints.where((each) => each != -1).toList();
}

// Perform Hangul syllable composition algorithm to derive the mapping
// of a canonically decomposed sequence of Hangul jamo characters
// to an equivalent precomposed Hangul syllable.
int? composeHangulSyllable(int x, int y) {
  if (hangulLB <= x && x <= hangulLL && hangulVB <= y && y <= hangulVL) {
    // Compose a leading consonant and a vowel into an LV syllable
    return hangulSB +
        (((x - hangulLB) * hangulVCOUNT) + y - hangulVB) * hangulTCOUNT;
  }
  if (hangulSB <= x &&
      x <= hangulSL &&
      hangulTB <= y &&
      y <= hangulTL &&
      (x - hangulSB) % hangulTCOUNT == 0) {
    // Compose an LV syllable and a trailing consonant into an LVT syllable
    return x + y - (hangulTB - 1);
  }
  return null;
}

// Creates a dictionary with a full canonical decompositions.
Map<int, List<int>> createDecomposition({bool compatibility = false}) {
  final decomposition = <int, List<int>>{};
  for (final MapEntry(:key, :value) in characterDecompositionMapping.entries) {
    if (value.type == null || compatibility) {
      decomposition[key] = value.values;
    }
  }
  expandDecomposition(decomposition);
  return decomposition;
}

// A full decomposition of a character sequence results from decomposing each of
// the characters in the sequence until no characters can be further decomposed.
void expandDecomposition(Map<int, List<int>> fullDecomposition) {
  const listComparator = ListEquality<int>();
  for (final key in fullDecomposition.keys) {
    final current = <int>[];
    final decomposition = [key];
    while (true) {
      for (final key in decomposition) {
        final value = fullDecomposition[key];
        if (value != null) {
          current.addAll(value);
        } else {
          current.add(key);
        }
      }
      if (listComparator.equals(current, decomposition)) {
        fullDecomposition[key] = decomposition;
        break;
      }
      decomposition.clear();
      decomposition.addAll(current);
      current.clear();
    }
  }
}

// Creates a dictionary with a full canonical composition.
Map<int, Map<int, int>> createComposition() {
  final composition = <int, Map<int, int>>{};
  for (final MapEntry(:key, :value) in characterDecompositionMapping.entries) {
    if (value.type == null &&
        value.values.length == 2 &&
        !canonicalCombiningClasses.containsKey(value.values[0])) {
      composition.putIfAbsent(value.values[0], () => {})[value.values[1]] = key;
    }
  }
  return composition;
}

// Dictionary mapping characters to their full canonical decompositions,
// not including Hangul syllables.
final canonicalDecomposition = createDecomposition();

// Dictionary mapping characters to their full compatibility decompositions,
// not including Hangul syllables.
final compatibilityDecomposition = createDecomposition(compatibility: true);

// Dictionary mapping canonical decompositions to their canonical composite,
// not including Hangul syllables.
final composition = createComposition();

// Hangul syllables for modern Korean.
const hangulSB = 0xac00;
const hangulSL = 0xd7a3;

// Hangul leading consonants (syllable onsets).
const hangulLB = 0x1100;
const hangulLL = 0x1112;

// Hangul vowels (syllable nucleuses).
const hangulVB = 0x1161;
const hangulVL = 0x1175;

// Hangul trailing consonants (syllable codas).
const hangulTB = 0x11a8;
const hangulTL = 0x11c2;

// Number of Hangul vowels.
const hangulVCOUNT = 21;

// Number of Hangul trailing consonants, with the additional case of no trailing
// consonant.
const hangulTCOUNT = 28;
