/// The Dart compilers consider various user annotations (pragmas) during
/// compilation. This library makes their use easier.
///
/// Make sure to study and understand the documentation for the
/// [Dart VM](https://github.com/dart-lang/sdk/blob/main/runtime/docs/pragmas.md)
/// and
/// [Dart2JS](https://github.com/dart-lang/sdk/blob/main/pkg/compiler/doc/pragmas.md)
/// before using any of this code.
library;

import 'feature.dart';

// region Pragmas for general use.

/// Never inline a function or method.
const neverInline =
    isJavaScript
        ? neverInlineJs
        : isWasm
        ? neverInlineWasm
        : neverInlineVm;
const neverInlineJs = pragma('dart2js:never-inline');
const neverInlineVm = pragma('vm:never-inline');
const neverInlineWasm = pragma('wasm:never-inline');

/// Inline a function or method when possible.
const preferInline =
    isJavaScript
        ? preferInlineJs
        : isWasm
        ? preferInlineWasm
        : preferInlineVm;
const preferInlineJs = pragma('dart2js:prefer-inline');
const preferInlineVm = pragma('vm:prefer-inline');
const preferInlineWasm = pragma('wasm:prefer-inline');

// endregion

// region Unsafe pragmas for general use.

/// Removes all array bounds checks.
const noBoundsChecks = isJavaScript ? noBoundsChecksJs : noBoundsChecksVm;
const noBoundsChecksJs = pragma('dart2js:index-bounds:trust');
const noBoundsChecksVm = pragma('vm:unsafe:no-bounds-checks');

// endregion
