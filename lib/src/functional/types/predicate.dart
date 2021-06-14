/// Function type for generic predicate functions.

/// Function predicate with 0 arguments.
typedef Predicate0 = bool Function();

/// Function predicate with 1 argument.
typedef Predicate1<T0> = bool Function(T0 arg0);

/// Function predicate with 2 arguments.
typedef Predicate2<T0, T1> = bool Function(T0 arg0, T1 arg1);

/// Function predicate with 3 arguments.
typedef Predicate3<T0, T1, T2> = bool Function(T0 arg0, T1 arg1, T2 arg2);

/// Function predicate with 4 arguments.
typedef Predicate4<T0, T1, T2, T3> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3);

/// Function predicate with 5 arguments.
typedef Predicate5<T0, T1, T2, T3, T4> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4);

/// Function predicate with 6 arguments.
typedef Predicate6<T0, T1, T2, T3, T4, T5> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5);

/// Function predicate with 7 arguments.
typedef Predicate7<T0, T1, T2, T3, T4, T5, T6> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6);

/// Function predicate with 8 arguments.
typedef Predicate8<T0, T1, T2, T3, T4, T5, T6, T7> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7);

/// Function predicate with 9 arguments.
typedef Predicate9<T0, T1, T2, T3, T4, T5, T6, T7, T8> = bool Function(T0 arg0,
    T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8);

/// Function predicate with 10 arguments.
typedef Predicate10<T0, T1, T2, T3, T4, T5, T6, T7, T8, T9> = bool Function(
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
