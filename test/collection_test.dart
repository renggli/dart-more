// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:collection';
import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/comparator.dart';
import 'package:more/graph.dart';
import 'package:more/math.dart';
import 'package:more/number.dart';
import 'package:test/test.dart';

import 'data/normalization_data.dart';

List<bool> randomBooleans(int seed, int length) {
  final list = <bool>[];
  final generator = Random(seed);
  for (var i = 0; i < length; i++) {
    list.add(generator.nextBool());
  }
  return list;
}

String joiner(List<String> input) => input.join('');

Matcher isMapEntry<K, V>(K key, V value) => isA<MapEntry<K, V>>()
    .having((entry) => entry.key, 'key', key)
    .having((entry) => entry.value, 'value', value);

void main() {
  group('bimap', () {
    final example = BiMap.of({1: 'a', 2: 'b', 3: 'c'});
    group('construction', () {
      test('empty', () {
        final target = BiMap<int, String>();
        expect(target, isEmpty);
        expect(target.isEmpty, isTrue);
        expect(target.isNotEmpty, isFalse);
        expect(target, hasLength(0));
      });
      test('identity', () {
        final target = BiMap<int, String>.identity();
        expect(target, isEmpty);
        expect(target.isEmpty, isTrue);
        expect(target.isNotEmpty, isFalse);
        expect(target, hasLength(0));
      });
      test('of', () {
        final target = BiMap<int, String>.of(example);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('from', () {
        final target = BiMap<int, String>.from(example);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterable', () {
        final target = BiMap<int, int>.fromIterable(example.keys);
        expect(target.keys, [1, 2, 3]);
        expect(target.values, [1, 2, 3]);
      });
      test('iterable (key)', () {
        final target = BiMap<int, int>.fromIterable(
          example.keys,
          key: (e) => (e as int) + 1,
        );
        expect(target.keys, [2, 3, 4]);
        expect(target.values, [1, 2, 3]);
      });
      test('iterable (value)', () {
        final target = BiMap<int, int>.fromIterable(
          example.keys,
          value: (e) => (e as int) + 1,
        );
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
      test('map converter', () {
        final target = example.toBiMap();
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterable converter', () {
        final target = [
          0,
          1,
          2,
        ].toBiMap(key: (e) => e + 1, value: (e) => String.fromCharCode(97 + e));
        expect(target.keys, [1, 2, 3]);
        expect(target.values, ['a', 'b', 'c']);
      });
      test('iterable converter (default key and value providers)', () {
        final target = ['a', 'b'].toBiMap<String, String>();
        expect(target.keys, ['a', 'b']);
        expect(target.values, ['a', 'b']);
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
        final target = BiMap<int, String>();
        target[1] = 'a';
        expect(target.keys, [1]);
        expect(target.values, ['a']);
      });
      test('define inverse', () {
        final target = BiMap<String, int>();
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
        target.putIfAbsent(1, () => throw StateError('Value already present!'));
        target.putIfAbsent(4, () => 'd');
        expect(target[4], 'd');
      });
    });
  });
  group('bitlist', () {
    for (final growable in [false, true]) {
      group(growable ? 'growable' : 'fixed-length', () {
        group('construction', () {
          test('default', () {
            for (var len = 1; len < 100; len++) {
              final target = BitList(len, growable: growable);
              expect(target, isNot(isEmpty));
              expect(target, hasLength(len));
              expect(target, everyElement(isFalse));
            }
          });
          test('empty', () {
            final target = BitList.empty(growable: growable);
            expect(target, isEmpty);
            expect(target, hasLength(0));
          });
          test('filled (false)', () {
            for (var len = 1; len < 100; len++) {
              final target = BitList.filled(len, false, growable: growable);
              expect(target, isNot(isEmpty));
              expect(target, hasLength(len));
              expect(target, everyElement(isFalse));
            }
          });
          test('filled (true)', () {
            for (var len = 1; len < 100; len++) {
              final target = BitList.filled(len, true, growable: growable);
              expect(target, isNot(isEmpty));
              expect(target, hasLength(len));
              expect(target, everyElement(isTrue));
            }
          });
          test('from', () {
            for (var len = 0; len < 100; len++) {
              final source = List<bool>.of(randomBooleans(457 * len, len));
              final target = BitList.from(source, growable: growable);
              expect(source, target);
              expect(source, target.toList());
            }
          });
          test('of', () {
            for (var len = 0; len < 100; len++) {
              final source = List<bool>.of(randomBooleans(447 * len, len));
              final target = BitList.of(source, growable: growable);
              expect(source, target);
              expect(source, target.toList());
            }
          });
          test('generate', () {
            for (var len = 0; len < 100; len++) {
              final source = randomBooleans(902 * len, len);
              final target = BitList.generate(
                len,
                (i) => source[i],
                growable: growable,
              );
              expect(source, target);
              expect(source, target.toList());
            }
          });
          test('of Set', () {
            for (var len = 0; len < 100; len++) {
              final source = Set<bool>.of(randomBooleans(827 * len, len));
              final target = BitList.of(source, growable: growable);
              expect(source, target);
              expect(source, target.toSet());
            }
          });
          test('of BitList', () {
            for (var len = 0; len < 10; len++) {
              final source = Set<bool>.of(randomBooleans(287 * len, len));
              final target = BitList.of(source, growable: growable);
              expect(source, target);
              expect(target, source);
            }
          });
          test('converter', () {
            for (var len = 0; len < 10; len++) {
              final source = randomBooleans(195 * len, len);
              final target = source.toBitList(growable: growable);
              expect(source, target);
              expect(target, source);
            }
          });
        });
        group('accessors', () {
          test('reading', () {
            for (var len = 0; len < 100; len++) {
              final source = randomBooleans(135 * len, len);
              final target = BitList.of(source, growable: growable);
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
              final target = BitList(len, growable: growable);
              expect(() => target[-1] = true, throwsRangeError);
              for (var i = 0; i < len; i++) {
                target[i] = source[i];
                expect(target.sublist(0, i), source.sublist(0, i));
                expect(target.sublist(i + 1), everyElement(isFalse));
              }
              expect(() => target[len] = true, throwsRangeError);
            }
          });
          test('fill range (false)', () {
            final generator = Random(925);
            for (var len = 2; len < 250; len++) {
              final source = BitList.filled(len, true, growable: growable);
              final startIndex = generator.nextInt(len ~/ 2);
              final endIndex = startIndex + generator.nextInt(len ~/ 2);
              source.fillRange(startIndex, endIndex, false);
              for (var i = 0; i < len; i++) {
                final expected = !i.between(startIndex, endIndex - 1);
                expect(source.getUnchecked(i), expected);
              }
            }
          });
          test('fill range (true)', () {
            final generator = Random(926);
            for (var len = 2; len < 250; len++) {
              final source = BitList.filled(len, false, growable: growable);
              final startIndex = generator.nextInt(len ~/ 2);
              final endIndex = startIndex + generator.nextInt(len ~/ 2);
              source.fillRange(startIndex, endIndex, true);
              for (var i = 0; i < len; i++) {
                final expected = i.between(startIndex, endIndex - 1);
                expect(source.getUnchecked(i), expected);
              }
            }
          });
          test('flipping', () {
            for (var len = 0; len < 100; len++) {
              final source = BitList.of(
                randomBooleans(385 * len, len),
                growable: growable,
              );
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
          test('count', () {
            for (var len = 0; len < 100; len++) {
              final list = BitList.of(
                randomBooleans(743 * len, len),
                growable: growable,
              );
              final trueCount = list.count();
              final falseCount = list.count(expected: false);
              expect(trueCount + falseCount, list.length);
              expect(trueCount, list.where((b) => b == true).length);
              expect(falseCount, list.where((b) => b == false).length);
            }
          });
          test('countRange', () {
            final generator = Random(926);
            final list = BitList.of(
              randomBooleans(744, 500),
              growable: growable,
            );
            for (var i = 0; i < 250; i++) {
              final startIndex = generator.nextInt(list.length ~/ 2);
              final endIndex = startIndex + generator.nextInt(list.length ~/ 2);
              final trueCount = list.countRange(startIndex, endIndex);
              final falseCount = list.countRange(
                startIndex,
                endIndex,
                expected: false,
              );
              expect(trueCount + falseCount, endIndex - startIndex);
              final range = list.getRange(startIndex, endIndex);
              expect(trueCount, range.where((b) => b == true).length);
              expect(falseCount, range.where((b) => b == false).length);
            }
          });
          test('indices', () {
            for (var len = 0; len < 100; len++) {
              final list = BitList.of(
                randomBooleans(743 * len, len),
                growable: growable,
              );
              final trueList = list.indices().toList();
              final trueSet = trueList.toSet();
              final falseList = list.indices(expected: false).toList();
              final falseSet = falseList.toSet();
              expect(trueSet.length, trueList.length);
              expect(falseSet.length, falseList.length);
              expect(trueSet.union(falseSet).length, list.length);
              for (final trueIndex in trueSet) {
                expect(list[trueIndex], isTrue);
              }
              for (final falseIndex in falseSet) {
                expect(list[falseIndex], isFalse);
              }
            }
          });
        });
        group('operators', () {
          test('concatenate', () {
            for (var len1 = 0; len1 < 100; len1++) {
              for (var len2 = 0; len2 < 100; len2++) {
                final source1 = BitList.of(
                  randomBooleans(954 * len1, len1),
                  growable: growable,
                );
                final source2 = BitList.of(
                  randomBooleans(713 * len2, len2),
                  growable: growable,
                );
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
              final source = BitList.of(
                randomBooleans(702, 100),
                growable: growable,
              );
              final target = ~source;
              for (var i = 0; i < target.length; i++) {
                expect(target[i], !source[i]);
              }
            });
            test('in-place', () {
              final source = BitList.of(
                randomBooleans(702, 100),
                growable: growable,
              );
              final target = BitList.of(source);
              target.not();
              for (var i = 0; i < target.length; i++) {
                expect(target[i], !source[i]);
              }
            });
          });
          group('intersection', () {
            test('operator', () {
              final source1 = BitList.of(
                randomBooleans(439, 100),
                growable: growable,
              );
              final source2 = BitList.of(
                randomBooleans(902, 100),
                growable: growable,
              );
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
              final source1 = BitList.of(
                randomBooleans(439, 100),
                growable: growable,
              );
              final source2 = BitList.of(
                randomBooleans(902, 100),
                growable: growable,
              );
              final target = BitList.of(source1);
              target.and(source2);
              for (var i = 0; i < target.length; i++) {
                expect(target[i], source1[i] && source2[i]);
              }
            });
          });
          group('union', () {
            test('operator', () {
              final source1 = BitList.of(
                randomBooleans(817, 100),
                growable: growable,
              );
              final source2 = BitList.of(
                randomBooleans(858, 100),
                growable: growable,
              );
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
              final source1 = BitList.of(
                randomBooleans(439, 100),
                growable: growable,
              );
              final source2 = BitList.of(
                randomBooleans(902, 100),
                growable: growable,
              );
              final target = BitList.of(source1);
              target.or(source2);
              for (var i = 0; i < target.length; i++) {
                expect(target[i], source1[i] || source2[i]);
              }
            });
          });
          test('difference', () {
            final source1 = BitList.of(
              randomBooleans(364, 100),
              growable: growable,
            );
            final source2 = BitList.of(
              randomBooleans(243, 100),
              growable: growable,
            );
            final target = source1 - source2;
            for (var i = 0; i < target.length; i++) {
              expect(target[i], source1[i] && !source2[i]);
            }
            expect(target, source1 & ~source2);
            final other = BitList(99, growable: growable);
            expect(() => other - source1, throwsArgumentError);
            expect(() => source1 - other, throwsArgumentError);
          });
          test('shift-left', () {
            for (var len = 0; len < 100; len++) {
              final source = BitList.of(
                randomBooleans(836 * len, len),
                growable: growable,
              );
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
              final source = BitList.of(
                randomBooleans(963 * len, len),
                growable: growable,
              );
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
        if (growable) {
          test('add', () {
            final source = randomBooleans(325, 500);
            final target = BitList.empty(growable: growable);
            for (var i = 0; i < source.length; i++) {
              target.add(source[i]);
              expect(target, source.getRange(0, i + 1));
            }
          });
          test('addAdd', () {
            final generator = Random(532);
            final source = randomBooleans(638, 2500);
            final target = BitList.empty(growable: growable);
            for (var start = 0; start < source.length;) {
              final end = min(source.length, start + generator.nextInt(25));
              target.addAll(source.getRange(start, end));
              expect(target, source.getRange(0, end));
              start = end;
            }
          });
          test('clear', () {
            final target = BitList.filled(2500, true, growable: growable);
            target.clear();
            expect(target, isEmpty);
          });
          test('length', () {
            final target = BitList.filled(100, false, growable: growable);
            final buffer = target.buffer;
            target.length += 1;
            expect(target.buffer, same(buffer));
            target.length -= 2;
            expect(target.buffer, same(buffer));
          });
          test('length (cleared)', () {
            final generator = Random(584);
            for (var i = 0; i < 0xff; i++) {
              final original = 1 + generator.nextInt(0xff);
              final smaller = generator.nextInt(original);
              final larger = original + generator.nextInt(0xff);
              final target = BitList.filled(original, true, growable: growable);
              target.length = smaller;
              target.length = larger;
              for (var i = 0; i < smaller; i++) {
                expect(target[i], isTrue);
              }
              for (var i = smaller; i < larger; i++) {
                expect(target[i], isFalse);
              }
            }
          });
          test('removeLast', () {
            final source = randomBooleans(453, 500);
            final target = BitList.of(source, growable: growable);
            for (var i = source.length - 1; i >= 0; i--) {
              expect(target.removeLast(), source[i]);
              expect(target, source.getRange(0, i));
            }
          });
        } else {
          test('unsupported operations', () {
            final list = BitList(32, growable: growable);
            expect(() => list.add(false), throwsUnsupportedError);
            expect(() => list.addAll([true, false]), throwsUnsupportedError);
            expect(() => list.clear(), throwsUnsupportedError);
            expect(() => list.insert(2, true), throwsUnsupportedError);
            expect(
              () => list.insertAll(2, [true, false]),
              throwsUnsupportedError,
            );
            expect(() => list.length = 10, throwsUnsupportedError);
            expect(() => list.remove(true), throwsUnsupportedError);
            expect(() => list.removeAt(2), throwsUnsupportedError);
            expect(() => list.removeLast(), throwsUnsupportedError);
            expect(() => list.removeRange(2, 4), throwsUnsupportedError);
            expect(
              () => list.removeWhere((value) => true),
              throwsUnsupportedError,
            );
            expect(
              () => list.replaceRange(2, 4, [true, false]),
              throwsUnsupportedError,
            );
            expect(
              () => list.retainWhere((value) => false),
              throwsUnsupportedError,
            );
          });
        }
      });
    }
  });
  group('fenwick', () {
    for (final (:name, :list) in [
      (name: 'empty', list: <int>[]),
      (name: 'single', list: [42]),
      (name: 'full', list: [-6, 11, 3, -20, 16, -5, -10, -19, -7, 8, 7, 4]),
    ]) {
      group(name, () {
        final tree = FenwickTree.of(list);
        test('length', () {
          expect(tree.isEmpty, list.isEmpty);
          expect(tree.isNotEmpty, list.isNotEmpty);
          expect(tree.length, list.length);
        });
        test('iterator', () {
          expect(List.of(tree), list);
        });
        test('toList', () {
          expect(tree.toList(), list);
        });
        test('read', () {
          for (var i = 0; i < list.length; i++) {
            expect(tree[i], list[i]);
          }
          expect(() => tree[-1], throwsRangeError);
          expect(() => tree[list.length], throwsRangeError);
        });
        test('write', () {
          final copy = FenwickTree.of(tree);
          for (var i = 0; i < list.length; i++) {
            copy[i] = i;
          }
          expect(tree, list);
          expect(copy, 0.to(list.length));
          expect(() => tree[-1] = 0, throwsRangeError);
          expect(() => tree[list.length] = 0, throwsRangeError);
        });
        if (list.isNotEmpty) {
          test('prefix', () {
            for (var i = 0; i <= list.length; i++) {
              expect(
                tree.prefix(i),
                list.getRange(0, i).fold(0, (a, b) => a + b),
                reason: '$i',
              );
            }
          });
          test('range', () {
            for (var i = 0; i <= list.length; i++) {
              for (var j = i; j <= list.length; j++) {
                expect(
                  tree.range(i, j),
                  list.getRange(i, j).fold(0, (a, b) => a + b),
                  reason: '$i..$j',
                );
              }
            }
          });
          test('update', () {
            final copy = FenwickTree.of(tree);
            for (var i = 0; i < list.length; i++) {
              copy.update(i, 1);
            }
            expect(copy, list.map((each) => each + 1));
          });
        }
      });
    }
    test('stress', () {
      final random = Random(572315);
      for (var i = 0; i < 10; i++) {
        final list = List.generate(
          random.nextInt(10000),
          (index) => random.nextInt(1000),
        );
        final tree = FenwickTree.of(list);
        expect(tree.toList(), list);
        expect(List.of(tree), list);
        for (var i = 0; i < list.length; i++) {
          expect(tree[i], list[i]);
        }
      }
    });
  });
  group('iterable', () {
    group('chunked', () {
      test('empty', () {
        final iterable = <int>[].chunked(2);
        expect(iterable, <int>[]);
      });
      test('even', () {
        final iterable = [1, 2, 3, 4].chunked(2);
        expect(iterable, [
          [1, 2],
          [3, 4],
        ]);
      });
      test('odd', () {
        final iterable = [1, 2, 3, 4, 5].chunked(2);
        expect(iterable, [
          [1, 2],
          [3, 4],
          [5],
        ]);
      });
      group('with padding', () {
        test('empty', () {
          final iterable = <int>[].chunkedWithPadding(2, 0);
          expect(iterable, <int>[]);
        });
        test('even', () {
          final iterable = [1, 2, 3, 4].chunkedWithPadding(2, 0);
          expect(iterable, [
            [1, 2],
            [3, 4],
          ]);
        });
        test('odd', () {
          final iterable = [1, 2, 3, 4, 5].chunkedWithPadding(2, 0);
          expect(iterable, [
            [1, 2],
            [3, 4],
            [5, 0],
          ]);
        });
      });
    });
    group('combinations', () {
      final letters = 'abcd'.toList();
      group('with repetitions', () {
        test('take 0', () {
          final iterable = letters.combinations(0, repetitions: true);
          expect(iterable, <List<String>>[[]]);
        });
        test('take 1', () {
          final iterable = letters.combinations(1, repetitions: true);
          expect(iterable, [
            ['a'],
            ['b'],
            ['c'],
            ['d'],
          ]);
        });
        test('take 2', () {
          final iterable = letters.combinations(2, repetitions: true);
          expect(iterable.map(joiner), [
            'aa',
            'ab',
            'ac',
            'ad',
            'bb',
            'bc',
            'bd',
            'cc',
            'cd',
            'dd',
          ]);
        });
        test('take 3', () {
          final iterable = letters.combinations(3, repetitions: true);
          expect(iterable.map(joiner), [
            'aaa',
            'aab',
            'aac',
            'aad',
            'abb',
            'abc',
            'abd',
            'acc',
            'acd',
            'add',
            'bbb',
            'bbc',
            'bbd',
            'bcc',
            'bcd',
            'bdd',
            'ccc',
            'ccd',
            'cdd',
            'ddd',
          ]);
        });
        test('take 4', () {
          final iterable = letters.combinations(4, repetitions: true);
          expect(iterable.map(joiner), [
            'aaaa',
            'aaab',
            'aaac',
            'aaad',
            'aabb',
            'aabc',
            'aabd',
            'aacc',
            'aacd',
            'aadd',
            'abbb',
            'abbc',
            'abbd',
            'abcc',
            'abcd',
            'abdd',
            'accc',
            'accd',
            'acdd',
            'addd',
            'bbbb',
            'bbbc',
            'bbbd',
            'bbcc',
            'bbcd',
            'bbdd',
            'bccc',
            'bccd',
            'bcdd',
            'bddd',
            'cccc',
            'cccd',
            'ccdd',
            'cddd',
            'dddd',
          ]);
        });
        test('take 5', () {
          final iterable = letters.combinations(5, repetitions: true);
          expect(iterable.first.join(), 'aaaaa');
          expect(iterable.last.join(), 'ddddd');
          expect(iterable.length, 56);
        });
        test('take 6', () {
          final iterable = letters.combinations(6, repetitions: true);
          expect(iterable.first.join(), 'aaaaaa');
          expect(iterable.last.join(), 'dddddd');
          expect(iterable.length, 84);
        });
      });
      group('without repetions', () {
        test('take 0', () {
          final iterable = letters.combinations(0, repetitions: false);
          expect(iterable, <List<String>>[[]]);
        });
        test('take 1', () {
          final iterable = letters.combinations(1, repetitions: false);
          expect(iterable, [
            ['a'],
            ['b'],
            ['c'],
            ['d'],
          ]);
        });
        test('take 2', () {
          final iterable = letters.combinations(2, repetitions: false);
          expect(iterable.map(joiner), ['ab', 'ac', 'ad', 'bc', 'bd', 'cd']);
        });
        test('take 3', () {
          final iterable = letters.combinations(3, repetitions: false);
          expect(iterable.map(joiner), ['abc', 'abd', 'acd', 'bcd']);
        });
        test('take 4', () {
          final iterable = letters.combinations(4, repetitions: false);
          expect(iterable.map(joiner), ['abcd']);
        });
      });
      test('range error', () {
        expect(() => letters.combinations(-1), throwsRangeError);
        expect(
          () => letters.combinations(-1, repetitions: true),
          throwsRangeError,
        );
        expect(
          () => letters.combinations(-1, repetitions: false),
          throwsRangeError,
        );
        expect(
          () => letters.combinations(5, repetitions: false),
          throwsRangeError,
        );
      });
    });
    group('count', () {
      test('true', () {
        expect(<int>[].count((each) => true), 0);
        expect(<int>[1].count((each) => true), 1);
        expect(<int>[1, 2, 3].count((each) => true), 3);
        expect(<int>[1, 2, 3, 4, 5].count((each) => true), 5);
      });
      test('false', () {
        expect(<int>[].count((each) => false), 0);
        expect(<int>[1].count((each) => false), 0);
        expect(<int>[1, 2, 3].count((each) => false), 0);
        expect(<int>[1, 2, 3, 4, 5].count((each) => false), 0);
      });
      test('isOdd', () {
        expect(<int>[].count((each) => each.isOdd), 0);
        expect(<int>[1].count((each) => each.isOdd), 1);
        expect(<int>[1, 2, 3].count((each) => each.isOdd), 2);
        expect(<int>[1, 2, 3, 4, 5].count((each) => each.isOdd), 3);
      });
      test('occurrences', () {
        expect(<int>[].occurrences(5), 0);
        expect(<int>[5].occurrences(5), 1);
        expect(<int>[1].occurrences(5), 0);
        expect(<int>[1, 5, 4, 5, 2].occurrences(5), 2);
      });
    });
    group('flatMap', () {
      test('empty', () {
        expect(
          <int>[].flatMap<String>(
            (each) => throw StateError('Never to be called'),
          ),
          isEmpty,
        );
      });
      test('expand', () {
        expect(['a'].flatMap((each) => [1, 2]), [1, 2]);
      });
      test('collapse', () {
        expect(['a', 'b'].flatMap((each) => []), isEmpty);
      });
    });
    group('flatten', () {
      test('empty', () {
        expect(<Iterable<int>>[[], [], []].flatten(), isEmpty);
      });
      test('single', () {
        expect(
          [
            [1],
            [2],
            [3],
          ].flatten(),
          [1, 2, 3],
        );
      });
      test('double', () {
        expect(
          [
            [1, 2],
            [3, 4],
            [5, 6],
          ].flatten(),
          [1, 2, 3, 4, 5, 6],
        );
      });
    });
    group('deepFlatten', () {
      test('empty', () {
        expect(<int>[].deepFlatten<int>(), isEmpty);
      });
      test('flat', () {
        expect([1, 2, 3, 4, 5, 6].deepFlatten<int>(), [1, 2, 3, 4, 5, 6]);
      });
      test('nested', () {
        expect(
          [
            1,
            2,
            [
              3,
              4,
              [5, 6],
            ],
          ].deepFlatten<int>(),
          [1, 2, 3, 4, 5, 6],
        );
      });
      test('error', () {
        expect(() => [1, 'hello'].deepFlatten<int>(), throwsArgumentError);
        expect(() => [1, null].deepFlatten<int>(), throwsArgumentError);
      });
    });
    group('groupBy', () {
      final example = 'aaaabbbccdaabbb'.toList();
      test('groupBy empty', () {
        final iterable = <int>[].groupBy<int>();
        expect(iterable, isEmpty);
      });
      test('groupBy basic', () {
        final iterable = example.groupBy<String>();
        expect(iterable.map((each) => each.key), [
          'a',
          'b',
          'c',
          'd',
          'a',
          'b',
        ]);
        expect(iterable.map((each) => each.values), [
          ['a', 'a', 'a', 'a'],
          ['b', 'b', 'b'],
          ['c', 'c'],
          ['d'],
          ['a', 'a'],
          ['b', 'b', 'b'],
        ]);
      });
      test('groupBy mapping', () {
        final iterable = example.reversed.groupBy((key) => key.codeUnitAt(0));
        expect(iterable.map((each) => each.key), [98, 97, 100, 99, 98, 97]);
        expect(iterable.map((each) => each.values), [
          ['b', 'b', 'b'],
          ['a', 'a'],
          ['d'],
          ['c', 'c'],
          ['b', 'b', 'b'],
          ['a', 'a', 'a', 'a'],
        ]);
      });
    });
    group('indexed', () {
      test('empty', () {
        final iterable = <int>[].indexed();
        expect(iterable, isEmpty);
      });
      test('simple', () {
        final iterable = ['a', 'b', 'c'].indexed();
        expect(iterable.map((each) => each.key), [0, 1, 2]);
        expect(iterable.map((each) => each.value), ['a', 'b', 'c']);
        expect(iterable.map((each) => each.toString()), [
          'MapEntry(0: a)',
          'MapEntry(1: b)',
          'MapEntry(2: c)',
        ]);
      });
      test('start', () {
        final actual = ['a', 'b']
            .indexed(start: 1)
            .map((each) => '${each.value}-${each.index}')
            .join(', ');
        const expected = 'a-1, b-2';
        expect(actual, expected);
      });
      test('step', () {
        final actual = ['a', 'b']
            .indexed(step: 2)
            .map((each) => '${each.value}-${each.index}')
            .join(', ');
        const expected = 'a-0, b-2';
        expect(actual, expected);
      });
      test('reverse', () {
        final actual = ['a', 'b']
            .indexed(start: 1, step: -1)
            .map((each) => '${each.value}-${each.index}')
            .join(', ');
        const expected = 'a-1, b-0';
        expect(actual, expected);
      });
      test('entries', () {
        final iterable = ['a', 'b', 'c'].indexed();
        expect(Map.fromEntries(iterable), {0: 'a', 1: 'b', 2: 'c'});
      });
      test('offset (deprecated)', () {
        final actual = ['a', 'b']
            .indexed(offset: 1)
            .map((each) => '${each.value}-${each.index}')
            .join(', ');
        const expected = 'a-1, b-2';
        expect(actual, expected);
      });
    });
    group('iterate', () {
      test('natural numbers', () {
        final iterable = iterate<int>(0, (a) => a + 1);
        expect(iterable.take(10), [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
      });
      test('powers of two', () {
        final iterable = iterate<int>(1, (a) => 2 * a);
        expect(iterable.take(10), [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]);
      });
      test('infinite', () {
        final iterable = iterate<int>(1, (a) => 2 * a);
        expect(iterable.isEmpty, isFalse);
        expect(iterable.isNotEmpty, isTrue);
        expect(() => iterable.length, throwsUnsupportedError);
        expect(() => iterable.last, throwsUnsupportedError);
        expect(() => iterable.lastWhere((e) => true), throwsUnsupportedError);
        expect(() => iterable.single, throwsUnsupportedError);
        expect(() => iterable.singleWhere((e) => true), throwsUnsupportedError);
        expect(() => iterable.toList(), throwsUnsupportedError);
        expect(() => iterable.toSet(), throwsUnsupportedError);
      });
    });
    group('operators', () {
      const empty = <int>[];
      const reverse = reverseComparable<num>;
      group('min', () {
        test('empty', () {
          expect(() => empty.min(), throwsStateError);
          expect(empty.min(orElse: () => -1), -1);
        });
        test('comparable', () {
          expect([1, 2, 3].min(), 1);
          expect([3, 2, 1].min(), 1);
        });
        test('custom comparator', () {
          expect([1, 2, 3].min(comparator: reverse), 3);
          expect([3, 2, 1].min(comparator: reverse), 3);
        });
      });
      group('max', () {
        test('empty', () {
          expect(() => empty.max(), throwsStateError);
          expect(empty.max(orElse: () => -1), -1);
        });
        test('comparable', () {
          expect([1, 2, 3].max(), 3);
          expect([3, 2, 1].max(), 3);
        });
        test('custom comparator', () {
          expect([1, 2, 3].max(comparator: reverse), 1);
          expect([3, 2, 1].max(comparator: reverse), 1);
        });
      });
      group('min/max', () {
        const sentinel = (min: -1, max: -1);
        test('empty', () {
          expect(() => empty.minMax(), throwsStateError);
          expect(empty.minMax(orElse: () => sentinel), sentinel);
        });
        test('comparable', () {
          expect([1, 2, 3].minMax(), (min: 1, max: 3));
          expect([3, 2, 1].minMax(), (min: 1, max: 3));
        });
        test('custom comparator', () {
          expect([1, 2, 3].minMax(comparator: reverse), (min: 3, max: 1));
          expect([3, 2, 1].minMax(comparator: reverse), (min: 3, max: 1));
        });
      });
      group('smallest', () {
        test('empty', () {
          expect(empty.smallest(0), isEmpty);
          expect(empty.smallest(1), isEmpty);
          expect(empty.smallest(2), isEmpty);
          expect(empty.smallest(3), isEmpty);
          expect(empty.smallest(4), isEmpty);
        });
        test('comparable', () {
          expect([3, 1, 2].smallest(0), isEmpty);
          expect([3, 1, 2].smallest(1), [1]);
          expect([3, 1, 2].smallest(2), [1, 2]);
          expect([3, 1, 2].smallest(3), [1, 2, 3]);
          expect([3, 1, 2].smallest(4), [1, 2, 3]);
        });
        test('custom comparator', () {
          expect([3, 1, 2].smallest(0, comparator: reverse), isEmpty);
          expect([3, 1, 2].smallest(1, comparator: reverse), [3]);
          expect([3, 1, 2].smallest(2, comparator: reverse), [3, 2]);
          expect([3, 1, 2].smallest(3, comparator: reverse), [3, 2, 1]);
          expect([3, 1, 2].smallest(4, comparator: reverse), [3, 2, 1]);
        });
      });
      group('largest', () {
        test('empty', () {
          expect(empty.largest(0), isEmpty);
          expect(empty.largest(1), isEmpty);
          expect(empty.largest(2), isEmpty);
          expect(empty.largest(3), isEmpty);
        });
        test('comparable', () {
          expect([3, 1, 2].largest(0), isEmpty);
          expect([3, 1, 2].largest(1), [3]);
          expect([3, 1, 2].largest(2), [3, 2]);
          expect([3, 1, 2].largest(3), [3, 2, 1]);
          expect([3, 1, 2].largest(4), [3, 2, 1]);
        });
        test('custom comparator', () {
          expect([3, 1, 2].largest(0, comparator: reverse), isEmpty);
          expect([3, 1, 2].largest(1, comparator: reverse), [1]);
          expect([3, 1, 2].largest(2, comparator: reverse), [1, 2]);
          expect([3, 1, 2].largest(3, comparator: reverse), [1, 2, 3]);
          expect([3, 1, 2].largest(4, comparator: reverse), [1, 2, 3]);
        });
      });
    });
    group('pairwise', () {
      test('empty', () {
        final iterator = <int>[].pairwise();
        expect(iterator, isEmpty);
      });
      test('1 element', () {
        final iterator = <int>[1].pairwise();
        expect(iterator, isEmpty);
      });
      test('2 elements', () {
        final iterator = <int>[1, 2].pairwise();
        expect(iterator, [(1, 2)]);
      });
      test('3 elements', () {
        final iterator = <int>[1, 2, 3].pairwise();
        expect(iterator, [(1, 2), (2, 3)]);
      });
      test('4 elements', () {
        final iterator = <int>[1, 2, 3, 4].pairwise();
        expect(iterator, [(1, 2), (2, 3), (3, 4)]);
      });
    });
    group('pairwise', () {
      test('empty', () {
        final result = <int>[].partition((each) => each.isEven);
        expect(result.truthy, isEmpty);
        expect(result.falsey, isEmpty);
      });
      test('single true', () {
        final result = ['hello'].partition((each) => true);
        expect(result.truthy, ['hello']);
        expect(result.falsey, isEmpty);
      });
      test('single false', () {
        final result = ['world'].partition((each) => false);
        expect(result.truthy, isEmpty);
        expect(result.falsey, ['world']);
      });
      test('example', () {
        final result = [1, 2, 3, 4].partition((each) => each.isEven);
        expect(result.truthy, [2, 4]);
        expect(result.falsey, [1, 3]);
      });
    });
    group('permutations', () {
      group('full permutations', () {
        test('empty', () {
          final iterator = ''.toList().permutations();
          expect(iterator, isEmpty);
        });
        test('single', () {
          final iterator = 'a'.toList().permutations();
          expect(iterator.map(joiner), ['a']);
        });
        test('2 element list', () {
          final iterator = 'ab'.toList().permutations();
          expect(iterator.map(joiner), ['ab', 'ba']);
        });
        test('3 element list', () {
          final iterator = 'abc'.toList().permutations();
          expect(iterator.map(joiner), [
            'abc',
            'acb',
            'bac',
            'bca',
            'cab',
            'cba',
          ]);
        });
      });
      group('partial permutations', () {
        test('0 of 2', () {
          final iterator = 'abc'.toList().permutations(0);
          expect(iterator.map(joiner), isEmpty);
        });
        test('1 of 3', () {
          final iterator = 'abc'.toList().permutations(1);
          expect(iterator.map(joiner), ['a', 'b', 'c']);
        });
        test('2 of 3', () {
          final iterator = 'abc'.toList().permutations(2);
          expect(iterator.map(joiner), ['ab', 'ac', 'ba', 'bc', 'ca', 'cb']);
        });
        test('2 of 4', () {
          final iterator = 'abcd'.toList().permutations(2);
          expect(iterator.map(joiner), [
            'ab',
            'ac',
            'ad',
            'ba',
            'bc',
            'bd',
            'ca',
            'cb',
            'cd',
            'da',
            'db',
            'dc',
          ]);
        });
        test('error', () {
          expect(() => 'abc'.toList().permutations(4), throwsRangeError);
          expect(() => 'abc'.toList().permutations(-1), throwsRangeError);
        });
      });
      group('nextPermutation', () {
        test('none', () {
          expect(<int>[].nextPermutation(), isFalse);
          expect([1].nextPermutation(), isFalse);
        });
        test('default', () {
          final list = [1, 2, 3];
          expect(list.nextPermutation(), isTrue);
          expect(list, [1, 3, 2]);
          expect(list.nextPermutation(), isTrue);
          expect(list, [2, 1, 3]);
          expect(list.nextPermutation(), isTrue);
          expect(list, [2, 3, 1]);
          expect(list.nextPermutation(), isTrue);
          expect(list, [3, 1, 2]);
          expect(list.nextPermutation(), isTrue);
          expect(list, [3, 2, 1]);
          expect(list.nextPermutation(), isFalse);
          expect(list, [3, 2, 1]);
        });
        test('custom', () {
          final list = [
            const Point<int>(2, 2),
            const Point<int>(3, 3),
            const Point<int>(1, 1),
          ];
          expect(
            list.nextPermutation(comparator: (a, b) => a.x.compareTo(b.x)),
            isTrue,
          );
          expect(list, [
            const Point<int>(3, 3),
            const Point<int>(1, 1),
            const Point<int>(2, 2),
          ]);
        });
      });
      group('previousPermutation', () {
        test('none', () {
          expect(<int>[].previousPermutation(), isFalse);
          expect([1].previousPermutation(), isFalse);
        });
        test('default', () {
          final list = [3, 2, 1];
          expect(list.previousPermutation(), isTrue);
          expect(list, [3, 1, 2]);
          expect(list.previousPermutation(), isTrue);
          expect(list, [2, 3, 1]);
          expect(list.previousPermutation(), isTrue);
          expect(list, [2, 1, 3]);
          expect(list.previousPermutation(), isTrue);
          expect(list, [1, 3, 2]);
          expect(list.previousPermutation(), isTrue);
          expect(list, [1, 2, 3]);
          expect(list.previousPermutation(), isFalse);
          expect(list, [1, 2, 3]);
        });
        test('custom', () {
          final list = [
            const Point<int>(2, 2),
            const Point<int>(3, 3),
            const Point<int>(1, 1),
          ];
          expect(
            list.previousPermutation(comparator: (a, b) => a.x.compareTo(b.x)),
            isTrue,
          );
          expect(list, [
            const Point<int>(2, 2),
            const Point<int>(1, 1),
            const Point<int>(3, 3),
          ]);
        });
      });
    });
    group('powerSet', () {
      test('empty', () {
        expect(<String>[].powerSet(), <List<String>>[[]]);
      });
      test('example', () {
        expect(['x', 'y', 'z'].powerSet(), <List<String>>[
          [],
          ['x'],
          ['y'],
          ['z'],
          ['x', 'y'],
          ['x', 'z'],
          ['y', 'z'],
          ['x', 'y', 'z'],
        ]);
      });
    });
    group('product', () {
      test('2', () {
        final iterable =
            [
              [1, 2],
            ].product();
        expect(iterable, [
          [1],
          [2],
        ]);
      });
      test('2 x 2', () {
        final iterable =
            [
              [1, 2],
              [3, 4],
            ].product();
        expect(iterable, [
          [1, 3],
          [1, 4],
          [2, 3],
          [2, 4],
        ]);
      });
      test('1 x 2 x 3', () {
        final iterable =
            [
              [1],
              [2, 3],
              [4, 5, 6],
            ].product();
        expect(iterable, [
          [1, 2, 4],
          [1, 2, 5],
          [1, 2, 6],
          [1, 3, 4],
          [1, 3, 5],
          [1, 3, 6],
        ]);
      });
      test('3 x 2 x 1', () {
        final iterable =
            [
              [1, 2, 3],
              [4, 5],
              [6],
            ].product();
        expect(iterable, [
          [1, 4, 6],
          [1, 5, 6],
          [2, 4, 6],
          [2, 5, 6],
          [3, 4, 6],
          [3, 5, 6],
        ]);
      });
      test('repeat 0', () {
        expect(() => <Iterable<int>>[].product(repeat: 0), throwsRangeError);
      });
      test('2 x repeat 2', () {
        final iterable = [
          [0, 1],
        ].product(repeat: 2);
        expect(iterable, [
          [0, 0],
          [0, 1],
          [1, 0],
          [1, 1],
        ]);
      });
      test('2 x 1 x repeat 2', () {
        final iterable = [
          [0, 1],
          [3],
        ].product(repeat: 2);
        expect(iterable, [
          [0, 3, 0, 3],
          [0, 3, 1, 3],
          [1, 3, 0, 3],
          [1, 3, 1, 3],
        ]);
      });
      test('2 x repeat 3', () {
        final iterable = [
          [0, 1],
        ].product(repeat: 3);
        expect(iterable, [
          [0, 0, 0],
          [0, 0, 1],
          [0, 1, 0],
          [0, 1, 1],
          [1, 0, 0],
          [1, 0, 1],
          [1, 1, 0],
          [1, 1, 1],
        ]);
      });
      test('1 x 2, repeat 3', () {
        final iterable = [
          [0, 1],
        ].product(repeat: 3);
        expect(iterable, [
          [0, 0, 0],
          [0, 0, 1],
          [0, 1, 0],
          [0, 1, 1],
          [1, 0, 0],
          [1, 0, 1],
          [1, 1, 0],
          [1, 1, 1],
        ]);
      });
      test('empty', () {
        expect(<Iterable<int>>[].product(), isEmpty);
        expect(<Iterable<int>>[[]].product(), isEmpty);
        expect(
          <Iterable<int>>[
            [1],
            [],
          ].product(),
          isEmpty,
        );
        expect(
          <Iterable<int>>[
            [],
            [1],
          ].product(),
          isEmpty,
        );
        expect(
          <Iterable<int>>[
            [1],
            [],
            [1],
          ].product(),
          isEmpty,
        );
      });
      group('tuple', () {
        test('basic', () {
          expect((['x', 'y'], [1, 2, 3]).product(), [
            ('x', 1),
            ('x', 2),
            ('x', 3),
            ('y', 1),
            ('y', 2),
            ('y', 3),
          ]);
        });
        test('empty', () {
          expect((<String>[], <int>[]).product(), isEmpty);
          expect((['x'], <int>[]).product(), isEmpty);
          expect((<String>[], [42]).product(), isEmpty);
        });
      });
    });
    group('random', () {
      test('empty', () {
        expect(() => <int>[].atRandom(), throwsStateError);
        expect(<int>[].atRandom(orElse: () => -1), -1);
      });
      test('single', () {
        expect([1].atRandom(), 1);
        expect([2].atRandom(), 2);
        expect([3].atRandom(), 3);
      });
      test('larger', () {
        final seen = <int>{};
        final picks = 0.to(10);
        while (seen.length < picks.length) {
          seen.add(picks.atRandom());
        }
      });
      test('custom', () {
        final seen = <int>{};
        final picks = 0.to(10);
        final random = Random(123456);
        while (seen.length < picks.length) {
          seen.add(picks.atRandom(random: random));
        }
      });
    });
    group('repeat element', () {
      test('default', () {
        expect(repeat(1).take(3), [1, 1, 1]);
        expect(repeat('a').take(3), ['a', 'a', 'a']);
      });
      test('zero', () {
        expect(repeat(2, count: 0), isEmpty);
        expect(repeat('b', count: 0), isEmpty);
      });
      test('one', () {
        expect(repeat(3, count: 1), [3]);
        expect(repeat('c', count: 1), ['c']);
      });
      test('two', () {
        expect(repeat(4, count: 2), [4, 4]);
        expect(repeat('d', count: 2), ['d', 'd']);
      });
      test('tree', () {
        expect(repeat(5, count: 3), [5, 5, 5]);
        expect(repeat('e', count: 3), ['e', 'e', 'e']);
      });
      test('error', () {
        expect(() => repeat(6, count: -1), throwsRangeError);
      });
      test('infinite', () {
        final iterable = repeat(42);
        expect(iterable.isEmpty, isFalse);
        expect(iterable.isNotEmpty, isTrue);
        expect(() => iterable.length, throwsUnsupportedError);
        expect(() => iterable.last, throwsUnsupportedError);
        expect(() => iterable.lastWhere((e) => true), throwsUnsupportedError);
        expect(() => iterable.single, throwsUnsupportedError);
        expect(() => iterable.singleWhere((e) => true), throwsUnsupportedError);
        expect(() => iterable.toList(), throwsUnsupportedError);
        expect(() => iterable.toSet(), throwsUnsupportedError);
      });
    });
    group('repeat iterable', () {
      test('empty', () {
        expect(<int>[].repeat(), isEmpty);
        expect(<int>[].repeat(count: 0), isEmpty);
        expect(<int>[].repeat(count: 1), isEmpty);
        expect(<int>[].repeat(count: 2), isEmpty);
        expect(<int>[].repeat(count: 3), isEmpty);
      });
      test('single', () {
        expect([1].repeat().take(3), [1, 1, 1]);
        expect([1].repeat(count: 0), isEmpty);
        expect([1].repeat(count: 1), [1]);
        expect([1].repeat(count: 2), [1, 1]);
        expect([1].repeat(count: 3), [1, 1, 1]);
      });
      test('double', () {
        expect([1, 2].repeat().take(5), [1, 2, 1, 2, 1]);
        expect([1, 2].repeat(count: 0), isEmpty);
        expect([1, 2].repeat(count: 1), [1, 2]);
        expect([1, 2].repeat(count: 2), [1, 2, 1, 2]);
        expect([1, 2].repeat(count: 3), [1, 2, 1, 2, 1, 2]);
      });
      test('triple', () {
        expect([1, 2, 3].repeat().take(7), [1, 2, 3, 1, 2, 3, 1]);
        expect([1, 2, 3].repeat(count: 0), isEmpty);
        expect([1, 2, 3].repeat(count: 1), [1, 2, 3]);
        expect([1, 2, 3].repeat(count: 2), [1, 2, 3, 1, 2, 3]);
        expect([1, 2, 3].repeat(count: 3), [1, 2, 3, 1, 2, 3, 1, 2, 3]);
      });
      test('infinite', () {
        final iterable = [1, 2, 3].repeat();
        expect(iterable.isEmpty, isFalse);
        expect(iterable.isNotEmpty, isTrue);
        expect(() => iterable.length, throwsUnsupportedError);
        expect(() => iterable.last, throwsUnsupportedError);
        expect(() => iterable.lastWhere((e) => true), throwsUnsupportedError);
        expect(() => iterable.single, throwsUnsupportedError);
        expect(() => iterable.singleWhere((e) => true), throwsUnsupportedError);
        expect(() => iterable.toList(), throwsUnsupportedError);
        expect(() => iterable.toSet(), throwsUnsupportedError);
      });
      test('error', () {
        expect(() => [1, 2, 3].repeat(count: -1), throwsRangeError);
      });
    });
    group('separatedBy', () {
      group('without before or after', () {
        test('empty', () {
          var s = 0;
          expect(<int>[].separatedBy(() => s++), isEmpty);
          expect(s, 0);
        });
        test('single', () {
          var s = 0;
          expect([10].separatedBy(() => s++), [10]);
          expect(s, 0);
        });
        test('double', () {
          var s = 0;
          expect([10, 20].separatedBy(() => s++), [10, 0, 20]);
          expect(s, 1);
        });
        test('triple', () {
          var s = 0;
          expect([10, 20, 30].separatedBy(() => s++), [10, 0, 20, 1, 30]);
          expect(s, 2);
        });
        test('iterator', () {
          final iterator = [42].separatedBy(() => 0).iterator;
          expect(iterator.moveNext(), isTrue);
          for (var i = 0; i <= 3; i++) {
            expect(iterator.current, 42);
          }
          for (var i = 0; i <= 3; i++) {
            expect(iterator.moveNext(), isFalse);
          }
        });
      });
      group('with before', () {
        test('empty', () {
          var s = 0, b = 0;
          expect(
            <int>[].separatedBy(() => s++, before: () => b++ + 5),
            isEmpty,
          );
          expect(s, 0);
          expect(b, 0);
        });
        test('single', () {
          var s = 0, b = 0;
          expect([10].separatedBy(() => s++, before: () => b++ + 5), [5, 10]);
          expect(s, 0);
          expect(b, 1);
        });
        test('double', () {
          var s = 0, b = 0;
          expect([10, 20].separatedBy(() => s++, before: () => b++ + 5), [
            5,
            10,
            0,
            20,
          ]);
          expect(s, 1);
          expect(b, 1);
        });
        test('triple', () {
          var s = 0, b = 0;
          expect([10, 20, 30].separatedBy(() => s++, before: () => b++ + 5), [
            5,
            10,
            0,
            20,
            1,
            30,
          ]);
          expect(s, 2);
          expect(b, 1);
        });
      });
      group('with after', () {
        test('empty', () {
          var s = 0, a = 0;
          expect(
            <int>[].separatedBy(() => s++, after: () => a++ + 15),
            isEmpty,
          );
          expect(s, 0);
          expect(a, 0);
        });
        test('single', () {
          var s = 0, a = 0;
          expect([10].separatedBy(() => s++, after: () => a++ + 15), [10, 15]);
          expect(s, 0);
          expect(a, 1);
        });
        test('double', () {
          var s = 0, a = 0;
          expect([10, 20].separatedBy(() => s++, after: () => a++ + 15), [
            10,
            0,
            20,
            15,
          ]);
          expect(s, 1);
          expect(a, 1);
        });
        test('triple', () {
          var s = 0, a = 0;
          expect([10, 20, 30].separatedBy(() => s++, after: () => a++ + 15), [
            10,
            0,
            20,
            1,
            30,
            15,
          ]);
          expect(s, 2);
          expect(a, 1);
        });
      });
      group('with before and after', () {
        test('empty', () {
          var s = 0, b = 0, a = 0;
          expect(
            <int>[].separatedBy(
              () => s++,
              before: () => b++ + 5,
              after: () => a++ + 15,
            ),
            isEmpty,
          );
          expect(s, 0);
          expect(b, 0);
          expect(a, 0);
        });
        test('single', () {
          var s = 0, b = 0, a = 0;
          expect(
            [10].separatedBy(
              () => s++,
              before: () => b++ + 5,
              after: () => a++ + 15,
            ),
            [5, 10, 15],
          );
          expect(s, 0);
          expect(b, 1);
          expect(a, 1);
        });
        test('double', () {
          var s = 0, b = 0, a = 0;
          expect(
            [10, 20].separatedBy(
              () => s++,
              before: () => b++ + 5,
              after: () => a++ + 15,
            ),
            [5, 10, 0, 20, 15],
          );
          expect(s, 1);
          expect(b, 1);
          expect(a, 1);
        });
        test('triple', () {
          var s = 0, b = 0, a = 0;
          expect(
            [10, 20, 30].separatedBy(
              () => s++,
              before: () => b++ + 5,
              after: () => a++ + 15,
            ),
            [5, 10, 0, 20, 1, 30, 15],
          );
          expect(s, 2);
          expect(b, 1);
          expect(a, 1);
        });
      });
    });
    group('toMap', () {
      test('empty', () {
        expect(<int>[].toMap<int, int>(), isEmpty);
      });
      test('default', () {
        const iterable = ['a', 'bb', 'ccc'];
        expect(iterable.toMap<String, String>(), {
          'a': 'a',
          'bb': 'bb',
          'ccc': 'ccc',
        });
      });
      test('custom', () {
        const iterable = ['a', 'bb', 'ccc'];
        expect(
          iterable.toMap(key: (each) => each[0], value: (each) => each.length),
          {'a': 1, 'b': 2, 'c': 3},
        );
      });
    });
    group('unique', () {
      test('identity', () {
        expect([1].unique(), [1]);
        expect([1, 2].unique(), [1, 2]);
        expect([1, 2, 3].unique(), [1, 2, 3]);
      });
      test('duplicates', () {
        expect([1, 1].unique(), [1]);
        expect([1, 2, 2, 1].unique(), [1, 2]);
        expect([1, 2, 3, 3, 2, 1].unique(), [1, 2, 3]);
      });
      test('repeated', () {
        final uniques = [1, 2, 2, 3, 3, 3].unique();
        expect(uniques, [1, 2, 3]);
        expect(uniques, [1, 2, 3]);
      });
      test('factory', () {
        final uniques = [
          1,
          2,
          2,
          3,
          3,
          3,
        ].unique(factory: StorageStrategy.positiveInteger().createSet);
        expect(uniques, [1, 2, 3]);
        expect(uniques, [1, 2, 3]);
      });
      test('equals and hashCode', () {
        final a = const Point(1, 2), b = const Point(1, 1) + const Point(0, 1);
        final uniques = [a, b, a].unique(
          equals: (a, b) => identical(a, b),
          hashCode: (a) => identityHashCode(a),
        );
        expect(uniques, [a, b]);
        expect(uniques, [a, b]);
      });
    });
    group('window', () {
      test('error', () {
        expect(() => [1, 2, 3].window(0), throwsRangeError);
        expect(() => [1, 2, 3].window(1, step: 0), throwsRangeError);
      });
      test('size = 1', () {
        expect(<int>[].window(1), isEmpty);
        expect([1].window(1), [
          [1],
        ]);
        expect([1, 2].window(1), [
          [1],
          [2],
        ]);
        expect([1, 2, 3].window(1), [
          [1],
          [2],
          [3],
        ]);
        expect([1, 2, 3, 4].window(1), [
          [1],
          [2],
          [3],
          [4],
        ]);
        expect([1, 2, 3, 4, 5].window(1), [
          [1],
          [2],
          [3],
          [4],
          [5],
        ]);
      });
      test('size = 2', () {
        expect(<int>[].window(2), isEmpty);
        expect([1].window(2), isEmpty);
        expect([1, 2].window(2), [
          [1, 2],
        ]);
        expect([1, 2, 3].window(2), [
          [1, 2],
          [2, 3],
        ]);
        expect([1, 2, 3, 4].window(2), [
          [1, 2],
          [2, 3],
          [3, 4],
        ]);
        expect([1, 2, 3, 4, 5].window(2), [
          [1, 2],
          [2, 3],
          [3, 4],
          [4, 5],
        ]);
      });
      test('size = 2, step = 2', () {
        expect(<int>[].window(2, step: 2), isEmpty);
        expect([1].window(2, step: 2), isEmpty);
        expect([1, 2].window(2, step: 2), [
          [1, 2],
        ]);
        expect([1, 2, 3].window(2, step: 2), [
          [1, 2],
        ]);
        expect([1, 2, 3, 4].window(2, step: 2), [
          [1, 2],
          [3, 4],
        ]);
        expect([1, 2, 3, 4, 5].window(2, step: 2), [
          [1, 2],
          [3, 4],
        ]);
      });
      test('size = 2, step = 3', () {
        expect(<int>[].window(2, step: 3), isEmpty);
        expect([1].window(2, step: 3), isEmpty);
        expect([1, 2].window(2, step: 3), [
          [1, 2],
        ]);
        expect([1, 2, 3].window(2, step: 3), [
          [1, 2],
        ]);
        expect([1, 2, 3, 4].window(2, step: 3), [
          [1, 2],
        ]);
        expect([1, 2, 3, 4, 5].window(2, step: 3), [
          [1, 2],
          [4, 5],
        ]);
      });
      test('size = 2, includePartial', () {
        expect(<int>[].window(2, includePartial: true), isEmpty);
        expect([1].window(2, includePartial: true), [
          [1],
        ]);
        expect([1, 2].window(2, includePartial: true), [
          [1, 2],
          [2],
        ]);
        expect([1, 2, 3].window(2, includePartial: true), [
          [1, 2],
          [2, 3],
          [3],
        ]);
        expect([1, 2, 3, 4].window(2, includePartial: true), [
          [1, 2],
          [2, 3],
          [3, 4],
          [4],
        ]);
        expect([1, 2, 3, 4, 5].window(2, includePartial: true), [
          [1, 2],
          [2, 3],
          [3, 4],
          [4, 5],
          [5],
        ]);
      });
      test('size = 2, step = 2, includePartial', () {
        expect(<int>[].window(2, step: 2, includePartial: true), isEmpty);
        expect([1].window(2, step: 2, includePartial: true), [
          [1],
        ]);
        expect([1, 2].window(2, step: 2, includePartial: true), [
          [1, 2],
        ]);
        expect([1, 2, 3].window(2, step: 2, includePartial: true), [
          [1, 2],
          [3],
        ]);
        expect([1, 2, 3, 4].window(2, step: 2, includePartial: true), [
          [1, 2],
          [3, 4],
        ]);
        expect([1, 2, 3, 4, 5].window(2, step: 2, includePartial: true), [
          [1, 2],
          [3, 4],
          [5],
        ]);
      });
      test('size = 2, step = 3, includePartial', () {
        expect(<int>[].window(2, step: 3, includePartial: true), isEmpty);
        expect([1].window(2, step: 3, includePartial: true), [
          [1],
        ]);
        expect([1, 2].window(2, step: 3, includePartial: true), [
          [1, 2],
        ]);
        expect([1, 2, 3].window(2, step: 3, includePartial: true), [
          [1, 2],
        ]);
        expect([1, 2, 3, 4].window(2, step: 3, includePartial: true), [
          [1, 2],
          [4],
        ]);
        expect([1, 2, 3, 4, 5].window(2, step: 3, includePartial: true), [
          [1, 2],
          [4, 5],
        ]);
      });
    });
    group('zip', () {
      group('default', () {
        test('empty', () {
          expect(<Iterable<int>>[].zip(), <int>[]);
        });
        test('single', () {
          expect(
            [
              [1, 2, 3],
            ].zip(),
            [
              [1],
              [2],
              [3],
            ],
          );
        });
        test('pair', () {
          expect(
            [
              [1, 2, 3],
              ['a', 'b', 'c'],
            ].zip(),
            [
              [1, 'a'],
              [2, 'b'],
              [3, 'c'],
            ],
          );
          expect(
            [
              [1, 2],
              ['a', 'b', 'c'],
            ].zip(),
            [
              [1, 'a'],
              [2, 'b'],
            ],
          );
          expect(
            [
              [1, 2, 3],
              ['a', 'b'],
            ].zip(),
            [
              [1, 'a'],
              [2, 'b'],
            ],
          );
        });
        test('tuple', () {
          expect(([1, 2, 3], ['a', 'b', 'c']).zip(), [
            (1, 'a'),
            (2, 'b'),
            (3, 'c'),
          ]);
          expect(([1, 2], ['a', 'b', 'c']).zip(), [(1, 'a'), (2, 'b')]);
          expect(([1, 2, 3], ['a', 'b']).zip(), [(1, 'a'), (2, 'b')]);
        });
      });
      group('partial', () {
        test('empty', () {
          expect(<Iterable<int>>[].zipPartial(), <int>[]);
        });
        test('single', () {
          expect(
            [
              [1, 2, 3],
            ].zipPartial(),
            [
              [1],
              [2],
              [3],
            ],
          );
        });
        test('pair', () {
          expect(
            [
              [1, 2, 3],
              ['a', 'b', 'c'],
            ].zipPartial(),
            [
              [1, 'a'],
              [2, 'b'],
              [3, 'c'],
            ],
          );
          expect(
            [
              [1, 2],
              ['a', 'b', 'c'],
            ].zipPartial(),
            [
              [1, 'a'],
              [2, 'b'],
              [null, 'c'],
            ],
          );
          expect(
            [
              [1, 2, 3],
              ['a', 'b'],
            ].zipPartial(),
            [
              [1, 'a'],
              [2, 'b'],
              [3, null],
            ],
          );
        });
        test('tuple', () {
          expect(([1, 2, 3], ['a', 'b', 'c']).zipPartial(), [
            (1, 'a'),
            (2, 'b'),
            (3, 'c'),
          ]);
          expect(([1, 2], ['a', 'b', 'c']).zipPartial(), [
            (1, 'a'),
            (2, 'b'),
            (null, 'c'),
          ]);
          expect(([1, 2, 3], ['a', 'b']).zipPartial(), [
            (1, 'a'),
            (2, 'b'),
            (3, null),
          ]);
        });
      });
      group('partial with', () {
        test('empty', () {
          expect(<Iterable<int>>[].zipPartialWith(0), <int>[]);
        });
        test('single', () {
          expect(
            [
              [1, 2, 3],
            ].zipPartialWith(0),
            [
              [1],
              [2],
              [3],
            ],
          );
        });
        test('pair', () {
          expect(
            [
              [1, 2, 3],
              ['a', 'b', 'c'],
            ].zipPartialWith(0),
            [
              [1, 'a'],
              [2, 'b'],
              [3, 'c'],
            ],
          );
          expect(
            [
              [1, 2],
              ['a', 'b', 'c'],
            ].zipPartialWith(0),
            [
              [1, 'a'],
              [2, 'b'],
              [0, 'c'],
            ],
          );
          expect(
            [
              [1, 2, 3],
              ['a', 'b'],
            ].zipPartialWith(0),
            [
              [1, 'a'],
              [2, 'b'],
              [3, 0],
            ],
          );
        });
        test('tuple', () {
          expect(([1, 2, 3], ['a', 'b', 'c']).zipPartialWith((4, 'd')), [
            (1, 'a'),
            (2, 'b'),
            (3, 'c'),
          ]);
          expect(([1, 2], ['a', 'b', 'c']).zipPartialWith((4, 'd')), [
            (1, 'a'),
            (2, 'b'),
            (4, 'c'),
          ]);
          expect(([1, 2, 3], ['a', 'b']).zipPartialWith((4, 'd')), [
            (1, 'a'),
            (2, 'b'),
            (3, 'd'),
          ]);
        });
      });
    });
  });
  group('list', () {
    group('rotate', () {
      group('list', () {
        test('size = 0', () {
          expect(<int>[]..rotate(-1), isEmpty);
          expect(<int>[]..rotate(0), isEmpty);
          expect(<int>[]..rotate(1), isEmpty);
        });
        group('size = 1', () {
          test('offset = 0', () {
            expect([0]..rotate(0), [0]);
          });
          test('offset = ±1', () {
            expect([0]..rotate(-1), [0]);
            expect([0]..rotate(1), [0]);
          });
        });
        group('size = 2', () {
          test('offset = 0', () {
            expect([0, 1]..rotate(0), [0, 1]);
          });
          test('offset = ±1', () {
            expect([0, 1]..rotate(-1), [1, 0]);
            expect([0, 1]..rotate(1), [1, 0]);
          });
          test('offset = ±2', () {
            expect([0, 1]..rotate(-2), [0, 1]);
            expect([0, 1]..rotate(2), [0, 1]);
          });
        });
        group('size = 3', () {
          test('offset = 0', () {
            expect([0, 1, 2]..rotate(0), [0, 1, 2]);
          });
          test('offset = ±1', () {
            expect([0, 1, 2]..rotate(-1), [1, 2, 0]);
            expect([0, 1, 2]..rotate(1), [2, 0, 1]);
          });
          test('offset = ±2', () {
            expect([0, 1, 2]..rotate(-2), [2, 0, 1]);
            expect([0, 1, 2]..rotate(2), [1, 2, 0]);
          });
          test('offset = ±3', () {
            expect([0, 1, 2]..rotate(-3), [0, 1, 2]);
            expect([0, 1, 2]..rotate(3), [0, 1, 2]);
          });
        });
        group('size = 4', () {
          test('offset = 0', () {
            expect([0, 1, 2, 3]..rotate(0), [0, 1, 2, 3]);
          });
          test('offset = ±1', () {
            expect([0, 1, 2, 3]..rotate(-1), [1, 2, 3, 0]);
            expect([0, 1, 2, 3]..rotate(1), [3, 0, 1, 2]);
          });
          test('offset = ±2', () {
            expect([0, 1, 2, 3]..rotate(-2), [2, 3, 0, 1]);
            expect([0, 1, 2, 3]..rotate(2), [2, 3, 0, 1]);
          });
          test('offset = ±3', () {
            expect([0, 1, 2, 3]..rotate(-3), [3, 0, 1, 2]);
            expect([0, 1, 2, 3]..rotate(3), [1, 2, 3, 0]);
          });
          test('offset = ±4', () {
            expect([0, 1, 2, 3]..rotate(-4), [0, 1, 2, 3]);
            expect([0, 1, 2, 3]..rotate(4), [0, 1, 2, 3]);
          });
        });
      });
      group('queue', () {
        test('size = 0', () {
          expect(Queue.of([])..rotate(-1), isEmpty);
          expect(Queue.of([])..rotate(0), isEmpty);
          expect(Queue.of([])..rotate(1), isEmpty);
        });
        group('size = 1', () {
          test('offset = 0', () {
            expect(Queue.of([0])..rotate(0), [0]);
          });
          test('offset = ±1', () {
            expect(Queue.of([0])..rotate(-1), [0]);
            expect(Queue.of([0])..rotate(1), [0]);
          });
        });
        group('size = 2', () {
          test('offset = 0', () {
            expect(Queue.of([0, 1])..rotate(0), [0, 1]);
          });
          test('offset = ±1', () {
            expect(Queue.of([0, 1])..rotate(-1), [1, 0]);
            expect(Queue.of([0, 1])..rotate(1), [1, 0]);
          });
          test('offset = ±2', () {
            expect(Queue.of([0, 1])..rotate(-2), [0, 1]);
            expect(Queue.of([0, 1])..rotate(2), [0, 1]);
          });
        });
        group('size = 3', () {
          test('offset = 0', () {
            expect(Queue.of([0, 1, 2])..rotate(0), [0, 1, 2]);
          });
          test('offset = ±1', () {
            expect(Queue.of([0, 1, 2])..rotate(-1), [1, 2, 0]);
            expect(Queue.of([0, 1, 2])..rotate(1), [2, 0, 1]);
          });
          test('offset = ±2', () {
            expect(Queue.of([0, 1, 2])..rotate(-2), [2, 0, 1]);
            expect(Queue.of([0, 1, 2])..rotate(2), [1, 2, 0]);
          });
          test('offset = ±3', () {
            expect(Queue.of([0, 1, 2])..rotate(-3), [0, 1, 2]);
            expect(Queue.of([0, 1, 2])..rotate(3), [0, 1, 2]);
          });
        });
        group('size = 4', () {
          test('offset = 0', () {
            expect(Queue.of([0, 1, 2, 3])..rotate(0), [0, 1, 2, 3]);
          });
          test('offset = ±1', () {
            expect(Queue.of([0, 1, 2, 3])..rotate(-1), [1, 2, 3, 0]);
            expect(Queue.of([0, 1, 2, 3])..rotate(1), [3, 0, 1, 2]);
          });
          test('offset = ±2', () {
            expect(Queue.of([0, 1, 2, 3])..rotate(-2), [2, 3, 0, 1]);
            expect(Queue.of([0, 1, 2, 3])..rotate(2), [2, 3, 0, 1]);
          });
          test('offset = ±3', () {
            expect(Queue.of([0, 1, 2, 3])..rotate(-3), [3, 0, 1, 2]);
            expect(Queue.of([0, 1, 2, 3])..rotate(3), [1, 2, 3, 0]);
          });
          test('offset = ±4', () {
            expect(Queue.of([0, 1, 2, 3])..rotate(-4), [0, 1, 2, 3]);
            expect(Queue.of([0, 1, 2, 3])..rotate(4), [0, 1, 2, 3]);
          });
        });
      });
    });
    group('take/skip', () {
      const list = ['a', 'b', 'c'];
      test('take', () {
        expect(list.take(0), isEmpty);
        expect(list.take(1), ['a']);
        expect(list.take(2), ['a', 'b']);
        expect(list.take(3), ['a', 'b', 'c']);
        expect(list.take(4), ['a', 'b', 'c']);
      });
      test('takeTo', () {
        expect(list.takeTo('a'), isEmpty);
        expect(list.takeTo('b'), ['a']);
        expect(list.takeTo('c'), ['a', 'b']);
        expect(list.takeTo('d'), ['a', 'b', 'c']);
      });
      test('takeLast', () {
        expect(list.takeLast(0), isEmpty);
        expect(list.takeLast(1), ['c']);
        expect(list.takeLast(2), ['b', 'c']);
        expect(list.takeLast(3), ['a', 'b', 'c']);
        expect(list.takeLast(4), ['a', 'b', 'c']);
      });
      test('takeLastTo', () {
        expect(list.takeLastTo('a'), ['b', 'c']);
        expect(list.takeLastTo('b'), ['c']);
        expect(list.takeLastTo('c'), isEmpty);
        expect(list.takeLastTo('d'), ['a', 'b', 'c']);
      });
      test('skip', () {
        expect(list.skip(0), ['a', 'b', 'c']);
        expect(list.skip(1), ['b', 'c']);
        expect(list.skip(2), ['c']);
        expect(list.skip(3), isEmpty);
        expect(list.skip(4), isEmpty);
      });
      test('skipTo', () {
        expect(list.skipTo('a'), ['b', 'c']);
        expect(list.skipTo('b'), ['c']);
        expect(list.skipTo('c'), isEmpty);
        expect(list.skipTo('d'), isEmpty);
      });
      test('skipLast', () {
        expect(list.skipLast(0), ['a', 'b', 'c']);
        expect(list.skipLast(1), ['a', 'b']);
        expect(list.skipLast(2), ['a']);
        expect(list.skipLast(3), isEmpty);
        expect(list.skipLast(4), isEmpty);
      });
      test('skipLastTo', () {
        expect(list.skipLastTo('a'), isEmpty);
        expect(list.skipLastTo('b'), ['a']);
        expect(list.skipLastTo('c'), ['a', 'b']);
        expect(list.skipLastTo('d'), isEmpty);
      });
    });
  });
  group('map', () {
    group('computed', () {
      test('basic', () {
        final map = <String, int>{}.withComputed(int.parse);
        expect(map.containsKey('42'), false);
        expect(map['42'], 42);
        expect(map.containsKey('42'), true);
      });
      test('typing', () {
        final map = <String, int>{}.withComputed(int.parse);
        expect(map['5'] + map['42'], 47);
      });
      test('modify', () {
        final map = {'1': -1}.withComputed(int.parse);
        expect(map['1'], -1);
        map['2'] = -2;
        expect(map['2'], -2);
      });
      test('throws', () {
        final map = <String, int>{}.withComputed(int.parse);
        expect(() => map['a'], throwsFormatException);
        expect(map.isEmpty, isTrue);
      });
    });
    group('default', () {
      test('basic', () {
        final map = {'a': 1}.withDefault(42);
        expect(map.containsKey('a'), isTrue);
        expect(map['a'], 1);
        expect(map.containsKey('z'), isFalse);
        expect(map['z'], 42);
      });
      test('typing', () {
        final map = <String, int>{}.withDefault(42);
        expect(map['what'] + map['ever'], 84);
      });
      test('modify', () {
        final map = {'a': 1}.withDefault(-1);
        expect(map['b'], -1);
        map['b'] = 42;
        expect(map['b'], 42);
      });
    });
  });
  group('multimap', () {
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
  });
  group('multiset', () {
    group('constructor', () {
      test('empty', () {
        final set = Multiset<String>();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.entrySet, unorderedEquals([]));
        expect(set.elementSet, unorderedEquals([]));
        expect(set.elementCounts, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('empty identity', () {
        final set = Multiset<String>.identity();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.entrySet, unorderedEquals([]));
        expect(set.elementSet, unorderedEquals([]));
        expect(set.elementCounts, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('of one unique', () {
        final set = Multiset.of(['a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['a']));
        expect(set.entrySet, unorderedEquals([isMapEntry('a', 1)]));
        expect(set.elementSet, unorderedEquals(['a']));
        expect(set.elementCounts, unorderedEquals([1]));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([1]));
      });
      test('of many unique', () {
        final set = Multiset.of(['a', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'c']));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry('a', 1),
            isMapEntry('b', 1),
            isMapEntry('c', 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
        expect(set.elementCounts, unorderedEquals([1, 1, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([1, 1, 1]));
      });
      test('of one repeated', () {
        final set = Multiset.of(['a', 'a', 'a']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'a', 'a']));
        expect(set.entrySet, unorderedEquals([isMapEntry('a', 3)]));
        expect(set.elementSet, unorderedEquals(['a']));
        expect(set.elementCounts, unorderedEquals([3]));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([3]));
      });
      test('of many repeated', () {
        final set = Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry('a', 3),
            isMapEntry('b', 2),
            isMapEntry('c', 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
        expect(set.elementCounts, unorderedEquals([3, 2, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('of set', () {
        final set = Multiset.of({'a', 'b', 'c'});
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'c']));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry('a', 1),
            isMapEntry('b', 1),
            isMapEntry('c', 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
        expect(set.elementCounts, unorderedEquals([1, 1, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([1, 1, 1]));
      });
      test('from many repeated', () {
        final set = Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry('a', 3),
            isMapEntry('b', 2),
            isMapEntry('c', 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
        expect(set.elementCounts, unorderedEquals([3, 2, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('copy', () {
        final set = Multiset.of(Multiset.of(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry('a', 3),
            isMapEntry('b', 2),
            isMapEntry('c', 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
        expect(set.elementCounts, unorderedEquals([3, 2, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate', () {
        final set = Multiset<String>.fromIterable([
          'a',
          'a',
          'a',
          'b',
          'b',
          'c',
        ]);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry('a', 3),
            isMapEntry('b', 2),
            isMapEntry('c', 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
        expect(set.elementCounts, unorderedEquals([3, 2, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate with key', () {
        final set = Multiset<int>.fromIterable([
          'a',
          'a',
          'a',
          'b',
          'b',
          'c',
        ], key: (e) => (e as String).codeUnitAt(0));
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals([97, 97, 97, 98, 98, 99]));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry(97, 3),
            isMapEntry(98, 2),
            isMapEntry(99, 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals([97, 98, 99]));
        expect(set.elementCounts, unorderedEquals([3, 2, 1]));
        expect(set.distinct, unorderedEquals([97, 98, 99]));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('generate with count', () {
        final set = Multiset.fromIterable(
          ['aaa', 'bb', 'c'],
          key: (e) => (e as String).substring(0, 1),
          count: (e) => (e as String).length,
        );
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry('a', 3),
            isMapEntry('b', 2),
            isMapEntry('c', 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
        expect(set.elementCounts, unorderedEquals([3, 2, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
      test('convert', () {
        final set = ['a', 'a', 'a', 'b', 'b', 'c'].toMultiset();
        expect(set, isNot(isEmpty));
        expect(set, hasLength(6));
        expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
        expect(
          set.entrySet,
          unorderedEquals([
            isMapEntry('a', 3),
            isMapEntry('b', 2),
            isMapEntry('c', 1),
          ]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b', 'c']));
        expect(set.elementCounts, unorderedEquals([3, 2, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        expect(set.counts, unorderedEquals([3, 2, 1]));
      });
    });
    group('adding', () {
      test('zero', () {
        final set =
            Multiset<String>()
              ..add('a', 0)
              ..add('b', 0);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.entrySet, unorderedEquals([]));
        expect(set.elementSet, unorderedEquals([]));
        expect(set.elementCounts, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
      test('single', () {
        final set =
            Multiset<String>()
              ..add('a')
              ..add('b')
              ..add('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 1), isMapEntry('b', 2)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([1, 2]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 2]));
      });
      test('multiple', () {
        final set =
            Multiset<String>()
              ..add('a', 2)
              ..add('b', 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([2, 3]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('all', () {
        final set = Multiset<String>()..addAll(['a', 'a', 'b', 'b', 'b']);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([3, 2]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([3, 2]));
      });
      test('error', () {
        final set = Multiset<String>();
        expect(() => set.add('a', -1), throwsArgumentError);
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.entrySet, unorderedEquals([]));
        expect(set.elementSet, unorderedEquals([]));
        expect(set.elementCounts, unorderedEquals([]));
        expect(set.distinct, unorderedEquals([]));
        expect(set.counts, unorderedEquals([]));
      });
    });
    group('removing', () {
      test('zero', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set
          ..remove('a', 0)
          ..remove('b', 0);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([2, 3]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('single', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set
          ..remove('a')
          ..remove('b');
        expect(set, isNot(isEmpty));
        expect(set, hasLength(3));
        expect(set, unorderedEquals(['a', 'b', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 1), isMapEntry('b', 2)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([1, 2]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 2]));
      });
      test('multiple', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set
          ..remove('a', 3)
          ..remove('b', 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(1));
        expect(set, unorderedEquals(['b']));
        expect(set.entrySet, unorderedEquals([isMapEntry('b', 1)]));
        expect(set.elementSet, unorderedEquals(['b']));
        expect(set.elementCounts, unorderedEquals([1]));
        expect(set.distinct, unorderedEquals(['b']));
        expect(set.counts, unorderedEquals([1]));
      });
      test('all', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set.removeAll(['a', 'b', 'b', 123, null]);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 1), isMapEntry('b', 1)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([1, 1]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([1, 1]));
      });
      test('clear', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set.clear();
        expect(set, isEmpty);
        expect(set, hasLength(0));
        expect(set, unorderedEquals([]));
        expect(set.entrySet, unorderedEquals([]));
        expect(set.elementSet, unorderedEquals([]));
        expect(set.elementCounts, unorderedEquals([]));
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
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([2, 3]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
      test('error', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        expect(() => set.remove('a', -1), throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([2, 3]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([2, 3]));
      });
    });
    group('access', () {
      test('single', () {
        final set = Multiset<String>();
        set['a'] = 2;
        expect(set['a'], 2);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.entrySet, unorderedEquals([isMapEntry('a', 2)]));
        expect(set.elementSet, unorderedEquals(['a']));
        expect(set.elementCounts, unorderedEquals([2]));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([2]));
      });
      test('multiple', () {
        final set = Multiset<String>();
        set['a'] = 2;
        set['b'] = 3;
        expect(set['a'], 2);
        expect(set['b'], 3);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([3, 2]));
        expect(set.distinct, unorderedEquals(['a', 'b']));
        expect(set.counts, unorderedEquals([3, 2]));
      });
      test('remove', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        set['b'] = 0;
        expect(set, isNot(isEmpty));
        expect(set, hasLength(2));
        expect(set, unorderedEquals(['a', 'a']));
        expect(set.entrySet, unorderedEquals([isMapEntry('a', 2)]));
        expect(set.elementSet, unorderedEquals(['a']));
        expect(set.elementCounts, unorderedEquals([2]));
        expect(set.distinct, unorderedEquals(['a']));
        expect(set.counts, unorderedEquals([2]));
      });
      test('error', () {
        final set = Multiset.of(['a', 'a', 'b', 'b', 'b']);
        expect(() => set['a'] = -1, throwsArgumentError);
        expect(set, isNot(isEmpty));
        expect(set, hasLength(5));
        expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
        expect(
          set.entrySet,
          unorderedEquals([isMapEntry('a', 2), isMapEntry('b', 3)]),
        );
        expect(set.elementSet, unorderedEquals(['a', 'b']));
        expect(set.elementCounts, unorderedEquals([2, 3]));
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
        expect(firstSet.containsAll([1, 2]), isFalse);
        expect(firstSet.containsAll(['a', null]), isFalse);
      });
      test('combine', () {
        expect(
          firstSet.combine(secondSet, (_, a, b) => a + b),
          unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
        );
        expect(
          firstSet.combine(secondSet, (_, a, b) => min(a, b)),
          unorderedEquals(['a', 'c']),
        );
        expect(
          firstSet.combine(secondSet, (_, a, b) => max(0, a - b)),
          unorderedEquals(['b', 'c']),
        );
        expect(
          firstSet.combine(secondSet, (_, a, b) => max(a - b, b - a)),
          unorderedEquals(['b', 'c', 'd', 'd']),
        );
      });
      test('combine (iterable)', () {
        expect(
          firstSet.combine(secondList, (_, a, b) => a + b),
          unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
        );
        expect(
          firstSet.combine(secondList, (_, a, b) => min(a, b)),
          unorderedEquals(['a', 'c']),
        );
        expect(
          firstSet.combine(secondList, (_, a, b) => max(0, a - b)),
          unorderedEquals(['b', 'c']),
        );
        expect(
          firstSet.combine(secondList, (_, a, b) => max(a - b, b - a)),
          unorderedEquals(['b', 'c', 'd', 'd']),
        );
      });
      test('intersection', () {
        expect(firstSet.intersection(secondSet), unorderedEquals(['a', 'c']));
        expect(
          firstSet.intersection(secondSet).distinct,
          unorderedEquals(['a', 'c']),
        );
        expect(secondSet.intersection(firstSet), unorderedEquals(['a', 'c']));
        expect(
          secondSet.intersection(firstSet).distinct,
          unorderedEquals(['a', 'c']),
        );
      });
      test('intersection (iterable)', () {
        expect(firstSet.intersection(secondList), unorderedEquals(['a', 'c']));
        expect(secondSet.intersection(firstList), unorderedEquals(['a', 'c']));
        expect(firstSet.intersection(['a', 1, null]), unorderedEquals(['a']));
      });
      test('union', () {
        expect(
          firstSet.union(secondSet),
          unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
        );
        expect(
          firstSet.union(secondSet).distinct,
          unorderedEquals(['a', 'b', 'c', 'd']),
        );
        expect(
          secondSet.union(firstSet),
          unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
        );
        expect(
          secondSet.union(firstSet).distinct,
          unorderedEquals(['a', 'b', 'c', 'd']),
        );
      });
      test('union (iterable)', () {
        expect(
          firstSet.union(secondList),
          unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
        );
        expect(
          secondSet.union(firstList),
          unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']),
        );
      });
      test('difference', () {
        expect(firstSet.difference(secondSet), unorderedEquals(['b', 'c']));
        expect(
          firstSet.difference(secondSet).distinct,
          unorderedEquals(['b', 'c']),
        );
        expect(secondSet.difference(firstSet), unorderedEquals(['d', 'd']));
        expect(secondSet.difference(firstSet).distinct, unorderedEquals(['d']));
      });
      test('difference (iterable)', () {
        expect(firstSet.difference(secondList), unorderedEquals(['b', 'c']));
        expect(secondSet.difference(firstList), unorderedEquals(['d', 'd']));
        expect(
          firstSet.difference(['a', 1, null]),
          unorderedEquals(['b', 'c', 'c']),
        );
      });
      test('asMap', () {
        expect(firstSet.asMap(), {'a': 1, 'b': 1, 'c': 2});
        expect(secondSet.asMap(), {'a': 1, 'c': 1, 'd': 2});
      });
      test('asMap (unmodifiable)', () {
        final map = firstSet.asMap();
        expect(() => map['a'] = 2, throwsUnsupportedError);
        expect(() => map.remove('a'), throwsUnsupportedError);
        expect(() => map.clear(), throwsUnsupportedError);
      });
    });
  });
  group('range', () {
    group('int', () {
      group('constructor', () {
        test('empty', () {
          verifyRange(IntegerRange.empty, included: [], excluded: [0]);
        });
        test('of', () {
          verifyRange(const IntegerRange.of(), included: [], excluded: [0]);
          verifyRange(
            const IntegerRange.of(start: -2),
            included: [-2, -1],
            excluded: [-3, 0],
          );
          verifyRange(
            const IntegerRange.of(end: 2),
            included: [0, 1],
            excluded: [-1, 3],
          );
          verifyRange(
            const IntegerRange.of(start: 1, end: 3),
            included: [1, 2],
            excluded: [0, 3],
          );
          verifyRange(
            const IntegerRange.of(start: 3, end: 1),
            included: [3, 2],
            excluded: [1, 4],
          );
          verifyRange(
            const IntegerRange.of(start: 1, end: 5, step: 2),
            included: [1, 3],
            excluded: [2, 4, 5],
          );
          verifyRange(
            const IntegerRange.of(start: 5, end: 1, step: -2),
            included: [5, 3],
            excluded: [4, 2, 1],
          );
        });
        test('length', () {
          verifyRange(
            const IntegerRange.length(0),
            included: [],
            excluded: [0],
          );
          verifyRange(
            const IntegerRange.length(1),
            included: [0],
            excluded: [-1, 1],
          );
          verifyRange(
            const IntegerRange.length(2),
            included: [0, 1],
            excluded: [-1, 2],
          );
          verifyRange(
            const IntegerRange.length(2, start: 10),
            included: [10, 11],
            excluded: [-1, 2],
          );
          verifyRange(
            const IntegerRange.length(2, step: 2),
            included: [0, 2],
            excluded: [-1, 1, 3],
          );
          verifyRange(
            const IntegerRange.length(2, step: -2),
            included: [0, -2],
            excluded: [-3, -1, 1],
          );
        });
        test('1 argument', () {
          verifyRange(IntegerRange(0), included: [], excluded: [-1, 0, 1]);
          verifyRange(IntegerRange(1), included: [0], excluded: [-1, 1]);
          verifyRange(IntegerRange(2), included: [0, 1], excluded: [-1, 2]);
          verifyRange(IntegerRange(3), included: [0, 1, 2], excluded: [-1, 3]);
        });
        test('2 arguments', () {
          verifyRange(IntegerRange(0, 0), included: [], excluded: [-1, 0, 1]);
          verifyRange(
            IntegerRange(0, 4),
            included: [0, 1, 2, 3],
            excluded: [-1, 4],
          );
          verifyRange(
            IntegerRange(4, 0),
            included: [4, 3, 2, 1],
            excluded: [5, 0],
          );
          verifyRange(
            IntegerRange(5, 9),
            included: [5, 6, 7, 8],
            excluded: [4, 9],
          );
          verifyRange(
            IntegerRange(9, 5),
            included: [9, 8, 7, 6],
            excluded: [10, 5],
          );
        });
        test('3 argument (positive step)', () {
          verifyRange(
            IntegerRange(0, 0, 1),
            included: [],
            excluded: [-1, 0, 1],
          );
          verifyRange(
            IntegerRange(2, 8, 2),
            included: [2, 4, 6],
            excluded: [0, 1, 3, 5, 7, 8],
          );
          verifyRange(
            IntegerRange(3, 8, 2),
            included: [3, 5, 7],
            excluded: [1, 2, 4, 6, 8, 9],
          );
          verifyRange(
            IntegerRange(4, 8, 2),
            included: [4, 6],
            excluded: [2, 3, 5, 7, 8],
          );
          verifyRange(
            IntegerRange(2, 7, 2),
            included: [2, 4, 6],
            excluded: [0, 1, 3, 5, 7, 8],
          );
          verifyRange(
            IntegerRange(2, 6, 2),
            included: [2, 4],
            excluded: [0, 1, 3, 5, 6, 7, 8],
          );
        });
        test('3 argument (negative step)', () {
          verifyRange(
            IntegerRange(0, 0, -1),
            included: [],
            excluded: [-1, 0, 1],
          );
          verifyRange(
            IntegerRange(8, 2, -2),
            included: [8, 6, 4],
            excluded: [2, 3, 5, 7, 9, 10],
          );
          verifyRange(
            IntegerRange(8, 3, -2),
            included: [8, 6, 4],
            excluded: [2, 3, 5, 7, 9, 10],
          );
          verifyRange(
            IntegerRange(8, 4, -2),
            included: [8, 6],
            excluded: [2, 3, 4, 5, 7, 9, 10],
          );
          verifyRange(
            IntegerRange(7, 2, -2),
            included: [7, 5, 3],
            excluded: [1, 2, 4, 6, 8, 9],
          );
          verifyRange(
            IntegerRange(6, 2, -2),
            included: [6, 4],
            excluded: [2, 3, 5, 7, 8, 9],
          );
        });
        test('positive step size', () {
          for (var end = 31; end <= 40; end++) {
            verifyRange(
              IntegerRange(10, end, 10),
              included: [10, 20, 30],
              excluded: [5, 15, 25, 35, 40],
            );
          }
        });
        test('negative step size', () {
          for (var end = 9; end >= 0; end--) {
            verifyRange(
              IntegerRange(30, end, -10),
              included: [30, 20, 10],
              excluded: [0, 5, 15, 25, 35],
            );
          }
        });
        test('length with positive step size', () {
          expect(const IntegerRange.of(end: 12, step: 2), hasLength(6));
          expect(const IntegerRange.of(end: 12, step: 3), hasLength(4));
          expect(const IntegerRange.of(end: 12, step: 4), hasLength(3));
          expect(const IntegerRange.of(end: 12, step: 6), hasLength(2));
        });
        test('length with negative step size', () {
          expect(const IntegerRange.of(start: 12, step: -2), hasLength(6));
          expect(const IntegerRange.of(start: 12, step: -3), hasLength(4));
          expect(const IntegerRange.of(start: 12, step: -4), hasLength(3));
          expect(const IntegerRange.of(start: 12, step: -6), hasLength(2));
        });
        test('shorthand', () {
          verifyRange(0.to(3), included: [0, 1, 2], excluded: [-1, 3]);
          verifyRange(3.to(0), included: [3, 2, 1], excluded: [4, 0]);
          verifyRange(
            2.to(8, step: 2),
            included: [2, 4, 6],
            excluded: [1, 3, 5, 7, 8],
          );
          verifyRange(
            8.to(2, step: -2),
            included: [8, 6, 4],
            excluded: [2, 3, 5, 7, 9],
          );
        });
        test('stress', () {
          final random = Random(1618033);
          for (var i = 0; i < 250; i++) {
            final start = random.nextInt(0xffff) - 0xffff ~/ 2;
            final end = random.nextInt(0xffff) - 0xffff ~/ 2;
            final step =
                start < end
                    ? 1 + random.nextInt(0xfff)
                    : -1 - random.nextInt(0xfff);
            final expected =
                start < end
                    ? <int>[for (var j = start; j < end; j += step) j]
                    : <int>[for (var j = start; j > end; j += step) j];
            verifyRange(
              IntegerRange(start, end, step),
              included: expected,
              excluded: [],
            );
          }
        });
        test('invalid', () {
          expect(() => IntegerRange(0, 0, 0), throwsArgumentError);
          expect(() => IntegerRange(null, 1), throwsArgumentError);
          expect(() => IntegerRange(null, null, 1), throwsArgumentError);
        });
        group('indices', () {
          test('empty', () {
            verifyRange(<int>[].indices(), included: [], excluded: [0, 1, 2]);
            verifyRange(
              <int>[].indices(step: -1),
              included: [],
              excluded: [0, 1, 2],
            );
          });
          test('default', () {
            verifyRange(
              [1, 2, 3].indices(),
              included: [0, 1, 2],
              excluded: [-1, 3],
            );
            verifyRange(
              [1, 2, 3].indices(step: -1),
              included: [2, 1, 0],
              excluded: [-1, 3],
            );
          });
          test('step', () {
            verifyRange(
              [1, 2, 3].indices(step: 2),
              included: [0, 2],
              excluded: [-1, 1, 3],
            );
            verifyRange(
              [1, 2, 3, 4].indices(step: 2),
              included: [0, 2],
              excluded: [-1, 1, 3],
            );
            verifyRange(
              [1, 2, 3].indices(step: -2),
              included: [2, 0],
              excluded: [-1, 1, 3],
            );
            verifyRange(
              [1, 2, 3, 4].indices(step: -2),
              included: [3, 1],
              excluded: [0, 2, 4, 6],
            );
          });
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verifyRange(
            IntegerRange(3).sublist(0),
            included: [0, 1, 2],
            excluded: [-1, 3],
          );
          verifyRange(
            IntegerRange(3).sublist(1),
            included: [1, 2],
            excluded: [-1, 0, 3],
          );
          verifyRange(
            IntegerRange(3).sublist(2),
            included: [2],
            excluded: [-1, 0, 1, 3],
          );
          verifyRange(
            IntegerRange(3).sublist(3),
            included: [],
            excluded: [-1, 0, 1, 2, 3],
          );
          expect(() => IntegerRange(3).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verifyRange(
            IntegerRange(3).sublist(0, 3),
            included: [0, 1, 2],
            excluded: [-1, 3],
          );
          verifyRange(
            IntegerRange(3).sublist(0, 2),
            included: [0, 1],
            excluded: [-1, 2, 3],
          );
          verifyRange(
            IntegerRange(3).sublist(0, 1),
            included: [0],
            excluded: [-1, 1, 2, 3],
          );
          verifyRange(
            IntegerRange(3).sublist(0, 0),
            included: [],
            excluded: [-1, 0, 1, 2, 3],
          );
          expect(() => IntegerRange(3).sublist(0, 4), throwsRangeError);
        });
        test('getRange', () {
          verifyRange(
            IntegerRange(3).getRange(0, 3),
            included: [0, 1, 2],
            excluded: [-1, 3],
          );
          verifyRange(
            IntegerRange(3).getRange(0, 2),
            included: [0, 1],
            excluded: [-1, 2, 3],
          );
          verifyRange(
            IntegerRange(3).getRange(0, 1),
            included: [0],
            excluded: [-1, 1, 2, 3],
          );
          verifyRange(
            IntegerRange(3).getRange(0, 0),
            included: [],
            excluded: [-1, 0, 1, 2, 3],
          );
          expect(() => IntegerRange(3).getRange(0, 4), throwsRangeError);
        });
      });
      test('unmodifiable', () {
        final list = IntegerRange(1, 5);
        expect(() => list[0] = 5, throwsUnsupportedError);
        expect(() => list.first = 5, throwsUnsupportedError);
        expect(() => list.last = 5, throwsUnsupportedError);
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
          () => list.retainWhere((value) => false),
          throwsUnsupportedError,
        );
        expect(() => list.setAll(2, [5, 6]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5, 6]), throwsUnsupportedError);
        expect(() => list.shuffle(), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
    group('double', () {
      group('constructor', () {
        test('empty', () {
          verifyRange(DoubleRange.empty, included: [], excluded: [0.0]);
        });
        test('of', () {
          verifyRange(const DoubleRange.of(), included: [], excluded: [0.0]);
          verifyRange(
            const DoubleRange.of(start: -2),
            included: [-2.0, -1.0],
            excluded: [-3.0, 0.0],
          );
          verifyRange(
            const DoubleRange.of(end: 2),
            included: [0.0, 1.0],
            excluded: [-1, 3],
          );
          verifyRange(
            const DoubleRange.of(start: 1, end: 3),
            included: [1.0, 2.0],
            excluded: [0.0, 3.0],
          );
          verifyRange(
            const DoubleRange.of(start: 3, end: 1),
            included: [3.0, 2.0],
            excluded: [1.0, 4.0],
          );
          verifyRange(
            const DoubleRange.of(start: 1, end: 5, step: 2),
            included: [1.0, 3.0],
            excluded: [2.0, 4.0, 5.0],
          );
          verifyRange(
            const DoubleRange.of(start: 5, end: 1, step: -2),
            included: [5.0, 3.0],
            excluded: [4.0, 2.0, 1.0],
          );
        });
        test('length', () {
          verifyRange(
            const DoubleRange.length(0),
            included: [],
            excluded: [0.0],
          );
          verifyRange(
            const DoubleRange.length(1),
            included: [0.0],
            excluded: [-1.0, 1.0],
          );
          verifyRange(
            const DoubleRange.length(2),
            included: [0.0, 1.0],
            excluded: [-1.0, 2.0],
          );
          verifyRange(
            const DoubleRange.length(2, start: 10),
            included: [10.0, 11.0],
            excluded: [-1.0, 2.0],
          );
          verifyRange(
            const DoubleRange.length(2, step: 2),
            included: [0.0, 2.0],
            excluded: [-1.0, 1.0, 3.0],
          );
          verifyRange(
            const DoubleRange.length(2, step: -2),
            included: [0.0, -2.0],
            excluded: [-3.0, -1.0, 1.0],
          );
        });

        test('1 argument', () {
          verifyRange(DoubleRange(0), included: [], excluded: [-1.0, 0.0, 1.0]);
          verifyRange(DoubleRange(1), included: [0.0], excluded: [-1.0, 1.0]);
          verifyRange(
            DoubleRange(2),
            included: [0.0, 1.0],
            excluded: [-1.0, 2.0],
          );
          verifyRange(
            DoubleRange(3),
            included: [0.0, 1.0, 2.0],
            excluded: [-1.0, 3.0],
          );
        });
        test('2 argument', () {
          verifyRange(
            DoubleRange(0, 0),
            included: [],
            excluded: [-1.0, 0.0, 1.0],
          );
          verifyRange(
            DoubleRange(0, 4),
            included: [0.0, 1.0, 2.0, 3.0],
            excluded: [-1.0, 4.0],
          );
          verifyRange(
            DoubleRange(4, 0),
            included: [4.0, 3.0, 2.0, 1.0],
            excluded: [5.0, 0.0],
          );
          verifyRange(
            DoubleRange(5, 9),
            included: [5.0, 6.0, 7.0, 8.0],
            excluded: [4.0, 9.0],
          );
          verifyRange(
            DoubleRange(9, 5),
            included: [9.0, 8.0, 7.0, 6.0],
            excluded: [10.0, 5.0],
          );
        });
        test('3 argument (positive step)', () {
          verifyRange(
            DoubleRange(0, 0, 1),
            included: [],
            excluded: [-1.0, 0.0, 1.0],
          );
          verifyRange(
            DoubleRange(2, 8, 1.5),
            included: [2.0, 3.5, 5.0, 6.5],
            excluded: [0.5, 3.0, 8.0],
          );
          verifyRange(
            DoubleRange(3, 8, 1.5),
            included: [3.0, 4.5, 6.0, 7.5],
            excluded: [1.5, 5.0, 9.0],
          );
          verifyRange(
            DoubleRange(4, 8, 1.5),
            included: [4.0, 5.5, 7.0],
            excluded: [3.5, 5, 6, 8.5],
          );
          verifyRange(
            DoubleRange(2, 7, 1.5),
            included: [2.0, 3.5, 5.0, 6.5],
            excluded: [0.5, 4.0, 8.0],
          );
          verifyRange(
            DoubleRange(2, 6, 1.5),
            included: [2.0, 3.5, 5.0],
            excluded: [0.5, 3.0, 4.0, 6.0],
          );
        });
        test('3 argument (negative step)', () {
          verifyRange(
            DoubleRange(0, 0, -1),
            included: [],
            excluded: [-1.0, 0.0, 1.0],
          );
          verifyRange(
            DoubleRange(8, 2, -1.5),
            included: [8.0, 6.5, 5.0, 3.5],
            excluded: [9.5, 6.0, 2.0],
          );
          verifyRange(
            DoubleRange(8, 3, -1.5),
            included: [8.0, 6.5, 5.0, 3.5],
            excluded: [9.5, 6.0, 2.0],
          );
          verifyRange(
            DoubleRange(8, 4, -1.5),
            included: [8.0, 6.5, 5.0],
            excluded: [9.5, 5.5, 3.5],
          );
          verifyRange(
            DoubleRange(7, 2, -1.5),
            included: [7.0, 5.5, 4.0, 2.5],
            excluded: [8.5, 3, 2.0],
          );
          verifyRange(
            DoubleRange(6, 2, -1.5),
            included: [6.0, 4.5, 3.0],
            excluded: [7.5, 4.0, 1.5],
          );
        });
        test('exceeding positive step size', () {
          for (var end = 31; end <= 40; end++) {
            verifyRange(
              DoubleRange(10, end.toDouble(), 10),
              included: [10.0, 20.0, 30.0],
              excluded: [5.0, 15.0, 25.0, 35.0, 40.0],
            );
          }
        });
        test('exceeding negative step size', () {
          for (var end = 9; end >= 0; end--) {
            verifyRange(
              DoubleRange(30, end.toDouble(), -10),
              included: [30.0, 20.0, 10.0],
              excluded: [0.0, 5.0, 15.0, 25.0, 35.0],
            );
          }
        });
        test('decimal positive step size', () {
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.1),
            hasLength(10),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.2),
            hasLength(5),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.3),
            hasLength(4),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.4),
            hasLength(3),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.5),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.6),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.7),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.8),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 0.9),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1.0),
            hasLength(1),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1.1),
            hasLength(1),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1.2),
            hasLength(1),
          );
        });
        test('decimal negative step size', () {
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.1),
            hasLength(10),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.2),
            hasLength(5),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.3),
            hasLength(4),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.4),
            hasLength(3),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.5),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.6),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.7),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.8),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -0.9),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1.0),
            hasLength(1),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1.1),
            hasLength(1),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1.2),
            hasLength(1),
          );
        });
        test('fractional positive step size', () {
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 1),
            hasLength(1),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 2),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 3),
            hasLength(3),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 4),
            hasLength(4),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 5),
            hasLength(5),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 6),
            hasLength(6),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 7),
            hasLength(7),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 8),
            hasLength(8),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 9),
            hasLength(9),
          );
          expect(
            const DoubleRange.of(start: 1, end: 2, step: 1 / 10),
            hasLength(10),
          );
        });
        test('fractional negative step size', () {
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 1),
            hasLength(1),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 2),
            hasLength(2),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 3),
            hasLength(3),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 4),
            hasLength(4),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 5),
            hasLength(5),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 6),
            hasLength(6),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 7),
            hasLength(7),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 8),
            hasLength(8),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 9),
            hasLength(9),
          );
          expect(
            const DoubleRange.of(start: 2, end: 1, step: -1 / 10),
            hasLength(10),
          );
        });
        test('shorthand', () {
          verifyRange(
            0.0.to(3.0),
            included: [0.0, 1.0, 2.0],
            excluded: [-1.0, 3.0],
          );
          verifyRange(
            3.0.to(0.0),
            included: [3.0, 2.0, 1.0],
            excluded: [4.0, 0.0],
          );
          verifyRange(
            4.0.to(8.0, step: 1.5),
            included: [4.0, 5.5, 7.0],
            excluded: [5.0, 6.0, 6.5, 8.0],
          );
          verifyRange(
            8.0.to(4.0, step: -1.5),
            included: [8.0, 6.5, 5.0],
            excluded: [3.5, 4.0, 6.0, 7.5],
          );
        });
        test('invalid', () {
          expect(() => DoubleRange(0, 0, 0), throwsArgumentError);
          expect(() => DoubleRange(null, 1), throwsArgumentError);
          expect(() => DoubleRange(null, null, 1), throwsArgumentError);
        });
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verifyRange(
            DoubleRange(3.0).sublist(0),
            included: [0.0, 1.0, 2.0],
            excluded: [-1.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).sublist(1),
            included: [1.0, 2.0],
            excluded: [-1.0, 0.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).sublist(2),
            included: [2.0],
            excluded: [-1.0, 0.0, 1.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).sublist(3),
            included: [],
            excluded: [-1.0, 0.0, 1.0, 2.0, 3.0],
          );
          expect(() => DoubleRange(3.0).sublist(4), throwsRangeError);
        });
        test('sublist (2 arguments)', () {
          verifyRange(
            DoubleRange(3.0).sublist(0, 3),
            included: [0.0, 1.0, 2.0],
            excluded: [-1.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).sublist(0, 2),
            included: [0.0, 1.0],
            excluded: [-1.0, 2.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).sublist(0, 1),
            included: [0.0],
            excluded: [-1.0, 1.0, 2.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).sublist(0, 0),
            included: [],
            excluded: [-1.0, 0.0, 1.0, 2.0, 3.0],
          );
          expect(() => DoubleRange(3.0).sublist(0, 4), throwsRangeError);
        });
        test('getRange', () {
          verifyRange(
            DoubleRange(3.0).getRange(0, 3),
            included: [0.0, 1.0, 2.0],
            excluded: [-1.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).getRange(0, 2),
            included: [0.0, 1.0],
            excluded: [-1.0, 2.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).getRange(0, 1),
            included: [0.0],
            excluded: [-1.0, 1.0, 2.0, 3.0],
          );
          verifyRange(
            DoubleRange(3.0).getRange(0, 0),
            included: [],
            excluded: [-1.0, 0.0, 1.0, 2.0, 3.0],
          );
          expect(() => DoubleRange(3.0).getRange(0, 4), throwsRangeError);
        });
      });
      test('unmodifiable', () {
        final list = DoubleRange(1.0, 5.0);
        expect(() => list[0] = 5.0, throwsUnsupportedError);
        expect(() => list.first = 5.0, throwsUnsupportedError);
        expect(() => list.last = 5.0, throwsUnsupportedError);
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
          () => list.replaceRange(2, 4, [5.0, 6.0]),
          throwsUnsupportedError,
        );
        expect(
          () => list.retainWhere((value) => false),
          throwsUnsupportedError,
        );
        expect(() => list.setAll(2, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5.0, 6.0]), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
    group('BigInt', () {
      List<BigInt> toBigIntList(List<int> values) =>
          values.map(BigInt.from).toList();
      group('constructor', () {
        test('empty', () {
          verifyRange(
            BigIntRange.empty,
            included: <BigInt>[],
            excluded: toBigIntList([0]),
          );
        });
        test('of', () {
          verifyRange(
            BigIntRange.of(),
            included: <BigInt>[],
            excluded: toBigIntList([0]),
          );
          verifyRange(
            BigIntRange.of(start: BigInt.from(-2)),
            included: toBigIntList([-2, -1]),
            excluded: toBigIntList([-3, 0]),
          );
          verifyRange(
            BigIntRange.of(end: BigInt.from(2)),
            included: toBigIntList([0, 1]),
            excluded: toBigIntList([-1, 3]),
          );
          verifyRange(
            BigIntRange.of(start: BigInt.from(1), end: BigInt.from(3)),
            included: toBigIntList([1, 2]),
            excluded: toBigIntList([0, 3]),
          );
          verifyRange(
            BigIntRange.of(start: BigInt.from(3), end: BigInt.from(1)),
            included: toBigIntList([3, 2]),
            excluded: toBigIntList([1, 4]),
          );
          verifyRange(
            BigIntRange.of(
              start: BigInt.from(1),
              end: BigInt.from(5),
              step: BigInt.from(2),
            ),
            included: toBigIntList([1, 3]),
            excluded: toBigIntList([2, 4, 5]),
          );
          verifyRange(
            BigIntRange.of(
              start: BigInt.from(5),
              end: BigInt.from(1),
              step: BigInt.from(-2),
            ),
            included: toBigIntList([5, 3]),
            excluded: toBigIntList([4, 2, 1]),
          );
        });
        test('length', () {
          verifyRange(
            BigIntRange.length(0),
            included: toBigIntList([]),
            excluded: toBigIntList([0]),
          );
          verifyRange(
            BigIntRange.length(1),
            included: toBigIntList([0]),
            excluded: toBigIntList([-1, 1]),
          );
          verifyRange(
            BigIntRange.length(2),
            included: toBigIntList([0, 1]),
            excluded: toBigIntList([-1, 2]),
          );
          verifyRange(
            BigIntRange.length(2, start: BigInt.from(10)),
            included: toBigIntList([10, 11]),
            excluded: toBigIntList([-1, 2]),
          );
          verifyRange(
            BigIntRange.length(2, step: BigInt.from(2)),
            included: toBigIntList([0, 2]),
            excluded: toBigIntList([-1, 1, 3]),
          );
          verifyRange(
            BigIntRange.length(2, step: BigInt.from(-2)),
            included: toBigIntList([0, -2]),
            excluded: toBigIntList([-3, -1, 1]),
          );
        });
        test('1 argument', () {
          verifyRange(
            BigIntRange(BigInt.zero),
            included: <BigInt>[],
            excluded: toBigIntList([-1, 0, 1]),
          );
          verifyRange(
            BigIntRange(BigInt.one),
            included: toBigIntList([0]),
            excluded: toBigIntList([-1, 1]),
          );
          verifyRange(
            BigIntRange(BigInt.from(2)),
            included: toBigIntList([0, 1]),
            excluded: toBigIntList([-1, 2]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)),
            included: toBigIntList([0, 1, 2]),
            excluded: toBigIntList([-1, 3]),
          );
        });
        test('2 argument', () {
          verifyRange(
            BigIntRange(BigInt.zero, BigInt.zero),
            included: <BigInt>[],
            excluded: toBigIntList([-1, 0, 1]),
          );
          verifyRange(
            BigIntRange(BigInt.zero, BigInt.from(4)),
            included: toBigIntList([0, 1, 2, 3]),
            excluded: toBigIntList([-1, 4]),
          );
          verifyRange(
            BigIntRange(BigInt.from(4), BigInt.zero),
            included: toBigIntList([4, 3, 2, 1]),
            excluded: toBigIntList([5, 0]),
          );
          verifyRange(
            BigIntRange(BigInt.from(5), BigInt.from(9)),
            included: toBigIntList([5, 6, 7, 8]),
            excluded: toBigIntList([4, 9]),
          );
          verifyRange(
            BigIntRange(BigInt.from(9), BigInt.from(5)),
            included: toBigIntList([9, 8, 7, 6]),
            excluded: toBigIntList([10, 5]),
          );
        });
        test('3 argument (positive step)', () {
          verifyRange(
            BigIntRange(BigInt.zero, BigInt.zero, BigInt.one),
            included: <BigInt>[],
            excluded: toBigIntList([-1, 0, 1]),
          );
          verifyRange(
            BigIntRange(BigInt.from(2), BigInt.from(8), BigInt.two),
            included: toBigIntList([2, 4, 6]),
            excluded: toBigIntList([0, 1, 3, 5, 7, 8]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3), BigInt.from(8), BigInt.two),
            included: toBigIntList([3, 5, 7]),
            excluded: toBigIntList([1, 2, 4, 6, 8, 9]),
          );
          verifyRange(
            BigIntRange(BigInt.from(4), BigInt.from(8), BigInt.two),
            included: toBigIntList([4, 6]),
            excluded: toBigIntList([2, 3, 5, 7, 8]),
          );
          verifyRange(
            BigIntRange(BigInt.from(2), BigInt.from(7), BigInt.two),
            included: toBigIntList([2, 4, 6]),
            excluded: toBigIntList([0, 1, 3, 5, 7, 8]),
          );
          verifyRange(
            BigIntRange(BigInt.from(2), BigInt.from(6), BigInt.two),
            included: toBigIntList([2, 4]),
            excluded: toBigIntList([0, 1, 3, 5, 6, 7, 8]),
          );
        });
        test('3 argument (negative step)', () {
          verifyRange(
            BigIntRange(BigInt.zero, BigInt.zero, BigIntExtension.negativeOne),
            included: <BigInt>[],
            excluded: toBigIntList([-1, 0, 1]),
          );
          verifyRange(
            BigIntRange(
              BigInt.from(8),
              BigInt.from(2),
              BigIntExtension.negativeTwo,
            ),
            included: toBigIntList([8, 6, 4]),
            excluded: toBigIntList([2, 3, 5, 7, 9, 10]),
          );
          verifyRange(
            BigIntRange(
              BigInt.from(8),
              BigInt.from(3),
              BigIntExtension.negativeTwo,
            ),
            included: toBigIntList([8, 6, 4]),
            excluded: toBigIntList([2, 3, 5, 7, 9, 10]),
          );
          verifyRange(
            BigIntRange(
              BigInt.from(8),
              BigInt.from(4),
              BigIntExtension.negativeTwo,
            ),
            included: toBigIntList([8, 6]),
            excluded: toBigIntList([2, 3, 4, 5, 7, 9, 10]),
          );
          verifyRange(
            BigIntRange(
              BigInt.from(7),
              BigInt.from(2),
              BigIntExtension.negativeTwo,
            ),
            included: toBigIntList([7, 5, 3]),
            excluded: toBigIntList([1, 2, 4, 6, 8, 9]),
          );
          verifyRange(
            BigIntRange(
              BigInt.from(6),
              BigInt.from(2),
              BigIntExtension.negativeTwo,
            ),
            included: toBigIntList([6, 4]),
            excluded: toBigIntList([2, 3, 5, 7, 8, 9]),
          );
        });
        test('positive step size', () {
          for (var end = 31; end <= 40; end++) {
            verifyRange(
              BigIntRange(BigInt.from(10), BigInt.from(end), BigInt.from(10)),
              included: toBigIntList([10, 20, 30]),
              excluded: toBigIntList([5, 15, 25, 35, 40]),
            );
          }
        });
        test('negative step size', () {
          for (var end = 9; end >= 0; end--) {
            verifyRange(
              BigIntRange(BigInt.from(30), BigInt.from(end), BigInt.from(-10)),
              included: toBigIntList([30, 20, 10]),
              excluded: toBigIntList([0, 5, 15, 25, 35]),
            );
          }
        });
        test('shorthand', () {
          verifyRange(
            BigInt.zero.to(BigInt.from(3)),
            included: toBigIntList([0, 1, 2]),
            excluded: toBigIntList([-1, 3]),
          );
          verifyRange(
            BigInt.from(3).to(BigInt.zero),
            included: toBigIntList([3, 2, 1]),
            excluded: toBigIntList([4, 0]),
          );
          verifyRange(
            BigInt.two.to(BigInt.from(8), step: BigInt.two),
            included: toBigIntList([2, 4, 6]),
            excluded: toBigIntList([0, 1, 3, 5, 7, 8]),
          );
          verifyRange(
            BigInt.from(8).to(BigInt.two, step: -BigInt.two),
            included: toBigIntList([8, 6, 4]),
            excluded: toBigIntList([2, 3, 5, 7, 9]),
          );
        });
        test('stress', () {
          final random = Random(6180340);
          for (var i = 0; i < 100; i++) {
            final start = BigInt.from(random.nextInt(0xffff) - 0xffff ~/ 2);
            final end = BigInt.from(random.nextInt(0xffff) - 0xffff ~/ 2);
            final step = BigInt.from(
              start < end
                  ? 1 + random.nextInt(0xfff)
                  : -1 - random.nextInt(0xfff),
            );
            final expected =
                start < end
                    ? <BigInt>[for (var j = start; j < end; j += step) j]
                    : <BigInt>[for (var j = start; j > end; j += step) j];
            verifyRange(
              BigIntRange(start, end, step),
              included: expected,
              excluded: <BigInt>[],
            );
          }
        });
        test('invalid', () {
          expect(
            () => BigIntRange(BigInt.zero, BigInt.zero, BigInt.zero),
            throwsArgumentError,
          );
          expect(() => BigIntRange(null, BigInt.one), throwsArgumentError);
          expect(
            () => BigIntRange(null, null, BigInt.one),
            throwsArgumentError,
          );
        });
        test('invalid length', () {
          final enormous = BigInt.two.pow(100);
          expect(() => BigIntRange(BigInt.zero, enormous), throwsArgumentError);
          expect(() => BigIntRange(enormous, BigInt.zero), throwsArgumentError);
          verifyRange(
            BigIntRange(enormous, enormous + BigInt.one),
            included: [enormous],
            excluded: [enormous - BigInt.one, enormous + BigInt.two],
          );
        }, testOn: '!js');
      });
      group('sublist', () {
        test('sublist (1 argument)', () {
          verifyRange(
            BigIntRange(BigInt.from(3)).sublist(0),
            included: toBigIntList([0, 1, 2]),
            excluded: toBigIntList([-1, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).sublist(1),
            included: toBigIntList([1, 2]),
            excluded: toBigIntList([-1, 0, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).sublist(2),
            included: toBigIntList([2]),
            excluded: toBigIntList([-1, 0, 1, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).sublist(3),
            included: <BigInt>[],
            excluded: toBigIntList([-1, 0, 1, 2, 3]),
          );
          expect(
            () => BigIntRange(BigInt.from(3)).sublist(4),
            throwsRangeError,
          );
        });
        test('sublist (2 arguments)', () {
          verifyRange(
            BigIntRange(BigInt.from(3)).sublist(0, 3),
            included: toBigIntList([0, 1, 2]),
            excluded: toBigIntList([-1, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).sublist(0, 2),
            included: toBigIntList([0, 1]),
            excluded: toBigIntList([-1, 2, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).sublist(0, 1),
            included: toBigIntList([0]),
            excluded: toBigIntList([-1, 1, 2, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).sublist(0, 0),
            included: <BigInt>[],
            excluded: toBigIntList([-1, 0, 1, 2, 3]),
          );
          expect(
            () => BigIntRange(BigInt.from(3)).sublist(0, 4),
            throwsRangeError,
          );
        });
        test('getRange', () {
          verifyRange(
            BigIntRange(BigInt.from(3)).getRange(0, 3),
            included: toBigIntList([0, 1, 2]),
            excluded: toBigIntList([-1, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).getRange(0, 2),
            included: toBigIntList([0, 1]),
            excluded: toBigIntList([-1, 2, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).getRange(0, 1),
            included: toBigIntList([0]),
            excluded: toBigIntList([-1, 1, 2, 3]),
          );
          verifyRange(
            BigIntRange(BigInt.from(3)).getRange(0, 0),
            included: toBigIntList([]),
            excluded: toBigIntList([-1, 0, 1, 2, 3]),
          );
          expect(
            () => BigIntRange(BigInt.from(3)).getRange(0, 4),
            throwsRangeError,
          );
        });
      });
      test('unmodifiable', () {
        final list = BigIntRange(BigInt.one, BigInt.from(5));
        expect(() => list[0] = BigInt.from(5), throwsUnsupportedError);
        expect(() => list.first = BigInt.from(5), throwsUnsupportedError);
        expect(() => list.last = BigInt.from(5), throwsUnsupportedError);
        expect(() => list.add(BigInt.from(5)), throwsUnsupportedError);
        expect(() => list.addAll(list), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(
          () => list.fillRange(2, 4, BigInt.from(5)),
          throwsUnsupportedError,
        );
        expect(() => list.insert(2, BigInt.from(5)), throwsUnsupportedError);
        expect(() => list.insertAll(2, list), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(BigInt.one), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(() => list.replaceRange(2, 4, list), throwsUnsupportedError);
        expect(
          () => list.retainWhere((value) => false),
          throwsUnsupportedError,
        );
        expect(() => list.setAll(2, list), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, list), throwsUnsupportedError);
        expect(() => list.shuffle(), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });
  });
  group('sortedlist', () {
    group('default constructor', () {
      allSortedListTests(<E>(
        Iterable<E> elements, {
        Comparator<E>? comparator,
        bool growable = true,
      }) {
        final list = SortedList<E>(comparator: comparator)..addAll(elements);
        return growable == false
            ? list.toSortedList(comparator: comparator, growable: growable)
            : list;
      });
    });
    group('iterable constructor', () {
      allSortedListTests(
        <E>(
          Iterable<E> elements, {
          Comparator<E>? comparator,
          bool growable = true,
        }) => SortedList<E>.of(
          elements,
          comparator: comparator,
          growable: growable,
        ),
      );
    });
    group('converting constructor', () {
      allSortedListTests(
        <E>(
          Iterable<E> elements, {
          Comparator<E>? comparator,
          bool growable = true,
        }) => elements.toSortedList(comparator: comparator, growable: growable),
      );
    });
  });
  group('rtree', () {
    group('bounds', () {
      final point1 = Bounds.fromPoint([1, 2, 3]);
      final point2 = Bounds.fromLists([3, 2, 1], [3, 2, 1]);
      final bound1 = Bounds.fromLists([-1, -1, -1], [1, 1, 1]);
      final bound2 = Bounds.fromLists([-2, 1, 2], [2, 3, 5]);
      final bound3 = Bounds.fromLists([-1, 2, 1], [3, 4, 4]);
      final bound4 = Bounds.fromLists([-1, 2, 2], [2, 3, 4]);
      test('length', () {
        expect(point1.length, 3);
        expect(point2.length, 3);
        expect(bound1.length, 3);
        expect(bound2.length, 3);
      });
      test('isPoint', () {
        expect(point1.isPoint, isTrue);
        expect(point2.isPoint, isTrue);
        expect(bound1.isPoint, isFalse);
        expect(bound2.isPoint, isFalse);
      });
      test('edges', () {
        expect(point1.edges, [0, 0, 0]);
        expect(point2.edges, [0, 0, 0]);
        expect(bound1.edges, [2, 2, 2]);
        expect(bound2.edges, [4, 2, 3]);
      });
      test('area', () {
        expect(point1.area, 0);
        expect(point2.area, 0);
        expect(bound1.area, 8);
        expect(bound2.area, 24);
      });
      test('center', () {
        expect(point1.center, [1, 2, 3]);
        expect(point2.center, [3, 2, 1]);
        expect(bound1.center, [0, 0, 0]);
        expect(bound2.center, [0, 2, 3.5]);
      });
      test('contains', () {
        expect(point1.contains(point1), isTrue);
        expect(point1.contains(point2), isFalse);
        expect(point1.contains(bound1), isFalse);
        expect(point1.contains(bound2), isFalse);

        expect(point2.contains(point1), isFalse);
        expect(point2.contains(point2), isTrue);
        expect(point2.contains(bound1), isFalse);
        expect(point2.contains(bound2), isFalse);

        expect(bound1.contains(point1), isFalse);
        expect(bound1.contains(point2), isFalse);
        expect(bound1.contains(bound1), isTrue);
        expect(bound1.contains(bound2), isFalse);

        expect(bound2.contains(point1), isTrue);
        expect(bound2.contains(point2), isFalse);
        expect(bound2.contains(bound1), isFalse);
        expect(bound2.contains(bound2), isTrue);
      });
      test('union', () {
        final pointUnion = point1.union(point2);
        expect(pointUnion.min, [1, 2, 1]);
        expect(pointUnion.max, [3, 2, 3]);
        final boundUnion = bound1.union(bound2);
        expect(boundUnion.min, [-2, -1, -1]);
        expect(boundUnion.max, [2, 3, 5]);
        final pointBoundUnion = point1.union(bound1);
        expect(pointBoundUnion.min, [-1, -1, -1]);
        expect(pointBoundUnion.max, [1, 2, 3]);
      });
      test('intersects', () {
        expect(point1.intersects(point1), isTrue);
        expect(point1.intersects(point2), isFalse);
        expect(point1.intersects(bound1), isFalse);
        expect(point1.intersects(bound2), isTrue);

        expect(point2.intersects(point1), isFalse);
        expect(point2.intersects(point2), isTrue);
        expect(point2.intersects(bound1), isFalse);
        expect(point2.intersects(bound2), isFalse);

        expect(bound1.intersects(point1), isFalse);
        expect(bound1.intersects(point2), isFalse);
        expect(bound1.intersects(bound1), isTrue);
        expect(bound1.intersects(bound2), isFalse);

        expect(bound2.intersects(point1), isTrue);
        expect(bound2.intersects(point2), isFalse);
        expect(bound2.intersects(bound1), isFalse);
        expect(bound2.intersects(bound2), isTrue);

        expect(bound2.intersects(bound3), isTrue);
        expect(bound3.intersects(bound2), isTrue);
      });
      test('intersection', () {
        expect(point1.intersection(point1), point1);
        expect(point1.intersection(point2), isNull);
        expect(point1.intersection(bound1), isNull);
        expect(point1.intersection(bound2), point1);

        expect(point2.intersection(point1), isNull);
        expect(point2.intersection(point2), point2);
        expect(point2.intersection(bound1), isNull);
        expect(point2.intersection(bound2), isNull);

        expect(bound1.intersection(point1), isNull);
        expect(bound1.intersection(point2), isNull);
        expect(bound1.intersection(bound1), bound1);
        expect(bound1.intersection(bound2), isNull);

        expect(bound2.intersection(point1), point1);
        expect(bound2.intersection(point2), isNull);
        expect(bound2.intersection(bound1), isNull);
        expect(bound2.intersection(bound2), bound2);

        expect(bound2.intersection(bound3), bound4);
        expect(bound3.intersection(bound2), bound4);
      });
      test('==', () {
        expect(point1, point1);
        expect(point1, isNot(point2));
        expect(point1, isNot(bound1));
        expect(point1, isNot(bound2));

        expect(point2, isNot(point1));
        expect(point2, point2);
        expect(point2, isNot(bound1));
        expect(point2, isNot(bound2));

        expect(bound1, isNot(point1));
        expect(bound1, isNot(point2));
        expect(bound1, bound1);
        expect(bound1, isNot(bound2));

        expect(bound2, isNot(point1));
        expect(bound2, isNot(point2));
        expect(bound2, isNot(bound1));
        expect(bound2, bound2);
      });
      test('hashCode', () {
        expect(point1.hashCode, point1.hashCode);
        expect(point1.hashCode, isNot(point2.hashCode));
        expect(point1.hashCode, isNot(bound1.hashCode));
        expect(point1.hashCode, isNot(bound2.hashCode));

        expect(point2.hashCode, isNot(point1.hashCode));
        expect(point2.hashCode, point2.hashCode);
        expect(point2.hashCode, isNot(bound1.hashCode));
        expect(point2.hashCode, isNot(bound2.hashCode));

        expect(bound1.hashCode, isNot(point1.hashCode));
        expect(bound1.hashCode, isNot(point2.hashCode));
        expect(bound1.hashCode, bound1.hashCode);
        expect(bound1.hashCode, isNot(bound2.hashCode));

        expect(bound2.hashCode, isNot(point1.hashCode));
        expect(bound2.hashCode, isNot(point2.hashCode));
        expect(bound2.hashCode, isNot(bound1.hashCode));
        expect(bound2.hashCode, bound2.hashCode);
      });
      test('toString', () {
        expect(
          point1.toString(),
          matches(RegExp(r'Bounds\(1(.0)?, 2(.0)?, 3(.0)?\)')),
        );
        expect(
          point2.toString(),
          matches(RegExp(r'Bounds\(3(.0)?, 2(.0)?, 1(.0)?\)')),
        );
        expect(
          bound1.toString(),
          matches(
            RegExp(
              r'Bounds\(-1(.0)?, -1(.0)?, -1(.0)?; 1(.0)?, 1(.0)?, 1(.0)?\)',
            ),
          ),
        );
        expect(
          bound2.toString(),
          matches(
            RegExp(
              r'Bounds\(-2(.0)?, 1(.0)?, 2(.0)?; 2(.0)?, 3(.0)?, 5(.0)?\)',
            ),
          ),
        );
      });
      test('unionAll', () {
        expect(() => Bounds.unionAll([]), throwsStateError);
        final singleUnion = Bounds.unionAll([bound1]);
        expect(singleUnion.min, bound1.min);
        expect(singleUnion.max, bound1.max);
        final fullUnion1 = Bounds.unionAll([point1, point2, bound1, bound2]);
        expect(fullUnion1.min, [-2.0, -1.0, -1.0]);
        expect(fullUnion1.max, [3.0, 3.0, 5.0]);
        final fullUnion2 = Bounds.unionAll([bound1, bound2, point2]);
        expect(fullUnion2.min, [-2.0, -1.0, -1.0]);
        expect(fullUnion2.max, [3.0, 3.0, 5.0]);
      });
      test('intersectionAll', () {
        expect(() => Bounds.intersectionAll([]), throwsStateError);
        final singleUnion = Bounds.intersectionAll([bound1]);
        expect(singleUnion?.min, bound1.min);
        expect(singleUnion?.max, bound1.max);
        final emptyUnion = Bounds.intersectionAll([bound1, bound2]);
        expect(emptyUnion, isNull);
        final fullUnion1 = Bounds.intersectionAll([bound2, bound3]);
        expect(fullUnion1?.min, bound4.min);
        expect(fullUnion1?.max, bound4.max);
        final fullUnion2 = Bounds.intersectionAll([bound2, bound3, point1]);
        expect(fullUnion2?.min, point1.min);
        expect(fullUnion2?.max, point1.max);
      });
    });
    group('guttman', () {
      allRTreeTests(
        <T>({int? minEntries, int? maxEntries}) =>
            RTree<T>.guttmann(minEntries: minEntries, maxEntries: maxEntries),
      );
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
        expect(empty.toList(), isEmpty);
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
          plenty.sublist(5, 7).toString(),
          plenty.toString().substring(5, 7),
        );
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
        expect(empty.toList(), isEmpty);
        expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
        expect(empty.toSet(), <String>{});
        expect(plenty.toSet(), {'M', 'o', 'r', 'e', ' ', 'D', 'a', 't'});
        expect(empty.toString(), '');
        expect(plenty.toString(), 'More Dart');
      });
      test('sublist', () {
        expect(plenty.sublist(5).toString(), plenty.toString().substring(5));
        expect(
          plenty.sublist(5, 7).toString(),
          plenty.toString().substring(5, 7),
        );
      });
    });
    group('partition', () {
      final regexp = RegExp(r',+');
      group('partition', () {
        test('string', () {
          expect('123,456,789'.partition(','), ['123', ',', '456,789']);
          expect('123;456;789'.partition(','), ['123;456;789', '', '']);
        });
        test('regexp', () {
          expect('123,,456,,789'.partition(regexp), ['123', ',,', '456,,789']);
          expect('123;;456;;789'.partition(regexp), ['123;;456;;789', '', '']);
        });
        test('start', () {
          expect('123,456,789'.partition(',', 3), ['123', ',', '456,789']);
          expect('123,456,789'.partition(',', 6), ['123,456', ',', '789']);
          expect('123,456,789'.partition(',', 9), ['123,456,789', '', '']);
        });
      });
      group('last partition', () {
        test('string', () {
          expect('123,456,789'.lastPartition(','), ['123,456', ',', '789']);
          expect('123;456;789'.lastPartition(','), ['', '', '123;456;789']);
        });
        test('regexp', () {
          expect('123,,456,,789'.lastPartition(regexp), [
            '123,,456,',
            ',',
            '789',
          ]);
          expect('123;;456;;789'.lastPartition(regexp), [
            '',
            '',
            '123;;456;;789',
          ]);
        });
        test('start', () {
          expect('123,456,789'.lastPartition(',', 2), ['', '', '123,456,789']);
          expect('123,456,789'.lastPartition(',', 5), ['123', ',', '456,789']);
          expect('123,456,789'.lastPartition(',', 7), ['123,456', ',', '789']);
        });
      });
    });
    group('remove prefix', () {
      test('string', () {
        expect('abcd'.removePrefix(''), 'abcd');
        expect('abcd'.removePrefix('a'), 'bcd');
        expect('abcd'.removePrefix('ab'), 'cd');
        expect('abcd'.removePrefix('abc'), 'd');
        expect('abcd'.removePrefix('abcd'), '');
        expect('abcd'.removePrefix('bcd'), 'abcd');
        expect('abcd'.removePrefix('xyz'), 'abcd');
      });
      test('regexp', () {
        expect('abcd'.removePrefix(RegExp('')), 'abcd');
        expect('abcd'.removePrefix(RegExp('a')), 'bcd');
        expect('abcd'.removePrefix(RegExp('ab')), 'cd');
        expect('abcd'.removePrefix(RegExp('abc')), 'd');
        expect('abcd'.removePrefix(RegExp('abcd')), '');
        expect('abcd'.removePrefix(RegExp('bcd')), 'abcd');
        expect('abcd'.removePrefix(RegExp('xyz')), 'abcd');
      });
    });
    group('remove suffix', () {
      test('string', () {
        expect('abcd'.removeSuffix(''), 'abcd');
        expect('abcd'.removeSuffix('d'), 'abc');
        expect('abcd'.removeSuffix('cd'), 'ab');
        expect('abcd'.removeSuffix('bcd'), 'a');
        expect('abcd'.removeSuffix('abcd'), '');
        expect('abcd'.removeSuffix('abc'), 'abcd');
        expect('abcd'.removeSuffix('xyz'), 'abcd');
      });
      test('regexp', () {
        expect('abcd'.removeSuffix(RegExp('')), 'abcd');
        expect('abcd'.removeSuffix(RegExp('d')), 'abc');
        expect('abcd'.removeSuffix(RegExp('cd')), 'ab');
        expect('abcd'.removeSuffix(RegExp('bcd')), 'a');
        expect('abcd'.removeSuffix(RegExp('abcd')), '');
        expect('abcd'.removeSuffix(RegExp('abc')), 'abcd');
        expect('abcd'.removeSuffix(RegExp('xyz')), 'abcd');
      });
    });
    group('converters', () {
      test('convert first character', () {
        expect(
          ''.convertFirstCharacters((value) {
            fail('Not supposed to be called');
          }),
          '',
        );
        expect(
          'a'.convertFirstCharacters((value) {
            expect(value, 'a');
            return 'A';
          }),
          'A',
        );
        expect(
          'ab'.convertFirstCharacters((value) {
            expect(value, 'a');
            return 'A';
          }),
          'Ab',
        );
        expect(
          'abc'.convertFirstCharacters((value) {
            expect(value, 'a');
            return 'A';
          }),
          'Abc',
        );
      });
      test('convert first two characters', () {
        expect(
          ''.convertFirstCharacters((value) {
            fail('Not supposed to be called');
          }, count: 2),
          '',
        );
        expect(
          'a'.convertFirstCharacters((value) {
            fail('Not supposed to be called');
          }, count: 2),
          'a',
        );
        expect(
          'ab'.convertFirstCharacters((value) {
            expect(value, 'ab');
            return '*';
          }, count: 2),
          '*',
        );
        expect(
          'abc'.convertFirstCharacters((value) {
            expect(value, 'ab');
            return '*';
          }, count: 2),
          '*c',
        );
      });
      test('convert last character', () {
        expect(
          ''.convertLastCharacters((value) {
            fail('Not supposed to be called');
          }),
          '',
        );
        expect(
          'a'.convertLastCharacters((value) {
            expect(value, 'a');
            return 'A';
          }),
          'A',
        );
        expect(
          'ab'.convertLastCharacters((value) {
            expect(value, 'b');
            return 'B';
          }),
          'aB',
        );
        expect(
          'abc'.convertLastCharacters((value) {
            expect(value, 'c');
            return 'C';
          }),
          'abC',
        );
      });
      test('convert last two characters', () {
        expect(
          ''.convertLastCharacters((value) {
            fail('Not supposed to be called');
          }, count: 2),
          '',
        );
        expect(
          'a'.convertLastCharacters((value) {
            fail('Not supposed to be called');
          }, count: 2),
          'a',
        );
        expect(
          'ab'.convertLastCharacters((value) {
            expect(value, 'ab');
            return '*';
          }, count: 2),
          '*',
        );
        expect(
          'abc'.convertLastCharacters((value) {
            expect(value, 'bc');
            return '*';
          }, count: 2),
          'a*',
        );
      });
      test('convert first character to upper-case', () {
        expect(''.toUpperCaseFirstCharacter(), '');
        expect('a'.toUpperCaseFirstCharacter(), 'A');
        expect('ab'.toUpperCaseFirstCharacter(), 'Ab');
        expect('abc'.toUpperCaseFirstCharacter(), 'Abc');
      });
      test('convert first character to lower-case', () {
        expect(''.toLowerCaseFirstCharacter(), '');
        expect('A'.toLowerCaseFirstCharacter(), 'a');
        expect('AB'.toLowerCaseFirstCharacter(), 'aB');
        expect('ABC'.toLowerCaseFirstCharacter(), 'aBC');
      });
    });
    group('indent', () {
      test('default', () {
        expect(''.indent('*'), '');
        expect('foo'.indent('*'), '*foo');
        expect('foo\nbar'.indent('*'), '*foo\n*bar');
        expect('foo\n\nbar'.indent('*'), '*foo\n\n*bar');
        expect(' zork '.indent('*'), '*zork');
      });
      test('firstPrefix', () {
        expect(''.indent('*', firstPrefix: '!'), '');
        expect('foo'.indent('*', firstPrefix: '!'), '!foo');
        expect('foo\nbar'.indent('*', firstPrefix: '!'), '!foo\n*bar');
        expect('foo\n\nbar'.indent('*', firstPrefix: '!'), '!foo\n\n*bar');
        expect(' zork '.indent('*', firstPrefix: '!'), '!zork');
      });
      test('trimWhitespace', () {
        expect(''.indent('*', trimWhitespace: false), '');
        expect('foo'.indent('*', trimWhitespace: false), '*foo');
        expect('foo\nbar'.indent('*', trimWhitespace: false), '*foo\n*bar');
        expect('foo\n\nbar'.indent('*', trimWhitespace: false), '*foo\n\n*bar');
        expect(' zork '.indent('*', trimWhitespace: false), '* zork ');
      });
      test('indentEmpty', () {
        expect(''.indent('*', indentEmpty: true), '*');
        expect('foo'.indent('*', indentEmpty: true), '*foo');
        expect('foo\nbar'.indent('*', indentEmpty: true), '*foo\n*bar');
        expect('foo\n\nbar'.indent('*', indentEmpty: true), '*foo\n*\n*bar');
        expect(' zork '.indent('*', indentEmpty: true), '*zork');
      });
    });
    group('dedent', () {
      test('default', () {
        expect(''.dedent(), '');
        expect('1\n2'.dedent(), '1\n2');
        expect('1\n\n2'.dedent(), '1\n\n2');
        expect(' 1\n\n 2'.dedent(), '1\n\n2');
        expect(' 1\n\n\t2'.dedent(), ' 1\n\n\t2');
        expect(' 1'.dedent(), '1');
        expect(' 1\n  2'.dedent(), '1\n 2');
        expect('  2\n 1'.dedent(), ' 2\n1');
        expect(' 1\n  2\n   3'.dedent(), '1\n 2\n  3');
        expect('   3\n  2\n 1'.dedent(), '  3\n 2\n1');
      });
      test('whitespace', () {
        expect(''.dedent(whitespace: '\t'), '');
        expect('1\n2'.dedent(whitespace: '\t'), '1\n2');
        expect('1\n\n2'.dedent(whitespace: '\t'), '1\n\n2');
        expect('\t1\n\n\t2'.dedent(whitespace: '\t'), '1\n\n2');
        expect('\t1'.dedent(whitespace: '\t'), '1');
        expect('\t1\n\t\t2'.dedent(whitespace: '\t'), '1\n\t2');
        expect('\t\t2\n\t1'.dedent(whitespace: '\t'), '\t2\n1');
        expect('\t1\n\t\t2\n\t\t\t3'.dedent(whitespace: '\t'), '1\n\t2\n\t\t3');
        expect('\t\t\t3\n\t\t2\n\t1'.dedent(whitespace: '\t'), '\t\t3\n\t2\n1');
      });
      test('ignoreEmpty', () {
        expect(''.dedent(ignoreEmpty: false), '');
        expect('1\n2'.dedent(ignoreEmpty: false), '1\n2');
        expect('1\n\n2'.dedent(ignoreEmpty: false), '1\n\n2');
        expect(' 1\n\n 2'.dedent(ignoreEmpty: false), ' 1\n\n 2');
        expect(' 1'.dedent(ignoreEmpty: false), '1');
        expect(' 1\n  2'.dedent(ignoreEmpty: false), '1\n 2');
        expect('  2\n 1'.dedent(ignoreEmpty: false), ' 2\n1');
        expect(' 1\n  2\n   3'.dedent(ignoreEmpty: false), '1\n 2\n  3');
        expect('   3\n  2\n 1'.dedent(ignoreEmpty: false), '  3\n 2\n1');
      });
    });
    group('take/skip', () {
      test('take', () {
        expect('abc'.take(0), '');
        expect('abc'.take(1), 'a');
        expect('abc'.take(2), 'ab');
        expect('abc'.take(3), 'abc');
        expect('abc'.take(4), 'abc');
      });
      test('takeTo', () {
        expect('abc'.takeTo('a'), '');
        expect('abc'.takeTo('b'), 'a');
        expect('abc'.takeTo('c'), 'ab');
        expect('abc'.takeTo('d'), 'abc');
      });
      test('takeLast', () {
        expect('abc'.takeLast(0), '');
        expect('abc'.takeLast(1), 'c');
        expect('abc'.takeLast(2), 'bc');
        expect('abc'.takeLast(3), 'abc');
        expect('abc'.takeLast(4), 'abc');
      });
      test('takeLastTo', () {
        expect('abc'.takeLastTo('a'), 'bc');
        expect('abc'.takeLastTo('b'), 'c');
        expect('abc'.takeLastTo('c'), '');
        expect('abc'.takeLastTo('d'), 'abc');
      });
      test('skip', () {
        expect('abc'.skip(0), 'abc');
        expect('abc'.skip(1), 'bc');
        expect('abc'.skip(2), 'c');
        expect('abc'.skip(3), '');
        expect('abc'.skip(4), '');
      });
      test('skipTo', () {
        expect('abc'.skipTo('a'), 'bc');
        expect('abc'.skipTo('b'), 'c');
        expect('abc'.skipTo('c'), '');
        expect('abc'.skipTo('d'), '');
      });
      test('skipLast', () {
        expect('abc'.skipLast(0), 'abc');
        expect('abc'.skipLast(1), 'ab');
        expect('abc'.skipLast(2), 'a');
        expect('abc'.skipLast(3), '');
        expect('abc'.skipLast(4), '');
      });
      test('skipLastTo', () {
        expect('abc'.skipLastTo('a'), '');
        expect('abc'.skipLastTo('b'), 'a');
        expect('abc'.skipLastTo('c'), 'ab');
        expect('abc'.skipLastTo('d'), '');
      });
    });
    group('wrap', () {
      test('default', () {
        expect('a'.wrap(4), 'a');
        expect('a b'.wrap(4), 'a b');
        expect('a b c'.wrap(4), 'a b\nc');
        expect('aa bb cc'.wrap(4), 'aa\nbb\ncc');
        expect('a\nb'.wrap(4), 'a\nb');
        expect('a\n\nb'.wrap(4), 'a\n\nb');
        expect('1234'.wrap(4), '1234');
        expect('12345'.wrap(4), '1234\n5');
        expect('12345678'.wrap(4), '1234\n5678');
        expect('123456789'.wrap(4), '1234\n5678\n9');
      });
      test('whitespace', () {
        const whitespace = ' ';
        expect('a'.wrap(4, whitespace: whitespace), 'a');
        expect('a b'.wrap(4, whitespace: whitespace), 'a b');
        expect('a  b'.wrap(4, whitespace: whitespace), 'a b');
        expect('a b c'.wrap(4, whitespace: whitespace), 'a b\nc');
        expect('aa bb cc'.wrap(4, whitespace: whitespace), 'aa\nbb\ncc');
        expect('a\nb'.wrap(4, whitespace: whitespace), 'a\nb');
        expect('1234'.wrap(4, whitespace: whitespace), '1234');
        expect('12345'.wrap(4, whitespace: whitespace), '1234\n5');
        expect('12345678'.wrap(4, whitespace: whitespace), '1234\n5678');
        expect('123456789'.wrap(4, whitespace: whitespace), '1234\n5678\n9');
      });
      test('breakLongWords', () {
        expect('a'.wrap(4, breakLongWords: false), 'a');
        expect('a b'.wrap(4, breakLongWords: false), 'a b');
        expect('a b c'.wrap(4, breakLongWords: false), 'a b\nc');
        expect('aa bb cc'.wrap(4, breakLongWords: false), 'aa\nbb\ncc');
        expect('a\nb'.wrap(4, breakLongWords: false), 'a\nb');
        expect('1234'.wrap(4, breakLongWords: false), '1234');
        expect('12345'.wrap(4, breakLongWords: false), '12345');
        expect('12345678'.wrap(4, breakLongWords: false), '12345678');
        expect('123456789'.wrap(4, breakLongWords: false), '123456789');
      });
      test('invalid', () {
        expect(() => 'a'.wrap(-1), throwsRangeError);
        expect(() => 'a'.wrap(0), throwsRangeError);
      });
    });
    group('unwrap', () {
      test('single', () {
        expect('1'.unwrap(), '1');
        expect('1\n2'.unwrap(), '1 2');
        expect('1\n2\n3'.unwrap(), '1 2 3');
      });
      test('multiple', () {
        expect('1\n\na'.unwrap(), '1\n\na');
        expect('1\n2\n\na\nb'.unwrap(), '1 2\n\na b');
        expect('1\n2\n3\n\na\nb\nc'.unwrap(), '1 2 3\n\na b c');
      });
    });
    group('normalization', () {
      final invariants = 0
          .to(0x10ffff)
          .toSet()
          .difference(
            normalizationTestData['@Part1']!
                .map((test) => test.source.single)
                .toSet(),
          )
          .map((value) => [value]);
      group('NFC', () {
        const form = NormalizationForm.nfc;
        test('basic', () {
          verifyUnicodeNormalization(form, ''.runes, ''.runes);
          verifyUnicodeNormalization(form, 'élève'.runes, 'élève'.runes);
          verifyUnicodeNormalization(form, '한국'.runes, '한국'.runes);
          verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ﬃ'.runes);
        });
        for (final MapEntry(key: part, value: tests)
            in normalizationTestData.entries) {
          test('suite $part', () {
            for (final test in tests) {
              verifyUnicodeNormalization(form, test.source, test.nfc);
              verifyUnicodeNormalization(form, test.nfc, test.nfc);
              verifyUnicodeNormalization(form, test.nfd, test.nfc);
              verifyUnicodeNormalization(form, test.nfkc, test.nfkc);
              verifyUnicodeNormalization(form, test.nfkd, test.nfkc);
            }
          });
        }
        test('suite invariants', () {
          for (final invariant in invariants) {
            verifyUnicodeNormalization(form, invariant, invariant);
          }
        });
      });
      group('NFD', () {
        const form = NormalizationForm.nfd;
        test('basic', () {
          verifyUnicodeNormalization(form, ''.runes, ''.runes);
          verifyUnicodeNormalization(form, 'élève'.runes, 'élève'.runes);
          verifyUnicodeNormalization(form, '한국'.runes, '한국'.runes);
          verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ﬃ'.runes);
        });
        for (final MapEntry(key: part, value: tests)
            in normalizationTestData.entries) {
          test('suite $part', () {
            for (final test in tests) {
              verifyUnicodeNormalization(form, test.source, test.nfd);
              verifyUnicodeNormalization(form, test.nfc, test.nfd);
              verifyUnicodeNormalization(form, test.nfd, test.nfd);
              verifyUnicodeNormalization(form, test.nfkc, test.nfkd);
              verifyUnicodeNormalization(form, test.nfkd, test.nfkd);
            }
          });
        }
        test('suite invariants', () {
          for (final invariant in invariants) {
            verifyUnicodeNormalization(form, invariant, invariant);
          }
        });
      });
      group('NFKC', () {
        const form = NormalizationForm.nfkc;
        test('basic', () {
          verifyUnicodeNormalization(form, ''.runes, ''.runes);
          verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ffi'.runes);
        });
        for (final MapEntry(key: part, value: tests)
            in normalizationTestData.entries) {
          test('suite $part', () {
            for (final test in tests) {
              verifyUnicodeNormalization(form, test.source, test.nfkc);
              verifyUnicodeNormalization(form, test.nfc, test.nfkc);
              verifyUnicodeNormalization(form, test.nfd, test.nfkc);
              verifyUnicodeNormalization(form, test.nfkc, test.nfkc);
              verifyUnicodeNormalization(form, test.nfkd, test.nfkc);
            }
          });
        }
        test('suite invariants', () {
          for (final invariant in invariants) {
            verifyUnicodeNormalization(form, invariant, invariant);
          }
        });
      });
      group('NFKD', () {
        const form = NormalizationForm.nfkd;
        test('basic', () {
          verifyUnicodeNormalization(form, ''.runes, ''.runes);
          verifyUnicodeNormalization(form, '⑴'.runes, '(1)'.runes);
          verifyUnicodeNormalization(form, 'ﬃ'.runes, 'ffi'.runes);
          verifyUnicodeNormalization(form, '²'.runes, '2'.runes);
          verifyUnicodeNormalization(form, '⑴ ﬃ ²'.runes, '(1) ffi 2'.runes);
        });
        for (final MapEntry(key: part, value: tests)
            in normalizationTestData.entries) {
          test('suite $part', () {
            for (final test in tests) {
              verifyUnicodeNormalization(form, test.source, test.nfkd);
              verifyUnicodeNormalization(form, test.nfc, test.nfkd);
              verifyUnicodeNormalization(form, test.nfd, test.nfkd);
              verifyUnicodeNormalization(form, test.nfkc, test.nfkd);
              verifyUnicodeNormalization(form, test.nfkd, test.nfkd);
            }
          });
        }
        test('suite invariants', () {
          for (final invariant in invariants) {
            verifyUnicodeNormalization(form, invariant, invariant);
          }
        });
      });
    });
  });
  group('trie', () {
    group(
      'list-based',
      () => allTrieTests(
        <K, P extends Comparable<P>, V>() => TrieNodeList<K, P, V>(),
      ),
    );
    group(
      'map-based',
      () => allTrieTests(
        <K, P extends Comparable<P>, V>() => TrieNodeMap<K, P, V>(),
      ),
    );
  });
  group('typemap', () {
    test('empty', () {
      final map = TypeMap<Object>();
      expect(map.hasInstance<String>(), isFalse);
      expect(map.getInstance<String>(), isNull);
      expect(map.types, isEmpty);
      expect(map.instances, isEmpty);
      expect(map.length, 0);
      expect(map.isEmpty, isTrue);
      expect(map.isNotEmpty, isFalse);
      expect(map.asMap(), isEmpty);
      expect(map.toString(), '{}');
    });
    test('single', () {
      final map = TypeMap<Object>();
      map.setInstance('hello');
      expect(map.hasInstance<String>(), isTrue);
      expect(map.getInstance<String>(), 'hello');
      expect(map.hasInstance<int>(), isFalse);
      expect(map.getInstance<int>(), isNull);
      expect(map.types, [String]);
      expect(map.instances, ['hello']);
      expect(map.length, 1);
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
      expect(map.asMap(), {String: 'hello'});
      expect(map.toString(), '{String: hello}');
    });
    test('double', () {
      final map = TypeMap<Object>();
      map.setInstance('hello');
      expect(map.hasInstance<String>(), isTrue);
      expect(map.getInstance<String>(), 'hello');
      expect(map.hasInstance<int>(), isFalse);
      expect(map.getInstance<int>(ifAbsentPut: () => 42), 42);
      expect(map.hasInstance<int>(), isTrue);
      expect(map.getInstance<int>(ifAbsentPut: () => 52), 42);
      expect(map.types, [String, int]);
      expect(map.instances, ['hello', 42]);
      expect(map.length, 2);
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
      expect(map.asMap(), {String: 'hello', int: 42});
      expect(map.toString(), '{String: hello, int: 42}');
    });
  });
}

void verifyRange<T>(
  Range<T> range, {
  required List<T> included,
  required List<T> excluded,
  bool reverse = true,
}) {
  expect(range, included);
  expect(range.length, included.length);
  if (reverse) {
    verifyRange(
      range.reversed,
      included: included.reversed.toList(),
      excluded: excluded,
      reverse: false,
    );
  }
  if (included.isEmpty) {
    expect(range.isEmpty, isTrue);
  } else {
    expect(range.isNotEmpty, isTrue);
    expect(range.start, included.first);
    expect(range.start, isNot(range.end));
    expect(range.first, included.first);
    expect(range.last, included.last);
  }
  // Test included indexes.
  for (final each in included.indexed()) {
    expect(each.value, range[each.index]);
    expect(range.contains(each.value), isTrue);
    expect(range.indexOf(each.value), each.index);
    expect(range.indexOf(each.value, each.index), each.index);
    expect(range.indexOf(each.value, -1), each.index);
    expect(range.lastIndexOf(each.value), each.index);
    expect(range.lastIndexOf(each.value, each.index), each.index);
    expect(range.lastIndexOf(each.value, included.length), each.index);
  }
  // Test excluded indexes.
  for (final value in excluded) {
    expect(range.contains(value), isFalse);
    expect(range.indexOf(value), -1);
    expect(range.indexOf(value, 0), -1);
    expect(range.indexOf(value, range.length), -1);
    expect(range.lastIndexOf(value), -1);
    expect(range.lastIndexOf(value, 0), -1);
    expect(range.lastIndexOf(value, range.length), -1);
  }
  // Validate forward iteration.
  final forward1 = range.iterator;
  expect(forward1.range, same(range));
  final forward2 = included.iterator;
  while (true) {
    final hasMore = forward1.moveNext();
    expect(hasMore, forward2.moveNext());
    if (hasMore == false) break;
    expect(forward1.current, forward2.current);
  }
  // Validate backward iteration.
  final backward1 = range.iteratorAtEnd;
  expect(backward1.range, same(range));
  final backward2 = included.reversed.iterator;
  while (true) {
    final hasMore = backward1.movePrevious();
    expect(hasMore, backward2.moveNext());
    if (hasMore == false) break;
    expect(backward1.current, backward2.current);
  }
  // Test range errors.
  expect(() => range[-1], throwsRangeError);
  expect(() => range[included.length], throwsRangeError);
}

void allSortedListTests(
  SortedList<E> Function<E>(
    Iterable<E> list, {
    Comparator<E>? comparator,
    bool growable,
  })
  createSortedList,
) {
  test('default ordering', () {
    final list = createSortedList<int>([5, 1, 2, 4, 3]);
    expect(list, [1, 2, 3, 4, 5]);
  });
  test('custom ordering', () {
    final list = createSortedList<num>([
      5,
      1,
      2,
      4,
      3,
    ], comparator: reverseComparable<num>);
    expect(list, [5, 4, 3, 2, 1]);
  });
  test('custom comparator', () {
    final list = createSortedList<int>([
      5,
      1,
      2,
      4,
      3,
    ], comparator: (a, b) => b - a);
    expect(list, [5, 4, 3, 2, 1]);
  });
  test('empty list', () {
    final list = createSortedList<int>([]);
    expect(list, isEmpty);
  });
  test('accessors', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.length, 3);
    expect(list.first, 1);
    expect(list.last, 5);
    expect(list[0], 1);
    expect(list[2], 5);
  });
  test('contains', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.contains(0), isFalse);
    expect(list.contains(1), isTrue);
    expect(list.contains(2), isFalse);
    expect(list.contains(3), isTrue);
    expect(list.contains(4), isFalse);
    expect(list.contains(5), isTrue);
    expect(list.contains(6), isFalse);
    expect(list.contains(null), isFalse);
  });
  test('occurrences', () {
    final list = createSortedList<int>([1, 2, 2, 3, 3, 3, 4, 4, 4, 4]);
    expect(list.occurrences(0), 0);
    expect(list.occurrences(1), 1);
    expect(list.occurrences(2), 2);
    expect(list.occurrences(3), 3);
    expect(list.occurrences(4), 4);
    expect(list.occurrences(5), 0);
  });
  test('add', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    list.add(4);
    expect(list, [1, 3, 4, 5]);
  });
  test('add (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    expect(() => list.add(4), throwsUnsupportedError);
  });
  test('addAll', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    list.addAll([2, 4]);
    expect(list, [1, 2, 3, 4, 5]);
  });
  test('addAll (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    expect(() => list.addAll([2, 4]), throwsUnsupportedError);
  });
  test('clear', () {
    final list = createSortedList<int>([5, 1, 3]);
    list.clear();
    expect(list, isEmpty);
  });
  test('remove', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list, [1, 3, 5]);
    expect(list.remove(3), isTrue);
    expect(list, [1, 5]);
    expect(list.remove(3), isFalse);
    expect(list.remove(null), isFalse);
  });
  test('remove (not growable)', () {
    final list = createSortedList<int>([5, 1, 3], growable: false);
    expect(() => list.remove(3), throwsUnsupportedError);
  });
  test('removeAt', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.removeAt(1), 3);
    expect(list, [1, 5]);
  });
  test('removeFirst', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.removeFirst(), 1);
    expect(list, [3, 5]);
  });
  test('removeLast', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.removeLast(), 5);
    expect(list, [1, 3]);
  });
  test('removeAll', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.removeAll(), [1, 3, 5]);
    expect(list, isEmpty);
  });
  test('toUnorderedList', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.toUnorderedList(), [1, 3, 5]);
  });
  test('unorderedElements', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(list.unorderedElements, [1, 3, 5]);
  });
  test('stress', () {
    final random = Random(6412);
    final numbers = <int>{};
    // Create 1000 unique numbers.
    while (numbers.length < 1000) {
      numbers.add(random.nextInt(0xffffff));
    }
    final values = List.of(numbers);
    // Create a list from digit of the values.
    final list = createSortedList<int>(values);
    // Verify all values are present.
    expect(list, hasLength(values.length));
    for (final value in values) {
      expect(list.contains(value), isTrue);
    }
    // Remove values in different order.
    values.shuffle(random);
    for (final value in values) {
      expect(list.remove(value), isTrue);
    }
    // Verify all values are gone.
    expect(list, isEmpty);
  });
  test('errors', () {
    final list = createSortedList<int>([5, 1, 3]);
    expect(() => list[0] = 2, throwsUnsupportedError);
    expect(() => list.length = 2, throwsUnsupportedError);
    expect(() => list.insert(1, 4), throwsUnsupportedError);
    expect(() => list.insertAll(1, [2, 4]), throwsUnsupportedError);
    expect(() => list.sort(), throwsUnsupportedError);
    expect(() => list.shuffle(), throwsUnsupportedError);
  });
}

