import 'package:test/test.dart';

import 'async_test.dart' as async_test;
import 'cache_test.dart' as cache_test;
import 'char_matcher_test.dart' as char_matcher_test;
import 'collection_test.dart' as collection_test;
import 'comparator_test.dart' as comparator_test;
import 'feature_test.dart' as feature_test;
import 'functional_test.dart' as functional_test;
import 'functional_type_test.dart' as functional_type_test;
import 'graph_test.dart' as graph_test;
import 'interval_test.dart' as interval_test;
import 'math_test.dart' as math_test;
import 'number_test.dart' as number_test;
import 'printer_test.dart' as printer_test;
import 'temporal_test.dart' as temporal_test;
import 'tuple_test.dart' as tuple_test;

void main() {
  group('async', async_test.main);
  group('cache', cache_test.main);
  group('char_matcher', char_matcher_test.main);
  group('collection', collection_test.main);
  group('comparator', comparator_test.main);
  group('feature', feature_test.main);
  group('functional', functional_test.main);
  group('functional type', functional_type_test.main);
  group('graph', graph_test.main);
  group('interval', interval_test.main);
  group('math', math_test.main);
  group('number', number_test.main);
  group('printer', printer_test.main);
  group('temporal', temporal_test.main);
  group('tuple', tuple_test.main);
}
