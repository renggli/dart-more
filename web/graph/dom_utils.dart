import 'package:web/web.dart' as web;

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

/// Creates a `<p>` element with optional [text].
web.HTMLParagraphElement p([String? text]) {
  final el = _create<web.HTMLParagraphElement>('p');
  if (text != null) el.textContent = text;
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
