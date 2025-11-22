// ignore_for_file: deprecated_member_use_from_same_package, unnecessary_lambdas, collection_methods_unrelated_type

import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/math.dart';
import 'package:test/test.dart';

import '../utils/collection.dart';

void main() {
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
          final list = BitList.of(randomBooleans(744, 500), growable: growable);
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
}
