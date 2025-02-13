// AUTO-GENERATED CODE: DO NOT EDIT

/// Converts a function with positional arguments into a sequence of functions
/// taking a single argument: https://en.wikipedia.org/wiki/Currying
library;

import 'mapping.dart';

extension Curry1<T1, R> on Map1<T1, R> {
  /// Converts a function with 1 positional arguments into a sequence of 1
  /// functions taking a single argument.
  Map1<T1, R> get curry => (T1 arg1) => this(arg1);
}

extension Curry2<T1, T2, R> on Map2<T1, T2, R> {
  /// Converts a function with 2 positional arguments into a sequence of 2
  /// functions taking a single argument.
  Map1<T1, Map1<T2, R>> get curry => (T1 arg1) => (T2 arg2) => this(arg1, arg2);
}

extension Curry3<T1, T2, T3, R> on Map3<T1, T2, T3, R> {
  /// Converts a function with 3 positional arguments into a sequence of 3
  /// functions taking a single argument.
  Map1<T1, Map1<T2, Map1<T3, R>>> get curry =>
      (T1 arg1) => (T2 arg2) => (T3 arg3) => this(arg1, arg2, arg3);
}

extension Curry4<T1, T2, T3, T4, R> on Map4<T1, T2, T3, T4, R> {
  /// Converts a function with 4 positional arguments into a sequence of 4
  /// functions taking a single argument.
  Map1<T1, Map1<T2, Map1<T3, Map1<T4, R>>>> get curry =>
      (T1 arg1) =>
          (T2 arg2) => (T3 arg3) => (T4 arg4) => this(arg1, arg2, arg3, arg4);
}

extension Curry5<T1, T2, T3, T4, T5, R> on Map5<T1, T2, T3, T4, T5, R> {
  /// Converts a function with 5 positional arguments into a sequence of 5
  /// functions taking a single argument.
  Map1<T1, Map1<T2, Map1<T3, Map1<T4, Map1<T5, R>>>>> get curry =>
      (T1 arg1) =>
          (T2 arg2) =>
              (T3 arg3) =>
                  (T4 arg4) => (T5 arg5) => this(arg1, arg2, arg3, arg4, arg5);
}

extension Curry6<T1, T2, T3, T4, T5, T6, R> on Map6<T1, T2, T3, T4, T5, T6, R> {
  /// Converts a function with 6 positional arguments into a sequence of 6
  /// functions taking a single argument.
  Map1<T1, Map1<T2, Map1<T3, Map1<T4, Map1<T5, Map1<T6, R>>>>>> get curry =>
      (T1 arg1) =>
          (T2 arg2) =>
              (T3 arg3) =>
                  (T4 arg4) =>
                      (T5 arg5) =>
                          (T6 arg6) => this(arg1, arg2, arg3, arg4, arg5, arg6);
}

extension Curry7<T1, T2, T3, T4, T5, T6, T7, R>
    on Map7<T1, T2, T3, T4, T5, T6, T7, R> {
  /// Converts a function with 7 positional arguments into a sequence of 7
  /// functions taking a single argument.
  Map1<T1, Map1<T2, Map1<T3, Map1<T4, Map1<T5, Map1<T6, Map1<T7, R>>>>>>>
  get curry =>
      (T1 arg1) =>
          (T2 arg2) =>
              (T3 arg3) =>
                  (T4 arg4) =>
                      (T5 arg5) =>
                          (T6 arg6) =>
                              (T7 arg7) => this(
                                arg1,
                                arg2,
                                arg3,
                                arg4,
                                arg5,
                                arg6,
                                arg7,
                              );
}

extension Curry8<T1, T2, T3, T4, T5, T6, T7, T8, R>
    on Map8<T1, T2, T3, T4, T5, T6, T7, T8, R> {
  /// Converts a function with 8 positional arguments into a sequence of 8
  /// functions taking a single argument.
  Map1<
    T1,
    Map1<T2, Map1<T3, Map1<T4, Map1<T5, Map1<T6, Map1<T7, Map1<T8, R>>>>>>>
  >
  get curry =>
      (T1 arg1) =>
          (T2 arg2) =>
              (T3 arg3) =>
                  (T4 arg4) =>
                      (T5 arg5) =>
                          (T6 arg6) =>
                              (T7 arg7) =>
                                  (T8 arg8) => this(
                                    arg1,
                                    arg2,
                                    arg3,
                                    arg4,
                                    arg5,
                                    arg6,
                                    arg7,
                                    arg8,
                                  );
}

extension Curry9<T1, T2, T3, T4, T5, T6, T7, T8, T9, R>
    on Map9<T1, T2, T3, T4, T5, T6, T7, T8, T9, R> {
  /// Converts a function with 9 positional arguments into a sequence of 9
  /// functions taking a single argument.
  Map1<
    T1,
    Map1<
      T2,
      Map1<T3, Map1<T4, Map1<T5, Map1<T6, Map1<T7, Map1<T8, Map1<T9, R>>>>>>>
    >
  >
  get curry =>
      (T1 arg1) =>
          (T2 arg2) =>
              (T3 arg3) =>
                  (T4 arg4) =>
                      (T5 arg5) =>
                          (T6 arg6) =>
                              (T7 arg7) =>
                                  (T8 arg8) =>
                                      (T9 arg9) => this(
                                        arg1,
                                        arg2,
                                        arg3,
                                        arg4,
                                        arg5,
                                        arg6,
                                        arg7,
                                        arg8,
                                        arg9,
                                      );
}

extension Curry10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, R>
    on Map10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, R> {
  /// Converts a function with 10 positional arguments into a sequence of 10
  /// functions taking a single argument.
  Map1<
    T1,
    Map1<
      T2,
      Map1<
        T3,
        Map1<T4, Map1<T5, Map1<T6, Map1<T7, Map1<T8, Map1<T9, Map1<T10, R>>>>>>>
      >
    >
  >
  get curry =>
      (T1 arg1) =>
          (T2 arg2) =>
              (T3 arg3) =>
                  (T4 arg4) =>
                      (T5 arg5) =>
                          (T6 arg6) =>
                              (T7 arg7) =>
                                  (T8 arg8) =>
                                      (T9 arg9) =>
                                          (T10 arg10) => this(
                                            arg1,
                                            arg2,
                                            arg3,
                                            arg4,
                                            arg5,
                                            arg6,
                                            arg7,
                                            arg8,
                                            arg9,
                                            arg10,
                                          );
}
