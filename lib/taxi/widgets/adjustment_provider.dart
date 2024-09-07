import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// 총 결제 금액
final totalAmountProvider = StateProvider<int>((ref) => 6200);

// 각 멤버의 금액 비율
final percentageControllersProvider = StateProvider<List<TextEditingController>>((ref) {
  List<TextEditingController> controllers = [];
  List<String> members = ["찰봉", "준하", "창욱", "민지"];
  int tmpPercentage = 100 ~/ members.length;

  controllers = List.generate(members.length, (index) => TextEditingController(text: tmpPercentage.toString()));
  return controllers;
});

// 각 멤버의 금액
final amountControllersProvider = StateProvider<List<TextEditingController>>((ref) {
  List<TextEditingController> controllers = [];
  List<String> members = ["찰봉", "준하", "창욱", "민지"];
  int tmpAmount = 6200 ~/ members.length;

  controllers = List.generate(members.length, (index) => TextEditingController(text: tmpAmount.toString()));
  return controllers;
});

// 경고 메시지
final isWarningVisibleProvider = StateProvider<bool>((ref) => false);

// 역할
final roleProvider = StateProvider<String>((ref) => 'OWNER');
