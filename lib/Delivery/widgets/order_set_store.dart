import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';
import '../provider/my_deliver_provider.dart';
import '../repository/store_repository.dart';

class StoreSelector extends ConsumerStatefulWidget {
  const StoreSelector({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _StoreSelectorState();
}

class _StoreSelectorState extends ConsumerState<StoreSelector> {
  List<Store> _storeList = [];
  String nowStoreName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setStoreList();
  }

  setStoreList() {
    ref
        .read(storeRepositoryProvider)
        .getStoreList()
        .then((value) => setState(() {
              _storeList = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    String myStore = ref.watch(postOrderNotifierProvider).store.id;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "가계 선택",
            style: TextStyle(fontSize: 15),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              _showStoreDialog();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(myStore.isEmpty ? "가계를 선택해 주세요" : nowStoreName,
                    style: TextStyle(
                        fontSize: 20,
                        color: myStore.isEmpty ? Colors.grey : Colors.black)),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ]);
  }

  void _showStoreDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
            content: SizedBox(
          width: 300,
          child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    width: 300,
                    alignment: Alignment.center,
                    child: Text(_storeList[index].name,
                        style: TextStyle(fontSize: 15)),
                  ),
                  onTap: () {
                    ref
                        .read(postOrderNotifierProvider.notifier)
                        .setMyDeliverStore(_storeList[index]);
                    setState(() {
                      nowStoreName = _storeList[index].name;
                    });
                    Navigator.pop(context);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: _storeList.length),
        ));
      },
    );
  }
}
