import 'package:flutter/material.dart';

SnackBar reUsableSnackBar(message, context) {
  return SnackBar(
      content: Text('$message'),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 5),
      duration: const Duration(seconds: 3),
    );
}
