extension PartitionStringExtension on String {
  /// Splits the string at the first occurrence of [pattern].
  ///
  /// Returns a list containing the part before the separator, the separator
  /// itself, and the part after the separator. If the [pattern] is not found,
  /// return a list with this string followed by two empty strings.
  List<String> partition(Pattern pattern, [int start = 0]) {
    final i = indexOf(pattern, start);
    if (i == -1) return [this, '', ''];
    final j =
        pattern is String
            ? i + pattern.length
            : pattern.matchAsPrefix(this, i)!.end;
    return [substring(0, i), substring(i, j), substring(j)];
  }

  /// Splits the string at the last occurrence of [pattern].
  ///
  /// Returns a list containing the part before the separator, the separator
  /// itself, and the part after the separator. If the [pattern] is not found,
  /// return a list two empty strings followed by this string.
  List<String> lastPartition(Pattern pattern, [int? start]) {
    final i = lastIndexOf(pattern, start);
    if (i == -1) return ['', '', this];
    final j =
        pattern is String
            ? i + pattern.length
            : pattern.matchAsPrefix(this, i)!.end;
    return [substring(0, i), substring(i, j), substring(j)];
  }
}
