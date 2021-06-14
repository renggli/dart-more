/// The constant functions.

import 'mapping.dart';

/// Constant function with 0 arguments.
Map0<R> constantFunction0<R>(R value) => () => value;

/// Constant function with 1 argument.
Map1<T0, R> constantFunction1<T0, R>(R value) => (arg0) => value;

/// Constant function with 2 arguments.
Map2<T0, T1, R> constantFunction2<T0, T1, R>(R value) => (arg0, arg1) => value;

/// Constant function with 3 arguments.
Map3<T0, T1, T2, R> constantFunction3<T0, T1, T2, R>(R value) =>
    (arg0, arg1, arg2) => value;

/// Constant function with 4 arguments.
Map4<T0, T1, T2, T3, R> constantFunction4<T0, T1, T2, T3, R>(R value) =>
    (arg0, arg1, arg2, arg3) => value;

/// Constant function with 5 arguments.
Map5<T0, T1, T2, T3, T4, R> constantFunction5<T0, T1, T2, T3, T4, R>(R value) =>
    (arg0, arg1, arg2, arg3, arg4) => value;

/// Constant function with 6 arguments.
Map6<T0, T1, T2, T3, T4, T5, R> constantFunction6<T0, T1, T2, T3, T4, T5, R>(
        R value) =>
    (arg0, arg1, arg2, arg3, arg4, arg5) => value;

/// Constant function with 7 arguments.
Map7<T0, T1, T2, T3, T4, T5, T6, R>
    constantFunction7<T0, T1, T2, T3, T4, T5, T6, R>(R value) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6) => value;

/// Constant function with 8 arguments.
Map8<T0, T1, T2, T3, T4, T5, T6, T7, R>
    constantFunction8<T0, T1, T2, T3, T4, T5, T6, T7, R>(R value) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7) => value;

/// Constant function with 9 arguments.
Map9<T0, T1, T2, T3, T4, T5, T6, T7, T8, R>
    constantFunction9<T0, T1, T2, T3, T4, T5, T6, T7, T8, R>(R value) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) => value;

/// Constant function with 10 arguments.
Map10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, R>
    constantFunction10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, R>(R value) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) => value;
