import 'package:flutter/material.dart';

class MyStock {
  String ticker; //티커
  String name; //주식명
  double amount; //보유 수량
  double avg; //평균단가
  Color color; //메인 컬러

  double evaPrice; //평가금액
  List<ExDividend> exDividends = List<ExDividend>(); //배당락일, 금액
  double nextDividend; //다음 예상 배당금(바로 직전 데이터와 같을 예정)
  double dividend; //배당금
  double percent; //전체에서 평가금액의 비율(평가금액/전체 자산)
  double totalDivPercent; //전체에서 배당률의 비율(배당금/전체 배당금)
  double divPercent; //배당률
  double closingPrice; //전일 종가
  double evaProfit; //평가손익
  double evaProfitPercent; //평가손익 퍼센트
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
      this.nextDividend,
      this.dividend,
      this.percent,
      this.totalDivPercent = 0.000,
      this.divPercent = 0.000,
      this.closingPrice = 5000,
      this.evaProfit = 20000,
      this.evaProfitPercent = -3.22,
      this.frequency,
      this.logoURL});
}

class ExDividend {
  DateTime datetime; //배당락일
  double price; //배당금
  ExDividend({this.datetime, this.price});
}
