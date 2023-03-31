import 'package:flutter/material.dart';

const List<String> list = <String>['최근 등록', '가까운 시간', 'Three', 'Four'];
String dropdownValue = list.first;

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
                value: dropdownValue,
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
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(width: 8),
              DropdownButton(
                value: dropdownValue,
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
                items: list.map<DropdownMenuItem<String>>((String value) {
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
