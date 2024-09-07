import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../taxi/widgets/adjustment_provider.dart';

class AdjustmentDialog extends ConsumerWidget {
  const AdjustmentDialog({super.key, required this.groupID});
  final int groupID;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAmountController = ref.watch(totalAmountProvider);
    final isWarningVisible = ref.watch(isWarningVisibleProvider);
    final role = ref.watch(roleProvider);
    final isReadOnly = role != 'OWNER';

    List<String> members = ["찰봉", "준하", "창욱", "민지"];

    if (members.isEmpty) {
      return Center(child: Text('멤버가 없습니다.'));
    }

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '정산하기',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 16),
            _buildRow(context, ref, '총 결제 금액', totalAmountController, '원', isReadOnly),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('총 인원', style: TextStyle(fontSize: 16),),
                  Text('${members.length} 명'),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: List.generate(members.length, (index) {
                  String member = members[index];
                  return Column(
                    children: [
                      _buildPersonRow(context, ref, member, index, isReadOnly),
                      SizedBox(height: 8),
                    ],
                  );
                }),
              ),
            ),
            if (isWarningVisible)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Text(
                      '총 결제 금액과 입력한 개인 요금의 합이\n일치하지 않습니다.',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  _handleAdjustmentRequest(context, ref);
                },
                child: Text('정산 요청', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, WidgetRef ref, String label, int totalAmountController, String suffix, bool isReadOnly) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16),),
        Row(
          children: [
            Container(
              width: 80,
              child: TextField(
                controller: TextEditingController(text: totalAmountController.toString()),
                readOnly: isReadOnly,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (value) {
                  int newAmount = int.tryParse(value) ?? 0;
                  ref.read(totalAmountProvider.notifier).state = newAmount;
                },
              ),
            ),
            SizedBox(width: 8),
            Text(suffix),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonRow(BuildContext context, WidgetRef ref, String name, int index, bool isReadOnly) {
    final percentageControllers = ref.watch(percentageControllersProvider);
    final amountControllers = ref.watch(amountControllersProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: TextStyle(fontSize: 12, color: Color(0xFF767676))),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  child: TextField(
                    controller: percentageControllers[index],
                    keyboardType: TextInputType.number,
                    readOnly: isReadOnly,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onChanged: (value) {

                    },
                  ),
                ),
                SizedBox(width: 8),
                Text('%'),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 80,
                  child: TextField(
                    controller: amountControllers[index],
                    keyboardType: TextInputType.number,
                    readOnly: isReadOnly,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onChanged: (value) {
                      // 로직 변경 필요시 여기에
                    },
                  ),
                ),
                SizedBox(width: 8),
                Text('원'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  void _handleAdjustmentRequest(BuildContext context, WidgetRef ref) {
    // 정산 요청
  }
}
