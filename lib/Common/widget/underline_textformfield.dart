import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watso/Common/theme/color.dart';

import '../theme/text.dart';

TextFormField underlineTextFromField(
    {ValueChanged<String>? onChanged,
    FormFieldSetter<String>? onSaved,
    String? label,
    String? hintText,
    FormFieldValidator? validator,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
    TextInputType? keyboardType}) {
  return TextFormField(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    obscureText: obscureText,
    style: WatsoText.readable,
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
      labelStyle: TextStyle(color: WatsoColor.lightText),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: WatsoColor.primary)),
      focusColor: WatsoColor.primary,
    ),
    cursorColor: WatsoColor.primary,
    validator: validator,
    onChanged: onChanged,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    onSaved: onSaved,
  );
}
