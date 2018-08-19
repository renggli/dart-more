library more.printer.utils;

T checkNumericType<T>(Object object, T nativeCallback(num value),
    T bigIntCallback(BigInt value)) {
  if (object is num) {
    return nativeCallback(object);
  } else if (object is BigInt) {
    return bigIntCallback(object);
  } else {
    throw ArgumentError.value(object, ' is not a numeric type.');
  }
}
