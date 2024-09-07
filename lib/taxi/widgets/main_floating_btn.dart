import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../common/constants/styles.dart';
import '../../common/router/routes.dart';

class MainFloatingBtn extends ConsumerWidget {
  const MainFloatingBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      onPressed: () {
        context.push(Routes.tCreate.path);
      },
      child: Icon(Icons.add),
      backgroundColor: WatsoColor.primary,
    );
  }
}
