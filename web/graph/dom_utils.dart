import 'dart:js_interop';
import 'dart:math' as math;

import 'package:web/web.dart' as web;

final math.Random _seedRandom = math.Random();

T _create<T extends web.HTMLElement>(String tag) =>
    web.document.createElement(tag) as T;

/// Creates a `<div>` element with an optional [className].
web.HTMLDivElement div([String? className]) {
  final el = _create<web.HTMLDivElement>('div');
  if (className != null) el.className = className;
  return el;
}

/// Creates a `<span>` element with optional [text] and [className].
web.HTMLSpanElement span([String? text, String? className]) {
  final el = _create<web.HTMLSpanElement>('span');
  if (text != null) el.textContent = text;
  if (className != null) el.className = className;
  return el;
}

/// Creates a `<p>` element with optional [text] and [className].
web.HTMLParagraphElement p([String? text, String? className]) {
  final el = _create<web.HTMLParagraphElement>('p');
  if (text != null) el.textContent = text;
  if (className != null) el.className = className;
  return el;
}

web.HTMLInputElement _input(String type, [num? value, num? min, num? max]) {
  final el = _create<web.HTMLInputElement>('input');
  el.type = type;
  if (value != null) el.value = value.toString();
  if (min != null) el.min = min.toString();
  if (max != null) el.max = max.toString();
  return el;
}

/// Creates an `<input type="number">` element.
web.HTMLInputElement numberInput([num? value, num? min, num? max]) =>
    _input('number', value, min, max);

/// Creates an `<input type="range">` element.
web.HTMLInputElement rangeInput([num? value, num? min, num? max]) =>
    _input('range', value, min, max);

/// Creates a `<button>` element with optional [text] and [className].
web.HTMLButtonElement button([String? text, String? className]) {
  final el = _create<web.HTMLButtonElement>('button');
  el.type = 'button';
  if (text != null) el.textContent = text;
  if (className != null) el.className = className;
  return el;
}

/// Creates a `<label>` element with optional [text].
web.HTMLLabelElement label([String? text]) {
  final el = _create<web.HTMLLabelElement>('label');
  if (text != null) el.textContent = text;
  return el;
}

/// Creates a `<select>` element with an optional [id].
web.HTMLSelectElement selectElement([String? id]) {
  final el = _create<web.HTMLSelectElement>('select');
  if (id != null) el.id = id;
  return el;
}

/// Creates an `<option>` element with optional [value] and [text].
web.HTMLOptionElement optionElement([String? value, String? text]) {
  final el = _create<web.HTMLOptionElement>('option');
  if (value != null) el.value = value;
  if (text != null) el.text = text;
  return el;
}

/// Creates a `<table>` element with an optional [className].
web.HTMLTableElement tableElement([String? className]) {
  final el = _create<web.HTMLTableElement>('table');
  if (className != null) el.className = className;
  return el;
}

// ---------------------------------------------------------------------------
// Shared Setting Components
// ---------------------------------------------------------------------------

/// Wraps [control] in a labeled vertical stack row.
web.HTMLElement stackedField(String labelText, web.HTMLElement control) {
  final group = div('form-field-stacked');
  group.appendChild(label(labelText));
  group.appendChild(control);
  return group;
}

/// Shared integer number setting component.
web.HTMLElement intSetting(
  String labelText,
  int value, {
  required int min,
  required int max,
  required void Function(int value) onChanged,
}) {
  final input = numberInput(value, min, max)..step = '1';
  void handleUpdate() {
    final parsed = int.tryParse(input.value);
    if (parsed != null) {
      onChanged(parsed.clamp(min, max));
    }
  }

  input.onInput.listen((_) => handleUpdate());
  input.onChange.listen((_) => handleUpdate());
  return stackedField(labelText, input);
}

/// Shared optional integer setting component (blank means null / Any).
web.HTMLElement optionalIntSetting(
  String labelText,
  int? value, {
  required int min,
  required int max,
  String placeholder = 'Any',
  required void Function(int? value) onChanged,
}) {
  final input = numberInput(value, min, max)
    ..step = '1'
    ..placeholder = placeholder;
  if (value == null) input.value = '';
  void handleUpdate() {
    final raw = input.value.trim();
    if (raw.isEmpty) {
      onChanged(null);
      return;
    }
    final parsed = int.tryParse(raw);
    onChanged(parsed?.clamp(min, max));
  }

  input.onInput.listen((_) => handleUpdate());
  input.onChange.listen((_) => handleUpdate());
  return stackedField(labelText, input);
}

