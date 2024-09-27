import 'dart:async';

class LoadingIndicator {
  LoadingIndicator(
      {required this.id,
      this.progress = 0,
      this.isNotProcessing = true,
      this.isConnecting = false,
      this.isCancelled = false,
      this.isStarted = false,
      this.milliseconds = 0,
      this.connectionDuration = 0,
      this.duration = 0,
      this.condition = true});

  void refresh() {
    // GITHUB print('STOP| duration: ' +
        // duration.toString() +
        // ' connection duration: ' +
        // connectionDuration.toString());
    milliseconds = 0;
    duration = 0;
    isNotProcessing = true;
    isConnecting = false;
    progress = 0;
    cancelTimer();
  }

  void startTimer() {
    // GITHUB print('START| duration: ' +
        // duration.toString() +
        // ' connection duration: ' +
        // connectionDuration.toString());
    if (isNotProcessing) {
      isNotProcessing = false;
      timer =
          Timer.periodic(const Duration(milliseconds: 100), (_) => function());
    }
  }

  void cancelTimer() {
    if (timer != null) timer!.cancel();
  }

  void function() {
    milliseconds += 1;
    if (progress >= 1) {
      if (milliseconds - duration > 40) {
        refresh();
      }
    } else {
      progress = (milliseconds + duration / 100) / (duration + duration / 100);
    }
    if (milliseconds > connectionDuration) isConnecting = true;
    if (isNotProcessing || isCancelled) {
      refresh();
    }
  }

  void start(DateTime connectionDurationPart, DateTime durationPart, bool auto,
      bool newCondition) {
    if (auto) condition = newCondition;
    isConnecting = false;
    isNotProcessing = true;
    progress = 0;
    duration = durationPart.difference(DateTime.now()).inSeconds * 10;
    connectionDuration =
        connectionDurationPart.difference(DateTime.now()).inSeconds * 10;
  }

  void toggle(bool shouldStart) {
    if (shouldStart) {
      isStarted = true;
      isCancelled = false;
    } else {
      isStarted = false;
      isCancelled = true;
    }
  }

  int id;
  double progress;
  bool isNotProcessing;
  bool isConnecting;
  bool isCancelled;
  bool isStarted;
  int milliseconds;
  int connectionDuration;
  int duration;
  bool condition;
  Timer? timer;
}
