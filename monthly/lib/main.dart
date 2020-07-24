import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'stock.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'my_stock.dart';
import 'package:flutter/services.dart';

Future<String> checkToken() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print('token:$token');
    if (token == null) {
      final response = await http.get('http://13.125.225.138:5000/token');
      print('response: ${response.body}');
      prefs.setString("token", response.body);
      token = response.body;
    }
    return token;
  } catch (e) {
    return '';
  }
}

Future<double> getDollarData() async {
  try {
    final response = await http.get('http://13.125.225.138:5000/dollar');
    var dollar = json.decode(response.body);
    return dollar['USD'].toDouble();
  } catch (e) {
    return 1200.0;
  }
}

Future<List<MyStock>> initStockData(String token, double dollar) async {
  try {
    final response = await http.get('http://13.125.225.138:5000/data/$token');
    var myData = json.decode(response.body);
    double exchange = 1;
    List<MyStock> stockList = [];
    myData.forEach((item) {
      if (item['ticker'].contains('.KS'))
        exchange = 1;
      else
        exchange = dollar;
      print('dividendmonth: ${item['DividendMonth']}');
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
          wonExchange: exchange));
    });
    return stockList;
  } catch (e) {
    exit(0);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  KakaoContext.clientId = "dfc5584eeb7d68ba3b1eac6eeb72db96";
  KakaoContext.javascriptClientId = "681b9f88d5034e80c2d669f839a5bac1";

  String token = await checkToken();
  double dollar = await getDollarData();
  List<MyStock> stockList = await initStockData(token, dollar);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => Stock(token, dollar, stockList)),
        ],
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('${context.watch<Stock>().thisMonthDividend}');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Monthly',
      theme: ThemeData(
        fontFamily: 'NanumGothic',
      ),
      home: Home(),
    );
  }
}
