// AUTO-GENERATED CODE: DO NOT EDIT

import 'package:checks/checks.dart';
import 'package:more/functional.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('identity', () {
    check(identityFunction(42)).equals(42);
    check(identityFunction('foo')).equals('foo');
  });
}
