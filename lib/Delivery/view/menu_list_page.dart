import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sangsangtalk/Common/widget/appbar.dart';

const data = [
  {
    'header': '세트메뉴',
    'menu': [
      {
        'name': '불고기 버거 세트',
        'price': 5000,
        'description': '불고기 버거, 콜라, 감자튀김, 양념감자',
      }
    ]
  }
];

class MenuListPage extends ConsumerStatefulWidget {
  const MenuListPage({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MenuListPageState();
}

class _MenuListPageState extends ConsumerState<MenuListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: '메뉴'),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 50,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Text('메뉴'),
                  ),
                  Container(
                    width: 50,
                    child: Text('가격'),
                  ),
                  Container(
                    width: 50,
                    child: Text('수량'),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Text('메뉴'),
                  ),
                  Container(
                    width: 50,
                    child: Text('가격'),
                  ),
                  Container(
                    width: 50,
                    child: Text('수량'),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              child: Row(
                children: [
                  Container(
                    width: 50,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {},
                    ),
                  ),
                  Container(
                    width: 50,
                    child: Text('메뉴'),
                  ),
                  Container(
                    width: 50,
                    child: Text('가격'),
                  ),
                  Container(
                    width: 50,
                    child: Text('수량'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
