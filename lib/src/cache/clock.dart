/// A function to provide the current time.
typedef Clock = DateTime Function();

/// The standard system clock.
DateTime systemClock() => DateTime.now();
