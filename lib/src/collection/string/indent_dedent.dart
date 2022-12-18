import 'dart:math';

import '../../../char_matcher.dart';
import 'prefix_suffix.dart';

extension IndentDedentStringExtension<T> on String {
  /// Adds a [prefix] to the beginning of each line.
  ///
  /// - If defined, [firstPrefix] replaces [prefix] on the first line.
  /// - [trimWhitespace] trims the each line from existing whitespace.
  /// - [indentEmpty] indents empty lines as well.
  String indent(
    String prefix, {
    String? firstPrefix,
    bool trimWhitespace = true,
    bool indentEmpty = false,
  }) {
    final result = <String>[];
    for (var line in split('\n')) {
      if (trimWhitespace) {
        line = line.trim();
      }
      if (line.isEmpty && !indentEmpty) {
        result.add(line);
      } else {
        if (result.isEmpty && firstPrefix != null) {
          result.add('$firstPrefix$line');
        } else {
          result.add('$prefix$line');
        }
      }
    }
    return result.join('\n');
  }

  /// Removes a common leading prefix from every line.
  ///
  /// - [whitespace] matches the leading prefix.
  /// - [ignoreEmpty] is used to skip over empty lines.
  String dedent({
    Pattern whitespace = const CharMatcher.whitespace(),
    bool ignoreEmpty = true,
  }) {
    final lines = split('\n');
    final prefix = findLongestPrefix(whitespace,
        ignoreEmpty ? lines.where((line) => line.trim().isNotEmpty) : lines);
    if (prefix.isEmpty) {
      return this;
    }
    return lines.map((line) => line.removePrefix(prefix)).join('\n');
  }
}

/// Returns the longest prefix [pattern] from a list of [lines].
String findLongestPrefix(Pattern pattern, Iterable<String> lines) {
  String? prefix;
  for (final line in lines) {
    // Extract the current prefix.
    var index = 0;
    while (index < line.length) {
      final match = pattern.matchAsPrefix(line, index);
      if (match == null) {
        break;
      }
      index = match.end;
    }
    final current = line.substring(0, index);
    // Find the longest prefix so far.
    if (prefix == null || prefix.startsWith(current)) {
      prefix = current;
    } else if (current.startsWith(prefix)) {
      continue;
    } else {
      for (var i = 0; i < min(prefix!.length, current.length); i++) {
        if (prefix[i] != current[i]) {
          prefix = prefix.substring(0, i);
          break;
        }
      }
    }
    // Give up, if the current prefix is empty.
    if (prefix.isEmpty) {
      return prefix;
    }
  }
  return prefix ?? '';
}
