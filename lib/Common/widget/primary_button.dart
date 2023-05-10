import 'package:flutter/material.dart';
import 'package:watso/Common/theme/color.dart';

import '../theme/text.dart';

ElevatedButton primaryButton(
    {required Function() onPressed,
    String text = '',
    EdgeInsetsGeometry? padding,
    TextStyle? textStyle,
    Size? minimumSize,
    Widget? child,
    double? elevation}) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
        elevation: elevation ?? 0,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        minimumSize: minimumSize,
        backgroundColor: WatsoColor.primary),
    child: child ??
        Text(
          text,
          style: textStyle ?? WatsoText.bold.copyWith(color: Colors.white),
        ),
  );
}
