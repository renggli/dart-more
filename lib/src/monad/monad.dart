part of monad;

abstract class Monad<T> {
  Monad then(function(T value));
}