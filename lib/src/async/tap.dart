import 'dart:async';

typedef Callback = void Function();
typedef DataCallback<E> = void Function(E element);
typedef ErrorCallback = void Function(Object error, [StackTrace stackTrace]);

extension TapExtension<E> on Stream<E> {
  /// Transparently perform side-effects on the events of a [Stream], for
  /// things such as logging or debugging.
  Stream<E> tap({
    Callback onListen,
    Callback onPause,
    Callback onResume,
    DataCallback<E> onData,
    ErrorCallback onError,
    Callback onCancel,
    Callback onDone,
  }) {
    final controller =
        isBroadcast ? StreamController<E>.broadcast() : StreamController<E>();
    StreamSubscription<E> subscription;
    controller.onListen = () {
      onListen?.call();
      subscription = listen(
        (element) {
          onData?.call(element);
          controller.add(element);
        },
        onError: (error, stackTrace) {
          onError?.call(error, stackTrace);
          controller.addError(error, stackTrace);
          subscription?.cancel();
        },
        onDone: () {
          onDone?.call();
          controller.close();
          subscription?.cancel();
        },
      );
    };
    controller.onPause = () {
      onPause?.call();
      subscription?.pause();
    };
    controller.onResume = () {
      onResume?.call();
      subscription?.resume();
    };
    controller.onCancel = () async {
      onCancel?.call();
      await subscription?.cancel();
    };
    return controller.stream;
  }
}
