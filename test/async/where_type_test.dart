import 'package:checks/checks.dart';
import 'package:more/async.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('whereType', () {
    final input = ['foo', 32, 42, 'bar', #symbol];
    test('<int>', () async {
      final stream = Stream.fromIterable(input);
      check(await stream.whereType<int>().toList()).deepEquals([32, 42]);
    });
    test('<String>', () async {
      final stream = Stream.fromIterable(input);
      check(await stream.whereType<String>().toList())
          .deepEquals(['foo', 'bar']);
    });
    test('<Symbol>', () async {
      final stream = Stream.fromIterable(input);
      check(await stream.whereType<Symbol>().toList()).deepEquals([#symbol]);
    });
    test('<void>', () async {
      final stream = Stream.fromIterable(input);
      check(await stream.whereType<void>().toList()).deepEquals(input);
    });
    test('<bool>', () async {
      final stream = Stream.fromIterable(input);
      check(await stream.whereType<bool>().toList()).isEmpty();
    });
  });
}
