import 'dart:async';

typedef FutureQueueFunc = Future<dynamic> Function();

/// 异步队列
class _FutureQueueItem {
  final FutureQueueFunc func;
  final Function(dynamic result)? callback;

  _FutureQueueItem(this.func, {this.callback});
}

class FutureQueenUtil {
  final StreamController<_FutureQueueItem> _futureQueue =
      StreamController<_FutureQueueItem>(sync: true);

  StreamSubscription? _subscription;

  void init() {
    _onListen();
  }

  void dispose() {
    _cancel();
  }

  void add(
    FutureQueueFunc func, {
    Function(dynamic result)? callback,
  }) {
    _futureQueue.sink.add(
      _FutureQueueItem(func, callback: callback),
    );
  }

  void _onListen() {
    _cancel();
    _subscription = _futureQueue.stream.asyncMap(
      (event) async {
        final result = await event.func();
        if (event.callback != null) {
          event.callback!(result);
        }
        return true;
      },
    ).listen(null);
  }

  void _cancel() {
    _subscription?.cancel();
    _subscription = null;
  }
}
