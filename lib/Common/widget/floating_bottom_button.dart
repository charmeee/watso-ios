import 'package:flutter/material.dart';

Widget customFloatingBottomButton(
  context, {
  required Widget child,
  required VoidCallback onPressed,
}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          minimumSize: const Size.fromHeight(50),
          backgroundColor: Colors.indigo),
      child: child,
    ),
  );
}
