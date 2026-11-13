import 'package:web/web.dart' as web;

import '../dom_utils.dart';
import '../state.dart';

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
