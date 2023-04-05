//make custom appbar
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

PreferredSizeWidget customAppBar(context,
    {String? title, int? titleSize, List<Widget>? action, bool? isCenter}) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: isCenter ?? false,
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
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}
