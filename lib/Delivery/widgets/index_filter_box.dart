import 'package:flutter/material.dart';

const List<String> filterTime = <String>['최근 등록', '가까운 시간'];
const List<String> filterPlace = <String>['생자대', '기숙사'];

class FilterBox extends StatelessWidget {
  const FilterBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              DropdownButton(
                value: filterTime.first,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: SizedBox(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  // setState(() {
                  //   dropdownValue = value!;
                  // });
                },
                items: filterTime.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 20),
              DropdownButton(
                value: filterPlace.first,
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Icon(Icons.arrow_downward),
                ),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: SizedBox(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  // setState(() {
                  //   dropdownValue = value!;
                  // });
                },
                items:
                    filterPlace.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
