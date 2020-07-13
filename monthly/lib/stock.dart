import 'package:flutter/material.dart';
import 'package:monthly/my_stock.dart';

class Stock with ChangeNotifier {
  List<MyStock> _stockList;
  List<double> _monthlyDividends;
  int _test = 7;

  //getter
  List<MyStock> get stockList => _stockList;
  List<double> get monthlyDividends => _monthlyDividends;
  int get test => _test;

  Stock() {
    init();
  }

  void init() {}

  void addStock({MyStock newStock}) {
    _stockList.add(newStock);
    notifyListeners();
  }

  void deleteStock({String ticker}) {
    _stockList.removeWhere((item) => item.ticker == ticker);
    notifyListeners();
  }

  void modifyStock({String ticker, double avg, double amount}) {
    int index = _stockList.indexWhere((item) => item.ticker == ticker);
    _stockList[index].amount = amount;
    _stockList[index].avg = avg;
    notifyListeners();
  }
}
