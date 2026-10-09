import 'package:checks/checks.dart';
import 'package:more/graph.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('integer', () {
    final strategy = StorageStrategy.integer();
    test('set', () {
      final set = strategy.createSet();
      check(set.add(42)).isTrue();
      check(set.add(-43)).isTrue();
      check(set.add(42)).isFalse();
      check(set.contains(42)).isTrue();
      check(set.contains(41)).isFalse();
      check(set.contains('foo' as dynamic)).isFalse();
      check(set).unorderedEquals([42, -43]);
      check(set.length).equals(2);
      check(() => set.lookup(42)).throws<UnimplementedError>();
      check(set.remove(42)).isTrue();
      check(set.remove(42)).isFalse();
      check(set.remove('foo' as dynamic)).isFalse();
      check(set.toSet()).deepEquals({-43});
      set.clear();
      check(set).isEmpty();
    });
    test('map', () {
      final map = strategy.createMap<String>();
      map[-42] = 'foo';
      map[43] = 'bar';
      map[43] = 'baz';
      check(map[-42]).equals('foo');
      check(map[43]).equals('baz');
      check(map[44]).isNull();
      check(map['foo' as dynamic]).isNull();
      check(map.containsKey(-42)).isTrue();
      check(map.containsKey(43)).isTrue();
      check(map.containsKey(44)).isFalse();
      check(map.keys).unorderedEquals([-42, 43]);
      check(map.values).unorderedEquals(['foo', 'baz']);
      check(map.remove(-42)).equals('foo');
      check(map.remove(-42)).isNull();
      check(map.remove('foo' as dynamic)).isNull();
      map.clear();
      check(map).isEmpty();
    });
    test('map (nullable)', () {
      final map = strategy.createMap<String?>();
      map[-3] = 'foo';
      map[2] = 'bar';
      map[2] = null;
      check(map[-3]).equals('foo');
      check(map[2]).isNull();
      check(map[3]).isNull();
      check(map['foo' as dynamic]).isNull();
      check(map.containsKey(-3)).isTrue();
      check(map.containsKey(2)).isTrue();
      check(map.containsKey(3)).isFalse();
      check(map.keys).unorderedEquals([2, -3]);
      check(map.values).unorderedEquals([null, 'foo']);
      check(map.remove(2)).isNull();
      check(map.remove('foo' as dynamic)).isNull();
      map.clear();
      check(map).isEmpty();
    });
  });
}
