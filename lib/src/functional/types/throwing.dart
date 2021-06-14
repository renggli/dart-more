// ignore_for_file: only_throw_errors

/// The throwing functions.
import 'mapping.dart';

/// Throwing function with 0 arguments.
Map0<R> throwFunction0<R>(Object throwable) => () => throw throwable;

/// Throwing function with 1 argument.
Map1<T0, R> throwFunction1<T0, R>(Object throwable) =>
    (arg0) => throw throwable;

/// Throwing function with 2 arguments.
Map2<T0, T1, R> throwFunction2<T0, T1, R>(Object throwable) =>
    (arg0, arg1) => throw throwable;

/// Throwing function with 3 arguments.
Map3<T0, T1, T2, R> throwFunction3<T0, T1, T2, R>(Object throwable) =>
    (arg0, arg1, arg2) => throw throwable;

/// Throwing function with 4 arguments.
Map4<T0, T1, T2, T3, R> throwFunction4<T0, T1, T2, T3, R>(Object throwable) =>
    (arg0, arg1, arg2, arg3) => throw throwable;

/// Throwing function with 5 arguments.
Map5<T0, T1, T2, T3, T4, R> throwFunction5<T0, T1, T2, T3, T4, R>(
        Object throwable) =>
    (arg0, arg1, arg2, arg3, arg4) => throw throwable;

/// Throwing function with 6 arguments.
Map6<T0, T1, T2, T3, T4, T5, R> throwFunction6<T0, T1, T2, T3, T4, T5, R>(
        Object throwable) =>
    (arg0, arg1, arg2, arg3, arg4, arg5) => throw throwable;

/// Throwing function with 7 arguments.
Map7<T0, T1, T2, T3, T4, T5, T6, R>
    throwFunction7<T0, T1, T2, T3, T4, T5, T6, R>(Object throwable) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6) => throw throwable;

/// Throwing function with 8 arguments.
Map8<T0, T1, T2, T3, T4, T5, T6, T7, R>
    throwFunction8<T0, T1, T2, T3, T4, T5, T6, T7, R>(Object throwable) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7) => throw throwable;

/// Throwing function with 9 arguments.
Map9<T0, T1, T2, T3, T4, T5, T6, T7, T8, R>
    throwFunction9<T0, T1, T2, T3, T4, T5, T6, T7, T8, R>(Object throwable) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) =>
            throw throwable;

/// Throwing function with 10 arguments.
Map10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, R>
    throwFunction10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, R>(
            Object throwable) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) =>
            throw throwable;
