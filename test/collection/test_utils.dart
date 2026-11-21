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

Condition<MapEntry<K, V>> isMapEntry<K, V>(K key, V value) => .it()
  ..has('key', (e) => e.key).equals(key)
  ..has('value', (e) => e.value).equals(value);

extension MapEntryChecks<K, V> on Subject<MapEntry<K, V>> {
  Subject<K> get key => has('key', (e) => e.key);
  Subject<V> get value => has('value', (e) => e.value);
}

extension MapEntryIterableChecks<K, V> on Subject<Iterable<MapEntry<K, V>>> {
  void matchesEntries(Iterable<(K, V)> expected) => has(
    'entries',
    (it) => it.map((e) => (e.key, e.value)),
  ).deepEquals(expected);
}

extension MultimapChecks<K, V, VS extends Iterable<V>>
    on Subject<Multimap<K, V, VS>> {
  Subject<int> get length => has('length', (m) => m.length);
  void get isEmpty => has('isEmpty', (m) => m.isEmpty).isTrue;
  void get isNotEmpty => has('isNotEmpty', (m) => m.isNotEmpty).isTrue;
}

extension SetIterableChecks<T> on Subject<Iterable<Iterable<T>>> {
  void unorderedSets(Iterable<Iterable<T>> expected) {
    unorderedMatches(
      expected.map<Condition<Iterable<T>>>(
        (set) => .it()..unorderedEquals(set),
      ),
    );
  }
}
