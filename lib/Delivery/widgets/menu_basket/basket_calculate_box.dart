import 'package:flutter/material.dart';

class CalculateBox extends StatelessWidget {
  const CalculateBox(
      {Key? key, required this.totalSumPrice, required this.expectDeliverFee})
      : super(key: key);
  final int totalSumPrice;
  final int expectDeliverFee;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '총 주문 금액',
                  style: TextStyle(fontSize: 18, color: Colors.black),
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
                  '1인당 예상 배달비(최소 인원 달성 시)',
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
                  '예상 본인 부담 금액',
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
      ),
    );
  }
}
