import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/my_stock.dart';
import 'package:monthly/user_data.dart';

class Stock with ChangeNotifier {
  int _level = 19; //monthly level(level.1 is Top)
  List<List<dynamic>> _levelCard = [
    [
      0,
      '주식 정보를 입력해주세요! \n하단 메뉴 2번에서 추가 할 수 있습니다.',
      'images/C20.jpg',
    ],
  ];
  double _dollar = 1000.0; //원-달러 확율
  UserData _userData = UserData();
  List<MyStock> _stockList = List<MyStock>();
  List<double> _monthlyDividends = List.filled(12, 0.0);
  Map<DateTime, List> _calEvents = {};

  double _totalInvestPrice = 0.0;
  double _totalEvaPrice = 0.0;
  double _totalEvaProfit = 0.0;

  //getter
  double get dollar => _dollar;
  Map<DateTime, List> get calEvents => _calEvents;
  int get level => _level;
  List<List<dynamic>> get levelCard => _levelCard;
  List<MyStock> get stockList => _stockList;
  List<double> get monthlyDividends => _monthlyDividends;
  UserData get userData => _userData;
  String get totalInvestPrice =>
      _totalInvestPrice.round().toString().replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  String get totalEvaPrice =>
      _totalEvaPrice.round().toString().replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  String get totalEvaProfit =>
      _totalEvaProfit.round().toString().replaceAllMapped(
          new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  String get totalEvaProfitPercent =>
      ((_totalEvaProfit / _totalInvestPrice) * 100).toStringAsFixed(1);
  String get avgDividend {
    return (_monthlyDividends.reduce((a, b) => a + b) / 12.0)
        .round()
        .toString()
        .replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},');
  }

