// AUTO-GENERATED CODE: DO NOT EDIT

/// Binds positional arguments and returns a new function:
/// https://en.wikipedia.org/wiki/Partial_application
library;

import 'mapping.dart';

extension Partial1<T1, R> on Map1<T1, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map0<R> bind0(T1 arg1) => () => this(arg1);
}

extension Partial2<T1, T2, R> on Map2<T1, T2, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map1<T2, R> bind0(T1 arg1) => (T2 arg2) => this(arg1, arg2);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map1<T1, R> bind1(T2 arg2) => (T1 arg1) => this(arg1, arg2);
}

extension Partial3<T1, T2, T3, R> on Map3<T1, T2, T3, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map2<T2, T3, R> bind0(T1 arg1) =>
      (T2 arg2, T3 arg3) => this(arg1, arg2, arg3);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map2<T1, T3, R> bind1(T2 arg2) =>
      (T1 arg1, T3 arg3) => this(arg1, arg2, arg3);

  /// Returns a new function with the 2nd argument bound to `arg2`.
  Map2<T1, T2, R> bind2(T3 arg3) =>
      (T1 arg1, T2 arg2) => this(arg1, arg2, arg3);
}

extension Partial4<T1, T2, T3, T4, R> on Map4<T1, T2, T3, T4, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map3<T2, T3, T4, R> bind0(T1 arg1) =>
      (T2 arg2, T3 arg3, T4 arg4) => this(arg1, arg2, arg3, arg4);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map3<T1, T3, T4, R> bind1(T2 arg2) =>
      (T1 arg1, T3 arg3, T4 arg4) => this(arg1, arg2, arg3, arg4);

  /// Returns a new function with the 2nd argument bound to `arg2`.
  Map3<T1, T2, T4, R> bind2(T3 arg3) =>
      (T1 arg1, T2 arg2, T4 arg4) => this(arg1, arg2, arg3, arg4);

  /// Returns a new function with the 3rd argument bound to `arg3`.
  Map3<T1, T2, T3, R> bind3(T4 arg4) =>
      (T1 arg1, T2 arg2, T3 arg3) => this(arg1, arg2, arg3, arg4);
}

extension Partial5<T1, T2, T3, T4, T5, R> on Map5<T1, T2, T3, T4, T5, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map4<T2, T3, T4, T5, R> bind0(T1 arg1) =>
      (T2 arg2, T3 arg3, T4 arg4, T5 arg5) =>
          this(arg1, arg2, arg3, arg4, arg5);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map4<T1, T3, T4, T5, R> bind1(T2 arg2) =>
      (T1 arg1, T3 arg3, T4 arg4, T5 arg5) =>
          this(arg1, arg2, arg3, arg4, arg5);

  /// Returns a new function with the 2nd argument bound to `arg2`.
  Map4<T1, T2, T4, T5, R> bind2(T3 arg3) =>
      (T1 arg1, T2 arg2, T4 arg4, T5 arg5) =>
          this(arg1, arg2, arg3, arg4, arg5);

  /// Returns a new function with the 3rd argument bound to `arg3`.
  Map4<T1, T2, T3, T5, R> bind3(T4 arg4) =>
      (T1 arg1, T2 arg2, T3 arg3, T5 arg5) =>
          this(arg1, arg2, arg3, arg4, arg5);

  /// Returns a new function with the 4th argument bound to `arg4`.
  Map4<T1, T2, T3, T4, R> bind4(T5 arg5) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4) =>
          this(arg1, arg2, arg3, arg4, arg5);
}

