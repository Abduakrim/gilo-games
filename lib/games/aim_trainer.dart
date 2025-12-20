import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';

class AimTrainer extends StatefulWidget {
  const AimTrainer({super.key});

  @override
  State<AimTrainer> createState() => _AimTrainerState();
}

class _AimTrainerState extends State<AimTrainer>
    with SingleTickerProviderStateMixin {
  int taps = 25;
  static const double targetSize = 100;

  late AnimationController _controller;
  late Animation<double> _scale;

  int currentTaps = 0;
  double? x;
  double? y;

  final Random random = Random();
  bool isAnimating = false;

  Timer? timer;
  DateTime? startTime;

  void generateRandomPosition(Size size) {
    x = random.nextDouble() * (size.width - targetSize);
    y = random.nextDouble() * (size.height - targetSize);
  }

  void startTimer() {
    startTime ??= DateTime.now();
    timer ??= Timer.periodic(
      const Duration(milliseconds: 50),
      (_) =>setState(() {}),
    );
    setState(() {});
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  void resetGame() {
    stopTimer();
    startTime = null;
    currentTaps = 0;
    setState(() {});
  }

  String get elapsedTime {
    if (startTime == null) return '0.000';
    final diff = DateTime.now().difference(startTime!);
    final seconds = diff.inSeconds;
    final milliseconds = diff.inMilliseconds % 1000;
    return '$seconds.${milliseconds.toString().padLeft(3, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> onHit(Size size) async {
    if (isAnimating) return;
    isAnimating = true;

    await _controller.reverse();

    setState(() {
      generateRandomPosition(size);
    });

    await _controller.forward();
    isAnimating = false;
  }

  void showResults() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.black,
        title: const Text("Results", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hits: $currentTaps",
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(
              "Time: $elapsedTime",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              resetGame();
              Navigator.pop(context);
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Size boxSize = Size(screenSize.width * 0.85, screenSize.height * 0.7);

    x = x ?? random.nextDouble() * (boxSize.width - targetSize);
    y = y ?? random.nextDouble() * (boxSize.height - targetSize);

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: boxSize.width,
            height: boxSize.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: x,
                  top: y,
                  child: GestureDetector(
                    onTap: () {
                      onHit(boxSize);

                      if (currentTaps == taps) {
                        showResults();
                        stopTimer();
                      } else {
                        currentTaps += 1;
                      }

                      if (currentTaps == 1) {
                        startTimer();
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _scale,
                      builder: (_, child) {
                        return Transform.scale(
                          scale: _scale.value,
                          child: child,
                        );
                      },
                      child: const _AimTarget(size: targetSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AimTarget extends StatelessWidget {
  final double size;
  const _AimTarget({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _ring(1.0, Colors.redAccent),
          _ring(0.7, Colors.white),
          _ring(0.4, Colors.redAccent),
          _ring(0.15, Colors.white),
        ],
      ),
    );
  }

  Widget _ring(double scale, Color color) {
    return FractionallySizedBox(
      widthFactor: scale,
      heightFactor: scale,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
