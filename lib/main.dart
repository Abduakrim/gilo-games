import 'package:flutter/material.dart';
import 'package:gilo_games/schulte_table.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SchulteTable());
  }
}
