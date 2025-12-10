import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  ToastHelper._();

  static void success(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flatColored,      // 👉 sesuai permintaan
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
    );
  }

  static void error(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,      // 👉 style fill colored
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 4),
      alignment: Alignment.topCenter,
    );
  }

  static void info(BuildContext context, String message) {
    toastification.show(
      context: context,
      type: ToastificationType.info,
      style: ToastificationStyle.flatColored,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
    );
  }
}
