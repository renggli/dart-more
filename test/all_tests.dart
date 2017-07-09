library more.test.all_tests;

import 'package:test/test.dart';

import 'char_matcher_test.dart' as char_matcher_test;
import 'collection_test.dart' as collection_test;
import 'fraction_test.dart' as fraction_test;
import 'int_math_test.dart' as int_math_test;
import 'iterable_test.dart' as iterable_test;
import 'ordering_test.dart' as ordering_test;

void main() {
  group('char_matcher', char_matcher_test.main);
  group('collection', collection_test.main);
  group('fraction', fraction_test.main);
  group('int_math', int_math_test.main);
  group('iterable', iterable_test.main);
  group('ordering', ordering_test.main);
}
