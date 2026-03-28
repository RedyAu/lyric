import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

IconData iconForLogLevel(Level level) {
  if (level.value >= Level.SEVERE.value) {
    return Icons.error_outline;
  }
  if (level.value >= Level.WARNING.value) {
    return Icons.warning_amber_outlined;
  }
  if (level.value >= Level.INFO.value) {
    return Icons.info_outline;
  }
  return Icons.message_outlined;
}

Color colorForLogLevel(Level level) {
  if (level.value >= Level.SEVERE.value) {
    return Colors.red;
  }
  if (level.value >= Level.WARNING.value) {
    return Colors.orange;
  }
  if (level.value >= Level.INFO.value) {
    return Colors.blue;
  }
  return Colors.grey;
}