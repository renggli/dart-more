// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'package:more/collection.dart';
import 'package:test/test.dart';

import 'utils/collection.dart';

void main() {
  group('list', () {
    group('constructor', () {
      test('empty', () {
        final map = ListMultimap<String, int>();
        expect(map, isEmpty);
        expect(map, hasLength(0));
        expect(map.isEmpty, isTrue);
        expect(map.isNotEmpty, isFalse);
        expect(map.asMap(), isEmpty);
        expect(map.keys, isEmpty);
        expect(map.values, isEmpty);
        expect(map.entries, isEmpty);
      });
      test('of', () {
        final map = ListMultimap.of(
          ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]),
        );
        expect(map, hasLength(3));
        expect(map.isEmpty, isFalse);
        expect(map.isNotEmpty, isTrue);
        expect(map.keys, ['a', 'b']);
        expect(map.values, [1, 2, 3]);
        expect(map.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('b', 3),
        ]);
        expect(map.asMap(), {
          'a': [1],
          'b': [2, 3],
        });
        expect(map['a'], [1]);
        expect(map['b'], [2, 3]);
      });
      test('identity', () {
        final map = ListMultimap<String, int>.identity();
        expect(map, isEmpty);
        expect(map, hasLength(0));
        expect(map.asMap(), isEmpty);
        expect(map.keys, isEmpty);
        expect(map.values, isEmpty);
        expect(map.entries, isEmpty);
      });
      test('fromIterable', () {
        final map = ListMultimap<String, int>.fromIterable(
          IntegerRange(3),
          key: (i) => String.fromCharCode((i as int) + 97),
          value: (i) => (i as int) + 1,
        );
        expect(map, hasLength(3));
        expect(map.keys, ['a', 'b', 'c']);
        expect(map.values, [1, 2, 3]);
        expect(map.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('c', 3),
        ]);
        expect(map.asMap(), {
          'a': [1],
          'b': [2],
          'c': [3],
        });
        expect(map['a'], [1]);
        expect(map['b'], [2]);
        expect(map['c'], [3]);
      });
      test('fromIterable (no providers)', () {
        final map = ListMultimap<int, int>.fromIterable(IntegerRange(3));
        expect(map, hasLength(3));
        expect(map.keys, [0, 1, 2]);
        expect(map.values, [0, 1, 2]);
        expect(map.entries, [
          isMapEntry(0, 0),
          isMapEntry(1, 1),
          isMapEntry(2, 2),
        ]);
        expect(map.asMap(), {
          0: [0],
          1: [1],
          2: [2],
        });
        expect(map[0], [0]);
        expect(map[1], [1]);
        expect(map[2], [2]);
      });
      test('fromIterables', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map, hasLength(3));
        expect(map.keys, ['a', 'b']);
        expect(map.values, [1, 2, 3]);
        expect(map.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('b', 3),
        ]);
        expect(map.asMap(), {
          'a': [1],
          'b': [2, 3],
        });
        expect(map['a'], [1]);
        expect(map['b'], [2, 3]);
      });
      test('fromIterables (error)', () {
        expect(
          () => ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2]),
          throwsArgumentError,
        );
      });
      test('fromEntries', () {
        final map = ListMultimap.fromEntries(const [
          MapEntry('a', 1),
          MapEntry('b', 2),
          MapEntry('b', 3),
        ]);
        expect(map, hasLength(3));
        expect(map.keys, ['a', 'b']);
        expect(map.values, [1, 2, 3]);
        expect(map.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('b', 3),
        ]);
        expect(map.asMap(), {
          'a': [1],
          'b': [2, 3],
        });
        expect(map['a'], [1]);
        expect(map['b'], [2, 3]);
      });
      test('map converter', () {
        final target = {'a': 1, 'b': 2, 'c': 3}.toListMultimap();
        expect(target.keys, ['a', 'b', 'c']);
        expect(target.values, [1, 2, 3]);
        expect(target.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('c', 3),
        ]);
        expect(target.asMap(), {
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
        expect(target.keys, ['a', 'b']);
        expect(target.values, [1, 3, 3, 2]);
        expect(target.entries, [
          isMapEntry('a', 1),
          isMapEntry('a', 3),
          isMapEntry('a', 3),
          isMapEntry('b', 2),
        ]);
        expect(target.asMap(), {
          'a': [1, 3, 3],
          'b': [2],
        });
      });
      test('iterable converter (no providers)', () {
        final target = ['a', 'b', 'b'].toListMultimap<String, String>();
        expect(target.keys, ['a', 'b']);
        expect(target.values, ['a', 'b', 'b']);
        expect(target.entries, [
          isMapEntry('a', 'a'),
          isMapEntry('b', 'b'),
          isMapEntry('b', 'b'),
        ]);
        expect(target.asMap(), {
          'a': ['a'],
          'b': ['b', 'b'],
        });
      });
    });
    group('accessor', () {
      test('containsKey', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map.containsKey('a'), isTrue);
        expect(map.containsKey('b'), isTrue);
        expect(map.containsKey('c'), isFalse);
      });
      test('containsValue', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map.containsValue(1), isTrue);
        expect(map.containsValue(2), isTrue);
        expect(map.containsValue(3), isTrue);
        expect(map.containsValue(4), isFalse);
      });
      test('containsEntry', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map.containsEntry('a', 1), isTrue);
        expect(map.containsEntry('a', 2), isFalse);
        expect(map.containsEntry('c', 3), isFalse);
      });
      test('read', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map['a'], [1]);
        expect(map['b'], [2, 3]);
      });
      test('write', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        map['a'][0] = 4;
        map['b'][0] = 5;
        map['b'][1] = 6;
        expect(map['a'], [4]);
        expect(map['b'], [5, 6]);
      });
    });
    group('modifiers', () {
      test('add', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.add('b', 4);
        expect(map, hasLength(4));
        expect(collection, [2, 3, 4]);
      });
      test('addAll', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.addAll('b', [3, 4, 5]);
        expect(map, hasLength(6));
        expect(collection, [2, 3, 3, 4, 5]);
      });
      test('length increase', () {
        final map = ListMultimap<String, int?>();
        final collection = map['c'];
        collection.length = 3;
        expect(map, hasLength(3));
        expect(collection, [null, null, null]);
      });
      test('length decrease', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        collection.length = 1;
        expect(map, hasLength(2));
        expect(collection, [2]);
      });
      test('length zero', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        collection.length = 0;
        expect(map, hasLength(1));
        expect(collection, isEmpty);
      });
      test('remove', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.remove('b', 3);
        expect(map, hasLength(2));
        expect(collection, [2]);
      });
      test('removeAll', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.removeAll('b');
        expect(map, hasLength(1));
        expect(collection, isEmpty);
      });
      test('removeAll with list', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.removeAll('b', [3]);
        expect(map, hasLength(2));
        expect(collection, [2]);
      });
      test('replace', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.replace('b', 4);
        expect(map, hasLength(2));
        expect(collection, [4]);
      });
      test('replaceAll', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.replaceAll('b', [3, 4, 5]);
        expect(map, hasLength(4));
        expect(collection, [3, 4, 5]);
      });
      test('clear', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.clear();
        expect(map, isEmpty);
        expect(collection, isEmpty);
      });
    });
    group('views', () {
      group('values', () {
        test('refresh empty', () {
          final map = ListMultimap<String, int>();
          final keyView1 = map['a'];
          final keyView2 = map['a'];
          expect(keyView1, isNot(same(keyView2)));
          keyView1.add(1);
          expect(keyView1, [1]);
          expect(keyView2, [1]);
        });
        test('refresh full', () {
          final map = ListMultimap.fromIterables(['a'], [1]);
          final keyView1 = map['a'];
          final keyView2 = map['a'];
          expect(keyView1, isNot(same(keyView2)));
          keyView1.add(2);
          expect(keyView1, [1, 2]);
          expect(keyView2, [1, 2]);
        });
      });
      group('asMap', () {
        test('access', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          expect(mapView['b'], [2, 3]);
          mapView['b'] = [4, 5, 6];
          expect(map['b'], [4, 5, 6]);
          expect(mapView['b'], [4, 5, 6]);
        });
        test('clear', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          mapView.clear();
          expect(map, isEmpty);
          expect(mapView, isEmpty);
        });
        test('remove', () {
          final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          mapView.remove('b');
          expect(map.keys, ['a']);
          expect(mapView.keys, ['a']);
        });
      });
      test('toString', () {
        final map = ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map.toString(), '{a: [1], b: [2, 3]}');
      });
    });
  });
  group('set', () {
    group('constructor', () {
      test('empty', () {
        final map = SetMultimap<String, int>();
        expect(map, isEmpty);
        expect(map, hasLength(0));
        expect(map.isEmpty, isTrue);
        expect(map.isNotEmpty, isFalse);
        expect(map.asMap(), isEmpty);
        expect(map.keys, isEmpty);
        expect(map.values, isEmpty);
        expect(map.entries, isEmpty);
      });
      test('of', () {
        final map = SetMultimap.of(
          SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]),
        );
        expect(map, hasLength(3));
        expect(map.isEmpty, isFalse);
        expect(map.isNotEmpty, isTrue);
        expect(map.keys, ['a', 'b']);
        expect(map.values, [1, 2, 3]);
        expect(map.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('b', 3),
        ]);
        expect(map.asMap(), {
          'a': [1],
          'b': [2, 3],
        });
        expect(map['a'], [1]);
        expect(map['b'], [2, 3]);
      });
      test('identity', () {
        final map = SetMultimap<String, int>.identity();
        expect(map, isEmpty);
        expect(map, hasLength(0));
        expect(map.asMap(), isEmpty);
        expect(map.keys, isEmpty);
        expect(map.values, isEmpty);
        expect(map.entries, isEmpty);
      });
      test('fromIterable', () {
        final map = SetMultimap<String, int>.fromIterable(
          IntegerRange(3),
          key: (i) => String.fromCharCode((i as int) + 97),
          value: (i) => (i as int) + 1,
        );
        expect(map, hasLength(3));
        expect(map.keys, ['a', 'b', 'c']);
        expect(map.values, [1, 2, 3]);
        expect(map.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('c', 3),
        ]);
        expect(map.asMap(), {
          'a': [1],
          'b': [2],
          'c': [3],
        });
        expect(map['a'], [1]);
        expect(map['b'], [2]);
        expect(map['c'], [3]);
      });
      test('fromIterable (no providers)', () {
        final map = SetMultimap<int, int>.fromIterable(IntegerRange(3));
        expect(map, hasLength(3));
        expect(map.keys, [0, 1, 2]);
        expect(map.values, [0, 1, 2]);
        expect(map.entries, [
          isMapEntry(0, 0),
          isMapEntry(1, 1),
          isMapEntry(2, 2),
        ]);
        expect(map.asMap(), {
          0: [0],
          1: [1],
          2: [2],
        });
        expect(map[0], [0]);
        expect(map[1], [1]);
        expect(map[2], [2]);
      });
      test('fromIterables', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map, hasLength(3));
        expect(map.keys, ['a', 'b']);
        expect(map.values, [1, 2, 3]);
        expect(map.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('b', 3),
        ]);
        expect(map.asMap(), {
          'a': [1],
          'b': [2, 3],
        });
        expect(map['a'], [1]);
        expect(map['b'], [2, 3]);
      });
      test('fromIterables (error)', () {
        expect(
          () => SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2]),
          throwsArgumentError,
        );
      });
      test('fromEntries', () {
        final map = SetMultimap.fromEntries(const [
          MapEntry('a', 1),
          MapEntry('b', 2),
          MapEntry('b', 3),
        ]);
        expect(map, hasLength(3));
        expect(map.keys, ['a', 'b']);
        expect(map.values, [1, 2, 3]);
        expect(map.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('b', 3),
        ]);
        expect(map.asMap(), {
          'a': [1],
          'b': [2, 3],
        });
        expect(map['a'], [1]);
        expect(map['b'], [2, 3]);
      });
      test('map converter', () {
        final target = {'a': 1, 'b': 2, 'c': 3}.toSetMultimap();
        expect(target.keys, ['a', 'b', 'c']);
        expect(target.values, [1, 2, 3]);
        expect(target.entries, [
          isMapEntry('a', 1),
          isMapEntry('b', 2),
          isMapEntry('c', 3),
        ]);
        expect(target.asMap(), {
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
        ].toSetMultimap(key: (e) => e[0], value: (e) => e.length);
        expect(target.keys, ['a', 'b']);
        expect(target.values, [1, 3, 2]);
        expect(target.entries, [
          isMapEntry('a', 1),
          isMapEntry('a', 3),
          isMapEntry('b', 2),
        ]);
        expect(target.asMap(), {
          'a': {1, 3},
          'b': {2},
        });
      });
      test('iterable converter (no providers)', () {
        final target = ['a', 'b', 'b'].toSetMultimap<String, String>();
        expect(target.keys, ['a', 'b']);
        expect(target.values, ['a', 'b']);
        expect(target.entries, [isMapEntry('a', 'a'), isMapEntry('b', 'b')]);
        expect(target.asMap(), {
          'a': {'a'},
          'b': {'b'},
        });
      });
    });
    group('accessors', () {
      test('containsKey', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map.containsKey('a'), isTrue);
        expect(map.containsKey('b'), isTrue);
        expect(map.containsKey('c'), isFalse);
      });
      test('containsValue', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map.containsValue(1), isTrue);
        expect(map.containsValue(2), isTrue);
        expect(map.containsValue(3), isTrue);
        expect(map.containsValue(4), isFalse);
      });
      test('containsEntry', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map.containsEntry('a', 1), isTrue);
        expect(map.containsEntry('a', 2), isFalse);
        expect(map.containsEntry('c', 3), isFalse);
      });
      test('lookup', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map['b'].lookup(2), 2);
        expect(map['b'].lookup(3), 3);
        expect(map['b'].lookup(4), null);
      });
    });
    group('modifiers', () {
      test('add', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.add('b', 4);
        expect(map, hasLength(4));
        expect(collection, [2, 3, 4]);
      });
      test('addAll', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.addAll('b', [3, 4, 5]);
        expect(map, hasLength(5));
        expect(collection, [2, 3, 4, 5]);
      });
      test('remove', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.remove('b', 3);
        expect(map, hasLength(2));
        expect(collection, [2]);
      });
      test('removeAll', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.removeAll('b');
        expect(map, hasLength(1));
        expect(collection, isEmpty);
      });
      test('removeAll with list', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.removeAll('b', [3]);
        expect(map, hasLength(2));
        expect(collection, [2]);
      });
      test('replace', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.replace('b', 4);
        expect(map, hasLength(2));
        expect(collection, [4]);
      });
      test('replaceAll', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.replaceAll('b', [3, 4, 5]);
        expect(map, hasLength(4));
        expect(collection, [3, 4, 5]);
      });
      test('clear', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        final collection = map['b'];
        map.clear();
        expect(map, isEmpty);
        expect(collection, isEmpty);
      });
    });
    group('views', () {
      group('values', () {
        test('refresh empty', () {
          final map = SetMultimap<String, int>();
          final keyView1 = map['a'];
          final keyView2 = map['a'];
          expect(keyView1, isNot(same(keyView2)));
          keyView1.add(1);
          expect(keyView1, [1]);
          expect(keyView2, [1]);
        });
        test('refresh full', () {
          final map = SetMultimap.fromIterables(['a'], [1]);
          final keyView1 = map['a'];
          final keyView2 = map['a'];
          expect(keyView1, isNot(same(keyView2)));
          keyView1.add(2);
          expect(keyView1, [1, 2]);
          expect(keyView2, [1, 2]);
        });
      });
      group('asMap', () {
        test('access', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          expect(mapView['b'], [2, 3]);
          mapView['b'] = {4, 5, 6};
          expect(map['b'], [4, 5, 6]);
          expect(mapView['b'], [4, 5, 6]);
        });
        test('clear', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          mapView.clear();
          expect(map, isEmpty);
          expect(mapView, isEmpty);
        });
        test('remove', () {
          final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
          final mapView = map.asMap();
          mapView.remove('b');
          expect(map.keys, ['a']);
          expect(mapView.keys, ['a']);
        });
      });
      test('toString', () {
        final map = SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]);
        expect(map.toString(), '{a: {1}, b: {2, 3}}');
      });
    });
  });
}
