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
    Stream? trigger,
    int? maxLength,
    Duration? maxAge,
  }) {
    final buffer = <E>[];
    final controller = isBroadcast
        ? StreamController<List<E>>.broadcast()
        : StreamController<List<E>>();
    StreamSubscription<E>? sourceSubscription;
    StreamSubscription? triggerSubscription;
    DateTime? nextUpdate;

    // Helper functions for state management.
    void adjustNextUpdate() {
      if (maxAge != null) {
        nextUpdate = DateTime.now().add(maxAge);
      }
    }

    void flush() {
      if (buffer.isNotEmpty) {
        controller.add(buffer.toList(growable: false));
        buffer.clear();
        adjustNextUpdate();
      }
    }

    void maybeFlush() {
      bool hasMaxLength() => maxLength != null && buffer.length >= maxLength;
      bool hasMaxAge() => nextUpdate?.isBefore(DateTime.now()) ?? false;
      if (hasMaxLength() || hasMaxAge()) {
        flush();
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
      adjustNextUpdate();
      sourceSubscription =
          listen(onSourceData, onError: onSourceError, onDone: onSourceDone);
      triggerSubscription = trigger?.listen(onTriggerData,
          onError: onTriggerError, onDone: onTriggerDone);
    };
    controller.onPause = () {
      sourceSubscription?.pause();
      triggerSubscription?.pause();
    };
    controller.onResume = () {
      sourceSubscription?.resume();
      triggerSubscription?.resume();
    };
    controller.onCancel = () {
      sourceSubscription?.cancel();
      triggerSubscription?.cancel();
    };
    return controller.stream;
  }
}
