import 'dart:typed_data';

import '../char_matcher.dart';
import '../generated/general_categories.dart' as generated;

class UnicodeCharMatcher extends CharMatcher {
  const UnicodeCharMatcher(this.mask);

  final int mask;

  @override
  bool match(int value) => generalCategories[value] & mask != 0;
}

final generalCategories = (() {
  final output = Int32List(generated.generalCategoriesLength);
  for (var i = 0, o = 0; o < generated.generalCategoriesLength;) {
    final i1 = generated.generalCategories[i++];
    if (i1 < 0) {
      final i2 = generated.generalCategories[i++];
      for (var j = i1; j < 0; j++) {
        output[o++] = i2;
      }
    } else {
      output[o++] = i1;
    }
  }
  return output;
})();
