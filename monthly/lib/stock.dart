import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/my_stock.dart';
import 'package:monthly/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stock with ChangeNotifier {
  SharedPreferences _prefs;
  int _level = 19; //monthly level(level.1 is Top)
  List<List<dynamic>> _levelCard = [
    [
      0,
      '주식 정보를 입력해주세요! \n하단 메뉴 2번에서 추가 할 수 있습니다.',
      'images/C20.jpg',
    ],
  ];
  double _dollar = 1000.0; //원-달러 환율
  UserData _userData = UserData();
  List<MyStock> _stockList = List<MyStock>();
  List<double> _monthlyDividends = List.filled(12, 0.0);
  Map<DateTime, List> _calEvents = {};

  double _totalInvestPrice = 0.0;
  double _totalEvaPrice = 0.0;
  double _totalEvaProfit = 0.0;

  bool _isStockListShowDollar = false; //표시 통화 설정 (True > 달러, False > 원)
  bool _isInputAvgDollar = false; // 미국 증시 매입 통화 설정 (True > 달러, False > 원)
  String _notionVersion = "";

  //getter
  bool get isStockListShowDollar => _isStockListShowDollar;
  bool get isInputAvgDollar => _isInputAvgDollar;
  String get notionVersion => _notionVersion;
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

  Stock(
      UserData userData,
      double dollar,
      List<MyStock> stockList,
      bool isInputAvgDollar,
      bool isStockListShowDollar,
      String notionVersion,
      SharedPreferences prefs) {
    _userData = userData;
    _dollar = dollar;
    _stockList = stockList;
    _isInputAvgDollar = isInputAvgDollar;
    _isStockListShowDollar = isStockListShowDollar;
    _notionVersion = notionVersion;
    _prefs = prefs;
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
    _stockList[index].editValue(
        avg: avg, amount: amount, isInputAvgDollar: _isInputAvgDollar);
    _httpStockPost(ticker, amount, avg);
    _calcAndSet();

    notifyListeners();
  }

  void setIsStockListShowDollar(bool set) {
    _isStockListShowDollar = set;
    _prefs.setBool('show', _isStockListShowDollar);
    notifyListeners();
  }

  void setIsInputAvgDollar(bool set) async {
    var json = jsonEncode({
      'id': userData.getId(),
      'currency': set ? 1 : 0,
    });

    try {
      await http.post(
        'http://13.125.225.138:5000/currency',
        headers: {"content-Type": "application/json"},
        body: json,
        encoding: Encoding.getByName("utf-8"),
      );
    } catch (e) {
      print('e:$e');
      return;
    }

    _isInputAvgDollar = set;

    stockList.forEach((element) {
      element.editValue(
          avg: element.avg,
          amount: element.amount,
          isInputAvgDollar: _isInputAvgDollar);
    });

    notifyListeners();
  }

  void setNotionVersion(String notionVersion) {
    _notionVersion = notionVersion;
    _prefs.setString("notion", _notionVersion);
//    print("provider notion : $_notionVersion");
  }

  void addKakaoProfile(
      {String profileImgUrl = '', String name, int snsId}) async {
    _userData.profileImgUrl = profileImgUrl != null ? profileImgUrl : "";
    _userData.name = name;
    _userData.snsId = snsId.toString();
    _userData.isSnsLogin = true;
    await _httpKakaoPost(snsId.toString());
    await _stockDataInit(_userData.getId());
    _calcAndSet();

    notifyListeners();
  }

  void addAppleProfile(
      {String profileImgUrl = '', String name, String snsId}) async {
    _userData.profileImgUrl = profileImgUrl != null ? profileImgUrl : "";
    _userData.name = name;
    _userData.snsId = snsId;
    _userData.isSnsLogin = true;
    _prefs.setString("appleName", name);
    _prefs.setString("appleToken", snsId);
    await _httpKakaoPost(snsId.toString());
    await _stockDataInit(_userData.getId());
    _calcAndSet();

    notifyListeners();
  }

  void logoutProfile() async {
    userData.snsId = '';
    userData.profileImgUrl = '';
    userData.name = '사용자';
    userData.isSnsLogin = false;

    if (_prefs.containsKey("appleName")) {
      _prefs.remove("appleName");
      _prefs.remove("appleToken");
    }

    await _stockDataInit(_userData.getId());
    _calcAndSet();

    notifyListeners();
  }

  Future<void> _stockDataInit(String id) async {
    try {
      final response = await http.get('http://13.125.225.138:5000/data/$id');
      var myData = json.decode(response.body);
      double exchange = 1;
      _stockList = [];
      myData.forEach((item) {
        if (item['ticker'].contains('.KS') || item['ticker'].contains('.KQ'))
          exchange = 1;
        else
          exchange = dollar;

        stockList.add(MyStock(
            ticker: item['ticker'],
            name: item['Name'],
            amount: item['amount'],
            avg: item['avgPrice'],
            dividendMonth: item['DividendMonth'],
            exDividends: item['ExList'],
            nextDividend: item['NextAmount'].toDouble(),
            yearlyDividend: item['YearlyDividend'].toDouble(),
            divPercent: (item['DividendYield'] ?? 0.0) * 100.0,
            closingPrice: item['Price'],
            frequency: item['Frequency'],
            dividendDate: item['DividendDate'] ?? '',
            logoURL: item['Logo'],
            wonExchange: exchange,
            isInputAvgDollar: _isInputAvgDollar));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<MyStock> _getMyData(String ticker) async {
    try {
      final response = await http
          .get('http://13.125.225.138:5000/data/${_userData.getId()}');
      var myData = json.decode(response.body);
      int index = myData.indexWhere((item) => item['ticker'] == ticker);
      var dF = myData[index];

      double exchange = 0;
      if (dF['ticker'].contains('.KS') || dF['ticker'].contains('.KQ'))
        exchange = 1;
      else
        exchange = dollar;

      return MyStock(
          ticker: dF['ticker'],
          name: dF['Name'],
          amount: dF['amount'],
          avg: dF['avgPrice'],
          dividendMonth: dF['DividendMonth'],
          exDividends: dF['ExList'],
          nextDividend: dF['NextAmount'].toDouble(),
          yearlyDividend: dF['YearlyDividend'].toDouble(),
          divPercent: (dF['DividendYield'] ?? 0.0) * 100.0,
          closingPrice: dF['Price'],
          frequency: dF['Frequency'],
          dividendDate: dF['DividendDate'] ?? '',
          logoURL: dF['Logo'],
          wonExchange: exchange,
          isInputAvgDollar: _isInputAvgDollar);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> _httpStockPost(
      String ticker, double amount, double avgPrice) async {
    var json = jsonEncode({
      'id': _userData.getId(),
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

  Future<void> _httpKakaoPost(String snsId) async {
    var json = jsonEncode({
      'id': _userData.tokenId,
      'kakaoid': snsId,
    });
    try {
      await http.post(
        'http://13.125.225.138:5000/kakao',
        headers: {"content-Type": "application/json"},
        body: json,
        encoding: Encoding.getByName("utf-8"),
      );
    } catch (e) {
      print('e:$e');
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
      _totalInvestPrice +=
          item.amount * item.wAvg(isInputAvgDollar: _isInputAvgDollar);
      _totalEvaPrice += item.amount * item.wClosingPrice;
    });

    _totalEvaProfit = _totalEvaPrice - _totalInvestPrice;
  }

  void _calcMonthlyDividends() {
    _monthlyDividends = List.filled(12, 0.0);
    _stockList.forEach((item) {
      if (item.frequency == -1) {
      } else if (item.frequency == 12) {
        for (int i = 0; i < 12; i++) {
          _monthlyDividends[i] += item.wNextDividend * item.amount;
        }
      } else {
        item.dividendMonth.forEach((element) {
          _monthlyDividends[element - 1] += item.wNextDividend * item.amount;
        });
      }
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
        if (avgDiv < kMonthlyLevel[i][0]) {
          _level = i + 1;
          int nextDiv = kMonthlyLevel[i][0];

          _levelCard.add([
            kMonthlyLevel[i][0],
            '다음 목표까지 ${(nextDiv.toDouble() - avgDiv).round().toString().replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}원!',
            'images/C00.jpg'
          ]);
          _levelCard = _levelCard.reversed.toList();
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
