/// Function type for generic predicate functions.
library predicate;

/// Predicate function type with 0 positional arguments.
typedef Predicate0 = bool Function();

/// Predicate function type with 1 positional argument.
typedef Predicate1<T0> = bool Function(T0 arg0);

/// Predicate function type with 2 positional arguments.
typedef Predicate2<T0, T1> = bool Function(T0 arg0, T1 arg1);

/// Predicate function type with 3 positional arguments.
typedef Predicate3<T0, T1, T2> = bool Function(T0 arg0, T1 arg1, T2 arg2);

/// Predicate function type with 4 positional arguments.
typedef Predicate4<T0, T1, T2, T3> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3);

/// Predicate function type with 5 positional arguments.
typedef Predicate5<T0, T1, T2, T3, T4> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4);

/// Predicate function type with 6 positional arguments.
typedef Predicate6<T0, T1, T2, T3, T4, T5> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5);

/// Predicate function type with 7 positional arguments.
typedef Predicate7<T0, T1, T2, T3, T4, T5, T6> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6);

/// Predicate function type with 8 positional arguments.
typedef Predicate8<T0, T1, T2, T3, T4, T5, T6, T7> = bool Function(
    T0 arg0, T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7);

/// Predicate function type with 9 positional arguments.
typedef Predicate9<T0, T1, T2, T3, T4, T5, T6, T7, T8> = bool Function(T0 arg0,
    T1 arg1, T2 arg2, T3 arg3, T4 arg4, T5 arg5, T6 arg6, T7 arg7, T8 arg8);

/// Predicate function type with 10 positional arguments.
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
