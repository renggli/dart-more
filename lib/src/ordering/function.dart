import 'ordering.dart';

typedef MappingFunction<F, T> = T Function(F argument);

class MappedOrdering<F, T> extends Ordering<F> {
  const MappedOrdering(this.ordering, this.mapper);

  final Ordering<T> ordering;

  final MappingFunction<F, T> mapper;

  @override
  int compare(F a, F b) => ordering.compare(mapper(a), mapper(b));
}
