import 'dart:convert';

/// Abstract class producing deltas from sequences of lines of text.
abstract class Differ {
  /// Compares two strings from [source] to [target].
  ///
  /// The optional arguments [sourceLabel] and [targetLabel] are used by some
  /// differs to print additional information about where the data is coming
  /// from, i.e. the filename and the last modification date.
  Iterable<String> compareStrings(String source, String target,
          {String? sourceLabel, String? targetLabel}) =>
      compareLines(_lineSplitter.convert(source), _lineSplitter.convert(target),
          sourceLabel: sourceLabel, targetLabel: targetLabel);

  /// Compares two iterables of lines from [source] to [target].
  ///
  /// The optional arguments [sourceLabel] and [targetLabel] are used by some
  /// differs to print additional information about where the data is coming
  /// from, i.e. the filename and the last modification date.
  Iterable<String> compareLines(
      Iterable<String> source, Iterable<String> target,
      {String? sourceLabel, String? targetLabel});
}

const _lineSplitter = LineSplitter();
