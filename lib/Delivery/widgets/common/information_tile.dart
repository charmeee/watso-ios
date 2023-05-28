import 'package:flutter/material.dart';

class InformationTile extends StatelessWidget {
  const InformationTile(
      {Key? key,
      required this.icon,
      required this.title,
      this.content,
      this.widget})
      : super(key: key);
  final IconData icon;
  final String title;
  final String? content;
  final Widget? widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Icon(
              icon,
              // Icons.store,
              color: Colors.grey,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    )),
                if (widget != null) widget!,
                if (content != null)
                  Text(
                    content!,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
