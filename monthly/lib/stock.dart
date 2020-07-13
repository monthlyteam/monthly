import 'package:flutter/material.dart';
import 'package:monthly/my_stock.dart';

class Stock with ChangeNotifier {
  List<MyStock> _stockList;
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

  void init() async {}

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
    notifyListeners();
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
