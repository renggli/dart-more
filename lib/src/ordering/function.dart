library more.ordering.function;

import 'package:more/ordering.dart';

typedef MappingFunction<F, T> = T Function(F argument);

class MappedOrdering<F, T> extends Ordering<F> {
  final Ordering<T> ordering;

  final MappingFunction<F, T> mapper;

  const MappedOrdering(this.ordering, this.mapper);

  @override
  int compare(F a, F b) => ordering.compare(mapper(a), mapper(b));
}
