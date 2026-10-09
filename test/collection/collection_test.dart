import 'package:checks/checks.dart';
import 'package:more/collection.dart';
import 'package:test/test.dart';

void main() {
  group('forList', () {
    test('empty', () {
      final collection = Collection<int>.forList();
      check(collection).isEmpty();
      check(collection).isA<Collection<int>>();
    });
    test('delegate', () {
      final delegate = <int>[1, 2];
      final collection = Collection.forList(delegate);
      check(collection).deepEquals([1, 2]);
      collection.add(3);
      check(delegate).deepEquals([1, 2, 3]);
      delegate.add(4);
      check(collection).deepEquals([1, 2, 3, 4]);
    });
    test('add', () {
      final collection = Collection<int>.forList();
      collection.add(1);
      check(collection).deepEquals([1]);
      collection.add(2);
      check(collection).deepEquals([1, 2]);
    });
    test('addAll', () {
      final collection = Collection<int>.forList();
      collection.addAll([1, 2]);
      check(collection).deepEquals([1, 2]);
      collection.addAll([3, 4]);
      check(collection).deepEquals([1, 2, 3, 4]);
    });
    test('remove', () {
      final collection = Collection.forList([1, 2, 3]);
      check(collection.remove(2)).isTrue();
      check(collection).deepEquals([1, 3]);
      check(collection.remove(4)).isFalse();
      check(collection).deepEquals([1, 3]);
    });
    test('clear', () {
      final collection = Collection.forList([1, 2, 3]);
      collection.clear();
      check(collection).isEmpty();
    });
  });

  group('forSet', () {
    test('empty', () {
      final collection = Collection<int>.forSet();
      check(collection).isEmpty();
      check(collection).isA<Collection<int>>();
    });
    test('delegate', () {
      final delegate = <int>{1, 2};
      final collection = Collection.forSet(delegate);
      check(collection).unorderedEquals([1, 2]);
      collection.add(3);
      check(delegate).unorderedEquals([1, 2, 3]);
      delegate.add(4);
      check(collection).unorderedEquals([1, 2, 3, 4]);
    });
    test('add', () {
      final collection = Collection<int>.forSet();
      collection.add(1);
      check(collection).unorderedEquals([1]);
      collection.add(2);
      check(collection).unorderedEquals([1, 2]);
      collection.add(1);
      check(collection).unorderedEquals([1, 2]);
    });
    test('addAll', () {
      final collection = Collection<int>.forSet();
      collection.addAll([1, 2]);
      check(collection).unorderedEquals([1, 2]);
      collection.addAll([2, 3]);
      check(collection).unorderedEquals([1, 2, 3]);
    });
    test('remove', () {
      final collection = Collection.forSet({1, 2, 3});
      check(collection.remove(2)).isTrue();
      check(collection).unorderedEquals([1, 3]);
      check(collection.remove(4)).isFalse();
      check(collection).unorderedEquals([1, 3]);
    });
    test('clear', () {
      final collection = Collection.forSet({1, 2, 3});
      collection.clear();
      check(collection).isEmpty();
    });
  });
}