void allRTreeTests(
  RTree<T> Function<T>({int? minEntries, int? maxEntries}) createRTree,
) {
  void validate<T>(RTree<T> tree, [RTreeNode<T>? parent, RTreeNode<T>? node]) {
    node ??= tree.root;
    expect(node.tree, same(tree));
    expect(node.parent, same(parent));
    if (node.isRoot) expect(node, same(tree.root));
    if (parent != null) {
      final parentEntry = node.parentEntry!;
      expect(node, same(parentEntry.child));
      for (final entry in node.entries) {
        expect(parentEntry.bounds.contains(entry.bounds), isTrue);
      }
    }
    for (final entry in node.entries) {
      if (entry.isLeaf) {
        expect(entry.data, isNotNull);
        expect(entry.child, isNull);
      } else {
        expect(entry.data, isNull);
        expect(entry.child, isNotNull);
        validate(tree, node, entry.child);
      }
    }
  }

  test('stress', () {
    final rtree = createRTree<int>();
    final random = Random(3212312);
    final bounds = <Bounds>[];
    for (var i = 0; i < 1000; i++) {
      final bound = Bounds.fromPoint(
        List.generate(3, (index) => 2000 * random.nextDouble() - 1000),
      );
      rtree.insert(bound, i);
      bounds.add(bound);
    }
    for (var i = 0; i < bounds.length; i++) {
      expect(rtree.searchNodes(), isNotEmpty);
      expect(rtree.searchEntries(), isNotEmpty);
      expect(rtree.queryEntries(bounds[i]), isNotEmpty);
      expect(rtree.queryNodes(bounds[i], leaves: true), isNotEmpty);
      expect(rtree.queryNodes(bounds[i], leaves: false), isNotEmpty);
    }
    validate(rtree);
  });
}

