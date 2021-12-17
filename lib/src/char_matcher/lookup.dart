import '../collection/bitlist.dart';
import 'char_matcher.dart';

class LookupCharMatcher extends CharMatcher {
  final int start;
  final int stop;
  final BitList buffer;

  const LookupCharMatcher(this.start, this.stop, this.buffer);

  @override
  bool match(int value) =>
      start <= value && value <= stop && buffer.getUnchecked(value - start);
}
