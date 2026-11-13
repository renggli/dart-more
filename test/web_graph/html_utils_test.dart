@TestOn('browser')
library;

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

import '../../web/graph/dom_utils.dart';

void main() {
  group('html_utils', () {
    test('escapeHtml handles special characters', () {
      check(escapeHtml('<img src="x" onerror=alert(1)>'))
          .equals('&lt;img src=&quot;x&quot; onerror=alert(1)&gt;');
      check(escapeHtml("a & b ' c \" d < e > f"))
          .equals('a &amp; b &#39; c &quot; d &lt; e &gt; f');
    });
  });
}
