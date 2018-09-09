library more.int_math.lcm;

import 'package:more/src/int_math/gcd.dart';

/// Returns the least common multiple (LCM) of two integers a and b. This is the
/// smallest positive integer that is divisible by both a and b.
int lcm(int a, int b) => a * b ~/ gcd(a, b);
