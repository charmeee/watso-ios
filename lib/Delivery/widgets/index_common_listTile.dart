import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sangsangtalk/Delivery/models/post_model.dart';

import '../models/post_response_model.dart';
import '../view/post_page.dart';

Widget indexCommonListTile(ResponsePost data, context) {
  String orderTime = DateFormat("M.d(E) HH:mm", 'ko').format(data.orderTime);
  return ListTile(
    leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
            'https://www.momstouch.co.kr/assets/images/brand/new_logo_brand_1.png',
            width: 60,
            height: 60,
            fit: BoxFit.fitWidth)),
    title: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(orderTime, style: TextStyle(fontSize: 15)),
        Text(data.store.name,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    ),
    subtitle: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🧑‍🍳${data.status.korName}',
              style: TextStyle(color: Colors.black87, height: 1.2)),
          Text(
            '🛖${data.place}',
            style: TextStyle(height: 1.2),
          ),
          Text(
            '🙋${data.users.length} / ${data.maxMember} 명 ',
            style: TextStyle(height: 1.2),
          ),
        ],
      ),
    ),
    trailing: Text(data.nickname),
    // contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    onTap: () {
      //navigate to PostDetailPage
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostPage(
                    postId: data.id,
                    postTitle: data.store.name,
                  )));
    },
  );
}
