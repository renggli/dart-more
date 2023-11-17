/// Information about the runtime environment.
library feature;

import 'dart:math';

/// True, if the code is running in JavaScript.
const bool isJavaScript = identical(1, 1.0);

/// The safe bits of an [int] value. In the Dart VM integer are represented
/// using 63 bits, in JavaScript we only have 53.
const int safeIntegerBits = isJavaScript ? 53 : 63;

/// The minimum safe value of an [int].
final int minSafeInteger = -pow(2, safeIntegerBits - 1).toInt();
// -BigInt.two.pow(safeIntegerBits - 1).toInt();

/// The maximum safe value of an [int].
final int maxSafeInteger = pow(2, safeIntegerBits - 1).toInt() - 1;
