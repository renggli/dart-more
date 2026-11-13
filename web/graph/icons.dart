/// Static SVG icon markup constants used across graph web application components.
abstract final class GraphIcons {
  /// Upward chevron arrow icon.
  static const String chevronUp =
      '<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 8 L6 4 L10 8"/></svg>';

  /// Downward chevron arrow icon.
  static const String chevronDown =
      '<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="2"><path d="M2 4 L6 8 L10 4"/></svg>';

  /// Rightward chevron arrow icon.
  static const String chevronRight =
      '<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 2 L8 6 L4 10"/></svg>';

  /// Grip / drag handle icon.
  static const String grip =
      '<svg width="10" height="14" viewBox="0 0 10 14" fill="currentColor"><circle cx="3" cy="2.5" r="1.1"/><circle cx="7" cy="2.5" r="1.1"/><circle cx="3" cy="7" r="1.1"/><circle cx="7" cy="7" r="1.1"/><circle cx="3" cy="11.5" r="1.1"/><circle cx="7" cy="11.5" r="1.1"/></svg>';

  /// Cross / remove icon.
  static const String close =
      '<svg width="12" height="12" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="2"><path d="M2.5 2.5 L9.5 9.5 M9.5 2.5 L2.5 9.5"/></svg>';
}
