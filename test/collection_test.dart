import 'dart:math';

import 'package:more/collection.dart';
import 'package:test/test.dart';

List<bool> randomBooleans(int seed, int length) {
  final list = <bool>[];
  final generator = Random(seed);
  for (var i = 0; i < length; i++) {
    list.add(generator.nextBool());
  }
  return list;
}

void main() {
  group('bi-map', () {
    final example = BiMap.of({1: 'a', 2: 'b', 3: 'c'});
    group('construction', () {
      test('empty', () {
        final target = BiMap();
        expect(target, isEmpty);
        expect(target.isEmpty, isTrue);
        expect(target.isNotEmpty, isFalse);
        expect(target, hasLength(0));
      });
      test('identity', () {
        final target = BiMap.identity();
        expect(target, isEmpty);
        expect(target.isEmpty, isTrue);
        expect(target.isNotEmpty, isFalse);
        expect(target, hasLength(0));
      });
      test('of', () {
        final target = BiMap.of(example);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('from', () {
        final target = BiMap.from(example);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterable', () {
        final target = BiMap.fromIterable(example.keys);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, [1, 2, 3]);
      });
      test('iterable (key)', () {
        final target = BiMap.fromIterable(example.keys, key: (e) => e + 1);
        expect(target.keys, [2, 3, 4]);
        expect(target.values, [1, 2, 3]);
      });
      test('iterable (value)', () {
        final target = BiMap.fromIterable(example.keys, value: (e) => e + 1);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, [2, 3, 4]);
      });
      test('iterables', () {
        final target = BiMap.fromIterables(example.keys, example.values);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterables (reverse)', () {
        final target = BiMap.fromIterables(example.values, example.keys);
        expect(target.keys, ['a', 'b', 'c']);
        expect(target.values, [1, 2, 3]);
      });
      test('iterables (error)', () {
        expect(() => BiMap.fromIterables([1], []), throwsArgumentError);
        expect(() => BiMap.fromIterables([], [1]), throwsArgumentError);
      });
      test('converter', () {
        final target = example.toBiMap();
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
    });
    group('accessing', () {
      test('indexed', () {
        expect(example[2], 'b');
        expect(example['b'], isNull);
      });
      test('indexed of inverse', () {
        expect(example.inverse['b'], 2);
        expect(example.inverse[2], isNull);
      });
      test('keys', () {
        expect(example.keys, [1, 2, 3]);
        expect(example.containsKey(2), isTrue);
        expect(example.containsKey('b'), isFalse);
      });
      test('keys of inverse', () {
        expect(example.inverse.keys, ['a', 'b', 'c']);
        expect(example.inverse.containsKey(2), isFalse);
        expect(example.inverse.containsKey('b'), isTrue);
      });
      test('values', () {
        expect(example.values, ['a', 'b', 'c']);
        expect(example.containsValue(2), isFalse);
        expect(example.containsValue('b'), isTrue);
      });
      test('values of inverse', () {
        expect(example.inverse.values, [1, 2, 3]);
        expect(example.inverse.containsValue(2), isTrue);
        expect(example.inverse.containsValue('b'), isFalse);
      });
      test('inverse updates', () {
        final target = BiMap.of(example);
        final inverse = target.inverse;
        target[4] = 'd';
        expect(inverse['d'], 4, reason: 'inverse sees addition');
        target.remove(3);
        expect(inverse[3], isNull, reason: 'inverse sees removal');
        inverse['e'] = 5;
        expect(target[5], 'e', reason: 'inverse updates target');
        inverse.remove('d');
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('forward updates', () {
        final target = BiMap.of(example);
        final forward = target.forward;
        target[4] = 'd';
        expect(forward[4], 'd', reason: 'inverse sees addition');
        target.remove(3);
        expect(forward[3], isNull, reason: 'inverse sees removal');
        forward[5] = 'e';
        expect(target[5], 'e', reason: 'inverse updates target');
        forward.remove(4);
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('backward updates', () {
        final target = BiMap.of(example);
        final backward = target.backward;
        target[4] = 'd';
        expect(backward['d'], 4, reason: 'inverse sees addition');
        target.remove(3);
        expect(backward[3], isNull, reason: 'inverse sees removal');
        backward['e'] = 5;
        expect(target[5], 'e', reason: 'inverse updates target');
        backward.remove('d');
        expect(target[4], isNull, reason: 'inverse updates target');
      });
      test('iteration', () {
        final keys = <int>[];
        final values = <String>[];
        example.forEach((key, value) {
          keys.add(key);
          values.add(value);
        });
        expect(example.keys, keys);
        expect(example.values, values);
      });
    });
    group('writing', () {
      test('define', () {
        final target = BiMap();
        target[1] = 'a';
        expect(target.keys, [1]);
        expect(target.values, ['a']);
      });
      test('define inverse', () {
        final target = BiMap();
        target.inverse[1] = 'a';
        expect(target.keys, ['a']);
        expect(target.values, [1]);
      });
      test('redefine key to new value', () {
        final target = BiMap.of(example);
        target[2] = 'd';
        expect(target.keys, [1, 3, 2]);
        expect(target.values, ['a', 'c', 'd']);
      });
      test('redefine value to new key', () {
        final target = BiMap.of(example);
        target[4] = 'b';
        expect(target.keys, [1, 3, 4]);
        expect(target.values, ['a', 'c', 'b']);
      });
      test('redefine key and value', () {
        final target = BiMap.of(example);
        target[1] = 'c';
        expect(target.keys, [2, 1]);
        expect(target.values, ['b', 'c']);
      });
      test('remove key', () {
        final target = BiMap.of(example);
        expect(target.remove(2), 'b');
        expect(target.keys, [1, 3]);
        expect(target.values, ['a', 'c']);
        expect(target.inverse.keys, ['a', 'c']);
        expect(target.inverse.values, [1, 3]);
      });
      test('remove value', () {
        final target = BiMap.of(example);
        expect(target.inverse.remove('b'), 2);
        expect(target.keys, [1, 3]);
        expect(target.values, ['a', 'c']);
        expect(target.inverse.keys, ['a', 'c']);
        expect(target.inverse.values, [1, 3]);
      });
      test('clear', () {
        final target = BiMap.of(example);
        target.clear();
        expect(target, isEmpty);
        expect(target.inverse, isEmpty);
      });
      test('define if absent', () {
        final target = BiMap.of(example);
        target.putIfAbsent(1, () => fail('Value already present!'));
        target.putIfAbsent(4, () => 'd');
        expect(target[4], 'd');
      });
    });
  });
  group('bitlist', () {
    group('construction', () {
      test('without elements', () {
        final target = BitList(0);
        expect(target, isEmpty);
        expect(target, hasLength(0));
        expect(target, []);
      });
      test('with elements', () {
        for (var len = 1; len < 100; len++) {
          final target = BitList(len);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isFalse));
        }
      });
      test('with filled false', () {
        for (var len = 1; len < 100; len++) {
          final target = BitList.filled(len, false);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isFalse));
        }
      });
      test('with filled true', () {
        for (var len = 1; len < 100; len++) {
          final target = BitList.filled(len, true);
          expect(target, isNot(isEmpty));
          expect(target, hasLength(len));
          expect(target, everyElement(isTrue));
        }
      });
      test('from List', () {
        for (var len = 0; len < 100; len++) {
          final source = List<bool>.of(randomBooleans(457 * len, len));
          final target = BitList.from(source);
          expect(source, target);
          expect(source, target.toList());
        }
      });
      test('of List', () {
        for (var len = 0; len < 100; len++) {
          final source = List<bool>.of(randomBooleans(457 * len, len));
          final target = BitList.of(source);
          expect(source, target);
          expect(source, target.toList());
        }
      });
      test('of Set', () {
        for (var len = 0; len < 100; len++) {
          final source = Set<bool>.of(randomBooleans(827 * len, len));
          final target = BitList.of(source);
          expect(source, target);
          expect(source, target.toSet());
        }
      });
      test('of BitList', () {
        for (var len = 0; len < 10; len++) {
          final source = Set<bool>.of(randomBooleans(287 * len, len));
          final target = BitList.of(source);
          expect(source, target);
          expect(target, source);
        }
      });
      test('converter', () {
        for (var len = 0; len < 10; len++) {
          final source = randomBooleans(195 * len, len);
          final target = source.toBitList();
          expect(source, target);
          expect(target, source);
        }
      });
    });
    group('accessors', () {
      test('reading', () {
        for (var len = 0; len < 100; len++) {
          final source = randomBooleans(135 * len, len);
          final target = BitList.of(source);
          expect(() => target[-1], throwsRangeError);
          for (var i = 0; i < len; i++) {
            expect(target[i], source[i]);
          }
          expect(() => target[len], throwsRangeError);
        }
      });
      test('writing', () {
        for (var len = 0; len < 100; len++) {
          final source = randomBooleans(396 * len, len);
          final target = BitList(len);
          expect(() => target[-1] = true, throwsRangeError);
          for (var i = 0; i < len; i++) {
            target[i] = source[i];
            expect(target.sublist(0, i), source.sublist(0, i));
            expect(target.sublist(i + 1), everyElement(isFalse));
          }
          expect(() => target[len] = true, throwsRangeError);
        }
      });
      test('flipping', () {
        for (var len = 0; len < 100; len++) {
          final source = BitList.of(randomBooleans(385 * len, len));
          final target = ~source;
          expect(() => target.flip(-1), throwsRangeError);
          for (var i = 0; i < len; i++) {
            final before = source[i];
            source.flip(i);
            expect(!before, source[i]);
          }
          expect(() => target.flip(len), throwsRangeError);
          expect(target, source);
        }
      });
      test('counting', () {
        for (var len = 0; len < 100; len++) {
          final list = BitList.of(randomBooleans(823 * len, len));
          final trueCount = list.count(true);
          final falseCount = list.count(false);
          expect(trueCount + falseCount, list.length);
          expect(trueCount, list.where((b) => b == true).length);
          expect(falseCount, list.where((b) => b == false).length);
        }
      });
    });
    group('operators', () {
      test('concatenate', () {
        for (var len1 = 0; len1 < 100; len1++) {
          for (var len2 = 0; len2 < 100; len2++) {
            final source1 = BitList.of(randomBooleans(954 * len1, len1));
            final source2 = BitList.of(randomBooleans(713 * len2, len2));
            final target = source1 + source2;
            expect(target.length, len1 + len2);
            for (var i = 0; i < len1 + len2; i++) {
              expect(target[i], i < len1 ? source1[i] : source2[i - len1]);
            }
          }
        }
      });
      group('complement', () {
        test('operator', () {
          final source = BitList.of(randomBooleans(702, 100));
          final target = ~source;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], !source[i]);
          }
        });
        test('in-place', () {
          final source = BitList.of(randomBooleans(702, 100));
          final target = BitList.of(source);
          target.not();
          for (var i = 0; i < target.length; i++) {
            expect(target[i], !source[i]);
          }
        });
      });
      group('intersection', () {
        test('operator', () {
          final source1 = BitList.of(randomBooleans(439, 100));
          final source2 = BitList.of(randomBooleans(902, 100));
          final target = source1 & source2;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] && source2[i]);
          }
          expect(target, source2 & source1);
          final other = BitList(99);
          expect(() => other & source1, throwsArgumentError);
          expect(() => source1 & other, throwsArgumentError);
        });
        test('in-place', () {
          final source1 = BitList.of(randomBooleans(439, 100));
          final source2 = BitList.of(randomBooleans(902, 100));
          final target = BitList.of(source1);
          target.and(source2);
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] && source2[i]);
          }
        });
      });
      group('union', () {
        test('operator', () {
          final source1 = BitList.of(randomBooleans(817, 100));
          final source2 = BitList.of(randomBooleans(858, 100));
          final target = source1 | source2;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] || source2[i]);
          }
          expect(target, source2 | source1);
          final other = BitList(99);
          expect(() => other | source1, throwsArgumentError);
          expect(() => source1 | other, throwsArgumentError);
        });
        test('in-place', () {
          final source1 = BitList.of(randomBooleans(439, 100));
          final source2 = BitList.of(randomBooleans(902, 100));
          final target = BitList.of(source1);
          target.or(source2);
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] || source2[i]);
          }
        });
      });
      test('difference', () {
        final source1 = BitList.of(randomBooleans(364, 100));
        final source2 = BitList.of(randomBooleans(243, 100));
        final target = source1 - source2;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], source1[i] && !source2[i]);
        }
        expect(target, source1 & ~source2);
        final other = BitList(99);
        expect(() => other - source1, throwsArgumentError);
        expect(() => source1 - other, throwsArgumentError);
      });
      test('shift-left', () {
        for (var len = 0; len < 100; len++) {
          final source = BitList.of(randomBooleans(836 * len, len));
          for (var shift = 0; shift <= len + 10; shift++) {
            final target = source << shift;
            if (shift == 0) {
              expect(target, source);
            } else if (shift >= len) {
              expect(target, everyElement(isFalse));
            } else {
              for (var i = shift; i < source.length; i++) {
                expect(target[i], source[i - shift]);
              }
            }
          }
          expect(() => source << -1, throwsArgumentError);
        }
      });
      test('shift-right', () {
        for (var len = 0; len < 100; len++) {
          final source = BitList.of(randomBooleans(963 * len, len));
          for (var shift = 0; shift <= len + 10; shift++) {
            final target = source >> shift;
            if (shift == 0) {
              expect(target, source);
            } else if (shift >= len) {
              expect(target, everyElement(isFalse));
            } else {
              for (var i = 0; i < source.length - shift; i++) {
                expect(target[i], source[i + shift]);
              }
            }
          }
          expect(() => source >> -1, throwsArgumentError);
        }
      });
    });
    test('fixed length', () {
      final list = BitList(32);
      expect(() => list.add(false), throwsUnsupportedError);
      expect(() => list.addAll([true, false]), throwsUnsupportedError);
      expect(() => list.clear(), throwsUnsupportedError);
      expect(() => list.insert(2, true), throwsUnsupportedError);
      expect(() => list.insertAll(2, [true, false]), throwsUnsupportedError);
      expect(() => list.length = 10, throwsUnsupportedError);
      expect(() => list.remove(true), throwsUnsupportedError);
      expect(() => list.removeAt(2), throwsUnsupportedError);
      expect(() => list.removeLast(), throwsUnsupportedError);
      expect(() => list.removeRange(2, 4), throwsUnsupportedError);
      expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
      expect(
          () => list.replaceRange(2, 4, [true, false]), throwsUnsupportedError);
      expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
    });
  });
  group('multimap', () {
    group('list', () {
      group('constructor', () {
        test('empty', () {
          final map = ListMultimap();
          expect(map, isEmpty);
          expect(map, hasLength(0));
          expect(map.isEmpty, isTrue);
          expect(map.isNotEmpty, isFalse);
          expect(map.asMap(), {});
          expect(map.keys, []);
          expect(map.values, []);
        });
        test('of', () {
          final map = ListMultimap.of(
              ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]));
          expect(map, hasLength(3));
          expect(map.isEmpty, isFalse);
          expect(map.isNotEmpty, isTrue);
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('identity', () {
          final map = ListMultimap.identity();
          expect(map, isEmpty);
          expect(map, hasLength(0));
          expect(map.asMap(), {});
          expect(map.keys, []);
          expect(map.values, []);
        });
        test('fromIterable', () {
          final map = ListMultimap.fromIterable(IntegerRange(3),
              key: (i) => String.fromCharCode(i + 97), value: (i) => i + 1);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b', 'c']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2],
            'c': [3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2]);
          expect(map['c'], [3]);
        });
        test('fromIterable (no providers)', () {
          final map = ListMultimap.fromIterable(IntegerRange(3));
          expect(map, hasLength(3));
          expect(map.keys, [0, 1, 2]);
          expect(map.values, [0, 1, 2]);
          expect(map.asMap(), {
            0: [0],
            1: [1],
            2: [2]
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
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('fromIterables (error)', () {
          expect(() => ListMultimap.fromIterables(['a', 'b', 'b'], [1, 2]),
              throwsArgumentError);
        });
        test('fromEntries', () {
          final map = ListMultimap.fromEntries(
              const [MapEntry('a', 1), MapEntry('b', 2), MapEntry('b', 3)]);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
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
          final map = SetMultimap();
          expect(map, isEmpty);
          expect(map, hasLength(0));
          expect(map.isEmpty, isTrue);
          expect(map.isNotEmpty, isFalse);
          expect(map.asMap(), {});
          expect(map.keys, []);
          expect(map.values, []);
        });
        test('of', () {
          final map = SetMultimap.of(
              SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2, 3]));
          expect(map, hasLength(3));
          expect(map.isEmpty, isFalse);
          expect(map.isNotEmpty, isTrue);
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('identity', () {
          final map = SetMultimap.identity();
          expect(map, isEmpty);
          expect(map, hasLength(0));
          expect(map.asMap(), {});
          expect(map.keys, []);
          expect(map.values, []);
        });
        test('fromIterable', () {
          final map = SetMultimap.fromIterable(IntegerRange(3),
              key: (i) => String.fromCharCode(i + 97), value: (i) => i + 1);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b', 'c']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2],
            'c': [3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2]);
          expect(map['c'], [3]);
        });
        test('fromIterable (no providers)', () {
          final map = SetMultimap.fromIterable(IntegerRange(3));
          expect(map, hasLength(3));
          expect(map.keys, [0, 1, 2]);
          expect(map.values, [0, 1, 2]);
          expect(map.asMap(), {
            0: [0],
            1: [1],
            2: [2]
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
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
        });
        test('fromIterables (error)', () {
          expect(() => SetMultimap.fromIterables(['a', 'b', 'b'], [1, 2]),
              throwsArgumentError);
        });
        test('fromEntries', () {
          final map = SetMultimap.fromEntries(
              const [MapEntry('a', 1), MapEntry('b', 2), MapEntry('b', 3)]);
          expect(map, hasLength(3));
          expect(map.keys, ['a', 'b']);
          expect(map.values, [1, 2, 3]);
          expect(map.asMap(), {
            'a': [1],
            'b': [2, 3]
          });
          expect(map['a'], [1]);
          expect(map['b'], [2, 3]);
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
  });
  group('multiset', () {
    group('construct', () {
      test('empty', () {
        final set = Multiset();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('empty identity', () {
        final set = Multiset.identity();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('of one unique', () {
        final set = Multiset.of(['a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([1]));
      });
      test('of many unique', () {
        final set = Multiset.of(['a', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([1, 1, 1]));
      });
      test('of one repeated', () {
        final set = Multiset.of(['a', 'a', 'a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([3]));
      });
      test('of many repeated', () {
        final set = Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('of set', () {
        final set = Multiset.of({'a', 'b', 'c'});
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([1, 1, 1]));
      });
      test('from many repeated', () {
        final set = Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('copy', () {
        final set = Multiset.of(Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate', () {
        final set = Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate with key', () {
        final set = Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c'],
            key: (e) => e.codeUnitAt(0));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals([97, 97, 97, 98, 98, 99]));
        expect(set.distinct, unorderedEquals([97, 98, 99]));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate with count', () {
        final set = Multiset.fromIterable(['aaa', 'bb', 'c'],
            key: (e) => e.substring(0, 1), count: (e) => e.length);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('convert', () {
        final set = ['a', 'a', 'a', 'b', 'b', 'c'].toMultiset();
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
    });
    group('adding', () {
      test('zero', () {
        final set = Multiset()..add('a', 0)..add('b', 0);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('single', () {
        final set = Multiset()..add('a')..add('b')..add('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 2]));
      });
      test('multiple', () {
        final set = Multiset()..add('a', 2)..add('b', 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('all', () {
        final set = Multiset()..addAll(['a', 'a', 'b', 'b', 'b']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([3, 2]));
      });
      test('error', () {
        final set = Multiset();
        expect(() => set.add('a', -1), throwsArgumentError);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
    });
    group('removing', () {
      test('zero', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set..remove('a', 0)..remove('b', 0);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('single', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set..remove('a')..remove('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 2]));
      });
      test('multiple', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set..remove('a', 3)..remove('b', 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['b']));
        expect(set.distinct, unorderedEquals(['b']));
        expect(set.counts, unorderedEquals([1]));
      });
      test('all', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set.removeAll(['a', 'b', 'b']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 1]));
      });
      test('clear', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set.clear();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('invalid', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('c'), returnsNormally);
        expect(() => set.remove('z'), returnsNormally);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('error', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('a', -1), throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
    });
    group('access', () {
      test('single', () {
        final set = Multiset();
        set['a'] = 2;
        expect(set['a'], 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([2]));
      });
      test('multiple', () {
        final set = Multiset();
        set['a'] = 2;
        set['b'] = 3;
        expect(set['a'], 2);
        expect(set['b'], 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([3, 2]));
      });
      test('remove', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set['b'] = 0;
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([2]));
      });
      test('error', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        expect(() => set['a'] = -1, throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
    });
    group('operator', () {
      final firstList = ['a', 'b', 'c', 'c'];
      final firstSet = Multiset.of(firstList);
      final secondList = ['a', 'c', 'd', 'd'];
      final secondSet = Multiset.of(secondList);
      test('contains', () {
        expect(firstSet.contains('a'), isTrue);
        expect(firstSet.contains('b'), isTrue);
        expect(firstSet.contains('c'), isTrue);
        expect(firstSet.contains('d'), isFalse);
      });
      test('containsAll', () {
        expect(firstSet.containsAll(firstSet), isTrue);
        expect(firstSet.containsAll(secondSet), isFalse);
        expect(firstSet.containsAll(Multiset()), isTrue);
        expect(firstSet.containsAll(Multiset.of(['a', 'b', 'b'])), isFalse);
        expect(firstSet.containsAll(Multiset.of(['a', 'b', 'd'])), isFalse);
      });
      test('containsAll (iterable)', () {
        expect(firstSet.containsAll(firstList), isTrue);
        expect(firstSet.containsAll(secondList), isFalse);
        expect(firstSet.containsAll([]), isTrue);
        expect(firstSet.containsAll(['a']), isTrue);
        expect(firstSet.containsAll(['x']), isFalse);
        expect(firstSet.containsAll(['a', 'b', 'b']), isFalse);
        expect(firstSet.containsAll(['a', 'b', 'd']), isFalse);
      });
      test('intersection', () {
        expect(firstSet.intersection(secondSet), unorderedEquals(['a', 'c']));
        expect(firstSet.intersection(secondSet).distinct,
            unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstSet), unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstSet).distinct,
            unorderedEquals(['a', 'c']));
      });
      test('intersection (iterable)', () {
        expect(firstSet.intersection(secondList), unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstList), unorderedEquals(['a', 'c']));
      });
      test('union', () {
        expect(firstSet.union(secondSet),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(firstSet.union(secondSet).distinct,
            unorderedEquals(['a', 'b', 'c', 'd']));
        expect(secondSet.union(firstSet),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(secondSet.union(firstSet).distinct,
            unorderedEquals(['a', 'b', 'c', 'd']));
      });
      test('union (iterable)', () {
        expect(firstSet.union(secondList),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        expect(secondSet.union(firstList),
            unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
      });
      test('difference', () {
        expect(firstSet.difference(secondSet), unorderedEquals(['b', 'c']));
        expect(firstSet.difference(secondSet).distinct,
            unorderedEquals(['b', 'c']));
        expect(secondSet.difference(firstSet), unorderedEquals(['d', 'd']));
        expect(secondSet.difference(firstSet).distinct, unorderedEquals(['d']));
      });
      test('difference (iterable)', () {
        expect(firstSet.difference(secondList), unorderedEquals(['b', 'c']));
        expect(secondSet.difference(firstList), unorderedEquals(['d', 'd']));
      });
    });
  });
  group('range', () {
    void verify(List<num> range, List<num> expected) {
      expect(range, expected);
      expect(range.reversed, expected.reversed);
      final iterator = range.iterator;
      for (var i = 0; i < expected.length; i++) {
        expect(iterator.moveNext(), isTrue);
        expect(iterator.current, range[i]);
        expect(range.indexOf(iterator.current), i);
        expect(range.indexOf(iterator.current, i), i);
        expect(range.indexOf(iterator.current, -1), i);
        expect(range.lastIndexOf(iterator.current), i);
        expect(range.lastIndexOf(iterator.current, i), i);
        expect(range.lastIndexOf(iterator.current, expected.length), i);
      }
      expect(iterator.moveNext(), isFalse);
      expect(() => range[-1], throwsRangeError);
      expect(() => range[expected.length], throwsRangeError);
      for (final value in expected) {
        expect(range.contains(value), isTrue);
      }
    }

    group('int', () {
      group('constructor', () {
        test('empty', () {
          verify(IntegerRange(), []);
          expect(IntegerRange().contains(0), isFalse);
        });
        test('1 argument', () {
          verify(IntegerRange(0), []);
          verify(IntegerRange(1), [0]);
          verify(IntegerRange(2), [0, 1]);
          verify(IntegerRange(3), [0, 1, 2]);
        });
        test('2 argument', () {
          verify(IntegerRange(0, 4), [0, 1, 2, 3]);
          verify(IntegerRange(5, 9), [5, 6, 7, 8]);
          verify(IntegerRange(9, 5), [9, 8, 7, 6]);
        });
        test('3 argument (positive step)', () {
          verify(IntegerRange(2, 8, 2), [2, 4, 6]);
          verify(IntegerRange(3, 8, 2), [3, 5, 7]);
          verify(IntegerRange(4, 8, 2), [4, 6]);
          verify(IntegerRange(2, 7, 2), [2, 4, 6]);
          verify(IntegerRange(2, 6, 2), [2, 4]);
        });
        test('3 argument (negative step)', () {
          verify(IntegerRange(8, 2, -2), [8, 6, 4]);
          verify(IntegerRange(8, 3, -2), [8, 6, 4]);
          verify(IntegerRange(8, 4, -2), [8, 6]);
          verify(IntegerRange(7, 2, -2), [7, 5, 3]);
          verify(IntegerRange(6, 2, -2), [6, 4]);
        });
        test('shorthand', () {
          verify(0.to(3), [0, 1, 2]);
          verify(2.to(8, step: 2), [2, 4, 6]);
        });
        test('invalid', () {
          expect(() => IntegerRange(0, 2, 0), throwsArgumentError);
          expect(() => IntegerRange(0, 2, -1), throwsArgumentError);
          expect(() => IntegerRange(2, 0, 1), throwsArgumentError);
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verify(IntegerRange(3).sublist(0), [0, 1, 2]);
          verify(IntegerRange(3).sublist(1), [1, 2]);
          verify(IntegerRange(3).sublist(2), [2]);
          verify(IntegerRange(3).sublist(3), []);
          expect(() => IntegerRange(3).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verify(IntegerRange(3).sublist(0, 3), [0, 1, 2]);
          verify(IntegerRange(3).sublist(0, 2), [0, 1]);
          verify(IntegerRange(3).sublist(0, 1), [0]);
          verify(IntegerRange(3).sublist(0, 0), []);
          expect(() => IntegerRange(3).sublist(0, 4), throwsRangeError);
        });
        test('getRange', () {
          verify(IntegerRange(3).getRange(0, 3).toList(), [0, 1, 2]);
          verify(IntegerRange(3).getRange(0, 2).toList(), [0, 1]);
          verify(IntegerRange(3).getRange(0, 1).toList(), [0]);
          verify(IntegerRange(3).getRange(0, 0).toList(), []);
          expect(() => IntegerRange(3).getRange(0, 4), throwsRangeError);
        });
      });
      group('index', () {
        test('indexOf (positive step)', () {
          final r = IntegerRange(2, 7, 2); // [2, 4, 6]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(1), -1);
          expect(r.indexOf(3), -1);
          expect(r.indexOf(5), -1);
          expect(r.indexOf(7), -1);
          expect(r.indexOf(2, 1), -1);
          expect(r.indexOf(4, 2), -1);
          expect(r.indexOf(6, 3), -1);
          expect(r.indexOf(8, 4), -1);
        });
        test('indexOf (negative step)', () {
          final r = IntegerRange(7, 2, -2); // [7, 5, 3]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(2), -1);
          expect(r.indexOf(4), -1);
          expect(r.indexOf(6), -1);
          expect(r.indexOf(8), -1);
          expect(r.indexOf(2, 1), -1);
          expect(r.indexOf(4, 2), -1);
          expect(r.indexOf(6, 3), -1);
          expect(r.indexOf(8, 4), -1);
        });
        test('lastIndexOf (positive step)', () {
          final r = IntegerRange(2, 7, 2); // [2, 4, 6]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(1), -1);
          expect(r.lastIndexOf(3), -1);
          expect(r.lastIndexOf(5), -1);
          expect(r.lastIndexOf(7), -1);
          expect(r.lastIndexOf(1, 1), -1);
          expect(r.lastIndexOf(3, 2), -1);
          expect(r.lastIndexOf(5, 3), -1);
          expect(r.lastIndexOf(7, 4), -1);
        });
        test('lastIndexOf (negative step)', () {
          final r = IntegerRange(7, 2, -2); // [7, 5, 3]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(2), -1);
          expect(r.lastIndexOf(4), -1);
          expect(r.lastIndexOf(6), -1);
          expect(r.lastIndexOf(8), -1);
          expect(r.lastIndexOf(2, 1), -1);
          expect(r.lastIndexOf(4, 2), -1);
          expect(r.lastIndexOf(6, 3), -1);
          expect(r.lastIndexOf(8, 4), -1);
        });
      });
      test('printing', () {
        expect(IntegerRange().toString(), 'IntegerRange()');
        expect(IntegerRange(1).toString(), 'IntegerRange(1)');
        expect(IntegerRange(1, 2).toString(), 'IntegerRange(1, 2)');
        expect(IntegerRange(1, 5, 2).toString(), 'IntegerRange(1, 5, 2)');
      });
      test('unmodifiable', () {
        final list = IntegerRange(1, 5);
        expect(() => list[0] = 5, throwsUnsupportedError);
        expect(() => list.add(5), throwsUnsupportedError);
        expect(() => list.addAll([5, 6]), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(() => list.fillRange(2, 4, 5), throwsUnsupportedError);
        expect(() => list.insert(2, 5), throwsUnsupportedError);
        expect(() => list.insertAll(2, [5, 6]), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(5), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(() => list.replaceRange(2, 4, [5, 6]), throwsUnsupportedError);
        expect(
            () => list.retainWhere((value) => false), throwsUnsupportedError);
        expect(() => list.setAll(2, [5, 6]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5, 6]), throwsUnsupportedError);
        expect(() => list.shuffle(), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
    group('double', () {
      group('constructor', () {
        test('empty', () {
          verify(DoubleRange(), []);
          expect(DoubleRange().contains(0.0), isFalse);
        });
        test('1 argument', () {
          verify(DoubleRange(0.0), []);
          verify(DoubleRange(1.0), [0.0]);
          verify(DoubleRange(2.0), [0.0, 1.0]);
          verify(DoubleRange(3.0), [0.0, 1.0, 2.0]);
        });
        test('2 argument', () {
          verify(DoubleRange(0.0, 4.0), [0.0, 1.0, 2.0, 3.0]);
          verify(DoubleRange(5.0, 9.0), [5.0, 6.0, 7.0, 8.0]);
          verify(DoubleRange(9.0, 5.0), [9.0, 8.0, 7.0, 6.0]);
        });
        test('3 argument (positive step)', () {
          verify(DoubleRange(2.0, 8.0, 1.5), [2.0, 3.5, 5.0, 6.5]);
          verify(DoubleRange(3.0, 8.0, 1.5), [3.0, 4.5, 6.0, 7.5]);
          verify(DoubleRange(4.0, 8.0, 1.5), [4.0, 5.5, 7.0]);
          verify(DoubleRange(2.0, 7.0, 1.5), [2.0, 3.5, 5.0, 6.5]);
          verify(DoubleRange(2.0, 6.0, 1.5), [2.0, 3.5, 5.0]);
        });
        test('3 argument (negative step)', () {
          verify(DoubleRange(8.0, 2.0, -1.5), [8.0, 6.5, 5.0, 3.5]);
          verify(DoubleRange(8.0, 3.0, -1.5), [8.0, 6.5, 5.0, 3.5]);
          verify(DoubleRange(8.0, 4.0, -1.5), [8.0, 6.5, 5.0]);
          verify(DoubleRange(7.0, 2.0, -1.5), [7.0, 5.5, 4.0, 2.5]);
          verify(DoubleRange(6.0, 2.0, -1.5), [6.0, 4.5, 3.0]);
        });
        test('shorthand', () {
          verify(0.0.to(3.0), [0.0, 1.0, 2.0]);
          verify(4.0.to(8.0, step: 1.5), [4.0, 5.5, 7.0]);
        });
        test('invalid', () {
          expect(() => DoubleRange(0.0, 2.0, 0.0), throwsArgumentError);
          expect(() => DoubleRange(0.0, 2.0, -1.5), throwsArgumentError);
          expect(() => DoubleRange(2.0, 0.0, 1.5), throwsArgumentError);
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verify(DoubleRange(3.0).sublist(0), [0.0, 1.0, 2.0]);
          verify(DoubleRange(3.0).sublist(1), [1.0, 2.0]);
          verify(DoubleRange(3.0).sublist(2), [2.0]);
          verify(DoubleRange(3.0).sublist(3), []);
          expect(() => DoubleRange(3.0).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verify(DoubleRange(3.0).sublist(0, 3), [0.0, 1.0, 2.0]);
          verify(DoubleRange(3.0).sublist(0, 2), [0.0, 1.0]);
          verify(DoubleRange(3.0).sublist(0, 1), [0.0]);
          verify(DoubleRange(3.0).sublist(0, 0), []);
          expect(() => DoubleRange(3.0).sublist(0, 4), throwsRangeError);
        });
        test('getRange', () {
          verify(DoubleRange(3.0).getRange(0, 3).toList(), [0.0, 1.0, 2.0]);
          verify(DoubleRange(3.0).getRange(0, 2).toList(), [0.0, 1.0]);
          verify(DoubleRange(3.0).getRange(0, 1).toList(), [0.0]);
          verify(DoubleRange(3.0).getRange(0, 0).toList(), []);
          expect(() => DoubleRange(3.0).getRange(0, 4), throwsRangeError);
        });
      });
      group('index', () {
        test('indexOf (positive step)', () {
          final r = DoubleRange(2.0, 7.0, 1.5); // [2.0, 3.5, 5.0, 6.5]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(1.0), -1);
          expect(r.indexOf(3.0), -1);
          expect(r.indexOf(7.0), -1);
          expect(r.indexOf(2.0, 1), -1);
          expect(r.indexOf(3.5, 2), -1);
          expect(r.indexOf(5.0, 3), -1);
          expect(r.indexOf(6.5, 4), -1);
        });
        test('indexOf (negative step)', () {
          final r = DoubleRange(7.0, 2.0, -1.5); // [7.0, 5.5, 4.0, 2.5]
          expect(r.indexOf(null), -1);
          expect(r.indexOf(2.0), -1);
          expect(r.indexOf(5.0), -1);
          expect(r.indexOf(8.0), -1);
          expect(r.indexOf(7.0, 1), -1);
          expect(r.indexOf(5.5, 2), -1);
          expect(r.indexOf(4.0, 3), -1);
          expect(r.indexOf(2.5, 4), -1);
        });
        test('lastIndexOf (positive step)', () {
          final r = DoubleRange(2.0, 7.0, 1.5); // [2.0, 3.5, 5.0, 6.5]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(1.0), -1);
          expect(r.lastIndexOf(3.0), -1);
          expect(r.lastIndexOf(7.0), -1);
          expect(r.lastIndexOf(2.0, -1), -1);
          expect(r.lastIndexOf(3.5, 0), -1);
          expect(r.lastIndexOf(5.0, 1), -1);
          expect(r.lastIndexOf(6.5, 2), -1);
          expect(r.lastIndexOf(7.0, 3), -1);
          expect(r.lastIndexOf(8.5, 4), -1);
        });
        test('lastIndexOf (negative step)', () {
          final r = DoubleRange(7.0, 2.0, -1.5); // [7.0, 5.5, 4.0, 2.5]
          expect(r.lastIndexOf(null), -1);
          expect(r.lastIndexOf(2.0), -1);
          expect(r.lastIndexOf(5.0), -1);
          expect(r.lastIndexOf(8.0), -1);
          expect(r.lastIndexOf(7.0, -1), -1);
          expect(r.lastIndexOf(5.5, 0), -1);
          expect(r.lastIndexOf(4.0, 1), -1);
          expect(r.lastIndexOf(2.5, 2), -1);
          expect(r.lastIndexOf(1.0, 3), -1);
          expect(r.lastIndexOf(0.0, 4), -1);
        });
      });
      test('printing', () {
        expect(DoubleRange().toString(), 'DoubleRange()');
        expect(DoubleRange(1.2).toString(), 'DoubleRange(1.2)');
        expect(DoubleRange(1.2, 3.4).toString(), 'DoubleRange(1.2, 3.4)');
        expect(DoubleRange(1.2, 3.4, 0.5).toString(),
            'DoubleRange(1.2, 3.4, 0.5)');
      });
      test('unmodifiable', () {
        final list = DoubleRange(1.0, 5.0);
        expect(() => list[0] = 5.0, throwsUnsupportedError);
        expect(() => list.add(5.0), throwsUnsupportedError);
        expect(() => list.addAll([5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(() => list.fillRange(2, 4, 5.0), throwsUnsupportedError);
        expect(() => list.insert(2, 5.0), throwsUnsupportedError);
        expect(() => list.insertAll(2, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(5.0), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(
            () => list.replaceRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
        expect(
            () => list.retainWhere((value) => false), throwsUnsupportedError);
        expect(() => list.setAll(2, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
  });
  group('string', () {
    group('immutable', () {
      final empty = ''.toList();
      final plenty = 'More Dart'.toList();
      test('creating', () {
        final coerced = '123'.toList();
        expect(coerced.length, 3);
        expect(coerced.toString(), '123');
      });
      test('isEmpty', () {
        expect(empty.isEmpty, isTrue);
        expect(plenty.isEmpty, isFalse);
      });
      test('length', () {
        expect(empty.length, 0);
        expect(plenty.length, 9);
      });
      test('reading', () {
        expect(plenty[0], 'M');
        expect(plenty[1], 'o');
        expect(plenty[2], 'r');
        expect(plenty[3], 'e');
        expect(plenty[4], ' ');
        expect(plenty[5], 'D');
        expect(plenty[6], 'a');
        expect(plenty[7], 'r');
        expect(plenty[8], 't');
      });
      test('reading (range error)', () {
        expect(() => empty[0], throwsRangeError);
        expect(() => plenty[-1], throwsRangeError);
        expect(() => plenty[9], throwsRangeError);
      });
      test('converting', () {
        expect(empty.toList(), []);
        expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), {'M', 'o', 'r', 'e', ' ', 'D', 'a', 't'});
        expect(empty.toString(), '');
        expect(plenty.toString(), 'More Dart');
      });
      test('read-only', () {
        expect(() => plenty[0] = 'a', throwsUnsupportedError);
        expect(() => plenty.length = 10, throwsUnsupportedError);
        expect(() => plenty.add('a'), throwsUnsupportedError);
        expect(() => plenty.remove('a'), throwsUnsupportedError);
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plenty.toString().substring(5));
        expect(
            plenty.sublist(5, 7).toString(), plenty.toString().substring(5, 7));
      });
    });
    group('mutable', () {
      final empty = ''.toList(mutable: true);
      final plenty = 'More Dart'.toList(mutable: true);
      test('creating', () {
        final coerced = '123'.toList(mutable: true);
        expect(coerced.length, 3);
        expect(coerced.toString(), '123');
      });
      test('isEmpty', () {
        expect(empty.isEmpty, isTrue);
        expect(plenty.isEmpty, isFalse);
      });
      test('length', () {
        expect(empty.length, 0);
        expect(plenty.length, 9);
      });
      test('reading', () {
        expect(plenty[0], 'M');
        expect(plenty[1], 'o');
        expect(plenty[2], 'r');
        expect(plenty[3], 'e');
        expect(plenty[4], ' ');
        expect(plenty[5], 'D');
        expect(plenty[6], 'a');
        expect(plenty[7], 'r');
        expect(plenty[8], 't');
      });
      test('reading (range error)', () {
        expect(() => empty[0], throwsRangeError);
        expect(() => plenty[-1], throwsRangeError);
        expect(() => plenty[9], throwsRangeError);
      });
      test('writing', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable[1] = 'd';
        expect(mutable.toString(), 'adc');
      });
      test('writing (range error)', () {
        expect(() => empty[0] = 'a', throwsRangeError);
        expect(() => plenty[-1] = 'a', throwsRangeError);
        expect(() => plenty[9] = 'a', throwsRangeError);
      });
      test('writing (argument error)', () {
        expect(() => plenty[0] = 'ab', throwsArgumentError);
      });
      test('adding', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable.add('d');
        expect(mutable.toString(), 'abcd');
      });
      test('removing', () {
        final mutable = 'abc'.toList(mutable: true);
        mutable.remove('a');
        expect(mutable.toString(), 'bc');
      });
      test('converting', () {
        expect(empty.toList(), []);
        expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), {'M', 'o', 'r', 'e', ' ', 'D', 'a', 't'});
        expect(empty.toString(), '');
        expect(plenty.toString(), 'More Dart');
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plenty.toString().substring(5));
        expect(
            plenty.sublist(5, 7).toString(), plenty.toString().substring(5, 7));
      });
    });
  });
}
