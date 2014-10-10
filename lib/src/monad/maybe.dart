part of monad;

/**
 * The optional monad.
 */
class Optional<T> implements Monad<T> {

  /**
   * The value of this monad.
   */
  final T _value;

  /**
   * Constructs an optional instance.
   */
  const Optional(this._value);

  /**
   * Constructs an present instance with a non-null reference.
   */
  factory Optional.present(T value) {
    if (value == null) {
      throw new ArgumentError('Expected a non-null value.');
    }
    return new Optional(value);
  }

  /**
   * Constructs an absent instance with no containing reference.
   */
  factory Optional.absent() => const Optional(null);

  /**
   * Returns the present value of this monad, otherwise throws an exception.
   */
  T get value {
    if (_value == null) {
      throw new ArgumentError('Expected a non-null value.');
    }
    return _value;
  }

  /**
   * Returns the present value of this monad, otherwise returns [other].
   */
  T or(T other) => _value == null ? other : _value;

  /**
   * Returns the present value of this monad, otherwise `null`.
   */
  T get orNull => _value;

  /**
   * Evaluates the function with the present value, otherwise returns the absent optional.
   */
  @override
  Optional then(function(T value)) {
    if (_value == null) {
      return const Optional(null);
    }
    return new Optional(function(_value));
  }

  /**
   * Returns true if the value is present.
   */
  bool get isPresent => _value != null;

  /**
   * Returns true if the value is absent.
   */
  bool get isAbsent => _value == null;

  @override
  String toString() {
    if (_value == null) {
      return 'Optional.absent()';
    } else {
      return 'Optional.present($_value)';
    }
  }

}