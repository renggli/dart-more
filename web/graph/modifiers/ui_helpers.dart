import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../state.dart';

/// Mode for displaying vertices and edges excluded or removed by a modifier.
enum RemovedMode {
  dim('dim', 'Dim removed'),
  hide('hide', 'Hide removed');

  new(this.id, this.label);

  /// Unique identifier.
  final String id;

  /// User-facing display label.
  final String label;

  /// Looks up [RemovedMode] by [id], defaulting to [RemovedMode.dim].
  static RemovedMode fromId(String id) =>
      values.firstWhere((m) => m.id == id, orElse: () => RemovedMode.dim);
}

/// Shared styling and output configuration for modifiers.
class OutputStyleOptions {
  new({
    String color = '#10b981',
    String pattern = 'none',
    RemovedMode removedMode = RemovedMode.dim,
    this.hasRemovedMode = false,
  }) : color = color,
       pattern = pattern,
       removedMode = removedMode,
       _defaultColor = color,
       _defaultPattern = pattern,
       _defaultRemovedMode = removedMode;

  String color;
  String pattern;
  RemovedMode removedMode;
  final bool hasRemovedMode;

  final String _defaultColor;
  final String _defaultPattern;
  final RemovedMode _defaultRemovedMode;

  /// Resets visual styling options back to their initial defaults.
  void resetDefaults() {
    color = _defaultColor;
    pattern = _defaultPattern;
    removedMode = _defaultRemovedMode;
  }

  /// Serializes output styling settings to a JSON map.
  Map<String, dynamic> toJson() => {
    'color': color,
    'pattern': pattern,
    if (hasRemovedMode) 'removedMode': removedMode.id,
  };

  /// Restores output styling settings from [json].
  void applyJson(Map<String, dynamic> json) {
    if (json['color'] case final String c) color = c;
    if (json['pattern'] case final String p) pattern = p;
    if (json['removedMode'] case final String rm) {
      removedMode = RemovedMode.fromId(rm);
    }
  }

  /// Converted dash pattern string (or null if none).
  String? get dashPattern => pattern != 'none' ? pattern : null;

  /// Converted highlight color string (or null if none).
  String? get highlightColor => color != 'none' ? color : null;

  /// Appends standard styling controls (color, line pattern, and optional removed mode) to [root].
  void buildUI(
    web.HTMLElement root,
    void Function() onModified, {
    String colorLabel = 'Highlight Color:',
    String patternLabel = 'Line Style:',
    String removedLabel = 'Show Removed as:',
  }) {
    root.appendChild(
      colorSetting(
        colorLabel,
        color,
        onChanged: (c) {
          color = c;
          onModified();
        },
      ),
    );
    root.appendChild(
      lineStyleSetting(
        patternLabel,
        pattern,
        onChanged: (p) {
          pattern = p;
          onModified();
        },
      ),
    );
    if (hasRemovedMode) {
      root.appendChild(
        dropdownSetting(
          removedLabel,
          removedMode.id,
          [for (final m in RemovedMode.values) (m.id, m.label)],
          onChanged: (val) {
            removedMode = RemovedMode.fromId(val);
            onModified();
          },
        ),
      );
    }
  }
}

/// Builds an accessible vertex selection dropdown within a stacked field.
web.HTMLElement vertexField(
  String labelText,
  AppState state,
  String? currentVal,
  String defaultLabel,
  void Function(String?) onChange,
) {
  final s = selectElement();
  s.className = 'vertex-select';
  s.setAttribute('data-default', defaultLabel);
  s.appendChild(optionElement('', defaultLabel));
  for (final v in state.renderGraph.vertices) {
    s.appendChild(optionElement(v, v));
  }
  s.value = currentVal ?? '';
  s.onChange.listen((_) {
    onChange(s.value.isEmpty ? null : s.value);
  });
  return stackedField(labelText, s);
}
