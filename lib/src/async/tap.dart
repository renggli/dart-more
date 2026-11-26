import 'dart:async';

/// Extension on [Stream] providing tapping operations for side-effects.
extension TapExtension<E> on Stream<E> {
  /// Transparently performs side-effects on the events of a [Stream], for
  /// things such as logging or debugging.
  Stream<E> tap({
    void Function()? onListen,
    void Function()? onPause,
    void Function()? onResume,
    void Function(E element)? onData,
    void Function(Object error, [StackTrace? stackTrace])? onError,
    void Function()? onCancel,
    void Function()? onDone,
  }) {
    final controller = isBroadcast
        ? StreamController<E>.broadcast()
        : StreamController<E>();
    StreamSubscription<E>? subscription;

    void dispatchOnData(E element) {
      onData?.call(element);
      if (!controller.isClosed) {
        controller.add(element);
      }
    }

    void dispatchOnError(Object error, [StackTrace? stackTrace]) {
      onError?.call(error, stackTrace);
      if (!controller.isClosed) {
        controller.addError(error, stackTrace);
      }
    }

    void dispatchOnDone() {
      try {
        onDone?.call();
      } finally {
        if (!controller.isClosed) {
          controller.close();
        }
      }
    }

    controller.onListen = () {
      onListen?.call();
      subscription = listen(
        dispatchOnData,
        onError: dispatchOnError,
        onDone: dispatchOnDone,
      );
    };
    if (!isBroadcast) {
      controller.onPause = () {
        try {
          onPause?.call();
        } finally {
          subscription?.pause();
        }
      };
      controller.onResume = () {
        try {
          onResume?.call();
        } finally {
          subscription?.resume();
        }
      };
    }
    controller.onCancel = () async {
      final sub = subscription;
      subscription = null;
      try {
        onCancel?.call();
      } finally {
        await sub?.cancel();
      }
    };

    return controller.stream;
  }
}
