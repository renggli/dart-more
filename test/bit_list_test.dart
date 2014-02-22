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
}
