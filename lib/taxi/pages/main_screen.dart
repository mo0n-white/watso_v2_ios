import 'package:flutter/material.dart';
import 'package:watso_v2/taxi/widgets/main_header.dart';

import '../widgets/main_body.dart';

class TaxiMainScreen extends StatelessWidget {
  const TaxiMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MainHeader(),
          MainBody(),
        ],
      ),
    );
  }
}
