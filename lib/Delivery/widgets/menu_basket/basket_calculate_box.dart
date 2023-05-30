import 'package:flutter/material.dart';

import '../../../Common/theme/text.dart';

class CalculateBox extends StatelessWidget {
  const CalculateBox(
      {Key? key,
      required this.totalSumPrice,
      required this.expectDeliverFee,
      this.isTotal = false})
      : super(key: key);
  final int totalSumPrice;
  final int expectDeliverFee;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('예상 배달비는 실제와 다를 수 있습니다.')),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '총 주문 금액',
                style: WatsoText.lightBold.copyWith(fontSize: 20),
              ),
              Text(
                '${totalSumPrice}원',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isTotal ? '예상 배달비' : '1인당 예상 배달비(최소 인원 달성 시)',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              Text(
                '$expectDeliverFee원',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ],
          ),
          Divider(
            height: 20,
            thickness: 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isTotal ? '예상 결제 금액' : '예상 본인 부담 금액',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                '${totalSumPrice + expectDeliverFee}원',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
