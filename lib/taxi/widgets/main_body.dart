import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../common/constants/styles.dart';
import '../../common/router/routes.dart';
import '../../common/widgets/Boxes.dart';
import '../model/taxi_model.dart';
import '../provider/main_providers.dart';

class MainBody extends ConsumerWidget {
  const MainBody({super.key});

  String convertHHMM(DateTime date) {
    if (date.hour > 12) {
      return "${date.hour - 12}:${date.minute}PM";
    }
    return "${date.hour}:${date.minute}AM";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<List<TaxiGroup>> groups = ref.watch(filteredGroupsProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("택시리스트", style: WatsoFont.title),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("출발도착지 ∙ 출발 시간 ∙ 총요금 ∙  정원",
              style: TextStyle(color: Colors.grey[600], fontSize: 11)),
        ),
        groups.when(data: (data) {
          if (data.isEmpty)
            return AngularBox(
                margin: EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 16.0),
                child: Text("모집중인 텍시가 없습니다"));
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (TaxiGroup group in data) ...{
                InkWell(
                    onTap: () {
                      context
                          .push(Routes.recruitment(group.id.toString()).path);
                    },
                    child: AngularBox(
                      margin: EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        "assets/icons/direction.svg"),
                                    SizedBox(width: 8),
                                    Text(
                                      group.option.direction ==
                                              TaxiDirection.CAMPUS
                                          ? TaxiDirection.STATION.toKorean()
                                          : TaxiDirection.CAMPUS.toKorean(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset("assets/icons/pin.svg"),
                                    SizedBox(width: 8),
                                    Text(
                                      group.option.direction.toKorean(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(convertHHMM(group.option.departDatetime)),
                              Text("6200원"),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("1/4명"),
                                  SvgPicture.asset("assets/icons/group.svg"),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              }
            ],
          );
        }, error: (err, stack) {
          return Text("에러가 발생했습니다.");
        }, loading: () {
          return CircularProgressIndicator();
        }),
      ],
    );
  }
}