void allTrieTests(
  TrieNode<K, P, V> Function<K, P extends Comparable<P>, V>() createRoot,
) {
  Trie<String, String, num> newTrie() => Trie<String, String, num>(
    parts: (key) => key.toList(),
    root: createRoot<String, String, num>(),
  );
  group('add', () {
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      expect(trie, hasLength(1));
      expect(trie.keys, ['disobey']);
      expect(trie.values, [42]);
      expect(trie['disobey'], 42);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('multiple', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disorder'] = 43;
      trie['disown'] = 44;
      trie['distrust'] = 45;
      expect(trie, hasLength(4));
      expect(trie.keys, ['disobey', 'disorder', 'disown', 'distrust']);
      expect(trie.values, [42, 43, 44, 45]);
      expect(trie.keysWithPrefix('dis'), [
        'disobey',
        'disorder',
        'disown',
        'distrust',
      ]);
      expect(trie.keysWithPrefix('diso'), ['disobey', 'disorder', 'disown']);
      expect(trie.keysWithPrefix('disobeying'), isEmpty);
      expect(trie['disobey'], 42);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['disorder'], 43);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie['disown'], 44);
      expect(trie.containsKey('disown'), isTrue);
      expect(trie['distrust'], 45);
      expect(trie.containsKey('distrust'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      expect(trie, hasLength(1));
      expect(trie.keys, ['']);
      expect(trie.values, [42]);
      expect(trie[''], 42);
      expect(trie.containsKey(''), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
    });
    test('replace', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disobey'] = 43;
      expect(trie, hasLength(1));
      expect(trie.keys, ['disobey']);
      expect(trie.values, [43]);
      expect(trie['disobey'], 43);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie['disobeying'], isNull);
      expect(trie.containsKey('disobeying'), isFalse);
    });
    test('enhancing', () {
      final trie = newTrie();
      trie['disobeying'] = 42;
      trie['disobey'] = 43;
      expect(trie, hasLength(2));
      expect(trie.keys, ['disobey', 'disobeying']);
      expect(trie.values, [43, 42]);
      expect(trie['disobeying'], 42);
      expect(trie.containsKey('disobeying'), isTrue);
      expect(trie['disobey'], 43);
      expect(trie.containsKey('disobey'), isTrue);
      expect(trie['dis'], isNull);
      expect(trie.containsKey('dis'), isFalse);
    });
  });
  group('remove', () {
    test('missing', () {
      final trie = newTrie();
      expect(trie.remove('disobey'), isNull);
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      expect(trie.remove(''), 42);
      expect(trie.containsKey(''), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      expect(trie.remove('disobey'), 42);
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('prefix', () {
      final trie = newTrie();
      trie['dis'] = 42;
      trie['disorder'] = 43;
      expect(trie.remove('dis'), 42);
      expect(trie.containsKey('dis'), isFalse);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie, hasLength(1));
      expect(trie.keys, ['disorder']);
      expect(trie.values, [43]);
    });
    test('root prefix', () {
      final trie = newTrie();
      trie[''] = 42;
      trie['disorder'] = 43;
      expect(trie.remove(''), 42);
      expect(trie.containsKey(''), isFalse);
      expect(trie.containsKey('disorder'), isTrue);
      expect(trie, hasLength(1));
      expect(trie.keys, ['disorder']);
      expect(trie.values, [43]);
    });
  });
  group('clear', () {
    test('root', () {
      final trie = newTrie();
      trie[''] = 42;
      trie.clear();
      expect(trie.containsKey(''), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('single', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie.clear();
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
    test('multiple', () {
      final trie = newTrie();
      trie['disobey'] = 42;
      trie['disobeying'] = 43;
      trie.clear();
      expect(trie.containsKey('disobey'), isFalse);
      expect(trie.containsKey('disobeying'), isFalse);
      expect(trie, hasLength(0));
      expect(trie.keys, isEmpty);
      expect(trie.values, isEmpty);
    });
  });
  group('constructor', () {
    test('fromTrie', () {
      final firstTrie = newTrie();
      firstTrie['abc'] = 42;
      final secondTrie = Trie<String, String, num>.fromTrie(
        firstTrie,
        root: createRoot<String, String, num>(),
      );
      secondTrie['abcdef'] = 43;
      expect(firstTrie, hasLength(1));
      expect(firstTrie.keys, ['abc']);
      expect(firstTrie.values, [42]);
      expect(secondTrie, hasLength(2));
      expect(secondTrie.keys, ['abc', 'abcdef']);
      expect(secondTrie.values, [42, 43]);
    });
    test('fromMap', () {
      final trie = Trie<String, String, int>.fromMap(
        {'abc': 42, 'abcdef': 43},
        parts: (key) => key.toList(),
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [42, 43]);
    });
    test('fromIterable', () {
      final trie = Trie<String, String, int>.fromIterable(
        ['abc', 'abcdef'],
        parts: (key) => key.toList(),
        value: (value) => (value as String).length,
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [3, 6]);
    });
    test('fromIterables', () {
      final trie = Trie<String, String, int>.fromIterables(
        ['abc', 'abcdef'],
        [42, 43],
        parts: (key) => key.toList(),
        root: createRoot(),
      );
      expect(trie, hasLength(2));
      expect(trie.keys, ['abc', 'abcdef']);
      expect(trie.values, [42, 43]);
    });
    test('fromIterables (error)', () {
      expect(
        () => Trie<String, String, int>.fromIterables(
          ['abc', 'abcdef'],
          [42],
          parts: (key) => key.toList(),
          root: createRoot(),
        ),
        throwsArgumentError,
      );
    });
  });
  group('other', () {
    test('typed', () {
      final trie = newTrie();
      expect(trie.containsKey(42), isFalse);
      expect(trie[42], isNull);
    });
    test('nodes', () {
      final trie = newTrie();
      trie.addAll({'a': 1, 'aa': 2, 'ab': 3});
      final root = createRoot<String, String, num>();
      expect(root.hasKeyAndValue, isFalse);
      expect(root.hasChildren, isFalse);
      expect(root.parts, isEmpty);
    });
    test('stress', () {
      final random = Random(42);
      final numbers = <int>{};
      // Create 1000 unique numbers.
      while (numbers.length < 1000) {
        numbers.add(random.nextInt(0xffffff));
      }
      final values = List.of(numbers);
      // Create a trie from digit of the values.
      final trie = Trie<int, String, bool>(
        parts: (value) => value.digits().map((digit) => digit.toString()),
        root: createRoot(),
      );
      for (final value in values) {
        trie[value] = true;
      }
      // Verify all values are present.
      expect(trie, hasLength(values.length));
      for (final value in values) {
        expect(trie.containsKey(value), isTrue);
        expect(trie[value], isTrue);
      }
      // Remove values in different order.
      values.shuffle(random);
      for (final value in values) {
        expect(trie.remove(value), isTrue);
      }
      // Verify all values are gone.
      expect(trie, isEmpty);
      for (final value in values) {
        expect(trie.containsKey(value), isFalse);
        expect(trie[value], isNull);
      }
    });
  });
}

void verifyUnicodeNormalization(
  NormalizationForm form,
  Iterable<int> source,
  Iterable<int> expected,
) {
  final sourceString = String.fromCharCodes(source);
  final actualString = sourceString.normalize(form: form);
  final expectedString = String.fromCharCodes(expected);
  if (actualString == expectedString) {
    expect(actualString, expectedString);
  } else {
    formatCharCodes(Iterable<int> charCodes) => charCodes
        .map((code) => code.toRadixString(16).padLeft(4, '0'))
        .join(' ');
    expect(
      actualString,
      expectedString,
      reason:
          'for "$sourceString" [${formatCharCodes(source)}]\n'
          'expected "$expectedString" [${formatCharCodes(expected)}],\n'
          'but got "$actualString" [${formatCharCodes(actualString.runes)}].',
    );
  }
}
