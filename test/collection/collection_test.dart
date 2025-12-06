import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('forList', () {
    test('empty', () {
      final collection = Collection<int>.forList();
      expect(collection, isEmpty);
      expect(collection, isA<Collection<int>>());
    });
    test('delegate', () {
      final delegate = <int>[1, 2];
      final collection = Collection.forList(delegate);
      expect(collection, [1, 2]);
      collection.add(3);
      expect(delegate, [1, 2, 3]);
      delegate.add(4);
      expect(collection, [1, 2, 3, 4]);
    });
    test('add', () {
      final collection = Collection<int>.forList();
      collection.add(1);
      expect(collection, [1]);
      collection.add(2);
      expect(collection, [1, 2]);
    });
    test('addAll', () {
      final collection = Collection<int>.forList();
      collection.addAll([1, 2]);
      expect(collection, [1, 2]);
      collection.addAll([3, 4]);
      expect(collection, [1, 2, 3, 4]);
    });
    test('remove', () {
      final collection = Collection.forList([1, 2, 3]);
      expect(collection.remove(2), isTrue);
      expect(collection, [1, 3]);
      expect(collection.remove(4), isFalse);
      expect(collection, [1, 3]);
    });
    test('clear', () {
      final collection = Collection.forList([1, 2, 3]);
      collection.clear();
      expect(collection, isEmpty);
    });
  });
  group('forSet', () {
    test('empty', () {
      final collection = Collection<int>.forSet();
      expect(collection, isEmpty);
      expect(collection, isA<Collection<int>>());
    });
    test('delegate', () {
      final delegate = <int>{1, 2};
      final collection = Collection.forSet(delegate);
      expect(collection, unorderedEquals([1, 2]));
      collection.add(3);
      expect(delegate, unorderedEquals([1, 2, 3]));
      delegate.add(4);
      expect(collection, unorderedEquals([1, 2, 3, 4]));
    });
    test('add', () {
      final collection = Collection<int>.forSet();
      collection.add(1);
      expect(collection, unorderedEquals([1]));
      collection.add(2);
      expect(collection, unorderedEquals([1, 2]));
      collection.add(1);
      expect(collection, unorderedEquals([1, 2]));
    });
    test('addAll', () {
      final collection = Collection<int>.forSet();
      collection.addAll([1, 2]);
      expect(collection, unorderedEquals([1, 2]));
      collection.addAll([2, 3]);
      expect(collection, unorderedEquals([1, 2, 3]));
    });
    test('remove', () {
      final collection = Collection.forSet({1, 2, 3});
      expect(collection.remove(2), isTrue);
      expect(collection, unorderedEquals([1, 3]));
      expect(collection.remove(4), isFalse);
      expect(collection, unorderedEquals([1, 3]));
    });
    test('clear', () {
      final collection = Collection.forSet({1, 2, 3});
      collection.clear();
      expect(collection, isEmpty);
    });
  });
}
