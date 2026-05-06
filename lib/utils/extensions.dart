import 'package:flutter/material.dart';

extension ColorExtension on String {
  Color toColor() {
    final hexString = replaceFirst('#', '');
    return Color(int.parse('0xFF$hexString'));
  }
}

extension DateTimeExtension on DateTime {
  String toFormattedString() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      return 'Today at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}';
    } else {
      return '$month/$day/$year at ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} ${hour >= 12 ? 'PM' : 'AM'}';
    }
  }
}
