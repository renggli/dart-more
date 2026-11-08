import 'package:web/web.dart' as web;

/// DOM element creation helpers that invoke `document.createElement` to avoid
/// the browser runtime `Illegal constructor` error thrown by `new HTML...Element()`.

web.HTMLDivElement div([String? className]) {
  final el = web.document.createElement('div') as web.HTMLDivElement;
  if (className != null) el.className = className;
  return el;
}

web.HTMLSpanElement span([String? text, String? className]) {
  final el = web.document.createElement('span') as web.HTMLSpanElement;
  if (text != null) el.textContent = text;
  if (className != null) el.className = className;
  return el;
}

web.HTMLParagraphElement p([String? text]) {
  final el = web.document.createElement('p') as web.HTMLParagraphElement;
  if (text != null) el.textContent = text;
  return el;
}

web.HTMLInputElement textInput([String? value, String? placeholder]) {
  final el = web.document.createElement('input') as web.HTMLInputElement;
  el.type = 'text';
  if (value != null) el.value = value;
  if (placeholder != null) el.placeholder = placeholder;
  return el;
}

web.HTMLInputElement numberInput([num? value, num? min, num? max]) {
  final el = web.document.createElement('input') as web.HTMLInputElement;
  el.type = 'number';
  if (value != null) el.value = value.toString();
  if (min != null) el.min = min.toString();
  if (max != null) el.max = max.toString();
  return el;
}

web.HTMLInputElement rangeInput([num? value, num? min, num? max]) {
  final el = web.document.createElement('input') as web.HTMLInputElement;
  el.type = 'range';
  if (value != null) el.value = value.toString();
  if (min != null) el.min = min.toString();
  if (max != null) el.max = max.toString();
  return el;
}

web.HTMLButtonElement button([String? text, String? className]) {
  final el = web.document.createElement('button') as web.HTMLButtonElement;
  if (text != null) el.textContent = text;
  if (className != null) el.className = className;
  return el;
}

web.HTMLLabelElement label([String? text]) {
  final el = web.document.createElement('label') as web.HTMLLabelElement;
  if (text != null) el.textContent = text;
  return el;
}

web.HTMLSelectElement selectElement([String? id]) {
  final el = web.document.createElement('select') as web.HTMLSelectElement;
  if (id != null) el.id = id;
  return el;
}

web.HTMLOptionElement optionElement([String? value, String? text]) {
  final el = web.document.createElement('option') as web.HTMLOptionElement;
  if (value != null) el.value = value;
  if (text != null) el.text = text;
  return el;
}

web.HTMLTableElement tableElement([String? className]) {
  final el = web.document.createElement('table') as web.HTMLTableElement;
  if (className != null) el.className = className;
  return el;
}
