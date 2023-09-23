/// Function types for generic callbacks.
library callback;

/// Callback function type with 0 positional arguments.
typedef Callback0 = void Function();

/// Callback function type with 1 positional argument.
typedef Callback1<T0> = void Function(T0 arg0);

/// Callback function type with 2 positional arguments.
typedef Callback2<T0, T1> = void Function(T0 arg0, T1 arg1);

/// Callback function type with 3 positional arguments.
typedef Callback3<T0, T1, T2> = void Function(T0 arg0, T1 arg1, T2 arg2);

/// Callback function type with 4 positional arguments.
typedef Callback4<T0, T1, T2, T3> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3);

/// Callback function type with 5 positional arguments.
typedef Callback5<T0, T1, T2, T3, T4> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4);

/// Callback function type with 6 positional arguments.
typedef Callback6<T0, T1, T2, T3, T4, T5> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5);

/// Callback function type with 7 positional arguments.
typedef Callback7<T0, T1, T2, T3, T4, T5, T6> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6);

/// Callback function type with 8 positional arguments.
typedef Callback8<T0, T1, T2, T3, T4, T5, T6, T7> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7);

/// Callback function type with 9 positional arguments.
typedef Callback9<T0, T1, T2, T3, T4, T5, T6, T7, T8> = void Function(T0 arg0,
    T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8);

/// Callback function type with 10 positional arguments.
typedef Callback10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> = void Function(
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
