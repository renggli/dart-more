library more.ordering.function;

import 'package:more/ordering.dart';

typedef T MappingFunction<F, T>(F argument);

class MappedOrdering<F, T> extends Ordering<F> {
  final Ordering<T> _ordering;

  final MappingFunction<F, T> _function;

  const MappedOrdering(this._ordering, this._function);

  @override
  int compare(F a, F b) => _ordering.compare(_function(a), _function(b));
}