/// Shared synchronized slider + number input range setting component.
web.HTMLElement rangeSetting(
  String labelText,
  num value, {
  required num min,
  required num max,
  num step = 1,
  required void Function(num value) onChanged,
}) {
  final row = div('setting-range-row');
  final slider = rangeInput(value, min, max)..step = step.toString();
  final numBox = numberInput(value, min, max)..step = step.toString();

  num? parseVal(String raw) =>
      step is int ? int.tryParse(raw) : double.tryParse(raw);

  slider.onInput.listen((_) {
    final parsed = parseVal(slider.value);
    if (parsed != null) {
      final clamped = parsed.clamp(min, max);
      numBox.value = clamped.toString();
      onChanged(clamped);
    }
  });
  void onNumInput() {
    final parsed = parseVal(numBox.value);
    if (parsed != null) {
      final clamped = parsed.clamp(min, max);
      slider.value = clamped.toString();
      onChanged(clamped);
    }
  }

  numBox.onInput.listen((_) => onNumInput());
  numBox.onChange.listen((_) => onNumInput());

  row.appendChild(slider);
  row.appendChild(numBox);
  return stackedField(labelText, row);
}

/// Shared random seed setting with a number input and a randomize button on the right.
web.HTMLElement seedSetting(
  String labelText,
  int value, {
  required void Function(int value) onChanged,
}) {
  final row = div('setting-seed-row');
  final input = numberInput(value, 0, 999999)..step = '1';

  void handleInput() {
    final parsed = int.tryParse(input.value);
    if (parsed != null) {
      onChanged(parsed.clamp(0, 999999));
    }
  }

  input.onInput.listen((_) => handleInput());
  input.onChange.listen((_) => handleInput());

  final randomBtn = button(null, 'setting-seed-btn')
    ..title = 'Randomize Seed'
    ..innerHTML =
        '<svg width="14" height="14" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round">'
                '<rect x="2" y="2" width="12" height="12" rx="2.5"/>'
                '<circle cx="5.5" cy="5.5" r="1" fill="currentColor" stroke="none"/>'
                '<circle cx="10.5" cy="5.5" r="1" fill="currentColor" stroke="none"/>'
                '<circle cx="8" cy="8" r="1" fill="currentColor" stroke="none"/>'
                '<circle cx="5.5" cy="10.5" r="1" fill="currentColor" stroke="none"/>'
                '<circle cx="10.5" cy="10.5" r="1" fill="currentColor" stroke="none"/>'
                '</svg>'
            .toJS;

  randomBtn.onClick.listen((_) {
    final nextSeed = _seedRandom.nextInt(1000000);
    input.value = nextSeed.toString();
    onChanged(nextSeed);
  });

  row.appendChild(input);
  row.appendChild(randomBtn);
  return stackedField(labelText, row);
}

/// Shared option dropdown setting component.
web.HTMLElement dropdownSetting(
  String labelText,
  String value,
  List<(String, String)> options, {
  required void Function(String value) onChanged,
}) {
  final select = selectElement();
  for (final (optVal, optLabel) in options) {
    select.appendChild(optionElement(optVal, optLabel));
  }
  select.value = value;
  select.onChange.listen((_) => onChanged(select.value));
  return stackedField(labelText, select);
}

/// Shared checkbox setting component.
web.HTMLElement checkboxSetting(
  String labelText,
  bool checked, {
  required void Function(bool checked) onChanged,
}) {
  final row = _create<web.HTMLLabelElement>('label')
    ..className = 'setting-checkbox-row';
  final checkbox = _input('checkbox')..checked = checked;
  checkbox.onChange.listen((_) => onChanged(checkbox.checked));
  row.appendChild(checkbox);
  row.appendChild(span(labelText));
  return row;
}

/// Default palette of preset colors for [colorSetting].
const List<(String, String)> presetColors = [
  ('#ef4444', 'Red'),
  ('#f97316', 'Orange'),
  ('#f59e0b', 'Amber'),
  ('#10b981', 'Emerald'),
  ('#06b6d4', 'Cyan'),
  ('#38bdf8', 'Sky Blue'),
  ('#3b82f6', 'Blue'),
  ('#a855f7', 'Purple'),
  ('#ec4899', 'Pink'),
  ('#94a3b8', 'Slate'),
];

