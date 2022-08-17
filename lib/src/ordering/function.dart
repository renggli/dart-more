// ignore_for_file: deprecated_member_use_from_same_package

import '../../printer.dart';
import 'ordering.dart';

typedef MappingFunction<F, T> = T Function(F argument);

class MappedOrdering<F, T> extends Ordering<F> {
  const MappedOrdering(this.ordering, this.mapper);

  final Ordering<T> ordering;

  final MappingFunction<F, T> mapper;

  @override
  int compare(F a, F b) => ordering.compare(mapper(a), mapper(b));

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(ordering, name: 'ordering')
    ..addValue(mapper, name: 'mapper');
}
