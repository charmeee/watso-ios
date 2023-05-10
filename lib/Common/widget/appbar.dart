//make custom appbar
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/text.dart';

PreferredSizeWidget customAppBar(context,
    {String? title,
    double? titleSize,
    List<Widget>? action,
    bool isCenter = false,
    bool isLogo = false}) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.black, //change your color here
    ),
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: isCenter,
    title: title != null
        ? (isLogo
            ? Text(title, style: WatsoText.logo)
            : Text(title,
                style: WatsoText.appBar.copyWith(
                  fontSize: titleSize ?? 22,
                )))
        : null,
    actions: action,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}
