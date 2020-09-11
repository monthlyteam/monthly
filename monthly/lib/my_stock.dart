import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';

class MyStock {
  String ticker; //티커
  String name; //주식명
  double amount; //보유 수량
  double avg; //평균매입단가
  double wonExchange; //환율(미국 주식:원달러 환율, 한국 주식: 1)

  Color color; //메인 컬러
  int frequency; //주기
  String dividendDate; //지급일
  String logoURL; //로고Url
  double divPercent; //배당률
  List<dynamic> dividendMonth = List<dynamic>(); //예상 배당 월

  //외부에서 환율 계산
  double percent = 0; //전체에서 평가금액의 비율(평가금액/전체 자산) 생성자
  double totalDivPercent = 0; //전체에서 배당률의 비율(배당금/전체 배당금) 생성자
  List<dynamic> exDividends = List<dynamic>();

  double _evaPrice; //평가금액
  double _nextDividend; //다음 예상 배당금(바로 직전 데이터와 같을 예정)
  double _dividend; //연 총 배당금
  double _yearlyDividend; //한 주당 연 배당금
  double _closingPrice; //현재가격
  double _evaProfit; //평가손익 생성자 안에서 계산
  double evaProfitPercent; //평가손익 퍼센트

  //getter
  double get evaPrice => _evaPrice; //배당락일 : 금액
  double get nextDividend => _nextDividend;
  double get dividend => _dividend;
  double get yearlyDividend => _yearlyDividend;
  double get closingPrice => _closingPrice;
  double get evaProfit => _evaProfit;

  //Won Exchange getter
  double get wEvaPrice => _evaPrice * wonExchange;
  double get wNextDividend => _nextDividend * wonExchange;
  double get wDividend => _dividend * wonExchange;
  double get wYearlyDividend => _yearlyDividend * wonExchange;
  double get wClosingPrice => _closingPrice * wonExchange;
  double get wEvaProfit => _evaProfit * wonExchange;

  MyStock(
      {this.ticker,
      this.name,
      amount,
      avg,
      this.dividendMonth,
      this.exDividends,
      nextDividend,
      yearlyDividend,
      this.divPercent,
      closingPrice,
      this.frequency,
      this.dividendDate,
      this.logoURL,
      this.wonExchange}) {
    _nextDividend = nextDividend;
    _yearlyDividend = yearlyDividend;
    _closingPrice = closingPrice;

    editValue(avg: avg, amount: amount);
  }

  void editValue({double avg, double amount}) {
    this.avg = avg;
    this.amount = amount;
    _evaPrice = _closingPrice * amount;
    _evaProfit = (_evaPrice) - ((amount * avg) / wonExchange);
    evaProfitPercent = (_evaProfit / ((amount * avg) / wonExchange)) * 100;
    _dividend = _yearlyDividend * amount;

    if (_evaProfit > 0.0)
      this.color = kUPColor;
    else if (_evaProfit < 0.0)
      this.color = kDownColor;
    else
      this.color = Colors.blueGrey;
  }
}
