import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/scaffolding.dart';

import '../test_utils.dart';

void main() {
  group('list', () {
    group('constructor', () {
      test('empty', () {
        final map = ListMultimap<String, int>();
        check(map).isEmpty();
        check(map).length.equals(0);
        check(map.isEmpty).isTrue();
        check(map.isNotEmpty).isFalse();
        check(map.asMap()).isEmpty();
        check(map.asMap().length).equals(0);
        check(map.keys).isEmpty();
        check(map.values).isEmpty();
        check(map.entries).isEmpty();
      });
      test('of', () {
        final map = ListMultimap.of(
          ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]),
        );
        check(map).length.equals(3);
        check(map.isEmpty).isFalse();
        check(map.isNotEmpty).isTrue();
        check(map.keys).deepEquals(['a', 'b']);
        check(map.values).deepEquals([1, 2, 3]);
        check(map.entries).matchesEntries([('a', 1), ('b', 2), ('b', 3)]);
        check(map.asMap()).deepEquals({
          'a': [1],
          'b': [2, 3],
        });
        check(map.asMap().length).equals(2);
        check(map['a']).deepEquals([1]);
        check(map['b']).deepEquals([2, 3]);
      });
      test('identity', () {
        final map = ListMultimap<String, int>.identity();
        check(map).isEmpty();
        check(map).length.equals(0);
        check(map.asMap()).isEmpty();
        check(map.keys).isEmpty();
        check(map.values).isEmpty();
        check(map.entries).isEmpty();
      });
      test('fromIterable', () {
        final map = ListMultimap<String, int>.fromIterable(
          IntegerRange(3),
          key: (i) => String.fromCharCode((i as int) + 97),
          value: (i) => (i as int) + 1,
        );
        check(map).length.equals(3);
        check(map.keys).deepEquals(['a', 'b', 'c']);
        check(map.values).deepEquals([1, 2, 3]);
        check(map.entries).matchesEntries([('a', 1), ('b', 2), ('c', 3)]);
        check(map.asMap()).deepEquals({
          'a': [1],
          'b': [2],
          'c': [3],
        });
        check(map['a']).deepEquals([1]);
        check(map['b']).deepEquals([2]);
        check(map['c']).deepEquals([3]);
      });
      test('fromIterable (no providers)', () {
        final map = ListMultimap<int, int>.fromIterable(IntegerRange(3));
        check(map).length.equals(3);
        check(map.keys).deepEquals([0, 1, 2]);
        check(map.values).deepEquals([0, 1, 2]);
        check(map.entries).matchesEntries([(0, 0), (1, 1), (2, 2)]);
        check(map.asMap()).deepEquals({
          0: [0],
          1: [1],
          2: [2],
        });
        check(map[0]).deepEquals([0]);
        check(map[1]).deepEquals([1]);
        check(map[2]).deepEquals([2]);
      });
      test('fromIterables', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        check(map).length.equals(3);
        check(map.keys).deepEquals(['a', 'b']);
        check(map.values).deepEquals([1, 2, 3]);
        check(map.entries).matchesEntries([('a', 1), ('b', 2), ('b', 3)]);
        check(map.asMap()).deepEquals({
          'a': [1],
          'b': [2, 3],
        });
        check(map['a']).deepEquals([1]);
        check(map['b']).deepEquals([2, 3]);
      });
      test('fromIterables (error)', () {
        check(() => ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2]))
            .throws<ArgumentError>();
      });
      test('fromEntries', () {
        final map = ListMultimap.fromEntries(const [
          MapEntry('a', 1),
          MapEntry('b', 2),
          MapEntry('b', 3),
        ]);
        check(map).length.equals(3);
        check(map.keys).deepEquals(['a', 'b']);
        check(map.values).deepEquals([1, 2, 3]);
        check(map.entries).matchesEntries([('a', 1), ('b', 2), ('b', 3)]);
        check(map.asMap()).deepEquals({
          'a': [1],
          'b': [2, 3],
        });
        check(map['a']).deepEquals([1]);
        check(map['b']).deepEquals([2, 3]);
      });
      test('map converter', () {
        final target = {'a': 1, 'b': 2, 'c': 3}.toListMultimap();
        check(target.keys).deepEquals(['a', 'b', 'c']);
        check(target.values).deepEquals([1, 2, 3]);
        check(target.entries).matchesEntries([('a', 1), ('b', 2), ('c', 3)]);
        check(target.asMap()).deepEquals({
          'a': [1],
          'b': [2],
          'c': [3],
        });
      });
      test('iterable converter', () {
        final target = [
          'a',
          'abb',
          'abb',
          'bb',
        ].toListMultimap(key: (e) => e[0], value: (e) => e.length);
        check(target.keys).deepEquals(['a', 'b']);
        check(target.values).deepEquals([1, 3, 3, 2]);
        check(target.entries)
            .matchesEntries([('a', 1), ('a', 3), ('a', 3), ('b', 2)]);
        check(target.asMap()).deepEquals({
          'a': [1, 3, 3],
          'b': [2],
        });
      });
      test('iterable converter (no providers)', () {
        final target = ['a', 'b', 'b'].toListMultimap<String, String>();
        check(target.keys).deepEquals(['a', 'b']);
        check(target.values).deepEquals(['a', 'b', 'b']);
        check(target.entries)
            .matchesEntries([('a', 'a'), ('b', 'b'), ('b', 'b')]);
        check(target.asMap()).deepEquals({
          'a': ['a'],
          'b': ['b', 'b'],
        });
      });
    });
    group('accessor', () {
      test('containsKey', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        check(map.containsKey('a')).isTrue();
        check(map.containsKey('b')).isTrue();
        check(map.containsKey('c')).isFalse();
      });
      test('containsValue', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        check(map.containsValue(1)).isTrue();
        check(map.containsValue(2)).isTrue();
        check(map.containsValue(3)).isTrue();
        check(map.containsValue(4)).isFalse();
      });
      test('containsEntry', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        check(map.containsEntry('a', 1)).isTrue();
        check(map.containsEntry('a', 2)).isFalse();
        check(map.containsEntry('c', 3)).isFalse();
      });
      test('read', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        check(map['a']).deepEquals([1]);
        check(map['b']).deepEquals([2, 3]);
      });
      test('write', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        map['a'][0] = 4;
        map['b'][0] = 5;
        map['b'][1] = 6;
        check(map['a']).deepEquals([4]);
        check(map['b']).deepEquals([5, 6]);
      });
    });
    group('modifiers', () {
      test('add', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.add('b', 4);
        check(map).length.equals(4);
        check(collection).deepEquals([2, 3, 4]);
      });
      test('addAll', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.addAll('b', [3, 4, 5]);
        check(map).length.equals(6);
        check(collection).deepEquals([2, 3, 3, 4, 5]);
      });
      test('length increase', () {
        final map = ListMultimap<String, int?>();
        final collection = map['c'];
        collection.length = 3;
        check(map).length.equals(3);
        check(collection).deepEquals([null, null, null]);
      });
      test('length decrease', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        collection.length = 1;
        check(map).length.equals(2);
        check(collection).deepEquals([2]);
      });
      test('length zero', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        collection.length = 0;
        check(map).length.equals(1);
        check(collection).isEmpty();
      });
      test('remove', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.remove('b', 3);
        check(map).length.equals(2);
        check(collection).deepEquals([2]);
      });
      test('removeAll', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.removeAll('b');
        check(map).length.equals(1);
        check(collection).isEmpty();
      });
      test('removeAll with list', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.removeAll('b', [3]);
        check(map).length.equals(2);
        check(collection).deepEquals([2]);
      });
      test('replace', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.replace('b', 4);
        check(map).length.equals(2);
        check(collection).deepEquals([4]);
      });
      test('replaceAll', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.replaceAll('b', [3, 4, 5]);
        check(map).length.equals(4);
        check(collection).deepEquals([3, 4, 5]);
      });
      test('clear', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.clear();
        check(map).isEmpty();
        check(collection).isEmpty();
      });
    });
    group('views', () {
      group('values', () {
        test('refresh empty', () {
          final map = ListMultimap<String, int>();
          final keyView1 = map['a'];
          final keyView2 = map['a'];
          check(keyView1).not((it) => it.identicalTo(keyView2));
          keyView1.add(1);
          check(keyView1).deepEquals([1]);
          check(keyView2).deepEquals([1]);
        });
        test('refresh full', () {
          final map = ListMultimap.fromIterables(['a'], [1]);
          final keyView1 = map['a'];
          final keyView2 = map['a'];
          check(keyView1).not((it) => it.identicalTo(keyView2));
          keyView1.add(2);
          check(keyView1).deepEquals([1, 2]);
          check(keyView2).deepEquals([1, 2]);
        });
      });
      group('asMap', () {
        test('access', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          check(mapView['b']).isNotNull().deepEquals([2, 3]);
          mapView['b'] = [4, 5, 6];
          check(map['b']).deepEquals([4, 5, 6]);
          check(mapView['b']).isNotNull().deepEquals([4, 5, 6]);
        });
        test('clear', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          mapView.clear();
          check(map).isEmpty();
          check(mapView).isEmpty();
        });
        test('remove', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          mapView.remove('b');
          check(map.keys).deepEquals(['a']);
          check(mapView.keys).deepEquals(['a']);
        });
      });
      test('toString', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        check(map.toString()).equals('{a: [1], b: [2, 3]}');
      });
    });
  });
}
