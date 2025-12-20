import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ReactionTime extends StatefulWidget {
  const ReactionTime({super.key});

  @override
  State<ReactionTime> createState() => _ReactionTimeState();
}

class _ReactionTimeState extends State<ReactionTime> {
  ReactionState state = ReactionState.idle;
  Timer? waitTimer;
  DateTime? greenTime;
  int reactionMs = 0;

  void startGame() {
    state = ReactionState.waiting;

    final delay = 2000 + Random().nextInt(3000);
    waitTimer = Timer(Duration(milliseconds: delay), () {
      state = ReactionState.ready;
      greenTime = DateTime.now();
      setState(() {});
    });

    setState(() {});
  }

  void handleTap() {
    if (state == ReactionState.waiting) {
      waitTimer?.cancel();
      state = ReactionState.tooSoon;
    } else if (state == ReactionState.ready) {
      reactionMs = DateTime.now().difference(greenTime!).inMilliseconds;
      state = ReactionState.finished;
    } else {
      startGame();
    }

    setState(() {});
  }

  Color get backgroundColor {
    switch (state) {
      case ReactionState.waiting:
        return Colors.red;
      case ReactionState.ready:
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  String get message {
    switch (state) {
      case ReactionState.idle:
        return 'Tap to start';
      case ReactionState.waiting:
        return 'Wait for green...';
      case ReactionState.ready:
        return 'TAP!';
      case ReactionState.finished:
        return 'Reaction: $reactionMs ms\nTap to retry';
      case ReactionState.tooSoon:
        return 'Too soon!\nTap to retry';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: backgroundColor),
      body: GestureDetector(
        onTap: handleTap,
        child: Container(
          color: backgroundColor,
          alignment: Alignment.center,
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

enum ReactionState { idle, waiting, ready, finished, tooSoon }