extension Partial6<T1, T2, T3, T4, T5, T6, R>
    on Map6<T1, T2, T3, T4, T5, T6, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map5<T2, T3, T4, T5, T6, R> bind0(T1 arg1) =>
      (T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map5<T1, T3, T4, T5, T6, R> bind1(T2 arg2) =>
      (T1 arg1, T3 arg3, T4 arg4, T5 arg5, T6 arg6) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6);

  /// Returns a new function with the 2nd argument bound to `arg2`.
  Map5<T1, T2, T4, T5, T6, R> bind2(T3 arg3) =>
      (T1 arg1, T2 arg2, T4 arg4, T5 arg5, T6 arg6) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6);

  /// Returns a new function with the 3rd argument bound to `arg3`.
  Map5<T1, T2, T3, T5, T6, R> bind3(T4 arg4) =>
      (T1 arg1, T2 arg2, T3 arg3, T5 arg5, T6 arg6) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6);

  /// Returns a new function with the 4th argument bound to `arg4`.
  Map5<T1, T2, T3, T4, T6, R> bind4(T5 arg5) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T6 arg6) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6);

  /// Returns a new function with the 5th argument bound to `arg5`.
  Map5<T1, T2, T3, T4, T5, R> bind5(T6 arg6) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6);
}

extension Partial7<T1, T2, T3, T4, T5, T6, T7, R>
    on Map7<T1, T2, T3, T4, T5, T6, T7, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map6<T2, T3, T4, T5, T6, T7, R> bind0(T1 arg1) =>
      (T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map6<T1, T3, T4, T5, T6, T7, R> bind1(T2 arg2) =>
      (T1 arg1, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7);

  /// Returns a new function with the 2nd argument bound to `arg2`.
  Map6<T1, T2, T4, T5, T6, T7, R> bind2(T3 arg3) =>
      (T1 arg1, T2 arg2, T4 arg4, T5 arg5, T6 arg6, T7 arg7) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7);

  /// Returns a new function with the 3rd argument bound to `arg3`.
  Map6<T1, T2, T3, T5, T6, T7, R> bind3(T4 arg4) =>
      (T1 arg1, T2 arg2, T3 arg3, T5 arg5, T6 arg6, T7 arg7) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7);

  /// Returns a new function with the 4th argument bound to `arg4`.
  Map6<T1, T2, T3, T4, T6, T7, R> bind4(T5 arg5) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T6 arg6, T7 arg7) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7);

  /// Returns a new function with the 5th argument bound to `arg5`.
  Map6<T1, T2, T3, T4, T5, T7, R> bind5(T6 arg6) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T7 arg7) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7);

  /// Returns a new function with the 6th argument bound to `arg6`.
  Map6<T1, T2, T3, T4, T5, T6, R> bind6(T7 arg7) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7);
}

extension Partial8<T1, T2, T3, T4, T5, T6, T7, T8, R>
    on Map8<T1, T2, T3, T4, T5, T6, T7, T8, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map7<T2, T3, T4, T5, T6, T7, T8, R> bind0(T1 arg1) =>
      (T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map7<T1, T3, T4, T5, T6, T7, T8, R> bind1(T2 arg2) =>
      (T1 arg1, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);

  /// Returns a new function with the 2nd argument bound to `arg2`.
  Map7<T1, T2, T4, T5, T6, T7, T8, R> bind2(T3 arg3) =>
      (T1 arg1, T2 arg2, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);

  /// Returns a new function with the 3rd argument bound to `arg3`.
  Map7<T1, T2, T3, T5, T6, T7, T8, R> bind3(T4 arg4) =>
      (T1 arg1, T2 arg2, T3 arg3, T5 arg5, T6 arg6, T7 arg7, T8 arg8) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);

  /// Returns a new function with the 4th argument bound to `arg4`.
  Map7<T1, T2, T3, T4, T6, T7, T8, R> bind4(T5 arg5) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T6 arg6, T7 arg7, T8 arg8) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);

  /// Returns a new function with the 5th argument bound to `arg5`.
  Map7<T1, T2, T3, T4, T5, T7, T8, R> bind5(T6 arg6) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T7 arg7, T8 arg8) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);

  /// Returns a new function with the 6th argument bound to `arg6`.
  Map7<T1, T2, T3, T4, T5, T6, T8, R> bind6(T7 arg7) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T8 arg8) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);

  /// Returns a new function with the 7th argument bound to `arg7`.
  Map7<T1, T2, T3, T4, T5, T6, T7, R> bind7(T8 arg8) =>
      (T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7) =>
          this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8);
}

