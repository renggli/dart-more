import 'dart:math';

import 'package:checks/checks.dart';
import 'package:more/src/collection/multimap.dart';

List<bool> randomBooleans(int seed, int length) {
  final list = <bool>[];
  final generator = Random(seed);
  for (var i = 0; i < length; i++) {
    list.add(generator.nextBool());
  }
  return list;
}

String joiner(List<String> input) => input.join('');

Condition<MapEntry<K, V>> isMapEntry<K, V>(K key, V value) =>
    (entry) => entry
      ..has((e) => e.key, 'key').equals(key)
      ..has((e) => e.value, 'value').equals(value);

extension MapEntryChecks<K, V> on Subject<MapEntry<K, V>> {
  Subject<K> get key => has((e) => e.key, 'key');
  Subject<V> get value => has((e) => e.value, 'value');
}

extension MapEntryIterableChecks<K, V> on Subject<Iterable<MapEntry<K, V>>> {
  void matchesEntries(Iterable<(K, V)> expected) => has(
    (it) => it.map((e) => (e.key, e.value)),
    'entries',
  ).deepEquals(expected);
}

extension MultimapChecks<K, V, VS extends Iterable<V>>
    on Subject<Multimap<K, V, VS>> {
  Subject<int> get length => has((m) => m.length, 'length');
  void isEmpty() => has((m) => m.isEmpty, 'isEmpty').isTrue();
  void isNotEmpty() => has((m) => m.isNotEmpty, 'isNotEmpty').isTrue();
}

extension SetIterableChecks<T> on Subject<Iterable<Iterable<T>>> {
  void unorderedSets(Iterable<Iterable<T>> expected) {
    unorderedMatches(
      expected.map(
        (set) =>
            (Subject<Iterable<T>> it) => it.unorderedEquals(set),
      ),
    );
  }
}
