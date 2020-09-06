import 'dart:collection';

/// Function type to build elements.
typedef Builder<E> = E Function();

/// States of the iterator statemachine.
enum State {
  start,
  before,
  next,
  separator,
  after,
  complete,
}

extension SeparatedExtension<E> on Iterable<E> {
  /// Returns an [Iterable] where every element is separated by an element
  /// built by a [separator] builder. Optionally specified [before] and [after]
  /// builders can provide an element at the beginning or the end of the
  /// non-empty iterable.
  ///
  /// Examples:
  ///
  ///    [1, 2, 3].separatedBy(() => 0);   // [1, 0, 2, 0, 3]
  ///    [1, 2].separateBy(() => 0, after: () => -1);   // [1, 0, 2, -1]
  ///
  Iterable<E> separatedBy(Builder<E> separator,
          {Builder<E>? before, Builder<E>? after}) =>
      SeparatedIterable<E>(this, separator, before, after);
}

class SeparatedIterable<E> extends IterableBase<E> {
  final Iterable<E> iterable;
  final Builder<E> separator;
  final Builder<E>? before;
  final Builder<E>? after;

  SeparatedIterable(this.iterable, this.separator, this.before, this.after);

  @override
  Iterator<E> get iterator =>
      SeparatedIterator<E>(iterable.iterator, separator, before, after);
}

class SeparatedIterator<E> extends Iterator<E> {
  final Iterator<E> iterator;
  final Builder<E> separator;
  final Builder<E>? before;
  final Builder<E>? after;

  @override
  late E current;
  State state = State.start;

  SeparatedIterator(this.iterator, this.separator, this.before, this.after);

  @override
  bool moveNext() {
    switch (state) {
      case State.start:
        if (iterator.moveNext()) {
          if (before == null) {
            state = State.next;
            current = iterator.current;
          } else {
            state = State.before;
            current = before!();
          }
        } else {
          state = State.complete;
        }
        break;
      case State.before:
        state = State.next;
        current = iterator.current;
        return true;
      case State.next:
        if (iterator.moveNext()) {
          state = State.separator;
          current = separator();
        } else {
          if (after == null) {
            state = State.complete;
          } else {
            state = State.after;
            current = after!();
          }
        }
        break;
      case State.separator:
        state = State.next;
        current = iterator.current;
        return true;
      case State.after:
        state = State.complete;
        return false;
      case State.complete:
        return false;
    }
    return state != State.complete;
  }
}
