import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:monthly/constants.dart';
import 'package:monthly/my_stock.dart';
import 'package:monthly/user_data.dart';

class Stock with ChangeNotifier {
  int _level = 19; //monthly level(Low level is Top)
  List<List<dynamic>> _levelCard = [
    [
      0,
      '주식 정보를 입력해주세요! \n하단 메뉴 2번에서 추가 할 수 있습니다.',
      'images/C20.jpg',
    ],
  ];
  double _exrate = 1200;
  UserData _userData = UserData();
  List<MyStock> _stockList = List<MyStock>();
  List<double> _monthlyDividends = List.filled(12, 0.0);
  Map<DateTime, List> _calEvents = {};

  //getter
  Map<DateTime, List> get calEvents => _calEvents;
  int get level => _level;
  List<List<dynamic>> get levelCard => _levelCard;
  List<MyStock> get stockList => _stockList;
  List<double> get monthlyDividends => _monthlyDividends;
  UserData get userData => _userData;
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

  Stock(String token) {
    _userData.tokenId = token;
    init();
  }

  void init() async {
//    addStock(ticker: 'KO');
//    addStock(ticker: 'TSLA');

    final response =
        await http.get('http://13.125.225.138:5000/data/${_userData.tokenId}');
    var myData = json.decode(response.body);

    myData.forEach((item) {
      _stockList.add(MyStock(
          ticker: item['ticker'],
          name: item['Name'],
          amount: item['amount'],
          avg: item['avgPrice'],
          evaPrice: item['Price'] * item['amount'],
          exDividends: item['ExList'],
          nextDividend: item['NextAmount'],
          dividend: item['YearlyDividend'] * item['amount'],
          divPercent: (item['DividendYield'] ?? 0.0) * 100,
          closingPrice: item['Price'],
          frequency: item['Frequency'],
          dividendDate: item['DividendDate'] ?? '',
          logoURL: item['Logo']));
    });
  }

  void _setLevel() {
    double avgDiv = (_monthlyDividends.reduce((a, b) => a + b) / 12.0);
    _levelCard = [];
    for (int i = 19; i > 0; i--) {
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

  void _setCalEvent() {
    _stockList.forEach((item) {
      item.exDividends.forEach((element) {
        if (_calEvents.containsKey(DateTime.parse(element['index']))) {
          //배당락일 정보 입력
          _calEvents[DateTime.parse(element['index'])]
              .add([0, item.ticker, item.name, element['dividend'] * _exrate]);
        } else {
          _calEvents[DateTime.parse(element['index'])] = [
            [0, item.ticker, item.name, element['dividend'] * _exrate]
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
            (item.nextDividend * item.amount * _exrate)
          ]);
        } else {
          _calEvents[DateTime.parse(item.dividendDate)] = [
            [
              1,
              item.ticker,
              item.name,
              (item.nextDividend * item.amount * _exrate)
            ]
          ];
        }
      }
    });
  }

  Future<void> addStock({String ticker}) async {
    await _httpStockPost(ticker, 10, 25);
    MyStock ms = await _getMyData(ticker);
    _stockList.add(ms);
    _calcMonthlyDividends();
    _calcStockPercent();
    _calcDividendPercent();
    _setLevel();
    _setCalEvent();
//    await _httpStockPost(newStock.ticker, newStock.avg, newStock.amount);
    print("add끝");
    notifyListeners();
  }

  void deleteStock({String ticker}) {
    _stockList.removeWhere((item) => item.ticker == ticker);
    _calcMonthlyDividends();
    _calcStockPercent();
    _calcDividendPercent();
    _httpStockPost(ticker, -1, -1);
    _setLevel();
    _setCalEvent();

    notifyListeners();
  }

  void modifyStock({String ticker, double avg, double amount}) {
    int index = _stockList.indexWhere((item) => item.ticker == ticker);
    _stockList[index].amount = amount;
    _stockList[index].avg = avg;
    _calcMonthlyDividends();
    _calcStockPercent();
    _calcDividendPercent();
    _httpStockPost(ticker, amount, avg);
    _setLevel();
    _setCalEvent();

    notifyListeners();
  }

  void _calcMonthlyDividends() {
    int month;
    _stockList.forEach((item) {
      item.exDividends.forEach((element) {
        month = DateTime.parse(element['index']).month;
        if (DateTime.parse(element['index']).year == DateTime.now().year) {
          _monthlyDividends[month - 1] +=
              element['dividend'] * item.amount * _exrate;
        } else {
          _monthlyDividends[month - 1] +=
              item.nextDividend * item.amount * _exrate;
        }
      });
    });
    _monthlyDividends.forEach((element) {
      print(element);
    });
    print("-------------");
  }

  void _calcStockPercent() {
    double sumEvaPrice = 0;
    _stockList.forEach((item) {
      sumEvaPrice += item.evaPrice;
    });

    _stockList.forEach((item) {
      item.percent = ((item.evaPrice / sumEvaPrice) * 100);
    });
  }

  void _calcDividendPercent() {
    double sumDividendPrice = 0;
    _stockList.forEach((item) {
      sumDividendPrice += item.dividend;
    });

    _stockList.forEach((item) {
      item.totalDivPercent = ((item.dividend / sumDividendPrice) * 100);
    });
  }

  void addKakaoProfile({String profileImgUrl = '', String name, int kakaoId}) {
    _userData.profileImgUrl = profileImgUrl;
    _userData.name = name;
    _userData.kakaoId = kakaoId;
    _httpKakaoPost(kakaoId);
    notifyListeners();
  }

  Future<void> _httpStockPost(
      String ticker, double amount, double avgPrice) async {
    var json = jsonEncode({
      'id': _userData.tokenId,
      'ticker': ticker,
      'amount': amount,
      'avgPrice': avgPrice,
    });
    print('httpStockPost json: $json');

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
      print('response: ${response.statusCode}');
    } catch (e) {
      print(e);
    }
  }

  Future<MyStock> _getMyData(String ticker) async {
    final response =
        await http.get('http://13.125.225.138:5000/data/${_userData.tokenId}');
    print('getMyDataresponse: ${response.body}');
    var myData = json.decode(response.body);
    int index = myData.indexWhere((item) => item['ticker'] == ticker);
    var dF = myData[index];
    print(
        "wwjfowijeiofjwojefow: ${dF['Name']}, ${dF['DividendDate']}, ${dF['Price']}");
    return MyStock(
        ticker: dF['ticker'],
        name: dF['Name'],
        amount: dF['amount'],
        avg: dF['avgPrice'],
        evaPrice: dF['Price'] * dF['amount'],
        exDividends: dF['ExList'],
        nextDividend: dF['NextAmount'],
        dividend: dF['YearlyDividend'] * dF['amount'],
        divPercent: (dF['DividendYield'] ?? 0.0) * 100,
        closingPrice: dF['Price'],
        frequency: dF['Frequency'],
        dividendDate: dF['DividendDate'] ?? '',
        logoURL: dF['Logo']);
  }
}
