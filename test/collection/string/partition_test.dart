import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('partition', () {
    final regexp = RegExp(r',+');

    group('partition', () {
      test('string', () {
        check('123,456,789'.partition(',')).deepEquals(['123', ',', '456,789']);
        check('123;456;789'.partition(',')).deepEquals(['123;456;789', '', '']);
      });
      test('regexp', () {
        check('123,,456,,789'.partition(regexp))
            .deepEquals(['123', ',,', '456,,789']);
        check('123;;456;;789'.partition(regexp))
            .deepEquals(['123;;456;;789', '', '']);
      });
      test('start', () {
        check('123,456,789'.partition(',', 3))
            .deepEquals(['123', ',', '456,789']);
        check('123,456,789'.partition(',', 6))
            .deepEquals(['123,456', ',', '789']);
        check('123,456,789'.partition(',', 9))
            .deepEquals(['123,456,789', '', '']);
      });
    });

    group('last partition', () {
      test('string', () {
        check('123,456,789'.lastPartition(','))
            .deepEquals(['123,456', ',', '789']);
        check('123;456;789'.lastPartition(','))
            .deepEquals(['', '', '123;456;789']);
      });
      test('regexp', () {
        check('123,,456,,789'.lastPartition(regexp))
            .deepEquals(['123,,456,', ',', '789']);
        check('123;;456;;789'.lastPartition(regexp))
            .deepEquals(['', '', '123;;456;;789']);
      });
      test('start', () {
        check('123,456,789'.lastPartition(',', 2))
            .deepEquals(['', '', '123,456,789']);
        check('123,456,789'.lastPartition(',', 5))
            .deepEquals(['123', ',', '456,789']);
        check('123,456,789'.lastPartition(',', 7))
            .deepEquals(['123,456', ',', '789']);
      });
    });
  });
}
