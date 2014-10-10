part of monad;

/**
 * The continuation monad.
 */
class Eventually<T> implements Monad<T> {

  final Function _function;

  factory Eventually.fromValue(T value) {
    return new Eventually<T>._((success(T value)) => success(value));
  }

  factory Eventually.fromFunction(function(T success)) {
    return new Eventually<T>._(function);
  }

  Eventually._(this._function);

  void run(success(T value)) => _function(success());

  @override
  Monad then(function(T value)) {
    return new Eventually.fromFunction((T value) {
      return function(_function(value));
    });
  }

}