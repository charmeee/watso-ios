import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget outlineTextFromField({ValueChanged<String>? onChanged,
  EdgeInsetsGeometry? contentPadding,
  String? label,
  String? hintText,
  FocusNode? focusNode,
  FormFieldValidator? validator,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyboardType,
  TextEditingController? controller,
  String? initialValue,
  Widget? suffix,
  Widget? suffixIcon}) {
  return TextFormField(

    focusNode: focusNode,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    initialValue: initialValue,
    decoration: InputDecoration(
      contentPadding:
      contentPadding ?? EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      hintText: hintText,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIcon: suffixIcon,
      suffix: suffix,
    ),
    validator: validator,
    onChanged: onChanged,
    inputFormatters: inputFormatters,
    keyboardType: keyboardType,
    cursorColor: Colors.grey,
    controller: controller,
  );
}
