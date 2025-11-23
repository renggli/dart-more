# Agent Guidelines for Dart

This file provides guidance to AI agents and developers when working with code in this repository.

## Code Standards

- Write clear, concise, and self-explanatory code.
- Avoid empty lines and excessive comments within methods.
- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style).
- Run `dart format` to ensure consistent formatting.

## Documentation & Tests

- All public APIs (classes, methods, fields) must have documentation comments (`///`).
- All comments must be complete sentences and end with a full-stop.
- Aim for 100% test coverage. Tests should mirror the top-level `lib/` structure in `test/`.
- Code must pass the analyzer with zero warnings.

## Minimal Dependencies

- Prefer standard library solutions.
- Add third-party dependencies only with clear benefit. See `pubspec.yaml` for current dependencies.

## Platform Compatibility

- Code must be compatible with Flutter.
- Code must run on Native (JIT/AOT) and Web (JS/WASM) platforms.
- Avoid `dart:io`, `dart:html`, `dart:js` in core logic.

## Type Safety & Null Safety

- Avoid `dynamic`. Use explicit types.
- Use pattern matching, sealed classes, enums, and record types where appropriate.

## Immutability by Default

- Use `final` for fields and variables wherever possible.
- Use `const` constructors and literals wherever possible.

## Asynchrony & Error Handling

- Prefer `async` and `await` over raw futures.
- Don't ignore errors; catch specific exceptions.
- Avoid catching `Error` or its subclasses.

## Explicit Over Implicit

- Prefer explicit configuration and control flow.
- Use relative imports within the package.

## Performance Pragmatism

- Optimize hot paths that show up in profiling; otherwise keep code simple and readable.
