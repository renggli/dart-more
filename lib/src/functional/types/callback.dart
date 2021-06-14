/// Function types for generic callbacks.

/// Function callback with 0 arguments.
typedef Callback0 = void Function();

/// Function callback with 1 argument.
typedef Callback1<T0> = void Function(T0 arg0);

/// Function callback with 2 arguments.
typedef Callback2<T0, T1> = void Function(T0 arg0, T1 arg1);

/// Function callback with 3 arguments.
typedef Callback3<T0, T1, T2> = void Function(T0 arg0, T1 arg1, T2 arg2);

/// Function callback with 4 arguments.
typedef Callback4<T0, T1, T2, T3> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3);

/// Function callback with 5 arguments.
typedef Callback5<T0, T1, T2, T3, T4> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4);

/// Function callback with 6 arguments.
typedef Callback6<T0, T1, T2, T3, T4, T5> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5);

/// Function callback with 7 arguments.
typedef Callback7<T0, T1, T2, T3, T4, T5, T6> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6);

/// Function callback with 8 arguments.
typedef Callback8<T0, T1, T2, T3, T4, T5, T6, T7> = void Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7);

/// Function callback with 9 arguments.
typedef Callback9<T0, T1, T2, T3, T4, T5, T6, T7, T8> = void Function(T0 arg0,
    T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8);

/// Function callback with 10 arguments.
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
