
import 'package:flutter/material.dart';

class GameItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;

  GameItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });
}