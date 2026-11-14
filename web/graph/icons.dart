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

  /// Eye icon for enabled visibility.
  static const String eye =
      '<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>';

  /// Eye-off icon for disabled visibility.
  static const String eyeOff =
      '<svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24"/><line x1="1" y1="1" x2="23" y2="23"/></svg>';

  /// Undo / reset / counter-clockwise arrow icon.
  static const String reset =
      '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8"/><path d="M3 3v5h5"/></svg>';
}
