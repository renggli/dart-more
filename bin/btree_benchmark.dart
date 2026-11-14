import 'dart:collection' show SplayTreeMap;
import 'dart:io';
import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/comparator.dart';

import 'utils/benchmark.dart';

void main() {
  final results = [
    for (final size in [1000, 10000]) ..._runSuite(size),
  ];
  printReport(results, reference: 'BTreeMap');
  stdout.writeln(
    '\n(Ratios > 1.0x mean BTreeMap is faster than the compared structure.)',
  );
}

List<(String, Map<String, double>)> _runSuite(int size) {
  final random = Random(42);
  final keys = List<int>.generate(size, (i) => i)..shuffle(random);
  final queryKeys = List<int>.generate(200, (_) => random.nextInt(size));
  final queryIndices = List<int>.generate(200, (_) => random.nextInt(size));

  final btree = BTreeMap<int, int>();
  final splay = SplayTreeMap<int, int>();
  final sorted = SortedList<int>();
  final list = <int>[];
  for (final k in keys) {
    btree[k] = k;
    splay[k] = k;
    sorted.add(k);
    list.add(k);
  }

  final rangeMin = (size * 0.45).round();
  final rangeMax = (size * 0.55).round();

  return [
    (
      'build ($size)',
      {
        'BTreeMap': benchmark(() {
          final m = BTreeMap<int, int>();
          for (final k in keys) {
            m[k] = k;
          }
        }),
        'SplayTreeMap': benchmark(() {
          final m = SplayTreeMap<int, int>();
          for (final k in keys) {
            m[k] = k;
          }
        }),
        'SortedList': benchmark(() {
          final l = SortedList<int>();
          for (final k in keys) {
            l.add(k);
          }
        }),
        'List': benchmark(() {
          final l = <int>[];
          for (final k in keys) {
            l.add(k);
          }
        }),
      },
    ),
    (
      'lookup 200x ($size)',
      {
        'BTreeMap': benchmark(
          () => queryKeys.fold<int>(0, (s, k) => s + btree[k]!),
        ),
        'SplayTreeMap': benchmark(
          () => queryKeys.fold<int>(0, (s, k) => s + splay[k]!),
        ),
        'SortedList': benchmark(() => queryKeys.where(sorted.contains).length),
        'List': benchmark(() => queryKeys.where(list.contains).length),
      },
    ),
    (
      'insert/remove 200x ($size)',
      {
        'BTreeMap': benchmark(() {
          for (final k in queryKeys) {
            btree.remove(k);
            btree[k] = k;
          }
        }),
        'SplayTreeMap': benchmark(() {
          for (final k in queryKeys) {
            splay.remove(k);
            splay[k] = k;
          }
        }),
        'SortedList': benchmark(() {
          for (final k in queryKeys) {
            sorted.remove(k);
            sorted.add(k);
          }
        }),
        'List': benchmark(() {
          for (final k in queryKeys) {
            list.remove(k);
            list.add(k);
          }
        }),
      },
    ),
    (
      'keyAt 200x ($size)',
      {
        'BTreeMap': benchmark(
          () => queryIndices.fold<int>(0, (s, i) => s + btree.keyAt(i)),
        ),
        'SplayTreeMap': benchmark(
          () =>
              queryIndices.fold<int>(0, (s, i) => s + splay.keys.elementAt(i)),
        ),
        'SortedList': benchmark(
          () => queryIndices.fold<int>(0, (s, i) => s + sorted[i]),
        ),
        'List': benchmark(
          () => queryIndices.fold<int>(0, (s, i) => s + list[i]),
        ),
      },
    ),
    (
      'indexOf 200x ($size)',
      {
        'BTreeMap': benchmark(
          () => queryKeys.fold<int>(0, (s, k) => s + btree.indexOfKey(k)),
        ),
        'SplayTreeMap': benchmark(
          () => queryKeys.fold<int>(
            0,
            (s, k) => s + splay.keys.takeWhile((e) => e < k).length,
          ),
        ),
        'SortedList': benchmark(
          () => queryKeys.fold<int>(0, (s, k) => s + sorted.indexOf(k)),
        ),
        'List': benchmark(
          () => queryKeys.fold<int>(0, (s, k) => s + list.indexOf(k)),
        ),
      },
    ),
    (
      'range 10% ($size)',
      {
        'BTreeMap': benchmark(
          () => btree
              .keysInRange(min: rangeMin, max: rangeMax)
              .fold<int>(0, (s, k) => s + k),
        ),
        'SplayTreeMap': benchmark(() {
          var sum = 0;
          for (
            var k = splay.firstKeyAfter(rangeMin - 1);
            k != null && k <= rangeMax;
            k = splay.firstKeyAfter(k)
          ) {
            sum += k;
          }
          if (sum < 0) throw StateError('unreachable');
        }),
        'SortedList': benchmark(() {
          var sum = 0;
          final start = sorted.comparator.binarySearchLower(sorted, rangeMin);
          for (var i = start; i < sorted.length && sorted[i] <= rangeMax; i++) {
            sum += sorted[i];
          }
          if (sum < 0) throw StateError('unreachable');
        }),
        'List': benchmark(
          () => list
              .where((k) => k >= rangeMin && k <= rangeMax)
              .fold<int>(0, (s, k) => s + k),
        ),
      },
    ),
    (
      'iterate ($size)',
      {
        'BTreeMap': benchmark(() => btree.keys.fold<int>(0, (s, k) => s + k)),
        'SplayTreeMap': benchmark(
          () => splay.keys.fold<int>(0, (s, k) => s + k),
        ),
        'SortedList': benchmark(() => sorted.fold<int>(0, (s, k) => s + k)),
        'List': benchmark(() => list.fold<int>(0, (s, k) => s + k)),
      },
    ),
  ];
}
