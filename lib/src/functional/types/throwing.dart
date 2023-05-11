/// The throwing functions.
import 'mapping.dart';

/// Throwing function with 0 positional arguments.
Map0<Never> throwFunction0(Object throwable) => () => throw throwable;

/// Throwing function with 1 positional argument.
Map1<T0, Never> throwFunction1<T0>(Object throwable) =>
    (arg0) => throw throwable;

/// Throwing function with 2 positional arguments.
Map2<T0, T1, Never> throwFunction2<T0, T1>(Object throwable) =>
    (arg0, arg1) => throw throwable;

/// Throwing function with 3 positional arguments.
Map3<T0, T1, T2, Never> throwFunction3<T0, T1, T2>(Object throwable) =>
    (arg0, arg1, arg2) => throw throwable;

/// Throwing function with 4 positional arguments.
Map4<T0, T1, T2, T3, Never> throwFunction4<T0, T1, T2, T3>(Object throwable) =>
    (arg0, arg1, arg2, arg3) => throw throwable;

/// Throwing function with 5 positional arguments.
Map5<T0, T1, T2, T3, T4, Never> throwFunction5<T0, T1, T2, T3, T4>(
        Object throwable) =>
    (arg0, arg1, arg2, arg3, arg4) => throw throwable;

/// Throwing function with 6 positional arguments.
Map6<T0, T1, T2, T3, T4, T5, Never> throwFunction6<T0, T1, T2, T3, T4, T5>(
        Object throwable) =>
    (arg0, arg1, arg2, arg3, arg4, arg5) => throw throwable;

/// Throwing function with 7 positional arguments.
Map7<T0, T1, T2, T3, T4, T5, T6, Never>
    throwFunction7<T0, T1, T2, T3, T4, T5, T6>(Object throwable) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6) => throw throwable;

/// Throwing function with 8 positional arguments.
Map8<T0, T1, T2, T3, T4, T5, T6, T7, Never>
    throwFunction8<T0, T1, T2, T3, T4, T5, T6, T7>(Object throwable) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7) => throw throwable;

/// Throwing function with 9 positional arguments.
Map9<T0, T1, T2, T3, T4, T5, T6, T7, T8, Never>
    throwFunction9<T0, T1, T2, T3, T4, T5, T6, T7, T8>(Object throwable) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8) =>
            throw throwable;

/// Throwing function with 10 positional arguments.
Map10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, Never>
    throwFunction10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9>(Object throwable) =>
        (arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9) =>
            throw throwable;
