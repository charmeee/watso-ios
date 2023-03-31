//make custom appbar
import 'package:flutter/material.dart';

PreferredSizeWidget customAppBar(context,
    {String? title, int? titleSize, List<Widget>? action}) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
    title: title != null
        ? Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: titleSize?.toDouble(),
              fontWeight: FontWeight.bold,
            ),
          )
        : null,
    actions: action,
  );
}
