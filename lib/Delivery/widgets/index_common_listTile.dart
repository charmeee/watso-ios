import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:watso/Delivery/models/post_model.dart';

import '../models/post_response_model.dart';
import '../view/post_page.dart';

Widget indexCommonListTile(ResponsePost data, context) {
  String orderTime = DateFormat("HH시 mm분", 'ko').format(data.orderTime);
  return ListTile(
    leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(data.store.logoImgUrl,
            width: 60, height: 60, fit: BoxFit.fitWidth)),
    title: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(orderTime,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87)),
        Text('[${data.place}] ' + data.store.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
      ],
    ),
    subtitle: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('· ${data.status.korName}',
              style: TextStyle(color: Colors.black87, height: 1.2)),
          // Text(
          //   '📍${data.place}',
          //   style: TextStyle(height: 1.2),
          // ),
          Text('· ${data.users.length} / ${data.maxMember} 명 ',
              style: TextStyle(color: Colors.black87, height: 1.2)),
        ],
      ),
    ),
    trailing: Text(data.nickname),
    contentPadding: EdgeInsets.only(top: 8, left: 16, right: 8),
    onTap: () {
      //navigate to PostDetailPage
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostPage(
                    postId: data.id,
                  )));
    },
  );
}
