import 'dart:async';

import 'package:checks/checks.dart';
import 'package:more/cache.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('loader', () {
    test('sync loader', () {
      String syncLoader(int key) => 'value_$key';
      check(syncLoader).isA<Loader<int, String>>();
      check(syncLoader(42)).equals('value_42');
    });
    test('async loader', () async {
      Future<String> asyncLoader(int key) async => 'value_$key';
      check(asyncLoader).isA<Loader<int, String>>();
      check(await asyncLoader(42)).equals('value_42');
    });
  });
}
