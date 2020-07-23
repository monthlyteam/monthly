import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:monthly/my_stock.dart';
import 'package:monthly/user_data.dart';

class Stock with ChangeNotifier {
  final double exrate = 1200;
  UserData _userData = UserData();
  List<MyStock> _stockList = List<MyStock>();
  List<double> _monthlyDividends = List.filled(12, 0.0);

  //getter
  List<MyStock> get stockList => _stockList;
  List<double> get monthlyDividends => _monthlyDividends;
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
    addStock(
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
    /*
    addStock(
        newStock: MyStock(
            ticker: "SPHD",
            name: "SPHD",
            amount: 30.0,
            avg: 50000.0,
            color: Color(0xff88B14B),
            frequency: "월",
            evaPrice: 52300.1,
            dividend: 45750.2,
            percent: 30.0,
            exDividends: [
              ExDividend(
                  datetime: DateTime.parse("2020-06-22T00:00:00.000Z"),
                  price: 0.153),
              ExDividend(
                  datetime: DateTime.parse("2020-05-18T00:00:00.000Z"),
                  price: 0.155),
              ExDividend(
                  datetime: DateTime.parse("2020-04-20T00:00:00.000Z"),
                  price: 0.156),
              ExDividend(
                  datetime: DateTime.parse("2020-03-23T00:00:00.000Z"),
                  price: 0.157),
              ExDividend(
                  datetime: DateTime.parse("2020-02-24T00:00:00.000Z"),
                  price: 0.158),
              ExDividend(
                  datetime: DateTime.parse("2020-01-21T00:00:00.000Z"),
                  price: 0.156),
              ExDividend(
                  datetime: DateTime.parse("2019-12-23T00:00:00.000Z"),
                  price: 0.155),
              ExDividend(
                  datetime: DateTime.parse("2019-11-18T00:00:00.000Z"),
                  price: 0.155),
              ExDividend(
                  datetime: DateTime.parse("2019-10-21T00:00:00.000Z"),
                  price: 0.152),
              ExDividend(
                  datetime: DateTime.parse("2019-09-23T00:00:00.000Z"),
                  price: 0.152),
              ExDividend(
                  datetime: DateTime.parse("2019-08-19T00:00:00.000Z"),
                  price: 0.153),
              ExDividend(
                  datetime: DateTime.parse("2019-07-22T00:00:00.000Z"),
                  price: 0.150),
            ],
            logoURL: "https:\/\/logo.clearbit.com\/samsung.com"));
     */
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
            ticker: "T",
            name: "AT&T",
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
    addStock(
        newStock: MyStock(
            ticker: "MSFT",
            name: "MicroSoft",
            amount: 20.0,
            avg: 50000.0,
            color: Color(0xff538FE0),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            nextDividend: 0.51,
            exDividends: [
              ExDividend(
                  datetime: DateTime.parse("2020-05-20T00:00:00.000Z"),
                  price: 0.51),
              ExDividend(
                  datetime: DateTime.parse("2020-02-19T00:00:00.000Z"),
                  price: 0.51),
              ExDividend(
                  datetime: DateTime.parse("2019-11-20T00:00:00.000Z"),
                  price: 0.51),
              ExDividend(
                  datetime: DateTime.parse("2019-08-14T00:00:00.000Z"),
                  price: 0.46),
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
  }

  void addStock({MyStock newStock}) {
    _stockList.add(newStock);
    _calcMonthlyDividends();
    _calcStockPercent();
    _httpPost(newStock.ticker, newStock.avg, newStock.amount);
    notifyListeners();
  }

  void deleteStock({String ticker}) {
    _stockList.removeWhere((item) => item.ticker == ticker);
    _calcMonthlyDividends();
    _calcStockPercent();
    _httpPost(ticker, -1, -1);
    notifyListeners();
  }

  void modifyStock({String ticker, double avg, double amount}) {
    int index = _stockList.indexWhere((item) => item.ticker == ticker);
    _stockList[index].amount = amount;
    _stockList[index].avg = avg;
    _calcMonthlyDividends();
    _calcStockPercent();
    _httpPost(ticker, amount, avg);
    notifyListeners();
  }

  void _calcMonthlyDividends() {
    int month;
    _stockList.forEach((item) {
      item.exDividends.forEach((element) {
        month = element.datetime.month;
        if (element.datetime.year == DateTime.now().year) {
          _monthlyDividends[month - 1] += element.price * item.amount * exrate;
        } else {
          _monthlyDividends[month - 1] +=
              item.nextDividend * item.amount * exrate;
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

  void _httpPost(String ticker, double amount, double avgPrice) async {
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
}
