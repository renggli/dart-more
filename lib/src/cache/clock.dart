library more.cache.clock;

/// A function to provide the current time.
typedef DateTime Clock();

/// The standard system clock.
DateTime systemClock() => DateTime.now();
