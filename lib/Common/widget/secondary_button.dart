import 'package:flutter/material.dart';

import '../theme/color.dart';
import '../theme/text.dart';

OutlinedButton secondaryButton({
  required Function() onPressed,
  required String text,
  double borderWidth = 1,
  EdgeInsetsGeometry? padding,
  TextStyle? textStyle,
}) {
  return OutlinedButton(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      side: BorderSide(color: WatsoColor.primary, width: borderWidth),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
    child: Text(
      text,
      style: textStyle ?? WatsoText.bold.copyWith(color: WatsoColor.primary),
    ),
  );
}
