import 'dart:math';

import 'package:more/collection.dart';
import 'package:more/interval.dart';
import 'package:test/test.dart';

final composers = [
  (name: 'Carl Orff', lifetime: Interval<num>(1895, 1982)),
  (name: 'Aaron Copland', lifetime: Interval<num>(1900, 1990)),
  (name: 'Antonio Salieri', lifetime: Interval<num>(1750, 1825)),
  (name: 'Antonio Vivaldi', lifetime: Interval<num>(1678, 1741)),
  (name: 'Antonín Dvořák', lifetime: Interval<num>(1841, 1904)),
  (name: 'Bedřich Smetana', lifetime: Interval<num>(1824, 1884)),
  (name: 'Benjamin Britten', lifetime: Interval<num>(1913, 1976)),
  (name: 'Camille Saint-Saëns', lifetime: Interval<num>(1835, 1921)),
  (name: 'Claude Debussy', lifetime: Interval<num>(1862, 1918)),
  (name: 'Claudio Monteverdi', lifetime: Interval<num>(1567, 1643)),
  (name: 'Dmitri Shostakovich', lifetime: Interval<num>(1906, 1975)),
  (name: 'Edward Elgar', lifetime: Interval<num>(1857, 1934)),
  (name: 'Felix Mendelssohn', lifetime: Interval<num>(1809, 1847)),
  (name: 'Franz Joseph Haydn', lifetime: Interval<num>(1732, 1809)),
  (name: 'Franz Liszt', lifetime: Interval<num>(1811, 1886)),
  (name: 'Franz Schubert', lifetime: Interval<num>(1797, 1828)),
  (name: 'Frederic Chopin', lifetime: Interval<num>(1810, 1849)),
  (name: 'George Frideric Handel', lifetime: Interval<num>(1685, 1759)),
  (name: 'George Gershwin', lifetime: Interval<num>(1898, 1937)),
  (name: 'Giuseppe Verdi', lifetime: Interval<num>(1813, 1901)),
  (name: 'Gustav Mahler', lifetime: Interval<num>(1860, 1911)),
  (name: 'Henry Purcell', lifetime: Interval<num>(1659, 1695)),
  (name: 'Igor Stravinsky', lifetime: Interval<num>(1882, 1971)),
  (name: 'Jean Sibelius', lifetime: Interval<num>(1865, 1957)),
  (name: 'Jean-Philippe Rameau', lifetime: Interval<num>(1683, 1764)),
  (name: 'Johann Sebastian Bach', lifetime: Interval<num>(1685, 1750)),
  (name: 'Johann Strauss II', lifetime: Interval<num>(1825, 1899)),
  (name: 'Johannes Brahms', lifetime: Interval<num>(1833, 1897)),
  (name: 'Ludwig van Beethoven', lifetime: Interval<num>(1770, 1827)),
  (name: 'Maurice Ravel', lifetime: Interval<num>(1875, 1937)),
  (name: 'Modest Mussorgsky', lifetime: Interval<num>(1839, 1881)),
  (name: 'Pyotr Ilyich Tchaikovsky', lifetime: Interval<num>(1840, 1893)),
  (name: 'Ralph Vaughan Williams', lifetime: Interval<num>(1872, 1958)),
  (name: 'Richard Strauss', lifetime: Interval<num>(1864, 1949)),
  (name: 'Richard Wagner', lifetime: Interval<num>(1813, 1883)),
  (name: 'Robert Schumann', lifetime: Interval<num>(1810, 1856)),
  (name: 'Samuel Barber', lifetime: Interval<num>(1910, 1981)),
  (name: 'Sergei Rachmaninoff', lifetime: Interval<num>(1873, 1943)),
  (name: 'Wolfgang Amadeus Mozart', lifetime: Interval<num>(1756, 1791)),
];

