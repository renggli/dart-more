/// Function type for generic mapping functions.
library mapping;

/// Mapping function type with 0 positional arguments.
typedef Map0<R> = R Function();

/// Mapping function type with 1 positional argument.
typedef Map1<T0, R> = R Function(T0 arg0);

/// Mapping function type with 2 positional arguments.
typedef Map2<T0, T1, R> = R Function(T0 arg0, T1 arg1);

/// Mapping function type with 3 positional arguments.
typedef Map3<T0, T1, T2, R> = R Function(T0 arg0, T1 arg1, T2 arg2);

/// Mapping function type with 4 positional arguments.
typedef Map4<T0, T1, T2, T3, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3);

/// Mapping function type with 5 positional arguments.
typedef Map5<T0, T1, T2, T3, T4, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4);

/// Mapping function type with 6 positional arguments.
typedef Map6<T0, T1, T2, T3, T4, T5, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5);

/// Mapping function type with 7 positional arguments.
typedef Map7<T0, T1, T2, T3, T4, T5, T6, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6);

/// Mapping function type with 8 positional arguments.
typedef Map8<T0, T1, T2, T3, T4, T5, T6, T7, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7);

/// Mapping function type with 9 positional arguments.
typedef Map9<T0, T1, T2, T3, T4, T5, T6, T7, T8, R> = R Function(T0 arg0,
    T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8);

/// Mapping function type with 10 positional arguments.
typedef Map10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9, R> = R Function(
    T0 arg0,
    T1 arg1,
    T2 arg2,
    T3 arg3,
    T4 arg4,
    T5 arg5,
    T6 arg6,
    T7 arg7,
    T8 arg8,
    T9 arg9);
