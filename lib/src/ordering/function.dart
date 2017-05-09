part of more.ordering;

typedef T _MapFunction<F, T>(F argument);

class _FunctionOrdering<F, T> extends Ordering<F> {
  final Ordering<T> _ordering;

  final _MapFunction<F, T> _function;

  const _FunctionOrdering(this._ordering, this._function);

  @override
  int compare(F a, F b) => _ordering.compare(_function(a), _function(b));
}
