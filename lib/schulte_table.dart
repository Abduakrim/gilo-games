import 'dart:async';

import 'package:flutter/material.dart';

class SchulteTable extends StatefulWidget {
  const SchulteTable({super.key});

  @override
  State<SchulteTable> createState() => _SchulteTableState();
}

class _SchulteTableState extends State<SchulteTable> {
  List<int>? nums;
  int nextNumber = 1;
  Timer? timer;
  DateTime? startTime;

  int dimension = 3;
  List<int> generateNumbers(int dimension) {
    int total = dimension * dimension;
    final list = List.generate(total, (i) => i + 1);
    list.shuffle();
    return list;
  }

  void startTimer() {
    startTime ??= DateTime.now();
    timer ??= Timer.periodic(Duration(milliseconds: 50), (_) {
      setState(() {});
    });
  }

  void resetGame() {
    stopTimer();
    startTime = null;
    nextNumber = 1;
    nums = generateNumbers(dimension);
    setState(() {});
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  int get totalCells => dimension * dimension;
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
    nums = generateNumbers(dimension);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.restart_alt),
        onPressed: () {
          resetGame();
        },
      ),
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 150,
            child: PopupMenuButton(
              child: Text(dimension.toString()),
              onSelected: (value) {
                dimension = value;
                resetGame();
              },

              itemBuilder: (context) => [
                PopupMenuItem(value: 3, child: Text('3x3')),
                PopupMenuItem(value: 4, child: Text('4x4')),
                PopupMenuItem(value: 5, child: Text('5x5')),
              ],
            ),
          ),
        ],
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(nextNumber.toString(), style: TextStyle(fontSize: 40)),
            SizedBox(width: 15),
            Text(elapsedTime),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: SizedBox(
            width: 500,

            child: GridView.builder(
              itemCount: totalCells,
              itemBuilder: (context, index) {
                final number = nums![index];
                return GestureDetector(
                  onTap: () {
                    if (number == nextNumber) {
                      if (nextNumber == 1) startTimer();

                      setState(() {
                        nextNumber++;
                      });
                    }
                    if (nextNumber > totalCells) {
                      stopTimer();
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black),
                    ),
                    child: Text(
                      nums![index].toString(),
                      style: TextStyle(fontSize: 40),
                    ),
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: dimension,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
