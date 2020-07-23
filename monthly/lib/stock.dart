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

  //getter
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
    addStock(ticker: 'QYLD');
    /* addStock(
        newStock: MyStock(
            ticker: "SBUX",
            name: "Starbucks",
            amount: 40.0,
            avg: 50000.0,
            color: Color(0xff538FE0),
            frequency: "분기",
            evaPrice: 81532.1,
            dividend: 82231.5,
            percent: 40.0,
            nextDividend: 0.42,
            exDividends: [
              ExDividend(
                  datetime: DateTime.parse("2020-05-07T00:00:00.000Z"),
                  price: 0.41),
              ExDividend(
                  datetime: DateTime.parse("2020-02-05T00:00:00.000Z"),
                  price: 0.41),
              ExDividend(
                  datetime: DateTime.parse("2019-11-12T00:00:00.000Z"),
                  price: 0.41),
              ExDividend(
                  datetime: DateTime.parse("2019-08-07T00:00:00.000Z"),
                  price: 0.36),
            ],
            logoURL: "https:\/\/logo.clearbit.com\/starbucks.com"));

    addStock(
        newStock: MyStock(
            ticker: "AAPL",
            name: "Apple",
            amount: 10.0,
            avg: 50000.0,
            color: Color(0xffE5396E),
            frequency: "분기",
            evaPrice: 401500.1,
            dividend: 41250.2,
            percent: 15.0,
            nextDividend: 0.82,
            exDividends: [
              ExDividend(
                  datetime: DateTime.parse("2020-05-08T00:00:00.000Z"),
                  price: 0.82),
              ExDividend(
                  datetime: DateTime.parse("2020-02-07T00:00:00.000Z"),
                  price: 0.77),
              ExDividend(
                  datetime: DateTime.parse("2019-11-07T00:00:00.000Z"),
                  price: 0.77),
              ExDividend(
                  datetime: DateTime.parse("2019-08-09T00:00:00.000Z"),
                  price: 0.7),
            ],
            logoURL: "https:\/\/logo.clearbit.com\/apple.com"));
    addStock(
        newStock: MyStock(
            ticker: "AA",
            name: "QYLDd",
            amount: 30.0,
            avg: 50000.0,
            color: Color(0xffE5396E),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            percent: 15.0,
            nextDividend: 0.52,
            exDividends: [
              ExDividend(
                  datetime: DateTime.parse("2020-07-09T00:00:00.000Z"),
                  price: 0.52),
              ExDividend(
                  datetime: DateTime.parse("2020-04-08T00:00:00.000Z"),
                  price: 0.52),
              ExDividend(
                  datetime: DateTime.parse("2020-01-09T00:00:00.000Z"),
                  price: 0.52),
              ExDividend(
                  datetime: DateTime.parse("2019-10-09T00:00:00.000Z"),
                  price: 0.51),
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
 */
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

  void addStock({String ticker}) async {
    await _httpStockPost(ticker, 10, 25);
    MyStock ms = await _getMyData(ticker);
    _stockList.add(ms);
    _calcMonthlyDividends();
    _calcStockPercent();
    _calcDividendPercent();
    _setLevel();
//    await _httpStockPost(newStock.ticker, newStock.avg, newStock.amount);

    notifyListeners();
  }

  void deleteStock({String ticker}) {
    _stockList.removeWhere((item) => item.ticker == ticker);
    _calcMonthlyDividends();
    _calcStockPercent();
    _calcDividendPercent();
    _httpStockPost(ticker, -1, -1);
    _setLevel();
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
    print('json: $json');

    try {
      var response = await http.post(
        'http://13.125.225.138:5000/update',
        headers: {"content-Type": "application/json"},
        body: json,
        encoding: Encoding.getByName("utf-8"),
      );
      print('response: ${response.statusCode}');
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

    print("sexxxxxxxxxxxxxx: ${dF['ExList']}");
    print("sexxxxxxxxxxxxxxx: ${dF['ExList'][0]}");
    print(
        "sexxxxxxxxxxxxxxxx: ${DateTime.parse(dF['ExList'][0]['index']).year}");

    return MyStock(
        ticker: dF['ticker'],
        name: dF['Name'],
        amount: dF['amount'],
        avg: dF['avgPrice'],
        color: Colors.blueGrey,
        evaPrice: dF['Price'] * dF['amount'],
        exDividends: dF['ExList'],
        nextDividend: dF['NextAmount'],
        dividend: dF['YearlyDividend'] * dF['amount'],
        divPercent: dF['DividendYield'] * 100,
        closingPrice: dF['Price'],
        frequency: dF['Frequency'],
        logoURL: dF['Logo']);
  }
}
