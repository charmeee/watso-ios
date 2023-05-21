import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/post_model.dart';
import '../provider/my_deliver_provider.dart';
import '../repository/store_repository.dart';

class StoreSelector extends ConsumerStatefulWidget {
  const StoreSelector({
    Key? key,
    required this.myStore,
  }) : super(key: key);
  final Store myStore;

  @override
  ConsumerState createState() => _StoreSelectorState();
}

class _StoreSelectorState extends ConsumerState<StoreSelector> {
  List<Store> _storeList = [];

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
    Store myStore = widget.myStore;
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "가게 선택",
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
                Text(myStore.id.isEmpty ? "가게를 선택해 주세요" : myStore.name,
                    style: TextStyle(
                        fontSize: 20,
                        color:
                            myStore.id.isEmpty ? Colors.grey : Colors.black)),
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
                        .read(myDeliveryNotifierProvider.notifier)
                        .setMyDeliverStore(_storeList[index]);
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
