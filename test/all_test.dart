import 'package:test/test.dart';

import 'async_test.dart' as async_test;
import 'cache_test.dart' as cache_test;
import 'char_matcher_test.dart' as char_matcher_test;
import 'collection_test.dart' as collection_test;
import 'feature_test.dart' as feature_test;
import 'hash_test.dart' as hash_test;
import 'iterable_test.dart' as iterable_test;
import 'math_test.dart' as math_test;
import 'number_test.dart' as number_test;
import 'optional_test.dart' as optional_test;
import 'ordering_test.dart' as ordering_test;
import 'printer_test.dart' as printer_test;
import 'tuple_test.dart' as tuple_test;

void main() {
  group('async', async_test.main);
  group('cache', cache_test.main);
  group('char_matcher', char_matcher_test.main);
  group('collection', collection_test.main);
  group('feature', feature_test.main);
  group('hash', hash_test.main);
  group('iterable', iterable_test.main);
  group('math', math_test.main);
  group('number', number_test.main);
  group('optional', optional_test.main);
  group('ordering', ordering_test.main);
  group('printer', printer_test.main);
  group('tuple', tuple_test.main);
}
