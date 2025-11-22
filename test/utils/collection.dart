import 'dart:math';

import 'package:test/test.dart';

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
