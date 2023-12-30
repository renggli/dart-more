import 'package:more/interval.dart';
import 'package:test/test.dart';

void main() {
  group('interval', () {
    final interval3to5 = Interval<num>(3, 5);
    final interval4to7 = Interval<num>(4, 7);
    final interval6to9 = Interval<num>(6, 9);
    final interval5to5 = Interval<num>(5);
    test('lower', () {
      expect(interval3to5.lower, 3);
      expect(interval4to7.lower, 4);
      expect(interval5to5.lower, 5);
    });
    test('upper', () {
      expect(interval3to5.upper, 5);
      expect(interval4to7.upper, 7);
      expect(interval5to5.upper, 5);
    });
    test('isSingle', () {
      expect(interval3to5.isSingle, isFalse);
      expect(interval4to7.isSingle, isFalse);
      expect(interval5to5.isSingle, isTrue);
    });
    test('contains', () {
      expect(interval3to5.contains(2), isFalse);
      expect(interval3to5.contains(3), isTrue);
      expect(interval3to5.contains(4), isTrue);
      expect(interval3to5.contains(5), isTrue);
      expect(interval3to5.contains(6), isFalse);
      expect(interval5to5.contains(4), isFalse);
      expect(interval5to5.contains(5), isTrue);
      expect(interval5to5.contains(6), isFalse);
    });
    test('hasIntersection', () {
      expect(interval3to5.hasIntersection(interval3to5), isTrue);
      expect(interval3to5.hasIntersection(interval4to7), isTrue);
      expect(interval3to5.hasIntersection(interval6to9), isFalse);
      expect(interval3to5.hasIntersection(interval5to5), isTrue);
      expect(interval4to7.hasIntersection(interval3to5), isTrue);
      expect(interval4to7.hasIntersection(interval4to7), isTrue);
      expect(interval4to7.hasIntersection(interval6to9), isTrue);
      expect(interval4to7.hasIntersection(interval5to5), isTrue);
      expect(interval6to9.hasIntersection(interval3to5), isFalse);
      expect(interval6to9.hasIntersection(interval4to7), isTrue);
      expect(interval6to9.hasIntersection(interval6to9), isTrue);
      expect(interval6to9.hasIntersection(interval5to5), isFalse);
      expect(interval5to5.hasIntersection(interval3to5), isTrue);
      expect(interval5to5.hasIntersection(interval4to7), isTrue);
      expect(interval5to5.hasIntersection(interval6to9), isFalse);
      expect(interval5to5.hasIntersection(interval5to5), isTrue);
    });
    test('intersection', () {
      expect(interval3to5.intersection(interval3to5), interval3to5);
      expect(interval3to5.intersection(interval4to7), Interval<num>(4, 5));
      expect(interval3to5.intersection(interval6to9), isNull);
      expect(interval3to5.intersection(interval5to5), interval5to5);
      expect(interval4to7.intersection(interval3to5), Interval<num>(4, 5));
      expect(interval4to7.intersection(interval4to7), interval4to7);
      expect(interval4to7.intersection(interval6to9), Interval<num>(6, 7));
      expect(interval4to7.intersection(interval5to5), interval5to5);
      expect(interval6to9.intersection(interval3to5), isNull);
      expect(interval6to9.intersection(interval4to7), Interval<num>(6, 7));
      expect(interval6to9.intersection(interval6to9), interval6to9);
      expect(interval6to9.intersection(interval5to5), isNull);
      expect(interval5to5.intersection(interval3to5), interval5to5);
      expect(interval5to5.intersection(interval4to7), interval5to5);
      expect(interval5to5.intersection(interval6to9), isNull);
      expect(interval5to5.intersection(interval5to5), interval5to5);
    });
    test('union', () {
      expect(interval3to5.union(interval3to5), interval3to5);
      expect(interval3to5.union(interval4to7), Interval<num>(3, 7));
      expect(interval3to5.union(interval6to9), Interval<num>(3, 9));
      expect(interval3to5.union(interval5to5), interval3to5);
      expect(interval4to7.union(interval3to5), Interval<num>(3, 7));
      expect(interval4to7.union(interval4to7), interval4to7);
      expect(interval4to7.union(interval6to9), Interval<num>(4, 9));
      expect(interval4to7.union(interval5to5), Interval<num>(4, 7));
      expect(interval6to9.union(interval3to5), Interval<num>(3, 9));
      expect(interval6to9.union(interval4to7), Interval<num>(4, 9));
      expect(interval6to9.union(interval6to9), interval6to9);
      expect(interval6to9.union(interval5to5), Interval<num>(5, 9));
      expect(interval5to5.union(interval3to5), Interval<num>(3, 5));
      expect(interval5to5.union(interval4to7), interval4to7);
      expect(interval5to5.union(interval6to9), Interval<num>(5, 9));
      expect(interval5to5.union(interval5to5), interval5to5);
    });
    test('equals', () {
      expect(interval3to5 == interval3to5, isTrue);
      expect(interval3to5 == interval4to7, isFalse);
      expect(interval3to5 == interval6to9, isFalse);
      expect(interval3to5 == interval5to5, isFalse);
      expect(interval4to7 == interval3to5, isFalse);
      expect(interval4to7 == interval4to7, isTrue);
      expect(interval4to7 == interval6to9, isFalse);
      expect(interval4to7 == interval5to5, isFalse);
      expect(interval6to9 == interval3to5, isFalse);
      expect(interval6to9 == interval4to7, isFalse);
      expect(interval6to9 == interval6to9, isTrue);
      expect(interval6to9 == interval5to5, isFalse);
      expect(interval5to5 == interval3to5, isFalse);
      expect(interval5to5 == interval4to7, isFalse);
      expect(interval5to5 == interval6to9, isFalse);
      expect(interval5to5 == interval5to5, isTrue);
    });
    test('hashCode', () {
      expect(interval3to5.hashCode == interval3to5.hashCode, isTrue);
      expect(interval3to5.hashCode == interval4to7.hashCode, isFalse);
      expect(interval3to5.hashCode == interval6to9.hashCode, isFalse);
      expect(interval3to5.hashCode == interval5to5.hashCode, isFalse);
      expect(interval4to7.hashCode == interval3to5.hashCode, isFalse);
      expect(interval4to7.hashCode == interval4to7.hashCode, isTrue);
      expect(interval4to7.hashCode == interval6to9.hashCode, isFalse);
      expect(interval4to7.hashCode == interval5to5.hashCode, isFalse);
      expect(interval6to9.hashCode == interval3to5.hashCode, isFalse);
      expect(interval6to9.hashCode == interval4to7.hashCode, isFalse);
      expect(interval6to9.hashCode == interval6to9.hashCode, isTrue);
      expect(interval6to9.hashCode == interval5to5.hashCode, isFalse);
      expect(interval5to5.hashCode == interval3to5.hashCode, isFalse);
      expect(interval5to5.hashCode == interval4to7.hashCode, isFalse);
      expect(interval5to5.hashCode == interval6to9.hashCode, isFalse);
      expect(interval5to5.hashCode == interval5to5.hashCode, isTrue);
    });
    test('toString', () {
      expect(interval3to5.toString(), '3..5');
      expect(interval4to7.toString(), '4..7');
      expect(interval6to9.toString(), '6..9');
      expect(interval5to5.toString(), '5');
    });
  });
}
