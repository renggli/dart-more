import 'normalization_logic.dart';

/// The different Unicode Normalization Forms.
enum NormalizationForm {
  /// Canonical Decomposition, followed by Canonical Composition.
  nfc,

  /// Canonical Decomposition.
  nfd,

  /// Compatibility Decomposition, followed by Canonical Composition.
  nfkc,

  /// Compatibility Decomposition.
  nfkd,
}

extension NormalizeStringExtension on String {
  /// Returns the Unicode Normalization Form of this string.
  ///
  /// If the form is omitted, the standard "NFC" normalization is used.
  String normalize({NormalizationForm form = NormalizationForm.nfc}) =>
      String.fromCharCodes(switch (form) {
        NormalizationForm.nfc => compose(reorder(decompose(runes.toList()))),
        NormalizationForm.nfd => reorder(decompose(runes.toList())),
        NormalizationForm.nfkc => compose(
          reorder(decompose(runes.toList(), compatibility: true)),
        ),
        NormalizationForm.nfkd => reorder(
          decompose(runes.toList(), compatibility: true),
        ),
      });
}
