extension PrefixSuffixStringExtension on String {
  /// If the string starts with the prefix pattern returns this [String]
  /// with the prefix removed, otherwise return `this`.
  String removePrefix(Pattern pattern) {
    if (pattern is String && startsWith(pattern)) {
      return substring(pattern.length);
    }
    final match = pattern.matchAsPrefix(this);
    if (match != null && match.end > 0) {
      return substring(match.end);
    }
    return this;
  }

  /// If the string ends with the suffix, return this [String] with the suffix
  /// removed, otherwise return `this`.
  String removeSuffix(String other) {
    if (endsWith(other)) {
      return substring(0, length - other.length);
    }
    return this;
  }
}
