library more.test.all_test;

import 'package:test/test.dart';

import 'cache_test.dart' as cache_test;
import 'char_matcher_test.dart' as char_matcher_test;
import 'collection_test.dart' as collection_test;
import 'int_math_test.dart' as int_math_test;
import 'iterable_test.dart' as iterable_test;
import 'number_test.dart' as number_test;
import 'ordering_test.dart' as ordering_test;
import 'printer_test.dart' as printer_test;

void main() {
  group('cache', cache_test.main);
  group('char_matcher', char_matcher_test.main);
  group('collection', collection_test.main);
  group('int_math', int_math_test.main);
  group('iterable', iterable_test.main);
  group('number', number_test.main);
  group('ordering', ordering_test.main);
  group('printer', printer_test.main);
}
