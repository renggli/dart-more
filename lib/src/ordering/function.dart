part of ordering;

class _FunctionOrdering<T> extends Ordering<T> {
  final Ordering _ordering;

  final Function _function;

  const _FunctionOrdering(this._ordering, this._function);

  @override
  int compare(a, b) => _ordering.compare(_function(a), _function(b));
}