extension Partial9<T1, T2, T3, T4, T5, T6, T7, T8, T9, R>
    on Map9<T1, T2, T3, T4, T5, T6, T7, T8, T9, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map8<T2, T3, T4, T5, T6, T7, T8, T9, R> bind0(T1 arg1) =>
      (
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map8<T1, T3, T4, T5, T6, T7, T8, T9, R> bind1(T2 arg2) =>
      (
        T1 arg1,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);

  /// Returns a new function with the 2nd argument bound to `arg2`.
  Map8<T1, T2, T4, T5, T6, T7, T8, T9, R> bind2(T3 arg3) =>
      (
        T1 arg1,
        T2 arg2,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);

  /// Returns a new function with the 3rd argument bound to `arg3`.
  Map8<T1, T2, T3, T5, T6, T7, T8, T9, R> bind3(T4 arg4) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);

  /// Returns a new function with the 4th argument bound to `arg4`.
  Map8<T1, T2, T3, T4, T6, T7, T8, T9, R> bind4(T5 arg5) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);

  /// Returns a new function with the 5th argument bound to `arg5`.
  Map8<T1, T2, T3, T4, T5, T7, T8, T9, R> bind5(T6 arg6) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T7 arg7,
        T8 arg8,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);

  /// Returns a new function with the 6th argument bound to `arg6`.
  Map8<T1, T2, T3, T4, T5, T6, T8, T9, R> bind6(T7 arg7) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T8 arg8,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);

  /// Returns a new function with the 7th argument bound to `arg7`.
  Map8<T1, T2, T3, T4, T5, T6, T7, T9, R> bind7(T8 arg8) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);

  /// Returns a new function with the 8th argument bound to `arg8`.
  Map8<T1, T2, T3, T4, T5, T6, T7, T8, R> bind8(T9 arg9) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9);
}

extension Partial10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, R>
    on Map10<T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, R> {
  /// Returns a new function with the 0th argument bound to `arg0`.
  Map9<T2, T3, T4, T5, T6, T7, T8, T9, T10, R> bind0(T1 arg1) =>
      (
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 1st argument bound to `arg1`.
  Map9<T1, T3, T4, T5, T6, T7, T8, T9, T10, R> bind1(T2 arg2) =>
      (
        T1 arg1,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 2nd argument bound to `arg2`.
  Map9<T1, T2, T4, T5, T6, T7, T8, T9, T10, R> bind2(T3 arg3) =>
      (
        T1 arg1,
        T2 arg2,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 3rd argument bound to `arg3`.
  Map9<T1, T2, T3, T5, T6, T7, T8, T9, T10, R> bind3(T4 arg4) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 4th argument bound to `arg4`.
  Map9<T1, T2, T3, T4, T6, T7, T8, T9, T10, R> bind4(T5 arg5) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 5th argument bound to `arg5`.
  Map9<T1, T2, T3, T4, T5, T7, T8, T9, T10, R> bind5(T6 arg6) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T7 arg7,
        T8 arg8,
        T9 arg9,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 6th argument bound to `arg6`.
  Map9<T1, T2, T3, T4, T5, T6, T8, T9, T10, R> bind6(T7 arg7) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T8 arg8,
        T9 arg9,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 7th argument bound to `arg7`.
  Map9<T1, T2, T3, T4, T5, T6, T7, T9, T10, R> bind7(T8 arg8) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T9 arg9,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 8th argument bound to `arg8`.
  Map9<T1, T2, T3, T4, T5, T6, T7, T8, T10, R> bind8(T9 arg9) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T10 arg10,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);

  /// Returns a new function with the 9th argument bound to `arg9`.
  Map9<T1, T2, T3, T4, T5, T6, T7, T8, T9, R> bind9(T10 arg10) =>
      (
        T1 arg1,
        T2 arg2,
        T3 arg3,
        T4 arg4,
        T5 arg5,
        T6 arg6,
        T7 arg7,
        T8 arg8,
        T9 arg9,
      ) => this(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
}
