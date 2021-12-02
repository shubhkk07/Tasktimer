import 'dart:async';
import 'package:flutter/material.dart';

class TaskTimer extends StatefulWidget {
  final String taskDuration;
  final int status;
  final Function onTimerEnd;
  const TaskTimer(
      {Key? key,
      required this.taskDuration,
      required this.status,
      required this.onTimerEnd})
      : super(key: key);

  @override
  _TaskTimerState createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  countdownDuration() {
    final taskDuration = widget.taskDuration.replaceAll(' mins', '');
    final result = taskDuration.split(':');
    return Duration(
        minutes: int.parse(result[0]), seconds: int.parse(result[1]));
  }

  Duration duration = Duration();
  Timer? timer;

  bool countDown = true;

  // ignore: prefer_typing_uninitialized_variables
  var isRunning;
  // ignore: prefer_typing_uninitialized_variables
  var isCompleted;

  @override
  void initState() {
    super.initState();
    reset();
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration());
    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        widget.onTimerEnd(1);
      } else {
        widget.onTimerEnd(2);
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    isRunning = timer == null ? false : timer!.isActive;
    isCompleted = duration.inSeconds == 0;
    return widget.status != 1
        ? SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: isRunning || isCompleted
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.pause),
                          onPressed: () {
                            if (isRunning) {
                              stopTimer(resets: false);
                            }
                          }),
                      displayWidget(),
                      IconButton(
                          color: Colors.white,
                          icon: const Icon(Icons.stop),
                          onPressed: () {
                            widget.onTimerEnd(0);
                            stopTimer();
                          }),
                    ],
                  )
                : Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: const Icon(Icons.play_arrow),
                        color: Colors.white,
                        onPressed: () {
                          startTimer();
                        }),
                  ))
        : Text(
            'COMPLETED',
            style: Theme.of(context).textTheme.caption,
          );
  }

  displayWidget() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        minutes,
        style: Theme.of(context).textTheme.caption,
      ),
      SizedBox(
        width: 8,
        child: Text(
          ' :',
          style: Theme.of(context).textTheme.caption,
        ),
      ),
      Text(
        seconds,
        style: Theme.of(context).textTheme.caption,
      ),
      const SizedBox(
        width: 8,
      ),
    ]);
  }
}
