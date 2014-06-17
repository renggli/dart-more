library bit_list_test;

import 'dart:math';
import 'package:unittest/unittest.dart';
import 'package:more/collection.dart';

List<bool> randomList(int seed, int length) {
  var list = new List();
  var generator = new Random(seed);
  for (var i = 0; i < length; i++) {
    list.add(generator.nextBool());
  }
  return list;
}

void main() {
  group('collection', () {
    group('bitlist', () {
      group('construction', () {
        test('without elements', () {
          var target = new BitList(0);
          expect(target, isEmpty);
          expect(target, hasLength(0));
          expect(target, []);
        });
        test('with elements', () {
          for (var len = 1; len < 100; len++) {
            var target = new BitList(len);
            expect(target, isNot(isEmpty));
            expect(target, hasLength(len));
            expect(target, everyElement(isFalse));
          }
        });
        test('from List', () {
          for (var len = 0; len < 100; len++) {
            var source = new List.from(randomList(457 * len, len));
            var target = new BitList.from(source);
            expect(source, target);
            expect(source, target.toList());
          }
        });
        test('from Set', () {
          for (var len = 0; len < 100; len++) {
            var source = new Set.from(randomList(827 * len, len));
            var target = new BitList.from(source);
            expect(source, target);
            expect(source, target.toSet());
          }
        });
        test('from BitList', () {
          for (var len = 0; len < 10; len++) {
            var source = new Set.from(randomList(287 * len, len));
            var target = new BitList.from(source);
            expect(source, target);
            expect(target, source);
          }
        });
      });
      group('accessors', () {
        test('reading', () {
          for (var len = 0; len < 100; len++) {
            var source = randomList(389 * len, len);
            var target = new BitList.from(source);
            expect(() => target[-1], throwsRangeError);
            for (var i = 0; i < len; i++) {
              expect(target[i], source[i]);
            }
            expect(() => target[len], throwsRangeError);
          }
        });
        test('writing', () {
          for (var len = 0; len < 100; len++) {
            var source = randomList(389 * len, len);
            var target = new BitList(len);
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
            var source = new BitList.from(randomList(147 * len, 100));
            var target = ~source;
            for (var i = 0; i < source.length; i++) {
              var before = source[i];
              source.flip(i);
              expect(!before, source[i]);
            }
            expect(target, source);
          }
        });
        test('counting', () {
          for (var len = 0; len < 100; len++) {
            var list = new BitList.from(randomList(823 * len, len));
            var trueCount = list.count(true);
            var falseCount = list.count(false);
            expect(trueCount + falseCount, list.length);
            expect(trueCount, list.where((b) => b == true).length);
            expect(falseCount, list.where((b) => b == false).length);
          }
        });
      });
      group('operators', () {
        test('complement', () {
          var source = new BitList.from(randomList(702, 100));
          var target = ~source;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], !source[i]);
          }
        });
        test('intersection', () {
          var source1 = new BitList.from(randomList(439, 100));
          var source2 = new BitList.from(randomList(902, 100));
          var target = source1 & source2;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] && source2[i]);
          }
          expect(target, source2 & source1);
        });
        test('union', () {
          var source1 = new BitList.from(randomList(817, 100));
          var source2 = new BitList.from(randomList(858, 100));
          var target = source1 | source2;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] || source2[i]);
          }
          expect(target, source2 | source1);
        });
        test('difference', () {
          var source1 = new BitList.from(randomList(364, 100));
          var source2 = new BitList.from(randomList(243, 100));
          var target = source1 - source2;
          for (var i = 0; i < target.length; i++) {
            expect(target[i], source1[i] && !source2[i]);
          }
          expect(target, source1 & ~source2);
        });
        test('shift-left', () {
          for (var len = 0; len < 100; len++) {
            var source = new BitList.from(randomList(836 * len, len));
            for (var shift = 0; shift <= len + 10; shift++) {
              var target = source << shift;
              if (shift == 0) {
                expect(target, source);
              } else if (shift >= len) {
                expect(target, everyElement(isFalse));
              } else {
                for (var i = shift; i < source.length; i++) {
                  expect(target[i], source[i - shift]);
                }
              }
              expect(() => source << -1 - shift, throwsArgumentError);
            }
          }
        });
        test('shift-right', () {
          for (var len = 0; len < 100; len++) {
            var source = new BitList.from(randomList(963 * len, len));
            for (var shift = 0; shift <= len + 10; shift++) {
              var target = source >> shift;
              if (shift == 0) {
                expect(target, source);
              } else if (shift >= len) {
                expect(target, everyElement(isFalse));
              } else {
                for (var i = 0; i < source.length - shift; i++) {
                  expect(target[i], source[i + shift]);
                }
              }
              expect(() => source << -1 - shift, throwsArgumentError);
            }
          }
        });
      });
      test('fixed length', () {
        var list = new BitList(32);
        expect(() => list.add(false), throwsUnsupportedError);
        expect(() => list.addAll([true, false]), throwsUnsupportedError);
        expect(() => list.clear(), throwsUnsupportedError);
        expect(() => list.insert(2, true), throwsUnsupportedError);
        expect(() => list.insertAll(2, [true, false]), throwsUnsupportedError);
        expect(() => list.length = 10, throwsUnsupportedError);
        expect(() => list.remove(true), throwsUnsupportedError);
        expect(() => list.removeAll([true, false]), throwsUnsupportedError);
        expect(() => list.removeAt(2), throwsUnsupportedError);
        expect(() => list.removeLast(), throwsUnsupportedError);
        expect(() => list.removeRange(2, 4), throwsUnsupportedError);
        expect(() => list.removeWhere((value) => true), throwsUnsupportedError);
        expect(() => list.replaceRange(2, 4, [true, false]), throwsUnsupportedError);
        expect(() => list.retainAll([true, false]), throwsUnsupportedError);
        expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
      });
    });

    group('multiset', () {
      group('construct', () {
        test('empty', () {
          var set = new Multiset();
          expect(set, isEmpty);
          expect(set, hasLength(0));
          expect(set, unorderedEquals([]));
          expect(set.distinct, unorderedEquals([]));
        });
        test('one unique', () {
          var set = new Multiset.from(['a']);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(1));
          expect(set, unorderedEquals(['a']));
          expect(set.distinct, unorderedEquals(['a']));
        });
        test('many unique', () {
          var set = new Multiset.from(['a', 'b', 'c']);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(3));
          expect(set, unorderedEquals(['a', 'b', 'c']));
          expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        });
        test('one repeated', () {
          var set = new Multiset.from(['a', 'a', 'a']);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(3));
          expect(set, unorderedEquals(['a', 'a', 'a']));
          expect(set.distinct, unorderedEquals(['a']));
        });
        test('many repeated', () {
          var set = new Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(6));
          expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
          expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        });
        test('copy', () {
          var set = new Multiset.from(new Multiset.from(['a', 'a', 'a', 'b', 'b', 'c']));
          expect(set, isNot(isEmpty));
          expect(set, hasLength(6));
          expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
          expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        });
        test('generate', () {
          var set = new Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c']);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(6));
          expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
          expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        });
        test('generate with key', () {
          var set = new Multiset.fromIterable(['a', 'a', 'a', 'b', 'b', 'c'],
              key: (String e) => e.codeUnitAt(0));
          expect(set, isNot(isEmpty));
          expect(set, hasLength(6));
          expect(set, unorderedEquals([97, 97, 97, 98, 98, 99]));
          expect(set.distinct, unorderedEquals([97, 98, 99]));
        });
        test('generate with count', () {
          var set = new Multiset.fromIterable(['aaa', 'bb', 'c'],
              key: (String e) => e.substring(0, 1),
              count: (String e) => e.length);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(6));
          expect(set, unorderedEquals(['a', 'a', 'a', 'b', 'b', 'c']));
          expect(set.distinct, unorderedEquals(['a', 'b', 'c']));
        });
      });
      group('adding', () {
        test('zero', () {
          var set = new Multiset();
          set..add('a', 0)..add('b', 0);
          expect(set, isEmpty);
          expect(set, hasLength(0));
          expect(set, unorderedEquals([]));
          expect(set.distinct, unorderedEquals([]));
        });
        test('single', () {
          var set = new Multiset();
          set..add('a')..add('b')..add('b');
          expect(set, isNot(isEmpty));
          expect(set, hasLength(3));
          expect(set, unorderedEquals(['a', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
        test('multiple', () {
          var set = new Multiset();
          set..add('a', 2)..add('b', 3);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(5));
          expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
        test('all', () {
          var set = new Multiset();
          set.addAll(['a', 'a', 'b', 'b', 'b']);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(5));
          expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
        test('error', () {
          var set = new Multiset();
          expect(() => set.add('a', -1), throwsArgumentError);
          expect(set, isEmpty);
          expect(set, hasLength(0));
          expect(set, unorderedEquals([]));
          expect(set.distinct, unorderedEquals([]));
        });
      });
      group('remvoing', () {
        test('zero', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          set..remove('a', 0)..remove('b', 0);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(5));
          expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
        test('single', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          set..remove('a')..remove('b');
          expect(set, isNot(isEmpty));
          expect(set, hasLength(3));
          expect(set, unorderedEquals(['a', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
        test('multiple', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          set..remove('a', 3)..remove('b', 2);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(1));
          expect(set, unorderedEquals(['b']));
          expect(set.distinct, unorderedEquals(['b']));
        });
        test('all', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          set.removeAll(['a', 'b', 'b']);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(2));
          expect(set, unorderedEquals(['a', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
        test('clear', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          set.clear();
          expect(set, isEmpty);
          expect(set, hasLength(0));
          expect(set, unorderedEquals([]));
          expect(set.distinct, unorderedEquals([]));
        });
        test('invalid', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          expect(() => set.remove('c'), returnsNormally);
          expect(() => set.remove(false), returnsNormally);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(5));
          expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
        test('error', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          expect(() => set.remove('a', -1), throwsArgumentError);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(5));
          expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
      });
      group('access', () {
        test('single', () {
          var set = new Multiset();
          set['a'] = 2;
          expect(set['a'], 2);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(2));
          expect(set, unorderedEquals(['a', 'a']));
          expect(set.distinct, unorderedEquals(['a']));
        });
        test('multiple', () {
          var set = new Multiset();
          set['a'] = 2;
          set['b'] = 3;
          expect(set['a'], 2);
          expect(set['b'], 3);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(5));
          expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
        test('remove', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          set['b'] = 0;
          expect(set, isNot(isEmpty));
          expect(set, hasLength(2));
          expect(set, unorderedEquals(['a', 'a']));
          expect(set.distinct, unorderedEquals(['a']));
        });
        test('error', () {
          var set = new Multiset.from(['a', 'a', 'b', 'b', 'b']);
          expect(() => set['a'] = -1, throwsArgumentError);
          expect(set, isNot(isEmpty));
          expect(set, hasLength(5));
          expect(set, unorderedEquals(['a', 'a', 'b', 'b', 'b']));
          expect(set.distinct, unorderedEquals(['a', 'b']));
        });
      });
      group('operator', () {
        var first_list = ['a', 'b', 'c', 'c'];
        var first_set = new Multiset.from(first_list);
        var second_list = ['a', 'c', 'd', 'd'];
        var second_set = new Multiset.from(second_list);
        test('contains', () {
          expect(first_set.contains('a'), isTrue);
          expect(first_set.contains('b'), isTrue);
          expect(first_set.contains('c'), isTrue);
          expect(first_set.contains('d'), isFalse);
        });
        test('containsAll', () {
          expect(first_set.containsAll(first_set), isTrue);
          expect(first_set.containsAll(second_set), isFalse);
          expect(first_set.containsAll(new Multiset()), isTrue);
          expect(first_set.containsAll(new Multiset.from(['a', 'b', 'b'])), isFalse);
          expect(first_set.containsAll(new Multiset.from(['a', 'b', 'd'])), isFalse);
        });
        test('containsAll (iterable)', () {
          expect(first_set.containsAll(first_list), isTrue);
          expect(first_set.containsAll(second_list), isFalse);
          expect(first_set.containsAll([]), isTrue);
          expect(first_set.containsAll(['a', 'b', 'b']), isFalse);
          expect(first_set.containsAll(['a', 'b', 'd']), isFalse);
        });
        test('intersection', () {
          expect(first_set.intersection(second_set), unorderedEquals(['a', 'c']));
          expect(first_set.intersection(second_set).distinct, unorderedEquals(['a', 'c']));
          expect(second_set.intersection(first_set), unorderedEquals(['a', 'c']));
          expect(second_set.intersection(first_set).distinct, unorderedEquals(['a', 'c']));
        });
        test('intersection (iterable)', () {
          expect(first_set.intersection(second_list), unorderedEquals(['a', 'c']));
          expect(second_set.intersection(first_list), unorderedEquals(['a', 'c']));
        });
        test('union', () {
          expect(first_set.union(second_set), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
          expect(first_set.union(second_set).distinct, unorderedEquals(['a', 'b', 'c', 'd']));
          expect(second_set.union(first_set), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
          expect(second_set.union(first_set).distinct, unorderedEquals(['a', 'b', 'c', 'd']));
        });
        test('union (iterable)', () {
          expect(first_set.union(second_list), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
          expect(second_set.union(first_list), unorderedEquals(['a', 'a', 'b', 'c', 'c', 'c', 'd', 'd']));
        });
        test('difference', () {
          expect(first_set.difference(second_set), unorderedEquals(['b', 'c']));
          expect(first_set.difference(second_set).distinct, unorderedEquals(['b', 'c']));
          expect(second_set.difference(first_set), unorderedEquals(['d', 'd']));
          expect(second_set.difference(first_set).distinct, unorderedEquals(['d']));
        });
        test('difference (iterable)', () {
          expect(first_set.difference(second_list), unorderedEquals(['b', 'c']));
          expect(second_set.difference(first_list), unorderedEquals(['d', 'd']));
        });
      });
    });
    group('range', () {
      test('no argument constructor', () {
        expect(range(), []);
      });
      test('1 argument constructor', () {
        expect(range(0), []);
        expect(range(1), [0]);
        expect(range(2), [0, 1]);
        expect(range(3), [0, 1, 2]);
      });
      test('2 argument constructor', () {
        expect(range(0, 4), [0, 1, 2, 3]);
        expect(range(5, 9), [5, 6, 7, 8]);
      });
      test('3 argument constructor', () {
        expect(range(2, 8, 2), [2, 4, 6]);
        expect(range(3, 8, 2), [3, 5, 7]);
        expect(range(4, 8, 2), [4, 6]);
        expect(range(2, 7, 2), [2, 4, 6]);
        expect(range(2, 6, 2), [2, 4]);
      });
      test('3 argument constructor (negative step)', () {
        expect(range(8, 2, -2), [8, 6, 4]);
        expect(range(8, 3, -2), [8, 6, 4]);
        expect(range(8, 4, -2), [8, 6]);
        expect(range(7, 2, -2), [7, 5, 3]);
        expect(range(6, 2, -2), [6, 4]);
      });
      test('printing', () {
        expect(range().toString(), 'range()');
        expect(range(1).toString(), 'range(1)');
        expect(range(1, 2).toString(), 'range(1, 2)');
        expect(range(1, 5, 2).toString(), 'range(1, 5, 2)');
      });
      test('double range', () {
        expect(range(1.5, 4.0), [1.5, 2.5, 3.5]);
        expect(range(1.5, 1.8, 0.1), [1.5, 1.6, 1.7]);
        expect(range(1.5, 1.8, 0.2), [1.5, 1.7]);
      });
      test('unmodifiable', () {
        var list = range(1, 5);
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
        expect(() => list.retainWhere((value) => false), throwsUnsupportedError);
        expect(() => list.setAll(2, [5, 6]), throwsUnsupportedError);
        expect(() => list.setRange(2, 4, [5, 6]), throwsUnsupportedError);
        expect(() => list.sort(), throwsUnsupportedError);
      });
    });

    group('string', () {
      group('immutable', () {
        var empty = string('');
        var plenty = string('More Dart');
        test('creating', () {
          var coerced = string(123);
          expect(coerced.length, 3);
          expect(coerced.toString(), '123');
        });
        test('isEmtpy', () {
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
          expect(empty.toSet(), new Set());
          expect(plenty.toSet(), new Set.from(['M', 'o', 'r', 'e', ' ', 'D', 'a', 't']));
          expect(empty.toString(), '');
          expect(plenty.toString(), 'More Dart');
        });
        test('read-only', () {
          expect(() => plenty[0] = 'a', throwsUnsupportedError);
          expect(() => plenty.length = 10, throwsUnsupportedError);
          expect(() => plenty.add('a'), throwsUnsupportedError);
          expect(() => plenty.remove('a'), throwsUnsupportedError);
        });
      });
      group('mutable', () {
        var empty = mutableString('');
        var plenty = mutableString('More Dart');
        test('creating', () {
          var coerced = mutableString(123);
          expect(coerced.length, 3);
          expect(coerced.toString(), '123');
        });
        test('isEmtpy', () {
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
          var mutable = mutableString('abc');
          mutable[1] = 'd';
          expect(mutable.toString(), 'adc');
        });
        test('writing (range error)', () {
          expect(() => empty[0] = 'a', throwsRangeError);
          expect(() => plenty[-1] = 'a', throwsRangeError);
          expect(() => plenty[9] = 'a', throwsRangeError);
        });
        test('adding', () {
          var mutable = mutableString('abc');
          mutable.add('d');
          expect(mutable.toString(), 'abcd');
        });
        test('removing', () {
          var mutable = mutableString('abc');
          mutable.remove('a');
          expect(mutable.toString(), 'bc');
        });
        test('converting', () {
          expect(empty.toList(), []);
          expect(plenty.toList(), ['M', 'o', 'r', 'e', ' ', 'D', 'a', 'r', 't']);
          expect(empty.toSet(), new Set());
          expect(plenty.toSet(), new Set.from(['M', 'o', 'r', 'e', ' ', 'D', 'a', 't']));
          expect(empty.toString(), '');
          expect(plenty.toString(), 'More Dart');
        });
      });
    });
  });
}
