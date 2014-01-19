// Copyright (c) 2013, Lukas Renggli <renggli@gmail.com>

library bit_list_test;

import 'dart:math';
import 'package:unittest/unittest.dart';
import 'package:more/bit_list.dart';

List<bool> randomList(int seed, int length) {
  var list = new List();
  var generator = new Random(seed);
  for (var i = 0; i < length; i++) {
    list.add(generator.nextBool());
  }
  return list;
}

void main() {
  group('bitlist', () {
    group('construction', () {
      test('empty', () {
        var list = new BitList(0);
        expect(list, isEmpty);
        expect(list, []);
      });
      test('tiny', () {
        var list = new BitList(1);
        expect(list, isNot(isEmpty));
        expect(list, hasLength(1));
        expect(list, [false]);
        list[0] = true;
        expect(list, [true]);
        list[0] = false;
        expect(list, [false]);
      });
      test('long', () {
        var target = new BitList(100);
        expect(target, hasLength(100));
        for (var i = 0; i < 100; i++) {
          var source = randomList(311 * i, target.length);
          for (var j = 0; j < source.length; j++) {
            target[j] = source[j];
          }
          for (var j = 0; j < source.length; j++) {
            expect(source[j], target[j]);
          }
        }
      });
      test('convert', () {
        for (var len = 0; len < 100; len++) {
          var source = randomList(457 * len, len);
          var target = new BitList.fromList(source);
          expect(source, target);
          expect(source, target.toList());
          expect(source, new BitList.fromList(target));
        }
      });
    });
    group('accessors', () {
      test('reading', () {
        for (var i = 0; i < 100; i++) {
          var list = new BitList(i);
          expect(() => list[-1], throwsRangeError);
          for (var j = 0; j < i; j++) {
            expect(() => list[j], returnsNormally);
          }
          expect(() => list[i], throwsRangeError);
        }
      });
      test('writing', () {
        for (var i = 0; i < 100; i++) {
          var list = new BitList(i);
          expect(() => list[-1] = true, throwsRangeError);
          for (var j = 0; j < i; j++) {
            expect(() => list[j] = true, returnsNormally);
          }
          expect(() => list[i] = true, throwsRangeError);
        }
      });
      test('flipping', () {
        var source = new BitList.fromList(randomList(927, 100));
        var target = ~source;
        for (var i = 0; i < source.length; i++) {
          var before = source[i];
          source.flip(i);
          expect(!before, source[i]);
        }
        expect(target, source);
      });
      test('counting', () {
        for (var len = 0; len < 100; len++) {
          var list = new BitList.fromList(randomList(823 * len, len));
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
        var source = new BitList.fromList(randomList(702, 100));
        var target = ~source;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], !source[i]);
        }
      });
      test('intersection', () {
        var source1 = new BitList.fromList(randomList(439, 100));
        var source2 = new BitList.fromList(randomList(902, 100));
        var target = source1 & source2;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], source1[i] && source2[i]);
        }
        expect(target, source2 & source1);
      });
      test('union', () {
        var source1 = new BitList.fromList(randomList(817, 100));
        var source2 = new BitList.fromList(randomList(858, 100));
        var target = source1 | source2;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], source1[i] || source2[i]);
        }
        expect(target, source2 | source1);
      });
      test('difference', () {
        var source1 = new BitList.fromList(randomList(364, 100));
        var source2 = new BitList.fromList(randomList(243, 100));
        var target = source1 - source2;
        for (var i = 0; i < target.length; i++) {
          expect(target[i], source1[i] && !source2[i]);
        }
        expect(target, source1 & ~source2);
      });
      test('shift-left', () {
        for (var len = 0; len < 100; len++) {
          var source = new BitList.fromList(randomList(836 * len, len));
          for (var shift = 0; shift <= len + 10; shift++) {
            var target = source << shift;
            if (shift == 0) {
              expect(target, source);
            } else if (shift >= len) {
              expect(target.any((x) => x), isFalse);
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
          var source = new BitList.fromList(randomList(963 * len, len));
          for (var shift = 0; shift <= len + 10; shift++) {
            var target = source >> shift;
            if (shift == 0) {
              expect(target, source);
            } else if (shift >= len) {
              expect(target.any((x) => x), isFalse);
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
}