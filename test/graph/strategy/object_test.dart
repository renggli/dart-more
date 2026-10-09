import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('object', () {
    final strategy = StorageStrategy<String>.object();
    test('set', () {
      final set = strategy.createSet();
      set.addAll(['foo', 'bar', 'foo']);
      check(set).length.equals(2);
      check(set).unorderedEquals(['foo', 'bar']);
    });
    test('map', () {
      final map = strategy.createMap<int>();
      map['foo'] = 42;
      map['bar'] = 43;
      check(map).length.equals(2);
      check(map).deepEquals({'foo': 42, 'bar': 43});
    });
  });
}
