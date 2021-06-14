/// Function type for generic mapping functions.

/// Function callback with 0 arguments.
typedef Map0<R> = R Function();

/// Function callback with 1 argument.
typedef Map1<T0, R> = R Function(T0 arg0);

/// Function callback with 2 arguments.
typedef Map2<T0, T1, R> = R Function(T0 arg0, T1 arg1);

/// Function callback with 3 arguments.
typedef Map3<T0, T1, T2, R> = R Function(T0 arg0, T1 arg1, T2 arg2);

/// Function callback with 4 arguments.
typedef Map4<T0, T1, T2, T3, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3);

/// Function callback with 5 arguments.
typedef Map5<T0, T1, T2, T3, T4, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4);

/// Function callback with 6 arguments.
typedef Map6<T0, T1, T2, T3, T4, T5, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5);

/// Function callback with 7 arguments.
typedef Map7<T0, T1, T2, T3, T4, T5, T6, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6);

/// Function callback with 8 arguments.
typedef Map8<T0, T1, T2, T3, T4, T5, T6, T7, R> = R Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7);

/// Function callback with 9 arguments.
typedef Map9<T0, T1, T2, T3, T4, T5, T6, T7, T8, R> = R Function(T0 arg0,
    T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8);

/// Function callback with 10 arguments.
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
