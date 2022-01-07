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
}
