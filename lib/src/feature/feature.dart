/// Information about the runtime environment.
library;

import 'dart:math';

/// True, if the code is running in JavaScript.
const isJavaScript = identical(1, 1.0);

/// True, if the code is running in WASM.
const isWasm = bool.fromEnvironment('dart.tool.dart2wasm');

/// True, if the code has assertions enabled.
final bool hasAssertionsEnabled = () {
  var enabled = false;
  assert(enabled = true);
  return enabled;
}();

/// The nominal safe integer bit-width used by [minSafeInteger] and
/// [maxSafeInteger] (`53` in JavaScript, `63` on VM/Wasm).
const int safeIntegerBits = isJavaScript ? 53 : 63;

/// The minimum safe value of an [int] (`-2^(safeIntegerBits - 1)`).
final int minSafeInteger = -pow(2, safeIntegerBits - 1).toInt();

/// The maximum safe value of an [int] (`2^(safeIntegerBits - 1) - 1`).
final int maxSafeInteger = pow(2, safeIntegerBits - 1).toInt() - 1;
