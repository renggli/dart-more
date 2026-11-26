/// Information about the runtime environment.
library;

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

/// The minimum safe value of an [int] (`-(2^53 - 1)` in JavaScript, `-2^63` on
/// VM/Wasm).
const int minSafeInteger = isJavaScript ? -9007199254740991 : -(1 << 62) * 2;

/// The maximum safe value of an [int] (`2^53 - 1` in JavaScript, `2^63 - 1` on
/// VM/Wasm).
const int maxSafeInteger = isJavaScript
    ? 9007199254740991
    : ((1 << 62) - 1) * 2 + 1;
