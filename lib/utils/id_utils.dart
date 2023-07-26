// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';

class IdUtils {
  static const String TABLE =
      'fZodR9XQDSUm21yCkr6zBqiveYah8bt4xsWpHnJE7jL5VG3guMTKNPAwcF';
  static const List<int> S = [11, 10, 3, 8, 4, 6]; // 位置编码表
  static const int XOR = 177451812; // 固定异或值
  static const int ADD = 8728348608; // 固定加法值
  static const List<String> r = [
    'B',
    'V',
    '1',
    '',
    '',
    '4',
    '',
    '1',
    '',
    '7',
    '',
    ''
  ];

  /// av转bv
  static String av2bv(int av) {
    int x_ = (av ^ XOR) + ADD;
    List<String> newR = [];
    newR.addAll(r);
    for (int i = 0; i < S.length; i++) {
      newR[S[i]] =
          TABLE.characters.elementAt((x_ / pow(58, i).toInt() % 58).toInt());
    }
    return newR.join();
  }

  /// bv转bv
  static int bv2av(String bv) {
    int r = 0;
    for (int i = 0; i < S.length; i++) {
      r += (TABLE.indexOf(bv.characters.elementAt(S[i])).toInt()) *
          pow(58, i).toInt();
    }
    return (r - ADD) ^ XOR;
  }
}
