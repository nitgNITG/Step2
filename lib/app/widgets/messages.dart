import 'package:step/app/core/themes/colors.dart';
import 'package:flutter/material.dart';

bool displaing = false;
void showSnackBar(
  BuildContext context,
  String message, {
  Color color = Colors.redAccent,
}) {
  if (!displaing) {
    displaing = true;
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            backgroundColor: color,
            content: Text(
              message,
              style: const TextStyle(color: kOnPrimary),
            ),
          ),
        )
        .closed
        .then((value) {
      displaing = false;
    });
  }
}
