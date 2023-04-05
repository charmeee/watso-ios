import 'package:flutter/material.dart';

import '../models/post_response_model.dart';
import '../view/post_page.dart';

Widget indexCommonListTile(ResponsePost data, context) {
  return ListTile(
    leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Image.network(
            'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg',
            width: 50,
            height: 50,
            fit: BoxFit.cover)),
    title: Text(data.title),
    subtitle: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(data.place),
        Text('${data.userOrders.length} / ${data.maxMember} 명 '),
      ],
    ),
    trailing: Text(data.nickname),
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
