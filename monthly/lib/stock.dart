import 'package:flutter/material.dart';
import 'package:monthly/my_stock.dart';

class Stock with ChangeNotifier {
  List<MyStock> _stockList = List<MyStock>();
  List<double> _monthlyDividends = List.filled(12, 0.0);

  //getter
  List<MyStock> get stockList => _stockList;
  List<double> get monthlyDividends => _monthlyDividends;
  double get avgDividend {
    return _monthlyDividends.reduce((a, b) => a + b) / 12.0;
  }

  double get thisMonthDividend {
    int thisMonth = DateTime.now().month;
    return _monthlyDividends[thisMonth - 1];
  }

  Stock() {
    init();
  }

  void init() async {
    addStock(
        newStock: MyStock(
            ticker: "SBUX",
            name: "Starbucks",
            amount: 40.0,
            avg: 50000.0,
            color: Color(0xffF25B7F),
            frequency: "분기",
            evaPrice: 81532.1,
            dividend: 82231.5,
            percent: 40.0,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/starbucks.com"));
    addStock(
        newStock: MyStock(
            ticker: "005930",
            name: "삼성전자",
            amount: 30.0,
            avg: 50000.0,
            color: Color(0xff88B14B),
            frequency: "연",
            evaPrice: 52300.1,
            dividend: 45750.2,
            percent: 30.0,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/samsung.com"));
    addStock(
        newStock: MyStock(
            ticker: "AAPL",
            name: "Apple",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffF09797),
            frequency: "월",
            evaPrice: 3251500.1,
            dividend: 41250.2,
            percent: 15.0,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/apple.com"));
    addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            percent: 15.0,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
    addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
    addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
    addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
    addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
    addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
    addStock(
        newStock: MyStock(
            ticker: "T",
            name: "AT&T",
            amount: 15.0,
            avg: 50000.0,
            color: Color(0xffE8B447),
            frequency: "분기",
            evaPrice: 417320.1,
            dividend: 9250.2,
            exDividends: [
              ExDividend(datetime: DateTime.now(), price: 4600.0),
              ExDividend(
                  datetime: DateTime.parse("1969-07-20 20:18:04Z"),
                  price: 4500.0)
            ],
            logoURL: "https:\/\/logo.clearbit.com\/att.com"));
//    _calcMonthlyDividends();
//    _calcStockPercent();
  }

  void addStock({MyStock newStock}) {
    _stockList.add(newStock);
    _calcMonthlyDividends();
    _calcStockPercent();
    notifyListeners();
  }

  void deleteStock({String ticker}) {
    _stockList.removeWhere((item) => item.ticker == ticker);
    _calcMonthlyDividends();
    _calcStockPercent();
    notifyListeners();
  }

  void modifyStock({String ticker, double avg, double amount}) {
    int index = _stockList.indexWhere((item) => item.ticker == ticker);
    _stockList[index].amount = amount;
    _stockList[index].avg = avg;
    _calcMonthlyDividends();
    _calcStockPercent();
    notifyListeners();
  }

  void _calcMonthlyDividends() {
    int month;
    _stockList.forEach((item) {
      item.exDividends.forEach((element) {
        month = element.datetime.month;
        _monthlyDividends[month - 1] += element.price;
      });
    });
  }

  void _calcStockPercent() {
    double sumEvaPrice = 0;
    _stockList.forEach((item) {
      sumEvaPrice += item.evaPrice;
    });

    _stockList.forEach((item) {
      item.percent = (item.evaPrice / sumEvaPrice) * 100;
    });
  }
}
