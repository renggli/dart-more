import '../../printer.dart';
import '../collection/bitlist.dart';
import 'char_matcher.dart';

class LookupCharMatcher extends CharMatcher {
  const LookupCharMatcher(this.start, this.stop, this.buffer);

  final int start;
  final int stop;
  final BitList buffer;

  @override
  bool match(int value) =>
      start <= value && value <= stop && buffer.getUnchecked(value - start);

  @override
  ObjectPrinter get toStringPrinter => super.toStringPrinter
    ..addValue(start, name: 'start')
    ..addValue(stop, name: 'stop')
    ..addValue(buffer, name: 'buffer');
}
