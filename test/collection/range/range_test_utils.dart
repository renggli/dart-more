import 'package:checks/checks.dart';
import 'package:more/collection.dart';

void verifyRange<T>(
  Range<T> range, {
  required List<T> included,
  required List<T> excluded,
  bool reverse = true,
}) {
  check(range).deepEquals(included);
  check(range.length).equals(included.length);
  if (reverse) {
    verifyRange(
      range.reversed,
      included: included.reversed.toList(),
      excluded: excluded,
      reverse: false,
    );
  }
  if (included.isEmpty) {
    check(range.isEmpty).isTrue();
  } else {
    check(range.isNotEmpty).isTrue();
    check(range.start).equals(included.first);
    check(range.start).not((it) => it.equals(range.end));
    check(range.first).equals(included.first);
    check(range.last).equals(included.last);
  }
  // Test included indexes.
  for (var index = 0; index < included.length; index++) {
    final value = included[index];
    check(range[index]).equals(value);
    check(range.contains(value)).isTrue();
    check(range.indexOf(value)).equals(index);
    check(range.indexOf(value, index)).equals(index);
    check(range.indexOf(value, -1)).equals(index);
    check(range.lastIndexOf(value)).equals(index);
    check(range.lastIndexOf(value, index)).equals(index);
    check(range.lastIndexOf(value, included.length)).equals(index);
  }
  // Test excluded indexes.
  for (final value in excluded) {
    check(range.contains(value)).isFalse();
    check(range.indexOf(value)).equals(-1);
    check(range.indexOf(value, 0)).equals(-1);
    check(range.indexOf(value, range.length)).equals(-1);
    check(range.lastIndexOf(value)).equals(-1);
    check(range.lastIndexOf(value, 0)).equals(-1);
    check(range.lastIndexOf(value, range.length)).equals(-1);
  }
  // Validate forward iteration.
  final forward1 = range.iterator;
  check(forward1.range).identicalTo(range);
  final forward2 = included.iterator;
  while (true) {
    final hasMore = forward1.moveNext();
    check(hasMore).equals(forward2.moveNext());
    if (hasMore == false) break;
    check(forward1.current).equals(forward2.current);
  }
  // Validate backward iteration.
  final backward1 = range.iteratorAtEnd;
  check(backward1.range).identicalTo(range);
  final backward2 = included.reversed.iterator;
  while (true) {
    final hasMore = backward1.movePrevious();
    check(hasMore).equals(backward2.moveNext());
    if (hasMore == false) break;
    check(backward1.current).equals(backward2.current);
  }
  // Test range errors.
  check(() => range[-1]).throws<RangeError>();
  check(() => range[included.length]).throws<RangeError>();
}
