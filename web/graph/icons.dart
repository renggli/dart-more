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

  /// Checkmark / apply icon.
  static const String check =
      '<svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><path d="M20 6 L9 17 L4 12"/></svg>';

  /// Die / dice icon for randomizing seeds.
  static const String dice =
      '<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round">'
      '<rect x="2" y="2" width="12" height="12" rx="2.5"/>'
      '<circle cx="5.5" cy="5.5" r="1" fill="currentColor" stroke="none"/>'
      '<circle cx="10.5" cy="5.5" r="1" fill="currentColor" stroke="none"/>'
      '<circle cx="8" cy="8" r="1" fill="currentColor" stroke="none"/>'
      '<circle cx="5.5" cy="10.5" r="1" fill="currentColor" stroke="none"/>'
      '<circle cx="10.5" cy="10.5" r="1" fill="currentColor" stroke="none"/>'
      '</svg>';

  /// Diagonal slash icon for 'None' / empty selection.
  static const String slash =
      '<svg width="11" height="11" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round">'
      '<line x1="2.5" y1="9.5" x2="9.5" y2="2.5"/>'
      '</svg>';

  /// Pencil icon for custom editing.
  static const String pencil =
      '<svg width="11" height="11" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M11 2l3 3-7.5 7.5H3.5v-3L11 2z"/>'
      '<path d="M9.5 3.5l3 3"/>'
      '</svg>';

  /// Line style preview icon.
  static String linePattern(String pattern) {
    final dashAttr = pattern == 'none' ? '' : 'stroke-dasharray="$pattern"';
    return '<svg width="32" height="10" viewBox="0 0 32 10">'
        '<line x1="2" y1="5" x2="30" y2="5" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" $dashAttr />'
        '</svg>';
  }

  /// Vertex selection mode icon.
  static const String modeVertex =
      '<svg width="15" height="15" viewBox="0 0 16 16" fill="currentColor">'
      '<circle cx="8" cy="8" r="4.5" />'
      '<circle cx="8" cy="8" r="6.5" fill="none" stroke="currentColor" stroke-width="1.2" opacity="0.6" />'
      '</svg>';

  /// Edge selection mode icon.
  static const String modeEdge =
      '<svg width="15" height="15" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.8">'
      '<line x1="3" y1="13" x2="13" y2="3" />'
      '<circle cx="3" cy="13" r="2" fill="currentColor" />'
      '<circle cx="13" cy="3" r="2" fill="currentColor" />'
      '</svg>';

  /// Toggle statistics icon.
  static const String toggleStats =
      '<svg width="15" height="15" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<rect x="2" y="2" width="12" height="12" rx="2" />'
      '<path d="M5 9 L7.5 11.5 L11 5" />'
      '</svg>';

  /// Toggle labels icon.
  static const String toggleLabels =
      '<svg width="15" height="15" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'
      '<path d="M2.5 13 L6 4 L9.5 13" />'
      '<path d="M3.7 10 L8.3 10" />'
      '<path d="M11 7.5 A2 2 0 0 1 14.5 9 L14.5 13" />'
      '<path d="M14.5 10.5 A2 2 0 0 0 11 12" />'
      '</svg>';

  /// Toggle weights icon.
  static const String toggleWeights =
      '<svg width="15" height="15" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round">'
      '<line x1="3" y1="5.5" x2="13" y2="5.5" />'
      '<line x1="3" y1="10.5" x2="13" y2="10.5" />'
      '<line x1="6" y1="2.5" x2="4.5" y2="13.5" />'
      '<line x1="11.5" y1="2.5" x2="10" y2="13.5" />'
      '</svg>';
}
