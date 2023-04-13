import 'package:flutter/material.dart';

import '../models/post_response_model.dart';
import '../view/post_page.dart';

Widget indexCommonListTile(ResponsePost data, context) {
  return ListTile(
    leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
            'https://www.momstouch.co.kr/assets/images/brand/new_logo_brand_1.png',
            width: 60,
            height: 60,
            fit: BoxFit.fitWidth)),
    title: Text(data.title),
    subtitle: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.place),
          Text('${data.users.length} / ${data.maxMember} 명 '),
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
                    postTitle: data.title,
                  )));
    },
  );
}
