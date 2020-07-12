import 'package:flutter/material.dart';

class MyStock {
  String ticker;
  String name;
  double amount;
  double avg; //평균단가
  Color color;

  double evaPrice; //평가금액
  List<ExDividend> exDividends; //배당낙일
  String frequency; //주기
  String logoURL;
}

class ExDividend {
  DateTime datetime;
  double price;
}
