import 'dart:math';

extension WrapUnwrapStringExtension on String {
  /// Wraps a long text so that every line is at most [width] characters long.
  String wrap(
    int width, {
    Pattern? whitespace,
    bool breakLongWords = true,
  }) {
    if (width < 1) {
      throw RangeError.range(width, 1, null, 'width', 'width must be positive');
    }
    return split('\n')
        .map((line) =>
            line._wrap(width, whitespace ?? defaultWhitespace, breakLongWords))
        .join('\n');
  }

  String _wrap(int width, Pattern whitespace, bool breakLongWords) {
    final result = <String>[];
    final buffer = StringBuffer();
    final words = split(whitespace);
    for (var i = 0; i < words.length;) {
      final word = words[i];
      if (word.isEmpty) {
        i++;
      } else if (buffer.isEmpty) {
        if (word.length <= width) {
          buffer.write(word);
        } else if (breakLongWords) {
          for (var j = 0; j < word.length; j += width) {
            result.add(word.substring(j, min(word.length, j + width)));
          }
        } else {
          buffer.write(word);
        }
        i++;
      } else if (buffer.length + 1 + word.length <= width) {
        buffer.write(' ');
        buffer.write(word);
        i++;
      } else {
        if (buffer.isNotEmpty) {
          result.add(buffer.toString());
          buffer.clear();
        }
      }
    }
    if (buffer.isNotEmpty) {
      result.add(buffer.toString());
    }
    return result.join('\n');
  }

  /// Unwraps a long text.
  String unwrap() => split('\n\n')
      .map((paragraph) => paragraph.replaceAll('\n', ' '))
      .join('\n\n');
}

final defaultWhitespace = RegExp(r'\s+');
