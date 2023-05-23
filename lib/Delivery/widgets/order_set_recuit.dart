import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/my_deliver_provider.dart';

const int MAX_RECUIT_MEMBER = 99;
const int MIN_RECUIT_MEMBER = 1;

class RecuitNumSelector extends ConsumerStatefulWidget {
  final GlobalKey<FormState> recruitFormKey;
  final int minMember;
  final int maxMember;
  final Function({int? max, int? min})? setMinMaxMember;

  const RecuitNumSelector({
    Key? key,
    required this.recruitFormKey,
    required this.minMember,
    required this.maxMember,
    this.setMinMaxMember,
  }) : super(key: key);

  @override
  ConsumerState createState() => _RecuitNumSelectorState();
}

class _RecuitNumSelectorState extends ConsumerState<RecuitNumSelector> {
  // late bool minChecked;
  // late bool maxChecked;
  late bool editMode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editMode = widget.setMinMaxMember != null;
    // minChecked = editMode;
    // maxChecked = editMode;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.recruitFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '모집 인원',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                // Checkbox(
                //   value: minChecked,
                //   onChanged: (value) {
                //     setState(() {
                //       minChecked = value!;
                //     });
                //   },
                //   fillColor: MaterialStateProperty.resolveWith((states) {
                //     if (states.contains(MaterialState.selected)) {
                //       return WatsoColor.primary;
                //     }
                //     return Colors.grey;
                //   }),
                // ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      label: Text('최소 인원'),
                    ),
                    initialValue: widget.minMember.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '최소 인원을 입력해주세요';
                      }
                      if (int.parse(value) < MIN_RECUIT_MEMBER) {
                        return '최소 $MAX_RECUIT_MEMBER명 이상 입력해주세요';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // if (minChecked && value!.isNotEmpty) {
                      //   int curVal = int.parse(value); //현재 value
                      //   if (curVal < 1) curVal = MIN_RECUIT_MEMBER;
                      //   if (editMode) {
                      //     widget.setMinMaxMember!(min: curVal);
                      //     return;
                      //   }
                      //   ref
                      //       .read(myDeliveryNotifierProvider.notifier)
                      //       .setMyDeliverOption(minMember: curVal);
                      // } else if (!minChecked) {
                      //   if (editMode) {
                      //     widget.setMinMaxMember!(min: MIN_RECUIT_MEMBER);
                      //     return;
                      //   }
                      //   ref
                      //       .read(myDeliveryNotifierProvider.notifier)
                      //       .setMyDeliverOption(minMember: MIN_RECUIT_MEMBER);
                      // }
                      if (value!.isNotEmpty) {
                        int curVal = int.parse(value); //현재 value
                        if (curVal < 1) curVal = MIN_RECUIT_MEMBER;
                        if (editMode) {
                          widget.setMinMaxMember!(min: curVal);
                          return;
                        }
                        ref
                            .read(myDeliveryNotifierProvider.notifier)
                            .setMyDeliverOption(minMember: curVal);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 40,
                ),

                // Checkbox(
                //   value: maxChecked,
                //   onChanged: (value) {
                //     setState(() {
                //       maxChecked = value!;
                //     });
                //   },
                //   fillColor: MaterialStateProperty.resolveWith((states) {
                //     if (states.contains(MaterialState.selected)) {
                //       return WatsoColor.primary;
                //     }
                //     return Colors.grey;
                //   }),
                // ),
                Expanded(
                  child: TextFormField(
                      initialValue: widget.maxMember.toString(),
                      decoration: InputDecoration(
                        label: Text('최대 인원'),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty) return '최대 인원을 입력해주세요';
                        if (value.length > 2) return '최대 인원은 99명 이하로 입력해주세요';
                      },
                      onSaved: (value) {
                        // if (maxChecked && value!.isNotEmpty) {
                        //   int curVal = int.parse(value); //현재 value
                        //   if (curVal < 1) curVal = MAX_RECUIT_MEMBER;
                        //   if (editMode) {
                        //     widget.setMinMaxMember!(max: curVal);
                        //     return;
                        //   }
                        //   ref
                        //       .read(myDeliveryNotifierProvider.notifier)
                        //       .setMyDeliverOption(maxMember: curVal);
                        // } else if (!maxChecked) {
                        //   if (editMode) {
                        //     widget.setMinMaxMember!(max: MAX_RECUIT_MEMBER);
                        //     return;
                        //   }
                        //   ref
                        //       .read(myDeliveryNotifierProvider.notifier)
                        //       .setMyDeliverOption(maxMember: MAX_RECUIT_MEMBER);
                        // }
                        if (value!.isNotEmpty) {
                          int curVal = int.parse(value); //현재 value
                          if (curVal < 1) curVal = MAX_RECUIT_MEMBER;
                          if (curVal > MAX_RECUIT_MEMBER) {
                            curVal = MAX_RECUIT_MEMBER;
                          }
                          if (editMode) {
                            widget.setMinMaxMember!(max: curVal);
                            return;
                          }
                          ref
                              .read(myDeliveryNotifierProvider.notifier)
                              .setMyDeliverOption(maxMember: curVal);
                        }
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
