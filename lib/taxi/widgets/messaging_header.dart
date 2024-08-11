import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/Buttons.dart';
import '../model/taxi_model.dart';
import 'messaging_timeline.dart';
import 'receipt_dialog.dart';
import 'recuit_info_card.dart';

class MessagingHeader extends ConsumerWidget {
  const MessagingHeader({super.key, required this.pageId});

  final String pageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String departure = "부산대";
    final List<String> processes =
        TaxiStatus.values.map((e) => e.toKr()).toList();
    final String destination = "밀양역";
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MessagingTimeline(
          processes: processes,
          processIndex: 2,
        ),
        RecuitInfoCard(
          departure: departure,
          destination: destination,
          maxPeople: 4,
          currentPeople: 3,
          departTime: DateTime.now(),
          estimatedCost: 20000,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: PrimaryBtn(
            minimumSize: Size(double.infinity, 48),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const ReceiptDialog(payment: 6300, hc: 3);
                  });
            },
            text: "탑승자 확정하기",
          ),
        ),
      ],
    );
  }
}