  String get thisMonthDividend {
    int thisMonth = DateTime.now().month;
    return (_monthlyDividends[thisMonth - 1])
        .round()
        .toString()
        .replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},');
  }

  Stock(String token, double dollar, List<MyStock> stockList) {
    _userData.tokenId = token;
    _dollar = dollar;
    _stockList = stockList;
    _calcAndSet();

    notifyListeners();
  }

  Future<bool> addStock({String ticker}) async {
    for (int i = 0; i < _stockList.length; i++) {
      if (_stockList[i].ticker == ticker) {
        return true;
      }
    }
    await _httpStockPost(ticker, 0, 0);
    MyStock ms = await _getMyData(ticker);

    if (ms == null) return false;

    _stockList.add(ms);
    _calcAndSet();

    notifyListeners();
    return true;
  }

  void deleteStock({String ticker}) {
    _stockList.removeWhere((item) => item.ticker == ticker);
    _httpStockPost(ticker, -1, -1);
    _calcAndSet();

    notifyListeners();
  }

  void modifyStock({String ticker, double avg, double amount}) {
    int index = _stockList.indexWhere((item) => item.ticker == ticker);
    _stockList[index].editValue(avg: avg, amount: amount);
    _httpStockPost(ticker, amount, avg);
    _calcAndSet();

    notifyListeners();
  }

  void addKakaoProfile({String profileImgUrl = '', String name, int kakaoId}) {
    _userData.profileImgUrl = profileImgUrl;
    _userData.name = name;
    _userData.kakaoId = kakaoId;
    _httpKakaoPost(kakaoId);
    notifyListeners();
  }

  Future<MyStock> _getMyData(String ticker) async {
    try {
      final response = await http
          .get('http://13.125.225.138:5000/data/${_userData.tokenId}');
      var myData = json.decode(response.body);
      int index = myData.indexWhere((item) => item['ticker'] == ticker);
      var dF = myData[index];

      double exchange = 0;
      if (dF['ticker'].contains('.KS'))
        exchange = 1;
      else
        exchange = dollar;

      return MyStock(
          ticker: dF['ticker'],
          name: dF['Name'],
          amount: dF['amount'],
          avg: dF['avgPrice'],
          exDividends: dF['ExList'],
          nextDividend: dF['NextAmount'].toDouble(),
          yearlyDividend: dF['YearlyDividend'].toDouble(),
          divPercent: (dF['DividendYield'] ?? 0.0) * 100.0,
          closingPrice: dF['Price'],
          frequency: dF['Frequency'],
          dividendDate: dF['DividendDate'] ?? '',
          logoURL: dF['Logo'],
          wonExchange: exchange);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _httpStockPost(
      String ticker, double amount, double avgPrice) async {
    var json = jsonEncode({
      'id': _userData.tokenId,
      'ticker': ticker,
      'amount': amount,
      'avgPrice': avgPrice,
    });

    try {
      var response = await http.post(
        'http://13.125.225.138:5000/update',
        headers: {"content-Type": "application/json"},
        body: json,
        encoding: Encoding.getByName("utf-8"),
      );
      print('statusCode: ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }

  void _httpKakaoPost(int kakaoId) async {
    var json = jsonEncode({
      'id': _userData.tokenId,
      'kakaoid': kakaoId,
    });
    try {
      var response = await http.post(
        'http://13.125.225.138:5000/kakao',
        headers: {"content-Type": "application/json"},
        body: json,
        encoding: Encoding.getByName("utf-8"),
      );
      print('statuscode: ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }

  void _calcAndSet() {
    _calcMonthlyDividends();
    _calcStockPercent();
    _calcDividendPercent();
    _calcTotalPrice();
    _setLevel();
    _setCalEvent();
  }

  void _calcTotalPrice() {
    _totalInvestPrice = 0;
    _totalEvaPrice = 0;

    _stockList.forEach((item) {
      _totalInvestPrice += item.amount * item.avg;
      _totalEvaPrice += item.amount * item.wClosingPrice;
    });

    _totalEvaProfit = _totalEvaPrice - _totalInvestPrice;
  }

  void _calcMonthlyDividends() {
    int month;
    _stockList.forEach((item) {
      item.exDividends.forEach((element) {
        month = DateTime.parse(element['index']).month;
        if (DateTime.parse(element['index']).year == DateTime.now().year) {
          _monthlyDividends[month - 1] +=
              element['dividend'] * item.amount * item.wonExchange;
        } else {
          _monthlyDividends[month - 1] += item.wNextDividend * item.amount;
        }
      });
    });
  }

  void _calcStockPercent() {
    double sumEvaPrice = 0;
    _stockList.forEach((item) {
      sumEvaPrice += item.wEvaPrice;
    });

    _stockList.forEach((item) {
      item.percent = ((item.wEvaPrice / sumEvaPrice) * 100);
    });
  }

  void _calcDividendPercent() {
    double sumDividendPrice = 0;
    _stockList.forEach((item) {
      sumDividendPrice += item.wDividend;
    });

    _stockList.forEach((item) {
      item.totalDivPercent = ((item.wDividend / sumDividendPrice) * 100.0);
    });
  }

  void _setLevel() {
    double avgDiv = (_monthlyDividends.reduce((a, b) => a + b) / 12.0);
    _levelCard = [];
    if (avgDiv >= 10000000) {
      _levelCard.add(['????????', '다음 목표까지 ???원', 'images/C00.jpg']);
      _level = 0;
      _levelCard = _levelCard + kMonthlyLevel;
    } else {
      for (int i = 19; i >= 0; i--) {
        print('i:$i');
        if (avgDiv < kMonthlyLevel[i][0]) {
          _level = i + 1;
          int nextDiv = kMonthlyLevel[i][0];

          _levelCard.add([
            kMonthlyLevel[i][0],
            '다음 목표까지 ${(nextDiv.toDouble() - avgDiv).round().toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원!',
            'images/C00.jpg'
          ]);
          _levelCard = _levelCard.reversed.toList();
          notifyListeners();
          break;
        }
        _levelCard.add(kMonthlyLevel[i]);
      }
    }
  }

  void _setCalEvent() {
    _calEvents = {};
    _stockList.forEach((item) {
      item.exDividends.forEach((element) {
        if (_calEvents.containsKey(DateTime.parse(element['index']))) {
          //배당락일 정보 입력
          _calEvents[DateTime.parse(element['index'])].add([
            0,
            item.ticker,
            item.name,
            element['dividend'] * item.wonExchange
          ]);
        } else {
          _calEvents[DateTime.parse(element['index'])] = [
            [0, item.ticker, item.name, element['dividend'] * item.wonExchange]
          ];
        }
      });
      if (item.dividendDate != '') {
        //ETF 등 해당 종목이 지급일 정보가 없을 경우 예외처리
        if (_calEvents.containsKey(DateTime.parse(item.dividendDate))) {
          //지급일 정보 입력
          _calEvents[DateTime.parse(item.dividendDate)].add([
            1,
            item.ticker,
            item.name,
            (item.nextDividend * item.amount * item.wonExchange)
          ]);
        } else {
          _calEvents[DateTime.parse(item.dividendDate)] = [
            [
              1,
              item.ticker,
              item.name,
              (item.nextDividend * item.amount * item.wonExchange)
            ]
          ];
        }
      }
    });
  }
}