void main() {
  group('interval', () {
    final interval0to7 = Interval<num>(0, 7);
    final interval8to9 = Interval<num>(8, 9);
    final interval1to3 = Interval<num>(1, 3);
    final interval3to6 = Interval<num>(3, 6);
    final interval2to4 = Interval<num>(2, 4);
    final interval5to5 = Interval<num>(5, 5);
    final intervals = [
      interval0to7,
      interval8to9,
      interval1to3,
      interval3to6,
      interval2to4,
      interval5to5,
    ];
    test('lower', () {
      expect(interval0to7.lower, 0);
      expect(interval8to9.lower, 8);
      expect(interval1to3.lower, 1);
      expect(interval3to6.lower, 3);
      expect(interval2to4.lower, 2);
      expect(interval5to5.lower, 5);
    });
    test('upper', () {
      expect(interval0to7.upper, 7);
      expect(interval8to9.upper, 9);
      expect(interval1to3.upper, 3);
      expect(interval3to6.upper, 6);
      expect(interval2to4.upper, 4);
      expect(interval5to5.upper, 5);
    });
    test('isSingle', () {
      expect(interval0to7.isSingle, isFalse);
      expect(interval8to9.isSingle, isFalse);
      expect(interval1to3.isSingle, isFalse);
      expect(interval3to6.isSingle, isFalse);
      expect(interval2to4.isSingle, isFalse);
      expect(interval5to5.isSingle, isTrue);
    });
    test('contains', () {
      for (final interval in intervals) {
        expect(interval.contains(interval.lower - 1), isFalse);
        for (var i = interval.lower; i <= interval.upper; i++) {
          expect(interval.contains(i), isTrue);
        }
        expect(interval.contains(interval.upper + 1), isFalse);
      }
    });
    test('intersects', () {
      final intersects = [intervals, intervals]
          .product()
          .where((pair) => pair.first.intersects(pair.last));
      expect(intersects, [
        [interval0to7, interval0to7],
        [interval0to7, interval1to3],
        [interval0to7, interval3to6],
        [interval0to7, interval2to4],
        [interval0to7, interval5to5],
        [interval8to9, interval8to9],
        [interval1to3, interval0to7],
        [interval1to3, interval1to3],
        [interval1to3, interval3to6],
        [interval1to3, interval2to4],
        [interval3to6, interval0to7],
        [interval3to6, interval1to3],
        [interval3to6, interval3to6],
        [interval3to6, interval2to4],
        [interval3to6, interval5to5],
        [interval2to4, interval0to7],
        [interval2to4, interval1to3],
        [interval2to4, interval3to6],
        [interval2to4, interval2to4],
        [interval5to5, interval0to7],
        [interval5to5, interval3to6],
        [interval5to5, interval5to5],
      ]);
    });
    test('encloses', () {
      final encloses = [intervals, intervals]
          .product()
          .where((pair) => pair.first.encloses(pair.last));
      expect(encloses, [
        [interval0to7, interval0to7],
        [interval0to7, interval1to3],
        [interval0to7, interval3to6],
        [interval0to7, interval2to4],
        [interval0to7, interval5to5],
        [interval8to9, interval8to9],
        [interval1to3, interval1to3],
        [interval3to6, interval3to6],
        [interval3to6, interval5to5],
        [interval2to4, interval2to4],
        [interval5to5, interval5to5],
      ]);
    });
    test('intersection', () {
      final fixtures = [
        (a: interval0to7, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval8to9, r: null),
        (a: interval0to7, b: interval1to3, r: Interval<num>(1, 3)),
        (a: interval0to7, b: interval3to6, r: Interval<num>(3, 6)),
        (a: interval0to7, b: interval2to4, r: Interval<num>(2, 4)),
        (a: interval0to7, b: interval5to5, r: Interval<num>(5, 5)),
        (a: interval8to9, b: interval0to7, r: null),
        (a: interval8to9, b: interval8to9, r: Interval<num>(8, 9)),
        (a: interval8to9, b: interval1to3, r: null),
        (a: interval8to9, b: interval3to6, r: null),
        (a: interval8to9, b: interval2to4, r: null),
        (a: interval8to9, b: interval5to5, r: null),
        (a: interval1to3, b: interval0to7, r: Interval<num>(1, 3)),
        (a: interval1to3, b: interval8to9, r: null),
        (a: interval1to3, b: interval1to3, r: Interval<num>(1, 3)),
        (a: interval1to3, b: interval3to6, r: Interval<num>(3, 3)),
        (a: interval1to3, b: interval2to4, r: Interval<num>(2, 3)),
        (a: interval1to3, b: interval5to5, r: null),
        (a: interval3to6, b: interval0to7, r: Interval<num>(3, 6)),
        (a: interval3to6, b: interval8to9, r: null),
        (a: interval3to6, b: interval1to3, r: Interval<num>(3, 3)),
        (a: interval3to6, b: interval3to6, r: Interval<num>(3, 6)),
        (a: interval3to6, b: interval2to4, r: Interval<num>(3, 4)),
        (a: interval3to6, b: interval5to5, r: Interval<num>(5, 5)),
        (a: interval2to4, b: interval0to7, r: Interval<num>(2, 4)),
        (a: interval2to4, b: interval8to9, r: null),
        (a: interval2to4, b: interval1to3, r: Interval<num>(2, 3)),
        (a: interval2to4, b: interval3to6, r: Interval<num>(3, 4)),
        (a: interval2to4, b: interval2to4, r: Interval<num>(2, 4)),
        (a: interval2to4, b: interval5to5, r: null),
        (a: interval5to5, b: interval0to7, r: Interval<num>(5, 5)),
        (a: interval5to5, b: interval8to9, r: null),
        (a: interval5to5, b: interval1to3, r: null),
        (a: interval5to5, b: interval3to6, r: Interval<num>(5, 5)),
        (a: interval5to5, b: interval2to4, r: null),
        (a: interval5to5, b: interval5to5, r: Interval<num>(5, 5)),
      ];
      for (final (:a, :b, :r) in fixtures) {
        expect(a.intersection(b), r);
        expect(b.intersection(a), r);
        expect(a.intersects(b), r != null);
        expect(b.intersects(a), r != null);
      }
    });
    test('union', () {
      final fixtures = [
        (a: interval0to7, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval8to9, r: Interval<num>(0, 9)),
        (a: interval0to7, b: interval1to3, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval3to6, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval2to4, r: Interval<num>(0, 7)),
        (a: interval0to7, b: interval5to5, r: Interval<num>(0, 7)),
        (a: interval8to9, b: interval0to7, r: Interval<num>(0, 9)),
        (a: interval8to9, b: interval8to9, r: Interval<num>(8, 9)),
        (a: interval8to9, b: interval1to3, r: Interval<num>(1, 9)),
        (a: interval8to9, b: interval3to6, r: Interval<num>(3, 9)),
        (a: interval8to9, b: interval2to4, r: Interval<num>(2, 9)),
        (a: interval8to9, b: interval5to5, r: Interval<num>(5, 9)),
        (a: interval1to3, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval1to3, b: interval8to9, r: Interval<num>(1, 9)),
        (a: interval1to3, b: interval1to3, r: Interval<num>(1, 3)),
        (a: interval1to3, b: interval3to6, r: Interval<num>(1, 6)),
        (a: interval1to3, b: interval2to4, r: Interval<num>(1, 4)),
        (a: interval1to3, b: interval5to5, r: Interval<num>(1, 5)),
        (a: interval3to6, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval3to6, b: interval8to9, r: Interval<num>(3, 9)),
        (a: interval3to6, b: interval1to3, r: Interval<num>(1, 6)),
        (a: interval3to6, b: interval3to6, r: Interval<num>(3, 6)),
        (a: interval3to6, b: interval2to4, r: Interval<num>(2, 6)),
        (a: interval3to6, b: interval5to5, r: Interval<num>(3, 6)),
        (a: interval2to4, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval2to4, b: interval8to9, r: Interval<num>(2, 9)),
        (a: interval2to4, b: interval1to3, r: Interval<num>(1, 4)),
        (a: interval2to4, b: interval3to6, r: Interval<num>(2, 6)),
        (a: interval2to4, b: interval2to4, r: Interval<num>(2, 4)),
        (a: interval2to4, b: interval5to5, r: Interval<num>(2, 5)),
        (a: interval5to5, b: interval0to7, r: Interval<num>(0, 7)),
        (a: interval5to5, b: interval8to9, r: Interval<num>(5, 9)),
        (a: interval5to5, b: interval1to3, r: Interval<num>(1, 5)),
        (a: interval5to5, b: interval3to6, r: Interval<num>(3, 6)),
        (a: interval5to5, b: interval2to4, r: Interval<num>(2, 5)),
        (a: interval5to5, b: interval5to5, r: Interval<num>(5, 5)),
      ];
      for (final (:a, :b, :r) in fixtures) {
        expect(a.union(b), r);
        expect(b.union(a), r);
      }
    });
    test('equals', () {
      for (var i = 0; i < intervals.length; i++) {
        for (var j = 0; j < intervals.length; j++) {
          expect(intervals[i] == intervals[j], i == j ? isTrue : isFalse);
        }
      }
    });
    test('hashCode', () {
      for (var i = 0; i < intervals.length; i++) {
        for (var j = 0; j < intervals.length; j++) {
          expect(intervals[i].hashCode == intervals[j].hashCode,
              i == j ? isTrue : isFalse);
        }
      }
    });
    test('toString', () {
      expect(interval0to7.toString(), '0..7');
      expect(interval8to9.toString(), '8..9');
      expect(interval1to3.toString(), '1..3');
      expect(interval3to6.toString(), '3..6');
      expect(interval2to4.toString(), '2..4');
      expect(interval5to5.toString(), '5..5');
    });
  });
  group('map', () {
    IntervalMap<num, String> createComposers() {
      final result = IntervalMap<num, String>();
      for (final composer in composers) {
        result[composer.lifetime] = composer.name;
      }
      return result;
    }

    test('empty', () {
      final map = IntervalMap<num, String>();
      expect(map.length, 0);
      expect(map.isEmpty, isTrue);
      expect(map.isNotEmpty, isFalse);
      expect(map.entries, isEmpty);
      expect(map.keys, isEmpty);
      expect(map.values, isEmpty);
      expect(map.entriesContainingPoint(0), isEmpty);
      expect(map.entriesIntersectingInterval(Interval(-1, 1)), isEmpty);
      expect(map.entriesEnclosingInterval(Interval(-1, 1)), isEmpty);
      expect(map.toString(), '{}');
    });
    test('single', () {
      final key = Interval<num>(1980, 2023);
      const value = 'Hello World';
      final map = IntervalMap<num, String>();
      map[key] = value;
      expect(map.length, 1);
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
      expect(map.entries, hasLength(1));
      expect(map.keys, [key]);
      expect(map.values, [value]);
      expect(map.containsKey(key), isTrue);
      expect(map.containsValue(value), isTrue);
      expect(map.keysContainingPoint(2000), [key]);
      expect(map.valuesContainingPoint(2023), [value]);
      expect(map.keysIntersectingInterval(Interval(1990, 2010)), [key]);
      expect(map.valuesIntersectingInterval(Interval(2010, 2030)), [value]);
      expect(map.keysEnclosingInterval(Interval(1990, 2010)), [key]);
      expect(map.valuesEnclosingInterval(Interval(2020, 2023)), [value]);
    });
    test('composers', () {
      final map = createComposers();
      expect(map.length, composers.length);
      expect(map.isEmpty, isFalse);
      expect(map.isNotEmpty, isTrue);
      expect(map.entries, hasLength(composers.length));
      expect(map.keys,
          unorderedEquals(composers.map((composer) => composer.lifetime)));
      expect(map.values,
          unorderedEquals(composers.map((composer) => composer.name)));
      expect(map.containsKey(composers.first.lifetime), isTrue);
      expect(map.containsValue(composers.first.name), isTrue);
      for (final composer in composers) {
        expect(map[composer.lifetime], composer.name);
      }
      expect(map.remove(composers.first.lifetime), composers.first.name);
      expect(map[composers.first.lifetime], isNull);
      expect(map.containsKey(composers.first.lifetime), isFalse);
      expect(map.containsValue(composers.first.name), isFalse);
      map.clear();
      expect(map, isEmpty);
    });
    test('composers alive in 1980', () {
      const length = 3;
      const point = 1980;
      final map = createComposers();
      expect(map.entriesContainingPoint(point), hasLength(length));
      expect(map.keysContainingPoint(point), hasLength(length));
      expect(map.valuesContainingPoint(point),
          unorderedEquals(['Carl Orff', 'Aaron Copland', 'Samuel Barber']));
      for (var i = 0; i < length; i++) {
        map.remove(map.keysContainingPoint(point).first);
        expect(map.valuesContainingPoint(point), hasLength(length - i - 1));
      }
      expect(map.entriesContainingPoint(point), isEmpty);
    });
    test('composers alive in the 20ties', () {
      const length = 4;
      final interval = Interval<num>(1700, 1725);
      final map = createComposers();
      expect(map.entriesIntersectingInterval(interval), hasLength(length));
      expect(map.keysIntersectingInterval(interval), hasLength(length));
      expect(
          map.valuesIntersectingInterval(interval),
          unorderedEquals([
            'Jean-Philippe Rameau',
            'Antonio Vivaldi',
            'George Frideric Handel',
            'Johann Sebastian Bach',
          ]));
      for (var i = 0; i < length; i++) {
        map.remove(map.keysIntersectingInterval(interval).first);
        expect(map.valuesIntersectingInterval(interval),
            hasLength(length - i - 1));
      }
      expect(map.entriesIntersectingInterval(interval), isEmpty);
    });
    test('composers between 1850 and 1900', () {
      const length = 3;
      final interval = Interval<num>(1850, 1900);
      final map = createComposers();
      expect(map.entriesEnclosingInterval(interval), hasLength(length));
      expect(map.keysEnclosingInterval(interval), hasLength(length));
      expect(
          map.valuesEnclosingInterval(interval),
          unorderedEquals([
            'Antonín Dvořák',
            'Camille Saint-Saëns',
            'Giuseppe Verdi',
          ]));
      for (var i = 0; i < length; i++) {
        map.remove(map.keysEnclosingInterval(interval).first);
        expect(
            map.valuesEnclosingInterval(interval), hasLength(length - i - 1));
      }
      expect(map.entriesEnclosingInterval(interval), isEmpty);
    });
  });
  group('set', () {
    IntervalSet<num> createComposers() => IntervalSet<num>()
      ..addAll(composers.map((composer) => composer.lifetime));

    test('empty', () {
      final set = IntervalSet<num>();
      expect(set.length, 0);
      expect(set.isEmpty, isTrue);
      expect(set.isNotEmpty, isFalse);
      expect(set.contains(null), isFalse);
      expect(set.lookup(null), isNull);
      expect(set.containingPoint(0), isEmpty);
      expect(set.intersectingInterval(Interval(-1, 1)), isEmpty);
      expect(set.enclosingInterval(Interval(-1, 1)), isEmpty);
      expect(set.toSet(), isEmpty);
      expect(set.toString(), '{}');
    });
    test('single', () {
      final interval = Interval<num>(1980, 2023);
      final set = IntervalSet<num>();
      expect(set.add(interval), isTrue);
      expect(set.length, 1);
      expect(set.isEmpty, isFalse);
      expect(set.isNotEmpty, isTrue);
      expect(set.contains(interval), isTrue);
      expect(set.lookup(interval), interval);
      expect(set.containingPoint(1979), isEmpty);
      expect(set.containingPoint(1980), [interval]);
      expect(set.containingPoint(2000), [interval]);
      expect(set.containingPoint(2023), [interval]);
      expect(set.containingPoint(2024), isEmpty);
      expect(set.intersectingInterval(Interval(1900, 1979)), isEmpty);
      expect(set.intersectingInterval(Interval(1979, 1985)), [interval]);
      expect(set.intersectingInterval(Interval(1980, 2023)), [interval]);
      expect(set.intersectingInterval(Interval(2000, 2010)), [interval]);
      expect(set.intersectingInterval(Interval(2020, 2030)), [interval]);
      expect(set.intersectingInterval(Interval(2024, 2100)), isEmpty);
      expect(set.enclosingInterval(Interval(1900, 1979)), isEmpty);
      expect(set.enclosingInterval(Interval(1979, 1985)), isEmpty);
      expect(set.enclosingInterval(Interval(1980, 2023)), [interval]);
      expect(set.enclosingInterval(Interval(2000, 2010)), [interval]);
      expect(set.enclosingInterval(Interval(2020, 2030)), isEmpty);
      expect(set.enclosingInterval(Interval(2024, 2100)), isEmpty);
      expect(set.toSet(), {interval});
      expect(set.toString(), '{1980..2023}');
    });
    test('composers', () {
      final set = createComposers();
      expect(set.length, composers.length);
      expect(set.isEmpty, isFalse);
      expect(set.isNotEmpty, isTrue);
      expect(set, hasLength(composers.length));
      for (final composer in composers) {
        expect(set.contains(composer.lifetime), isTrue);
      }
      expect(set.remove(composers.first.lifetime), isTrue);
      expect(set.contains(composers.first.lifetime), isFalse);
      expect(set.remove(composers.first.lifetime), isFalse);
      expect(set, hasLength(composers.length - 1));
      set.removeAll([composers.first.lifetime, composers.last.lifetime]);
      expect(set, hasLength(composers.length - 2));
      set.clear();
      expect(set, isEmpty);
    });
    test('composers alive in 1980', () {
      const length = 3;
      const point = 1980;
      final set = createComposers();
      expect(
          set.containingPoint(point),
          unorderedEquals([
            Interval<num>(1895, 1982),
            Interval<num>(1900, 1990),
            Interval<num>(1910, 1981),
          ]));
      for (var i = 0; i < length; i++) {
        set.remove(set.containingPoint(point).first);
        expect(set.containingPoint(point), hasLength(length - i - 1));
      }
      expect(set.containingPoint(point), isEmpty);
    });
    test('composers alive in the 20ties', () {
      const length = 4;
      final interval = Interval<num>(1700, 1725);
      final set = createComposers();
      expect(
          set.intersectingInterval(interval),
          unorderedEquals([
            Interval<num>(1683, 1764),
            Interval<num>(1678, 1741),
            Interval<num>(1685, 1759),
            Interval<num>(1685, 1750),
          ]));
      for (var i = 0; i < length; i++) {
        set.remove(set.intersectingInterval(interval).first);
        expect(set.intersectingInterval(interval), hasLength(length - i - 1));
      }
      expect(set.intersectingInterval(interval), isEmpty);
    });
    test('composers between 1850 and 1900', () {
      const length = 3;
      final interval = Interval<num>(1850, 1900);
      final set = createComposers();
      expect(set.enclosingInterval(interval), [
        Interval<num>(1841, 1904),
        Interval<num>(1835, 1921),
        Interval<num>(1813, 1901),
      ]);
      for (var i = 0; i < length; i++) {
        set.remove(set.enclosingInterval(interval).first);
        expect(set.enclosingInterval(interval), hasLength(length - i - 1));
      }
      expect(set.enclosingInterval(interval), isEmpty);
    });
  });
  test('stress', () {
    const min = 0, max = 10000, size = 100, count = 50000;
    final random = Random(71729);
    final intervals = <Interval<num>>[];
    for (var i = 0; i < count; i++) {
      final a = random.nextInt(max - size), c = random.nextInt(size);
      intervals.add(Interval<num>(a, a + c));
    }
    final node = IntervalTreeNode.fromIntervals(intervals);
    expect(node?.iterable.length, intervals.length);
    expect(node?.queryInterval(Interval(min, max)).length, intervals.length);
    for (final interval in intervals) {
      final midpoint = (interval.lower + interval.upper) ~/ 2;
      expect(node?.queryPoint(midpoint), contains(same(interval)));
      expect(node?.queryPoint(interval.lower), contains(same(interval)));
      expect(node?.queryPoint(interval.upper), contains(same(interval)));
      expect(node?.queryInterval(interval), contains(same(interval)));
      expect(node?.queryInterval(Interval(interval.lower)),
          contains(same(interval)));
      expect(
          node?.queryInterval(Interval(interval.lower - 1, interval.lower + 1)),
          contains(same(interval)));
      expect(node?.queryInterval(Interval(midpoint)), contains(same(interval)));
      expect(node?.queryInterval(Interval(midpoint - 1, midpoint + 1)),
          contains(same(interval)));
      expect(node?.queryInterval(Interval(interval.upper)),
          contains(same(interval)));
      expect(
          node?.queryInterval(Interval(interval.upper - 1, interval.upper + 1)),
          contains(same(interval)));
    }
  });
}
