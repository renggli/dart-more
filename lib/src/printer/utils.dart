T checkNumericType<T>(Object? object, T Function(num value) nativeCallback,
    T Function(BigInt value) bigIntCallback) {
  if (object is num) {
    return nativeCallback(object);
  } else if (object is BigInt) {
    return bigIntCallback(object);
  } else {
    throw ArgumentError.value(object, ' is not a numeric type.');
  }
}
