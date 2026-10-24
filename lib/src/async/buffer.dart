import 'dart:async';

/// Extension on [Stream] providing buffering operations.
extension BufferExtension<E> on Stream<E> {
  /// Gathers the elements of this [Stream] and bundles the items into a [List]
  /// until either:
  ///
  /// - The [trigger] stream emits an event.
  /// - The buffer reaches [maxLength] elements.
  /// - The buffer reaches [maxAge] duration.
  ///
  /// If none of the arguments are given, the stream will buffer results until
  /// the source stream completes.
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
      maxAgeTimer?.cancel();
      maxAgeTimer = null;
      if (buffer.isNotEmpty && !controller.isClosed) {
        controller.add(buffer.toList(growable: false));
        buffer.clear();
      }
    }

    void maybeFlush() {
      if (maxLength != null && buffer.length >= maxLength) {
        flush();
      } else if (maxAge != null && maxAgeTimer == null && buffer.isNotEmpty) {
        maxAgeTimer = Timer(maxAge, flush);
      }
    }

    void cleanup() {
      // Defensive cleanup; flush() always precedes cleanup() in close() and nulls maxAgeTimer.
      maxAgeTimer?.cancel(); // coverage:ignore-line
      maxAgeTimer = null;
      sourceSubscription?.cancel();
      sourceSubscription = null;
      triggerSubscription?.cancel();
      triggerSubscription = null;
    }

    void close() {
      if (!controller.isClosed) {
        flush();
        cleanup();
        controller.close();
      }
    }

    // Handling of the trigger stream.
    void onTriggerData(value) {
      if (!controller.isClosed) {
        flush();
      }
    }

    void onTriggerError(Object error, StackTrace stackTrace) {
      if (!controller.isClosed) {
        controller.addError(error, stackTrace);
      }
    }

    void onTriggerDone() {
      close();
    }

    // Handling of the source stream.
    void onSourceData(E value) {
      if (!controller.isClosed) {
        buffer.add(value);
        maybeFlush();
      }
    }

    void onSourceError(Object error, StackTrace stackTrace) {
      if (!controller.isClosed) {
        controller.addError(error, stackTrace);
      }
    }

    void onSourceDone() {
      close();
    }

    // Setup the resulting stream controller.
    controller.onListen = () {
      sourceSubscription = listen(
        onSourceData,
        onError: onSourceError,
        onDone: onSourceDone,
      );
      triggerSubscription = trigger?.listen(
        onTriggerData,
        onError: onTriggerError,
        onDone: onTriggerDone,
      );
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
