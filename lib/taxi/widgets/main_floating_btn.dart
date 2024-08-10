import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/constants/styles.dart';
import '../model/taxi_model.dart';
import '../provider/main_providers.dart';

class MainFloatingBtn extends ConsumerWidget {
  const MainFloatingBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TaxiOption filter = ref.watch(filterOptionsProvider);

    return FloatingActionButton(
      onPressed: () {
        // context.go(Routes.tRecruitment.path);
      },
      child: Icon(Icons.add),
      backgroundColor: WatsoColor.primary,
    );
  }
}
