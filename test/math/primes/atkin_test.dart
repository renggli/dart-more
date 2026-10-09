import 'package:more/math.dart';
import 'package:test/scaffolding.dart';

import 'sieve_test_utils.dart';

void main() {
  group('AtkinPrimeSieve', () {
    primeSieveTests(AtkinPrimeSieve.new);
  });
}
