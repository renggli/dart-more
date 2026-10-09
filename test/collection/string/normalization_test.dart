import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

import '../../data/normalization_data.dart';

void verifyUnicodeNormalization(
  NormalizationForm form,
  Iterable<int> source,
  Iterable<int> expected,
) {
  final sourceString = String.fromCharCodes(source);
  final actualString = sourceString.normalize(form: form);
  final expectedString = String.fromCharCodes(expected);
  if (actualString == expectedString) {
    check(actualString).equals(expectedString);
  } else {
    String formatCharCodes(Iterable<int> charCodes) => charCodes
        .map((code) => code.toRadixString(16).padLeft(4, '0'))
        .join(' ');
    check(
      actualString,
      because:
          'for "$sourceString" [${formatCharCodes(source)}]\n'
          'expected "$expectedString" [${formatCharCodes(expected)}],\n'
          'but got "$actualString" [${formatCharCodes(actualString.runes)}].',
    ).equals(expectedString);
  }
}

void main() {
  group('normalization', () {
    final invariants = 0
        .to(0x10ffff)
        .toSet()
        .difference(
          normalizationTestData['@Part1']!
              .map((test) => test.source.single)
              .toSet(),
        )
        .map((value) => [value]);

    group('NFC', () {
      const form = NormalizationForm.nfc;
      test('basic', () {
        verifyUnicodeNormalization(form, ''.runes, ''.runes);
        verifyUnicodeNormalization(form, 'élève'.runes, 'élève'.runes);
        verifyUnicodeNormalization(form, '한국'.runes, '한국'.runes);
        verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ﬃ'.runes);
      });
      for (final MapEntry(key: part, value: tests)
          in normalizationTestData.entries) {
        test('suite $part', () {
          for (final test in tests) {
            verifyUnicodeNormalization(form, test.source, test.nfc);
            verifyUnicodeNormalization(form, test.nfc, test.nfc);
            verifyUnicodeNormalization(form, test.nfd, test.nfc);
            verifyUnicodeNormalization(form, test.nfkc, test.nfkc);
            verifyUnicodeNormalization(form, test.nfkd, test.nfkc);
          }
        });
      }
      test('suite invariants', () {
        for (final invariant in invariants) {
          verifyUnicodeNormalization(form, invariant, invariant);
        }
      });
    });

    group('NFD', () {
      const form = NormalizationForm.nfd;
      test('basic', () {
        verifyUnicodeNormalization(form, ''.runes, ''.runes);
        verifyUnicodeNormalization(form, 'élève'.runes, 'élève'.runes);
        verifyUnicodeNormalization(form, '한국'.runes, '한국'.runes);
        verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ﬃ'.runes);
      });
      for (final MapEntry(key: part, value: tests)
          in normalizationTestData.entries) {
        test('suite $part', () {
          for (final test in tests) {
            verifyUnicodeNormalization(form, test.source, test.nfd);
            verifyUnicodeNormalization(form, test.nfc, test.nfd);
            verifyUnicodeNormalization(form, test.nfd, test.nfd);
            verifyUnicodeNormalization(form, test.nfkc, test.nfkd);
            verifyUnicodeNormalization(form, test.nfkd, test.nfkd);
          }
        });
      }
      test('suite invariants', () {
        for (final invariant in invariants) {
          verifyUnicodeNormalization(form, invariant, invariant);
        }
      });
    });

    group('NFKC', () {
      const form = NormalizationForm.nfkc;
      test('basic', () {
        verifyUnicodeNormalization(form, ''.runes, ''.runes);
        verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ffi'.runes);
      });
      for (final MapEntry(key: part, value: tests)
          in normalizationTestData.entries) {
        test('suite $part', () {
          for (final test in tests) {
            verifyUnicodeNormalization(form, test.source, test.nfkc);
            verifyUnicodeNormalization(form, test.nfc, test.nfkc);
            verifyUnicodeNormalization(form, test.nfd, test.nfkc);
            verifyUnicodeNormalization(form, test.nfkc, test.nfkc);
            verifyUnicodeNormalization(form, test.nfkd, test.nfkc);
          }
        });
      }
      test('suite invariants', () {
        for (final invariant in invariants) {
          verifyUnicodeNormalization(form, invariant, invariant);
        }
      });
    });

    group('NFKD', () {
      const form = NormalizationForm.nfkd;
      test('basic', () {
        verifyUnicodeNormalization(form, ''.runes, ''.runes);
        verifyUnicodeNormalization(form, '⑴'.runes, '(1)'.runes);
        verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ffi'.runes);
        verifyUnicodeNormalization(form, '²'.runes, '2'.runes);
        verifyUnicodeNormalization(form, '⑴ ﬃ ²'.runes, '(1) ffi 2'.runes);
      });
      for (final MapEntry(key: part, value: tests)
          in normalizationTestData.entries) {
        test('suite $part', () {
          for (final test in tests) {
            verifyUnicodeNormalization(form, test.source, test.nfkd);
            verifyUnicodeNormalization(form, test.nfc, test.nfkd);
            verifyUnicodeNormalization(form, test.nfd, test.nfkd);
            verifyUnicodeNormalization(form, test.nfkc, test.nfkd);
            verifyUnicodeNormalization(form, test.nfkd, test.nfkd);
          }
        });
      }
      test('suite invariants', () {
        for (final invariant in invariants) {
          verifyUnicodeNormalization(form, invariant, invariant);
        }
      });
    });
  });
}
