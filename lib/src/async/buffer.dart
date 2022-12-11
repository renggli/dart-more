import 'dart:async';

extension BufferExtension<E> on Stream<E> {
  /// Gathers the elements of this [Stream] and bundles the items into a [List]
  /// until either
  ///
  /// - another [Stream] [trigger]s,
  /// - buffer reaches [maxLength], or
  /// - buffer reaches [maxAge].
  ///
  /// If none of the arguments are given, the stream will buffer results until
  /// the source completes.
  Stream<List<E>> buffer({
    Stream<void>? trigger,
    int? maxLength,
    Duration? maxAge,
  }) {
    final buffer = <E>[];
    final controller = isBroadcast
        ? StreamController<List<E>>.broadcast()
        : StreamController<List<E>>();
    StreamSubscription<E>? sourceSubscription;
    StreamSubscription<void>? triggerSubscription;
    Timer? maxAgeTimer;

    // Helper functions for state management.
    void flush() {
      if (buffer.isNotEmpty) {
        maxAgeTimer?.cancel();
        controller.add(buffer.toList(growable: false));
        buffer.clear();
      }
    }

    void maybeFlush() {
      if (maxLength != null && buffer.length >= maxLength) {
        flush();
      } else if (maxAge != null) {
        maxAgeTimer?.cancel();
        if (buffer.isNotEmpty) {
          maxAgeTimer = Timer(maxAge, flush);
        }
      }
    }

    // Handling of the trigger stream.
    void onTriggerData(value) {
      flush();
    }

    void onTriggerError(Object error, StackTrace stackTrace) {
      controller.addError(error, stackTrace);
    }

    void onTriggerDone() {
      flush();
      controller.close();
    }

    // Handling of the source stream.
    void onSourceData(E value) {
      buffer.add(value);
      maybeFlush();
    }

    void onSourceError(Object error, StackTrace stackTrace) {
      controller.addError(error, stackTrace);
    }

    void onSourceDone() {
      flush();
      controller.close();
    }

    // Setup the resulting stream controller.
    controller.onListen = () {
      sourceSubscription =
          listen(onSourceData, onError: onSourceError, onDone: onSourceDone);
      triggerSubscription = trigger?.listen(onTriggerData,
          onError: onTriggerError, onDone: onTriggerDone);
    };
    if (!isBroadcast) {
      controller.onPause = () {
        sourceSubscription?.pause();
        triggerSubscription?.pause();
      };
      controller.onResume = () {
        sourceSubscription?.resume();
        triggerSubscription?.resume();
      };
    }
    controller.onCancel = () async {
      maxAgeTimer?.cancel();
      await sourceSubscription?.cancel();
      await triggerSubscription?.cancel();
    };
    return controller.stream;
  }
}
