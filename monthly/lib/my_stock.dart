import 'package:flutter/material.dart';

class MyStock {
  String ticker; //티커
  String name; //주식명
  double amount; //보유 수량
  double avg; //평균단가
  Color color; //메인 컬러

  double evaPrice; //평가금액
  List<ExDividend> exDividends; //배당락일, 금액
  double dividend; //배당금
  double percent; //평가금액/전체 자산
  String frequency; //주기
  String logoURL; //로고Url
  MyStock(
      {this.ticker,
      this.name,
      this.amount,
      this.avg,
      this.color,
      this.evaPrice,
      this.exDividends,
      this.dividend,
      this.percent,
      this.frequency,
      this.logoURL});
}

class ExDividend {
  DateTime datetime; //배당락일
  double price; //배당금
}
