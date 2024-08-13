import 'package:flutter/material.dart';

class AdjustmentDialog extends StatefulWidget {
  const AdjustmentDialog({
    super.key,
    required this.groupID,
  });
  final int groupID;

  @override
  State<AdjustmentDialog> createState() => _AdjustmentDialogState();
}

class _AdjustmentDialogState extends State<AdjustmentDialog> {
  final TextEditingController _totalAmountController = TextEditingController(
      text: '6200');
  final TextEditingController _totalPeopleController = TextEditingController(
      text: '4');
  final List<TextEditingController> _percentageControllers = [
    TextEditingController(text: '25'),
    TextEditingController(text: '25'),
    TextEditingController(text: '25'),
  ];
  List<String> members = ["찰봉", "준하", "창욱"];


  @override
  Widget build(BuildContext context) {
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
            _buildRow('총 결제 금액', _totalAmountController, '원', readOnly: false),
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
            Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('1인당 요금', style: TextStyle(fontSize: 16),),
                  Text('${_calculatePerPerson()} 원'),
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                children: members
                    .asMap()
                    .entries
                    .map((entry) {
                  int index = entry.key;
                  String member = entry.value;

                  return Column(
                    children: [
                      _buildPersonRow(member, index),
                      SizedBox(height: 8),
                    ],
                  );
                }).toList(),
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, //   버튼 색상
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () {
                  // 버튼 클릭 시 수행할 작업, 아래 코드는 임시로 해둠
                  _handlePercentage();
                },
                child: Text('정산 요청'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 그룹 정산 내역
  Widget _buildRow(String label, TextEditingController controller,
      String suffix, {bool readOnly = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16),),
        Row(
          children: [
            Container(
              width: 80,
              child: TextField(
                controller: controller,
                readOnly: readOnly,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
                onChanged: (value) {
                  setState(() {}); // 값 변경될 때마다 업데이트
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

  // 개인 정산 내역
  Widget _buildPersonRow(String name, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF767676),
          ),),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  child: TextField(
                    controller: _percentageControllers[index],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onChanged: (value) {
                      setState(() {}); // 값이 변경될 때마다 UI를 업데이트
                    },
                  ),
                ),
                SizedBox(width: 8),
                Text('%'),
              ],
            ),
            Text('${_calculateIndividualAmount(index)} 원'),
          ],
        ),
      ],
    );
  }

  // 1인당 요금(단순 n빵)
  String _calculatePerPerson() {
    int totalAmount = int.tryParse(_totalAmountController.text) ?? 0;
    return (totalAmount / members.length).toStringAsFixed(0);
  }

  // 개인 요금(비율)
  String _calculateIndividualAmount(int index) {
    int totalAmount = int.tryParse(_totalAmountController.text) ?? 0;
    int percentage = int.tryParse(_percentageControllers[index].text) ?? 0;
    return ((totalAmount * percentage) / 100).toStringAsFixed(0);
  }

  void _handlePercentage() {
    int totalPercentage = _percentageControllers
        .map((controller) => int.tryParse(controller.text) ?? 0)
        .fold(0, (sum, value) => sum + value);

    if (totalPercentage != 100) {
      debugPrint('퍼센트 합 100 아님');
    } else {
      // 퍼센트 합계가 100인 경우 처리할 코드
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _totalPeopleController.dispose();
    _percentageControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }
}