import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  for (final growable in [false, true]) {
    group(growable ? 'growable' : 'fixed-length', () {
      group('construction', () {
        test('default', () {
          for (var len = 1; len < 100; len++) {
            final target = BitList(len, growable: growable);
            check(target).isNotEmpty();
            check(target).length.equals(len);
            check(target).every((it) => it.isFalse());
          }
        });
        test('empty', () {
          final target = BitList.empty(growable: growable);
          check(target).isEmpty();
          check(target).length.equals(0);
        });
        test('filled (false)', () {
          for (var len = 1; len < 100; len++) {
            final target = BitList.filled(len, false, growable: growable);
            check(target).isNotEmpty();
            check(target).length.equals(len);
            check(target).every((it) => it.isFalse());
          }
        });
        test('filled (true)', () {
          for (var len = 1; len < 100; len++) {
            final target = BitList.filled(len, true, growable: growable);
            check(target).isNotEmpty();
            check(target).length.equals(len);
            check(target).every((it) => it.isTrue());
          }
        });
        test('from', () {
          for (var len = 0; len < 100; len++) {
            final source = List<bool>.of(randomBooleans(457 * len, len));
            final target = BitList.from(source, growable: growable);
            check(target).deepEquals(source);
            check(target.toList()).deepEquals(source);
          }
        });
        test('of', () {
          for (var len = 0; len < 100; len++) {
            final source = List<bool>.of(randomBooleans(447 * len, len));
            final target = BitList.of(source, growable: growable);
            check(target).deepEquals(source);
            check(target.toList()).deepEquals(source);
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
            check(target).deepEquals(source);
            check(target.toList()).deepEquals(source);
          }
        });
        test('of Set', () {
          for (var len = 0; len < 100; len++) {
            final source = Set<bool>.of(randomBooleans(827 * len, len));
            final target = BitList.of(source, growable: growable);
            check(target).unorderedEquals(source);
            check(target.toSet()).deepEquals(source);
          }
        });

        test('of BitList', () {
          for (var len = 0; len < 100; len++) {
            final source = BitList.of(randomBooleans(287 * len, len));
            final target = BitList.of(source, growable: growable);
            check(target).deepEquals(source);
            check(source).deepEquals(target);
          }
        });
        test('of growable BitList with excess capacity', () {
          final source = BitList.empty(growable: true);
          for (var i = 0; i < 70; i++) {
            source.add(i.isEven);
          }
          final target = BitList.of(source, growable: growable);
          check(target).deepEquals(source);
          check(target).length.equals(70);
        });
        test('converter', () {
          for (var len = 0; len < 10; len++) {
            final source = randomBooleans(195 * len, len);
            final target = source.toBitList(growable: growable);
            check(target).deepEquals(source);
            check(source).deepEquals(target);
          }
        });
      });
      group('accessors', () {
        test('reading', () {
          for (var len = 0; len < 100; len++) {
            final source = randomBooleans(135 * len, len);
            final target = BitList.of(source, growable: growable);
            check(() => target[-1]).throws<RangeError>();
            for (var i = 0; i < len; i++) {
              check(target[i]).equals(source[i]);
            }
            check(() => target[len]).throws<RangeError>();
          }
        });
        test('writing', () {
          for (var len = 0; len < 100; len++) {
            final source = randomBooleans(396 * len, len);
            final target = BitList(len, growable: growable);
            check(() => target[-1] = true).throws<RangeError>();
            for (var i = 0; i < len; i++) {
              target[i] = source[i];
              check(target.sublist(0, i)).deepEquals(source.sublist(0, i));
              check(target.sublist(i + 1)).every((it) => it.isFalse());
            }
            check(() => target[len] = true).throws<RangeError>();
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
              check(source.getUnchecked(i)).equals(expected);
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
              check(source.getUnchecked(i)).equals(expected);
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
            check(() => target.flip(-1)).throws<RangeError>();
            for (var i = 0; i < len; i++) {
              final before = source[i];
              source.flip(i);
              check(source[i]).equals(!before);
            }
            check(() => target.flip(len)).throws<RangeError>();
            check(target).deepEquals(source);
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
            check(trueCount + falseCount).equals(list.length);
            check(trueCount).equals(list.where((b) => b == true).length);
            check(falseCount).equals(list.where((b) => b == false).length);
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
            check(trueCount + falseCount).equals(endIndex - startIndex);
            final range = list.getRange(startIndex, endIndex);
            check(trueCount).equals(range.where((b) => b == true).length);
            check(falseCount).equals(range.where((b) => b == false).length);
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
            check(trueSet.length).equals(trueList.length);
            check(falseSet.length).equals(falseList.length);
            check(trueSet.union(falseSet).length).equals(list.length);
            for (final trueIndex in trueSet) {
              check(list[trueIndex]).isTrue();
            }
            for (final falseIndex in falseSet) {
              check(list[falseIndex]).isFalse();
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
              check(target.length).equals(len1 + len2);
              for (var i = 0; i < len1 + len2; i++) {
                check(target[i])
                    .equals(i < len1 ? source1[i] : source2[i - len1]);
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
              check(target[i]).equals(!source[i]);
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
              check(target[i]).equals(!source[i]);
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
              check(target[i]).equals(source1[i] && source2[i]);
            }
            check(target).deepEquals(source2 & source1);
            final other = BitList(99);
            check(() => other & source1).throws<ArgumentError>();
            check(() => source1 & other).throws<ArgumentError>();
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
              check(target[i]).equals(source1[i] && source2[i]);
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
              check(target[i]).equals(source1[i] || source2[i]);
            }
            check(target).deepEquals(source2 | source1);
            final other = BitList(99);
            check(() => other | source1).throws<ArgumentError>();
            check(() => source1 | other).throws<ArgumentError>();
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
              check(target[i]).equals(source1[i] || source2[i]);
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
            check(target[i]).equals(source1[i] && !source2[i]);
          }
          check(target).deepEquals(source1 & ~source2);
          final other = BitList(99, growable: growable);
          check(() => other - source1).throws<ArgumentError>();
          check(() => source1 - other).throws<ArgumentError>();
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
                check(target).deepEquals(source);
              } else if (shift >= len) {
                check(target).every((it) => it.isFalse());
              } else {
                for (var i = shift; i < source.length; i++) {
                  check(target[i]).equals(source[i - shift]);
                }
              }
            }
            check(() => source << -1).throws<ArgumentError>();
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
                check(target).deepEquals(source);
              } else if (shift >= len) {
                check(target).every((it) => it.isFalse());
              } else {
                for (var i = 0; i < source.length - shift; i++) {
                  check(target[i]).equals(source[i + shift]);
                }
              }
            }
            check(() => source >> -1).throws<ArgumentError>();
          }
        });
      });
      if (growable) {
        test('add', () {
          final source = randomBooleans(325, 500);
          final target = BitList.empty(growable: growable);
          for (var i = 0; i < source.length; i++) {
            target.add(source[i]);
            check(target).deepEquals(source.getRange(0, i + 1));
          }
        });
        test('addAdd', () {
          final generator = Random(532);
          final source = randomBooleans(638, 2500);
          final target = BitList.empty(growable: growable);
          for (var start = 0; start < source.length;) {
            final end = min(source.length, start + generator.nextInt(25));
            target.addAll(source.getRange(start, end));
            check(target).deepEquals(source.getRange(0, end));
            start = end;
          }
        });
        test('clear', () {
          final target = BitList.filled(2500, true, growable: growable);
          target.clear();
          check(target).isEmpty();
        });
        test('length', () {
          final target = BitList.filled(100, false, growable: growable);
          final buffer = target.buffer;
          target.length += 1;
          check(target.buffer).identicalTo(buffer);
          target.length -= 2;
          check(target.buffer).identicalTo(buffer);
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
              check(target[i]).isTrue();
            }
            for (var i = smaller; i < larger; i++) {
              check(target[i]).isFalse();
            }
          }
        });
        test('removeLast', () {
          final source = randomBooleans(453, 500);
          final target = BitList.of(source, growable: growable);
          for (var i = source.length - 1; i >= 0; i--) {
            check(target.removeLast()).equals(source[i]);
            check(target).deepEquals(source.getRange(0, i));
          }
        });
      } else {
        test('unsupported operations', () {
          final list = BitList(32, growable: growable);
          check(() => list.add(false)).throws<UnsupportedError>();
          check(() => list.addAll([true, false])).throws<UnsupportedError>();
          check(list.clear).throws<UnsupportedError>();
          check(() => list.insert(2, true)).throws<UnsupportedError>();
          check(() => list.insertAll(2, [true, false]))
              .throws<UnsupportedError>();
          check(() => list.length = 10).throws<UnsupportedError>();
          check(() => list.remove(true)).throws<UnsupportedError>();
          check(() => list.removeAt(2)).throws<UnsupportedError>();
          check(list.removeLast).throws<UnsupportedError>();
          check(() => list.removeRange(2, 4)).throws<UnsupportedError>();
          check(() => list.removeWhere((value) => true))
              .throws<UnsupportedError>();
          check(() => list.replaceRange(2, 4, [true, false]))
              .throws<UnsupportedError>();
          check(() => list.retainWhere((value) => false))
              .throws<UnsupportedError>();
        });
      }
    });
  }
}
