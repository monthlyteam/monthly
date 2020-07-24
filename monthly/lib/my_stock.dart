import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';

class MyStock {
  String ticker; //티커
  String name; //주식명
  double amount; //보유 수량
  double avg; //평균단가
  Color color; //메인 컬러

  double evaPrice; //평가금액
  List<dynamic> exDividends = List<dynamic>(); //배당락일 : 금액
  double nextDividend; //다음 예상 배당금(바로 직전 데이터와 같을 예정)
  double dividend; //배당금
  double percent; //전체에서 평가금액의 비율(평가금액/전체 자산) 생성자
  double totalDivPercent; //전체에서 배당률의 비율(배당금/전체 배당금) 생성자
  double divPercent; //배당률
  double closingPrice; //현재가격
  double evaProfit; //평가손익 생성자 안에서 계산
  double evaProfitPercent; //평가손익 퍼센트 생성자
  int frequency; //주기
  String dividendDate;
  String logoURL; //로고Url

  MyStock(
      {this.ticker,
      this.name,
      this.amount,
      this.avg,
      this.evaPrice,
      this.exDividends,
      this.nextDividend,
      this.dividend,
      this.percent = 0.0,
      this.totalDivPercent = 0.0,
      this.divPercent,
      this.closingPrice,
      this.evaProfit,
      this.evaProfitPercent,
      this.frequency,
      this.dividendDate,
      this.logoURL}) {
    evaProfit = evaPrice - amount * avg;
    evaProfitPercent = (evaProfit / (amount * avg)) * 100;

    if (evaProfit > 0.0)
      this.color = kUPColor;
    else if (evaProfit < 0.0)
      this.color = kDownColor;
    else
      this.color = Colors.blueGrey;
  }
}