/// Shared color picker setting with a no-op option, clickable swatches, and a custom color input.
web.HTMLElement colorSetting(
  String labelText,
  String initialColor, {
  required void Function(String color) onChanged,
}) {
  final picker = div('setting-color-picker');
  final swatchButtons = <String, web.HTMLButtonElement>{};

  final noneSwatch = button(null, 'color-swatch color-swatch-none')
    ..title = 'None'
    ..innerHTML =
        '<svg width="11" height="11" viewBox="0 0 12 12" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round">'
                '<line x1="2.5" y1="9.5" x2="9.5" y2="2.5"/>'
                '</svg>'
            .toJS;

  final customSwatch = _create<web.HTMLLabelElement>('label')
    ..className = 'color-swatch color-custom-swatch'
    ..title = 'Custom Color'
    ..innerHTML =
        '<svg width="11" height="11" viewBox="0 0 16 16" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">'
                '<path d="M11 2l3 3-7.5 7.5H3.5v-3L11 2z"/>'
                '<path d="M9.5 3.5l3 3"/>'
                '</svg>'
            .toJS;

  final customInput = _input('color')
    ..className = 'color-custom-input'
    ..value = initialColor.startsWith('#') && initialColor.length == 7
        ? initialColor
        : '#38bdf8';
  customSwatch.appendChild(customInput);

  void updateActive(String activeColor) {
    final normalized = activeColor.trim().toLowerCase();
    final isNone = normalized.isEmpty || normalized == 'none';
    noneSwatch.classList.toggle('active', isNone);

    var matchedPreset = false;
    for (final entry in swatchButtons.entries) {
      final isMatch = !isNone && entry.key == normalized;
      entry.value.classList.toggle('active', isMatch);
      if (isMatch) matchedPreset = true;
    }

    final isCustom = !isNone && !matchedPreset;
    customSwatch.classList.toggle('active', isCustom);
    if (activeColor.startsWith('#') && activeColor.length == 7) {
      customInput.value = activeColor;
    }
    customSwatch.style.backgroundColor = isCustom ? activeColor : '';
  }

  noneSwatch.onClick.listen((_) {
    updateActive('none');
    onChanged('none');
  });
  picker.appendChild(noneSwatch);

  for (final (hex, name) in presetColors) {
    final swatch = button(null, 'color-swatch')
      ..title = '$name ($hex)'
      ..style.backgroundColor = hex;
    swatchButtons[hex.toLowerCase()] = swatch;
    swatch.onClick.listen((_) {
      updateActive(hex);
      onChanged(hex);
    });
    picker.appendChild(swatch);
  }

  customInput.onInput.listen((_) {
    final hex = customInput.value;
    updateActive(hex);
    onChanged(hex);
  });
  picker.appendChild(customSwatch);
  updateActive(initialColor);

  return stackedField(labelText, picker);
}

/// Default line dash patterns for [lineStyleSetting].
const List<(String, String)> presetLineStyles = [
  ('none', 'Solid'),
  ('6,4', 'Dashed'),
  ('2,3', 'Dotted'),
  ('10,4', 'Long Dash'),
  ('8,3,2,3', 'Dash-Dot'),
];

/// Shared line style picker component with visual SVG previews.
web.HTMLElement lineStyleSetting(
  String labelText,
  String initialPattern, {
  required void Function(String pattern) onChanged,
}) {
  final picker = div('setting-line-picker');
  final buttons = <String, web.HTMLButtonElement>{};

  void updateActive(String activePattern) {
    for (final entry in buttons.entries) {
      entry.value.classList.toggle('active', entry.key == activePattern);
    }
  }

  for (final (pattern, name) in presetLineStyles) {
    final dashAttr = pattern == 'none' ? '' : 'stroke-dasharray="$pattern"';
    final btn = button(null, 'line-style-btn')
      ..title = name
      ..innerHTML =
          '<svg width="32" height="10" viewBox="0 0 32 10">'
                  '<line x1="2" y1="5" x2="30" y2="5" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" $dashAttr />'
                  '</svg>'
              .toJS;
    buttons[pattern] = btn;
    btn.onClick.listen((_) {
      updateActive(pattern);
      onChanged(pattern);
    });
    picker.appendChild(btn);
  }

  updateActive(initialPattern);
  return stackedField(labelText, picker);
}
